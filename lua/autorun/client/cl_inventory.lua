
local INVENTORY = {}
INVENTORY.IsOpen = false
INVENTORY.Panel = nil

local INVENTORY_KEY = KEY_TAB

function INVENTORY:CreatePanel()
    if IsValid(self.Panel) then
        self.Panel:Remove()
    end
    
    self.Panel = vgui.Create("DPanel")
    self.Panel:SetSize(ScrW(), ScrH())
    self.Panel:SetPos(0, 0)
    self.Panel:MakePopup()
    self.Panel:SetKeyboardInputEnabled(false)
    self.Panel:SetMouseInputEnabled(true)
    
    local htmlPanel = vgui.Create("DHTML", self.Panel)
    htmlPanel:Dock(FILL)
    
    local htmlContent = self:GetInventoryHTML()
    htmlPanel:SetHTML(htmlContent)
    
    htmlPanel:AddFunction("gmod", "closeInventory", function()
        self:Close()
    end)
    
    htmlPanel:AddFunction("gmod", "moveItem", function(fromType, fromIndex, toType, toIndex)
        self:MoveItem(fromType, fromIndex, toType, toIndex)
    end)
    
    htmlPanel:AddFunction("gmod", "useItem", function(itemType, itemIndex)
        self:UseItem(itemType, itemIndex)
    end)
    
    gui.EnableScreenClicker(true)
    
    return self.Panel
end

function INVENTORY:GetInventoryHTML()
    local css = file.Read("html/inventory/styles.css", "GAME") or self:GetDefaultCSS()
    local js = file.Read("html/inventory/script.js", "GAME") or self:GetDefaultJS()
    
    return string.format([[
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NoPixel Inventory UI</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>%s</style>
</head>
<body>
    <div id="qbcore-inventory">
        <div class="inv-container">
            <!-- Left Sidebar -->
            <div class="left-sidebar">
                <div class="sidebar-icon"><i class="fas fa-home"></i></div>
                <div class="sidebar-icon"><i class="fas fa-mask"></i></div>
                <div class="sidebar-icon"><i class="fas fa-vr-cardboard"></i></div>
                <div class="sidebar-icon"><i class="fas fa-heart"></i></div>
                <div class="sidebar-icon"><i class="fas fa-home"></i></div>
            </div>
            
            <!-- Character Body Container -->
            <div class="player-body-container">
                <div class="player-body">
                    <img src="data:image/png;base64,%s" alt="Character Body" style="width: 198px; height: 428px;">
                </div>
                
                <!-- Equipment Slots -->
                <div class="equipment-slot" data-slot="head" style="position: absolute; top: 2%%; left: 48%%; width: 50px; height: 50px;">
                    <div class="item-slot-img"><i class="fas fa-hard-hat placeholder-icon"></i></div>
                </div>
                <div class="equipment-slot" data-slot="left-arm" style="position: absolute; top: 22%%; left: 5%%; width: 50px; height: 50px;">
                    <div class="item-slot-img"><i class="fas fa-tshirt placeholder-icon"></i></div>
                </div>
                <div class="equipment-slot" data-slot="right-arm" style="position: absolute; top: 22%%; right: 5%%; width: 50px; height: 50px;">
                    <div class="item-slot-img"><i class="fas fa-tshirt placeholder-icon"></i></div>
                </div>
                <div class="equipment-slot" data-slot="body" style="position: absolute; top: 38%%; left: 48%%; width: 50px; height: 50px;">
                    <div class="item-slot-img"><i class="fas fa-vest placeholder-icon"></i></div>
                </div>
                <div class="equipment-slot" data-slot="left-leg" style="position: absolute; top: 75%%; left: 38%%; width: 50px; height: 50px;">
                    <div class="item-slot-img"><i class="fas fa-shoe-prints placeholder-icon"></i></div>
                </div>
                <div class="equipment-slot" data-slot="right-leg" style="position: absolute; top: 75%%; right: 38%%; width: 50px; height: 50px;">
                    <div class="item-slot-img"><i class="fas fa-shoe-prints placeholder-icon"></i></div>
                </div>
            </div>

            <!-- Inventory Sections -->
            <div class="pocket-inventory-icon"><i class="fas fa-pocket"></i></div>
            <div class="pocket-inv-info"><div id="pocket-inv-label">Pockets</div></div>
            <div class="player-inventory-first">
                <div class="inventory-grid" id="pocket-inventory"></div>
            </div>

            <div class="player-inventory-icon"><i class="fas fa-user"></i></div>
            <div class="player-inv-info">
                <div id="player-inv-label">Player</div>
                <div id="player-inv-weight">0.70kg/160.00kg</div>
            </div>
            <div class="player-inventory">
                <div class="inventory-grid" id="player-inventory"></div>
            </div>

            <div class="backpack-inventory-icon"><i class="fas fa-backpack"></i></div>
            <div class="backpack-inv-info"><div id="backpack-inv-label">Backpack</div></div>
            <div class="player-inventory-backpack">
                <div class="inventory-grid" id="backpack-inventory"></div>
            </div>

            <div class="other-inventory-icon"><i class="fas fa-store"></i></div>
            <div class="other-inv-info">
                <div id="other-inv-label">24/7 Supermarket</div>
                <div id="other-inv-weight">0.00kg/100.00kg</div>
            </div>
            <div class="other-inventory">
                <div class="inventory-grid" id="other-inventory"></div>
            </div>

            <!-- Personal Information -->
            <div class="ply-number-line"></div>
            <div class="player-name-title">Name</div>
            <div class="player-name" id="player-name">%s</div>
            
            <div class="phone-number-line"></div>
            <div class="phone-number-title">Phone Number</div>
            <div class="phone-number" id="phone-number">%s</div>
            
            <div class="player-id-line"></div>
            <div class="player-id-title">State ID</div>
            <div class="player-id" id="state-id">%s</div>
            
            <div class="citizen-id-line"></div>
            <div class="citizen-id-title">Citizen ID</div>
            <div class="citizen-id" id="citizen-id">%s</div>

            <!-- Item Information Panel -->
            <div class="ply-iteminfo-container" style="display: none;">
                <div class="item-info-title">Item Name</div>
                <div class="item-info-line"></div>
                <div class="item-info-description">Item description goes here</div>
            </div>
        </div>
    </div>

    <script>%s</script>
    <script>
        // Garry's Mod integration functions
        function closeInventory() {
            if (typeof gmod !== 'undefined' && gmod.closeInventory) {
                gmod.closeInventory();
            }
        }
        
        function moveItemGMod(fromType, fromIndex, toType, toIndex) {
            if (typeof gmod !== 'undefined' && gmod.moveItem) {
                gmod.moveItem(fromType, fromIndex, toType, toIndex);
            }
        }
        
        function useItemGMod(itemType, itemIndex) {
            if (typeof gmod !== 'undefined' && gmod.useItem) {
                gmod.useItem(itemType, itemIndex);
            }
        }
        
        // Override the original inventory system to use GMod functions
        if (typeof InventorySystem !== 'undefined') {
            const originalHandleDrop = InventorySystem.prototype.handleDrop;
            InventorySystem.prototype.handleDrop = function(e) {
                originalHandleDrop.call(this, e);
                
                if (this.draggedItem) {
                    const sourceSlot = this.draggedItem.sourceSlot;
                    const targetSlot = e.currentTarget;
                    
                    const sourceType = sourceSlot.dataset.type;
                    const sourceIndex = parseInt(sourceSlot.dataset.index);
                    const targetType = targetSlot.dataset.type;
                    const targetIndex = parseInt(targetSlot.dataset.index);
                    
                    moveItemGMod(sourceType, sourceIndex, targetType, targetIndex);
                }
            };
        }
        
        // Handle ESC key to close inventory
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeInventory();
            }
        });
        
        // Update player information from GMod
        function updatePlayerInfo(name, phone, stateId, citizenId) {
            document.getElementById('player-name').textContent = name || 'Unknown';
            document.getElementById('phone-number').textContent = phone || 'N/A';
            document.getElementById('state-id').textContent = stateId || '1';
            document.getElementById('citizen-id').textContent = citizenId || 'Unknown';
        }
    </script>
</body>
</html>
    ]], css, self:GetBodyImageBase64(), 
        LocalPlayer():Nick() or "Unknown Player",
        "555-0123", -- Default phone number
        "1", -- Default state ID  
        "ABC123", -- Default citizen ID
        js)
end

function INVENTORY:Open()
    if self.IsOpen then return end
    
    self.IsOpen = true
    self:CreatePanel()
    
    net.Start("inventory_opened")
    net.SendToServer()
end

function INVENTORY:Close()
    if not self.IsOpen then return end
    
    self.IsOpen = false
    
    if IsValid(self.Panel) then
        self.Panel:Close()
    end
    
    gui.EnableScreenClicker(false)
    
    net.Start("inventory_closed")
    net.SendToServer()
end

function INVENTORY:Toggle()
    if self.IsOpen then
        self:Close()
    else
        self:Open()
    end
end

function INVENTORY:MoveItem(fromType, fromIndex, toType, toIndex)
    net.Start("inventory_move_item")
    net.WriteString(fromType)
    net.WriteInt(fromIndex, 16)
    net.WriteString(toType)
    net.WriteInt(toIndex, 16)
    net.SendToServer()
end

function INVENTORY:UseItem(itemType, itemIndex)
    net.Start("inventory_use_item")
    net.WriteString(itemType)
    net.WriteInt(itemIndex, 16)
    net.SendToServer()
end

function INVENTORY:GetDefaultCSS()
    return file.Read("styles.css", "GAME") or ""
end

function INVENTORY:GetDefaultJS()
    return file.Read("script.js", "GAME") or ""
end

function INVENTORY:GetBodyImageBase64()
    local base64Data = file.Read("body_base64.txt", "GAME")
    if base64Data then
        return string.Trim(base64Data)
    end
    return ""
end

hook.Add("PlayerButtonDown", "InventoryToggle", function(ply, button)
    if ply ~= LocalPlayer() then return end
    
    if button == INVENTORY_KEY then
        INVENTORY:Toggle()
    end
end)

net.Receive("inventory_update", function()
    local inventoryData = net.ReadTable()
    if INVENTORY.IsOpen and IsValid(INVENTORY.Panel) then
        local htmlPanel = INVENTORY.Panel:GetChildren()[1]
        if IsValid(htmlPanel) then
            htmlPanel:RunJavascript(string.format("updateInventoryData(%s)", util.TableToJSON(inventoryData)))
        end
    end
end)

net.Receive("inventory_player_info", function()
    local name = net.ReadString()
    local phone = net.ReadString()
    local stateId = net.ReadString()
    local citizenId = net.ReadString()
    
    if INVENTORY.IsOpen and IsValid(INVENTORY.Panel) then
        local htmlPanel = INVENTORY.Panel:GetChildren()[1]
        if IsValid(htmlPanel) then
            htmlPanel:RunJavascript(string.format("updatePlayerInfo('%s', '%s', '%s', '%s')", name, phone, stateId, citizenId))
        end
    end
end)

print("[NoPixel Inventory] Client-side loaded. Press TAB to open inventory.")
