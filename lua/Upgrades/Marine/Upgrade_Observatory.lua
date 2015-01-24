//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// ObservatoryUpgrade.lua
						
class 'ObservatoryUpgrade' (CombatBuildableUpgrade)

ObservatoryUpgrade.cost 	 		= { 1 }                           					// cost of the upgrade in points
ObservatoryUpgrade.upgradeName  	= "observatory"                       				// Text code of the upgrade if using it via console
ObservatoryUpgrade.upgradeTitle 	= "OBSERVATORY"               						// Title of the upgrade, e.g. Submachine Gun
ObservatoryUpgrade.upgradeDesc  	= "OBSERVATORY_HINT"				// Description of the upgrade
ObservatoryUpgrade.upgradeTechId 	= kTechId.Observatory 	    						// TechId of the upgrade, default is kTechId.Move cause its the first item
ObservatoryUpgrade.teamType 		= kCombatUpgradeTeamType.MarineTeam					// Team Type
ObservatoryUpgrade.minPlayerLevel 	= 2													// Controls whether this upgrade requires the recipient to be a minimum level
ObservatoryUpgrade.rowOrder 		= 0													// Controls the horizontal position on the menu
ObservatoryUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Observatory_Active.dds")
ObservatoryUpgrade.vidDesc			= "videos/Marines_Observatory.webm"
ObservatoryUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Observatory.dds"
ObservatoryUpgrade.requirements		= { "engineer"}

function ObservatoryUpgrade:Initialize()

	CombatBuildableUpgrade.Initialize(self)
	
	self.cost = ObservatoryUpgrade.cost
	self.upgradeName = ObservatoryUpgrade.upgradeName
	self.upgradeTitle = ObservatoryUpgrade.upgradeTitle
	self.upgradeDesc = ObservatoryUpgrade.upgradeDesc
	self.upgradeTechId = ObservatoryUpgrade.upgradeTechId
	self.teamType = ObservatoryUpgrade.teamType
	self.minPlayerLevel = ObservatoryUpgrade.minPlayerLevel
	self.rowOrder = ObservatoryUpgrade.rowOrder
	self.texture = ObservatoryUpgrade.texture
	self.vidDesc = ObservatoryUpgrade.vidDesc
	self.detailImage = ObservatoryUpgrade.detailImage
	self.requirements = ObservatoryUpgrade.requirements
end

function ObservatoryUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "MarineStructureUpgrade") and not player:isa("Spectator") then
		return "Entity needs MarineStructureUpgrade mixin"
	else
		return CombatBuildableUpgrade.CanApplyUpgrade(self, player)
	end
end

function ObservatoryUpgrade:OnAdd(player, isReapply)
	CombatBuildableUpgrade.OnAdd(self, player, isReapply)
	player:UpdateObservatoryLevel(self:GetCurrentLevel())
end

function ObservatoryUpgrade:GetClassName()
	return "ObservatoryUpgrade"
end

function ObservatoryUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You can now build Observatories!")
end