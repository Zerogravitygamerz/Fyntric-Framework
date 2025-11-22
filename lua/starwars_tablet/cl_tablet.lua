local SWT = include("starwars_tablet/shared.lua")

local PANEL = nil
local currentData = nil

local function injectData()
    if not IsValid(PANEL) or not PANEL.Ready then return end
    PANEL:QueueJavascript(string.format("window.applyData(%s);", util.TableToJSON(currentData or {}, true)))
end

local function buildPanel()
    if IsValid(PANEL) then PANEL:Remove() end

    local w, h = ScrW() * 0.7, ScrH() * 0.8
    local frame = vgui.Create("DFrame")
    frame:SetSize(w, h)
    frame:Center()
    frame:SetTitle("GAR Holotablet // Tactical Ops")
    frame:MakePopup()

    local dhtml = vgui.Create("DHTML", frame)
    dhtml:Dock(FILL)
    dhtml:SetAllowLua(true)

    dhtml:AddFunction("tablet", "ready", function()
        dhtml.Ready = true
        injectData()
    end)

    dhtml:AddFunction("tablet", "send", function(action, payload)
        net.Start(SWT.Net.Action)
        net.WriteString(action)
        net.WriteString(payload or "{}")
        net.SendToServer()
    end)

    local html = file.Read("starwars_tablet/ui/index.html", "LUA")
    dhtml:SetHTML(html or [[<html><body>Missing tablet UI</body></html>]])

    PANEL = dhtml
end

net.Receive(SWT.Net.Payload, function()
    local payload = util.JSONToTable(net.ReadString() or "{}") or {}
    currentData = payload
    if not IsValid(PANEL) then
        buildPanel()
    end
    injectData()
end)

concommand.Add("swt_tablet", function()
    net.Start(SWT.Net.OpenRequest)
    net.SendToServer()
end, nil, "Open the Star Wars tactical tablet")
