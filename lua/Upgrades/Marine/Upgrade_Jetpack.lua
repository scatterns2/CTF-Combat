//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'JetpackUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
JetpackUpgrade.upgradeType 		= kCombatUpgradeTypes.Other	       			// The type of the upgrade
JetpackUpgrade.cost 			= { 2 }                             	 		// cost of the upgrade in points
JetpackUpgrade.upgradeName 		= "jetpack"                     				// Text code of the upgrade if using it via console
JetpackUpgrade.upgradeTitle 	= "JETPACK"               						// Title of the upgrade, e.g. Submachine Gun
JetpackUpgrade.upgradeDesc 		= "JETPACK_TOOLTIP"				// Description of the upgrade
JetpackUpgrade.upgradeTechId 	= kTechId.JetpackMarine							// TechId of the upgrade, default is kTechId.Move cause its the first entry
JetpackUpgrade.teamType 		= kCombatUpgradeTeamType.MarineTeam				// Team Type
JetpackUpgrade.minPlayerLevel 	= 9												// Controls whether this upgrade requires the recipient to be a minimum level
JetpackUpgrade.rowOrder 		= 0												// Controls the horizontal position on the menu
JetpackUpgrade.texture  		= PrecacheAsset("ui/buymenu/Icons/Icon_Jetpack_Active.dds")
JetpackUpgrade.mustBeNearTechPoint = false
JetpackUpgrade.fuelRechargeRate = 1.0
JetpackUpgrade.vidDesc			= "videos/Marines_Jetpack.webm"
JetpackUpgrade.requirements		= {"scout"}

function JetpackUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.upgradeType = JetpackUpgrade.upgradeType
	self.cost = JetpackUpgrade.cost
	self.upgradeName = JetpackUpgrade.upgradeName
	self.upgradeTitle = JetpackUpgrade.upgradeTitle
	self.upgradeDesc = JetpackUpgrade.upgradeDesc
	self.upgradeTechId = JetpackUpgrade.upgradeTechId
	self.teamType = JetpackUpgrade.teamType
	self.minPlayerLevel = JetpackUpgrade.minPlayerLevel
	self.rowOrder = JetpackUpgrade.rowOrder
	self.texture = JetpackUpgrade.texture
	self.mustBeNearTechPoint = JetpackUpgrade.mustBeNearTechPoint
	self.uniqueSlot = JetpackUpgrade.uniqueSlot
	self.vidDesc = JetpackUpgrade.vidDesc
	self.requirements = JetpackUpgrade.requirements
	
end

function JetpackUpgrade:GetClassName()
	return "JetpackUpgrade"
end

function JetpackUpgrade:ResetLevel()
	// TODO: Reset logic
end

function JetpackUpgrade:CanApplyUpgrade(player)
	if not player:isa("Marine") then
		return "Player must be a Marine!"
	else
		return CombatUpgrade.CanApplyUpgrade(self, player)
	end
end

function JetpackUpgrade:OnAdd(player, isReapply)
    if not player:isa("JetpackMarine") and not player:isa("DevouredPlayer") then
		
		local percent = player:GetLifePercent()
		
		local activeWeapon = player:GetActiveWeapon()
		local activeWeaponMapName = nil
		
		if activeWeapon ~= nil then
			activeWeaponMapName = activeWeapon:GetMapName()
		end
		
		local jetpackMarine = player:Replace(JetpackMarine.kMapName, player:GetTeamNumber(), not player:isa("Exo"), Vector(player:GetOrigin()))
		
		jetpackMarine:SetActiveWeapon(activeWeaponMapName)
		jetpackMarine:SetHealth(jetpackMarine:GetMaxHealth() * percent)
		jetpackMarine:SetArmor(jetpackMarine:GetMaxArmor() * percent)
		
		jetpackMarine:ReapplyUpgrades()
			
		return jetpackMarine

    end
end

function JetpackUpgrade:GetEventParams()
	return { description = self:GetEventTitle(), bottomText = self:GetUpgradeTitle() .. " equipped!" }
end

function JetpackUpgrade:CausesEntityChange()
	return true
end