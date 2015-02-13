//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Upgrade_Katana.lua
						
class 'KatanaUpgrade' (CombatWeaponUpgrade)

KatanaUpgrade.cost	 			= { 1 }                           							// cost of the upgrade in points
KatanaUpgrade.upgradeName 		= "katana"                       							// Text code of the upgrade if using it via console
KatanaUpgrade.upgradeTitle 		= "COMBAT_UPGRADE_KATANA"               									// Title of the upgrade, e.g. Submachine Gun
KatanaUpgrade.upgradeDesc 		= "COMBAT_UPGRADE_KATANA_TOOLTIP"	// Description of the upgrade
KatanaUpgrade.upgradeTechId 	= kTechId.Katana 	    									// TechId of the upgrade, default is kTechId.Move cause its the first entry
KatanaUpgrade.requirements		= { "scout" }
KatanaUpgrade.hudSlot			= kAxeHUDSlot												// Is this a primary weapon?
KatanaUpgrade.minPlayerLevel 	= 0															// Controls whether this upgrade requires the recipient to be a minimum level
KatanaUpgrade.rowOrder 			= 0															// Controls the horizontal position on the menu
KatanaUpgrade.texture  			= PrecacheAsset("ui/buymenu/Icons/Icon_Reload_Active.dds")
KatanaUpgrade.vidDesc			= "videos/Marines_Axe.webm"


function KatanaUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = KatanaUpgrade.cost
	self.upgradeName = KatanaUpgrade.upgradeName
	self.upgradeTitle = KatanaUpgrade.upgradeTitle
	self.upgradeDesc = KatanaUpgrade.upgradeDesc
	self.upgradeTechId = KatanaUpgrade.upgradeTechId
	self.requirements = KatanaUpgrade.requirements
	self.hudSlot = KatanaUpgrade.hudSlot
	self.minPlayerLevel = KatanaUpgrade.minPlayerLevel
	self.rowOrder = KatanaUpgrade.rowOrder
	self.texture = KatanaUpgrade.texture
	self.vidDesc = KatanaUpgrade.vidDesc
	
end

function KatanaUpgrade:GetClassName()
	return "KatanaUpgrade"
end