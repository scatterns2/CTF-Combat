//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Globals_Combat.lua

// Version number
kCombatVersion = "2014.12.11 (Merry Fademas!)"

// Game modes
kCombatGameType = enum( { 'CombatDeathmatch', 'CombatCapture', 'Infection','CombatCTF' } )

// Stats stuff
kChoosyTime = 6
kMaxSkillDifference = 200

// Marine HUD Slots
kAxeHUDSlot = 3
kWelderHUDSlot = 3
kMinesHUDSlot = 4
kGrenadesHUDSlot = 4
kBuilderHUDSlot = 5

// Alien HUD Slots
kSpitSprayHUDSlot = 1
kBileBombHUDSlot = 2
kBabblerBombHUDSlot = 3
kDropStructuresHUDSlot = 5

// Buy menu
kUpgradeIconHeight = 256
kUpgradeIconWidth = 256

kCombatRootFolder = "combat"

Script.Load("lua/Globals_Stats.lua")