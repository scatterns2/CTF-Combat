// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Weapons\Marine\HealGun.lua
//
//    Created by:   Andreas Urwalek (a_urwa@sbox.tugraz.at)
//
//    Weapon used for repairing structures and armor of friendly players (marines, exosuits, jetpackers).
//    Uses hud slot 3 (replaces axe)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Weapons/Weapon.lua")
Script.Load("lua/PickupableWeaponMixin.lua")
Script.Load("lua/LiveMixin.lua")

class 'HealGun' (Weapon)

HealGun.kMapName = "healgun"

HealGun.kModelName = PrecacheAsset("models/marine/welder/welder.model")
local kViewModels = GenerateMarineViewModelPaths("welder")
local kAnimationGraph = PrecacheAsset("models/marine/welder/welder_view.animation_graph")

kHealGunHUDSlot = 3

local kHealGunTraceExtents = Vector(0.4, 0.4, 0.4)

local networkVars =
{
    healing = "boolean",
    loopingSoundEntId = "entityid",
    deployed = "boolean"
}

AddMixinNetworkVars(LiveMixin, networkVars)

local kHealGunFireDelay = 0.5
local kHealGunDamagePerSecond = 30
local kWeldRange = 3.4
local kHealGunEffectRate = 0.45
local kHealRate = 2.5
local kFireLoopingSound = PrecacheAsset("sound/NS2.fev/marine/welder/weld")

local kHealScoreAdded = 2
// Every kAmountHealedForPoints points of damage healed, the player gets
// kHealScoreAdded points to their score.

local kAmountHealedForPoints = 600

function HealGun:OnCreate()

    Weapon.OnCreate(self)
    
    self.healing = false
    self.deployed = false
    
    InitMixin(self, PickupableWeaponMixin)
    InitMixin(self, LiveMixin)
    
    self.loopingSoundEntId = Entity.invalidId
    
    if Server then
    
        self.loopingFireSound = Server.CreateEntity(SoundEffect.kMapName)
        self.loopingFireSound:SetAsset(kFireLoopingSound)
        // SoundEffect will automatically be destroyed when the parent is destroyed (the HealGun).
        self.loopingFireSound:SetParent(self)
        self.loopingSoundEntId = self.loopingFireSound:GetId()
        
    end
    
end

function HealGun:OnInitialized()

    self:SetModel(HealGun.kModelName)
    
    Weapon.OnInitialized(self)
    
    self.timeWeldStarted = 0
    self.timeLastWeld = 0
    
end

function HealGun:GetIsValidRecipient(recipient)

    if self:GetParent() == nil and recipient and not GetIsVortexed(recipient) and recipient:isa("Marine") then
    
        local healgun = recipient:GetWeapon(HealGun.kMapName)
        return healgun == nil
        
    end
    
    return false
    
end

function HealGun:GetViewModelName(sex, variant)
    return kViewModels[sex][variant]
end

function HealGun:GetAnimationGraphName()
    return kAnimationGraph
end

function HealGun:GetHUDSlot()
    return kHealGunHUDSlot
end

function HealGun:GetIsDroppable()
    return true
end

function HealGun:OnHolster(player)

    Weapon.OnHolster(self, player)
    
    self.healing = false
    self.deployed = false
    // cancel muzzle effect
    self:TriggerEffects("welder_holster")
    
end

function HealGun:OnDraw(player, previousWeaponMapName)

    Weapon.OnDraw(self, player, previousWeaponMapName)
    
    self:SetAttachPoint(Weapon.kHumanAttachPoint)
    self.healing = false
    self.deployed = false
    
end


function HealGun:OnTag(tagName)

    if tagName == "deploy_end" then
        self.deployed = true
    end

end

function HealGun:GetIsAffectedByWeaponUpgrades()
    return false
end

// don't play 'welder_attack' and 'welder_attack_end' too often, would become annoying with the sound effects and also client fps
function HealGun:OnPrimaryAttack(player)

    if GetIsVortexed(player) or not self.deployed then
        return
    end
    
    PROFILE("HealGun:OnPrimaryAttack")
    
    if not self.healing then
    
        self:TriggerEffects("welder_start")
        self.timeWeldStarted = Shared.GetTime()
        
        if Server then
            self.loopingFireSound:Start()
        end
        
    end
    
    self.healing = true
    local hitPoint = nil
    
    if self.timeLastWeld + kHealGunFireDelay < Shared.GetTime () then
    
        hitPoint = self:PerformWeld(player)
        self.timeLastWeld = Shared.GetTime()
        
    end
    
    if not self.timeLastWeldEffect or self.timeLastWeldEffect + kHealGunEffectRate < Shared.GetTime() then
    
        self:TriggerEffects("welder_muzzle")
        self.timeLastWeldEffect = Shared.GetTime()
        
    end
    
end

function HealGun:GetSprintAllowed()
    return true
end

// welder wont break sprinting
function HealGun:GetTryingToFire(input)
    return false
end

function HealGun:GetDeathIconIndex()
    return kDeathMessageIcon.HealGun
end

function HealGun:OnPrimaryAttackEnd(player)

    if self.healing then
        self:TriggerEffects("welder_end")
    end
    
    self.healing = false
    
    if Server then
        self.loopingFireSound:Stop()
    end
    
end

function HealGun:Dropped(prevOwner)

    Weapon.Dropped(self, prevOwner)
    
    if Server then
        self.loopingFireSound:Stop()
    end
    
    self.healing = false
    self.deployed = false
    
end

function HealGun:GetRange()
    return kWeldRange
end

function HealGun:GetMeleeBase()
    return 2, 2
end

local function PrioritizeDamagedFriends(weapon, player, newTarget, oldTarget)
    return not oldTarget or (HasMixin(newTarget, "Team") and newTarget:GetTeamNumber() == player:GetTeamNumber() and (HasMixin(newTarget, "Weldable") and newTarget:GetCanBeWelded(weapon)))
end

function HealGun:PerformWeld(player)

    local attackDirection = player:GetViewCoords().zAxis
    local success = false
    // prioritize friendlies
    local didHit, target, endPoint, direction, surface = CheckMeleeCapsule(self, player, 0, self:GetRange(), nil, true, 1, PrioritizeDamagedFriends, nil, PhysicsMask.Flame)
    
    if didHit and target and HasMixin(target, "Live") then
        
        if GetAreEnemies(player, target) then
            self:DoDamage(kHealGunDamagePerSecond * kHealGunFireDelay, target, endPoint, attackDirection)
            success = true     
        elseif player:GetTeamNumber() == target:GetTeamNumber() and self:GetIsAlive() then
        
			if target:GetHealth() < target:GetMaxHealth() then                 

				target:AddHealth(kHealRate + kHealGunFireDelay * kSelfWeldAmount)
				
            end
 
			
         end
        
    end
    
    if player:GetHealth() < player:GetMaxHealth() then
	
		player:AddHealth(kHealRate + kHealGunFireDelay * kSelfWeldAmount)
	
    end
	
    if success then    
        return endPoint
    end
    
end

function HealGun:GetShowDamageIndicator()
    return true
end

function HealGun:GetReplacementWeaponMapName()
    return Axe.kMapName
end

function HealGun:OnUpdateAnimationInput(modelMixin)

    PROFILE("HealGun:OnUpdateAnimationInput")
    
    local parent = self:GetParent()
    local sprinting = parent ~= nil and HasMixin(parent, "Sprint") and parent:GetIsSprinting()
    local activity = (self.healing and not sprinting) and "primary" or "none"
    
    modelMixin:SetAnimationInput("activity", activity)
    modelMixin:SetAnimationInput("welder", true)
    
end

function HealGun:UpdateViewModelPoseParameters(viewModel)
    viewModel:SetPoseParam("welder", 1)    
end

function HealGun:OnUpdatePoseParameters(viewModel)

    PROFILE("HealGun:OnUpdatePoseParameters")
    self:SetPoseParam("welder", 1)
    
end

function HealGun:OnUpdateRender()

    Weapon.OnUpdateRender(self)
    
    if self.ammoDisplayUI then
    
        local progress = PlayerUI_GetUnitStatusPercentage()
        self.ammoDisplayUI:SetGlobal("weldPercentage", progress)
        
    end
    
    local parent = self:GetParent()
    if parent and self.healing then

        if (not self.timeLastWeldHitEffect or self.timeLastWeldHitEffect + 0.06 < Shared.GetTime()) then
        
            local viewCoords = parent:GetViewCoords()
        
            local trace = Shared.TraceRay(viewCoords.origin, viewCoords.origin + viewCoords.zAxis * self:GetRange(), CollisionRep.Damage, PhysicsMask.Flame, EntityFilterTwo(self, parent))
            if trace.fraction ~= 1 then
            
                local coords = Coords.GetTranslation(trace.endPoint - viewCoords.zAxis * .1)
                
                local className = nil
                if trace.entity then
                    className = trace.entity:GetClassName()
                end
                
                self:TriggerEffects("welder_hit", { classname = className, effecthostcoords = coords})
                
            end
            
            self.timeLastWeldHitEffect = Shared.GetTime()
            
        end
        
    end
    
end

function HealGun:ModifyDamageTaken(damageTable, attacker, doer, damageType)
    if damageType ~= kDamageType.Corrode then
        damageTable.damage = 0
    end
end

function HealGun:GetCanTakeDamageOverride()
    return self:GetParent() == nil
end

if Server then

    function HealGun:OnKill()
        DestroyEntity(self)
    end
    
    function HealGun:GetSendDeathMessageOverride()
        return false
    end    
    
end

function HealGun:GetIsWelding()
    return self.healing
end

if Client then

    function HealGun:GetUIDisplaySettings()
        return { xSize = 512, ySize = 512, script = "lua/GUIWelderDisplay.lua" }
    end
    
end

Shared.LinkClassToMap("HealGun", HealGun.kMapName, networkVars)