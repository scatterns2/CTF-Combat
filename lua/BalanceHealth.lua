// ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =======		
//		
// lua\BalanceHealth.lua		
//		
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com)			
//		
// ========= For more information, visit us at http://www.unknownworlds.com =====================		




kTechPointDamageThreshold = 0 -- The hive/cc will only take HP damage if their armor fraction is below this.

// HEALTH AND ARMOR		
kMarineHealth = 160	kMarineArmor = 0	kMarinePointValue = 5
kScoutHealth = 160
kMedicHealth = 230
kEngineerHealth = 180
kAssaultHealth = 300

kJetpackHealth = 100	kJetpackArmor = 30	kJetpackPointValue = 10
kExosuitHealth = 100    kExosuitArmor = 320    kExosuitPointValue = 20

kLayMinesPointValue = 1
kGrenadeLauncherPointValue = 2
kShotgunPointValue = 5
kFlamethrowerPointValue = 7

kMinigunPointValue = 5
kRailgunPointValue = 5
		
kSkulkHealth = 150	kSkulkArmor = 0		kSkulkPointValue = 5    kSkulkHealthPerBioMass = 3
kGorgeHealth = 310	kGorgeArmor = 0	    kGorgePointValue = 7    kGorgeHealthPerBioMass = 2
kLerkHealth = 200	kLerkArmor = 0	    kLerkPointValue = 15    kLerkHealthPerBioMass = 2
kFadeHealth = 360	kFadeArmor = 0      kFadePointValue = 20    kFadeHealthPerBioMass = 5
kOnosHealth = 600	kOnosArmor = 300	kOnosPointValue = 30    kOnosHealtPerBioMass = 25

kMarineWeaponHealth = 400
		
kEggHealth = 350	kEggArmor = 0	kEggPointValue = 1
kMatureEggHealth = 400	kMatureEggArmor = 0

kBabblerHealth = 15	kBabblerArmor = 0	kBabblerPointValue = 0
kBabblerEggHealth = 300	kBabblerEggArmor = 0	kBabblerEggPointValue = 0
		
kArmorPerUpgradeLevel = 20
kExosuitArmorPerUpgradeLevel = 45
kArmorHealScalar = 1 // 0.75

kParasitePlayerPointValue = 1
kBuildPointValue = 5
kRecyclePaybackScalar = 0.75

kCarapaceHealReductionPerLevel = 0.0

kSkulkArmorFullyUpgradedAmount = 30
kGorgeArmorFullyUpgradedAmount = 100
kLerkArmorFullyUpgradedAmount = 60
kFadeArmorFullyUpgradedAmount = 120
kOnosArmorFullyUpgradedAmount = 650

kBalanceInfestationHurtPercentPerSecond = 2
kMinHurtPerSecond = 20

// used for structures
kStartHealthScalar = 0.3


kCommandStationHealth = 10000	kCommandStationArmor = 750
kMatureHiveHealth = 10000 kMatureHiveArmor = 750


kArmoryHealth = 1800	kArmoryArmor = 300	kArmoryPointValue = 100
kWeaponCacheHealth = 600	kWeaponCacheArmor = 150		kWeaponCachePointValue = 100
kAdvancedArmoryHealth = 3000	kAdvancedArmoryArmor = 500	kAdvancedArmoryPointValue = 100
kObservatoryHealth = 1000	kObservatoryArmor = 0	kObservatoryPointValue = 100
kPhaseGateHealth = 2500	kPhaseGateArmor = 0	kPhaseGatePointValue = 100
kRoboticsFactoryHealth = 2800	kRoboticsFactoryArmor = 600	kRoboticsFactoryPointValue = 10
kARCRoboticsFactoryHealth = 2800	kARCRoboticsFactoryArmor = 600	kARCRoboticsFactoryPointValue = 15
kPrototypeLabHealth = 3000    kPrototypeLabArmor = 500    kPrototypeLabPointValue = 20
kInfantryPortalHealth = 1525    kInfantryPortalArmor = 500    kInfantryPortalPointValue = 10
kArmsLabHealth = 1650    kArmsLabArmor = 500    kArmsLabPointValue = 15
kSentryBatteryHealth = 600	kSentryBatteryArmor = 200	kSentryBatteryPointValue = 2

		
kDrifterHealth = 300	kDrifterArmor = 20	kDrifterPointValue = 2
kMACHealth = 300	kMACArmor = 50	kMACPointValue = 2
kMineHealth = 100	kMineArmor = 0	kMinePointValue = 0
		
kExtractorHealth = 2400 kExtractorArmor = 1050 kExtractorPointValue = 15
kExtractorArmorAddAmount = 700 // not used

// (2500 = NS1)
kHarvesterHealth = 2000 kHarvesterArmor = 200 kHarvesterPointValue = 15
kMatureHarvesterHealth = 2300 kMatureHarvesterArmor = 320

kSentryHealth = 400	kSentryArmor = 150	kSentryPointValue = 30
kARCHealth = 2000	kARCArmor = 500	kARCPointValue = 5
kARCDeployedHealth = 2000	kARCDeployedArmor = 0
		
kCragHealth = 600	kCragArmor = 300	kCragPointValue = 100
kMatureCragHealth = 1000	kMatureCragArmor = 500	kMatureCragPointValue = 100
		
kWhipHealth = 1	kWhipArmor = 100	kWhipPointValue = 40
kMatureWhipHealth = 500	kMatureWhipArmor = 200	kMatureWhipPointValue = 40

kShadeHealth = 750	kShadeArmor = 0	kShadePointValue = 100
kMatureShadeHealth = 1500	kMatureShadeArmor = 0	kMatureShadePointValue = 100

kHydraHealth = 600	kHydraArmor = 0	kHydraPointValue = 20
kMatureHydraHealth = 600	kMatureHydraArmor = 0	kMatureHydraPointValue = 20

kClogHealth = 300  kClogArmor = 0 kClogPointValue = 5
kWebHealth = 50

kCystHealth = 70	kCystArmor = 0
kMatureCystHealth = 450    kMatureCystArmor = 0    kCystPointValue = 1

kBoneWallHealth = 100 kBoneWallArmor = 0    kBoneWallHealthPerBioMass = 100
kContaminationHealth = 1000 kContaminationArmor = 0    kContaminationPointValue = 1

kPowerPointHealth = 2000	kPowerPointArmor = 1000	kPowerPointPointValue = 25
kDoorHealth = 2000	kDoorArmor = 1000	kDoorPointValue = 0

kTunnelEntranceHealth = 1000    kTunnelEntranceArmor = 100    kTunnelEntrancePointValue = 100
kMatureTunnelEntranceHealth = 1250    kMatureTunnelEntranceArmor = 200


