//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// ShotgunUpgrade.lua
						
class 'CannonUpgrade' (CombatWeaponUpgrade)

CannonUpgrade.cost 	 		= { 2 }                          				// cost of the upgrade in points
CannonUpgrade.upgradeName  	= "cannon"	                        			// Text code of the upgrade if using it via console
CannonUpgrade.upgradeTitle 	= "COMBAT_UPGRADE_CANNON"       								// Title of the upgrade, e.g. Submachine Gun
CannonUpgrade.upgradeDesc  	= "COMBAT_UPGRADE_CANNON_TOOLTIP"				// Description of the upgrade
CannonUpgrade.upgradeTechId 	= kTechId.Cannon	 		    				// TechId of the upgrade, default is kTechId.Move cause its the first entry
CannonUpgrade.hudSlot	 		= kPrimaryWeaponSlot							// Is this a primary weapon?
CannonUpgrade.minPlayerLevel 	= 8												// Controls whether this upgrade requires the recipient to be a minimum level
CannonUpgrade.rowOrder 		= 0												// Controls the horizontal position on the menu
CannonUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_HeavyCannon_Active.dds")
CannonUpgrade.vidDesc			= "videos/Marines_Shotgun.webm"
CannonUpgrade.detailImage	= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_HC.dds"
CannonUpgrade.requirements			= { "assault"}


function CannonUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = CannonUpgrade.cost
	self.upgradeName = CannonUpgrade.upgradeName
	self.upgradeTitle = CannonUpgrade.upgradeTitle
	self.upgradeDesc = CannonUpgrade.upgradeDesc
	self.upgradeTechId = CannonUpgrade.upgradeTechId
	self.hudSlot = CannonUpgrade.hudSlot
	self.minPlayerLevel = CannonUpgrade.minPlayerLevel
	self.rowOrder = CannonUpgrade.rowOrder
	self.texture = CannonUpgrade.texture
	self.vidDesc = CannonUpgrade.vidDesc
	// Hide the cannon until it is textured.
	self.hideUpgrade = false
	self.detailImage = CannonUpgrade.detailImage
	self.requirements = CannonUpgrade.requirements
	
end

function CannonUpgrade:GetClassName()
	return "CannonUpgrade"
end
