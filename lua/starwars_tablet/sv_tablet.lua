local SWT = include("starwars_tablet/shared.lua")

local tabletData = {
    contacts = {},
    messages = {},
    reports = {},
    regiments = {},
    announcements = {},
    holofeed = {},
    minigameScores = {}
}

local function persist()
    local json = util.TableToJSON(tabletData, true)
    file.CreateDir("data")
    file.Write(SWT.DataFile, json)
end

local function loadPersisted()
    if file.Exists(SWT.DataFile, "DATA") then
        local raw = file.Read(SWT.DataFile, "DATA")
        local parsed = util.JSONToTable(raw or "")
        if istable(parsed) then
            tabletData = table.Merge(tabletData, parsed)
        end
    end
end

local function emitPayload(ply)
    net.Start(SWT.Net.Payload)
    net.WriteString(util.TableToJSON(tabletData, true))
    if IsValid(ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

local function guardString(str, max)
    if not isstring(str) then return "" end
    str = string.sub(str, 1, max or 256)
    return str
end

local function guardTable(tbl)
    if not istable(tbl) then return {} end
    return tbl
end

local function playerId(ply)
    return IsValid(ply) and ply:SteamID64() or "console"
end

local function addMessage(ply, payload)
    local msg = {
        from = playerId(ply),
        to = guardString(payload.to, 64),
        body = guardString(payload.body, 600),
        channel = guardString(payload.channel or "encrypted", 32),
        timestamp = os.time()
    }
    table.insert(tabletData.messages, 1, msg)
end

local function addContact(ply, payload)
    local id = playerId(ply)
    tabletData.contacts[id] = tabletData.contacts[id] or {}
    table.insert(tabletData.contacts[id], {
        name = guardString(payload.name, 64),
        regiment = guardString(payload.regiment, 64),
        frequency = guardString(payload.frequency, 32),
        notes = guardString(payload.notes, 240),
        addedAt = os.time()
    })
end

local function addReport(ply, payload)
    table.insert(tabletData.reports, 1, {
        author = playerId(ply),
        title = guardString(payload.title, 120),
        body = guardString(payload.body, 1200),
        tags = guardTable(payload.tags),
        location = guardString(payload.location or "Unknown Sector", 120),
        timestamp = os.time()
    })
end

local function updateRegiment(ply, payload)
    local key = guardString(payload.name, 64)
    tabletData.regiments[key] = {
        name = key,
        lead = guardString(payload.lead, 64),
        color = guardString(payload.color or "#3d8be3", 16),
        alert = guardString(payload.alert or "green", 32),
        duties = guardTable(payload.duties),
        roster = guardTable(payload.roster),
        channels = guardTable(payload.channels),
        updatedAt = os.time(),
        updatedBy = playerId(ply)
    }
end

local function addAnnouncement(ply, payload)
    local entry = {
        author = playerId(ply),
        body = guardString(payload.body, 420),
        priority = guardString(payload.priority or "standard", 24),
        expires = os.time() + (tonumber(payload.duration or 0) or 0),
        timestamp = os.time()
    }
    table.insert(tabletData.announcements, 1, entry)
    emitPayload()
end

local function addHolofeed(ply, payload)
    local entry = {
        author = playerId(ply),
        handle = guardString(payload.handle or "@unknown", 32),
        body = guardString(payload.body, 240),
        likes = math.max(0, math.floor(tonumber(payload.likes or 0) or 0)),
        hashtags = guardTable(payload.hashtags),
        timestamp = os.time()
    }
    table.insert(tabletData.holofeed, 1, entry)
    emitPayload()
end

local function addMinigameScore(ply, payload)
    local id = playerId(ply)
    tabletData.minigameScores[id] = tabletData.minigameScores[id] or {}
    tabletData.minigameScores[id][payload.name or "unknown"] = {
        score = tonumber(payload.score or 0) or 0,
        recordedAt = os.time()
    }
end

local handlers = {
    contact = addContact,
    message = addMessage,
    report = addReport,
    regiment = updateRegiment,
    announcement = addAnnouncement,
    holofeed = addHolofeed,
    minigame = addMinigameScore
}

local function handleAction(len, ply)
    local action = net.ReadString()
    local payload = util.JSONToTable(net.ReadString() or "{}") or {}
    if handlers[action] then
        handlers[action](ply, payload)
        persist()
        emitPayload(ply)
    end
end

local function handleOpen(len, ply)
    emitPayload(ply)
end

hook.Add("Initialize", "SWT_LoadData", loadPersisted)

util.AddNetworkString(SWT.Net.OpenRequest)
util.AddNetworkString(SWT.Net.Payload)
util.AddNetworkString(SWT.Net.Action)
util.AddNetworkString(SWT.Net.Push)

net.Receive(SWT.Net.Action, handleAction)
net.Receive(SWT.Net.OpenRequest, handleOpen)

concommand.Add("swt_tablet_clear", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    tabletData = {
        contacts = {},
        messages = {},
        reports = {},
        regiments = {},
        announcements = {},
        holofeed = {},
        minigameScores = {}
    }
    persist()
    emitPayload()
end, nil, "Admin: wipe the Star Wars tablet state")
