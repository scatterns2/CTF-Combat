//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'DamageUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
DamageUpgrade.cost 			 = { 1, 1, 1, 1, 1 }                           	 	// Cost of the upgrade in upgrade points
DamageUpgrade.upgradeName 	 = "damage"                     					// Text code of the upgrade if using it via console
DamageUpgrade.upgradeTitle 	 = "COMBAT_UPGRADE_DAMAGE"		               					// Title of the upgrade, e.g. Submachine Gun
DamageUpgrade.upgradeDesc    = "COMBAT_UPGRADE_DAMAGE_TOOLTIP"									// Description of the upgrade
DamageUpgrade.upgradeTechId  = kTechId.Weapons1									// TechId of the upgrade, default is kTechId.Move cause its the first entry
DamageUpgrade.teamType		 = kCombatUpgradeTeamType.MarineTeam
DamageUpgrade.minPlayerLevel = 1												// Controls whether this upgrade requires the recipient to be a minimum level
DamageUpgrade.rowOrder 		 = 1												// Controls the horizontal position on the menu
DamageUpgrade.texture 		 = PrecacheAsset("ui/buymenu/Icons/Icon_Damage_Active.dds")
DamageUpgrade.vidDesc		 = "videos/Marines_Damage.webm"
DamageUpgrade.compatiblewithExo = true
DamageUpgrade.upgradeType 	= kCombatUpgradeTypes.Offense        			// the type of the upgrade
DamageUpgrade.requirements		= { "marine","marine" }

function DamageUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.cost = DamageUpgrade.cost
	self.upgradeType = DamageUpgrade.upgradeType
	self.upgradeName = DamageUpgrade.upgradeName
	self.upgradeTitle = DamageUpgrade.upgradeTitle
	self.upgradeDesc = DamageUpgrade.upgradeDesc
	self.upgradeTechId = DamageUpgrade.upgradeTechId
	self.minPlayerLevel = DamageUpgrade.minPlayerLevel
	self.rowOrder = DamageUpgrade.rowOrder
	self.texture = DamageUpgrade.texture
	self.teamType = DamageUpgrade.teamType
	self.vidDesc = DamageUpgrade.vidDesc
	self.compatiblewithExo = DamageUpgrade.compatiblewithExo
	self.upgradeType = DamageUpgrade.upgradeType
	self.requirements = DamageUpgrade.requirements
	
end

function DamageUpgrade:GetClassName()
	return "DamageUpgrade"
end

function DamageUpgrade:GetLevelString(level, player)
	return GetTranslationString("COMBAT_UPGRADE_DAMAGE_LEVEL", { boost = level*WeaponUpgradeMixin.damageBoostPerLevel / WeaponUpgradeMixin.baseDamage * 100 })
end

function DamageUpgrade:CanApplyUpgrade(player)
	if not HasMixin(player, "WeaponUpgrade") and not player:isa("Spectator") then
		return "Entity needs WeaponUpgrade mixin"
	else
		return CombatUpgrade.CanApplyUpgrade(self, player)
	end
end

function DamageUpgrade:OnAdd(player, isReapply)
	player:UpdateDamageLevel(self:GetCurrentLevel())
end

function DamageUpgrade:SendAddMessage(player)
	player:SendDirectMessage("Damage upgraded to level " .. self:GetCurrentLevel())
	local damageBoost = math.round(self:GetCurrentLevel()*WeaponUpgradeMixin.damageBoostPerLevel / WeaponUpgradeMixin.baseDamage * 100)
	player:SendDirectMessage("Deals " .. damageBoost .. "% more damage to Kharaa.")
end