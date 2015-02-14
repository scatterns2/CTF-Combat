//________________________________
//
//  NS2: Combat
//    Copyright 2014 Faultline Games Ltd.
//  and Unknown Worlds Entertainment Inc.
//
//________________________________

Script.Load("lua/Weapons/Marine/ClipWeapon.lua")
Script.Load("lua/PickupableWeaponMixin.lua")
Script.Load("lua/LiveMixin.lua")
Script.Load("lua/EntityChangeMixin.lua")
Script.Load("lua/Weapons/ClientWeaponEffectsMixin.lua")

class 'Cannon' (ClipWeapon)

Cannon.kMapName = "cannon"
Cannon.kModelName = PrecacheAsset("models/marine/heavy_cannon/heavy_cannon_world.model")
local kViewModelName = PrecacheAsset("models/marine/heavy_cannon/heavy_cannon_view.model")
local kAnimationGraph = PrecacheAsset("models/marine/heavy_cannon/heavy_cannon.animation_graph")

local kCannonBulletSize = 0.20

local kRange = 250
local kSpread = Math.Radians(8)
local kMinSpread = 0
local kCannonRateOfFire = 1
local kCannonDamage = 50
local kCannonAoeDamage = 0
local kCannonSelfDamage = kCannonAoeDamage
local kAoeRadius = 4
local kCannonWeight = 0.25
local kCannonClipSize = 6

local kButtRange = 1.1

local kExplosionCinematic = PrecacheAsset("cinematics/marine/cannon_impact_explos.cinematic")
//local kExplosionCinematic = PrecacheAsset("cinematics/marine/grenades/cluster_small_explos.cinematic")
local kTracerCinematic = PrecacheAsset("cinematics/marine/cannon_tracer.cinematic")
local kTracerResidueCinematic = PrecacheAsset("cinematics/marine/cannon_tracer_residue.cinematic")

local networkVars =
{
}

AddMixinNetworkVars(LiveMixin, networkVars)

local kMuzzleEffect = PrecacheAsset("cinematics/marine/cannon_muzzle_flash.cinematic")
local kMuzzleAttachPoint = "fxnode_hcmuzzle"

local kAttackSoundName = PrecacheAsset("sound/combat.fev/combat/weapons/marine/heavy_cannon/fire")
local kLocalAttackSoundName = PrecacheAsset("sound/combat.fev/combat/weapons/marine/heavy_cannon/fire_client")

function Cannon:OnCreate()

    ClipWeapon.OnCreate(self)
    
    InitMixin(self, PickupableWeaponMixin)
    InitMixin(self, EntityChangeMixin)
    InitMixin(self, LiveMixin)
	
	if Client then
        InitMixin(self, ClientWeaponEffectsMixin)
	end
    
end

function Cannon:OnInitialized()    
    ClipWeapon.OnInitialized(self)    
end


function Cannon:FirePrimary(player)

    ClipWeapon.FirePrimary(self, player)    
    self:TriggerEffects("cannon_attack")
    
end

if Client then

    function Cannon:OnClientPrimaryAttackStart()
	
		local player = self:GetParent()
		
		/*if player and player:GetIsLocalPlayer() then
			Shared.PlaySound(self, kLocalAttackSoundName)
		else
			Shared.PlaySound(self, kAttackSoundName)
		end*/
	
	end
	
end


function Cannon:GetAnimationGraphName()
    return kAnimationGraph
end

function Cannon:GetViewModelName()
    return kViewModelName
end

function Cannon:GetDeathIconIndex()
    return kDeathMessageIcon.Cannon    
end

function Cannon:GetHUDSlot()
    return kPrimaryWeaponSlot
end

function Cannon:GetPrimaryMinFireDelay()
    return kCannonRateOfFire    
end

function Cannon:GetClipSize()
    return kCannonClipSize
end

function Cannon:GetSpread()
    return kSpread
end

local function CannonRandom()
    return math.max(0.2 + NetworkRandom())
end

function Cannon:CalculateSpreadDirection(shootCoords, player)
    return CalculateSpread(shootCoords, self:GetSpread() * self:GetInaccuracyScalar(player), CannonRandom)
end

function Cannon:GetBulletDamage(target, endPoint)
    return kCannonDamage
end

function Cannon:GetBulletSize()
    return kCannonBulletSize
end

function Cannon:GetRange()
    return kRange
end

function Cannon:GetWeight()
    return kCannonWeight
end

function Cannon:GetPrimaryCanInterruptReload()
    return false
end

function Cannon:GetSecondaryCanInterruptReload()
    return false
end

function Cannon:GetHasSecondary(player)
    return false
end

function Cannon:UpdateViewModelPoseParameters(viewModel)   
end

function Cannon:OnProcessMove(input)
    ClipWeapon.OnProcessMove(self, input)
end

function Cannon:GetAmmoPackMapName()
    return RifleAmmo.kMapName
end


function Cannon:OverrideWeaponName()
    return "rifle"
end

function Cannon:ApplyBulletGameplayEffects(player, target, endPoint, direction, damage, surface, showTracer)

	if not(tostring(endPoint.x) == tostring((-1)^.5) or tostring(endPoint.y) == tostring((-1)^.5) or tostring(endPoint.z) == tostring((-1)^.5)) and Server then
        local surface = GetSurfaceFromEntity(target)
		local params = { surface = surface }
		params[kEffectHostCoords] = Coords.GetTranslation(endPoint)
		GetEffectManager():TriggerEffects("cannon_hit", params)
	end
    local hitEntities = GetEntitiesWithMixinWithinRange("Live", endPoint, kAoeRadius)
    table.removevalue(hitEntities, target)
    
    // reduced damage to yourself
    if (table.contains(hitEntities, player)) then
        table.removevalue(hitEntities, player)
        self:DoDamage(kCannonSelfDamage, player, endPoint, direction, surface, false, showTracer)
    end
    
    RadiusDamage(hitEntities, endPoint, kAoeRadius, kCannonAoeDamage, self)
	
end


function Cannon:OnTag(tagName)

    PROFILE("Cannon:OnTag")

    ClipWeapon.OnTag(self, tagName)
    
    //Print("Ammo: " .. ToString( self.ammo ))
    //Print("Clip: " .. ToString( self.clip ))  
    
end

if Client then    
    
    
    function Cannon:GetBarrelPoint()
    
        local player = self:GetParent()
        if player then
        
            local origin = player:GetEyePos()
            local viewCoords= player:GetViewCoords()
            
            return origin + viewCoords.zAxis * 0.4 + viewCoords.xAxis * -0.15 + viewCoords.yAxis * -0.10
            
        end
        
        return self:GetOrigin()
        
    end    
    
    function Cannon:GetUIDisplaySettings()
        return { xSize = 256, ySize = 500, script = "lua/GUICannonDisplay.lua"}
    end
    
end

function Cannon:ModifyDamageTaken(damageTable, attacker, doer, damageType)

    if damageType ~= kDamageType.Corrode then
        damageTable.damage = 0
    end
    
end

function Cannon:GetCanTakeDamageOverride()
    return self:GetParent() == nil
end

function Cannon:GetTracerEffectName()
    return kTracerCinematic
end

function Cannon:GetTracerResidueEffectName()
    return kTracerResidueCinematic
end

function Cannon:GetTracerEffectFrequency()
    return 1
end

if Server then

    function Cannon:OnKill()
        DestroyEntity(self)
    end
    
    function Cannon:GetSendDeathMessageOverride()
        return false
    end 
    
end

Shared.LinkClassToMap("Cannon", Cannon.kMapName, networkVars)