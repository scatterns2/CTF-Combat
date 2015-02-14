// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Weapons\Revolver.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Weapons/Marine/Pistol.lua")

class 'Revolver' (Pistol)

Revolver.kMapName = "revolver"

Revolver.kModelName = PrecacheAsset("models/marine/revolver/revolver_world.model")
local kViewModelName = PrecacheAsset("models/marine/revolver/revolver_view.model")
local kAnimationGraph = PrecacheAsset("models/marine/revolver/revolver_view.animation_graph")

local kRange = 200
local kSpread = Math.Radians(1)
local kAltSpread = ClipWeapon.kCone0Degrees

local kLaserAttachPoint = "fxnode_laser"

if Client then

    function Revolver:GetBarrelPoint()

        local player = self:GetParent()
        if player then
        
            local origin = player:GetEyePos()
            local viewCoords= player:GetViewCoords()
        
            return origin + viewCoords.zAxis * 0.4 + viewCoords.xAxis * -0.1 + viewCoords.yAxis * -0.2
        end
        
        return self:GetOrigin()
        
    end
    
    function Revolver:OverrideLaserLength()
    
        local parent = self:GetParent()
        
        if parent and parent == Client.GetLocalPlayer() and not parent:GetIsThirdPerson() then
            return 0.3
        end

        return 20
    
    end
    
    function Revolver:OverrideLaserWidth()
    
        local parent = self:GetParent()
        
        if parent and parent == Client.GetLocalPlayer() and not parent:GetIsThirdPerson() then
            return 0.02
        end

        return 0.045
    
    end
    
    function Revolver:OverrideStartColor()
    
        local parent = self:GetParent()
        
        if parent and parent == Client.GetLocalPlayer() and not parent:GetIsThirdPerson() then
            return Color(1, 0, 0, 0.35)
        end

        return Color(1, 0, 0, 0.7)
        
    end
    
    function Revolver:OverrideEndColor()
    
        local parent = self:GetParent()
        
        if parent and parent == Client.GetLocalPlayer() and not parent:GetIsThirdPerson() then
            return Color(1, 0, 0, 0)
        end

        return Color(1, 0, 0, 0.07)
        
    end

    function Revolver:GetLaserAttachCoords()
    
        // return first person coords
        local parent = self:GetParent()
        if parent and parent == Client.GetLocalPlayer() then

            local viewModel = parent:GetViewModelEntity()
        
            if Shared.GetModel(viewModel.modelIndex) then
                
                local viewCoords = parent:GetViewCoords()
                local attachCoords = viewModel:GetAttachPointCoords(kLaserAttachPoint)
                
                attachCoords.origin = viewCoords:TransformPoint(attachCoords.origin)
                
                // when we are not reloading or sprinting then return the view axis (otherwise the laser pointer goes in wrong direction)
                /*
                if not self:GetIsReloading() and not parent:GetIsSprinting() then
                
                    attachCoords.zAxis = viewCoords.zAxis
                    attachCoords.xAxis = viewCoords.xAxis
                    attachCoords.yAxis = viewCoords.yAxis

                else*/
                
                    attachCoords.zAxis = viewCoords:TransformVector(attachCoords.zAxis)
                    attachCoords.xAxis = viewCoords:TransformVector(attachCoords.xAxis)
                    attachCoords.yAxis = viewCoords:TransformVector(attachCoords.yAxis)
                    
                    local zAxis = attachCoords.zAxis
                    attachCoords.zAxis = attachCoords.xAxis
                    attachCoords.xAxis = zAxis
                    
                //end
                
                attachCoords.origin = attachCoords.origin - attachCoords.zAxis * 0.1
                
                return attachCoords
            
            end
            
        end
        
        // return third person coords
        return self:GetAttachPointCoords(kLaserAttachPoint)
        
    end
    
    function Revolver:GetUIDisplaySettings()
        return { xSize = 512, ySize = 512, script = "lua/GUIRevolverDisplay.lua" }
    end
    
end

function Revolver:OverrideWeaponName()
    return "pistol"
end
	
function Revolver:OnMaxFireRateExceeded()
    self.queuedShots = Clamp(self.queuedShots + 1, 0, 10)
end

function Revolver:GetAnimationGraphName()
    return kAnimationGraph
end

function Revolver:GetViewModelName(sex, variant)
    return kViewModelName
end

function Revolver:GetDeathIconIndex()
    return kDeathMessageIcon.Revolver
end

function Revolver:GetPrimaryMinFireDelay()
    return kRevolverRateOfFire    
end

function Revolver:GetWeight()
    return kRevolverWeight
end

function Revolver:GetClipSize()
    return kRevolverClipSize
end

function Revolver:GetNumStartClips()
    return 6
end

function Revolver:GetSpread()
    return ConditionalValue(self.altMode, kAltSpread, kSpread)
end

function Revolver:GetBulletDamage(target, endPoint)
    return ConditionalValue(self.altMode, kRevolverAltDamage, kRevolverDamage)
end

function Revolver:GetIsLaserActive()
    return self.altMode and self:GetIsActive()
end

function Revolver:GetIdleAnimations(index)
    local animations = {"idle", "idle_spin", "idle_gangster"}
    return animations[index]
end


function Revolver:FirePrimary(player)

    ClipWeapon.FirePrimary(self, player)
    
    self:TriggerEffects("revolver_attack")
    
    TEST_EVENT("Revolver primary attack")
    
end

Shared.LinkClassToMap("Revolver", Revolver.kMapName, networkVars)