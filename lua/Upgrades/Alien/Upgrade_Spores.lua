//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'SporesUpgrade' (CombatAlienAbilityUpgrade)

SporesUpgrade.cost 			= { 1 }                          				// cost of the upgrade in points
SporesUpgrade.upgradeName	= "spores"	                        			// text code of the upgrade if using it via console
SporesUpgrade.upgradeTitle 	= "SPORES"										// Title of the upgrade, e.g. Submachine Gun
SporesUpgrade.upgradeDesc	= "SPORES_TOOLTIP"			// Description of the upgrade
SporesUpgrade.upgradeTechId	= kTechId.Spores  								// techId of the upgrade, default is kTechId.Move cause its the first 
SporesUpgrade.requirements  = { "lerk" }									// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
SporesUpgrade.minPlayerLevel = 2
SporesUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Spores_Active.dds")
SporesUpgrade.vidDesc 		= ""

function SporesUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = SporesUpgrade.cost
	self.upgradeName = SporesUpgrade.upgradeName
	self.upgradeTitle = SporesUpgrade.upgradeTitle
	self.upgradeDesc = SporesUpgrade.upgradeDesc
	self.upgradeTechId = SporesUpgrade.upgradeTechId
	self.requirements = SporesUpgrade.requirements
	self.minPlayerLevel = SporesUpgrade.minPlayerLevel
	self.texture = SporesUpgrade.texture
	self.vidDesc = SporesUpgrade.vidDesc
	
end

function SporesUpgrade:GetClassName()
	return "SporesUpgrade"
end