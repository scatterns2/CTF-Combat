// ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Marine.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

class 'Scout' (Marine)

Scout.kMapName = "scout"

if Server then
    Script.Load("lua/Scout_Server.lua")
end

Scout.kHealth = 80
Scout.kBaseArmor = 120
Scout.kRunMaxSpeed = 8             
Scout.kWalkMaxSpeed = 5

local networkVars =
{      
        
}

function Scout:OnCreate()

    Marine.OnCreate(self)
 
end

function Scout:OnInitialized()

    Marine.OnInitialized(self)
   
end

function Scout:GetMaxSpeed(possible)

    if possible then
        return Scout.kRunMaxSpeed
    end

    local sprintingScalar = self:GetSprintingScalar()
    local maxSprintSpeed = Scout.kWalkMaxSpeed + (Scout.kRunMaxSpeed - Scout.kWalkMaxSpeed)*sprintingScalar
    local maxSpeed = ConditionalValue(self:GetIsSprinting(), maxSprintSpeed, Scout.kWalkMaxSpeed)
    
    // Take into account our weapon inventory and current weapon. Assumes a vanilla marine has a scalar of around .8.
    local inventorySpeedScalar = self:GetInventorySpeedScalar() + .17    
    local useModifier = self.isUsing and 0.5 or 1
    
    if self.catpackboost then
        maxSpeed = maxSpeed + kCatPackMoveAddSpeed
    end
    
    return maxSpeed * self:GetSlowSpeedModifier() * inventorySpeedScalar  * useModifier
    
end

Shared.LinkClassToMap("Scout", Scout.kMapName, networkVars, true)
