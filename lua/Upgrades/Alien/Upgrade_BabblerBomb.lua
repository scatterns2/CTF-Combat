//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'BabblerBombUpgrade' (CombatAlienAbilityUpgrade)

BabblerBombUpgrade.cost 		= { 1 }                          					// cost of the upgrade in points
BabblerBombUpgrade.upgradeName	= "babblerbomb"	                        			// text code of the upgrade if using it via console
BabblerBombUpgrade.upgradeTitle = "COMBAT_UPGRADE_BABBLER_BOMB"						// Title of the upgrade, e.g. Submachine Gun
BabblerBombUpgrade.upgradeDesc	= "COMBAT_UPGRADE_BABBLER_BOMB_TOOLTIP"				// Description of the upgrade
BabblerBombUpgrade.upgradeTechId = kTechId.BabblerBombAbility  						// techId of the upgrade, default is kTechId.Move cause its the first 
BabblerBombUpgrade.requirements  = { "gorge" }										// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
BabblerBombUpgrade.minPlayerLevel = 4
BabblerBombUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Babbler_Active.dds")
BabblerBombUpgrade.vidDesc 		= ""

function BabblerBombUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = BabblerBombUpgrade.cost
	self.upgradeName = BabblerBombUpgrade.upgradeName
	self.upgradeTitle = BabblerBombUpgrade.upgradeTitle
	self.upgradeDesc = BabblerBombUpgrade.upgradeDesc
	self.upgradeTechId = BabblerBombUpgrade.upgradeTechId
	self.requirements = BabblerBombUpgrade.requirements
	self.minPlayerLevel = BabblerBombUpgrade.minPlayerLevel
	self.texture = BabblerBombUpgrade.texture
	self.vidDesc = BabblerBombUpgrade.vidDesc
	
end

function BabblerBombUpgrade:GetClassName()
	return "BabblerBombUpgrade"
end