--[[
    Vector Clipboard Addon
    When the local player types "/vector <precision>" in chat, this addon copies
    the player's current position vector to the clipboard with the requested
    number of decimal places (default 2 if not specified).
]]

local function copyVectorToClipboard(msg)
    -- Only react to the local player's messages
    if msg ~= LocalPlayer() then return end

    local text = msg
    local prefix = string.match(text, "^/vector")
    if not prefix then return end

    -- Extract precision number after the command
    local precision = tonumber(text:match("^/vector%s+(%d+)$")) or 2

    local pos = LocalPlayer():GetPos()
    local fmt = string.format("%%.%df", precision)
    local vectorStr = string.format("Vector(%s, %s, %s)",
        string.format(fmt, pos.x),
        string.format(fmt, pos.y),
        string.format(fmt, pos.z))

    -- Copy to clipboard on the client
    SetClipboardText(vectorStr)
    chat.AddText(Color(0,255,0), "Copied position: ", vectorStr)

    return true -- block message from chat
end

hook.Add("OnPlayerChat", "VectorClipboardCopy", function(ply, text)
    if ply ~= LocalPlayer() then return end
    local cmd = string.lower(text)
    if cmd:StartWith("/vector") then
        -- Build message with the same text to handle precision
        copyVectorToClipboard(text)
        return true
    end
end)

