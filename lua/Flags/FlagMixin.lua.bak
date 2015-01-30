-- lua\FlagMixin.lua    

Script.Load("lua/EquipmentOutline.lua")

FlagMixin = CreateMixin(FlagMixin)
FlagMixin.type = "SentryBattery"

FlagMixin.expectedMixins =
{
    Team = "For returning flag to correct team",
}

FlagMixin.expectedCallbacks =
{
    OnTouchEnemy = "Called when an enemy player is close enough to pick up with the player as the parameter",
    OnTouchFriendly = "Called when a friendly player is close enough to pick up with the player as the parameter",
    GetOrigin = "Returns the position of this pickupable item",
    GetIsValidRecipient = "Should return true if the passed in Entity can receive this pickup"
}

FlagMixin.optionalCallbacks =
{
    GetIsPermanent = "Return true when this item has unlimited life time.",
    SetExpireTime = "Sets expiration time for the entity.",
    GetExpireTimeFraction = "Returns the expire time fraction, if it has limited time, otherwise it returns 0."
}

FlagMixin.expectedConstants =
{
    kRecipientType = "The class type that is allowed to pick this up",
}

FlagMixin.networkVars =
{
    kAtBase = "boolean",
    kCarried = "boolean",
    kReturning = "boolean",
    kDropTime = "time"
}

local kCheckForPickupRate = 0.1
local kPickupRange = 2

function FlagMixin:__initmixin()
    
    
    if Server then
    
        if not self.GetCheckForRecipient or self:GetCheckForRecipient() then
            self:AddTimedCallback(FlagMixin._CheckForPickup, kCheckForPickupRate)
        end
        
        if not self.GetIsPermanent or not self:GetIsPermanent() then
            self:AddTimedCallback(FlagMixin._DestroySelf, kItemStayTime)
        end
        
    end
    
end

function FlagMixin:_GetNearbyRecipient()

    local recipientTypes = self:GetMixinConstants().kRecipientType
    local potentialRecipients = {}

    if type(recipientTypes) == "string" then    
        potentialRecipients = GetEntitiesWithinRange(self:GetMixinConstants().kRecipientType, self:GetOrigin(), kPickupRange)
        
    elseif type(recipientTypes) == "table" then
        
        for _, recipientType in ipairs(recipientTypes) do        
            table.copy(GetEntitiesWithinRange(recipientType, self:GetOrigin(), kPickupRange), potentialRecipients, true)
        end
        
    end    
    
    for index, recipient in pairs(potentialRecipients) do
    
        if self:GetIsValidRecipient(recipient) then
            return recipient
        end
        
    end
    
    return nil
    
end

function FlagMixin:_CheckForPickup()

    assert(Server)
    local now = Shared.GetTime()
    // Scan for nearby friendly players that need medpacks because we don't have collision detection yet
    local player = self:_GetNearbyRecipient()
    if player ~= nil then
        local team = player:GetTeamNumber()
        local flagTeam = self:GetTeamNumber()

        local enemies = (team ~= flagTeam)
        local friends = (team == flagTeam)
        if enemies then
            self:OnTouchEnemy(player)
        elseif friends then
            self:OnTouchFriendly(player)
        end        
    end    
    // Continue the callback.
    return true   
end

function FlagMixin:_DestroySelf()

    assert(Client == nil)
    
    DestroyEntity(self)

end

function FlagMixin:OnDrop()

        if not self:GetIsDestroyed() then
            self.kDropTime = Shared.GetTime()
            self.kReturning = true
            self.kCarried = false
            self:SetParent(nil)
        end  
        
end

function FlagMixin:OnTaken(player)
    if self.kAtBase then
        self.kAtBase = false
    end
	
    player:AddScore(kPickUpFlagScore)
end

function FlagMixin:OnPlayerReturn(player)
    player:AddScore(kReturnFlagScore)
    self:ReturnFlag()
end

function FlagMixin:OnUpdate(deltaTime)
    if Client then    
        EquipmentOutline_UpdateModel(self)    
    end

end

function FlagMixin:ReturnFlag()
    if Server then
        local team = self:GetTeam()
        local techPoint = team:GetInitialTechPoint()
        for index, current in ientitylist(Shared.GetEntitiesWithClassname("ResourcePoint")) do
            local sameLocation = (techPoint:GetLocationName() == current:GetLocationName())
            if sameLocation then
                current:SetAttached(nil)
                current:SpawnFlagForTeam(team)
            end
        end
    end
    self:_DestroySelf() 
end
