#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <Array.au3>
#include "XML.au3"

Local $sSQliteDll = _SQLite_Startup()

If @error Then
    MsgBox($MB_SYSTEMMODAL, "SQLite Error", "SQLite3.dll Can't be Loaded!" & @CRLF & @CRLF & _
            "Not FOUND in @SystemDir, @WindowsDir, @ScriptDir, @WorkingDir, @LocalAppDataDir\AutoIt v3\SQLite")
    Exit -1
EndIf

_SQLite_Open ("rifleData.sqlite3")

Func InsertRifle($name, $classname, $barrelLength, $barrelTwist, $railHeightAboveBore)
   Local $existCheckResult
   _SQLite_QuerySingleRow ( -1, "SELECT COUNT(*) FROM main.rifles WHERE rifles.classname='"&$classname&"'", $existCheckResult)

   If ($existCheckResult[0] > 0) Then
	  ConsoleWriteError("Rifle '"&$classname&"' already exists, won't insert"&@CRLF)
	  Return
   EndIf

   _SQLite_Exec(-1, "INSERT INTO main.rifles('name', 'classname', 'ace_barrelLength', 'ace_barrelTwist', 'ace_RailHeightAboveBore') VALUES ('"&$name&"', '"&$classname&"',"&$barrelLength&","&$barrelTwist&","&$railHeightAboveBore&")")
EndFunc

Func InsertAmmoType($name, $classname, $caliber, $dragmodel, $bc, $bulletMass, $bulletLength, $barrelLengthMuzzleVel, $muzzleVelShifts)
   Local $existCheckResult
   _SQLite_QuerySingleRow ( -1, "SELECT COUNT(*) FROM ammoTypes WHERE ammoTypes.classname='"&$classname&"'", $existCheckResult)

   If ($existCheckResult[0] > 0) Then
	  ConsoleWriteError("AmmoType '"&$classname&"' already exists, won't insert"&@CRLF)
	  Return
   EndIf

   $query = "INSERT INTO main.ammoTypes('name', 'classname', 'ACE_caliber', 'ACE_dragModel', 'ACE_bulletMass', 'ACE_bulletLength', 'ACE_ballisticCoefficient')" & _
   " VALUES ('"&$name&"', '"&$classname&"',"&$caliber&","&$dragmodel&","&$bulletMass&","&$bulletLength&","&$bc&")"
   _SQLite_Exec(-1, $query)

   $ammoTypeID = _SQLite_LastInsertRowID()


    For $row=0 To UBound($barrelLengthMuzzleVel)-1
        $query =  "INSERT INTO main.ammoMuzzleVel('id', 'ACE_barrelLength', 'ACE_muzzleVelocity')" & _
            "   VALUES ('"&$ammoTypeID&"', '"& $barrelLengthMuzzleVel[$row][0]&"',"& $barrelLengthMuzzleVel[$row][1]&")"
        _SQLite_Exec(-1, $query)
    Next

   Local $temp = -15
   For $shift In $muzzleVelShifts
	  _SQLite_Exec(-1, "INSERT INTO main.ammoVelocityShift('id', 'temperature', 'ACE_ammoTempMuzzleVelocityShift') VALUES ('"&$ammoTypeID&"', '"&$temp&"',"&$shift&")")
	  $temp = $temp + 5
   Next

EndFunc

Func InsertAmmoTypeSeperate($name, $classname, $caliber, $dragmodel, $bc, $bulletMass, $bulletLength, $barrelLengths, $muzzleVelocities, $muzzleVelShifts)
   Local $aArray[0][2]

   For $i = 0 To UBound($barrelLengths)-1
	  Local $newEntry[1][2] = [[$barrelLengths[$i], $muzzleVelocities[$i]]]
	  _ArrayAdd($aArray, $newEntry, 0)
   Next

   InsertAmmoType($name, $classname, $caliber, $dragmodel, $bc, $bulletMass, $bulletLength, $aArray, $muzzleVelShifts)
EndFunc

Func InsertScope($name, $classname, $scopeHeightAboveRail)
   Local $existCheckResult
   _SQLite_QuerySingleRow(-1, "SELECT COUNT(*) FROM main.scopes WHERE scopes.classname='"&$classname&"'", $existCheckResult)

   If ($existCheckResult[0] > 0) Then
	  ConsoleWriteError("Scope '"&$classname&"' already exists, won't insert"&@CRLF)
	  Return
   EndIf

   _SQLite_Exec(-1, "INSERT INTO main.scopes('name', 'classname', 'ACE_ScopeHeightAboveRail') VALUES ('"&$name&"', '"&$classname&"',"&$scopeHeightAboveRail&")")
EndFunc

Func AddMagazineWellToRifle($rifleClassname, $magazineWellName)
   Local $existCheckResult
   $query = "SELECT Count(*) FROM rifleMagazineWells " & @CRLF & _
		 "INNER JOIN rifles ON rifleMagazineWells.rifle = rifles.id " & @CRLF & _
		 "INNER JOIN magazineWells ON rifleMagazineWells.magazineWell = magazineWells.id " & @CRLF & _
		 "WHERE " & @CRLF & _
		 "rifles.classname = '"&$rifleClassname&"' AND " & @CRLF & _
		 "magazineWells.classname = '"&$magazineWellName&"'"
   _SQLite_QuerySingleRow(-1, $query, $existCheckResult)

   If ($existCheckResult[0] > 0) Then
	  ConsoleWriteError("MagWell Connection '"&$rifleClassname&"'->'"&$magazineWellName&"' already exists, won't insert"&@CRLF)
	  Return
   EndIf

   ;Make sure magazine well exists, this query will probably fail but we don't care
   _SQLite_Exec(-1, "INSERT INTO main.magazineWells('classname') VALUES ('"&$magazineWellName&"')")

   $query = "INSERT INTO main.rifleMagazineWells('magazineWell', 'rifle') VALUES (" & @CRLF & _
	  "(SELECT magazineWells.id FROM magazineWells WHERE magazineWells.classname = '"&$magazineWellName&"')," & @CRLF & _
	  "(SELECT rifles.id FROM rifles WHERE rifles.classname = '"&$rifleClassname&"'))"
   _SQLite_Exec(-1, $query)

EndFunc

Func AddAmmoToMagazineWell($magazineWellName, $ammoType)
   Local $existCheckResult
   $query = "SELECT" & @CRLF & _
	  "Count(*)" & @CRLF & _
	  "FROM" & @CRLF & _
	  "ammoMagWells" & @CRLF & _
	  "INNER JOIN magazineWells ON ammoMagWells.magWell = magazineWells.id" & @CRLF & _
	  "INNER JOIN ammoTypes ON ammoMagWells.ammoType = ammoTypes.id" & @CRLF & _
	  "WHERE" & @CRLF & _
	  "ammoTypes.classname = '"&$ammoType&"' AND" & @CRLF & _
	  "magazineWells.classname = '"&$magazineWellName&"'"

   _SQLite_QuerySingleRow(-1, $query, $existCheckResult)

   If ($existCheckResult[0] > 0) Then
	  ConsoleWriteError("Ammmo-MagWell Connection '"&$magazineWellName&"'->'"&$ammoType&"' already exists, won't insert"&@CRLF)
	  Return
   EndIf

      ;Make sure magazine well exists, this query will probably fail but we don't care
   _SQLite_Exec(-1, "INSERT INTO main.magazineWells('classname') VALUES ('"&$magazineWellName&"')")

   $query = "INSERT INTO main.ammoMagWells('magWell', 'ammoType') VALUES (" & _
	  "(SELECT magazineWells.id FROM magazineWells WHERE magazineWells.classname = '"&$magazineWellName&"')," & _
	  "(SELECT ammoTypes.id FROM ammoTypes WHERE ammoTypes.classname = '"&$ammoType&"'))"

   _SQLite_Exec(-1, $query)
EndFunc


Func XMLAddRifleCartridge(ByRef $oXMLDoc,ByRef $cartridgeElement, $ammoType, $ace_barrelLength)

    $query = "SELECT name, classname, ACE_caliber, ACE_dragModel, ACE_bulletMass, ACE_bulletLength, ACE_ballisticCoefficient FROM ammoTypes" & @CRLF & _
    "WHERE" & @CRLF & _
    "ammoTypes.id = "&$ammoType

	Local $aRow
    _SQLite_QuerySingleRow(-1, $query, $aRow)

    $name = $aRow[0]
    $classname = $aRow[1]
    $ACE_caliber = $aRow[2]
    $ACE_dragModel = $aRow[3]
    $ACE_bulletMass = $aRow[4]
    $ACE_bulletLength = $aRow[5]
    $ACE_ballisticCoefficient = $aRow[6]

    Local $newNode = $oXMLDoc.createElement("CartridgeName")
    $newNode.text = $name
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("BulletWeight_gr")
    $newNode.text = String(Round($ACE_bulletMass * 15.43, 1))
    $cartridgeElement.appendChild($newNode)


    Local $bulletSpeedNode = $oXMLDoc.createElement("BulletSpeed")
    $bulletSpeedNode.text = 1
    $cartridgeElement.appendChild($bulletSpeedNode)

    Local $bulletTempNode = $oXMLDoc.createElement("BulletTemperature")
    $bulletTempNode.text = 1
    $cartridgeElement.appendChild($bulletTempNode)

    Local $newNode = $oXMLDoc.createElement("BulletBC")
    $newNode.text = String($ACE_ballisticCoefficient)
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("BulletBCSpeed")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)


    Local $newNode = $oXMLDoc.createElement("BulletBC2")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)
    Local $newNode = $oXMLDoc.createElement("BulletBC2Speed")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)
    Local $newNode = $oXMLDoc.createElement("BulletBC3")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)
    Local $newNode = $oXMLDoc.createElement("BulletBC3Speed")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)
    Local $newNode = $oXMLDoc.createElement("BulletBC4")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)
    Local $newNode = $oXMLDoc.createElement("BulletBC4Speed")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)
    Local $newNode = $oXMLDoc.createElement("BulletBC5")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)
    Local $newNode = $oXMLDoc.createElement("BulletBC5Speed")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)

    ;Local $newNode = $oXMLDoc.createElement("TempModifyer")
    ;$newNode.text = "0.4"
    ;$cartridgeElement.appendChild($newNode)


If ($ACE_dragModel = 7) Then
    Local $newNode = $oXMLDoc.createElement("DragFunctionName")
    $newNode.text = "G7"
    $cartridgeElement.appendChild($newNode)
    Local $newNode = $oXMLDoc.createElement("DragFunctionNumber")
    $newNode.text = 5
    $cartridgeElement.appendChild($newNode)
Else
    Local $newNode = $oXMLDoc.createElement("DragFunctionName")
    $newNode.text = "G1"
    $cartridgeElement.appendChild($newNode)
    Local $newNode = $oXMLDoc.createElement("DragFunctionNumber")
    $newNode.text = 1
    $cartridgeElement.appendChild($newNode)
EndIf

    Local $newNode = $oXMLDoc.createElement("DragFunctionCategory")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)

    ;Local $newNode = $oXMLDoc.createElement("StabilityFactor")
    ;$newNode.text = 0
    ;$cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("bullet_length_inch")
    $newNode.text = String(Round($ACE_bulletLength / 25.4,4))
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("bullet_diam_inch")
    $newNode.text = String(Round($ACE_caliber / 25.4,4))
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("ShiftVerticalMOA")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("ShiftHorizontalMOA")
    $newNode.text = 0
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("offset_units")
    $newNode.text = 1
    $cartridgeElement.appendChild($newNode)

    $query = "SELECT ammoVelocityShift.temperature, ammoMuzzleVel.ACE_muzzleVelocity + ammoVelocityShift.ACE_ammoTempMuzzleVelocityShift" & @CRLF & _
        "FROM ammoTypes" & @CRLF & _
        "INNER JOIN ammoVelocityShift ON ammoVelocityShift.id = ammoTypes.id" & @CRLF & _
        "INNER JOIN ammoMuzzleVel ON ammoMuzzleVel.id = ammoTypes.id" & @CRLF & _
        "WHERE" & @CRLF & _
        "ammoMuzzleVel.ACE_barrelLength = " & $ace_barrelLength  & @CRLF & _
        " AND ammoTypes.id = "&$ammoType&" LIMIT 5"

    Local $thermoNode = $oXMLDoc.createElement("TermoSensitivity") ;#TODO
	Local $hQuery
    _SQLite_Query(-1, $query, $hQuery) ; the query
    $speedset = false;
    While _SQLite_FetchData($hQuery, $aRow) = $SQLITE_OK
        Local $thermoRow = $oXMLDoc.createElement("TermoRow") ;#TODO

        If (Not $speedset) Then
            $bulletSpeedNode.text = String($aRow[1])
            $bulletTempNode.text = String($aRow[0])
            $speedset = true
        EndIf

        Local $newNode = $oXMLDoc.createElement("TS_Temperature")
        $newNode.text = String($aRow[0])
        $thermoRow.appendChild($newNode)

        Local $newNode = $oXMLDoc.createElement("TS_Speed")
        $newNode.text = String($aRow[1])
        $thermoRow.appendChild($newNode)

        $thermoNode.appendChild($thermoRow)
    WEnd
    $cartridgeElement.appendChild($thermoNode)

    Local $newNode = $oXMLDoc.createElement("ZeroTemperature")
    $newNode.text = 14
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("ZeroPowderTemperature")
    $newNode.text = 15
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("ZeroPressure")
    $newNode.text = 594
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("ZeroHumidity")
    $newNode.text =0
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("ZeroDensityAltitude")
    $newNode.text = 346
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("same_atm")
    $newNode.text = "true"
    $cartridgeElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("CartridgeNotes")
    $cartridgeElement.appendChild($newNode)
EndFunc

Func XMLAddRifleScopeCombi(ByRef $oXMLDoc,ByRef $rifleElement, $rifleID, $scopeID)

	Local $aRow
    _SQLite_QuerySingleRow(-1, "SELECT name, classname, ace_barrelLength, ace_barrelTwist, ace_RailHeightAboveBore FROM rifles WHERE rifles.id="&$rifleID, $aRow)

    $name = $aRow[0]
    $classname = $aRow[1]
    $ace_barrelLength = $aRow[2]
    $ace_barrelTwist = $aRow[3]
    $ace_RailHeightAboveBore = $aRow[4]

    _SQLite_QuerySingleRow(-1, "SELECT name, classname, ACE_ScopeHeightAboveRail FROM scopes WHERE scopes.id="&$scopeID, $aRow)
    $scopeName = $aRow[0]
    $ACE_ScopeHeightAboveRail = $aRow[2]

    Local $newNode = $oXMLDoc.createElement("RifleName")
    $newNode.text = $name &" ["&$scopeName&"]"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("ZeroDistance")
    $newNode.text = 100
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("ScopeHeight")
    $newNode.text = String($ace_RailHeightAboveBore + $ACE_ScopeHeightAboveRail)
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("ScopeClickVert") ;#TODO
    $newNode.text = String(0.1)
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("ScopeClickHor") ;#TODO
    $newNode.text = String(0.1)
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("Reticle") ;#TODO
    $newNode.text = 24
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("click_units") ;#TODO
    $newNode.text = 1
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("min_magnification") ;#TODO
    $newNode.text = 3
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("max_magnification") ;#TODO
    $newNode.text = 12
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("true_magnification") ;#TODO
    $newNode.text = 12
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("first_focal") ;#TODO
    $newNode.text = "false"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("TwistRate") ;#TODO
    $newNode.text = String(Abs($ace_barrelTwist / 25.4))
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("TwistLeft") ;#TODO
    If ($ace_barrelTwist > 0) Then
        $newNode.text = "false"
    Else
        $newNode.text = "true"
    EndIf
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_EndDistance") ;#TODO
    $newNode.text = 2200
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_StartDistance") ;#TODO
    $newNode.text = 100
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_show_speed") ;#TODO
    $newNode.text = "true"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_show_energy") ;#TODO
    $newNode.text = "true"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_show_time") ;#TODO
    $newNode.text = "true"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_show_path_cm") ;#TODO
    $newNode.text = "false"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_show_path_moa") ;#TODO
    $newNode.text = "false"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_show_path_td") ;#TODO
    $newNode.text = "true"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_show_path_click") ;#TODO
    $newNode.text = "false"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_show_wind_cm") ;#TODO
    $newNode.text = "false"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_show_wind_moa") ;#TODO
    $newNode.text = "false"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_show_wind_td") ;#TODO
    $newNode.text = "true"
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("m_show_wind_click") ;#TODO
    $newNode.text = "false"
    $rifleElement.appendChild($newNode)
    $query = "SELECT ammoTypes.id FROM rifleMagazineWells" & @CRLF & _
    "INNER JOIN magazineWells ON rifleMagazineWells.magazineWell = magazineWells.id" & @CRLF & _
    "INNER JOIN ammoMagWells ON ammoMagWells.magWell = magazineWells.id" & @CRLF & _
    "INNER JOIN ammoTypes ON ammoMagWells.ammoType = ammoTypes.id" & @CRLF & _
    "WHERE" & @CRLF & _
    "rifleMagazineWells.rifle = "&$rifleID

	Local $hQuery
    _SQLite_Query(-1, $query, $hQuery) ; the query
    While _SQLite_FetchData($hQuery, $aRow) = $SQLITE_OK
        Local $newNode = $oXMLDoc.createElement("Cartridge") ;#TODO
        $rifleElement.appendChild($newNode)
        XMLAddRifleCartridge($oXMLDoc,$newNode, $aRow[0], $ace_barrelLength)
    WEnd

    Local $newNode = $oXMLDoc.createElement("CurrentCartridge") ;#TODO
    $newNode.text = 0
    $rifleElement.appendChild($newNode)

    Local $newNode = $oXMLDoc.createElement("RifleNotes") ;#TODO
    $rifleElement.appendChild($newNode)

EndFunc


Func XMLAddRifle(ByRef $oXMLDoc, ByRef $rifleElement, $rifleID)

    Local $hQuery
	Local $aRow
    _SQLite_Query(-1, "SELECT scopes.id FROM scopes", $hQuery) ; the query
    While _SQLite_FetchData($hQuery, $aRow) = $SQLITE_OK
        XMLAddRifleScopeCombi($oXMLDoc,$rifleElement, $rifleID, $aRow[0])
    WEnd



EndFunc


Func GenerateRiflesSRL()
    Local $oXMLDoc = _XML_CreateDOMDocument(Default)


    $oXMLDoc.appendChild($oXMLDoc.createProcessingInstruction("xml", "version=""1.0"" encoding=""UTF-8"""))

    Local $StrelokNode = $oXMLDoc.createElement("StrelokPro")
    $oXMLDoc.appendChild($StrelokNode)

    Local $metricUnits = $oXMLDoc.createElement("Metric_units_on")
    $metricUnits.text = "true"
    $StrelokNode.appendChild($metricUnits)

    Local $metricUnits = $oXMLDoc.createElement("CurrentRifle")
    $metricUnits.text = 0
    $StrelokNode.appendChild($metricUnits)


    Local $hQuery
    Local $aRow
    _SQLite_Query(-1, "SELECT rifles.id FROM rifles", $hQuery) ; the query
    While _SQLite_FetchData($hQuery, $aRow) = $SQLITE_OK
        Local $rifleNode = $oXMLDoc.createElement("Rifle")
        XMLAddRifle($oXMLDoc, $rifleNode, $aRow[0])
        $StrelokNode.appendChild($rifleNode)
    WEnd
    FileDelete("rifles.srl")

    
    FileWrite("rifles.srl", _XML_Tidy($oXMLDoc))

    ;_XML_SaveToFile($oXMLDoc, "rifles.srl")
EndFunc



InsertScope("M8541 (low mount)", "rhsusf_acc_M8541_low", 2.9789)

InsertRifle("M2010 ESR (RHS)", "rhs_weap_XM2010", 609.6, 254, 3.1028)
AddMagazineWellToRifle("rhs_weap_XM2010", "CBA_762x51")
AddMagazineWellToRifle("rhs_weap_XM2010", "CBA_300WM_AICS")

InsertRifle("Mk 11 Mod 0 (RHS)", "rhs_weap_sr25", 609.6, 285.75, 3.13162)
InsertRifle("Mk 11 Mod 0 (EC) (RHS)", "rhs_weap_sr25_ec", 508, 285.75, 3.13689)
AddMagazineWellToRifle("rhs_weap_sr25", "CBA_762x51")
AddMagazineWellToRifle("rhs_weap_sr25_ec", "CBA_762x51")

InsertRifle("M40A5 (RHS)", "rhs_weap_m40a5", 635, 304.8, 2.46368)
AddMagazineWellToRifle("rhs_weap_m40a5", "CBA_762x51")

InsertRifle("M24 SWS (RHS)", "rhs_weap_m24sws", 609.6, 285.75, 2.41891)
AddMagazineWellToRifle("rhs_weap_m24sws", "CBA_762x51")

InsertRifle("M82A1 (RHS)", "rhs_weap_m82a1", 736.6, 381, 4.18639)
AddMagazineWellToRifle("rhs_weap_m82a1", "CBA_50BMG_M107")

InsertRifle("M107 (RHS)", "rhs_weap_M107", 736.6, 381, 4.18639)
AddMagazineWellToRifle("rhs_weap_M107", "CBA_50BMG_M107")


; "rhsusf_20Rnd_762x51_SR25_m118_special_Mag","rhsusf_20Rnd_762x51_SR25_m993_Mag","rhsusf_20Rnd_762x51_SR25_m62_Mag"
Local $barrelLengths[4] = [406.4,508,609.6,660.4]
Local $muzzleVelocities[4] = [750,780,790,794]
Local $muzzleVelocityShifts[11] = [-26.55,-25.47,-22.85,-20.12,-16.98,-12.8,-7.64,-1.53,5.96,15.17,26.19]
InsertAmmoTypeSeperate("M118LR (RHS)", "rhs_ammo_762x51_M118_Special_Ball", 7.823, 7, 0.243, 11.34, 31.496, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
Local $barrelLengths[4] = [330.2,406.4,508,609.6]
Local $muzzleVelocities[4] = [875,910,930,945]
InsertAmmoTypeSeperate("M993 (RHS)", "rhs_ammo_762x51_M993_Ball", 7.823, 1, 0.359, 8.22946, 31.496, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
Local $barrelLengths[5] = [254,406.4,508,609.6,660.4]
Local $muzzleVelocities[5] = [700,800,820,833,845]
InsertAmmoTypeSeperate("M62 Tracer (RHS)", "rhs_ammo_762x51_M62_tracer", 7.823, 7, 0.2, 9.4608, 28.956, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
InsertAmmoTypeSeperate("M80 (RHS)", "rhs_ammo_762x51_M80", 7.823, 7, 0.2, 9.4608, 28.956, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)

AddAmmoToMagazineWell("CBA_762x51", "rhs_ammo_762x51_M118_Special_Ball")
AddAmmoToMagazineWell("CBA_762x51", "rhs_ammo_762x51_M993_Ball")
AddAmmoToMagazineWell("CBA_762x51", "rhs_ammo_762x51_M62_tracer")
AddAmmoToMagazineWell("CBA_762x51", "rhs_ammo_762x51_M80")

; "rhsusf_5Rnd_300winmag_xm2010"
Local $barrelLengths[3] = [508,609.6,660.4]
Local $muzzleVelocities[3] = [847,867,877]
Local $muzzleVelocityShifts[11] = [-5.3,-5.1,-4.6,-4.2,-3.4,-2.6,-1.4,-0.3,1.4,3,5.2]
InsertAmmoTypeSeperate(".300WM Mk248 MOD 1 (RHS)", "rhsusf_B_300winmag", 7.823, 7, 0.31, 14.256, 37.821, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)

AddAmmoToMagazineWell("CBA_300WM_AICS", "rhsusf_B_300winmag");


; "ACE_10Rnd_762x51_Mk316_Mod_0_Mag"
Local $barrelLengths[4] = [406.4,508,609.6,660.4]
Local $muzzleVelocities[4] = [775,790,805,810]
Local $muzzleVelocityShifts[11] = [-5.3,-5.1,-4.6,-4.2,-3.4,-2.6,-1.4,-0.3,1.4,3,5.2]
InsertAmmoTypeSeperate("Mk316 Mod 0 (ACE)", "ACE_762x51_Ball_Mk316_Mod_0", 7.823, 7, 0.243, 11.34, 31.496, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
; "ACE_20Rnd_762x51_Mk319_Mod_0_Mag"
Local $barrelLengths[3] = [330.2,406.4,508]
Local $muzzleVelocities[3] = [838,892,910]
Local $muzzleVelocityShifts[11] = [-2.655,-2.547,-2.285,-2.012,-1.698,-1.28,-0.764,-0.153,0.596,1.517,2.619]
InsertAmmoTypeSeperate("Mk319 Mod 0 (ACE)", "ACE_762x51_Ball_Mk319_Mod_0", 7.823, 1, 0.377, 8.424, 31.496, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
; "ACE_20Rnd_762x51_Mag_SD"
Local $muzzleVelocities[4] = [305,325,335,340]
Local $muzzleVelocityShifts[11] = [-2.655,-2.547,-2.285,-2.012,-1.698,-1.28,-0.764,-0.153,0.596,1.517,2.619]
InsertAmmoTypeSeperate("7.62mm SD (ACE)", "ACE_762x51_Ball_Subsonic", 7.823, 7, 0.235, 12.96, 34.036, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)

AddAmmoToMagazineWell("CBA_762x51", "ACE_762x51_Ball_Mk316_Mod_0")
AddAmmoToMagazineWell("CBA_762x51", "ACE_762x51_Ball_Mk319_Mod_0")
AddAmmoToMagazineWell("CBA_762x51", "ACE_762x51_Ball_Subsonic")


; RHS 50BMG
Local $barrelLengths[1] = [736.6]
Local $muzzleVelocities[1] = [900]
Local $muzzleVelocityShifts[11] = [-26.55,-25.47,-22.85,-20.12,-16.98,-12.8,-7.64,-1.53,5.96,15.17,26.19]
InsertAmmoTypeSeperate("M33 Ball (RHS)", "rhsusf_ammo_127x99_M33_Ball", 12.954, 1, 0.67, 41.9256, 58.674, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
InsertAmmoTypeSeperate("Mk 211 HEIAP (RHS)", "rhsusf_ammo_127x99_mk211", 12.954, 1, 0.67, 41.9904, 58.674, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)

AddAmmoToMagazineWell("CBA_50BMG_M107", "rhsusf_ammo_127x99_M33_Ball");
AddAmmoToMagazineWell("CBA_50BMG_M107", "rhsusf_ammo_127x99_mk211");



;InsertAmmoTypeSeperate("", "", 7.823, , , , [], [], [])



GenerateRiflesSRL();

