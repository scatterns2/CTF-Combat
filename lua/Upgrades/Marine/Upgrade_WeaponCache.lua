//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// WeaponCacheUpgrade.lua
						
class 'WeaponCacheUpgrade' (CombatBuildableUpgrade)

WeaponCacheUpgrade.cost 	 		 = { 2 }                           				// cost of the upgrade in points
WeaponCacheUpgrade.upgradeName  	 = "weaponcache"                       				// Text code of the upgrade if using it via console
WeaponCacheUpgrade.upgradeTitle 	 = "COMBAT_UPGRADE_WEAPON_CACHE"               						// Title of the upgrade, e.g. Submachine Gun
WeaponCacheUpgrade.upgradeDesc  	 = "ARMORY_TOOLTIP"	// Description of the upgrade
WeaponCacheUpgrade.upgradeTechId  = kTechId.WeaponCache 	    					// TechId of the upgrade, default is kTechId.Move cause its the first item
WeaponCacheUpgrade.teamType 		 = kCombatUpgradeTeamType.MarineTeam			// Team Type
WeaponCacheUpgrade.minPlayerLevel = 4											// Controls whether this upgrade requires the recipient to be a minimum level
WeaponCacheUpgrade.rowOrder 		 = 0											// Controls the horizontal position on the menu
WeaponCacheUpgrade.texture  		 = PrecacheAsset("ui/buymenu/Icons/Icon_Armory_Active.dds")
WeaponCacheUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Cache.dds"
WeaponCacheUpgrade.requirements		= {"engineer"}

function WeaponCacheUpgrade:Initialize()

	CombatBuildableUpgrade.Initialize(self)
	
	self.cost = WeaponCacheUpgrade.cost
	self.upgradeName = WeaponCacheUpgrade.upgradeName
	self.upgradeTitle = WeaponCacheUpgrade.upgradeTitle
	self.upgradeDesc = WeaponCacheUpgrade.upgradeDesc
	self.upgradeTechId = WeaponCacheUpgrade.upgradeTechId
	self.teamType = WeaponCacheUpgrade.teamType
	self.minPlayerLevel = WeaponCacheUpgrade.minPlayerLevel
	self.rowOrder = WeaponCacheUpgrade.rowOrder
	self.texture = WeaponCacheUpgrade.texture
	self.vidDesc = WeaponCacheUpgrade.vidDesc
	self.detailImage = WeaponCacheUpgrade.detailImage
	self.requirements = WeaponCacheUpgrade.requirements

end

function WeaponCacheUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "MarineStructureUpgrade") and not player:isa("Spectator") then
		return "Entity needs MarineStructureUpgrade mixin"
	else
		return CombatBuildableUpgrade.CanApplyUpgrade(self, player)
	end
end

function WeaponCacheUpgrade:OnAdd(player, isReapply)
	CombatBuildableUpgrade.OnAdd(self, player, isReapply)
	player:UpdateArmoryLevel(self:GetCurrentLevel())
end

function WeaponCacheUpgrade:GetClassName()
	return "WeaponCacheUpgrade"
end

function WeaponCacheUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You can now deploy weapon caches!")
end