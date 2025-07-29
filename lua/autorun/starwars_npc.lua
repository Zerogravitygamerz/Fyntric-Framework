-- Spawns a frozen Star Wars NPC at the specified location

if SERVER then
    hook.Add("InitPostEntity", "SpawnFrozenStarWarsNPC", function()
        -- Position and orientation for the NPC
        local pos = Vector(-10322.2559, -848.5197, -6086.9688)
        local ang = Angle(0, 0, 0)

        local npc = ents.Create("npc_citizen")
        if not IsValid(npc) then return end

        npc:SetModel("models/aussiwozzi/cgi/base/212th_arc.mdl")
        npc:SetPos(pos)
        npc:SetAngles(ang)
        npc:Spawn()

        -- Keep the NPC completely frozen
        npc:CapabilitiesClear()
        npc:SetNPCState(NPC_STATE_SCRIPT)
        npc:SetSchedule(SCHED_IDLE_STAND)
        npc:SetMoveType(MOVETYPE_NONE)
    end)
end
