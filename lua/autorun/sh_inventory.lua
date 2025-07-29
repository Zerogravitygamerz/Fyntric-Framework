
INVENTORY_CONFIG = {
    MAX_POCKET_SLOTS = 6,
    MAX_PLAYER_SLOTS = 15,
    MAX_BACKPACK_SLOTS = 30,
    MAX_OTHER_SLOTS = 15,
    
    POCKET_GRID = {2, 3}, -- 2x3 grid
    PLAYER_GRID = {5, 3}, -- 5x3 grid  
    BACKPACK_GRID = {5, 6}, -- 5x6 grid
    OTHER_GRID = {5, 3}, -- 5x3 grid
    
    EQUIPMENT_SLOTS = {
        "head",
        "left-arm", 
        "right-arm",
        "body",
        "left-leg",
        "right-leg"
    }
}

INVENTORY_ITEMS = {
    ["burger"] = {
        name = "Burger",
        icon = "fas fa-hamburger",
        description = "A delicious burger that restores health",
        usable = true,
        stackable = true,
        max_stack = 10
    },
    
    ["water"] = {
        name = "Water Bottle", 
        icon = "fas fa-tint",
        description = "Fresh water to quench your thirst",
        usable = true,
        stackable = true,
        max_stack = 5
    },
    
    ["keys"] = {
        name = "Keys",
        icon = "fas fa-key", 
        description = "Vehicle and house keys",
        usable = false,
        stackable = false
    },
    
    ["phone"] = {
        name = "Phone",
        icon = "fas fa-mobile-alt",
        description = "A smartphone for communication", 
        usable = true,
        stackable = false
    },
    
    ["energy_drink"] = {
        name = "Energy Drink",
        icon = "fas fa-battery-full",
        description = "Restores energy and stamina",
        usable = true,
        stackable = true,
        max_stack = 20
    },
    
    ["first_aid"] = {
        name = "First Aid Kit",
        icon = "fas fa-medkit", 
        description = "Emergency medical supplies",
        usable = true,
        stackable = true,
        max_stack = 5
    }
}

function INVENTORY_GetItemData(itemId)
    return INVENTORY_ITEMS[itemId]
end

function INVENTORY_IsValidSlot(inventoryType, slotIndex)
    local maxSlots = 0
    
    if inventoryType == "pocket" then
        maxSlots = INVENTORY_CONFIG.MAX_POCKET_SLOTS
    elseif inventoryType == "player" then
        maxSlots = INVENTORY_CONFIG.MAX_PLAYER_SLOTS
    elseif inventoryType == "backpack" then
        maxSlots = INVENTORY_CONFIG.MAX_BACKPACK_SLOTS
    elseif inventoryType == "other" then
        maxSlots = INVENTORY_CONFIG.MAX_OTHER_SLOTS
    elseif inventoryType == "equipment" then
        return table.HasValue(INVENTORY_CONFIG.EQUIPMENT_SLOTS, slotIndex)
    end
    
    return slotIndex >= 1 and slotIndex <= maxSlots
end

print("[NoPixel Inventory] Shared configuration loaded.")
