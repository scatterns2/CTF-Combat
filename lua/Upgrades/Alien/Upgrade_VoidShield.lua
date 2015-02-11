//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
// Alien Upgrades
						
class 'VoidShieldUpgrade' (CombatAlienAbilityUpgrade)

VoidShieldUpgrade.cost 			= { 1 }                          				// cost of the upgrade in points
VoidShieldUpgrade.upgradeName	= "voidshield"	                        			// text code of the upgrade if using it via console
VoidShieldUpgrade.upgradeTitle 	= "COMBAT_UPGRADE_VOIDSHIELD"										// Title of the upgrade, e.g. Submachine Gun
VoidShieldUpgrade.upgradeDesc	= "COMBAT_UPGRADE_VOIDSHIELD_TOOLTIP"			// Description of the upgrade
VoidShieldUpgrade.upgradeTechId	= kTechId.VoidShield								// techId of the upgrade, default is kTechId.Move cause its the first 
VoidShieldUpgrade.requirements  = { "fade" }									// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
VoidShieldUpgrade.minPlayerLevel = 1
VoidShieldUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Umbra_Active.dds")
VoidShieldUpgrade.vidDesc 		= ""

function VoidShieldUpgrade:Initialize()

	CombatAlienAbilityUpgrade.Initialize(self)
	
	self.cost = VoidShieldUpgrade.cost
	self.upgradeName = VoidShieldUpgrade.upgradeName
	self.upgradeTitle = VoidShieldUpgrade.upgradeTitle
	self.upgradeDesc = VoidShieldUpgrade.upgradeDesc
	self.upgradeTechId = VoidShieldUpgrade.upgradeTechId
	self.requirements = VoidShieldUpgrade.requirements
	self.minPlayerLevel = VoidShieldUpgrade.minPlayerLevel
	self.texture = VoidShieldUpgrade.texture
	self.vidDesc = VoidShieldUpgrade.vidDesc
	
end

function VoidShieldUpgrade:GetClassName()
	return "VoidShieldUpgrade"
end


function VoidShieldUpgrade:OnAdd(player, isReapply)
	player:SetHasOneHive(true)
	player:SetHasTwoHives(true)
    player.twoHives = true
	player:GiveItem(VoidShield.kMapName)
	player:SetActiveWeapon(SwipeBlink.kMapName)
end
