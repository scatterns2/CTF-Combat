//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'LaserMinesUpgrade' (CombatResupplyableWeaponUpgrade)

LaserMinesUpgrade.cost 		 	= { 1 }                          			// cost of the upgrade in points
LaserMinesUpgrade.upgradeName 	= "lasermines"	                    		// text code of the upgrade if using it via console
LaserMinesUpgrade.upgradeTitle  = "COMBAT_UPGRADE_LASER_MINES"       						// Title of the upgrade, e.g. Submachine Gun
LaserMinesUpgrade.upgradeDesc  	= "TIPVIDEO_1_MARINE_MINES"			// Description of the upgrade
LaserMinesUpgrade.upgradeTechId = kTechId.LayLaserMines  					// techId of the upgrade, default is kTechId.Move cause its the first entry
LaserMinesUpgrade.hudSlot	 	= kMinesHUDSlot								// Is this a primary weapon?
LaserMinesUpgrade.minPlayerLevel = 1										// Controls whether this upgrade requires the recipient to be a minimum level
LaserMinesUpgrade.rowOrder 		= 0											// Controls the horizontal position on the menu
LaserMinesUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Mines_Active.dds")
LaserMinesUpgrade.vidDesc		= "videos/Marines_Mines.webm"
LaserMinesUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Mine.dds"
LaserMinesUpgrade.requirements		= { "engineer" }

function LaserMinesUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = LaserMinesUpgrade.cost
	self.upgradeName = LaserMinesUpgrade.upgradeName
	self.upgradeTitle = LaserMinesUpgrade.upgradeTitle
	self.upgradeDesc = LaserMinesUpgrade.upgradeDesc
	self.upgradeTechId = LaserMinesUpgrade.upgradeTechId
	self.hudSlot = LaserMinesUpgrade.hudSlot
	self.minPlayerLevel = LaserMinesUpgrade.minPlayerLevel
	self.rowOrder = LaserMinesUpgrade.rowOrder
	self.texture = LaserMinesUpgrade.texture
	self.vidDesc = LaserMinesUpgrade.vidDesc
	self.detailImage = LaserMinesUpgrade.detailImage
	self.requirements = LaserMinesUpgrade.requirements

end

function LaserMinesUpgrade:GetClassName()
	return "LaserMinesUpgrade"
end

function LaserMinesUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You bought " .. self:GetUpgradeTitle() .. "!")
end