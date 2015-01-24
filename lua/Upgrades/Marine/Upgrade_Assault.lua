//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'AssaultUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
AssaultUpgrade.upgradeType 			= kCombatUpgradeTypes.Lifeform     			// The type of the upgrade
AssaultUpgrade.cost 				= { 0 }                              		// cost of the upgrade in points
AssaultUpgrade.upgradeName 			= "assault"                     				// Text code of the upgrade if using it via console
AssaultUpgrade.upgradeTitle 		= "ASSAULT"               					// Title of the upgrade, e.g. Submachine Gun
AssaultUpgrade.upgradeDesc 			= "COMBAT_UPGRADE_MARINE_TOOLTIP"				// Description of the upgrade
AssaultUpgrade.upgradeTechId 		= kTechId.Assault							// TechId of the upgrade, default is kTechId.Move cause its the first entry
AssaultUpgrade.teamType 			= kCombatUpgradeTeamType.MarineTeam			// Team Type
AssaultUpgrade.minPlayerLevel 		= 0											// Controls whether this upgrade requires the recipient to be a minimum level
AssaultUpgrade.rowOrder 			= 0											// Controls the horizontal position on the menu
AssaultUpgrade.texture  			= PrecacheAsset("ui/buymenu/Icons/Icon_Marine_Active.dds")
AssaultUpgrade.mustBeNearTechPoint = true
AssaultUpgrade.isClassUpgrade = true	
AssaultUpgrade.uniqueSlot 			= kUpgradeUniqueSlot.Class
AssaultUpgrade.vidDesc				= "videos/Marines_MinigunExo.webm"
AssaultUpgrade.requirements			= { }

function AssaultUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.upgradeType = AssaultUpgrade.upgradeType
	self.cost = AssaultUpgrade.cost
	self.upgradeName = AssaultUpgrade.upgradeName
	self.upgradeTitle = AssaultUpgrade.upgradeTitle
	self.upgradeDesc = AssaultUpgrade.upgradeDesc
	self.upgradeTechId = AssaultUpgrade.upgradeTechId
	self.teamType = AssaultUpgrade.teamType
	self.minPlayerLevel = AssaultUpgrade.minPlayerLevel
	self.rowOrder = AssaultUpgrade.rowOrder
	self.texture = AssaultUpgrade.texture
	self.mustBeNearTechPoint = AssaultUpgrade.mustBeNearTechPoint
	self.uniqueSlot = AssaultUpgrade.uniqueSlot
	self.vidDesc = AssaultUpgrade.vidDesc
	self.vidDesc = AssaultUpgrade.vidDesc
	self.requirements = AssaultUpgrade.requirements
	self.isClassUpgrade = AssaultUpgrade.isClassUpgrade

end

function AssaultUpgrade:GetClassName()
	return "AssaultUpgrade"
end

function AssaultUpgrade:OnAdd(player, isReapply)
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
	if not player:isa("Assault") then
		local percent = player:GetLifePercent()
		player:OnDestroy()
		marine = player:Replace(Assault.kMapName, player:GetTeamNumber(), false, player:GetOrigin())
		marine:SetHealth(marine:GetMaxHealth() * percent)
		marine:SetArmor(marine:GetMaxArmor() * percent)
	end
	
	// Give the rifle if the marine doesn't have it already
	if giveRifle then
		local rifleUpgrade = player:GetUpgradeByName("Cannon")
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

function AssaultUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = "You are now a Marine!" }
end


function AssaultUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_Marine_mask.dds", ""
end

function AssaultUpgrade:CausesEntityChange()
	return true
end