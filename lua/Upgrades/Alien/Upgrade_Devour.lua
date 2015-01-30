//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'DevourUpgrade' (CombatAlienAbilityUpgrade)

DevourUpgrade.cost 			= { 1 }                          					// cost of the upgrade in points
DevourUpgrade.upgradeName	= "devour"	                        				// text code of the upgrade if using it via console
DevourUpgrade.upgradeTitle	= "COMBAT_UPGRADE_DEVOUR"											// Title of the upgrade, e.g. Submachine Gun
DevourUpgrade.upgradeDesc	= "COMBAT_UPGRADE_DEVOUR_TOOLTIP"	// Description of the upgrade
DevourUpgrade.upgradeTechId = kTechId.Devour  									// techId of the upgrade, default is kTechId.Move cause its the first 
DevourUpgrade.requirements  = { "onos" }										// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
DevourUpgrade.minPlayerLevel = 10
DevourUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Devour_Active.dds")
DevourUpgrade.vidDesc 		= ""

function DevourUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = DevourUpgrade.cost
	self.upgradeName = DevourUpgrade.upgradeName
	self.upgradeTitle = DevourUpgrade.upgradeTitle
	self.upgradeDesc = DevourUpgrade.upgradeDesc
	self.upgradeTechId = DevourUpgrade.upgradeTechId
	self.requirements = DevourUpgrade.requirements
	self.minPlayerLevel = DevourUpgrade.minPlayerLevel
	self.texture = DevourUpgrade.texture
	self.vidDesc = DevourUpgrade.vidDesc
	
end

function DevourUpgrade:GetClassName()
	return "DevourUpgrade"
end