//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'LeapUpgrade' (CombatAlienAbilityUpgrade)

LeapUpgrade.cost 			= { 1 }                          				// cost of the upgrade in points
LeapUpgrade.upgradeName	= "leap"	                        				// text code of the upgrade if using it via console
LeapUpgrade.upgradeTitle = "LEAP"											// Title of the upgrade, e.g. Submachine Gun
LeapUpgrade.upgradeDesc	= "LEAP_TOOLTIP"			// Description of the upgrade
LeapUpgrade.upgradeTechId = kTechId.Leap  									// techId of the upgrade, default is kTechId.Move cause its the first 
LeapUpgrade.requirements  = { "skulk" }										// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
LeapUpgrade.minPlayerLevel = 3
LeapUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Leap_Active.dds")
LeapUpgrade.vidDesc 		= ""

function LeapUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = LeapUpgrade.cost
	self.upgradeName = LeapUpgrade.upgradeName
	self.upgradeTitle = LeapUpgrade.upgradeTitle
	self.upgradeDesc = LeapUpgrade.upgradeDesc
	self.upgradeTechId = LeapUpgrade.upgradeTechId
	self.requirements = LeapUpgrade.requirements
	self.minPlayerLevel = LeapUpgrade.minPlayerLevel
	self.texture = LeapUpgrade.texture
	self.vidDesc = LeapUpgrade.vidDesc
	
end

function LeapUpgrade:GetClassName()
	return "LeapUpgrade"
end

function LeapUpgrade:OnAdd(player, isReapply)
	player:SetHasOneHive(true)
	player:SetHasTwoHives(true)
    player.twoHives = true
end