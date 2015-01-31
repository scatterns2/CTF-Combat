//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// RifleUpgrade.lua
						
class 'RifleUpgrade' (CombatWeaponUpgrade)

RifleUpgrade.cost 			= { 1 }                           				// cost of the upgrade in points
RifleUpgrade.upgradeName 	= "rifle"                       				// Text code of the upgrade if using it via console
RifleUpgrade.upgradeTitle	= "RIFLE"               						// Title of the upgrade, e.g. Submachine Gun
RifleUpgrade.upgradeDesc	= "RIFLE_UPGRADE"	// Description of the upgrade
RifleUpgrade.upgradeTechId 	= kTechId.Rifle 	    						// TechId of the upgrade, default is kTechId.Move cause its the first entry
RifleUpgrade.hudSlot 		= kPrimaryWeaponSlot							// Is this a primary weapon?
RifleUpgrade.minPlayerLevel = 1
RifleUpgrade.menuPositionX	= 0
RifleUpgrade.menuPositionY	= 0
RifleUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Rifle_Active.dds")
RifleUpgrade.vidDesc		= "videos/Marines_ReloadSpeed.webm"
RifleUpgrade.detailImage	= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Rifle1.dds"

function RifleUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = RifleUpgrade.cost
	self.upgradeName = RifleUpgrade.upgradeName
	self.upgradeTitle = RifleUpgrade.upgradeTitle
	self.upgradeDesc = RifleUpgrade.upgradeDesc
	self.upgradeTechId = RifleUpgrade.upgradeTechId
	self.hudSlot = RifleUpgrade.hudSlot
	self.minPlayerLevel = RifleUpgrade.minPlayerLevel
	self.menuPositionX = RifleUpgrade.menuPositionX
	self.menuPositionY = RifleUpgrade.menuPositionY
	self.texture = RifleUpgrade.texture
	self.hideUpgrade = RifleUpgrade.hideUpgrade
	self.vidDesc = RifleUpgrade.vidDesc
	self.detailImage = RifleUpgrade.detailImage
	
end

function RifleUpgrade:GetClassName()
	return "RifleUpgrade"
end

function RifleUpgrade:GetHideUpgrade(upgradeList)
	if self:GetCurrentLevel() > 0 then
		return true
	elseif upgradeList and not upgradeList:GetHasUpgradeByName("lmg") then
		return true
	else
		return false
	end
end