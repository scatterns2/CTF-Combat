//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//_______________________________

// CombatMarineClassUpgrade.lua

// Base class for all weapons and their upgrades

Script.Load("lua/Upgrade.lua")
							
class 'CombatMarineClassUpgrade' (CombatUpgrade)

CombatMarineClassUpgrade.upgradeType 		= kCombatUpgradeTypes.Lifeform          // the type of the upgrade
CombatMarineClassUpgrade.triggerType 		= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
CombatMarineClassUpgrade.permanent			= true									// Controls whether you get the upgrade back when you respawn
CombatMarineClassUpgrade.teamType			= kCombatUpgradeTeamType.MarineTeam	    // Team Type
CombatMarineClassUpgrade.uniqueSlot			= kUpgradeUniqueSlot.Class				// Unique slot
CombatMarineClassUpgrade.mustBeNearTechPoint = true									// Only available near the tech point

function CombatMarineClassUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "CombatMarineClassUpgrade") then
		self.hideUpgrade = true
		self.baseUpgrade = true
	end
	self.upgradeType = CombatMarineClassUpgrade.upgradeType
	self.triggerType = CombatMarineClassUpgrade.triggerType
	self.permanent = CombatMarineClassUpgrade.permanent
	self.teamType = CombatMarineClassUpgrade.teamType
	self.uniqueSlot = CombatMarineClassUpgrade.uniqueSlot
	self.mustBeNearTechPoint = CombatMarineClassUpgrade.mustBeNearTechPoint
	
end

function CombatMarineClassUpgrade:GetClassName()
	return "CombatMarineClassUpgrade"
end

function CombatMarineClassUpgrade:GetHasRoomToUpgrade(player)
	if player.GetHasRoomToEvolve and not player:GetHasRoomToEvolve(self:GetUpgradeTechId()) then
		return false
	else
		return true
	end
end

function CombatMarineClassUpgrade:CanApplyUpgrade(player)
	if not player:isa("Marine") or player:isa("MarineSpectator") then
		return "Player must be a Marine!"
	else
		return ""
	end
end

// Give the weapon to the player when they buy the upgrade.
function CombatMarineClassUpgrade:OnAdd(player, isReapply)

	// Apply the same logic to the player as OnCommandChangeClass does
	if player:GetTechId() ~= self:GetUpgradeTechId() then
		local position = player:GetOrigin()
		local newPlayer = player:Replace(self:GetUpgradeName(), player:GetTeamNumber(), false, nil, nil)
		
		if not newPlayer:SpaceClearForEntity(position) then
			local newPlayerExtents = LookupTechData(newPlayer:GetTechId(), kTechDataMaxExtents)
			local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(newPlayerExtents) 
			position = GetRandomSpawnForCapsule(newPlayerExtents.y, capsuleRadius, newPlayer:GetModelOrigin(), 0.5, 5)
		end
		
		newPlayer.upgradeUpdateQueue = player.upgradeUpdateQueue
		newPlayer:SetOrigin(position)
		newPlayer:ClearUpgrades()
		newPlayer:ReapplyUpgrades()
		
		return newPlayer
	end

end

function CombatMarineClassUpgrade:SendAddMessage(player)
	local a = "a"
	if self:GetUpgradeTitle() == "Onos" then
		a = "an"
	end
	player:SendDirectMessage("You are now " .. a .. " " .. self:GetUpgradeTitle() .. "!")
end

function CombatMarineClassUpgrade:CausesEntityChange()
	return true
end