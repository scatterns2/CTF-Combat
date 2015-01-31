//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// AxeUpgrade.lua
						
class 'AxeUpgrade' (CombatWeaponUpgrade)

AxeUpgrade.cost	 			= { 0 }                           							// cost of the upgrade in points
AxeUpgrade.upgradeName 		= "axe"                       								// Text code of the upgrade if using it via console
AxeUpgrade.upgradeTitle 	= "COMBAT_UPGRADE_AXE"               						// Title of the upgrade, e.g. Submachine Gun
AxeUpgrade.upgradeDesc 		= "WEAPON_DESC_AXE"											// Description of the upgrade
AxeUpgrade.upgradeTechId 	= kTechId.Axe 	    										// TechId of the upgrade, default is kTechId.Move cause its the first entry
AxeUpgrade.hudSlot			= kAxeHUDSlot												// Is this a primary weapon?
AxeUpgrade.minPlayerLevel 	= 2															// Controls whether this upgrade requires the recipient to be a minimum level
AxeUpgrade.rowOrder 		= 0															// Controls the horizontal position on the menu
AxeUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Reload_Active.dds")
AxeUpgrade.vidDesc			= "videos/Marines_Axe.webm"


function AxeUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = AxeUpgrade.cost
	self.upgradeName = AxeUpgrade.upgradeName
	self.upgradeTitle = AxeUpgrade.upgradeTitle
	self.upgradeDesc = AxeUpgrade.upgradeDesc
	self.upgradeTechId = AxeUpgrade.upgradeTechId
	self.hudSlot = AxeUpgrade.hudSlot
	self.minPlayerLevel = AxeUpgrade.minPlayerLevel
	self.rowOrder = AxeUpgrade.rowOrder
	self.texture = AxeUpgrade.texture
	self.vidDesc = AxeUpgrade.vidDesc
	
end

function AxeUpgrade:GetClassName()
	return "AxeUpgrade"
end