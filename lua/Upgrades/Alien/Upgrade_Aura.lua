//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// Alien Upgrades
						
class 'AuraUpgrade' (CombatAlienUpgrade)

AuraUpgrade.cost 				= { 2 }                     // cost of the upgrade in upgrade points
AuraUpgrade.upgradeName		= "aura"	            // text code of the upgrade if using it via console
AuraUpgrade.upgradeTitle 		= "AURA"       		// Title of the upgrade, e.g. Submachine Gun
AuraUpgrade.upgradeDesc 		= "AURA_TOOLTIP" 	// Description of the upgrade
AuraUpgrade.upgradeTechId 	= kTechId.Aura  		// techId of the upgrade, default is kTechId.Move cause its the first 
AuraUpgrade.minPlayerLevel 	= 4
AuraUpgrade.texture 			= PrecacheAsset("ui/buymenu/Icons/Icon_Aura_Active.dds")
AuraUpgrade.vidDesc 			= "videos/Aliens_Aura.webm"
AuraUpgrade.upgradeType 		= kCombatUpgradeTypes.Offense
AuraUpgrade.disallowedGameModes = { kCombatGameType.Infection }

function AuraUpgrade:Initialize()

	CombatAlienUpgrade.Initialize(self)
	
	self.cost = AuraUpgrade.cost
	self.upgradeName = AuraUpgrade.upgradeName
	self.upgradeTitle = AuraUpgrade.upgradeTitle
	self.upgradeDesc = AuraUpgrade.upgradeDesc
	self.upgradeTechId = AuraUpgrade.upgradeTechId
	self.minPlayerLevel = AuraUpgrade.minPlayerLevel
	self.texture = AuraUpgrade.texture
	self.vidDesc = AuraUpgrade.vidDesc
	self.upgradeType = AuraUpgrade.upgradeType
	self.disallowedGameModes = AuraUpgrade.disallowedGameModes
	
end

function AuraUpgrade:GetClassName()
	return "AuraUpgrade"
end


function AuraUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "Aura") and not player:isa("Spectator") then
		return "Entity needs Aura mixin"
	else
		return CombatUpgrade.CanApplyUpgrade(self, player)
	end
end

function AuraUpgrade:OnAdd(player, isReapply)
	player:SetHasAura(true)
end