//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'CarapaceUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
CarapaceUpgrade.cost 			= { 1 }										// cost of the upgrade in points
CarapaceUpgrade.upgradeType 	= kCombatUpgradeTypes.Defense        					// the type of the upgrade
CarapaceUpgrade.upgradeName 	= "carapace"                     							// Text code of the upgrade if using it via console
CarapaceUpgrade.upgradeTitle 	= "CARAPACE"               								// Title of the upgrade, e.g. Submachine Gun
CarapaceUpgrade.upgradeDesc 	= "CARAPACE_TOOLTIP"	// Description of the upgrade
CarapaceUpgrade.upgradeTechId	= kTechId.Carapace										// TechId of the upgrade, default is kTechId.Move cause its the first entry
CarapaceUpgrade.teamType 		= kCombatUpgradeTeamType.AlienTeam
CarapaceUpgrade.minPlayerLevel 	= 1														// Controls whether this upgrade requires the recipient to be a minimum level
CarapaceUpgrade.rowOrder 		= 0														// Controls the horizontal position on the menu
CarapaceUpgrade.texture 		= PrecacheAsset("ui/buymenu/Icons/Icon_Carapace_Active.dds")
CarapaceUpgrade.vidDesc			= "videos/Aliens_Carapace.webm"
CarapaceUpgrade.upgradeType = kCombatUpgradeTypes.Defense

function CarapaceUpgrade:Initialize()

	CombatUpgrade.Initialize(self)
	self.cost = CarapaceUpgrade.cost
	self.upgradeType = CarapaceUpgrade.upgradeType
	self.upgradeName = CarapaceUpgrade.upgradeName
	self.upgradeTitle = CarapaceUpgrade.upgradeTitle
	self.upgradeDesc = CarapaceUpgrade.upgradeDesc
	self.teamType = CarapaceUpgrade.teamType
	self.upgradeTechId = CarapaceUpgrade.upgradeTechId
	self.minPlayerLevel = CarapaceUpgrade.minPlayerLevel
	self.rowOrder = CarapaceUpgrade.rowOrder
	self.texture = CarapaceUpgrade.texture
	self.vidDesc = CarapaceUpgrade.vidDesc
	self.upgradeType = CarapaceUpgrade.upgradeType
	
end

function CarapaceUpgrade:GetClassName()
	return "CarapaceUpgrade"
end

function CarapaceUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "Carapace") and not player:isa("Spectator") then
		return "Entity needs CarapaceUpgrade mixin"
	else
		return CombatUpgrade.CanApplyUpgrade(self, player)
	end
end

function CarapaceUpgrade:GetLevelString(level, player)
	if player then
		local newHp = math.round((player:GetOriginalMaxHealth() + level * (CarapaceMixin.hpPercentPerLevel * player:GetOriginalMaxHealth() + CarapaceMixin.hpScalarPerLevel)))
		local newArmor = math.round((player:GetOriginalMaxArmor() + level * (CarapaceMixin.armorPercentPerLevel * player:GetOriginalMaxArmor() + CarapaceMixin.armorScalarPerLevel)))
		return GetTranslationString("COMBAT_UPGRADE_CARAPACE_LEVEL", { newHp = newHp, newArmor = newArmor })
	else
		return GetTranslationString("COMBAT_UPGRADE_CARAPACE_MAX", {})
	end
end

function CarapaceUpgrade:OnAdd(player, isReapply)
	player:SetCarapaceLevel(self:GetCurrentLevel())
end

function CarapaceUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Carapace upgraded to level " .. self:GetCurrentLevel())
	player:SendDirectMessage("New Max Health is: " .. player:GetMaxHealth())
	player:SendDirectMessage("New Max Armor is: " .. player:GetMaxArmor())
end

function CarapaceUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = "Increases health and armor per each level." }
end