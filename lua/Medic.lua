// ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Marine.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

class 'Medic' (Marine)

Medic.kMapName = "medic"

if Server then
    Script.Load("lua/Medic_Server.lua")
end

Medic.kHealth = 125
Medic.kBaseArmor = 120
Medic.kRunMaxSpeed = 8             

local networkVars =
{      
        
}

function Medic:OnCreate()

    Marine.OnCreate(self)
 
end

function Medic:OnInitialized()

    Marine.OnInitialized(self)
   
end

Shared.LinkClassToMap("Medic", Medic.kMapName, networkVars, true)
