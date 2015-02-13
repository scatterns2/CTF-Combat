//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'VortexUpgrade' (CombatAlienAbilityUpgrade)

VortexUpgrade.cost 			= { 1 }                          			// cost of the upgrade in points
VortexUpgrade.upgradeName	= "vortex"	                        		// text code of the upgrade if using it via console
VortexUpgrade.upgradeTitle 	= "VORTEX"									// Title of the upgrade, e.g. Submachine Gun
VortexUpgrade.upgradeDesc	= "COMBAT_UPGRADE_VORTEX"					// Description of the upgrade
VortexUpgrade.upgradeTechId	= kTechId.Vortex							// techId of the upgrade, default is kTechId.Move cause its the first 
VortexUpgrade.requirements  = { "fade" }								// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
VortexUpgrade.minPlayerLevel = 4
VortexUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Vortex_Active.dds")
VortexUpgrade.vidDesc 		= ""

function VortexUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = VortexUpgrade.cost
	self.upgradeName = VortexUpgrade.upgradeName
	self.upgradeTitle = VortexUpgrade.upgradeTitle
	self.upgradeDesc = VortexUpgrade.upgradeDesc
	self.upgradeTechId = VortexUpgrade.upgradeTechId
	self.requirements = VortexUpgrade.requirements
	self.minPlayerLevel = VortexUpgrade.minPlayerLevel
	self.texture = VortexUpgrade.texture
	self.vidDesc = VortexUpgrade.vidDesc
	
end

function VortexUpgrade:GetClassName()
	return "VortexUpgrade"
end