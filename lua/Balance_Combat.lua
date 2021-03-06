//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Balance.lua

// Game rules
kInitialTimeLeft = 1500
-- Use 0 for no limit
kOvertimeLimit = 0
kOverTimeSpeed = 1.1
kCombatAssistXPProportion = 0.3
kCombatAssistXPRange = 20
kCombatXPJoinProportion = 0.4
kCombatXPRebalanceEnabled = true
kCombatXPRebalanceInterval = 150
kCombatXPDeathBonusProportion = 0

// What proportion of people should get free XP.
kCombatXPRebalanceThreshold = 0.3
// Delay suicides by this long...
kSuicideDelay = 5

// Capture Point
kCapturePointContinuousXpPerTick = 1
kCapturePointContinuousInterval = 2
kCapturePointXp = 200

kCommandStationHealSpeed = .75
kHiveHealSpeed = .75

// Bots do reduced damage
kBotDamageScalar = 0.75

//adds .5 m/s per level
kCelerityAddSpeed = .5

// Range for evolving to Onos/Exo from the Hive/CommandStation
kTechRange = 25.0

// Range for buying weapons near armories 
kCombatArmoryRange = 7.0

// Spawning logic
kRespawnTimer = 14
kTicksPerSpawn = 3
kGameTimeSpawnMultiplier = 0 -- 1200/10 = 10 secs increase every 20 minutes
kSpawnTimePerLevel = 1
kSpawnMaxRetries = 100
kSpawnMinDistance = 4
kSpawnMaxDistance = 70
kSpawnMaxVertical = 20
kSpawnProtectDelay = 0.05
kSpawnProtectTime = 2.5
kDontSpawnNearEnemyRange = 15
kNanoShieldDamageReductionDamage = 0.1
kDamageReductionPerDeath = 0.10

kSpawnLifeformPenalties = {}
kSpawnLifeformPenalties["Marine"] = 0
kSpawnLifeformPenalties["Assault"] = 0
kSpawnLifeformPenalties["Scout"] = 0
kSpawnLifeformPenalties["Medic"] = 0
kSpawnLifeformPenalties["Engineer"] = 0
kSpawnLifeformPenalties["DevouredPlayer"] = 0
kSpawnLifeformPenalties["JetpackMarine"] = 0
kSpawnLifeformPenalties["Exo"] = 5

kSpawnLifeformPenalties["Skulk"] = 0
kSpawnLifeformPenalties["Gorge"] = 0
kSpawnLifeformPenalties["Lerk"] = 0
kSpawnLifeformPenalties["Fade"] = 0
kSpawnLifeformPenalties["Onos"] = 5


// No eggs
kAlienEggsPerHive = 0

// Alien vision should be free
kAlienVisionCost = 0
kAlienVisionEnergyRegenMod = 1

// Tweaks for weapons and upgrades
// Camouflage
kCamouflageVelocity = 4
kCamouflageTime = 2
kCamouflageUncloakFactor = 2 / 3
kAdrenalineAbilityMaxEnergy = 110

-- CTF Mode Specific
kPickUpFlagScore = 50
kReturnFlagScore = 100
kCaptureFlagScore = 300

kCaptureWinTotal = 5


/* Healing/Welding */
// Gorge Healspray heals more (and makes a bit more damage)
kHealsprayDamage = 7.5
// Crag healing rate
kCragHealPercentage = 0.15
// Conversely, reduce the welder's effectiveness from its original value of 150.
kStructureWeldRate = 90
// The rate at which players heal the hive/cc should be multiplied by this ratio.
kHiveCCHealRate = 1
// The rate at which players gain XP for healing... relative to damage dealt.
kHealXpRate = .10
kPlayerHealMultiplier = 10 --you gain 10x as much experience for the same heal amount on a player as you do on a structure
kStructureHealSprayMultiplier = 51

// HEALTH OVERRIDES
kClogHealth = 500  kClogArmor = 0 kClogPointValue = 5
kWebHealth = 50

// ALIEN DAMAGE VALUES
kBiteDamage = 70
kBiteDamageType = kDamageType.Normal
kBiteEnergyCost = 4

kLeapEnergyCost = 33

kBileBombDamage = 50 // per second
kBileBombDamageType = kDamageType.Structural
kBileBombEnergyCost = 26
kBileBombDuration = 1.5
kBileBombSplashRadius = 4.8

kXenocideDamage = 100
kXenocideDamageType = kDamageType.Normal
kXenocideRange = 10

kLerkBiteDamage = 50
kBitePoisonDamage = 10 // per second
kPoisonBiteDuration = 5
kLerkBiteEnergyCost = 5
kLerkBiteDamageType = kDamageType.Normal

kUmbraEnergyCost = 27
kUmbraDuration = 5
kUmbraRadius = 5
kLerkFlapEnergyCost = 5

kSpikeMaxDamage = 16
kSpikeMinDamage = 13
kSpikeDamageType = kDamageType.Normal
kSpikeEnergyCost = 4
kSpikeMinDamageRange = 20
kSpikeMaxDamageRange = 5
kSpikesRange = 100
kSpikesPerShot = 1

//Ranged Spores
kSporesDustDamagePerSecond = 50
kSporesDustFireDelay = 1.5			// increased from 0.36.
kSporesDustEnergyCost = 30			// increased from 8.
kSporesDustCloudRadius = 4			// increased from 2.5.
kSporesDustCloudLifetime = 3		// decreased from 8.
kSporesMaxCloudRange = 20			// added ranged spores.
kSporesTravelSpeed = 30				// ranged spores cloud speed.

kAcidicVengeanceDPS = 25

// reduce ink amount a bit
kShadeInkDisorientRadius = 9

// Babbler Bomb
kBabblersPerBomb = 4
kTimeBetweenBabblerBombShots = 3
kBabblerLifetime = 10
kBabblerDamage = 15

//Fade Swipe and Stab
kSwipeDamageType = kDamageType.Normal
kSwipeDamage = 75
kSwipeEnergyCost = 5

kStabDamage = 200
kStabDamageType = kDamageType.Normal
kStabEnergyCost = 20

kStartBlinkEnergyCost = 16
kBlinkEnergyCost = 32

kVoidShieldEnergyCost = 15

// Acid Rocket
kAcidRocketVelocity = 40
kAcidRocketEnergyCost = 30
kAcidRocketFireDelay = 0
kAcidRocketBombDamageType = kDamageType.Normal
kAcidRocketBombDuration = 1
kAcidRocketBombDamage = 70
kAcidRocketBombRadius = 0.2
kAcidRocketBombSplashRadius = 4
kAcidRocketBombDotIntervall = 0.4

// Onos Gore
kGoreDamage = 100
kGoreDamageType = kDamageType.Normal
kGoreEnergyCost = 5

//Stomp
kStompEnergyCost = 30
kStompDamageType = kDamageType.Normal
kStompDamage = 30
kStompRange = 10
kDisruptMarineTime = 1
kDisruptMarineTimeout = 4

// Hydras
kHydraJetpackFuelDamage = 0.1 // from 0 to 1
kHydraFireRate = 0.25
kHydraHealth = 600 // Original value 350
kHydraArmor = 0 // Original value 10

// MARINE DAMAGE VALUES
kLmgDamage = 10
kLmgDamageType = kDamageType.Normal
kLmgClipSize = 40

// MARINE DAMAGE VALUES
kRifleDamage = 30 //11
kRifleDamageType = kDamageType.Normal
kRifleClipSize = 21
kRifleMeleeDamage = 40

// 10 bullets per second
kPistolRateOfFire = 0.1
kPistolMinDamage = 15
kPistolMaxDamage = 20
kPistolMinDamageRange = 30
kPistolMaxDamageRange = 10
kPistolDamageType = kDamageType.Normal
kPistolClipSize = 10
// not used yet
kPistolMinFireDelay = 0.1

// 10 bullets per second
kRevolverRateOfFire = 0.1
kRevolverDamage = 38
kRevolverDamageType = kDamageType.Normal
kRevolverClipSize = 6
// not used yet
kRevolverMinFireDelay = 0.1
kRevolverWeight = 0.06

kPistolAltDamage = 40

kWelderDamagePerSecond = 30
kWelderDamageType = kDamageType.Flame
SetCachedTechData(kTechId.Welder, kTechDataDamageType, kWelderDamageType)
kWelderFireDelay = 0.2

kAxeDamage = 30
kAxeDamageType = kDamageType.Structural
SetCachedTechData(kTechId.Axe, kTechDataDamageType, kAxeDamageType)

kKatanaRange = 1.6
kKatanaDamage = 70
kKatanaDamageType = kDamageType.Normal
//SetCachedTechData(kTechId.Katana, kTechDataDamageType, kKatanaDamageType)

kPulseGrenadeDamageRadius = 5
kPulseGrenadeEnergyDamageRadius = 5
kPulseGrenadeDamage = 50
kPulseGrenadeEnergyDamagePercent = 1
kPulseGrenadeDamageType = kDamageType.Normal
kElectrifiedAttackSpeed = 0.5
kElectrifiedDuration = 4

kClusterGrenadeDamageRadius = 6
kClusterGrenadeDamage = 40
kClusterFragmentDamageRadius = 5
kClusterFragmentDamage = 60
kClusterGrenadeDamageType = kDamageType.Normal

kNerveGasDamagePerSecond = 20
kNerveGasDamageType = kDamageType.Gas

kGrenadeLauncherGrenadeDamage = 100
kGrenadeLauncherGrenadeDamageType = kDamageType.Heavy
kGrenadeLauncherClipSize = 4
kGrenadeLauncherGrenadeDamageRadius = 4
kGrenadeLifetime = 2

kShotgunDamage = 9
kShotgunClipSize = 6
kShotgunBulletsPerShot = 17
kShotgunRange = 40
kShotgunFireRate = 0.8

kNadeLauncherClipSize = 4

kFlamethrowerDamage = 12
kFlamethrowerClipSize = 30
kFlamethrowerRange = 8.5
kBurnDamagePerSecond = 12
kFlamePercentDamage = 2
kFlameDotUpgradeMultiplier = 2
kBurnDamagePerStackPerSecond = 3
kFlamethrowerMaxStacks = 20
kFlamethrowerBurnDuration = 3
kFlamethrowerStackRate = 0.4
kFlameRadius = 1.8
kFlameDamageStackWeight = 0.5

kMinigunDamage = 20
kCannonDamage = 40

kClawDamage = 30
kClawDamageType = kDamageType.Structural

kRailgunDamage = 40
kRailgunChargeDamage = 80
kRailgunDamageType = kDamageType.Puncture

kNumMines = 1
kMineDamage = 150
kMineDetonateRange = 7

kKnifeWeight = 0.05
kKnifeDamage = 30
kKnifeRange = 1.2 // Axe range is 1
kKnifeDamageType = kDamageType.Structural
kKnifeCost = 10

kDevourPunchDamage = 100

// number of handgrenades
kMaxHandGrenades = 1

kJetpackUpgradeModifier = 1.2

// Sentries
kSentryAttackBaseROF = .15
kSentryAttackRandROF = 0.0
kSentryAttackBulletsPerSalvo = 1
kConfusedSentryBaseROF = 0.6
kSentryDamage = 10

// EMP energy drain
kEMPBlastEnergyDamage = 75

/* HEALTH */
// Power points
kPowerPointHealth = 700	
kPowerPointArmor = 500	
kPowerPointPointValue = 0

// Primary Structures
kArmoryHealth = 3500
kCommandStationHealth = 6000

/* COSTS */
// Building
kNumSentriesPerPlayer = 1
kSentryCost = 0
kSentryBuildTime = 2
kPhaseGateCost = 0
kPhaseGateBuildTime = 6
kNumPhasegatesPerPlayer = 1
kArmoryCost = 0
kArmoryBuildTime = 5
kNumArmoriesPerPlayer = 1
kObservatoryCost = 0
kObservatoryBuildTime = 7
kNumObservatoriesPerPlayer = 1
kNumMinesPerPlayer = 3
kMaxBabblersPerPlayer = 12

// Minimum distance from any entities when building
kMarineBuildRadius = 1.5 

// Resupply
kResupplyInterval = 7
kResupplyHealth = 50

kNanoShieldDamageReductionDamage = 0.5

// Rate at which players gain XP for healing other players...
kPlayerHealXpRate = 0

// XP for utility structures
kPhaseGateUseXp = 5
kTunnelUseXp = 10
kWeaponCacheUseXp = 1

// Gorge abilities are free.
kHydraCost = 0
kGorgeTunnelCost = 0
kBabblerCost = 0
kWebBuildCost = 0
kWhipCost = 0

// Make these less "spammy"
kEMPTimer = 30
kInkTimer = 30

// Point Values
kCommandStationPointValue = 250
kArmoryPointValue = 150
kHivePointValue = 400