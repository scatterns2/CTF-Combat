//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
// CombatDeathmatchGamerules.lua

Script.Load("lua/GenericGamerules.lua")

class 'CombatDeathmatchGamerules' (GenericGamerules)

CombatDeathmatchGamerules.kMapName = "combatdeathmatch_gamerules"
CombatDeathmatchGamerules.kDefaultTimeLimit = 0

local networkVars =
{
	timelimit = "time"
}

if Server then

	function CombatDeathmatchGamerules:OnCreate()
	
		self.isCompetitive = true
		self.lightsStartOff = false
		self.powerPointsTakeDamage = true
		self.startWithArmory = true
		self.startWithPhaseGate = true
		self.startWithFlag = true
		self.startWithCommandChair = true
		self.startWithShift = true
		self.startWithCrag = true
		self.startWithHive = true
		self.commandStructuresTakeDamage = false
		self.combatGameType = kCombatGameType.CombatDeathmatch
		self.timeLimit = CombatDeathmatchGamerules.kDefaultTimeLimit
	
		GenericGamerules.OnCreate(self)
		
	end

	function CombatDeathmatchGamerules:GetGameModeName()
		return "Combat Deathmatch"
	end
	
	function CombatDeathmatchGamerules:GetGameModeText()
		return { "Fight until the other team's base is destroyed!" }
	end

	local overrideResetGame = GenericGamerules.ResetGame
	function CombatDeathmatchGamerules:ResetGame()
		
		overrideResetGame(self)
		
		// Lock the command chairs and reveal the objectives.
		self:RevealCommandChairLocations()
		self:LockCommandChairs()
		
	end

end

Shared.LinkClassToMap("CombatDeathmatchGamerules", CombatDeathmatchGamerules.kMapName, networkVars)