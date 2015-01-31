//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Upgrade_Knife.lua
						
class 'KnifeUpgrade' (CombatWeaponUpgrade)

KnifeUpgrade.cost	 			= { 0 }                           							// cost of the upgrade in points
KnifeUpgrade.upgradeName 		= "knife"                       							// Text code of the upgrade if using it via console
KnifeUpgrade.upgradeTitle 		= "COMBAT_UPGRADE_KNIFE"               									// Title of the upgrade, e.g. Submachine Gun
KnifeUpgrade.upgradeDesc 		= "COMBAT_UPGRADE_KNIFE_TOOLTIP"	// Description of the upgrade
KnifeUpgrade.upgradeTechId 		= kTechId.Knife 	    									// TechId of the upgrade, default is kTechId.Move cause its the first entry
KnifeUpgrade.hudSlot			= kAxeHUDSlot												// Is this a primary weapon?
KnifeUpgrade.minPlayerLevel 	= 0															// Controls whether this upgrade requires the recipient to be a minimum level
KnifeUpgrade.rowOrder 			= 0															// Controls the horizontal position on the menu
KnifeUpgrade.texture  			= PrecacheAsset("ui/buymenu/Icons/Icon_Reload_Active.dds")
KnifeUpgrade.vidDesc			= "videos/Marines_Axe.webm"


function KnifeUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = KnifeUpgrade.cost
	self.upgradeName = KnifeUpgrade.upgradeName
	self.upgradeTitle = KnifeUpgrade.upgradeTitle
	self.upgradeDesc = KnifeUpgrade.upgradeDesc
	self.upgradeTechId = KnifeUpgrade.upgradeTechId
	self.hudSlot = KnifeUpgrade.hudSlot
	self.minPlayerLevel = KnifeUpgrade.minPlayerLevel
	self.rowOrder = KnifeUpgrade.rowOrder
	self.texture = KnifeUpgrade.texture
	self.vidDesc = KnifeUpgrade.vidDesc
	
end

function KnifeUpgrade:GetClassName()
	return "KnifeUpgrade"
end