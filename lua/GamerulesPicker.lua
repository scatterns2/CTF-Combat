//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//_______________________________

// GamerulesPicker.lua

Script.Load("lua/GamerulesPicker_Global.lua")
Script.Load("lua/Entity.lua")

class 'GamerulesPicker' (Entity)

GamerulesPicker.kMapName = "gamerules_picker"

local networkVars =
{
}

if Server then
	
	function GamerulesPicker:OnCreate()
		// Set global gamerules picker whenever gamerules pickers are built
        SetGamerulesPicker(self)
	end
	
    function GamerulesPicker:OnInitialized()
		// Set global gamerules picker whenever gamerules pickers are built
        SetGamerulesPicker(self)
	end
	
	function GamerulesPicker:GetGameType()
		if self.gameType == nil then
			return kCombatGameType.CombatDeathmatch
		else
			return self.gameType
		end
	end
	
	function GamerulesPicker:GetPowerNodesStartDestroyed()
		return self.powerNodesStartDestroyed
	end
	
	function GamerulesPicker:GetGamerulesMapName()
		if self.gameType == nil then
			return CombatDeathmatchGamerules.kMapName
		elseif self.gameType == kCombatGameType.CombatDeathmatch then
			return CombatDeathmatchGamerules.kMapName
		elseif self.gameType == kCombatGameType.CombatCapture then
			return CombatCaptureGamerules.kMapName
		elseif self.gameType == kCombatGameType.CombatCTF then
			return CombatCTFGamerules.kMapName	
		elseif self.gameType == kCombatGameType.Infection then
			return InfectionGamerules.kMapName
		end
	end
	
end

Shared.LinkClassToMap("GamerulesPicker", GamerulesPicker.kMapName, networkVars)