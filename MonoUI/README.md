# MonoUI - A Comprehensive WoW UI Remake

A complete user interface replacement for World of Warcraft, inspired by the classic MonoUI addon.

## Features

- **Custom Unit Frames**: Clean, modern unit frames for player, target, pet, focus, and more
- **Action Bars**: Fully customizable action bars with modern styling
- **Minimap**: Square minimap with clean design and organized buttons
- **Chat**: Styled chat frames with copy functionality
- **Bags**: Unified bag interface with search
- **Nameplates**: Enhanced nameplates with health values and cast bars
- **Tooltips**: Enhanced tooltips with item level, specialization, and more
- **Buffs/Debuffs**: Organized buff and debuff display

## Installation

1. Download or clone this repository
2. Copy the `wowui` folder to your World of Warcraft AddOns directory:
   - **Windows**: `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
   - **Mac**: `/Applications/World of Warcraft/_retail_/Interface/AddOns/`
3. Rename the folder to `MonoUI` (if needed)
4. Download required libraries (see Dependencies section)
5. Launch World of Warcraft
6. Enable MonoUI in the AddOns menu at the character select screen

## Dependencies

MonoUI requires the following libraries. You can obtain them from:
- [Ace3](https://www.curseforge.com/wow/addons/ace3)
- [LibSharedMedia-3.0](https://www.curseforge.com/wow/addons/libsharedmedia-3-0)

### Installing Libraries

1. Download each library from the links above
2. Extract the library folders to: `MonoUI\Libs\`
3. Your folder structure should look like:
   ```
   MonoUI\
   ├── Libs\
   │   ├── LibStub\
   │   ├── CallbackHandler-1.0\
   │   ├── AceAddon-3.0\
   │   ├── AceDB-3.0\
   │   ├── AceConsole-3.0\
   │   └── AceEvent-3.0\
   ├── Core\
   ├── Modules\
   └── MonoUI.toc
   ```

## Usage

### Slash Commands

- `/monoui` or `/mui` - Show help
- `/monoui reset` - Reset all settings to defaults
- `/monoui version` - Show addon version

### Configuration

Configuration options are stored in the `MonoUIDB` saved variable. You can modify settings in-game through the slash commands or by editing the saved variables file.

Default settings can be found in `Core\Init.lua` in the `GetDefaults()` function.

### Moving Frames

Most frames (unit frames, minimap, etc.) can be moved by clicking and dragging them.

## Modules

### Unit Frames
- Player, Target, Pet, Focus, Target of Target
- Health and power bars with percentage display
- Portrait support
- Class-colored names and health bars
- Level and classification display

### Action Bars
- Up to 6 customizable action bars
- Customizable button size and spacing
- Hotkey and macro name display options
- Pet and stance/shapeshift bars

### Minimap
- Square or round design
- Customizable size
- Organized minimap buttons
- Mouse wheel zoom support

### Chat
- Styled chat frames
- Customizable fonts and colors
- Chat copy functionality
- Clean tab design

### Bags
- Unified bag interface
- Search functionality
- Gold and slot display
- Bank support

### Nameplates
- Custom nameplate styling
- Health value display
- Cast bar support
- Threat coloring

### Tooltips
- Enhanced tooltips with additional information
- Item level display
- Specialization display for players
- Item ID display

### Buffs
- Organized buff and debuff display
- Cooldown spirals
- Duration timers
- Stack count display
- Debuff type coloring

## Customization

You can customize MonoUI by editing the configuration in `Core\Init.lua`. The `GetDefaults()` function contains all customizable settings:

- Colors and fonts
- Frame sizes and positions
- Enable/disable individual modules
- Button sizes and spacing
- And much more!

## Development

### File Structure

```
MonoUI\
├── Core\
│   ├── Init.lua          # Main addon initialization
│   ├── Config.lua        # Configuration and constants
│   └── Utilities.lua     # Helper functions
├── Modules\
│   ├── UnitFrames.lua    # Unit frame module
│   ├── ActionBars.lua    # Action bar module
│   ├── Minimap.lua       # Minimap module
│   ├── Chat.lua          # Chat module
│   ├── Bags.lua          # Bag module
│   ├── Nameplates.lua    # Nameplate module
│   ├── Tooltip.lua       # Tooltip module
│   └── Buffs.lua         # Buff module
├── Libs\                 # External libraries
└── MonoUI.toc           # Addon table of contents
```

### Adding New Modules

1. Create a new `.lua` file in the `Modules\` directory
2. Add the file to `MonoUI.toc`
3. Register your module with `MonoUI:RegisterModule("ModuleName", module)`
4. Implement `Enable()`, `Disable()`, and `Update()` functions
5. Add default settings to `GetDefaults()` in `Core\Init.lua`

## Known Issues

- Some advanced features may require additional implementation
- Configuration GUI is not yet implemented (coming soon)
- Some modules may need adjustment for different screen resolutions

## Credits

- Inspired by the original MonoUI addon
- Built with Ace3 framework
- Special thanks to the WoW addon development community

## License

This project is provided as-is for educational and personal use.

## Support

For bugs, feature requests, or questions, please open an issue on the repository.

## Version History

### 1.0.0
- Initial release
- Core framework implemented
- All major modules functional
- Basic customization support
