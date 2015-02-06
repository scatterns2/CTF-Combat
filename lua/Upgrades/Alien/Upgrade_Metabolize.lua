//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
// Alien Upgrades
						
class 'MetabolizeUpgrade' (CombatAlienAbilityUpgrade)

MetabolizeUpgrade.cost 			= { 1 }                          				// cost of the upgrade in points
MetabolizeUpgrade.upgradeName	= "metabolize"	                        			// text code of the upgrade if using it via console
MetabolizeUpgrade.upgradeTitle 	= "COMBAT_UPGRADE_VOID_SHROUD"										// Title of the upgrade, e.g. Submachine Gun
MetabolizeUpgrade.upgradeDesc	= "TIPVIDEO_2_FADE_FADE_SHADOW_STEP"			// Description of the upgrade
MetabolizeUpgrade.upgradeTechId	= kTechId.MetabolizeHealth								// techId of the upgrade, default is kTechId.Move cause its the first 
MetabolizeUpgrade.requirements  = { "fade" }									// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
MetabolizeUpgrade.minPlayerLevel = 2
MetabolizeUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Umbra_Active.dds")
MetabolizeUpgrade.vidDesc 		= ""

function MetabolizeUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = MetabolizeUpgrade.cost
	self.upgradeName = MetabolizeUpgrade.upgradeName
	self.upgradeTitle = MetabolizeUpgrade.upgradeTitle
	self.upgradeDesc = MetabolizeUpgrade.upgradeDesc
	self.upgradeTechId = MetabolizeUpgrade.upgradeTechId
	self.requirements = MetabolizeUpgrade.requirements
	self.minPlayerLevel = MetabolizeUpgrade.minPlayerLevel
	self.texture = MetabolizeUpgrade.texture
	self.vidDesc = MetabolizeUpgrade.vidDesc
	
end

function MetabolizeUpgrade:GetClassName()
	return "MetabolizeUpgrade"
end

function MetabolizeUpgrade:OnAdd(player, isReapply)
	player:SetHasOneHive(true)
	player:SetHasTwoHives(true)
    player.twoHives = true
end