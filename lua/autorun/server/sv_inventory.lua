
util.AddNetworkString("inventory_opened")
util.AddNetworkString("inventory_closed")
util.AddNetworkString("inventory_move_item")
util.AddNetworkString("inventory_use_item")
util.AddNetworkString("inventory_update")
util.AddNetworkString("inventory_player_info")

local PlayerInventories = {}

local function CreateDefaultInventory()
    return {
        pocket = {},
        player = {},
        backpack = {},
        other = {},
        equipment = {
            head = nil,
            ["left-arm"] = nil,
            ["right-arm"] = nil,
            body = nil,
            ["left-leg"] = nil,
            ["right-leg"] = nil
        }
    }
end

local function GetPlayerInventory(ply)
    local steamid = ply:SteamID()
    if not PlayerInventories[steamid] then
        PlayerInventories[steamid] = CreateDefaultInventory()
        
        PlayerInventories[steamid].pocket[1] = {
            name = "Keys",
            icon = "fas fa-key",
            quantity = 1,
            description = "Vehicle and house keys"
        }
        
        PlayerInventories[steamid].player[1] = {
            name = "Burger",
            icon = "fas fa-hamburger", 
            quantity = 3,
            description = "A delicious burger that restores health"
        }
        
        PlayerInventories[steamid].other[1] = {
            name = "Energy Drink",
            icon = "fas fa-battery-full",
            quantity = 10,
            description = "Restores energy and stamina"
        }
    end
    return PlayerInventories[steamid]
end

local function SendInventoryUpdate(ply)
    local inventory = GetPlayerInventory(ply)
    net.Start("inventory_update")
    net.WriteTable(inventory)
    net.Send(ply)
end

local function SendPlayerInfo(ply)
    net.Start("inventory_player_info")
    net.WriteString(ply:Nick())
    net.WriteString("555-" .. string.format("%04d", ply:UserID())) -- Generate phone from UserID
    net.WriteString(tostring(ply:UserID())) -- Use UserID as State ID
    net.WriteString("CID" .. string.format("%05d", ply:UserID())) -- Generate Citizen ID
    net.Send(ply)
end

net.Receive("inventory_opened", function(len, ply)
    print("[NoPixel Inventory] " .. ply:Nick() .. " opened inventory")
    SendInventoryUpdate(ply)
    SendPlayerInfo(ply)
end)

net.Receive("inventory_closed", function(len, ply)
    print("[NoPixel Inventory] " .. ply:Nick() .. " closed inventory")
end)

net.Receive("inventory_move_item", function(len, ply)
    local fromType = net.ReadString()
    local fromIndex = net.ReadInt(16)
    local toType = net.ReadString()
    local toIndex = net.ReadInt(16)
    
    local inventory = GetPlayerInventory(ply)
    
    if not inventory[fromType] or not inventory[toType] then
        print("[NoPixel Inventory] Invalid inventory type for " .. ply:Nick())
        return
    end
    
    if fromType == "equipment" or toType == "equipment" then
        print("[NoPixel Inventory] Equipment move not yet implemented")
        return
    end
    
    local fromItem = inventory[fromType][fromIndex]
    local toItem = inventory[toType][toIndex]
    
    inventory[fromType][fromIndex] = toItem
    inventory[toType][toIndex] = fromItem
    
    print(string.format("[NoPixel Inventory] %s moved item from %s[%d] to %s[%d]", 
        ply:Nick(), fromType, fromIndex, toType, toIndex))
    
    SendInventoryUpdate(ply)
end)

net.Receive("inventory_use_item", function(len, ply)
    local itemType = net.ReadString()
    local itemIndex = net.ReadInt(16)
    
    local inventory = GetPlayerInventory(ply)
    local item = inventory[itemType] and inventory[itemType][itemIndex]
    
    if not item then
        print("[NoPixel Inventory] " .. ply:Nick() .. " tried to use non-existent item")
        return
    end
    
    print(string.format("[NoPixel Inventory] %s used item: %s", ply:Nick(), item.name))
    
    if item.name == "Burger" then
        ply:SetHealth(math.min(ply:GetMaxHealth(), ply:Health() + 25))
        ply:ChatPrint("You ate a burger and restored 25 health!")
        
        if item.quantity > 1 then
            item.quantity = item.quantity - 1
        else
            inventory[itemType][itemIndex] = nil
        end
        
        SendInventoryUpdate(ply)
    elseif item.name == "Energy Drink" then
        ply:ChatPrint("You drank an energy drink and feel energized!")
        
        if item.quantity > 1 then
            item.quantity = item.quantity - 1
        else
            inventory[itemType][itemIndex] = nil
        end
        
        SendInventoryUpdate(ply)
    else
        ply:ChatPrint("You used: " .. item.name)
    end
end)

hook.Add("PlayerSpawn", "InventoryPlayerSpawn", function(ply)
    GetPlayerInventory(ply)
end)

hook.Add("PlayerDisconnected", "InventoryPlayerDisconnect", function(ply)
    local steamid = ply:SteamID()
    print("[NoPixel Inventory] " .. ply:Nick() .. " disconnected, inventory data retained in memory")
end)

print("[NoPixel Inventory] Server-side loaded.")
