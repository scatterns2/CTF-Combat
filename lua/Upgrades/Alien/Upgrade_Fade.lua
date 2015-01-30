//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// FadeUpgrade is applied before anything else
						
class 'FadeUpgrade' (CombatAlienClassUpgrade)

FadeUpgrade.cost 			= { 0 }                          		// cost of the upgrade in upgrade points
FadeUpgrade.upgradeName		= "fade"								// text code of the upgrade if using it via console
FadeUpgrade.upgradeTitle 	= "FADE"       							// Title of the upgrade, e.g. Submachine Gun
FadeUpgrade.upgradeDesc 	= "FADE_TOOLTIP"             		// Description of the upgrade
FadeUpgrade.upgradeTechId 	= kTechId.Fade  						// techId of the upgrade, default is kTechId.Move cause its the first
FadeUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Fade_Active.dds")
FadeUpgrade.minPlayerLevel 	= 1
FadeUpgrade.vidDesc			= "videos/Aliens_Fade.webm"
FadeUpgrade.isClassUpgrade = true						--Lifeforms, Marine and Exo are all classes
FadeUpgrade.rebuyCooldownTime = 60
FadeUpgrade.disallowedGameModes = { kCombatGameType.Infection }

function FadeUpgrade:Initialize()

	CombatAlienClassUpgrade.Initialize(self)
	
	self.cost = FadeUpgrade.cost
	self.upgradeName = FadeUpgrade.upgradeName
	self.upgradeTitle = FadeUpgrade.upgradeTitle
	self.upgradeDesc = FadeUpgrade.upgradeDesc
	self.upgradeTechId = FadeUpgrade.upgradeTechId
	self.texture = FadeUpgrade.texture
	self.minPlayerLevel = FadeUpgrade.minPlayerLevel
	self.vidDesc = FadeUpgrade.vidDesc
	self.isClassUpgrade = FadeUpgrade.isClassUpgrade
	self.rebuyCooldownTime = FadeUpgrade.rebuyCooldownTime
	self.disallowedGameModes = FadeUpgrade.disallowedGameModes
	self.needsNetworkMessage = true
	
end

function FadeUpgrade:GetClassName()
	return "FadeUpgrade"
end


function FadeUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_Fade_mask.dds", ""
end