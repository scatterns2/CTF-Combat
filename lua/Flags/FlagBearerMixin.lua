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
    team = self:GetTeamNumber()

end

function FlagBearerMixin:IsBearingFlag()
   return self.hasFlag
end

if Server then
    
    local function GetTeamAttachPoint()
        if team == kTeam1Index then
            return "JetPack"
        elseif team == kTeam2Index then
            return "babbler_attach1"
        else
            Print("GetTeamAttachPoint(team = %d) is an invalid team.", team)
            return nil
        end
    end

    function FlagBearerMixin:AttachFlag(flag)
    
        local success = false
        if self.attachedFlag == nil then
            self.attachedFlag = flag
            self.attachedFlagId = flag:GetId()
            flag:SetParent(self)
            flag:SetAttachPoint(GetTeamAttachPoint())
            success = true
            self.hasFlag = true
        end
        
        return success
    
    end
    
    function FlagBearerMixin:DetachFlag(flag)
        self:DetachAll()
    end
    
    function FlagBearerMixin:OnF4WithFlag()
        if self.attachedFlag ~= nil then
            local flag = self.attachedFlag
            flag:ReturnFlag()
        end
    end
    
    function FlagBearerMixin:OnCaptureFlag()
        local flag = self.attachedFlag
        flag:ReturnFlag()
        self:AddScore(kCaptureFlagScore)
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
        if team ~= 0 then
            if (self.attachedFlag ~= nil) then
                local flag = self.attachedFlag
                local origin, success = self:GetAttachPointOrigin(GetTeamAttachPoint())
                if origin then
                    flag:SetOrigin(origin)
                end   
                self.attachedFlag:OnDrop()
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
    
    function FlagBearerMixin:GetFreeFlagAttachPointOrigin()
    
        local freeAttachPoint = #self.freeAttachPoints > 0 and self.freeAttachPoints[1] or false
        if freeAttachPoint then
            return self:GetAttachPointOrigin(freeAttachPoint)
        end
    
    end

end
