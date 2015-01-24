//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

// ClusterGrenadeUpgrade.lua
						
class 'ClusterGrenadeUpgrade' (CombatResupplyableWeaponUpgrade)

ClusterGrenadeUpgrade.cost			 = { 1 }                           						// cost of the upgrade in points
ClusterGrenadeUpgrade.upgradeName 	 = "clustergrenade"                 					// Text code of the upgrade if using it via console
ClusterGrenadeUpgrade.upgradeTitle	 = "CLUSTER_GRENADE"              						// Title of the upgrade, e.g. Submachine Gun
ClusterGrenadeUpgrade.upgradeDesc 	 = "TIPVIDEO_1_HARD_GRENADE_CLUSTER"				// Description of the upgrade
ClusterGrenadeUpgrade.upgradeTechId  = kTechId.ClusterGrenade 								// TechId of the upgrade, default is kTechId.Move cause its the first entry
ClusterGrenadeUpgrade.hudSlot		 = kGrenadesHUDSlot            							// Is this a primary weapon?
ClusterGrenadeUpgrade.uniqueSlot     = kUpgradeUniqueSlot.Weapon4
ClusterGrenadeUpgrade.minPlayerLevel = 3													// Controls whether this upgrade requires the recipient to be a minimum level
ClusterGrenadeUpgrade.rowOrder 		 = 0													// Controls the horizontal position on the menu
ClusterGrenadeUpgrade.texture 		 = PrecacheAsset("ui/buymenu/Icons/Icon_Grenade1_Active.dds")
ClusterGrenadeUpgrade.vidDesc		 = "videos/Marines_ClusterGrenade.webm"
ClusterGrenadeUpgrade.detailImage		= "ui/buymenu/Background/MarineCenters/Marine_BM_Center_Cluster.dds"
ClusterGrenadeUpgrade.requirements		= {"assault"}

function ClusterGrenadeUpgrade:Initialize()

	CombatWeaponUpgrade.Initialize(self)
	
	self.cost = ClusterGrenadeUpgrade.cost
	self.upgradeName = ClusterGrenadeUpgrade.upgradeName
	self.upgradeTitle = ClusterGrenadeUpgrade.upgradeTitle
	self.upgradeDesc = ClusterGrenadeUpgrade.upgradeDesc
	self.upgradeTechId = ClusterGrenadeUpgrade.upgradeTechId
	self.hudSlot = ClusterGrenadeUpgrade.hudSlot
	self.minPlayerLevel = ClusterGrenadeUpgrade.minPlayerLevel
	self.rowOrder = ClusterGrenadeUpgrade.rowOrder
	self.texture = ClusterGrenadeUpgrade.texture
	self.vidDesc = ClusterGrenadeUpgrade.vidDesc
	self.detailImage = ClusterGrenadeUpgrade.detailImage
	self.requirements = ClusterGrenadeUpgrade.requirements
end

function ClusterGrenadeUpgrade:GetClassName()
	return "ClusterGrenadeUpgrade"
end