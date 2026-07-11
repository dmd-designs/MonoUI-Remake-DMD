# MonoUI Quick Start Guide

Get up and running with MonoUI in 5 minutes!

## 🚀 Quick Installation

### For Experienced Users

1. **Copy** the `wowui` folder to your WoW AddOns directory
2. **Rename** it to `MonoUI`
3. **Download** [Ace3](https://www.curseforge.com/wow/addons/ace3)
4. **Extract** Ace3 library folders to `MonoUI\Libs\`
5. **Launch** WoW and enable MonoUI
6. **Done!** Type `/mui` for help

### For New Users

Follow the detailed [INSTALLATION.md](INSTALLATION.md) guide.

## 📍 AddOns Folder Location

- **Windows**: `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
- **Mac**: `/Applications/World of Warcraft/_retail_/Interface/AddOns/`

## ⚡ First Launch Checklist

After logging in, you should see:

- ✅ Green welcome message: "MonoUI version 1.0.0 loaded"
- ✅ Custom unit frames (player/target)
- ✅ Redesigned action bars
- ✅ Modified minimap
- ✅ Styled chat frames

### If Something's Wrong

1. Type `/reload` to reload the UI
2. Check AddOns are enabled (character select screen)
3. Verify library installation (see INSTALLATION.md)

## 🎮 Essential Commands

| Command | Description |
|---------|-------------|
| `/monoui` or `/mui` | Show help |
| `/monoui reset` | Reset all settings |
| `/monoui version` | Show version |
| `/reload` | Reload UI |

## 🎨 Quick Customization

### Move Frames
- **Click and drag** most frames to reposition
- Player frame, target frame, minimap are all movable

### Adjust Settings
1. Open `Core\Init.lua`
2. Find `GetDefaults()` function
3. Change values (see comments)
4. Type `/reload` in-game

See [CUSTOMIZATION.md](CUSTOMIZATION.md) for detailed options.

## 📦 What's Included

### ✅ Fully Working
- Unit frames (player, target, pet, focus, ToT)
- Action bars (6 bars + pet + stance)
- Minimap styling
- Chat frames
- Bags (unified interface)
- Nameplates
- Tooltips
- Buffs & Debuffs

### 🔧 Coming Soon
- Configuration GUI
- Raid frames
- Arena frames
- Additional customization options

## 🆘 Quick Troubleshooting

### "Addon failed to load" Error
**Fix**: Install Ace3 libraries to `MonoUI\Libs\`

### Default UI Still Shows
**Fix**: 
1. Disable conflicting addons
2. Type `/reload`
3. Check MonoUI is enabled

### Frames Missing
**Fix**: Type `/monoui reset` then `/reload`

### Can't Move Frames
**Fix**: Make sure you're out of combat and click-dragging the frame itself

## 📚 Documentation

- [README.md](README.md) - Full overview
- [INSTALLATION.md](INSTALLATION.md) - Detailed installation
- [CUSTOMIZATION.md](CUSTOMIZATION.md) - Customization guide
- [CHANGELOG.md](CHANGELOG.md) - Version history

## 💡 Tips

1. **Start Simple**: Use default settings first, customize later
2. **One Change at a Time**: Easier to track what breaks
3. **Backup**: Save your `WTF` folder before major changes
4. **Reset Available**: `/monoui reset` if you get stuck
5. **Community**: Check WoW addon forums for help

## 🎯 Common Tasks

### Change Colors
1. Edit `Core\Config.lua`
2. Modify RGB values in `private.Colors`
3. `/reload`

### Resize Unit Frames
1. Edit `Modules\UnitFrames.lua`
2. Find `CreateUnitFrame("player", 250, 60)`
3. Change width/height numbers
4. `/reload`

### Move Action Bars
1. Edit `Modules\ActionBars.lua`
2. Find `PositionBars()` function
3. Modify `SetPoint()` coordinates
4. `/reload`

### Change Font Size
1. Edit `Core\Init.lua`
2. Find fontSize settings in `GetDefaults()`
3. Change numbers
4. `/reload`

## ✨ Make It Yours

MonoUI is designed to be customized! Every aspect can be modified:
- Colors
- Fonts
- Sizes
- Positions
- Behaviors

Check [CUSTOMIZATION.md](CUSTOMIZATION.md) for the full guide.

## 🤝 Getting Help

If you're stuck:

1. **Read the error** - Look at the error message in-game
2. **Check installation** - Verify folder structure
3. **Reset settings** - Try `/monoui reset`
4. **Disable addons** - Test for conflicts
5. **Ask for help** - WoW UI forums, Discord communities

## 📈 Next Steps

1. **Test everything** - Make sure all features work
2. **Position frames** - Arrange UI to your preference
3. **Customize colors** - Match your style
4. **Add features** - Modify code or request features
5. **Share feedback** - Help improve MonoUI

## 🌟 Enjoy!

You're all set! MonoUI should give you a clean, modern interface for World of Warcraft.

Type `/mui` in chat anytime for help.

Happy adventuring! 🎮

---

*Questions? Check the other documentation files or visit WoW addon communities.*
