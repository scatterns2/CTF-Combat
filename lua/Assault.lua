// ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Marine.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

class 'Assault' (Marine)

Assault.kMapName = "assault"

if Server then
    Script.Load("lua/Assault_Server.lua")
end

Assault.kHealth = 300
Assault.kBaseArmor = 0
Assault.kRunMaxSpeed = 6.5             
Assault.kWalkMaxSpeed = 4.5            

local networkVars =
{      
        
}

function Assault:OnCreate()

    Marine.OnCreate(self)
 
end

function Assault:OnInitialized()

    Marine.OnInitialized(self)
   
end



Shared.LinkClassToMap("Assault", Assault.kMapName, networkVars, true)
