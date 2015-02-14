//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
// Alien Upgrades
						
class 'BoneShieldUpgrade' (CombatAlienAbilityUpgrade)

BoneShieldUpgrade.cost 			= { 1 }                          					// cost of the upgrade in points
BoneShieldUpgrade.upgradeName	= "boneshield"	                        			// text code of the upgrade if using it via console
BoneShieldUpgrade.upgradeTitle	= "BONESHIELD"										// Title of the upgrade, e.g. Submachine Gun
BoneShieldUpgrade.upgradeDesc	= "BONESHIELD_TOOLTIP"								// Description of the upgrade
BoneShieldUpgrade.upgradeTechId = kTechId.BoneShield  								// techId of the upgrade, default is kTechId.Move cause its the first 
BoneShieldUpgrade.requirements  = { "onos" }										// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
BoneShieldUpgrade.minPlayerLevel = 1
BoneShieldUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Boneshield_Active.dds")
BoneShieldUpgrade.vidDesc 		= ""

function BoneShieldUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = BoneShieldUpgrade.cost
	self.upgradeName = BoneShieldUpgrade.upgradeName
	self.upgradeTitle = BoneShieldUpgrade.upgradeTitle
	self.upgradeDesc = BoneShieldUpgrade.upgradeDesc
	self.upgradeTechId = BoneShieldUpgrade.upgradeTechId
	self.requirements = BoneShieldUpgrade.requirements
	self.minPlayerLevel = BoneShieldUpgrade.minPlayerLevel
	self.texture = BoneShieldUpgrade.texture
	self.vidDesc = BoneShieldUpgrade.vidDesc
	
end

function BoneShieldUpgrade:GetClassName()
	return "BoneShieldUpgrade"
end