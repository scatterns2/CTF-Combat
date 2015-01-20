//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________
						
class 'RailgunExoUpgrade' (CombatUpgrade)

// Define these statically so we can easily access them without instantiating too.
RailgunExoUpgrade.upgradeType		= kCombatUpgradeTypes.Lifeform      			// The type of the upgrade
RailgunExoUpgrade.cost				= { 4 }                              		// cost of the upgrade in points
RailgunExoUpgrade.upgradeName		= "railgunexo"                     			// Text code of the upgrade if using it via console
RailgunExoUpgrade.upgradeTitle		= "UPGRADE_RAILGUN_NAME"               			// Title of the upgrade, e.g. Submachine Gun
RailgunExoUpgrade.upgradeDesc 		= "UPGRADE_RAILGUN_TIPDESC"							// Description of the upgrade
RailgunExoUpgrade.upgradeTechId		= kTechId.Exo				// TechId of the upgrade, default is kTechId.Move cause its the first entry
RailgunExoUpgrade.teamType			= kCombatUpgradeTeamType.MarineTeam			// Team Type
RailgunExoUpgrade.minPlayerLevel	= 10										// Controls whether this upgrade requires the recipient to be a minimum level
RailgunExoUpgrade.rowOrder			= 1											// Controls the horizontal position on the menu
RailgunExoUpgrade.texture			= PrecacheAsset("ui/buymenu/Icons/Icon_ExoR_Active.dds")
RailgunExoUpgrade.mustBeNearTechPoint = true
RailgunExoUpgrade.uniqueSlot		= kUpgradeUniqueSlot.Class
RailgunExoUpgrade.vidDesc			= "videos/Marines_RailgunExo.webm"
RailgunExoUpgrade.compatiblewithExo	= true
RailgunExoUpgrade.hideUpgrade 		= false
RailgunExoUpgrade.rebuyCooldownTime = 60
RailgunExoUpgrade.requirements = {"marine", "railgunexo"}
RailgunExoUpgrade.disallowedGameModes = { kCombatGameType.Infection }
RailgunExoUpgrade.hideUpgrade  	= true

function RailgunExoUpgrade:Initialize()

	CombatUpgrade.Initialize(self)

	self.upgradeType = RailgunExoUpgrade.upgradeType
	self.cost = RailgunExoUpgrade.cost
	self.upgradeName = RailgunExoUpgrade.upgradeName
	self.upgradeTitle = RailgunExoUpgrade.upgradeTitle
	self.upgradeDesc = RailgunExoUpgrade.upgradeDesc
	self.upgradeTechId = RailgunExoUpgrade.upgradeTechId
	self.teamType = RailgunExoUpgrade.teamType
	self.minPlayerLevel = RailgunExoUpgrade.minPlayerLevel
	self.rowOrder = RailgunExoUpgrade.rowOrder
	self.texture = RailgunExoUpgrade.texture
	self.mustBeNearTechPoint = RailgunExoUpgrade.mustBeNearTechPoint
	self.uniqueSlot = RailgunExoUpgrade.uniqueSlot
	self.vidDesc = RailgunExoUpgrade.vidDesc
	self.compatiblewithExo = RailgunExoUpgrade.compatiblewithExo
	self.hideUpgrade = RailgunExoUpgrade.hideUpgrade
	self.requirements = RailgunExoUpgrade.requirements
	self.rebuyCooldownTime = RailgunExoUpgrade.rebuyCooldownTime 
	self.disallowedGameModes = RailgunExoUpgrade.disallowedGameModes
	self.hideUpgrade = RailgunExoUpgrade.hideUpgrade
	
end

function RailgunExoUpgrade:GetClassName()
	return "RailgunExoUpgrade"
end

function RailgunExoUpgrade:CanApplyUpgrade(player)

	if player:isa("Exo") then
		return "You cannot switch between Exosuits!"
	end
    
	return CombatUpgrade.CanApplyUpgrade(self, player)
end

function RailgunExoUpgrade:OnAdd(player, isReapply)
	if player.layout ~= "ClawRailgun" then
		local percent = player:GetLifePercent()
		local position = player:GetOrigin()
		
		local newPlayer = player:Replace(Exo.kMapName, player:GetTeamNumber(), false, nil, { layout = "ClawRailgun" })
		
		if not newPlayer:SpaceClearForEntity(position) then
			local newPlayerExtents = LookupTechData(newPlayer:GetTechId(), kTechDataMaxExtents)
			local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(newPlayerExtents) 
			position = GetRandomSpawnForCapsule(newPlayerExtents.y, capsuleRadius, newPlayer:GetModelOrigin(), 0.5, 5)
		end
		
		newPlayer:SetOrigin(position)
		newPlayer:SetArmor(newPlayer:GetMaxArmor() * percent)
		newPlayer:ReapplyUpgrades()
		
		return newPlayer
	end
end

function RailgunExoUpgrade:GetOverlayTextures()
	return "ui/buymenu/Icons/masks/Icon_ExoR_mask.dds", ""
end

function RailgunExoUpgrade:CausesEntityChange()
	return true
end

function RailgunExoUpgrade:GetRespawnExtraValues()
	return { layout = "ClawRailgun" }
end