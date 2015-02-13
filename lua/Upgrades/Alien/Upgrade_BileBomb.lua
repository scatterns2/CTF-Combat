//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'BileBombUpgrade' (CombatAlienAbilityUpgrade)

BileBombUpgrade.cost 			= { 1 }                          				// cost of the upgrade in points
BileBombUpgrade.upgradeName	= "bilebomb"	                        			// text code of the upgrade if using it via console
BileBombUpgrade.upgradeTitle = "BILEBOMB"						// Title of the upgrade, e.g. Submachine Gun
BileBombUpgrade.upgradeDesc	= "BILEBOMB_TOOLTIP"				// Description of the upgrade
BileBombUpgrade.upgradeTechId = kTechId.BileBomb  								// techId of the upgrade, default is kTechId.Move cause its the first 
BileBombUpgrade.requirements  = { "gorge" }										// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
BileBombUpgrade.minPlayerLevel = 2
BileBombUpgrade.uniqueSlot 		= kUpgradeUniqueSlot.Weapon2
BileBombUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_BileBomb_Active.dds")
BileBombUpgrade.vidDesc 		= ""

function BileBombUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = BileBombUpgrade.cost
	self.upgradeName = BileBombUpgrade.upgradeName
	self.upgradeTitle = BileBombUpgrade.upgradeTitle
	self.upgradeDesc = BileBombUpgrade.upgradeDesc
	self.upgradeTechId = BileBombUpgrade.upgradeTechId
	self.requirements = BileBombUpgrade.requirements
	self.minPlayerLevel = BileBombUpgrade.minPlayerLevel
	self.uniqueSlot = BileBombUpgrade.uniqueSlot
	self.texture = BileBombUpgrade.texture
	self.vidDesc = BileBombUpgrade.vidDesc
	
end

function BileBombUpgrade:GetClassName()
	return "BileBombUpgrade"
end