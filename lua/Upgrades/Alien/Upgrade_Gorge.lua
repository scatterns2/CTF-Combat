//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// GorgeUpgrade is applied before anything else
						
class 'GorgeUpgrade' (CombatAlienClassUpgrade)

GorgeUpgrade.cost 			= { 0 }										// cost of the upgrade in points
GorgeUpgrade.upgradeName	= "gorge"	                        		// text code of the upgrade if using it via console
GorgeUpgrade.upgradeTitle 	= "GORGE"       							// Title of the upgrade, e.g. Submachine Gun
GorgeUpgrade.upgradeDesc 	= "GORGE_TOOLTIP"             				// Description of the upgrade
GorgeUpgrade.upgradeTechId 	= kTechId.Gorge  							// techId of the upgrade, default is kTechId.Move cause its the first 
GorgeUpgrade.minPlayerLevel = 0
GorgeUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Gorge_Active.dds")
GorgeUpgrade.vidDesc		= "videos/Aliens_Gorge.webm"
GorgeUpgrade.isClassUpgrade = true						--Lifeforms, Marine and Exo are all classes
GorgeUpgrade.rebuyCooldownTime = 10                                    // cooldown in sec
GorgeUpgrade.disallowedGameModes = { kCombatGameType.Infection }

function GorgeUpgrade:Initialize()

	CombatAlienClassUpgrade.Initialize(self)
	
	self.cost = GorgeUpgrade.cost
	self.upgradeName = GorgeUpgrade.upgradeName
	self.upgradeTitle = GorgeUpgrade.upgradeTitle
	self.upgradeDesc = GorgeUpgrade.upgradeDesc
	self.upgradeTechId = GorgeUpgrade.upgradeTechId
	self.minPlayerLevel = GorgeUpgrade.minPlayerLevel
	self.texture = GorgeUpgrade.texture
	self.vidDesc = GorgeUpgrade.vidDesc
	self.isClassUpgrade = GorgeUpgrade.isClassUpgrade
	self.rebuyCooldownTime = GorgeUpgrade.rebuyCooldownTime
	self.disallowedGameModes = GorgeUpgrade.disallowedGameModes
	self.needsNetworkMessage = true
	
end

function GorgeUpgrade:GetClassName()
	return "GorgeUpgrade"
end

function GorgeUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_Gorge_mask.dds", ""
end