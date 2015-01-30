//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'HungerUpgrade' (CombatAlienUpgrade)

// Define these statically so we can easily access them without instantiating too.
HungerUpgrade.cost = { 1, 1, 1 }                              									// Cost of the upgrade in upgrade points
HungerUpgrade.upgradeName 		= "hunger"                     									// Text code of the upgrade if using it via console
HungerUpgrade.upgradeTitle 		= "UPGRADE_HUNGER_NAME"		               									// Title of the upgrade, e.g. Submachine Gun
HungerUpgrade.upgradeDesc 		= "UPGRADE_HUNGER_TIPDESC"	// Description of the upgrade
HungerUpgrade.upgradeTechId 	= kTechId.Bite													// TechId of the upgrade, default is kTechId.Move cause its the first entry
HungerUpgrade.minPlayerLevel 	= 4
HungerUpgrade.texture 			= PrecacheAsset("ui/buymenu/Icons/Icon_Vampiric_Active.dds")
HungerUpgrade.vidDesc			= "videos/Aliens_Hunger.webm"
HungerUpgrade.upgradeType 		= kCombatUpgradeTypes.Offense

function HungerUpgrade:Initialize()

	CombatAlienUpgrade.Initialize(self)

	self.cost = HungerUpgrade.cost
	self.upgradeType = HungerUpgrade.upgradeType
	self.upgradeName = HungerUpgrade.upgradeName
	self.upgradeTitle = HungerUpgrade.upgradeTitle
	self.upgradeDesc = HungerUpgrade.upgradeDesc
	self.upgradeTechId = HungerUpgrade.upgradeTechId
	self.minPlayerLevel = HungerUpgrade.minPlayerLevel
	self.texture = HungerUpgrade.texture
	self.vidDesc = HungerUpgrade.vidDesc
	self.upgradeType = HungerUpgrade.upgradeType
	
end

function HungerUpgrade:GetClassName()
	return "HungerUpgrade"
end

function HungerUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "Hunger") and not player:isa("Spectator") then
		return "Entity needs Hunger mixin"
	else
		return CombatUpgrade.CanApplyUpgrade(self, player)
	end
end

function HungerUpgrade:GetLevelString(level, player)
	if player then
		return GetTranslationString("COMBAT_UPGRADE_HUNGER_LEVEL", { regen = level * (kHungerScalarRegen + player:GetMaxHealth() * kHungerPercentRegen * .01) })
	else
		return GetTranslationString("COMBAT_UPGRADE_HUNGER_MAX", {})
	end
end

function HungerUpgrade:OnAdd(player, isReapply)
    CombatAlienUpgrade.OnAdd(self, player, isReapply)
	player:UpdateHungerLevel(self:GetCurrentLevel())
end

function HungerUpgrade:SendAddMessage(player)
	local msg = "You will receive " .. kHungerScalarRegen * self:GetLevel() ..
	" health + " .. player:GetMaxHealth() * kHungerPercentRegen * .01 * self:GetLevel() .. "% of max every successful melee attack."
	Player:SendDirectMessage(msg)
end

function HungerUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = "Vampiric bite!" }
end