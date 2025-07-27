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
        -- Use a lower alpha so the blur appears lighter
        surface.SetDrawColor(0, 0, 0, 80)
        surface.DrawRect(0, 0, w, h)
    end

    -- create the centered panel that holds the inventory
    local slotSize = 64
    local slotSpacing = 4
    local gridSize = slotSize * 5 + slotSpacing * 4
    local actionWidth = 80

    local main = vgui.Create("EditablePanel", InventoryUI)
    main:SetSize(gridSize * 2 + actionWidth + 20, gridSize)
    main:Center()

    -- left inventory grid
    local left = vgui.Create("DIconLayout", main)
    left:SetSize(gridSize, gridSize)
    left:SetPos(0, 0)
    left:SetSpaceX(slotSpacing)
    left:SetSpaceY(slotSpacing)

    for i = 1, 25 do
        local slot = left:Add("DPanel")
        slot:SetSize(slotSize, slotSize)
        slot.Paint = function(self, w, h)
            surface.SetDrawColor(40, 40, 40, 180)
            surface.DrawRect(0, 0, w, h)
        end
    end

    -- right inventory grid
    local right = vgui.Create("DIconLayout", main)
    right:SetSize(gridSize, gridSize)
    right:SetPos(gridSize + actionWidth + 20, 0)
    right:SetSpaceX(slotSpacing)
    right:SetSpaceY(slotSpacing)

    for i = 1, 25 do
        local slot = right:Add("DPanel")
        slot:SetSize(slotSize, slotSize)
        slot.Paint = function(self, w, h)
            surface.SetDrawColor(40, 40, 40, 180)
            surface.DrawRect(0, 0, w, h)
        end
    end

    -- action column in between
    local actions = vgui.Create("EditablePanel", main)
    actions:SetSize(actionWidth, gridSize)
    actions:SetPos(gridSize + 10, 0)

    local function StyledBox(ctrl)
        ctrl.Paint = function(self, w, h)
            surface.SetDrawColor(40, 40, 40, 180)
            surface.DrawRect(0, 0, w, h)
        end
    end

    local amount = vgui.Create("DTextEntry", actions)
    amount:SetNumeric(true)
    amount:SetText("0")
    amount:SetTextColor(color_white)
    amount:SetFont("DermaDefault")
    amount:SetContentAlignment(5)
    amount:SetSize(actionWidth, 30)
    amount:SetPos(0, 0)
    StyledBox(amount)

    local btnUse = vgui.Create("DButton", actions)
    btnUse:SetText("USE")
    btnUse:SetTextColor(color_white)
    btnUse:SetFont("DermaDefault")
    btnUse:SetSize(actionWidth, 30)
    btnUse:SetPos(0, 40)
    StyledBox(btnUse)

    local btnGive = vgui.Create("DButton", actions)
    btnGive:SetText("GIVE")
    btnGive:SetTextColor(color_white)
    btnGive:SetFont("DermaDefault")
    btnGive:SetSize(actionWidth, 30)
    btnGive:SetPos(0, 80)
    StyledBox(btnGive)

    local btnClose = vgui.Create("DButton", actions)
    btnClose:SetText("CLOSE")
    btnClose:SetTextColor(color_white)
    btnClose:SetFont("DermaDefault")
    btnClose:SetSize(actionWidth, 30)
    btnClose:SetPos(0, 120)
    StyledBox(btnClose)
    btnClose.DoClick = function()
        CloseInventory()
    end
end

local function OpenInventory()
    if InventoryOpen then return end
    CreateInventory()
    InventoryUI:SetVisible(true)
    InventoryUI:SetMouseInputEnabled(true)
    InventoryUI:SetKeyboardInputEnabled(true)
    gui.EnableScreenClicker(true)
    InventoryOpen = true
end

local function CloseInventory()
    if not InventoryOpen then return end
    if IsValid(InventoryUI) then
        InventoryUI:SetVisible(false)
        InventoryUI:SetMouseInputEnabled(false)
        InventoryUI:SetKeyboardInputEnabled(false)
    end
    gui.EnableScreenClicker(false)
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

hook.Add("CreateMove", "InventoryBlockMovement", function(cmd)
    if InventoryOpen then
        cmd:ClearMovement()
        cmd:ClearButtons()
    end
end)
