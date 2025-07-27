-- Spawns a frozen Star Wars NPC at the specified location

if SERVER then
    hook.Add("InitPostEntity", "SpawnFrozenStarWarsNPC", function()
        local pos = Vector(-10322.2559, -848.5197, -6086.9688)

        local npc = ents.Create("npc_citizen")
        if not IsValid(npc) then return end

        npc:SetModel("models/aussiwozzi/cgi/base/212th_arc.mdl")
        npc:SetPos(pos)
        npc:Spawn()

        -- Prevent the NPC from moving
        npc:CapabilitiesClear()
        npc:SetMoveType(MOVETYPE_NONE)
    end)
end
