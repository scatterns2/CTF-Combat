//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'StompUpgrade' (CombatAlienAbilityUpgrade)

StompUpgrade.cost 			= { 1 }                          					// cost of the upgrade in points
StompUpgrade.upgradeName	= "stomp"	                        				// text code of the upgrade if using it via console
StompUpgrade.upgradeTitle	= "STOMP"											// Title of the upgrade, e.g. Submachine Gun
StompUpgrade.upgradeDesc	= "STOMP_TOOLTIP"									// Description of the upgrade
StompUpgrade.upgradeTechId = kTechId.Stomp  									// techId of the upgrade, default is kTechId.Move cause its the first 
StompUpgrade.requirements  = { "onos" }											// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
StompUpgrade.minPlayerLevel = 10
StompUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Stomp_Active.dds")
StompUpgrade.vidDesc 		= ""

function StompUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = StompUpgrade.cost
	self.upgradeName = StompUpgrade.upgradeName
	self.upgradeTitle = StompUpgrade.upgradeTitle
	self.upgradeDesc = StompUpgrade.upgradeDesc
	self.upgradeTechId = StompUpgrade.upgradeTechId
	self.requirements = StompUpgrade.requirements
	self.minPlayerLevel = StompUpgrade.minPlayerLevel
	self.texture = StompUpgrade.texture
	self.vidDesc = StompUpgrade.vidDesc
	
end

function StompUpgrade:GetClassName()
	return "StompUpgrade"
end

function StompUpgrade:OnAdd(player, isReapply)
	player:SetHasOneHive(true)
	player:SetHasTwoHives(true)
    player.twoHives = true
end