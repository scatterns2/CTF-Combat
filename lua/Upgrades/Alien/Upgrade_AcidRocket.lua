//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'AcidRocketUpgrade' (CombatAlienAbilityUpgrade)

AcidRocketUpgrade.cost 			= { 1 }                          			// cost of the upgrade in points
AcidRocketUpgrade.upgradeName	= "acidrocket"	                        	// text code of the upgrade if using it via console
AcidRocketUpgrade.upgradeTitle 	= "COMBAT_UPGRADE_ACID_ROCKET"				// Title of the upgrade, e.g. Submachine Gun
AcidRocketUpgrade.upgradeDesc	= "COMBAT_UPGRADE_ACID_ROCKET_TOOLTIP"		// Description of the upgrade
AcidRocketUpgrade.upgradeTechId	= kTechId.AcidRocket						// techId of the upgrade, default is kTechId.Move cause its the first 
AcidRocketUpgrade.requirements  = { "fade" }								// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
AcidRocketUpgrade.minPlayerLevel = 7
AcidRocketUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_AcidRocket_Active.dds")
AcidRocketUpgrade.disallowedGameModes = { kCombatGameType.Infection }
AcidRocketUpgrade.vidDesc 		= ""

function AcidRocketUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = AcidRocketUpgrade.cost
	self.upgradeName = AcidRocketUpgrade.upgradeName
	self.upgradeTitle = AcidRocketUpgrade.upgradeTitle
	self.upgradeDesc = AcidRocketUpgrade.upgradeDesc
	self.upgradeTechId = AcidRocketUpgrade.upgradeTechId
	self.requirements = AcidRocketUpgrade.requirements
	self.minPlayerLevel = AcidRocketUpgrade.minPlayerLevel
	self.texture = AcidRocketUpgrade.texture
	self.vidDesc = AcidRocketUpgrade.vidDesc
	self.disallowedGameModes = AcidRocketUpgrade.disallowedGameModes
	
end

function AcidRocketUpgrade:GetClassName()
	return "AcidRocketUpgrade"
end