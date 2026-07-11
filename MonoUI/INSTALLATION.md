# MonoUI Installation Guide

This guide will help you install MonoUI and its required dependencies.

## Prerequisites

- World of Warcraft (Retail version)
- Basic knowledge of addon installation

## Step 1: Locate Your AddOns Folder

Find your WoW AddOns directory:

### Windows
```
C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\
```

### macOS
```
/Applications/World of Warcraft/_retail_/Interface/AddOns/
```

If the `AddOns` folder doesn't exist, create it.

## Step 2: Install MonoUI

1. Copy the entire `wowui` folder to your AddOns directory
2. Rename the folder from `wowui` to `MonoUI` (important!)
3. Your path should now be:
   - Windows: `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\MonoUI\`
   - macOS: `/Applications/World of Warcraft/_retail_/Interface/AddOns/MonoUI/`

## Step 3: Download Required Libraries

MonoUI requires external libraries to function. You have two options:

### Option A: Download Packaged Ace3 (Recommended for Beginners)

1. Visit: https://www.curseforge.com/wow/addons/ace3
2. Click "Download" to get the latest version
3. Extract the downloaded ZIP file
4. You'll see multiple folders (LibStub, CallbackHandler-1.0, AceAddon-3.0, etc.)
5. Copy ALL these folders into `MonoUI\Libs\` directory
6. Replace the placeholder files when prompted

Your `MonoUI\Libs\` folder should contain:
```
MonoUI\Libs\
├── LibStub\
│   └── LibStub.lua (real file, not placeholder)
├── CallbackHandler-1.0\
│   └── CallbackHandler-1.0.lua (real file)
├── AceAddon-3.0\
│   └── AceAddon-3.0.lua (real file)
├── AceDB-3.0\
│   └── AceDB-3.0.lua (real file)
├── AceConsole-3.0\
│   └── AceConsole-3.0.lua (real file)
└── AceEvent-3.0\
    └── AceEvent-3.0.lua (real file)
```

### Option B: Use CurseForge Client (Easiest)

1. Install the [CurseForge Client](https://www.curseforge.com/download/app)
2. Add World of Warcraft to the client
3. Search for and install "Ace3"
4. The Ace3 libraries will be installed automatically
5. Copy the library folders from your main AddOns folder to `MonoUI\Libs\`

## Step 4: Verify Installation

Your MonoUI folder structure should look like this:

```
MonoUI\
├── Core\
│   ├── Init.lua
│   ├── Config.lua
│   └── Utilities.lua
├── Modules\
│   ├── ActionBars.lua
│   ├── Bags.lua
│   ├── Buffs.lua
│   ├── Chat.lua
│   ├── Minimap.lua
│   ├── Nameplates.lua
│   ├── Tooltip.lua
│   └── UnitFrames.lua
├── Libs\
│   ├── LibStub\
│   ├── CallbackHandler-1.0\
│   ├── AceAddon-3.0\
│   ├── AceDB-3.0\
│   ├── AceConsole-3.0\
│   └── AceEvent-3.0\
├── MonoUI.toc
└── README.md
```

## Step 5: Enable the Addon

1. Launch World of Warcraft
2. At the character select screen, click "AddOns" in the bottom-left corner
3. Find "MonoUI" in the list
4. Check the box next to it to enable
5. Click "Okay"
6. Log in with your character

## Step 6: Configure MonoUI

Once in-game, you should see:
- Custom unit frames for player, target, etc.
- Restyled action bars at the bottom
- Modified minimap in the top-right
- Enhanced chat frames

Type `/monoui` or `/mui` in chat to see available commands.

## Troubleshooting

### "MonoUI failed to load" or Error Messages

**Problem**: Missing or incorrect library installation

**Solution**:
1. Check that all library folders are in `MonoUI\Libs\`
2. Ensure you've replaced the placeholder `.lua` files with real library files
3. Make sure folder names match exactly (case-sensitive on some systems)

### Default UI Still Shows

**Problem**: Blizzard frames not hidden

**Solution**:
1. Disable other UI addons that might conflict
2. Type `/reload` in-game to reload the UI
3. Check that MonoUI is enabled in the AddOns menu

### Frames Are Missing or Not Positioned Correctly

**Problem**: First-time load or resolution issues

**Solution**:
1. Type `/monoui reset` to reset to defaults
2. Log out and back in
3. Manually move frames by clicking and dragging

### "LibStub not installed" Error

**Problem**: Libraries not properly installed

**Solution**:
1. Verify the Ace3 library files are in place
2. Don't just extract Ace3 to AddOns - copy the individual library folders to MonoUI\Libs\
3. Restart WoW completely

## Getting Help

If you continue to have issues:

1. Check the error message in-game (if any)
2. Verify your folder structure matches the guide
3. Ensure you're running the retail (not Classic) version of WoW
4. Try disabling other addons to check for conflicts

## Next Steps

- Explore the modules and features
- Customize settings by editing `Core\Init.lua`
- Move frames to your preferred positions
- Use `/monoui` for help with commands

Enjoy your new UI!
