// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Fade.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// Role: Surgical striker, harassment
//
// The Fade should be a fragile, deadly-sharp knife. Wielded properly, it's force is undeniable. But
// used clumsily or without care will only hurt the user. Make sure Fade isn't better than the Skulk 
// in every way (notably, vs. Structures). To harass, he must be able to stay out in the field
// without continually healing at base, and needs to be able to use blink often.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Utility.lua")
Script.Load("lua/Weapons/Alien/SwipeBlink.lua")
Script.Load("lua/Weapons/Alien/StabBlink.lua")
Script.Load("lua/Weapons/Alien/Vortex.lua")
Script.Load("lua/Weapons/Alien/ReadyRoomBlink.lua")
Script.Load("lua/Alien.lua")
Script.Load("lua/Mixins/BaseMoveMixin.lua")
Script.Load("lua/Mixins/GroundMoveMixin.lua")
Script.Load("lua/CelerityMixin.lua")
Script.Load("lua/Mixins/JumpMoveMixin.lua")
Script.Load("lua/Mixins/CrouchMoveMixin.lua")
Script.Load("lua/Mixins/CameraHolderMixin.lua")
Script.Load("lua/DissolveMixin.lua")
Script.Load("lua/TunnelUserMixin.lua")
Script.Load("lua/BabblerClingMixin.lua")
Script.Load("lua/RailgunTargetMixin.lua")
Script.Load("lua/Weapons/PredictedProjectile.lua")
Script.Load("lua/IdleMixin.lua")
Script.Load("lua/FadeVariantMixin.lua")
Script.Load("lua/Weapons/Alien/AcidRocket.lua")
Script.Load("lua/Weapons/Alien/VoidShield.lua")

class 'Fade' (Alien)

Fade.kMapName = "fade"

Fade.kModelName = PrecacheAsset("models/alien/fade/fade.model")
local kViewModelName = PrecacheAsset("models/alien/fade/fade_view.model")
local kFadeAnimationGraph = PrecacheAsset("models/alien/fade/fade.animation_graph")

PrecacheAsset("models/alien/fade/fade.surface_shader")

local kViewOffsetHeight = 1.7
Fade.XZExtents = 0.4
Fade.YExtents = 1.05
Fade.kHealth = kFadeHealth
Fade.kArmor = kFadeArmor
// ~350 pounds.
local kMass = 158
local kJumpHeight = 1.4

local kFadeScanDuration = 4

local kShadowStepCooldown = 0.73
local kShadowStepForce = 30 //21

local kShadowStepSpeed = 30
Fade.kShadowStepDuration = 0.25

local kMaxSpeed = 6.2
local kBlinkSpeed = 12
local kBlinkAcceleration = 40
local kBlinkAddAcceleration = 3
local kVoidShieldAnimationDelay = 0.65
local kStabSpeed = 3
local kShieldDuration = 1.25

// Delay before you can blink again after a blink.
local kMinEnterEtherealTime = 0.5

local kFadeGravityMod = 0.93

if Server then
    Script.Load("lua/Fade_Server.lua")
elseif Client then    
    Script.Load("lua/Fade_Client.lua")
end

local networkVars =
{
    isScanned = "boolean",
    shadowStepping = "boolean",
    timeShadowStep = "private compensated time",
    shadowStepDirection = "private vector",
    shadowStepSpeed = "private compensated interpolated float",
    
    etherealStartTime = "private time",
    etherealEndTime = "private time",
    
    // True when we're moving quickly "through the ether"
    ethereal = "boolean",
    
    landedAfterBlink = "private compensated boolean",  
    
    timeOfLastPhase = "time",
    hasEtherealGate = "boolean"
    
}

AddMixinNetworkVars(BaseMoveMixin, networkVars)
AddMixinNetworkVars(GroundMoveMixin, networkVars)
AddMixinNetworkVars(JumpMoveMixin, networkVars)
AddMixinNetworkVars(CrouchMoveMixin, networkVars)
AddMixinNetworkVars(CelerityMixin, networkVars)
AddMixinNetworkVars(CameraHolderMixin, networkVars)
AddMixinNetworkVars(DissolveMixin, networkVars)
AddMixinNetworkVars(TunnelUserMixin, networkVars)
AddMixinNetworkVars(BabblerClingMixin, networkVars)
AddMixinNetworkVars(IdleMixin, networkVars)
AddMixinNetworkVars(FadeVariantMixin, networkVars)

function Fade:OnCreate()

    InitMixin(self, BaseMoveMixin, { kGravity = Player.kGravity * kFadeGravityMod })
    InitMixin(self, GroundMoveMixin)
    InitMixin(self, JumpMoveMixin)
    InitMixin(self, CrouchMoveMixin)
    InitMixin(self, CelerityMixin)
    InitMixin(self, CameraHolderMixin, { kFov = kFadeFov })
    
    Alien.OnCreate(self)
    
    InitMixin(self, DissolveMixin)
    InitMixin(self, TunnelUserMixin)
    InitMixin(self, BabblerClingMixin)
    InitMixin(self, FadeVariantMixin)
	
	InitMixin(self, PredictedProjectileShooterMixin)
    
    if Client then
        InitMixin(self, RailgunTargetMixin)
    end
    
    self.shadowStepDirection = Vector()
    
    if Server then
    
        self.timeLastScan = 0
        self.isBlinking = false
        self.timeShadowStep = 0
        self.shadowStepping = false
        
    end
    
    self.etherealStartTime = 0
    self.etherealEndTime = 0
    self.ethereal = false
    self.landedAfterBlink = true
	self.timeVoidShield = 0
    self.shieldAmount = 0
	
end

function Fade:OnInitialized()

    Alien.OnInitialized(self)
    
    self:SetModel(Fade.kModelName, kFadeAnimationGraph)
    
    if Client then
    
        self.blinkDissolve = 0
        
        self:AddHelpWidget("GUIFadeBlinkHelp", 2)
        self:AddHelpWidget("GUIFadeShadowStepHelp", 2)
        self:AddHelpWidget("GUITunnelEntranceHelp", 1)
        
    end
    
    InitMixin(self, IdleMixin)
    
end

function Fade:GetShowElectrifyEffect()
    return self.hasEtherealGate or self.electrified
end

function Fade:ModifyJump(input, velocity, jumpVelocity)
		// Fade jumps slightly lower because it has Blink
		//jumpVelocity:Scale(kFadeGravityMod)

end

function Fade:OnDestroy()

    Alien.OnDestroy(self)
    
    if Client then
        self:DestroyTrailCinematic()
    end
    
end

function Fade:GetControllerPhysicsGroup()

    if self.isHallucination then
        return PhysicsGroup.SmallStructuresGroup
    end

    return PhysicsGroup.BigPlayerControllersGroup  
  
end

function Fade:GetInfestationBonus()
    return kFadeInfestationSpeedBonus
end

function Fade:GetCarapaceSpeedReduction()
    return kFadeCarapaceSpeedReduction
end

function Fade:MovementModifierChanged(newMovementModifierState, input)

    if newMovementModifierState and self:GetActiveWeapon() ~= nil then
        local weaponMapName = self:GetActiveWeapon():GetMapName()
        local vshieldweapon = self:GetWeapon(VoidShield.kMapName)
        if vshieldweapon and not vshieldweapon:GetHasAttackDelay() and self:GetEnergy() >= vshieldweapon:GetEnergyCost() then
            self:SetActiveWeapon(VoidShield.kMapName)
            self:PrimaryAttack()
            if weaponMapName ~= VoidShield.kMapName then
                self.previousweapon = weaponMapName

            end
        end
    end
    //self:TriggerShadowStep(input.move)
    
end

function Fade:ModifyCrouchAnimation(crouchAmount)    
    return Clamp(crouchAmount * (1 - ( (self:GetVelocityLength() - kMaxSpeed) / (kMaxSpeed * 0.5))), 0, 1)
end

function Fade:GetHeadAttachpointName()
    return "fade_tongue2"
end

// Prevents reseting of celerity.
function Fade:OnSecondaryAttack()
end

function Fade:GetBaseArmor()
    return Fade.kArmor
end

function Fade:GetBaseHealth()
    return Fade.kHealth
end

function Fade:GetHealthPerBioMass()
    return kFadeHealthPerBioMass
end

function Fade:GetArmorFullyUpgradedAmount()
    return kFadeArmorFullyUpgradedAmount
end

function Fade:GetMaxViewOffsetHeight()
    return kViewOffsetHeight
end

function Fade:GetViewModelName()
    return self:GetVariantViewModel(self:GetVariant())
end

function Fade:GetCanStep()
    return not self:GetIsBlinking()
end

function Fade:ModifyGravityForce(gravityTable)

    if self:GetIsBlinking() or self:GetIsOnGround() then
        gravityTable.gravity = 0
    elseif self.gravityTrigger and self.gravityTrigger ~= 0 then
        local ent = Shared.GetEntity(self.gravityTrigger)
        if ent then
            gravityTable.gravity = ent:GetGravityOverride(gravity) 
        end
    end

end

function Fade:GetPerformsVerticalMove()
    return self:GetIsBlinking()
end

function Fade:GetAcceleration()
    return 10
end

function Fade:GetGroundFriction()
    return self:GetIsShadowStepping() and 0 or 8
end  

function Fade:GetAirControl()
    return 30 //40
end   

function Fade:GetAirFriction()
    return (self:GetIsBlinking() or self:GetRecentlyShadowStepped()) and 0 or (0.2 - GetCelerityLevel(self) * 0.01)
end 

function Fade:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsBlinking() then
    
        local wishDir = self:GetViewCoords().zAxis
        local maxSpeedTable = { maxSpeed = kBlinkSpeed }
        self:ModifyMaxSpeed(maxSpeedTable, input)  
        local prevSpeed = velocity:GetLength()
        local maxSpeed = math.max(prevSpeed, maxSpeedTable.maxSpeed)
        local maxSpeed = math.min(25, maxSpeed)    
        
        velocity:Add(wishDir * kBlinkAcceleration * deltaTime)
        
        if velocity:GetLength() > maxSpeed then

            velocity:Normalize()
            velocity:Scale(maxSpeed)
            
        end 
        
        // additional acceleration when holding down blink to exceed max speed
        velocity:Add(wishDir * kBlinkAddAcceleration * deltaTime)
        
    end

end

function Fade:GetIsStabbing()

    local stabWeapon = self:GetWeapon(StabBlink.kMapName)
    return stabWeapon and stabWeapon:GetIsStabbing()    

end

function Fade:GetCanJump()
    return self:GetIsOnGround() and not self:GetIsBlinking() and not self:GetIsStabbing()
end

function Fade:GetIsShadowStepping()
    return self.shadowStepping
end

function Fade:GetMaxSpeed(possible)

    if possible then
        return kMaxSpeed
    end
    
    if self:GetIsBlinking() then
        return kBlinkSpeed
    end
    
    // Take into account crouching.
    return kMaxSpeed
    
end

function Fade:GetMass()
    return kMass
end

function Fade:GetJumpHeight()
    return kJumpHeight
end

function Fade:GetIsBlinking()
    return self.ethereal and self:GetIsAlive()
end

function Fade:GetRecentlyBlinked(player)
    return Shared.GetTime() - self.etherealEndTime < kMinEnterEtherealTime
end

function Fade:GetHasShadowStepAbility()
    return self:GetHasTwoHives()
end

function Fade:GetHasShadowStepCooldown()
    return self.timeShadowStep + kShadowStepCooldown > Shared.GetTime()
end

function Fade:GetRecentlyShadowStepped()
    return self.timeShadowStep + kShadowStepCooldown * 2 > Shared.GetTime()
end

function Fade:GetMovementSpecialTechId()
	return kTechId.VoidShield
	//return kTechId.ShadowStep
end

function Fade:GetHasMovementSpecial()
    return self:GetHasOneHive()
end

function Fade:GetMovementSpecialEnergyCost()
	return kVoidShieldEnergyCost
    //return kFadeShadowStepCost
end

function Fade:GetCollisionSlowdownFraction()
    return 0.05
end

function Fade:TriggerShadowStep(direction)

    --if not self:GetHasMovementSpecial() then
    --   return
    --end
	
    if direction:GetLength() == 0 then
        direction.z = 1
    end

    direction:Normalize() 

    local movementDirection = self:GetViewCoords():TransformVector( direction )
    
    if self:GetIsOnSurface() then
    
        movementDirection.y = 0
        movementDirection:Normalize()
        
    else
        movementDirection.y = math.min(0.25, movementDirection.y)
    end    

    local weapon = self:GetActiveWeapon()
    local canShadowStep = not weapon or not weapon.GetCanShadowStep or weapon:GetCanShadowStep()
    
    if canShadowStep and not self:GetIsBlinking() and not self:GetHasShadowStepCooldown() and self:GetEnergy() > kFadeShadowStepCost /* and not self:GetRecentlyJumped() */ then

        local velocity = self:GetVelocity()
		
        self:SetVelocity( movementDirection * kShadowStepForce * self:GetSlowSpeedModifier())
        
        self.timeShadowStep = Shared.GetTime()
        self.shadowStepping = true
        self.shadowStepDirection = direction
        
        self:TriggerEffects("shadow_step", {effecthostcoords = Coords.GetLookIn(self:GetOrigin(), movementDirection)})
        
        /*
        if Client and Client.GetLocalPlayer() == self then
            self:TriggerFirstPersonMiniBlinkEffect(direction)
        end
        */
        
        self:DeductAbilityEnergy(kFadeShadowStepCost)
        self:TriggerUncloak()
    
    end
    
end

function Fade:GetHasVoidShieldAnimationDelay()
    return self.timeVoidShield + kVoidShieldAnimationDelay > Shared.GetTime()
end

function Fade:GetCanMetabolizeHealth()
    return true
end

function Fade:OverrideInput(input)

    Alien.OverrideInput(self, input)
    
    if self:GetIsShadowStepping() then
        input.move = self.shadowStepDirection
    elseif self:GetIsBlinking() then
        input.move.z = 1
        input.move.x = 0
    end
    
    return input
    
end

function Fade:OnProcessMove(input)

    Alien.OnProcessMove(self, input)
    
    if Server then
    
        if self.isScanned and self.timeLastScan + kFadeScanDuration < Shared.GetTime() then
            self.isScanned = false
        end

    end
    
	if not self:GetHasVoidShieldAnimationDelay() and self.previousweapon ~= nil then
        self:SetActiveWeapon(self.previousweapon)
        self.previousweapon = nil
    end
        
end

function Fade:GetBlinkAllowed()

    local weapons = self:GetWeapons()
    for i = 1, #weapons do
    
        if not weapons[i]:GetBlinkAllowed() then
            return false
        end
        
    end

    return true

end

function Fade:OnScan()

    if Server then
    
        self.timeLastScan = Shared.GetTime()
        self.isScanned = true
        
    end
    
end

function Fade:GetStepHeight()

    if self:GetIsBlinking() then
        return 2
    end
    
    return Player.GetStepHeight()
    
end

function Fade:SetDetected(state)

    if Server then
    
        if state then
        
            self.timeLastScan = Shared.GetTime()
            self.isScanned = true
            
        else
            self.isScanned = false
        end
        
    end
    
end

function Fade:OnUpdateAnimationInput(modelMixin)

    if not self:GetHasVoidShieldAnimationDelay() then
        Alien.OnUpdateAnimationInput(self, modelMixin)

        if self.timeOfLastPhase + 0.5 > Shared.GetTime() then
            modelMixin:SetAnimationInput("move", "teleport")
        end
    else
        local weapon = self:GetActiveWeapon()
        if weapon ~= nil and weapon.OnUpdateAnimationInput and weapon:GetMapName() == VoidShield.kMapName then
            weapon:OnUpdateAnimationInput(modelMixin)
        end
    end

end

function Fade:TriggerBlink()
    self.ethereal = true
    self.landedAfterBlink = false
end

function Fade:OnBlinkEnd()
    self.ethereal = false
end

function Fade:PreUpdateMove(input, runningPrediction)
    self.shadowStepping = self.timeShadowStep + Fade.kShadowStepDuration > Shared.GetTime()
end

/*
function Fade:ModifyAttackSpeed(attackSpeedTable)
	local weaponMapName = self:GetActiveWeapon():GetMapName()
	if weaponMapName == VoidShield.kMapName then
		attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 3
	end
end
*/

function Fade:GetEngagementPointOverride()
    return self:GetOrigin() + Vector(0, 0.8, 0)
end

/*
function Fade:ModifyHeal(healTable)
    Alien.ModifyHeal(self, healTable)
    healTable.health = healTable.health * 1.7
end
*/

function Fade:OverrideVelocityGoal(velocityGoal)
    
    if not self:GetIsOnGround() and self:GetCrouching() then
        velocityGoal:Scale(0)
    end
    
end
/*
function Fade:HandleButtons(input)

    Alien.HandleButtons(self, input)
    
    if self:GetIsBlinking() then 
        input.commands = bit.bor(input.commands, Move.Crouch)    
    end

end
*/
function Fade:OnGroundChanged(onGround, impactForce, normal, velocity)

    Alien.OnGroundChanged(self, onGround, impactForce, normal, velocity)

    if onGround then
        self.landedAfterBlink = true
    end
    
end

function Fade:GetMovementSpecialCooldown()
    local cooldown = 0
    local timeLeft = (Shared.GetTime() - self.timeVoidShield)
    
    local voidshieldWeapon = self:GetWeapon(VoidShield.kMapName)
    local shieldDelay = voidshieldWeapon and voidshieldWeapon:GetAttackDelay() or 0
    if timeLeft < shieldDelay then
        return Clamp(timeLeft / shieldDelay, 0, 1)
    end
    
    return cooldown
end

function Fade:GetShieldAmount()
	return self.shieldAmount
end

function Fade:SetShield(amount)
	self.shieldAmount = amount
	self:AddTimedCallback(Fade.ShieldExpire, kShieldDuration)
	return self.shieldAmount
end

function Fade:ModifyDamageTaken(damageTable, attacker, doer, damageType, hitPoint)
	local prevShieldHP = self.shieldAmount
    if prevShieldHP > 0 then
		local damageBlocked = math.max(0, math.min(prevShieldHP, damageTable.damage))
		self.shieldAmount = self.shieldAmount - damageBlocked
		damageTable.damage = damageTable.damage - damageBlocked
		
		self:TriggerEffects("boneshield_blocked", {effecthostcoords = Coords.GetTranslation(hitPoint)} )
		
	end
end

function Fade:ShieldExpire()
	if Shared.GetTime() >= self.timeVoidShield + kShieldDuration then
		self.shieldAmount = 0
	//if Client then Print("Shield Gone") end
	end
end

Shared.LinkClassToMap("Fade", Fade.kMapName, networkVars, true)