//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'GrenadeLauncherUpgrade' (CombatWeaponUpgrade)

// Define these statically so we can easily access them without instantiating.
GrenadeLauncherUpgrade.cost		 		= { 1 }                          							 // cost of the upgrade in points
GrenadeLauncherUpgrade.upgradeName  	= "gl"	                        							 // text code of the upgrade if using it via console
GrenadeLauncherUpgrade.upgradeTitle 	= "GRENADE_LAUNCHER"       									 // Title of the upgrade, e.g. Submachine Gun
GrenadeLauncherUpgrade.upgradeDesc  	= "GRENADE_LAUNCHER_TOOLTIP" // Description of the upgrade
GrenadeLauncherUpgrade.upgradeTechId 	= kTechId.GrenadeLauncher 		    						 // TechId of the upgrade, default is kTechId.Move cause its the first entry
GrenadeLauncherUpgrade.hudSlot	 		= kPrimaryWeaponSlot										 // Is this a primary weapon?
GrenadeLauncherUpgrade.minPlayerLevel	= 6															 // Controls whether this upgrade requires the recipient to be a minimum level
GrenadeLauncherUpgrade.rowOrder 		= 1															 // Controls the horizontal position on the menu
GrenadeLauncherUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_GLauncher_Active.dds")
GrenadeLauncherUpgrade.vidDesc			= "videos/Marines_GrenadeLauncher.webm"
GrenadeLauncherUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_GL.dds"

function GrenadeLauncherUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = GrenadeLauncherUpgrade.cost
	self.upgradeName = GrenadeLauncherUpgrade.upgradeName
	self.upgradeTitle = GrenadeLauncherUpgrade.upgradeTitle
	self.upgradeDesc = GrenadeLauncherUpgrade.upgradeDesc
	self.upgradeTechId = GrenadeLauncherUpgrade.upgradeTechId
	self.hudSlot = GrenadeLauncherUpgrade.hudSlot
	self.minPlayerLevel = GrenadeLauncherUpgrade.minPlayerLevel
	self.rowOrder = GrenadeLauncherUpgrade.rowOrder
	self.texture = GrenadeLauncherUpgrade.texture
	self.vidDesc = GrenadeLauncherUpgrade.vidDesc
	self.detailImage = GrenadeLauncherUpgrade.detailImage

end

function GrenadeLauncherUpgrade:GetClassName()
	return "GrenadeLauncherUpgrade"
end