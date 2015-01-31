//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// RevolverUpgrade.lua
						
class 'RevolverUpgrade' (CombatWeaponUpgrade)

RevolverUpgrade.cost 			= { 0 }                           				// cost of the upgrade in points
RevolverUpgrade.upgradeName 	= "revolver"                       				// Text code of the upgrade if using it via console
RevolverUpgrade.upgradeTitle	= "COMBAT_UPGRADE_REVOLVER"               		// Title of the upgrade, e.g. Submachine Gun
RevolverUpgrade.upgradeDesc		= "COMBAT_UPGRADE_REVOLVER_TOOLTIP"				// Description of the upgrade
RevolverUpgrade.upgradeTechId 	= kTechId.Revolver 	    						// TechId of the upgrade, default is kTechId.Move cause its the first entry
RevolverUpgrade.hudSlot 		= kPrimaryWeaponSlot							// Is this a primary weapon?
RevolverUpgrade.minPlayerLevel 	= 0
RevolverUpgrade.menuPositionX	= 0
RevolverUpgrade.menuPositionY	= 0
RevolverUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Revolver_Active.dds")
RevolverUpgrade.vidDesc			= "videos/Marines_ReloadSpeed.webm"
RevolverUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Revolver.dds"
RevolverUpgrade.requirements	= { "engineer"}

function RevolverUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = RevolverUpgrade.cost
	self.upgradeName = RevolverUpgrade.upgradeName
	self.upgradeTitle = RevolverUpgrade.upgradeTitle
	self.upgradeDesc = RevolverUpgrade.upgradeDesc
	self.upgradeTechId = RevolverUpgrade.upgradeTechId
	self.hudSlot = RevolverUpgrade.hudSlot
	self.minPlayerLevel = RevolverUpgrade.minPlayerLevel
	self.menuPositionX = RevolverUpgrade.menuPositionX
	self.menuPositionY = RevolverUpgrade.menuPositionY
	self.texture = RevolverUpgrade.texture
	self.vidDesc = RevolverUpgrade.vidDesc
	self.detailImage = RevolverUpgrade.detailImage
	self.requirements = RevolverUpgrade.requirements
	
end

function RevolverUpgrade:GetClassName()
	return "RevolverUpgrade"
end

function RevolverUpgrade:GetHideUpgrade(upgradeList)
	if self:GetCurrentLevel() > 0 then
		return true
	else
		return false
	end
end