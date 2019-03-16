#include "functions.au3"


InsertScope("M8541A (low mount)", "rhsusf_acc_premier_low", 3.90899)
InsertScope("M8541A + AN/PVS-27", "rhsusf_acc_premier_anpvs27", 5.25066)
InsertScope("Mk. 4 ER/T 6.5-20x M5", "rhsusf_acc_LEUPOLDMK4_2", 3.86377)
InsertScope("Mk. 4 ER/T 3.5-10x M3", "rhsusf_acc_LEUPOLDMK4", 2.62567)
InsertScope("S+B 3-12x50 PM II", "RKSL_optic_PMII_312", 4.22357)
InsertScope("S+B 5-25x56 PM II", "RKSL_optic_PMII_525", 4.22357)




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

InsertRifle("AI AWC-M (HLC)", "hlc_rifle_awcovert", 305, 203, 4) ;#TODO heightAboveBore is incorrect
AddMagazineWellToRifle("hlc_rifle_awcovert", "CBA_300WM_AICS")

InsertRifle("AI AWM (HLC)", "hlc_rifle_awmagnum", 660, 279, 4) ;#TODO heightAboveBore is incorrect
AddMagazineWellToRifle("hlc_rifle_awmagnum", "CBA_300WM_AICS")


InsertRifle("TAC50 (R3F)", "R3F_TAC50", 736.6, 381, 2.99563)
AddMagazineWellToRifle("R3F_TAC50", "R3F_TAC50")

Local $barrelLengths[1] = [736.6]
Local $muzzleVelocities[1] = [820]
Local $muzzleVelocityShifts[11] = [-18.91,-17.83,-15.21,-12.48,-9.34,-5.16,0,6.11,13.6,22.81,33.83]
InsertAmmoTypeSeperate("TAC50 (R3F)", "R3F_127x99_Ball3", 12.954, 1, 0.67, 41.9256, 58.674, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
AddAmmoToMagazineWell("R3F_TAC50", "R3F_127x99_Ball3")

InsertRifle("T-500 (RHS)", "rhs_weap_t5000", 698.5, 254, 2.12198)
AddMagazineWellToRifle("rhs_weap_t5000", "RHS_T5000")

Local $barrelLengths[3] = [508,660.4,711.2]
Local $muzzleVelocities[3] = [880,915,925]
Local $muzzleVelocityShifts[11] = [-26.55,-25.47,-22.85,-20.12,-16.98,-12.8,-7.64,-1.53,5.96,15.17,26.19]
InsertAmmoTypeSeperate("338 Ball (Vanilla)", "B_338_Ball", 8.585, 7, 0.322, 16.2, 39.573, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
AddAmmoToMagazineWell("RHS_T5000", "B_338_Ball")


; "rhsusf_20Rnd_762x51_SR25_m118_special_Mag","rhsusf_20Rnd_762x51_SR25_m993_Mag","rhsusf_20Rnd_762x51_SR25_m62_Mag"
Local $barrelLengths[4] = [406.4,508,609.6,660.4]
Local $muzzleVelocities[4] = [750,780,790,794]
Local $muzzleVelocityShifts[11] = [-26.55,-25.47,-22.85,-20.12,-16.98,-12.8,-7.64,-1.53,5.96,15.17,26.19]
InsertAmmoTypeSeperate("M118LR (ACE/RHS)", "rhs_ammo_762x51_M118_Special_Ball", 7.823, 7, 0.243, 11.34, 31.496, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
Local $barrelLengths[4] = [330.2,406.4,508,609.6]
Local $muzzleVelocities[4] = [875,910,930,945]
InsertAmmoTypeSeperate("M993 AP (ACE/RHS)", "rhs_ammo_762x51_M993_Ball", 7.823, 1, 0.359, 8.22946, 31.496, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
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

; HLC 300wm
; "hlc_5rnd_300WM_FMJ_AWM", "hlc_5rnd_300WM_mk248_AWM", "hlc_5rnd_300WM_BTSP_AWM", "hlc_5rnd_300WM_AP_AWM", "hlc_5rnd_300WM_SBT_AWM", "hlc_5rnd_300WM_T_AWM"

;Load Data - MEN S230430 FMJ
Local $barrelLengths[2] = [305, 660.4]
Local $muzzleVelocities[2] = [690, 990]
Local $muzzleVelocityShifts[11] = [-5.3, -5.1, -4.6, -4.2, -3.4, -2.6, -1.4, -0.3, 1.4, 3.0, 5.2]
InsertAmmoTypeSeperate(".300WM FMJ AWM (HLC)", "HLC_300WM_FMJ", 7.823, 7, 0.250, 13.0, 37.821, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
AddAmmoToMagazineWell("CBA_300WM_AICS", "HLC_300WM_FMJ")

InsertAmmoTypeSeperate(".300WM Tracer AWM (HLC)", "HLC_300WM_Tracer", 7.823, 7, 0.250, 13.0, 37.821, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
AddAmmoToMagazineWell("CBA_300WM_AICS", "HLC_300WM_Tracer")

Local $barrelLengths[2] = [305, 660]
Local $muzzleVelocities[2] = [670, 940]
InsertAmmoTypeSeperate(".300WM Soft-Point AWM (HLC)", "HLC_300WM_BTSP", 7.823, 7, 0.268, 12.31179, 35.1282, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
AddAmmoToMagazineWell("CBA_300WM_AICS", "HLC_300WM_BTSP")
;Yes this is the same even though this is supposed to be subsonic
InsertAmmoTypeSeperate(".300WM Subsonic AWM (HLC)", "HLC_300WM_S_BT", 7.823, 7, 0.268, 12.31179, 35.1282, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
AddAmmoToMagazineWell("CBA_300WM_AICS", "HLC_300WM_S_BT")

Local $barrelLengths[2] = [305, 660.4]
;MEN DM131 AP (Tungsten-Carbide penetrator in a solid aluminium slug)
Local $muzzleVelocities[2] = [614, 861]
InsertAmmoTypeSeperate(".300WM AP AWM (HLC)", "HLC_300WM_AP", 7.823, 7, 0.268, 12.8, 37.821, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
AddAmmoToMagazineWell("CBA_300WM_AICS", "HLC_300WM_AP")

;Mk248 Mod 1 OTM (220 Grain SMK Boat-Tailed Hollowpoint, as Spec'd by Black Hills)
Local $barrelLengths[3] = [508.0, 609.6, 660.4]
Local $muzzleVelocities[3] = [847, 867, 877]
InsertAmmoTypeSeperate("300WM Mk.248 Mod1 AWM (HLC)", "HLC_300WM_BTHP", 7.823, 7, 0.310, 14.256, 37.821, $barrelLengths, $muzzleVelocities, $muzzleVelocityShifts)
AddAmmoToMagazineWell("CBA_300WM_AICS", "HLC_300WM_BTHP")


;InsertAmmoTypeSeperate("", "", 7.823, , , , [], [], [])



GenerateRiflesSRL();

