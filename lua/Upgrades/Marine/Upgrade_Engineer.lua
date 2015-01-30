//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
	
	
class 'EngineerUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
EngineerUpgrade.upgradeType 		= kCombatUpgradeTypes.Lifeform     			// The type of the upgrade
EngineerUpgrade.cost 				= { 0 }                              		// cost of the upgrade in points
EngineerUpgrade.upgradeName 		= "engineer"                     				// Text code of the upgrade if using it via console
EngineerUpgrade.upgradeTitle 		= "ENGINEER"               					// Title of the upgrade, e.g. Submachine Gun
EngineerUpgrade.upgradeDesc 		= "COMBAT_UPGRADE_ENGINEER_TOOLTIP"				// Description of the upgrade
EngineerUpgrade.upgradeTechId 		= kTechId.Engineer							// TechId of the upgrade, default is kTechId.Move cause its the first entry
EngineerUpgrade.teamType 			= kCombatUpgradeTeamType.MarineTeam			// Team Type
EngineerUpgrade.minPlayerLevel 		= 0											// Controls whether this upgrade requires the recipient to be a minimum level
EngineerUpgrade.rowOrder 			= 0											// Controls the horizontal position on the menu
EngineerUpgrade.texture  			= PrecacheAsset("ui/buymenu/Icons/Icon_Marine_Active.dds")
EngineerUpgrade.mustBeNearTechPoint = true
EngineerUpgrade.uniqueSlot 			= kUpgradeUniqueSlot.Class
EngineerUpgrade.vidDesc				= "videos/Marines_MinigunExo.webm"
EngineerUpgrade.requirements		= {}

function EngineerUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.upgradeType = EngineerUpgrade.upgradeType
	self.cost = EngineerUpgrade.cost
	self.upgradeName = EngineerUpgrade.upgradeName
	self.upgradeTitle = EngineerUpgrade.upgradeTitle
	self.upgradeDesc = EngineerUpgrade.upgradeDesc
	self.upgradeTechId = EngineerUpgrade.upgradeTechId
	self.teamType = EngineerUpgrade.teamType
	self.minPlayerLevel = EngineerUpgrade.minPlayerLevel
	self.rowOrder = EngineerUpgrade.rowOrder
	self.texture = EngineerUpgrade.texture
	self.mustBeNearTechPoint = EngineerUpgrade.mustBeNearTechPoint
	self.uniqueSlot = EngineerUpgrade.uniqueSlot
	self.vidDesc = EngineerUpgrade.vidDesc
	self.vidDesc = EngineerUpgrade.vidDesc
	self.requirements = EngineerUpgrade.requirements
	
end

function EngineerUpgrade:GetClassName()
	return "EngineerUpgrade"
end

function EngineerUpgrade:OnAdd(player, isReapply)
	// Check whether we'll want to give the player their rifle
	local giveRifle = false
	local slot1Upgrades = player:GetActiveUpgradesBySlot(kUpgradeUniqueSlot.Weapon1)
	if #slot1Upgrades == 0 then
		giveRifle = true
	end
	
	// Check whether we'll want to give the player their axe/knife
	local givePistol = false
	local slot2Upgrades = player:GetActiveUpgradesBySlot(kUpgradeUniqueSlot.Weapon2)
	if #slot2Upgrades == 0 then
		givePistol = true
	end
	
	// Check whether we'll want to give the player their axe/knife
	local giveKnife = false
	local slot3Upgrades = player:GetActiveUpgradesBySlot(kUpgradeUniqueSlot.Weapon3)
	if #slot3Upgrades == 0 then
		giveKnife = true
	end
	
		// Check whether we'll want to give the player their axe/knife
	local giveBuild = false
	local slot4Upgrades = player:GetActiveUpgradesBySlot(kUpgradeUniqueSlot.Weapon4)
	if #slot4Upgrades == 0 then
		giveBuild = true
	end
	
	// Switch player to marine if they're not one already
	local engineer = player
	local percent = player:GetLifePercent()
	player:OnDestroy()
	engineer = player:Replace(Engineer.kMapName, player:GetTeamNumber(), nil, player:GetOrigin())
	engineer:SetHealth(engineer:GetMaxHealth() * percent)
	engineer:SetArmor(engineer:GetMaxArmor() * percent)
	
	// Give the rifle if the marine doesn't have it already
	if giveRifle then
		local rifleUpgrade = player:GetUpgradeByName("Flamethrower")
		if rifleUpgrade then
			engineer:BuyUpgrade(rifleUpgrade:GetId(), true, true)
		end
	end

	// Give the knife if the marine doesn't have it already
	if givePistol then
		local pistolUpgrade = player:GetUpgradeByName("pistol")
		if pistolUpgrade then
			engineer:BuyUpgrade(pistolUpgrade:GetId(), true, true)
		end
	end
	
	// Give the knife if the marine doesn't have it already
	if giveKnife then
		local welderUpgrade = player:GetUpgradeByName("welder")
		if welderUpgrade then
			engineer:BuyUpgrade(welderUpgrade:GetId(), true, true)
		end
	end
	
	local giveBuild = true
	if giveBuild then
		local structureUpgrade = player:GetUpgradeByName("MarineStructureAbility")
		if structureUpgrade then
			engineer:BuyUpgrade(structureUpgrade:GetId(), true, true)
		end
	end
	
	return engineer
end

function EngineerUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = "You are now a Engineer Class!" }
end


function EngineerUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_Marine_mask.dds", ""
end

function EngineerUpgrade:CausesEntityChange()
	return true
end