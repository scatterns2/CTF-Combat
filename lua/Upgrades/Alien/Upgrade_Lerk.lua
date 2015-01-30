//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// LerkUpgrade is applied before anything else
						
class 'LerkUpgrade' (CombatAlienClassUpgrade)

LerkUpgrade.cost 			= { 0 }                          			// cost of the upgrade in points
LerkUpgrade.upgradeName		= "lerk"	                        		// text code of the upgrade if using it via console
LerkUpgrade.upgradeTitle 	= "LERK"       								// Title of the upgrade, e.g. Submachine Gun
LerkUpgrade.upgradeDesc 	= "LERK_TOOLTIP"             			// Description of the upgrade
LerkUpgrade.upgradeTechId 	= kTechId.Lerk  							// techId of the upgrade, default is kTechId.Move cause its the first 
LerkUpgrade.minPlayerLevel 	= 0
LerkUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Lerk_Active.dds")
LerkUpgrade.vidDesc			= "videos/Aliens_Lerk.webm"
LerkUpgrade.isClassUpgrade = true	
LerkUpgrade.rebuyCooldownTime = 30  					--Lifeforms, Marine and Exo are all classes
LerkUpgrade.disallowedGameModes = { kCombatGameType.Infection }

function LerkUpgrade:Initialize()

	CombatAlienClassUpgrade.Initialize(self)
	
	self.cost = LerkUpgrade.cost
	self.upgradeName = LerkUpgrade.upgradeName
	self.upgradeTitle = LerkUpgrade.upgradeTitle
	self.upgradeDesc = LerkUpgrade.upgradeDesc
	self.upgradeTechId = LerkUpgrade.upgradeTechId
	self.minPlayerLevel = LerkUpgrade.minPlayerLevel
	self.texture = LerkUpgrade.texture
	self.vidDesc = LerkUpgrade.vidDesc
	self.isClassUpgrade = LerkUpgrade.isClassUpgrade
	self.rebuyCooldownTime = LerkUpgrade.rebuyCooldownTime
	self.disallowedGameModes = LerkUpgrade.disallowedGameModes
	self.needsNetworkMessage = true
	
end

function LerkUpgrade:GetClassName()
	return "LerkUpgrade"
end

function LerkUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_Lerk_mask.dds", ""
end