//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// OnosUpgrade is applied before anything else
						
class 'OnosUpgrade' (CombatAlienClassUpgrade)

OnosUpgrade.cost 			= { 0 }                          			// cost of the upgrade in points
OnosUpgrade.upgradeName		= "onos"	                        		// text code of the upgrade if using it via console
OnosUpgrade.upgradeTitle 	= "ONOS"       								// Title of the upgrade, e.g. Submachine Gun
OnosUpgrade.upgradeDesc 	= "ONOS_TOOLTIP"             		// Description of the upgrade
OnosUpgrade.upgradeTechId 	= kTechId.Onos  							// techId of the upgrade, default is kTechId.Move cause its the first 
OnosUpgrade.minPlayerLevel 	= 0
OnosUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Onos_Active.dds")
OnosUpgrade.vidDesc			= "videos/Aliens_Onos.webm"
OnosUpgrade.isClassUpgrade = true						--Lifeforms, Marine and Exo are all classes
OnosUpgrade.rebuyCooldownTime = 90
OnosUpgrade.disallowedGameModes = { kCombatGameType.Infection }

function OnosUpgrade:Initialize()

	CombatAlienClassUpgrade.Initialize(self)
	
	self.cost = OnosUpgrade.cost
	self.upgradeName = OnosUpgrade.upgradeName
	self.upgradeTitle = OnosUpgrade.upgradeTitle
	self.upgradeDesc = OnosUpgrade.upgradeDesc
	self.upgradeTechId = OnosUpgrade.upgradeTechId
	self.minPlayerLevel = OnosUpgrade.minPlayerLevel
	self.texture = OnosUpgrade.texture
	self.vidDesc = OnosUpgrade.vidDesc
	self.isClassUpgrade = OnosUpgrade.isClassUpgrade
    self.rebuyCooldownTime = OnosUpgrade.rebuyCooldownTime
	self.disallowedGameModes = OnosUpgrade.disallowedGameModes
    self.needsNetworkMessage = true
	
end

function OnosUpgrade:GetClassName()
	return "OnosUpgrade"
end
function OnosUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_Onos_Mask.dds", ""
end