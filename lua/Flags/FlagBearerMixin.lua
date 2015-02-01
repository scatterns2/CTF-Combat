// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\FlagBearerMixin.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
//    Handles flags attaching to units.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

FlagBearerMixin = CreateMixin(FlagBearerMixin)
FlagBearerMixin.type = "FlagBearer"

FlagBearerMixin.expectedMixins =
{
    EntityChange = "Required to update list of flag Ids"
}

FlagBearerMixin.networkVars =
{
    hasFlag = "boolean"
}

function FlagBearerMixin:__initmixin()

    self.attachedFlag = nil
    self.hasFlag = false

end

function FlagBearerMixin:IsBearingFlag()
   return self.hasFlag
end

if Server then
    
    function FlagBearerMixin:AttachFlag(flag)
    
        local success = false
        if self.attachedFlag == nil then
            self.attachedFlag = flag
            self.attachedFlagId = flag:GetId()
            self.hasFlag = true
            success = true
        end
        
        return success
    
    end
    
    function FlagBearerMixin:DetachFlag(flag)
        self:DetachAll()
    end
    
    function FlagBearerMixin:OnF4WithFlag()
        if self.attachedFlag ~= nil then
            local flag = self:GetFlag()
            flag:ReturnFlag()
        end
    end
    
    function FlagBearerMixin:OnCaptureFlag()
        local flag = self:GetFlag()
        flag:ReturnFlag()
        self:AddXp(kCaptureFlagScore)
        self:DetachOnCapture()
        self:GetTeam():AddFlagCapture()
    end

    function FlagBearerMixin:OnEntityChange(oldId, newId)

        if (self.attachedFlagId ~= nil) and (self.attachedFlagId == oldId )  then
            self.attachedFlag = nil
            self.attachedFlagId = nil
            self.hasFlag = false
        end

    end
    
    function FlagBearerMixin:GetFlag()
        return self.attachedFlag
    end
    
    function FlagBearerMixin:DetachAll()
        local team = self:GetTeamNumber()
        if team >= 1 then
            if (self.attachedFlag ~= nil) then
                local flag = self:GetFlag()
                local origin, success = self:GetAttachPointOrigin(self:GetFlagAttachPointName())
                if origin then
                    flag:SetOrigin(origin)
                end   
                flag:OnDrop()
                self.attachedFlagId = nil
                self.attachedFlag = nil
                self.hasFlag = false
            end 
        else
            self:OnF4WithFlag()
        end   
    end

    function FlagBearerMixin:DetachOnCapture()
        self.attachedFlagId = nil
        self.attachedFlag = nil
        self.hasFlag = false
    end
       
    function FlagBearerMixin:OnKill()
        self:DetachAll()    
    end

    function FlagBearerMixin:OnDestroy()
        self:DetachAll()
    end
end
