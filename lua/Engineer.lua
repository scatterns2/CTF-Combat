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

Engineer.kHealth = 144
Engineer.kBaseArmor = 120
Engineer.kRunMaxSpeed = 8             

local networkVars =
{      
        
}

function Engineer:OnCreate()

    Marine.OnCreate(self)
 
end

function Engineer:OnInitialized()

    Marine.OnInitialized(self)
   
end

Shared.LinkClassToMap("Engineer", Engineer.kMapName, networkVars, true)
