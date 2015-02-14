//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
// Alien Upgrades
						
class 'ShadowStepUpgrade' (CombatAlienAbilityUpgrade)

ShadowStepUpgrade.cost 			= { 1 }                          				// cost of the upgrade in points
ShadowStepUpgrade.upgradeName	= "shadowstep"	                        			// text code of the upgrade if using it via console
ShadowStepUpgrade.upgradeTitle 	= "COMBAT_UPGRADE_SHADOW_STEP"										// Title of the upgrade, e.g. Submachine Gun
ShadowStepUpgrade.upgradeDesc	= "TIPVIDEO_2_FADE_FADE_SHADOW_STEP"			// Description of the upgrade
ShadowStepUpgrade.upgradeTechId	= kTechId.ShadowStep  								// techId of the upgrade, default is kTechId.Move cause its the first 
ShadowStepUpgrade.requirements  = { "fade" }									// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
ShadowStepUpgrade.minPlayerLevel = 7
ShadowStepUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Blink_Active.dds")
ShadowStepUpgrade.vidDesc 		= ""
ShadowStepUpgrade.disallowedGameModes = { kCombatGameType.Infection, kCombatGameType.CombatCTF }
ShadowStepUpgrade.hideUpgrade = true

function ShadowStepUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = ShadowStepUpgrade.cost
	self.upgradeName = ShadowStepUpgrade.upgradeName
	self.upgradeTitle = ShadowStepUpgrade.upgradeTitle
	self.upgradeDesc = ShadowStepUpgrade.upgradeDesc
	self.upgradeTechId = ShadowStepUpgrade.upgradeTechId
	self.requirements = ShadowStepUpgrade.requirements
	self.minPlayerLevel = ShadowStepUpgrade.minPlayerLevel
	self.texture = ShadowStepUpgrade.texture
	self.vidDesc = ShadowStepUpgrade.vidDesc
	self.disallowedGameModes = ShadowStepUpgrade.disallowedGameModes
	self.hideUpgrade = ShadowStepUpgrade.hideUpgrade
	
end

function ShadowStepUpgrade:GetClassName()
	return "ShadowStepUpgrade"
end

function ShadowStepUpgrade:OnAdd(player, isReapply)
	player:SetHasOneHive(true)
	player:SetHasTwoHives(true)
    player.twoHives = true
end