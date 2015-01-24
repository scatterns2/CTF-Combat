//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'ScoutUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
ScoutUpgrade.upgradeType 		= kCombatUpgradeTypes.Lifeform     			// The type of the upgrade
ScoutUpgrade.cost 				= { 0 }                              		// cost of the upgrade in points
ScoutUpgrade.upgradeName 		= "scout"                     				// Text code of the upgrade if using it via console
ScoutUpgrade.upgradeTitle 		= "SCOUT"               					// Title of the upgrade, e.g. Submachine Gun
ScoutUpgrade.upgradeDesc 		= "COMBAT_UPGRADE_MARINE_TOOLTIP"				// Description of the upgrade
ScoutUpgrade.upgradeTechId 		= kTechId.Scout							// TechId of the upgrade, default is kTechId.Move cause its the first entry
ScoutUpgrade.teamType 			= kCombatUpgradeTeamType.MarineTeam			// Team Type
ScoutUpgrade.minPlayerLevel 	= 0											// Controls whether this upgrade requires the recipient to be a minimum level
ScoutUpgrade.rowOrder 			= 0											// Controls the horizontal position on the menu
ScoutUpgrade.texture  			= PrecacheAsset("ui/buymenu/Icons/Icon_Marine_Active.dds")
ScoutUpgrade.mustBeNearTechPoint = true
ScoutUpgrade.uniqueSlot 		= kUpgradeUniqueSlot.Class
ScoutUpgrade.vidDesc			= "videos/Marines_MinigunExo.webm"
ScoutUpgrade.requirements		= {}

function ScoutUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.upgradeType = ScoutUpgrade.upgradeType
	self.cost = ScoutUpgrade.cost
	self.upgradeName = ScoutUpgrade.upgradeName
	self.upgradeTitle = ScoutUpgrade.upgradeTitle
	self.upgradeDesc = ScoutUpgrade.upgradeDesc
	self.upgradeTechId = ScoutUpgrade.upgradeTechId
	self.teamType = ScoutUpgrade.teamType
	self.minPlayerLevel = ScoutUpgrade.minPlayerLevel
	self.rowOrder = ScoutUpgrade.rowOrder
	self.texture = ScoutUpgrade.texture
	self.mustBeNearTechPoint = ScoutUpgrade.mustBeNearTechPoint
	self.uniqueSlot = ScoutUpgrade.uniqueSlot
	self.vidDesc = ScoutUpgrade.vidDesc
	self.vidDesc = ScoutUpgrade.vidDesc
	self.requirements = ScoutUpgrade.requirements
	
end

function ScoutUpgrade:GetClassName()
	return "ScoutUpgrade"
end

function ScoutUpgrade:OnAdd(player, isReapply)
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
	
	// Switch player to marine if they're not one already
	local marine = player
	if not player:isa("Scout") then
		local percent = player:GetLifePercent()
		player:OnDestroy()
		marine = player:Replace(Scout.kMapName, player:GetTeamNumber(), false, player:GetOrigin())
		marine:SetHealth(marine:GetMaxHealth() * percent)
		marine:SetArmor(marine:GetMaxArmor() * percent)
	end
	
	// Give the rifle if the marine doesn't have it already
	if giveRifle then
		local rifleUpgrade = player:GetUpgradeByName("lmg")
		if rifleUpgrade then
			marine:BuyUpgrade(rifleUpgrade:GetId(), true, true)
		end
	end

	// Give the knife if the marine doesn't have it already
	if givePistol then
		local pistolUpgrade = player:GetUpgradeByName("pistol")
		if pistolUpgrade then
			marine:BuyUpgrade(pistolUpgrade:GetId(), true, true)
		end
	end
	
	// Give the knife if the marine doesn't have it already
	if giveKnife then
		local knifeUpgrade = player:GetUpgradeByName("knife")
		if knifeUpgrade then
			marine:BuyUpgrade(knifeUpgrade:GetId(), true, true)
		end
	end
	
	return marine
end

function ScoutUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = "You are now a Marine!" }
end


function ScoutUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_Marine_mask.dds", ""
end

function ScoutUpgrade:CausesEntityChange()
	return true
end