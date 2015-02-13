//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// LightMachineGunUpgrade.lua
						
class 'LightMachineGunUpgrade' (CombatWeaponUpgrade)

LightMachineGunUpgrade.cost 			= { 0 }                           				// cost of the upgrade in points
LightMachineGunUpgrade.upgradeName 		= "lmg"                       					// Text code of the upgrade if using it via console
LightMachineGunUpgrade.upgradeTitle		= "COMBAT_UPGRADE_LMG"               							// Title of the upgrade, e.g. Submachine Gun
LightMachineGunUpgrade.upgradeDesc		= "COMBAT_UPGRADE_LMG_TOOLTIP"	// Description of the upgrade
LightMachineGunUpgrade.upgradeTechId 	= kTechId.LightMachineGun 	    							// TechId of the upgrade, default is kTechId.Move cause its the first entry
LightMachineGunUpgrade.hudSlot 			= kPrimaryWeaponSlot							// Is this a primary weapon?
LightMachineGunUpgrade.minPlayerLevel 	= 0
LightMachineGunUpgrade.menuPositionX	= 0
LightMachineGunUpgrade.menuPositionY	= 0
LightMachineGunUpgrade.texture 			= PrecacheAsset("ui/buymenu/Icons/Icon_LMG_Active.dds")
LightMachineGunUpgrade.vidDesc			= "videos/Marines_ReloadSpeed.webm"
LightMachineGunUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_LMG.dds"
LightMachineGunUpgrade.requirements		= {"scout","marine"}


function LightMachineGunUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = LightMachineGunUpgrade.cost
	self.upgradeName = LightMachineGunUpgrade.upgradeName
	self.upgradeTitle = LightMachineGunUpgrade.upgradeTitle
	self.upgradeDesc = LightMachineGunUpgrade.upgradeDesc
	self.upgradeTechId = LightMachineGunUpgrade.upgradeTechId
	self.hudSlot = LightMachineGunUpgrade.hudSlot
	self.minPlayerLevel = LightMachineGunUpgrade.minPlayerLevel
	self.menuPositionX = LightMachineGunUpgrade.menuPositionX
	self.menuPositionY = LightMachineGunUpgrade.menuPositionY
	self.texture = LightMachineGunUpgrade.texture
	self.vidDesc = LightMachineGunUpgrade.vidDesc
	self.detailImage = LightMachineGunUpgrade.detailImage
	self.requirements = LightMachineGunUpgrade.requirements	
	
end

function LightMachineGunUpgrade:GetClassName()
	return "LightMachineGunUpgrade"
end

function LightMachineGunUpgrade:GetHideUpgrade(upgradeList)
	if self:GetCurrentLevel() > 0 then
		return true
	else
		return false
	end
end