if SERVER then return end

local InventoryUI
local InventoryOpen = false

local function CreateInventory()
    if IsValid(InventoryUI) then return end

    InventoryUI = vgui.Create("EditablePanel")
    InventoryUI:SetSize(ScrW(), ScrH())
    InventoryUI:Dock(FILL)
    InventoryUI:SetVisible(false)
    InventoryUI:SetMouseInputEnabled(false)
    InventoryUI:SetKeyboardInputEnabled(false)

    InventoryUI.Paint = function(self, w, h)
        if not self.StartTime then self.StartTime = SysTime() end
        Derma_DrawBackgroundBlur(self, self.StartTime)
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(0, 0, w, h)
    end
end

local function OpenInventory()
    if InventoryOpen then return end
    CreateInventory()
    InventoryUI:SetVisible(true)
    InventoryUI:SetMouseInputEnabled(true)
    InventoryUI:SetKeyboardInputEnabled(true)
    InventoryOpen = true
end

local function CloseInventory()
    if not InventoryOpen then return end
    if IsValid(InventoryUI) then
        InventoryUI:SetVisible(false)
        InventoryUI:SetMouseInputEnabled(false)
        InventoryUI:SetKeyboardInputEnabled(false)
    end
    InventoryOpen = false
end

hook.Add("PlayerBindPress", "InventoryTabToggle", function(ply, bind, pressed)
    if bind == "+showscores" and pressed then
        if InventoryOpen then
            CloseInventory()
        else
            OpenInventory()
        end
        return true
    end
end)
