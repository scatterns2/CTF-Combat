//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'MarineUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
MarineUpgrade.upgradeType 		= kCombatUpgradeTypes.Lifeform     			// The type of the upgrade
MarineUpgrade.cost 				= { 0 }                              		// cost of the upgrade in points
MarineUpgrade.upgradeName 		= "marine"                     				// Text code of the upgrade if using it via console
MarineUpgrade.upgradeTitle 		= "MARINE"               					// Title of the upgrade, e.g. Submachine Gun
MarineUpgrade.upgradeDesc 		= "COMBAT_UPGRADE_MARINE_TOOLTIP"				// Description of the upgrade
MarineUpgrade.upgradeTechId 	= kTechId.Marine							// TechId of the upgrade, default is kTechId.Move cause its the first entry
MarineUpgrade.teamType 			= kCombatUpgradeTeamType.MarineTeam			// Team Type
MarineUpgrade.minPlayerLevel 	= 0											// Controls whether this upgrade requires the recipient to be a minimum level
MarineUpgrade.rowOrder 			= 0											// Controls the horizontal position on the menu
MarineUpgrade.texture  			= PrecacheAsset("ui/buymenu/Icons/Icon_Marine_Active.dds")
MarineUpgrade.mustBeNearTechPoint = true
MarineUpgrade.uniqueSlot 		= kUpgradeUniqueSlot.Class
MarineUpgrade.vidDesc			= "videos/Marines_MinigunExo.webm"
MarineUpgrade.requirements		= {}
MarineUpgrade.hideUpgrade  	= true


function MarineUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.upgradeType = MarineUpgrade.upgradeType
	self.cost = MarineUpgrade.cost
	self.upgradeName = MarineUpgrade.upgradeName
	self.upgradeTitle = MarineUpgrade.upgradeTitle
	self.upgradeDesc = MarineUpgrade.upgradeDesc
	self.upgradeTechId = MarineUpgrade.upgradeTechId
	self.teamType = MarineUpgrade.teamType
	self.minPlayerLevel = MarineUpgrade.minPlayerLevel
	self.rowOrder = MarineUpgrade.rowOrder
	self.texture = MarineUpgrade.texture
	self.mustBeNearTechPoint = MarineUpgrade.mustBeNearTechPoint
	self.uniqueSlot = MarineUpgrade.uniqueSlot
	self.vidDesc = MarineUpgrade.vidDesc
	self.vidDesc = MarineUpgrade.vidDesc
	self.requirements = MarineUpgrade.requirements
	self.hideUpgrade = MarineUpgrade.hideUpgrade

end

function MarineUpgrade:GetClassName()
	return "MarineUpgrade"
end

function MarineUpgrade:OnAdd(player, isReapply)
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
	if not player:isa("Marine") then
		local percent = player:GetLifePercent()
		player:OnDestroy()
		marine = player:Replace(Marine.kMapName, player:GetTeamNumber(), false, player:GetOrigin())
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

function MarineUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = "You are now a Marine!" }
end


function MarineUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_Marine_mask.dds", ""
end

function MarineUpgrade:CausesEntityChange()
	return true
end