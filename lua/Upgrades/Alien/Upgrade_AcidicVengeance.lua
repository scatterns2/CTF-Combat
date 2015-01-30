//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'AcidicVengeanceUpgrade' (CombatAlienUpgrade)

// Define these statically so we can easily access them without instantiating too.
AcidicVengeanceUpgrade.cost = { 2 }                              				// Cost of the upgrade in upgrade points
AcidicVengeanceUpgrade.upgradeName 		= "acid"                     			// Text code of the upgrade if using it via console
AcidicVengeanceUpgrade.upgradeTitle 	= "COMBAT_UPGRADE_ACIDIC_VENGEANCE"			// Title of the upgrade, e.g. Submachine Gun
AcidicVengeanceUpgrade.upgradeDesc 		= "COMBAT_UPGRADE_ACIDIC_VENGEANCE_TOOLTIP"	// Description of the upgrade
AcidicVengeanceUpgrade.upgradeTechId 	= kTechId.Spores						// TechId of the upgrade, default is kTechId.Move cause its the first entry
AcidicVengeanceUpgrade.minPlayerLevel 	= 3
AcidicVengeanceUpgrade.texture 			= PrecacheAsset("ui/buymenu/Icons/Icon_Acidic_Active.dds")
AcidicVengeanceUpgrade.vidDesc 			= ""
AcidicVengeanceUpgrade.upgradeType 		= kCombatUpgradeTypes.Offense

function AcidicVengeanceUpgrade:Initialize()

	CombatAlienUpgrade.Initialize(self)

	self.cost = AcidicVengeanceUpgrade.cost
	self.upgradeType = AcidicVengeanceUpgrade.upgradeType
	self.upgradeName = AcidicVengeanceUpgrade.upgradeName
	self.upgradeTitle = AcidicVengeanceUpgrade.upgradeTitle
	self.upgradeDesc = AcidicVengeanceUpgrade.upgradeDesc
	self.upgradeTechId = AcidicVengeanceUpgrade.upgradeTechId
	self.minPlayerLevel = AcidicVengeanceUpgrade.minPlayerLevel
	self.texture = AcidicVengeanceUpgrade.texture
	self.vidDesc = AcidicVengeanceUpgrade.vidDesc
	self.upgradeType = AcidicVengeanceUpgrade.upgradeType
	
end

function AcidicVengeanceUpgrade:GetClassName()
	return "AcidicVengeanceUpgrade"
end

function AcidicVengeanceUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "AcidicVengeance") and not player:isa("Spectator") then
		return "Entity needs AcidicVengeance mixin"
	else
		return CombatUpgrade.CanApplyUpgrade(self, player)
	end
end

function AcidicVengeanceUpgrade:OnAdd(player, isReapply)
	player:UpdateAcidicVengeanceLevel(self:GetCurrentLevel())
end

function AcidicVengeanceUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You have Acidic Vengeance!")
	player:SendDirectMessage("On death: Explode in a cloud of poisonous gas.")
end

function AcidicVengeanceUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = "Cloud of poisonous gas after death" }
end