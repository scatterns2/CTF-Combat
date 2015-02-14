//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'NanoArmorUpgrade' (CombatTimedUpgrade)

NanoArmorUpgrade.kBoostRegenScalarPerLevel = 5
NanoArmorUpgrade.kBoostRegenPercentPerLevel = .7

// Define these statically so we can easily access them without instantiating too.
NanoArmorUpgrade.cost 				= { 1, 1, 1}                         // cost of the upgrade in points
NanoArmorUpgrade.upgradeName 		= "nanoarmor"                     			// Text code of the upgrade if using it via console
NanoArmorUpgrade.upgradeTitle 		= "UPGRADE_NANO_ARMOR_NAME"               				// Title of the upgrade, e.g. Submachine Gun
NanoArmorUpgrade.upgradeDesc 		= "UPGRADE_NANO_ARMOR_TIPDESC"			// Description of the upgrade
NanoArmorUpgrade.upgradeTechId 		= kTechId.NanoArmor							// TechId of the upgrade, default is kTechId.Move cause its the first entry
NanoArmorUpgrade.triggerInterval 	= { 1, 1, 1} 						// Specify the timer interval (in seconds) per level.
NanoArmorUpgrade.teamType 			= kCombatUpgradeTeamType.MarineTeam			// Team Type
NanoArmorUpgrade.minPlayerLevel 	= 5											// Controls whether this upgrade requires the recipient to be a minimum level
NanoArmorUpgrade.rowOrder 			= 2											// Controls the horizontal position on the menu
NanoArmorUpgrade.texture  			= PrecacheAsset("ui/buymenu/Icons/Icon_Nano_Active.dds")
NanoArmorUpgrade.damageRegenPause 	= 3
NanoArmorUpgrade.vidDesc			= "videos/Marines_NanoArmor.webm"
NanoArmorUpgrade.compatibleWithExo 	= true
NanoArmorUpgrade.upgradeType 	= kCombatUpgradeTypes.Defense        			// the type of the upgrade
NanoArmorUpgrade.requirements	= {}

function NanoArmorUpgrade:Initialize()

	CombatTimedUpgrade.Initialize(self)

	self.cost = NanoArmorUpgrade.cost
	self.upgradeName = NanoArmorUpgrade.upgradeName
	self.upgradeTitle = NanoArmorUpgrade.upgradeTitle
	self.upgradeDesc = NanoArmorUpgrade.upgradeDesc
	self.upgradeTechId = NanoArmorUpgrade.upgradeTechId
	self.triggerInterval = NanoArmorUpgrade.triggerInterval
	self.teamType = NanoArmorUpgrade.teamType
	self.minPlayerLevel = NanoArmorUpgrade.minPlayerLevel
	self.rowOrder = NanoArmorUpgrade.rowOrder
	self.texture = NanoArmorUpgrade.texture
	self.vidDesc = NanoArmorUpgrade.vidDesc
	self.compatibleWithExo = NanoArmorUpgrade.compatibleWithExo
	self.upgradeType = NanoArmorUpgrade.upgradeType
	self.requirements = NanoArmorUpgrade.requirements
	
end

function NanoArmorUpgrade:GetClassName()
	return "NanoArmorUpgrade"
end

function NanoArmorUpgrade:GetRegenScalar(player, level)
	return (level ~= nil and level or self:GetCurrentLevel()) * (NanoArmorUpgrade.kBoostRegenScalarPerLevel + player:GetMaxArmor() * NanoArmorUpgrade.kBoostRegenPercentPerLevel * .01)
end

function NanoArmorUpgrade:GetRegenString(player)
	return self:GetRegenScalar(player)
end

function NanoArmorUpgrade:GetLevelString(level, player)
	if player then
		return GetTranslationString("COMBAT_UPGRADE_NANO_ARMOR_LEVEL", { regen = self:GetRegenScalar(player, level) })
	else
		return GetTranslationString("COMBAT_UPGRADE_NANO_ARMOR_MAX", {})
	end
end

function NanoArmorUpgrade:GetTimerDescription(player)
	return "Your armor will self-repair by " .. self:GetCurrentLevel() * NanoArmorUpgrade.kBoostRegenScalarPerLevel ..
	" + " .. self:GetCurrentLevel() * player:GetMaxArmor() * NanoArmorUpgrade.kBoostRegenPercentPerLevel * .01 .. "% of max every second."
end

function NanoArmorUpgrade:RegenerateNow(player)

    if Shared.GetTime() >= (player.timeOfLastDamage + NanoArmorUpgrade.damageRegenPause) then
        local regenAmount = self:GetRegenScalar(player)
        player:RegenerateArmor(regenAmount)
    end

end

function NanoArmorUpgrade:OnAdd(player, isReapply)
	CombatTimedUpgrade.OnAdd(self, player, isReapply)
	
	if player and player:GetIsAlive() and player:GetNeedsToRegenerateArmor() then
		self:RegenerateNow(player)
	end
end

function NanoArmorUpgrade:OnTrigger(player)
	if player and player:GetIsAlive() and player:GetNeedsToRegenerateArmor() then
        self:RegenerateNow(player)
	end
end

function NanoArmorUpgrade:CanApplyUpgrade(player)

	local baseText = CombatTimedUpgrade.CanApplyUpgrade(self, player)
	
	if baseText ~= "" then
		return baseText
	elseif not player:isa("Marine") and not player:isa("Exo") then
		return "Player needs to be a Marine or an Exo!"
	else
		return ""
	end
	
end

function NanoArmorUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = NanoArmorUpgrade.kBoostRegenPercentPerLevel * self:GetCurrentLevel() .. "% Armor regen" }
end