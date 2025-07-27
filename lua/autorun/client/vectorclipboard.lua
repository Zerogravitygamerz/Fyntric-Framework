--[[
    Vector Clipboard Addon
    When the local player types "/vector <precision>" or "/vector<precision>"
    in chat, this addon copies the player's current position vector to the
    clipboard. Precision controls the number of decimal places (default is 2).
]]

hook.Add("OnPlayerChat", "VectorClipboardCopy", function(ply, text)
    if ply ~= LocalPlayer() then return end

    local cmd = string.lower(text)
    local precisionStr = cmd:match("^/vector%s*(%d*)$")
    if not precisionStr then return end

    local precision = tonumber(precisionStr) or 2
    local pos = ply:GetPos()
    local fmt = string.format("%%.%df", precision)
    local vectorStr = string.format("Vector(%s, %s, %s)",
        string.format(fmt, pos.x),
        string.format(fmt, pos.y),
        string.format(fmt, pos.z))

    SetClipboardText(vectorStr)
    chat.AddText(Color(0,255,0), "Copied position: ", vectorStr)

    return true -- block message from chat
end)

