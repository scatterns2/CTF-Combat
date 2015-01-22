//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'MedicUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
MedicUpgrade.upgradeType 		= kCombatUpgradeTypes.Lifeform     			// The type of the upgrade
MedicUpgrade.cost 				= { 0 }                              		// cost of the upgrade in points
MedicUpgrade.upgradeName 		= "medic"                     				// Text code of the upgrade if using it via console
MedicUpgrade.upgradeTitle 		= "MEDIC"               					// Title of the upgrade, e.g. Submachine Gun
MedicUpgrade.upgradeDesc 		= "COMBAT_UPGRADE_MARINE_TOOLTIP"				// Description of the upgrade
MedicUpgrade.upgradeTechId 		= kTechId.Medic							// TechId of the upgrade, default is kTechId.Move cause its the first entry
MedicUpgrade.teamType 			= kCombatUpgradeTeamType.MarineTeam			// Team Type
MedicUpgrade.minPlayerLevel 	= 0											// Controls whether this upgrade requires the recipient to be a minimum level
MedicUpgrade.rowOrder 			= 0											// Controls the horizontal position on the menu
MedicUpgrade.texture  			= PrecacheAsset("ui/buymenu/Icons/Icon_Marine_Active.dds")
MedicUpgrade.mustBeNearTechPoint = true
MedicUpgrade.isClassUpgrade = true						--Lifeforms, Marine and Exo are all classes
MedicUpgrade.uniqueSlot 		= kUpgradeUniqueSlot.Class
MedicUpgrade.vidDesc			= "videos/Marines_MinigunExo.webm"
MedicUpgrade.requirements		= {}

function MedicUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.upgradeType = MedicUpgrade.upgradeType
	self.cost = MedicUpgrade.cost
	self.upgradeName = MedicUpgrade.upgradeName
	self.upgradeTitle = MedicUpgrade.upgradeTitle
	self.upgradeDesc = MedicUpgrade.upgradeDesc
	self.upgradeTechId = MedicUpgrade.upgradeTechId
	self.teamType = MedicUpgrade.teamType
	self.minPlayerLevel = MedicUpgrade.minPlayerLevel
	self.rowOrder = MedicUpgrade.rowOrder
	self.texture = MedicUpgrade.texture
	self.mustBeNearTechPoint = MedicUpgrade.mustBeNearTechPoint
	self.uniqueSlot = MedicUpgrade.uniqueSlot
	self.vidDesc = MedicUpgrade.vidDesc
	self.vidDesc = MedicUpgrade.vidDesc
	self.requirements = MedicUpgrade.requirements
	self.isClassUpgrade = MedicUpgrade.isClassUpgrade

end

function MedicUpgrade:GetClassName()
	return "MedicUpgrade"
end

function MedicUpgrade:OnAdd(player, isReapply)
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
	if not player:isa("Medic") then
		local percent = player:GetLifePercent()
		player:OnDestroy()
		marine = player:Replace(Medic.kMapName, player:GetTeamNumber(), false, player:GetOrigin())
		marine:SetHealth(marine:GetMaxHealth() * percent)
		marine:SetArmor(marine:GetMaxArmor() * percent)
	end
	
	// Give the rifle if the marine doesn't have it already
	if giveRifle then
		local rifleUpgrade = player:GetUpgradeByName("shotgun")
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

function MedicUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = "You are now a Marine!" }
end


function MedicUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_Marine_mask.dds", ""
end

function MedicUpgrade:CausesEntityChange()
	return true
end