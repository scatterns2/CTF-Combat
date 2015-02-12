//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// ShotgunUpgrade.lua
						
class 'ShotgunUpgrade' (CombatWeaponUpgrade)

ShotgunUpgrade.cost 	 		= { 1 }                          				// cost of the upgrade in points
ShotgunUpgrade.upgradeName  	= "shotgun"	                        			// Text code of the upgrade if using it via console
ShotgunUpgrade.upgradeTitle 	= "SHOTGUN"       								// Title of the upgrade, e.g. Submachine Gun
ShotgunUpgrade.upgradeDesc  	= "SHOTGUN_TOOLTIP"	// Description of the upgrade
ShotgunUpgrade.upgradeTechId 	= kTechId.Shotgun 	 		    				// TechId of the upgrade, default is kTechId.Move cause its the first entry
ShotgunUpgrade.hudSlot	 		= kPrimaryWeaponSlot							// Is this a primary weapon?
ShotgunUpgrade.minPlayerLevel 	= 2												// Controls whether this upgrade requires the recipient to be a minimum level
ShotgunUpgrade.rowOrder 		= 0												// Controls the horizontal position on the menu
ShotgunUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Shotgun_Active.dds")
ShotgunUpgrade.vidDesc			= "videos/Marines_Shotgun.webm"
ShotgunUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Shot.dds"
ShotgunUpgrade.requirements		= {"scout","marine"}

function ShotgunUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = ShotgunUpgrade.cost
	self.upgradeName = ShotgunUpgrade.upgradeName
	self.upgradeTitle = ShotgunUpgrade.upgradeTitle
	self.upgradeDesc = ShotgunUpgrade.upgradeDesc
	self.upgradeTechId = ShotgunUpgrade.upgradeTechId
	self.hudSlot = ShotgunUpgrade.hudSlot
	self.minPlayerLevel = ShotgunUpgrade.minPlayerLevel
	self.rowOrder = ShotgunUpgrade.rowOrder
	self.texture = ShotgunUpgrade.texture
	self.vidDesc = ShotgunUpgrade.vidDesc
	self.detailImage = ShotgunUpgrade.detailImage
	self.requirements = ShotgunUpgrade.requirements
	
end

function ShotgunUpgrade:GetClassName()
	return "ShotgunUpgrade"
end