//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'XenocideUpgrade' (CombatAlienAbilityUpgrade)

XenocideUpgrade.cost 			= { 1 }                          					// cost of the upgrade in points
XenocideUpgrade.upgradeName	= "xenocide"	                        				// text code of the upgrade if using it via console
XenocideUpgrade.upgradeTitle = "XENOCIDE"											// Title of the upgrade, e.g. Submachine Gun
XenocideUpgrade.upgradeDesc	= "XENOCIDE_TOOLTIP"		// Description of the upgrade
XenocideUpgrade.upgradeTechId = kTechId.Xenocide  									// techId of the upgrade, default is kTechId.Move cause its the first 
XenocideUpgrade.requirements  = { "skulk" }											// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
XenocideUpgrade.minPlayerLevel = 6
XenocideUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Xenocide_Active.dds")
XenocideUpgrade.vidDesc 		= ""

function XenocideUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = XenocideUpgrade.cost
	self.upgradeName = XenocideUpgrade.upgradeName
	self.upgradeTitle = XenocideUpgrade.upgradeTitle
	self.upgradeDesc = XenocideUpgrade.upgradeDesc
	self.upgradeTechId = XenocideUpgrade.upgradeTechId
	self.requirements = XenocideUpgrade.requirements
	self.minPlayerLevel = XenocideUpgrade.minPlayerLevel
	self.texture = XenocideUpgrade.texture
	self.vidDesc = XenocideUpgrade.vidDesc
	
end

function XenocideUpgrade:GetClassName()
	return "XenocideUpgrade"
end