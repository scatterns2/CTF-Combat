//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'SnipeUpgrade' (CombatAlienUpgrade)

SnipeUpgrade.cost 			= { 1 }                          				// cost of the upgrade in points
SnipeUpgrade.upgradeName	= "snipe"	                        			// text code of the upgrade if using it via console
SnipeUpgrade.upgradeTitle 	= "SNIPE"										// Title of the upgrade, e.g. Submachine Gun
SnipeUpgrade.upgradeDesc	= "SNIPE_TOOLTIP"			// Description of the upgrade
SnipeUpgrade.upgradeTechId	= kTechId.Snipe  								// techId of the upgrade, default is kTechId.Move cause its the first 
SnipeUpgrade.requirements  = { "lerk" }									// Upgrades you must get before you can get this one.  These are OR - conditionals ONLY!!
SnipeUpgrade.minPlayerLevel = 1
SnipeUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Focus_Active.dds")  //PLACEHOLDER
SnipeUpgrade.vidDesc 		= ""

function SnipeUpgrade:Initialize()

	CombatAlienUpgrade.Initialize(self)
	
	self.cost = SnipeUpgrade.cost
	self.upgradeName = SnipeUpgrade.upgradeName
	self.upgradeTitle = SnipeUpgrade.upgradeTitle
	self.upgradeDesc = SnipeUpgrade.upgradeDesc
	self.upgradeTechId = SnipeUpgrade.upgradeTechId
	self.requirements = SnipeUpgrade.requirements
	self.minPlayerLevel = SnipeUpgrade.minPlayerLevel
	self.texture = SnipeUpgrade.texture
	self.vidDesc = SnipeUpgrade.vidDesc
	
end

function SnipeUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "Spikes") then
		return "Entity needs Spikes mixin"
	else
		return CombatUpgrade.CanApplyUpgrade(self, player)
	end
end

function SnipeUpgrade:OnAdd(player, isReapply)
	Print("Sniping!")
	player:SetSnipeMode(true)
end

function SnipeUpgrade:GetClassName()
	return "SnipeUpgrade"
end
