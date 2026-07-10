# Media Folder

This folder is for custom media files (textures, sounds, fonts) for MonoUI.

## Folder Structure

```
Media\
├── Textures\      # Custom textures (statusbars, borders, backgrounds)
├── Fonts\         # Custom fonts (.ttf files)
└── Sounds\        # Custom sound files
```

## Adding Custom Textures

1. Place your `.tga` or `.blp` files in the `Textures\` folder
2. Reference them in your code:
   ```lua
   texture:SetTexture("Interface\\AddOns\\MonoUI\\Media\\Textures\\MyTexture")
   ```

## Adding Custom Fonts

1. Place your `.ttf` font files in the `Fonts\` folder
2. Reference them in `Core\Config.lua`:
   ```lua
   private.Fonts = {
       normal = "Interface\\AddOns\\MonoUI\\Media\\Fonts\\MyFont.ttf",
   }
   ```

## Adding Custom Sounds

1. Place your `.ogg` or `.mp3` files in the `Sounds\` folder
2. Reference them in your code:
   ```lua
   PlaySoundFile("Interface\\AddOns\\MonoUI\\Media\\Sounds\\MySound.ogg")
   ```

## Notes

- WoW supports `.tga` and `.blp` for textures (`.blp` is preferred for smaller file size)
- Fonts must be `.ttf` format
- Sounds should be `.ogg` or `.mp3` format
- Keep file sizes reasonable to avoid long loading times

## Example Files

You can add example files here for reference:
- `statusbar.tga` - A custom status bar texture
- `MyFont.ttf` - A custom font
- `notification.ogg` - A notification sound

## LibSharedMedia Integration

If you want to use LibSharedMedia-3.0 (optional):

1. Install LibSharedMedia-3.0
2. Register your media in your addon code:
   ```lua
   local LSM = LibStub("LibSharedMedia-3.0")
   LSM:Register("statusbar", "MonoUI Clean", [[Interface\AddOns\MonoUI\Media\Textures\statusbar]])
   ```

## Creating Your Own Textures

### Status Bar Texture
- Recommended size: 256x32 pixels
- Format: .tga or .blp
- Should be a solid or gradient texture

### Border Texture
- Can be any size (usually 8x8 or 16x16)
- Should tile well

### Background Texture
- Usually 512x512 or 1024x1024
- Can be tiled or stretched

## Tools

Recommended tools for creating WoW textures:
- **GIMP** - Free image editor
- **BLP Converter** - Convert between .tga and .blp
- **WoW BLP Lab** - Professional BLP editor

## Resources

- [WoW Interface Media](https://www.wowinterface.com/downloads/cat20.html)
- [BLP Converter Download](https://www.wowinterface.com/downloads/info14110-BLPConverter.html)
- [WoW UI Texture Guide](https://wowpedia.fandom.com/wiki/Creating_textures)
