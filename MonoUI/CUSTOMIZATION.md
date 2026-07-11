# MonoUI Customization Guide

This guide will help you customize MonoUI to your preferences.

## Table of Contents

1. [Basic Configuration](#basic-configuration)
2. [Colors](#colors)
3. [Fonts](#fonts)
4. [Unit Frames](#unit-frames)
5. [Action Bars](#action-bars)
6. [Minimap](#minimap)
7. [Chat](#chat)
8. [Bags](#bags)
9. [Nameplates](#nameplates)
10. [Tooltips](#tooltips)
11. [Buffs](#buffs)

## Basic Configuration

All settings are stored in `Core\Init.lua` in the `GetDefaults()` function.

To modify settings:
1. Open `Core\Init.lua` in a text editor
2. Find the `GetDefaults()` function
3. Modify the values
4. Save the file
5. Type `/reload` in-game or restart WoW

## Colors

### Changing Primary Colors

Located in `Core\Config.lua`:

```lua
private.Colors = {
    primary = {0.0, 1.0, 0.0},      -- Green (RGB values 0-1)
    secondary = {1.0, 1.0, 1.0},    -- White
    background = {0.0, 0.0, 0.0, 0.8},  -- Black with 80% opacity
    border = {0.3, 0.3, 0.3},       -- Dark gray
}
```

**RGB Values**: Use values between 0 and 1
- Red: `{1, 0, 0}`
- Green: `{0, 1, 0}`
- Blue: `{0, 0, 1}`
- Yellow: `{1, 1, 0}`
- Purple: `{0.5, 0, 0.5}`
- Orange: `{1, 0.5, 0}`

### Changing Class Colors

Modify class colors in `Core\Config.lua`:

```lua
classColors = {
    WARRIOR = {0.78, 0.61, 0.43},
    PALADIN = {0.96, 0.55, 0.73},
    -- ... etc
}
```

## Fonts

### Changing Default Fonts

Located in `Core\Config.lua`:

```lua
private.Fonts = {
    normal = "Fonts\\FRIZQT__.TTF",
    bold = "Fonts\\ARIALN.TTF",
    number = "Fonts\\ARIALN.TTF",
}
```

**Available WoW Fonts**:
- `Fonts\\FRIZQT__.TTF` - Default UI font
- `Fonts\\ARIALN.TTF` - Arial Narrow
- `Fonts\\MORPHEUS.TTF` - Decorative font
- `Fonts\\skurri.ttf` - Skurri font
- `Fonts\\FRIENDS.TTF` - Friends font

You can also use custom fonts by placing them in `MonoUI\Media\Fonts\` and referencing them:
```lua
normal = "Interface\\AddOns\\MonoUI\\Media\\Fonts\\YourFont.ttf"
```

## Unit Frames

### Basic Settings

In `Core\Init.lua`, find the `unitframes` section:

```lua
unitframes = {
    enabled = true,              -- Enable/disable unit frames
    showPortrait = true,         -- Show 3D portrait
    showCastbar = true,          -- Show cast bar
    healthColor = {0.0, 1.0, 0.0},  -- Health bar color (green)
    powerColor = {0.0, 0.5, 1.0},   -- Power bar color (blue)
},
```

### Positioning Unit Frames

In `Modules\UnitFrames.lua`, find the `CreatePlayerFrame()` function:

```lua
frame:SetPoint("CENTER", UIParent, "CENTER", -300, -200)
```

**Position Format**: `SetPoint(anchor, relative, relativeAnchor, x, y)`
- Anchor points: `TOP`, `BOTTOM`, `LEFT`, `RIGHT`, `CENTER`, `TOPLEFT`, `TOPRIGHT`, `BOTTOMLEFT`, `BOTTOMRIGHT`
- X: Horizontal offset (positive = right, negative = left)
- Y: Vertical offset (positive = up, negative = down)

### Changing Unit Frame Size

Find the `CreateUnitFrame()` calls and modify the width/height:

```lua
local frame = self:CreateUnitFrame("player", 250, 60)  -- width, height
```

## Action Bars

### Settings

```lua
actionbars = {
    enabled = true,
    numBars = 6,              -- Number of bars (1-6)
    buttonSize = 32,          -- Size of buttons in pixels
    buttonSpacing = 2,        -- Space between buttons
    showHotkeys = true,       -- Show hotkey text
    showMacroNames = true,    -- Show macro names
},
```

### Repositioning Bars

In `Modules\ActionBars.lua`, find the `PositionBars()` function:

```lua
-- Bar 1 - Main bar
if bars[1] then
    bars[1]:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 50)
end
```

Modify the position values to move bars.

### Changing Number of Buttons per Bar

In `Modules\ActionBars.lua`, modify:

```lua
local NUM_ACTIONBAR_BUTTONS = 12  -- Change to 10, 11, 12, etc.
```

## Minimap

### Settings

```lua
minimap = {
    enabled = true,
    size = 140,               -- Size in pixels
    shape = "square",         -- "square" or "round"
    hideZoomButtons = true,   -- Hide zoom buttons
},
```

### Position

In `Modules\Minimap.lua`, find `PositionMinimap()`:

```lua
Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -20)
```

## Chat

### Settings

```lua
chat = {
    enabled = true,
    fontSize = 12,            -- Font size for chat text
    fadeTime = 120,           -- Time in seconds before fading
    width = 400,              -- Chat frame width
    height = 150,             -- Chat frame height
},
```

### Position

In `Modules\Chat.lua`, find `PositionChatFrames()`:

```lua
cf1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 20, 20)
```

## Bags

### Settings

```lua
bags = {
    enabled = true,
    oneContainerBag = true,   -- Combine all bags
    spacing = 2,              -- Space between items
},
```

### Bag Window Size

In `Modules\Bags.lua`, find `CreateBagFrame()`:

```lua
frame:SetSize(400, 500)  -- width, height
```

## Nameplates

### Settings

```lua
nameplates = {
    enabled = true,
    showHealthValue = true,   -- Show health percentage
    showCastbar = true,       -- Show cast bar
},
```

### Customizing Nameplate Appearance

In `Modules\Nameplates.lua`, modify the `StyleNameplate()` function to change colors, sizes, and positioning.

## Tooltips

### Settings

```lua
tooltip = {
    enabled = true,
    showItemLevel = true,     -- Show item level on gear
    showSpecialization = true, -- Show player spec
},
```

### Tooltip Anchor

By default, tooltips follow the cursor. To change this, modify in `Modules\Tooltip.lua`:

```lua
-- For static positioning
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    tooltip:SetOwner(parent, "ANCHOR_BOTTOMRIGHT")  -- Change anchor here
end)
```

## Buffs

### Settings

```lua
buffs = {
    enabled = true,
    consolidate = true,       -- Consolidate buffs
    size = 30,                -- Icon size in pixels
},
```

### Position

In `Modules\Buffs.lua`, find `CreateBuffFrame()` and `CreateDebuffFrame()`:

```lua
frame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -200, -20)
```

### Changing Number of Icons per Row

In `Modules\Buffs.lua`, modify:

```lua
local maxPerRow = 16  -- Change to desired number
```

## Advanced Customization

### Adding Custom Modules

1. Create a new file in `Modules\` (e.g., `MyModule.lua`)
2. Add it to `MonoUI.toc`:
   ```
   Modules\MyModule.lua
   ```
3. Create your module:
   ```lua
   local ADDON_NAME, private = ...
   local MonoUI = private.MonoUI
   
   local MyModule = {}
   MonoUI:RegisterModule("MyModule", MyModule)
   
   function MyModule:Enable()
       -- Your code here
   end
   
   function MyModule:Disable()
       -- Cleanup code
   end
   
   function MyModule:Update()
       -- Update code
   end
   ```

### Creating Custom Slash Commands

In `Core\Init.lua`, modify the `SlashCommand()` function:

```lua
function MonoUI:SlashCommand(input)
    if input:lower() == "mycommand" then
        self:Print("My custom command!")
    end
end
```

### Saving Custom Settings

Add your settings to the `GetDefaults()` function:

```lua
myModule = {
    enabled = true,
    mySetting = "value",
},
```

Access them in your module:

```lua
local mySetting = MonoUI.db.profile.myModule.mySetting
```

## Tips

1. **Backup**: Always backup your `WTF` folder before making changes
2. **Test**: Make small changes and test frequently
3. **Reload**: Use `/reload` to reload the UI after changes
4. **Reset**: Use `/monoui reset` to reset to defaults if something breaks
5. **Comments**: Add comments to remember your changes

## Getting Help

If you need help with customization:
1. Check the existing code for examples
2. Refer to the [WoW UI & Macros Forum](https://us.forums.blizzard.com/en/wow/c/ui-macros/23)
3. Look at other addons for inspiration
4. Read the [WoW API Documentation](https://wowpedia.fandom.com/wiki/World_of_Warcraft_API)

## Resources

- [WoW Programming Wiki](https://wowpedia.fandom.com/)
- [Ace3 Documentation](https://www.wowace.com/projects/ace3)
- [WoW Interface](https://www.wowinterface.com/)
- [CurseForge](https://www.curseforge.com/wow/addons)
