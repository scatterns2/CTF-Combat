//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'ReloadSpeedUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
ReloadSpeedUpgrade.cost 			= { 2 }										// Cost of the upgrade in upgrade points
ReloadSpeedUpgrade.upgradeName 		= "reloadspeed"                     				 	// Text code of the upgrade if using it via console
ReloadSpeedUpgrade.upgradeTitle 	= "COMBAT_UPGRADE_RELOAD_SPEED"               					// Title of the upgrade, e.g. Submachine Gun
ReloadSpeedUpgrade.upgradeDesc 		= "COMBAT_UPGRADE_RELOAD_SPEED_TOOLTIP"								// Description of the upgrade
ReloadSpeedUpgrade.upgradeTechId 	= kTechId.Speed1										// TechId of the upgrade, default is kTechId.Move cause its the first entry
ReloadSpeedUpgrade.teamType 		= kCombatUpgradeTeamType.MarineTeam						// Team Type
ReloadSpeedUpgrade.uniqueSlot 		= kUpgradeUniqueSlot.LessReloads						// Unique slot
ReloadSpeedUpgrade.mutuallyExclusive = false												// Cannot buy another upgrade in this slot when you have this one.
ReloadSpeedUpgrade.minPlayerLevel 	= 5														// Controls whether this upgrade requires the recipient to be a minimum level
ReloadSpeedUpgrade.rowOrder			= 0														// Controls the horizontal position on the menu
ReloadSpeedUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Reload_Active.dds")
ReloadSpeedUpgrade.vidDesc			= "videos/Marines_ReloadSpeed.webm"
ReloadSpeedUpgrade.requirements		= {"assault"}


function ReloadSpeedUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.cost = ReloadSpeedUpgrade.cost
	self.upgradeName = ReloadSpeedUpgrade.upgradeName
	self.upgradeTitle = ReloadSpeedUpgrade.upgradeTitle
	self.upgradeDesc = ReloadSpeedUpgrade.upgradeDesc
	self.upgradeTechId = ReloadSpeedUpgrade.upgradeTechId
	self.teamType = ReloadSpeedUpgrade.teamType
	self.uniqueSlot = ReloadSpeedUpgrade.uniqueSlot
	self.mutuallyExclusive = ReloadSpeedUpgrade.mutuallyExclusive
	self.minPlayerLevel = ReloadSpeedUpgrade.minPlayerLevel
	self.rowOrder = ReloadSpeedUpgrade.rowOrder
	self.texture = ReloadSpeedUpgrade.texture
	self.vidDesc = ReloadSpeedUpgrade.vidDesc
	self.requirements = ReloadSpeedUpgrade.requirements
	
end

function ReloadSpeedUpgrade:GetClassName()
	return "ReloadSpeedUpgrade"
end

function ReloadSpeedUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "WeaponUpgrade") and not player:isa("Spectator") then
		return "Entity needs WeaponUpgrade mixin"
	elseif player:isa("Exo") then
		return "Your massive metal hands can't hold weapons!"
	else
		return ""
	end
end

function ReloadSpeedUpgrade:OnAdd(player, isReapply)
	player:UpdateReloadSpeedLevel(self:GetCurrentLevel())
end

function ReloadSpeedUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Reload speed upgraded to level " .. self:GetCurrentLevel())
	local reloadSpeedBoost = math.round(self:GetCurrentLevel()*ReloadSpeedMixin.reloadSpeedBoostPerLevel * 100)
	player:SendDirectMessage("You will reload " .. reloadSpeedBoost .. "% faster")
end

function ReloadSpeedUpgrade:GetEventParams()
	local reloadSpeedBoost = math.round(self:GetCurrentLevel()*ReloadSpeedMixin.reloadSpeedBoostPerLevel * 100)
	return { description = self:GetEventTitle(), bottomText = "Reload  " .. reloadSpeedBoost .. "% faster!" }
end