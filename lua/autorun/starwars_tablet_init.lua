-- Entry point for the Star Wars roleplay tablet addon
if SERVER then
    AddCSLuaFile("starwars_tablet/shared.lua")
    AddCSLuaFile("starwars_tablet/cl_tablet.lua")

    include("starwars_tablet/shared.lua")
    include("starwars_tablet/sv_tablet.lua")
else
    include("starwars_tablet/shared.lua")
    include("starwars_tablet/cl_tablet.lua")
end
