# Fyntric-Framework - NoPixel Inventory System

A realistic NoPixel-style inventory system for Garry's Mod featuring:

## Features

- **Character-centered design** with anatomical equipment slots
- **Multiple inventory sections**: Pockets, Player, Backpack, 24/7 Supermarket
- **Drag & drop functionality** between all inventory types
- **Personal information display** with player details
- **Tab key toggle** - Press TAB to open/close inventory
- **Realistic NoPixel styling** with dark theme and teal accents

## Installation

1. Download or clone this repository
2. Place the entire folder in your Garry's Mod `addons` directory
3. Restart your Garry's Mod server or use `lua_run` commands to reload

## Usage

### For Players
- Press **TAB** to open/close the inventory
- **Drag and drop** items between inventory sections
- **Click** on items to view information
- **Double-click** items to use them (if usable)
- Press **ESC** to close the inventory

### For Developers

#### Server-side Functions
```lua
-- Get player inventory
local inventory = GetPlayerInventory(player)

-- Add item to player inventory
inventory.player[1] = {
    name = "Custom Item",
    icon = "fas fa-star",
    quantity = 1,
    description = "A custom item"
}

-- Send inventory update
SendInventoryUpdate(player)
```

#### Client-side Functions
```lua
-- Open inventory programmatically
INVENTORY:Open()

-- Close inventory
INVENTORY:Close()

-- Check if inventory is open
if INVENTORY.IsOpen then
    -- Do something
end
```

## File Structure

```
lua/
├── autorun/
│   ├── client/
│   │   └── cl_inventory.lua    # Client-side inventory logic
│   ├── server/
│   │   └── sv_inventory.lua    # Server-side inventory management
│   └── sh_inventory.lua        # Shared configuration
html/
└── inventory/
    ├── styles.css              # Inventory UI styling
    └── script.js               # Inventory JavaScript logic
```

## Configuration

Edit `lua/autorun/sh_inventory.lua` to modify:
- Inventory slot counts
- Grid layouts
- Item definitions
- Equipment slot names

## Customization

### Adding New Items
Add items to the `INVENTORY_ITEMS` table in `sh_inventory.lua`:

```lua
["my_item"] = {
    name = "My Custom Item",
    icon = "fas fa-custom-icon",
    description = "Description of my item",
    usable = true,
    stackable = true,
    max_stack = 5
}
```

### Modifying UI Layout
Edit `html/inventory/styles.css` to change:
- Colors and themes
- Positioning and sizing
- Animations and effects

### Custom Key Binding
Change the inventory key in `cl_inventory.lua`:
```lua
local INVENTORY_KEY = KEY_I  -- Change from TAB to I key
```

## Dependencies

- Garry's Mod
- Font Awesome (loaded via CDN)

## Compatibility

- Works with DarkRP and other gamemodes
- Compatible with other inventory addons (may require configuration)
- Supports multiplayer servers

## Support

For issues, suggestions, or contributions, please visit the GitHub repository.

## License

This project is open source. Feel free to modify and distribute according to your needs.
