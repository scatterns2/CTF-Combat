//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'UmbraUpgrade' (CombatAlienAbilityUpgrade)

UmbraUpgrade.cost 			= { 1 }                          				// cost of the upgrade in points
UmbraUpgrade.upgradeName	= "umbra"	                        			// text code of the upgrade if using it via console
UmbraUpgrade.upgradeTitle 	= "UMBRA"										// Title of the upgrade, e.g. Submachine Gun
UmbraUpgrade.upgradeDesc	= "UMBRA_TOOLTIP"				// Description of the upgrade
UmbraUpgrade.upgradeTechId	= kTechId.Umbra  								// techId of the upgrade, default is kTechId.Move cause its the first 
UmbraUpgrade.requirements  	= { "lerk" }										// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
UmbraUpgrade.minPlayerLevel = 2
UmbraUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Umbra_Active.dds")
UmbraUpgrade.vidDesc 		= ""

function UmbraUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = UmbraUpgrade.cost
	self.upgradeName = UmbraUpgrade.upgradeName
	self.upgradeTitle = UmbraUpgrade.upgradeTitle
	self.upgradeDesc = UmbraUpgrade.upgradeDesc
	self.upgradeTechId = UmbraUpgrade.upgradeTechId
	self.requirements = UmbraUpgrade.requirements
	self.minPlayerLevel = UmbraUpgrade.minPlayerLevel
	self.texture = UmbraUpgrade.texture
	self.vidDesc = UmbraUpgrade.vidDesc
	
end

function UmbraUpgrade:GetClassName()
	return "UmbraUpgrade"
end