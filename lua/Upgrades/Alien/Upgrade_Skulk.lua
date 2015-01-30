//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// SkulkUpgrade is applied before anything else
						
class 'SkulkUpgrade' (CombatAlienClassUpgrade)

SkulkUpgrade.cost 				= { 0 }             	// cost of the upgrade in points
SkulkUpgrade.upgradeName		= "skulk"				// text code of the upgrade if using it via console
SkulkUpgrade.upgradeTitle 		= "SKULK"				// Title of the upgrade, e.g. Submachine Gun
SkulkUpgrade.upgradeDesc 		= "SKULK_TOOLTIP"	// Description of the upgrade
SkulkUpgrade.upgradeTechId 		= kTechId.Skulk  		// techId of the upgrade, default is kTechId.Move cause its the first 
SkulkUpgrade.minPlayerLevel 	= 0
SkulkUpgrade.texture 			= PrecacheAsset("ui/buymenu/Icons/Icon_Skulk_Active.dds")
SkulkUpgrade.vidDesc			= "videos/Aliens_Skulk.webm"
SkulkUpgrade.isClassUpgrade = true						--Lifeforms, Marine and Exo are all classes
SkulkUpgrade.requirements = {}

function SkulkUpgrade:Initialize()

	CombatAlienClassUpgrade.Initialize(self)
	
	self.cost = SkulkUpgrade.cost
	self.upgradeName = SkulkUpgrade.upgradeName
	self.upgradeTitle = SkulkUpgrade.upgradeTitle
	self.upgradeDesc = SkulkUpgrade.upgradeDesc
	self.upgradeTechId = SkulkUpgrade.upgradeTechId
	self.minPlayerLevel = SkulkUpgrade.minPlayerLevel
	self.texture = SkulkUpgrade.texture
	self.vidDesc = SkulkUpgrade.vidDesc
	self.isClassUpgrade = SkulkUpgrade.isClassUpgrade
	self.requirements = SkulkUpgrade.requirements
	self.needsNetworkMessage = true
	
end

function SkulkUpgrade:GetClassName()
	return "SkulkUpgrade"
end

function SkulkUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_Skulk_mask.dds", ""
end