//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'RegenerationUpgrade' (CombatTimedUpgrade)

RegenerationUpgrade.kBoostRegenScalarPerLevel = 5 //1.5
RegenerationUpgrade.kBoostRegenPercentPerLevel = 6 //1.5

// Define these statically so we can easily access them without instantiating too.
RegenerationUpgrade.cost 				= { 1 }                             		// cost of the upgrade in points
RegenerationUpgrade.upgradeName 		= "regen"                     							// Text code of the upgrade if using it via console
RegenerationUpgrade.upgradeTitle 		= "REGENERATION"               							// Title of the upgrade, e.g. Submachine Gun
RegenerationUpgrade.upgradeDesc 		= "REGENERATION_TOOLTIP"			// Description of the upgrade
RegenerationUpgrade.upgradeTechId 		= kTechId.Regeneration									// TechId of the upgrade, default is kTechId.Move cause its the first entry
RegenerationUpgrade.triggerInterval		= { 1 } 									// Specify the timer interval (in seconds) per level.
RegenerationUpgrade.teamType 			= kCombatUpgradeTeamType.AlienTeam						// Team Type
RegenerationUpgrade.minPlayerLevel 		= 1
RegenerationUpgrade.texture 			= PrecacheAsset("ui/buymenu/Icons/Icon_Regen_Active.dds")
RegenerationUpgrade.damageRegenPause 	= 6
RegenerationUpgrade.vidDesc				= "videos/Aliens_Regeneration.webm"
RegenerationUpgrade.upgradeType = kCombatUpgradeTypes.Defense

function RegenerationUpgrade:Initialize()

	CombatTimedUpgrade.Initialize(self)

	self.cost = RegenerationUpgrade.cost
	self.upgradeName = RegenerationUpgrade.upgradeName
	self.upgradeTitle = RegenerationUpgrade.upgradeTitle
	self.upgradeDesc = RegenerationUpgrade.upgradeDesc
	self.upgradeTechId = RegenerationUpgrade.upgradeTechId
	self.triggerInterval = RegenerationUpgrade.triggerInterval
	self.teamType = RegenerationUpgrade.teamType
	self.minPlayerLevel = RegenerationUpgrade.minPlayerLevel
	self.texture = RegenerationUpgrade.texture
	self.vidDesc = RegenerationUpgrade.vidDesc
	self.upgradeType = RegenerationUpgrade.upgradeType
	
end

function RegenerationUpgrade:GetClassName()
	return "RegenerationUpgrade"
end

function RegenerationUpgrade:GetRegenScalar(player, level)
	return (level~= nil and level or self:GetCurrentLevel()) * (RegenerationUpgrade.kBoostRegenScalarPerLevel + (player:GetMaxArmor() + player:GetMaxHealth()) * RegenerationUpgrade.kBoostRegenPercentPerLevel * .01)
end

function RegenerationUpgrade:GetRegenString(player)
	return self:GetRegenScalar(player)
end

function RegenerationUpgrade:GetTimerDescription(player)
	return "You will regenerate health by " .. self:GetRegenString(player) .. " every "
end

function RegenerationUpgrade:RegenerateNow(player)
    if Shared.GetTime() >= (player.timeOfLastDamage + RegenerationUpgrade.damageRegenPause) then
        local regenAmount = self:GetRegenScalar(player)
	    player:Regenerate(regenAmount)
    end

end

function RegenerationUpgrade:OnAdd(player, isReapply)
	CombatTimedUpgrade.OnAdd(self, player, isReapply)
	
	if player and player:GetIsAlive() and player:GetNeedsToRegenerate() then
		self:RegenerateNow(player)
	end
end

function RegenerationUpgrade:GetLevelString(level, player)
	if player then
		return GetTranslationString("COMBAT_UPGRADE_REGEN_LEVEL", { regen = self:GetRegenScalar(player, level) })
	else
		return GetTranslationString("COMBAT_UPGRADE_REGEN_MAX", {})
	end
end

function RegenerationUpgrade:OnTrigger(player)
	if player and player:GetIsAlive() and player:GetNeedsToRegenerate() then
		self:RegenerateNow(player)
	end
end

function RegenerationUpgrade:CanApplyUpgrade(player)

	local baseText = CombatTimedUpgrade.CanApplyUpgrade(self, player)
	
	if baseText ~= "" then
		return baseText
	elseif not player:isa("Alien") then
		return "Player must be an Alien"
	else
		return ""
	end
end