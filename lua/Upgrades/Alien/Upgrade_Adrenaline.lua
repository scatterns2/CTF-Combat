//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'AdrenalineUpgrade' (CombatAlienUpgrade)

AdrenalineUpgrade.cost 				= { 2 }                     // cost of the upgrade in upgrade points
AdrenalineUpgrade.upgradeName		= "adrenaline"	            // text code of the upgrade if using it via console
AdrenalineUpgrade.upgradeTitle 		= "ADRENALINE"       		// Title of the upgrade, e.g. Submachine Gun
AdrenalineUpgrade.upgradeDesc 		= "ADRENALINE_TOOLTIP" 	// Description of the upgrade
AdrenalineUpgrade.upgradeTechId 	= kTechId.Adrenaline  		// techId of the upgrade, default is kTechId.Move cause its the first 
AdrenalineUpgrade.minPlayerLevel 	= 4
AdrenalineUpgrade.texture 			= PrecacheAsset("ui/buymenu/Icons/Icon_Adrenaline_Active.dds")
AdrenalineUpgrade.vidDesc 			= "videos/Aliens_Adrenaline.webm"
AdrenalineUpgrade.upgradeType 		= kCombatUpgradeTypes.Offense

function AdrenalineUpgrade:Initialize()

	CombatAlienUpgrade.Initialize(self)
	
	self.cost = AdrenalineUpgrade.cost
	self.upgradeName = AdrenalineUpgrade.upgradeName
	self.upgradeTitle = AdrenalineUpgrade.upgradeTitle
	self.upgradeDesc = AdrenalineUpgrade.upgradeDesc
	self.upgradeTechId = AdrenalineUpgrade.upgradeTechId
	self.minPlayerLevel = AdrenalineUpgrade.minPlayerLevel
	self.texture = AdrenalineUpgrade.texture
	self.vidDesc = AdrenalineUpgrade.vidDesc
	self.upgradeType = AdrenalineUpgrade.upgradeType
	
end

function AdrenalineUpgrade:GetClassName()
	return "AdrenalineUpgrade"
end