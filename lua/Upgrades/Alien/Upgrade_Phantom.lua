//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
// Alien Upgrades
						
class 'PhantomUpgrade' (CombatAlienUpgrade)

PhantomUpgrade.cost 			= { 2 }    									// cost of the upgrade in upgrade points
PhantomUpgrade.upgradeName		= "phantom"	                				// text code of the upgrade if using it via console
PhantomUpgrade.upgradeTitle 	= "PHANTOM"       							// Title of the upgrade, e.g. Submachine Gun
PhantomUpgrade.upgradeDesc 		= "PHANTOM_TOOLTIP"	// Description of the upgrade
PhantomUpgrade.upgradeTechId 	= kTechId.Phantom							// techId of the upgrade, default is kTechId.Move cause its the first 
PhantomUpgrade.minPlayerLevel 	= 2
PhantomUpgrade.texture 			= PrecacheAsset("ui/buymenu/Icons/Icon_Phantom_Active.dds")
PhantomUpgrade.vidDesc 			= "videos/Aliens_Phantom.webm"
PhantomUpgrade.upgradeType = kCombatUpgradeTypes.Defense

function PhantomUpgrade:Initialize()

	CombatAlienUpgrade.Initialize(self)
	
	self.cost = PhantomUpgrade.cost
	self.upgradeName = PhantomUpgrade.upgradeName
	self.upgradeTitle = PhantomUpgrade.upgradeTitle
	self.upgradeDesc = PhantomUpgrade.upgradeDesc
	self.upgradeTechId = PhantomUpgrade.upgradeTechId
	self.minPlayerLevel = PhantomUpgrade.minPlayerLevel
	self.texture = PhantomUpgrade.texture
	self.vidDesc = PhantomUpgrade.vidDesc
	self.upgradeType = PhantomUpgrade.upgradeType
	
end

function PhantomUpgrade:GetClassName()
	return "PhantomUpgrade"
end