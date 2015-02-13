//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
// Alien Upgrades
						
class 'CelerityUpgrade' (CombatAlienUpgrade)

CelerityUpgrade.cost 			= { 1 }					// cost of the upgrade in upgrade points
CelerityUpgrade.upgradeName		= "celerity"					// text code of the upgrade if using it via console
CelerityUpgrade.upgradeTitle 	= "CELERITY"					// Title of the upgrade, e.g. Submachine Gun
CelerityUpgrade.upgradeDesc 	= "CELERITY_TOOLTIP"	// Description of the upgrade
CelerityUpgrade.upgradeTechId 	= kTechId.Celerity				// techId of the upgrade, default is kTechId.Move cause its the first 
CelerityUpgrade.minPlayerLevel 	= 1
CelerityUpgrade.texture = PrecacheAsset("ui/buymenu/Icons/Icon_Celerity_Active.dds")
CelerityUpgrade.vidDesc	= "videos/Aliens_Celerity.webm"
CelerityUpgrade.upgradeType = kCombatUpgradeTypes.Defense

function CelerityUpgrade:Initialize()

	CombatAlienUpgrade.Initialize(self)
	
	self.cost = CelerityUpgrade.cost
	self.upgradeName = CelerityUpgrade.upgradeName
	self.upgradeTitle = CelerityUpgrade.upgradeTitle
	self.upgradeDesc = CelerityUpgrade.upgradeDesc
	self.upgradeTechId = CelerityUpgrade.upgradeTechId
	self.minPlayerLevel = CelerityUpgrade.minPlayerLevel
	self.texture = CelerityUpgrade.texture
	self.vidDesc = CelerityUpgrade.vidDesc
	self.upgradeType = CelerityUpgrade.upgradeType
	
end

function CelerityUpgrade:GetLevelString(level, player)
	return GetTranslationString("COMBAT_UPGRADE_CELERITY_LEVEL", {percent = level * kCelerityAddSpeed * 10})
end

function CelerityUpgrade:GetClassName()
	return "CelerityUpgrade"
end