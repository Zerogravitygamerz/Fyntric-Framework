# Fyntric-Framework

Star Wars-themed Galactic Operations tablet UI built as a single-page HTML for Garry's Mod DHTML panels. All assets are inline (no external calls) so it can be packed with a GLua script or served from `file://`.

## Embedding in Garry's Mod
1. Create a DHTML panel and load `index.html` (from disk or `panel:SetHTML` with the file contents).
2. Wire JS -> Lua by exposing a receiver:
   ```lua
   local pnl = vgui.Create("DHTML")
   pnl:SetSize(1280, 720)
   pnl:Center()
   pnl:AddFunction("gmod", "receive", function(channel, raw)
       -- channel examples: "comms:send", "contacts:add", "games:dice"
       local payload = util.JSONToTable(raw or "{}") or {}
       print("[Tablet]", channel, util.TableToJSON(payload))
   end)
   ```
3. Send Lua -> JS events using `__fromGmod`:
   ```lua
   local function pushAnnouncement()
       pnl:QueueJavascript(string.format(
           "window.__fromGmod('announcements:push', %s)",
           util.TableToJSON({title='Server Drill', channel='Fleet', body='Report to hangar A'})
       ))
   end
   ```

## Event channels
- **Outbound (JS → GLua):** `comms:new_channel`, `comms:send`, `contacts:add`, `contacts:remove`, `contacts:ping`, `reports:file`, `regiments:drill`, `regiments:recall`, `regiments:buff`, `announcements:broadcast`, `holofeed:post`, `games:memory`, `games:calibration`, `games:dice`.
- **Inbound (GLua → JS):** `contacts:sync`, `announcements:push`, `comms:message`, `holofeed:inject`, `regiments:update`.

These payloads are JSON-friendly tables and can be extended without modifying the UI. Unknown channels will simply log to the browser console for debugging.
