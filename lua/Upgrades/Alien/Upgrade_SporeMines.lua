//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
// Alien Upgrades
						
class 'SporeMineUpgrade' (CombatAlienAbilityUpgrade)

SporeMineUpgrade.cost 			= { 1 }                          				// cost of the upgrade in points
SporeMineUpgrade.upgradeName	= "sporemine"	                        			// text code of the upgrade if using it via console
SporeMineUpgrade.upgradeTitle = "COMBAT_UPGRADE_SPORE_MINE"						// Title of the upgrade, e.g. Submachine Gun
SporeMineUpgrade.upgradeDesc	= "COMBAT_UPGRADE_SPORE_MINE_TOOLTIP"				// Description of the upgrade
SporeMineUpgrade.upgradeTechId = kTechId.SporeMineAbility  								// techId of the upgrade, default is kTechId.Move cause its the first 
SporeMineUpgrade.requirements  = { "gorge" }										// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
SporeMineUpgrade.minPlayerLevel = 4
SporeMineUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Sporemine_Active.dds")
SporeMineUpgrade.vidDesc 		= ""

function SporeMineUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = SporeMineUpgrade.cost
	self.upgradeName = SporeMineUpgrade.upgradeName
	self.upgradeTitle = SporeMineUpgrade.upgradeTitle
	self.upgradeDesc = SporeMineUpgrade.upgradeDesc
	self.upgradeTechId = SporeMineUpgrade.upgradeTechId
	self.requirements = SporeMineUpgrade.requirements
	self.minPlayerLevel = SporeMineUpgrade.minPlayerLevel
	self.texture = SporeMineUpgrade.texture
	self.vidDesc = SporeMineUpgrade.vidDesc
	
end

function SporeMineUpgrade:GetClassName()
	return "SporeMineUpgrade"
end