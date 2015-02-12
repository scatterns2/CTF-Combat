//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'FlamethrowerUpgrade' (CombatWeaponUpgrade)

// Define these statically so we can easily access them without instantiating.
FlamethrowerUpgrade.cost			= { 1 }                          				// cost of the upgrade in points
FlamethrowerUpgrade.upgradeName 	= "flamer"			                        	// text code of the upgrade if using it via console
FlamethrowerUpgrade.upgradeTitle	= "FLAMETHROWER"								// Title of the upgrade, e.g. Submachine Gun
FlamethrowerUpgrade.upgradeDesc		= "FLAMETHROWER_TOOLTIP"	// Description of the upgrade
FlamethrowerUpgrade.upgradeTechId	= kTechId.Flamethrower 		    				// TechId of the upgrade, default is kTechId.Move cause its the first entry
FlamethrowerUpgrade.hudSlot			= kPrimaryWeaponSlot							// Is this a primary weapon?
FlamethrowerUpgrade.minPlayerLevel 	= 1												// Controls whether this upgrade requires the recipient to be a minimum level
FlamethrowerUpgrade.rowOrder 		= 1												// Controls the horizontal position on the menu
FlamethrowerUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Flamethrower_Active.dds")
FlamethrowerUpgrade.vidDesc			= "videos/Marines_Flamethrower.webm"
FlamethrowerUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Flame.dds"
FlamethrowerUpgrade.requirements			= { "engineer", "marine"}

function FlamethrowerUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = FlamethrowerUpgrade.cost
	self.upgradeName = FlamethrowerUpgrade.upgradeName
	self.upgradeTitle = FlamethrowerUpgrade.upgradeTitle
	self.upgradeDesc = FlamethrowerUpgrade.upgradeDesc
	self.upgradeTechId = FlamethrowerUpgrade.upgradeTechId
	self.hudSlot = FlamethrowerUpgrade.hudSlot
	self.minPlayerLevel = FlamethrowerUpgrade.minPlayerLevel
	self.rowOrder = FlamethrowerUpgrade.rowOrder
	self.texture = FlamethrowerUpgrade.texture
	self.vidDesc = FlamethrowerUpgrade.vidDesc
	self.eventParams = FlamethrowerUpgrade.eventParams
	self.detailImage = FlamethrowerUpgrade.detailImage
	self.requirements = FlamethrowerUpgrade.requirements
	
end

function FlamethrowerUpgrade:GetClassName()
	return "FlamethrowerUpgrade"
end