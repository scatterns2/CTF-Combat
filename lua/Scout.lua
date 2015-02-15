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

Scout.kHealth = 160
Scout.kBaseArmor = 0
Scout.kRunMaxSpeed = 8.5            
Scout.kWalkMaxSpeed = 7

Scout.kWalkBackwardSpeedScalar = 0.6

local networkVars =
{      
    canDoubleJump = "boolean"   
}

function Scout:OnCreate()

    Marine.OnCreate(self)
 
end

function Scout:OnInitialized()

    Marine.OnInitialized(self)
	self.canDoubleJump = true
   
end

function Scout:GetMaxSpeed(possible)

    if possible then
        return Scout.kRunMaxSpeed
    end

    local sprintingScalar = self:GetSprintingScalar()
    local maxSprintSpeed = Scout.kWalkMaxSpeed + (Scout.kRunMaxSpeed - Scout.kWalkMaxSpeed) * sprintingScalar
    local maxSpeed = ConditionalValue(self:GetIsSprinting(), maxSprintSpeed, Scout.kWalkMaxSpeed)
    
    // Take into account our weapon inventory and current weapon. Assumes a vanilla marine has a scalar of around .8.
    local inventorySpeedScalar = self:GetInventorySpeedScalar() + .17 //Clamp(self:GetInventorySpeedScalar() + .17, 0, 1)
    local useModifier = self.isUsing and 0.5 or 1
    
    if self.catpackboost then
        maxSpeed = maxSpeed + kCatPackMoveAddSpeed
    end
    
    return maxSpeed * self:GetSlowSpeedModifier() * inventorySpeedScalar  * useModifier
    
end

function Scout:GetAcceleration()
    return 12 * self:GetSlowSpeedModifier()
end

function Scout:GetGroundFriction()
    return 10
end

function Scout:GetAirAcceleration()
    return 8 * self:GetSlowSpeedModifier()
end

// Scouts can move backwards faster than most marines
function Scout:GetMaxBackwardSpeedScalar()
    return Scout.kWalkBackwardSpeedScalar
end

function Scout:OnGroundChanged(onGround, impactForce, normal, velocity)
	Marine.OnGroundChanged(self, onGround, impactForce, normal, velocity)
	if onGround then
		self.canDoubleJump = true
	end
end

function Scout:GetCanJump()
	if self:GetIsOnGround() then
		return true
	elseif self.canDoubleJump and self:GetVelocity().y >=0 then
		self.canDoubleJump = false
		return true
	end
	
	return false
end

local kStrafeJumpForce = 7
local kStrafeJumpDelay = 0.7
local kStrafeJumpBonus = 1
function Scout:ModifyJump(input, velocity, jumpVelocity)
    
	Marine.ModifyJump(self, input, velocity, jumpVelocity)
    local isStrafeJump = input.move.z == 0 and input.move.x ~= 0
    if isStrafeJump and self:GetTimeGroundTouched() + kStrafeJumpDelay < Shared.GetTime() then
    
        local strafeJumpDirection = GetNormalizedVector(self:GetViewCoords():TransformVector(input.move))
		local strafeJumpScalar = Clamp((self:GetMaxSpeed() + kStrafeJumpBonus - velocity:GetLengthXZ()) / kStrafeJumpForce, 0, 1)
        jumpVelocity:Add(strafeJumpDirection * kStrafeJumpForce * strafeJumpScalar)
        jumpVelocity.y = jumpVelocity.y * 0.8
        self.strafeJumped = true
        
    else
        self.strafeJumped = false
    end
    
	jumpVelocity:Scale(self:GetSlowSpeedModifier())
    
end

Shared.LinkClassToMap("Scout", Scout.kMapName, networkVars, true)
