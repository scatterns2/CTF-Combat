//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//_______________________________

// CarapaceMixin.lua

CarapaceMixin = CreateMixin( CarapaceMixin )
CarapaceMixin.type = "Carapace"

CarapaceMixin.hpPercentPerLevel = 0.15 //0.07
CarapaceMixin.hpScalarPerLevel = 0 //4
CarapaceMixin.armorPercentPerLevel = 0.15
CarapaceMixin.armorScalarPerLevel = 0 //5

CarapaceMixin.expectedMixins =
{
	Live = "For setting the armor/hp values",
	ArmorUpgrade = "To allow armor upgrade",
	HealthUpgrade = "To allow health upgrade",
}

CarapaceMixin.expectedCallbacks =
{
}

CarapaceMixin.expectedConstants =
{
}

CarapaceMixin.networkVars =
{
	upgradeCarapaceLevel = "integer (0 to " .. #CarapaceUpgrade.cost .. ")",
}

function CarapaceMixin:__initmixin()

	if Server then
		self.upgradeCarapaceLevel = 0
	end

end

function CarapaceMixin:CopyPlayerDataFrom(player)

	if Server then
		self.upgradeCarapaceLevel = player.upgradeCarapaceLevel
	end

end

function CarapaceMixin:OnInitialized()
	if Server then
		self:ApplyCarapace()
	end
end

function CarapaceMixin:GetHasCarapace()
	return self.upgradeCarapaceLevel > 0
end

function CarapaceMixin:GetCarapaceLevel()
	return self.upgradeCarapaceLevel
end

function CarapaceMixin:SetCarapaceLevel(newLevel)
	if Server then
		self.upgradeCarapaceLevel = newLevel
		self:ApplyCarapace()
	end
end

function CarapaceMixin:ApplyCarapaceHealth(origHealth)

	return origHealth + self:GetCarapaceLevel() * (CarapaceMixin.hpPercentPerLevel * origHealth + CarapaceMixin.hpScalarPerLevel)

end

function CarapaceMixin:ApplyCarapaceArmor(origArmor)

	return origArmor + self:GetCarapaceLevel() * (CarapaceMixin.armorPercentPerLevel * origArmor + CarapaceMixin.armorScalarPerLevel)

end

function CarapaceMixin:ApplyCarapace()
	
	if Server then
		self:UpgradeArmor()
		self:UpgradeHealth()
	end
	
end