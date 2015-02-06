// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Weapons\Alien\SpikesMixin.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

SpikesMixin = CreateMixin( SpikesMixin )
SpikesMixin.type = "Spikes"

local kSpread = Math.Radians(2)
local kSpikeSize = 0.03
local kSpikesAttackDelay = 1.0
kSpikesPerShot = 4

// GetHasSecondary and GetSecondaryEnergyCost should completely override any existing
// same named function defined in the object.
SpikesMixin.overrideFunctions =
{
    "GetHasSecondary",
    "GetSecondaryEnergyCost",
    "GetBarrelPoint",
    "OnSecondaryAttack",
    "OnSecondaryAttackEnd",
    "GetTracerEffectName"
    
}

SpikesMixin.networkVars =
{
    shootingSpikes = "boolean",
    // need to use a network variable for silence upgrade here, since the marines do not know the alien tech tree
    silenced = "boolean",
	timeLastSpiked = "time"
}

local function FireSpikes(self)

    local player = self:GetParent()    
    local viewAngles = player:GetViewAngles()
    viewAngles.roll = NetworkRandom() * math.pi * 2
    local shootCoords = viewAngles:GetCoords()
    
    // Filter ourself out of the trace so that we don't hit ourselves.
    local filter = EntityFilterOneAndIsa(player, "Babbler")
    local range = kSpikesRange
    
    local numSpikes = kSpikesPerShot
    local startPoint = player:GetEyePos()
    
    local viewCoords = player:GetViewCoords()
    
    self.spiked = true
    self.silenced = GetHasSilenceUpgrade(player)
    
    for spike = 1, numSpikes do

        // Calculate spread for each shot, in case they differ    
        local spreadDirection = CalculateSpread(viewCoords, kSpread, NetworkRandom) 

        local endPoint = startPoint + spreadDirection * range
        startPoint = player:GetEyePos()
        
        local trace = Shared.TraceRay(startPoint, endPoint, CollisionRep.Damage, PhysicsMask.Bullets, filter)
        if not trace.entity then
            local extents = GetDirectedExtentsForDiameter(spreadDirection, kSpikeSize)
            trace = Shared.TraceBox(extents, startPoint, endPoint, CollisionRep.Damage, PhysicsMask.Bullets, filter)
        end
        
        local distToTarget = math.max(0, (trace.endPoint - startPoint):GetLength() - kSpikeMaxDamageRange)
        
        if trace.fraction < 1 then

            // Have damage increase to reward close combat
            local damageDistScalar = Clamp(1 - (distToTarget / kSpikeMinDamageRange), 0, 1)
            local damage = kSpikeMinDamage + damageDistScalar * (kSpikeMaxDamage - kSpikeMinDamage)
            local direction = (trace.endPoint - startPoint):GetUnit()
            self:DoDamage(damage, trace.entity, trace.endPoint - direction * kHitEffectOffset, direction, trace.surface, true, math.random() < 0.75)
                
        end
        
    end
	
	self.timeLastSpiked = Shared.GetTime()    
end

function SpikesMixin:GetTracerEffectName()
    return kSpikeTracerEffectName
end

function SpikesMixin:GetMinFireDelay()
    return kSpikesAttackDelay
end

function SpikesMixin:GetTracerResidueEffectName()

    local parent = self:GetParent()
    if parent and parent:GetIsLocalPlayer() then
        return kSpikeTracerFirstPersonResidueEffectName
    else
        return kSpikeTracerResidueEffectName
    end 
    
end

function SpikesMixin:OnSecondaryAttack(player)
	
	self.timeLastSpiked = self.timeLastSpiked or 0
	
	local isShootAllowed = (Shared.GetTime() - self.timeLastSpiked) >= self:GetMinFireDelay()
	
    if player:GetEnergy() >= self:GetSecondaryEnergyCost(player) and not self.primaryAttacking and isShootAllowed then
        self.shootingSpikes = true
    else
        self.shootingSpikes = false
        self.secondaryAttacking = false
    end
    
end

function SpikesMixin:OnSecondaryAttackEnd(player)

    Ability.OnSecondaryAttackEnd(self, player)    
    self.secondaryAttacking = false
    self.shootingSpikes = false

end

function SpikesMixin:OnHolster()
    self.shootingSpikes = false
end

function SpikesMixin:GetHasSecondary(player)
    return true
end

function SpikesMixin:GetSecondaryEnergyCost(player)
	local energyMultiplier = 1
	if HasMixin(player, "Focus") then
		energyMultiplier = player:GetFocusEnergyMultiplier()
	end
    return kSpikeEnergyCost * energyMultiplier
end

function SpikesMixin:GetBarrelPoint()

    local player = self:GetParent()
    
    if player then
    
        local viewCoords = player:GetViewCoords()
        local barrelPoint = viewCoords.origin + viewCoords.zAxis * 2 - viewCoords.yAxis * 0.1
        
        if self.shootLeft then
            barrelPoint = barrelPoint - viewCoords.xAxis * 0.4
        else
            barrelPoint = barrelPoint + viewCoords.xAxis * 0.4
        end
        
        self.shootLeft = not self.shootLeft
        
        return barrelPoint
        
    end

end

function SpikesMixin:OnTag(tagName)

    PROFILE("SpikesMixin:OnTag")

    if self.shootingSpikes and tagName == "shoot" then
    
        local player = self:GetParent()
        if player and player:GetEnergy() > self:GetSecondaryEnergyCost() then
        
            FireSpikes(self)
            self:GetParent():DeductAbilityEnergy(self:GetSecondaryEnergyCost())
            self.secondaryAttacking = true

        else
            self.shootingSpikes = false
            self.secondaryAttacking = false
        end
        
    end

end

function SpikesMixin:OnUpdateAnimationInput(modelMixin)

    PROFILE("SpikesMixin:OnUpdateAnimationInput")

    local player = self:GetParent()
    if player and self.shootingSpikes and player:GetEnergy() >= self:GetSecondaryEnergyCost(player) then
        modelMixin:SetAnimationInput("activity", "secondary")
    end
    
end

function SpikesMixin:GetIsSecondaryBlocking()
    return self.secondaryAttacking
end

function SpikesMixin:OnClientSecondaryAttacking()

    if not self.silenced then
        self:TriggerEffects("spikes_attack")
    end
    
end

function SpikesMixin:GetTriggerSecondaryEffects()

    local parent = self:GetParent()
    return parent ~= nil and parent:GetIsAlive()

end

function SpikesMixin:GetDamageType()
    return kSpikeDamageType
end