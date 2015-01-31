//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// PistolUpgrade.lua
						
class 'PistolUpgrade' (CombatWeaponUpgrade)

PistolUpgrade.cost 			= { 0 }                           				// cost of the upgrade in points
PistolUpgrade.upgradeName 	= "pistol"                       				// Text code of the upgrade if using it via console
PistolUpgrade.upgradeTitle	= "PISTOL"               						// Title of the upgrade, e.g. Submachine Gun
PistolUpgrade.upgradeDesc	= "PISTOL_TOOLTIP"								// Description of the upgrade
PistolUpgrade.upgradeTechId = kTechId.Pistol 	    						// TechId of the upgrade, default is kTechId.Move cause its the first entry
PistolUpgrade.hudSlot 		= kSecondaryWeaponSlot							// Is this a primary weapon?
PistolUpgrade.minPlayerLevel = 0
PistolUpgrade.menuPositionX	= 0
PistolUpgrade.menuPositionY	= 0
PistolUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Pistol_Active.dds")
PistolUpgrade.vidDesc		= "videos/Marines_ReloadSpeed.webm"
PistolUpgrade.detailImage	= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Pistol.dds"

function PistolUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = PistolUpgrade.cost
	self.upgradeName = PistolUpgrade.upgradeName
	self.upgradeTitle = PistolUpgrade.upgradeTitle
	self.upgradeDesc = PistolUpgrade.upgradeDesc
	self.upgradeTechId = PistolUpgrade.upgradeTechId
	self.hudSlot = PistolUpgrade.hudSlot
	self.minPlayerLevel = PistolUpgrade.minPlayerLevel
	self.menuPositionX = PistolUpgrade.menuPositionX
	self.menuPositionY = PistolUpgrade.menuPositionY
	self.texture = PistolUpgrade.texture
	self.vidDesc = PistolUpgrade.vidDesc
	self.detailImage = PistolUpgrade.detailImage
	
end

function PistolUpgrade:GetClassName()
	return "PistolUpgrade"
end

function PistolUpgrade:GetHideUpgrade(upgradeList)
	if self:GetCurrentLevel() > 0 then
		return true
	else
		return false
	end
end