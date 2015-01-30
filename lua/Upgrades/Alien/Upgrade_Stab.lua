//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'StabUpgrade' (CombatAlienAbilityUpgrade)

StabUpgrade.cost 			= { 1 }                          				// cost of the upgrade in points
StabUpgrade.upgradeName		= "Stab"	                        			// text code of the upgrade if using it via console
StabUpgrade.upgradeTitle 	= "STAB_BLINK"										// Title of the upgrade, e.g. Submachine Gun
StabUpgrade.upgradeDesc		= "STAB_TOOLTIP"					// Description of the upgrade
StabUpgrade.upgradeTechId 	= kTechId.Stab  								// techId of the upgrade, default is kTechId.Move cause its the first 
StabUpgrade.requirements 	= { "fade" }									// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
StabUpgrade.minPlayerLevel	= 7
StabUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Stab_Active.dds")
StabUpgrade.vidDesc 		= ""

function StabUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = StabUpgrade.cost
	self.upgradeName = StabUpgrade.upgradeName
	self.upgradeTitle = StabUpgrade.upgradeTitle
	self.upgradeDesc = StabUpgrade.upgradeDesc
	self.upgradeTechId = StabUpgrade.upgradeTechId
	self.requirements = StabUpgrade.requirements
	self.minPlayerLevel = StabUpgrade.minPlayerLevel
	self.texture = StabUpgrade.texture
	self.vidDesc = StabUpgrade.vidDesc
	
end

function StabUpgrade:GetClassName()
	return "StabUpgrade"
end