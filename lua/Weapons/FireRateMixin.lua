//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//_______________________________

// FireRateMixin.lua

Script.Load("lua/FunctionContracts.lua")

FireRateMixin = CreateMixin( FireRateMixin )
FireRateMixin.type = "VariableFireRate"

FireRateMixin.baseFireRate = 1.0
FireRateMixin.fireRateBoostPerLevel = 0.15

FireRateMixin.expectedMixins =
{
}

FireRateMixin.expectedCallbacks =
{
}

FireRateMixin.overrideFunctions =
{
}

FireRateMixin.expectedConstants =
{
}

FireRateMixin.networkVars =
{
	fireRateScalar = "float",
	weaponFireRateLevel = "integer (0 to " .. #FireRateUpgrade.cost .. ")",
}

function FireRateMixin:__initmixin()

    self.fireRateScalar = FireRateMixin.baseFireRate
	self.weaponFireRateLevel = 0
    
end

function FireRateMixin:SetParent()

	self:UpdateWeaponFireRateLevel()
	
end

function FireRateMixin:OnUpdateAnimationInput(modelMixin)
   
	if modelMixin then
	
		local baseAttackSpeed = 1
		if modelMixin.GetAnimationInput then
			baseAttackSpeed = modelMixin:GetAnimationInput("attack_speed")
		end
		
		local newAttackSpeed = baseAttackSpeed * self.fireRateScalar
		
		if self.fireRateScalar ~= FireRateMixin.baseFireRate then
			modelMixin:SetAnimationInput("attack_speed", newAttackSpeed)
		end
    end
			
end

function FireRateMixin:UpdateWeaponFireRateLevel()

	local player = self:GetParent()
	// Funky hax for alien.
	if not player then
		player = self
	end
	
    if player and HasMixin(player, "WeaponUpgrade") and self.weaponFireRateLevel ~= player:GetFireRateLevel() then
	
		self:SetWeaponFireRateLevel(player:GetFireRateLevel())
		
    end

end

function FireRateMixin:SetWeaponFireRateLevel(newLevel)

	self.weaponFireRateLevel = newLevel
	self.fireRateScalar = FireRateMixin.baseFireRate + (self.weaponFireRateLevel * FireRateMixin.fireRateBoostPerLevel)

end

function FireRateMixin:SetWeaponFireRate(speedPercent)

	self.fireRateScalar = speedPercent

end