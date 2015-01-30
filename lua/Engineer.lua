// ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Marine.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

class 'Engineer' (Marine)

Engineer.kMapName = "engineer"

if Server then
    Script.Load("lua/Engineer_Server.lua")
end

Engineer.kHealth = 225
Engineer.kBaseArmor = 0
Engineer.kRunMaxSpeed = 6.5             
Engineer.kWalkMaxSpeed = 5.5

local networkVars =
{      
        
}

function Engineer:OnCreate()

    Marine.OnCreate(self)
 
end

function Engineer:OnInitialized()

    Marine.OnInitialized(self)
   
end

function Engineer:GetMaxSpeed(possible)

    if possible then
        return Engineer.kRunMaxSpeed
    end

    local sprintingScalar = self:GetSprintingScalar()
    local maxSprintSpeed = Engineer.kWalkMaxSpeed + (Engineer.kRunMaxSpeed - Engineer.kWalkMaxSpeed)*sprintingScalar
    local maxSpeed = ConditionalValue(self:GetIsSprinting(), maxSprintSpeed, Engineer.kWalkMaxSpeed)
    
    // Take into account our weapon inventory and current weapon. Assumes a vanilla marine has a scalar of around .8.
    local inventorySpeedScalar = self:GetInventorySpeedScalar() + .17    
    local useModifier = self.isUsing and 0.5 or 1
    
    if self.catpackboost then
        maxSpeed = maxSpeed + kCatPackMoveAddSpeed
    end
    
    return maxSpeed * self:GetSlowSpeedModifier() * inventorySpeedScalar  * useModifier
    
end

Shared.LinkClassToMap("Engineer", Engineer.kMapName, networkVars, true)
