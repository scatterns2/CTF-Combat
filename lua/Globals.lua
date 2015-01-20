// ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Globals.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Utility.lua")
Script.Load("lua/GUIAssets.lua")

kDefaultPlayerSkill = 1500
kMaxPlayerSkill = 3000
kMaxPlayerLevel = 300

kSuicideDelay = 6

kDecalMaxLifetime = 60

// All the layouts are based around this screen height.
kBaseScreenHeight = 1080

// Team types - corresponds with teamNumber in editor_setup.xml
kNeutralTeamType = 0
kMarineTeamType = 1
kAlienTeamType = 2
kRandomTeamType = 3

// after 5 minutes players are allowed to give up a round
kMinTimeBeforeConcede = 10 * 60
kPercentNeededForVoteConcede = 0.75

// Team colors
kMarineFontName = Fonts.kAgencyFB_Large
kMarineFontColor = Color(0.756, 0.952, 0.988, 1)

kAlienFontName = Fonts.kAgencyFB_Large
kAlienFontColor = Color(0.901, 0.623, 0.215, 1)

kNeutralFontName = Fonts.kAgencyFB_Large
kNeutralFontColor = Color(0.7, 0.7, 0.7, 1)

kSteamFriendColor = Color(1, 1, 1, 1)

// Move hit effect slightly off surface we hit so particles don't penetrate. In meters.
kHitEffectOffset = 0.13
// max distance of blood from impact point to nearby geometry
kBloodDistance = 3.5

kCommanderPingDuration = 15

kCommanderColor = 0xFFFF00
kCommanderColorFloat = Color(1,1,0,1)
kMarineTeamColor = 0x4DB1FF
kMarineTeamColorFloat = Color(0.302, 0.859, 1)
kAlienTeamColor = 0xFFCA3A
kAlienTeamColorFloat = Color(1, 0.792, 0.227)
kNeutralTeamColor = 0xEEEEEE
kChatPrefixTextColor = 0xFFFFFF
kChatTextColor = { [kNeutralTeamType] = kNeutralFontColor,
                   [kMarineTeamType] = kMarineFontColor,
                   [kAlienTeamType] = kAlienFontColor }
kNewPlayerColor = 0x00DC00
kNewPlayerColorFloat = Color(0, 0.862, 0, 1)
kChatTypeTextColor = 0xDD4444
kFriendlyColor = 0xFFFFFF
kNeutralColor = 0xAAAAFF
kEnemyColor = 0xFF0000
kParasitedTextColor = 0xFFEB7F

kParasiteColor = Color(1, 1, 0, 1)
kPoisonedColor = Color(0, 1, 0, 1)

kCountDownLength = 6

// Team numbers and indices
kTeamInvalid = -1
kTeamReadyRoom = 0
kTeam1Index = 1
kTeam2Index = 2
kSpectatorIndex = 3

// Marines vs. Aliens
kTeam1Type = kMarineTeamType
kTeam2Type = kAlienTeamType

// Used for playing team and scoreboard
kTeam1Name = "Frontiersmen"
kTeam2Name = "Kharaa"
kSpectatorTeamName = "Ready room"
kDefaultPlayerName = "NSPlayer"

kDefaultWaypointGroup = "GroundWaypoints"
kAirWaypointsGroup = "AirWaypoints"

kMaxResources = 200

// Max number of entities allowed in radius. Don't allow creating any more entities if this number is rearched.
// Don't include players in count.
kMaxEntitiesInRadius = 25
kMaxEntityRadius = 15

kWorldMessageLifeTime = 1.0
kCommanderErrorMessageLifeTime = 2.0
kWorldMessageResourceOffset = Vector(0, 2.5, 0)
kResourceMessageRange = 35
kWorldDamageNumberAnimationSpeed = 220
// Updating messages with new numbers shouldn't reset animation - keep it big and faded-in intead of growing
kWorldDamageRepeatAnimationScalar = .1

// Max player name
kMaxNameLength = 20
kMaxScore = 25000
kMaxKills = 254
kMaxDeaths = 254
kMaxPing = 999

kMaxChatLength = 120

kMaxHotkeyGroups = 9

// Surface list. Add more materials here to precache ricochets, bashes, footsteps, etc
// Used with PrecacheMultipleAssets
kSurfaceList = { "door", "electronic", "metal", "organic", "rock", "thin_metal", "membrane", "armor", "flesh", "flame", "infestation", "glass" }

// a longer surface list, for hiteffects only (used by hiteffects network message, don't remove any values)
kHitEffectSurface = enum( { "metal", "door", "electronic", "organic", "rock", "thin_metal", "membrane", "armor", "flesh", "flame", "infestation", "glass", "ethereal", "flame", "hallucination", "umbra", "nanoshield" } )
kHitEffectRelevancyDistance = 40
kHitEffectMaxPosition = 1638 // used for precision in hiteffect message
kTracerSpeed = 115
kMaxHitEffectsPerSecond = 25

kMainMenuFlash = "ui/main_menu.swf"

kPlayerStatus = enum( { "Hidden", "Dead", "Evolving", "Embryo", "Commander", "Exo", "GrenadeLauncher", "Rifle", "LMG", "Shotgun", "Flamethrower", "Cannon", "Void", "Spectator", "Skulk", "Gorge", "Fade", "Lerk", "Onos", "SkulkEgg", "GorgeEgg", "FadeEgg", "LerkEgg", "OnosEgg","Medic","Assault","Scout","Engineer" } )
kPlayerCommunicationStatus = enum( {'None', 'Voice', 'Typing', 'Menu'} )
kSpectatorMode = enum( { 'FreeLook', 'Overhead', 'Following', 'FirstPerson' } )

kMaxAlienAbilities = 3

kNoWeaponSlot = 0
// Weapon slots (marine only). Alien weapons use just regular numbers.
kPrimaryWeaponSlot = 1
kSecondaryWeaponSlot = 2
kTertiaryWeaponSlot = 3

// How long to display weapon picker after selecting weapons
kDisplayWeaponTime = 1.5

// Death message indices 
kDeathMessageIcon = enum( { 'None', 
                            'Rifle', 'RifleButt', 'Pistol', 'Axe', 'Shotgun',
                            'Flamethrower', 'ARC', 'Grenade', 'Sentry', 'Welder',
                            'Bite', 'HydraSpike', 'Spray', 'Spikes', 'Parasite',
                            'SporeCloud', 'Swipe', 'BuildAbility', 'Whip', 'BileBomb',
                            'Mine', 'Gore', 'Spit', 'Jetpack', 'Claw',
                            'Minigun', 'Vortex', 'LerkBite', 'Umbra', 
                            'Xenocide', 'Blink', 'Leap', 'Stomp',
                            'Consumed', 'GL', 'Recycled', 'Babbler', 'Railgun', 'AcidRocket', 'GorgeTunnel', 'BoneShield',
                            'ClusterGrenade', 'GasGrenade', 'PulseGrenade', 'Stab', 'WhipBomb',
							'MarineStructureAbility', 'Cannon', 'Devour', 'BabblerBomb', 'SporeMine', 'LightMachineGun', 'Knife', 'RefundMarine', 'RefundAlien',
							'Revolver', 'Metabolize', 'Crush', 'BabblerAbility',
                            } )

kMinimapBlipType = enum( { 'Undefined', 'TechPoint', 'ResourcePoint', 'Scan', 'EtherealGate', 'HighlightWorld',
                           'Sentry', 'CommandStation',
                           'Extractor', 'InfantryPortal', 'Armory', 'AdvancedArmory', 'PhaseGate', 'Observatory',
                           'RoboticsFactory', 'ArmsLab', 'PrototypeLab',
                           'Hive', 'Harvester', 'Hydra', 'Egg', 'Embryo', 'Crag', 'Whip', 'Shade', 'Shift', 'Shell', 'Veil', 'Spur', 'TunnelEntrance', 'BoneWall',
                           'Marine', 'JetpackMarine', 'Exo', 'Skulk', 'Lerk', 'Onos', 'Fade', 'Gorge',
                           'Door', 'PowerPoint', 'DestroyedPowerPoint', 
                           'BlueprintPowerPoint', 'ARC', 'Drifter', 'MAC', 'Infestation', 'InfestationDying', 'MoveOrder', 'AttackOrder', 'BuildOrder', 'SensorBlip', 'SentryBattery',
						   'WeaponCache', 'DevouredPlayer', 'CapturePoint', 'UnsocketedPowerPoint','Scout','Assault','Medic','Engineer','Flag' } )

// Friendly IDs
// 0 = friendly
// 1 = enemy
// 2 = neutral
// for spectators is used Marine and Alien
kMinimapBlipTeam = enum( {'Friendly', 'Enemy', 'Neutral', 'Alien', 'Marine', 'FriendAlien', 'FriendMarine', 'InactiveAlien', 'InactiveMarine' } )

// How long commander alerts should last (from NS1)
kAlertExpireTime = 20

// Bit mask table for non-stackable game effects. OnInfestation is set if we're on ANY infestation (regardless of team).
// Always keep "Max" as last element.
kGameEffect = CreateBitMask( {"InUmbra", "Fury", "Cloaked", "Parasite", "NearDeath", "OnFire", "OnInfestation", "Beacon", "Energize" } )
kGameEffectMax = bit.lshift( 1, GetBitMaskNumBits(kGameEffect) )

// Stackable game effects (more than one can be active, server-side only)
kFuryGameEffect = "fury"
kMaxStackLevel = 10

kMaxEntityStringLength = 32
kMaxAnimationStringLength = 32

// Player modes. When outside the default player mode, input isn't processed from the player
kPlayerMode = enum( {'Default', 'Taunt', 'Knockback', 'StandUp'} )

// Team alert types
kAlertType = enum( {'Attack', 'Info', 'Request'} )

// Dynamic light modes for power grid
kLightMode = enum( {'Normal', 'NoPower', 'LowPower', 'Damaged'} )

// Game state
kGameState = enum( {'NotStarted', 'PreGame', 'Countdown', 'Started', 'Team1Won', 'Team2Won', 'Draw'} )

// Don't allow commander to build structures this close to attach points or other structures
kBlockAttachStructuresRadius = 3

// Marquee while active, to ensure we get mouse release event even if on top of other component
kHighestPriorityZ = 3

// How often to send kills, deaths, nick name changes, etc. for scoreboard
kScoreboardUpdateInterval = 3

// How often to send ping updates to individual players
kUpdatePingsIndividual = 6

// How often to send ping updates to all players.
kUpdatePingsAll = 12

kStructureSnapRadius = 4

// Only send friendly blips down within this range 
kHiveSightMaxRange = 50
kHiveSightMinRange = 3
kHiveSightDamageTime = 8

// Bit masks for relevancy checking
kRelevantToTeam1Unit        = 1
kRelevantToTeam2Unit        = 2
kRelevantToTeam1Commander   = 4
kRelevantToTeam2Commander   = 8
kRelevantToTeam1            = bit.bor(kRelevantToTeam1Unit, kRelevantToTeam1Commander)
kRelevantToTeam2            = bit.bor(kRelevantToTeam2Unit, kRelevantToTeam2Commander)
kRelevantToReadyRoom        = 16

// Hive sight constants
kBlipType = enum( {'Undefined', 'Friendly', 'FriendlyUnderAttack', 'Sighted', 'TechPointStructure', 'NeedHealing', 'FollowMe', 'Chuckle', 'Pheromone', 'Parasited' } )

kFeedbackURL = "http://getsatisfaction.com/unknownworlds/feedback/topics/new?product=unknownworlds_natural_selection_2&display=layer&style=idea&custom_css=http://www.unknownworlds.com/game_scripts/ns2/styles.css"

// Used for menu on top of class (marine or alien buy menus or out of game menu) 
kMenuFlashIndex = 2

// Fade to black time (then to spectator mode)
kFadeToBlackTime = 3

// Constant to prevent z-fighting 
kZFightingConstant = 0.1

// Any geometry or props with this name won't be drawn or affect commanders
kCommanderInvisibleGroupName = "CommanderInvisible"
kCommanderInvisibleVentsGroupName = "CommanderInvisibleVents"
// Any geometry or props with this name will not support being built on top of
kCommanderNoBuildGroupName = "CommanderNoBuild"
kCommanderBuildGroupName = "CommanderBuild"

// invisible and blocks all movement
kMovementCollisionGroupName = "MovementCollisionGeometry"
// same as 'MovementCollisionGeometry'
kCollisionGeometryGroupName = "CollisionGeometry"
// invisible, blocks anything default geometry would block
kInvisibleCollisionGroupName = "InvisibleGeometry"
// visible and won't block anything
kNonCollisionGeometryGroupName = "NonCollisionGeometry"

kPathingLayerName = "Pathing"

// Max players allowed in game
kMaxPlayers = 32

kMaxIdleWorkers = 127
kMaxPlayerAlerts = 127

// Max distance to propagate entities with
kMaxRelevancyDistance = 40

kEpsilon = 0.0001

// Weapon spawn height (for Commander dropping weapons)
kCommanderDropSpawnHeight = 0.08
kCommanderEquipmentDropSpawnHeight = 0.5

kInventoryIconsTexture = Textures.kInventoryIcons
kInventoryIconTextureWidth = 128
kInventoryIconTextureHeight = 64

// Options keys
kNicknameOptionsKey = "nickname"
kVisualDetailOptionsKey = "visualDetail"
kSoundInputDeviceOptionsKey = "sound/input-device"
kSoundOutputDeviceOptionsKey = "sound/output-device"
kSoundVolumeOptionsKey = "soundVolume"
kMusicVolumeOptionsKey = "musicVolume"
kVoiceVolumeOptionsKey = "voiceVolume"
kDisplayOptionsKey = "graphics/display/display"
kWindowModeOptionsKey = "graphics/display/window-mode"
kDisplayQualityOptionsKey = "graphics/display/quality"
kInvertedMouseOptionsKey = "input/mouse/invert"
kLastServerConnected = "lastConnectedServer"
kLastServerPassword  = "lastServerPassword"
kLastServerMapName  = "lastServerMapName"

kPhysicsGpuAccelerationKey = "physics/gpu-acceleration"
kGraphicsXResolutionOptionsKey = "graphics/display/x-resolution"
kGraphicsYResolutionOptionsKey = "graphics/display/y-resolution"
kAntiAliasingOptionsKey = "graphics/display/anti-aliasing"
kAtmosphericsOptionsKey = "graphics/display/atmospherics"
kOculusModeKey = "oculusMode"
kShadowsOptionsKey = "graphics/display/shadows"
kShadowFadingOptionsKey = "graphics/display/shadow-fading"
kBloomOptionsKey = "graphics/display/bloom"
kAnisotropicFilteringOptionsKey = "graphics/display/anisotropic-filtering"

kMouseSensitivityScalar         = 50

// Player use range
kPlayerUseRange = 2
kMaxPitch = (math.pi / 2) - math.rad(3)

// Pathing flags
kPathingFlags = enum ({'UnBuildable', 'UnPathable', 'Blockable'})

// How far from the order location must units be to complete it.
kAIMoveOrderCompleteDistance = 0.01
kPlayerMoveOrderCompleteDistance = 1.5

// Statistics
kStatisticsURL = "http://combatsponitor.unknownworlds.com/api/sendmatchStart"

kResourceType = enum( {'Team', 'Personal', 'Energy', 'Ammo'} )

kNameTagFontColors = { [kMarineTeamType] = kMarineFontColor,
                       [kAlienTeamType] = kAlienFontColor,
                       [kNeutralTeamType] = kNeutralFontColor }

kNameTagFontNames = { [kMarineTeamType] = kMarineFontName,
                      [kAlienTeamType] = kAlienFontName,
                      [kNeutralTeamType] = kNeutralFontName }

kHealthBarColors = { [kMarineTeamType] = Color(0.725, 0.921, 0.949, 1),
                     [kAlienTeamType] = Color(0.776, 0.364, 0.031, 1),
                     [kNeutralTeamType] = Color(1, 1, 1, 1) }

kHealthBarBgColors = { [kMarineTeamType] = Color(0.725 * 0.5, 0.921 * 0.5, 0.949 * 0.5, 1),
                     [kAlienTeamType] = Color(0.776 * 0.5, 0.364 * 0.5, 0.031 * 0.5, 1),
                     [kNeutralTeamType] = Color(1 * 0.5, 1 * 0.5, 1 * 0.5, 1) }
                     
kArmorBarColors = { [kMarineTeamType] = Color(0.078, 0.878, 0.984, 1),
                    [kAlienTeamType] = Color(0.576, 0.194, 0.011, 1),
                    [kNeutralTeamType] = Color(0.5, 0.5, 0.5, 1) }
                     
kArmorBarBgColors = { [kMarineTeamType] = Color(0.078 * 0.5, 0.878 * 0.5, 0.984 * 0.5, 1),
                    [kAlienTeamType] = Color(0.576 * 0.5, 0.194 * 0.5, 0.011 * 0.5, 1),
                    [kNeutralTeamType] = Color(0.5 * 0.5, 0.5 * 0.5, 0.5 * 0.5, 1) }
                    
kAbilityBarColors = { [kMarineTeamType] = Color(0,1,1,1),
                    [kAlienTeamType] = Color(1,1,0,1),
                    [kNeutralTeamType] = Color(1, 1, 1, 1) }
                     
kAbilityBarBgColors = { [kMarineTeamType] = Color(0, 0.5, 0.5, 1),
                    [kAlienTeamType] = Color(0.5, 0.5, 0, 1),
                    [kNeutralTeamType] = Color(0.5, 0.5, 0.5, 1) }

// used for specific effects
kUseInterval = 0.1

kPlayerLOSDistance = 20
kStructureLOSDistance = 3.5

kGestateCameraDistance = 1.75

// Rookie mode
kRookieSaveInterval = 30 // seconds
kRookieTimeThreshold = 4 * 60 * 60 // 4 hours
kRookieNetworkCheckInterval = 2
kRookieOptionsKey = "rookieMode"

kMinFOVAdjustmentDegrees = 0
kMaxFOVAdjustmentDegrees = 30

kDamageEffectType = enum({ 'Blood', 'AlienBlood', 'Sparks' })

kIconColors = 
{
    [kMarineTeamType] = Color(0.8, 0.96, 1, 1),
    [kAlienTeamType] = Color(1, 0.9, 0.4, 1),
    [kNeutralTeamType] = Color(1, 1, 1, 1),
}

//----------------------------------------
//  DLC stuff
//----------------------------------------
// checks if client has the DLC, if a table is passed, the function returns true when the client owns at least one of the productIds
function GetHasDLC(productId, client)

    if productId == nil or productId == 0 then
        return true
    end
    
    local checkIds = {}
    
    if type(productId) == "table" then
        checkIds = productId
    else
        checkIds = { productId }
    end  
    
    for i = 1, #checkIds do
    
        if Client then
        
            assert(client == nil)
            if Client.GetIsDlcAuthorized(checkIds[i]) then
                return true
            end
            
        elseif Server and client then
        
            assert(client ~= nil)
            if Server.GetIsDlcAuthorized(client, checkIds[i]) then
                return true 
            end    

        end
    
    end
    
    return false
    
end

kSpecialEditionProductId = 4930
kFaultlineProductId = 311010
kReaperProductId = 310100 //temp for testing 310100

kNoShoulerPad = 0

// DLC player variants
// "code" is the key

// TODO we can really just get rid of the enum. use array-of-structures pattern, and use #kMarineVariants to network vars

kMarineVariant = enum({ "green" })
kMarineVariantData =
{
    [kMarineVariant.green] = { productId = nil, displayName = "Normal", modelFilePart = "", viewModelFilePart = "" }
}
kDefaultMarineVariant = kMarineVariant.green

kSkulkVariant = enum({ "normal" })
kSkulkVariantData =
{
    [kSkulkVariant.normal] = { productId = nil, displayName = "Normal", modelFilePart = "", viewModelFilePart = "" }
}
kDefaultSkulkVariant = kSkulkVariant.normal

kGorgeVariant = enum({ "normal" })
kGorgeVariantData =
{
    [kGorgeVariant.normal] = { productId = nil, displayName = "Normal", modelFilePart = "", viewModelFilePart = "" }
}
kDefaultGorgeVariant = kGorgeVariant.normal

kLerkVariant = enum({ "normal" })
kLerkVariantData =
{
    [kLerkVariant.normal] = { productId = nil, displayName = "Normal", modelFilePart = "", viewModelFilePart = "" }
}
kDefaultLerkVariant = kLerkVariant.normal

kFadeVariant = enum({ "normal" })
kFadeVariantData =
{
    [kFadeVariant.normal] = { productId = nil, displayName = "Normal", modelFilePart = "", viewModelFilePart = "" },
}
kDefaultFadeVariant = kFadeVariant.normal

kOnosVariant = enum({ "normal" })
kOnosVariantData =
{
    [kOnosVariant.normal] = { productId = nil, displayName = "Normal", modelFilePart = "", viewModelFilePart = "" },
}
kDefaultOnosVariant = kOnosVariant.normal


kExoVariant = enum({ "normal" })
kExoVariantData =
{
    [kExoVariant.normal] = { productId = nil, displayName = "Normal", modelFilePart = "", viewModelFilePart = "" }
}
kDefaultExoVariant = kExoVariant.normal

kRifleVariant = enum({ "normal" })
kRifleVariantData =
{
    [kRifleVariant.normal] = { productId = nil, displayName = "Normal", modelFilePart = "", viewModelFilePart = "" }
}
kDefaultRifleVariant = kRifleVariant.normal

function FindVariant( data, displayName )

    for var, data in pairs(data) do
        if data.displayName == displayName then
            return var
        end
    end
    return nil

end

function GetVariantName( data, var )
    if data[var] then
        return data[var].displayName
    end
    return ""        
end

function GetVariantModel( data, var )
    if data[var] then
        return data[var].modelFilePart .. ".model"
    end
    return ""        
end

function GetHasVariant(data, var, client)
    return GetHasDLC(data[var].productId, client)
end

kShoulderPad2ProductId =
{
    kNoShoulerPad,
	kFaultlineProductId,
	
    kReaperProductId,
}
function GetHasShoulderPad(index, client)
    return GetHasDLC( kShoulderPad2ProductId[index], client )
end

kShoulderPadNames =
{
    "None",
	"Faultline"
}

function GetShoulderPadIndexByName(padName)

    for index, name in ipairs(kShoulderPadNames) do
        if name == padName then
            return index
        end    
    end
    
    return 1

end

kHUDMode = enum({ "Full", "Minimal" })

