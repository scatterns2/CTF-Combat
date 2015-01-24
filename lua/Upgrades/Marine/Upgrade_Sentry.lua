//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// SentryUpgrade.lua
						
class 'SentryUpgrade' (CombatBuildableUpgrade)

SentryUpgrade.cost 	 		 = { 1 }                           					// cost of the upgrade in points
SentryUpgrade.upgradeName  	 = "sentry"                       					// Text code of the upgrade if using it via console
SentryUpgrade.upgradeTitle 	 = "SENTRY_TURRET"               							// Title of the upgrade, e.g. Submachine Gun
SentryUpgrade.upgradeDesc  	 = "COMBAT_UPGRADE_SENTRY_TOOLTIP"	// Description of the upgrade
SentryUpgrade.upgradeTechId  = kTechId.Sentry 	    							// TechId of the upgrade, default is kTechId.Move cause its the first item
SentryUpgrade.teamType 		 = kCombatUpgradeTeamType.MarineTeam				// Team Type
SentryUpgrade.minPlayerLevel = 4												// Controls whether this upgrade requires the recipient to be a minimum level
SentryUpgrade.hardCapScale	 = 0.25												// Hard Cap scale
SentryUpgrade.rowOrder 		 = 0												// Controls the horizontal position on the menu
SentryUpgrade.texture  		 = PrecacheAsset("ui/buymenu/Icons/Icon_Sentry_Active.dds")
SentryUpgrade.vidDesc		 = "videos/Marines_Sentry.webm"
SentryUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_SentryT.dds"
SentryUpgrade.disallowedGameModes = { kCombatGameType.Infection }
SentryUpgrade.requirements		= {"engineer"}

function SentryUpgrade:Initialize()

	CombatBuildableUpgrade.Initialize(self)
	
	self.cost = SentryUpgrade.cost
	self.upgradeName = SentryUpgrade.upgradeName
	self.upgradeTitle = SentryUpgrade.upgradeTitle
	self.upgradeDesc = SentryUpgrade.upgradeDesc
	self.upgradeTechId = SentryUpgrade.upgradeTechId
	self.teamType = SentryUpgrade.teamType
	self.minPlayerLevel = SentryUpgrade.minPlayerLevel
	self.hardCapScale = SentryUpgrade.hardCapScale
	self.rowOrder = SentryUpgrade.rowOrder
	self.texture = SentryUpgrade.texture
	self.vidDesc = SentryUpgrade.vidDesc
	self.detailImage = SentryUpgrade.detailImage
	self.disallowedGameModes = SentryUpgrade.disallowedGameModes
	self.requirements = SentryUpgrade.requirements
end

function SentryUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "MarineStructureUpgrade") and not player:isa("Spectator") then
		return "Entity needs MarineStructureUpgrade mixin"
	else
		return CombatBuildableUpgrade.CanApplyUpgrade(self, player)
	end
end

function SentryUpgrade:OnAdd(player, isReapply)
	CombatBuildableUpgrade.OnAdd(self, player, isReapply)
	player:UpdateSentryLevel(self:GetCurrentLevel())
end

function SentryUpgrade:GetClassName()
	return "SentryUpgrade"
end

function SentryUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You can now build Sentry turrets!")
end