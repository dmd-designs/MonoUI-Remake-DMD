# MonoUI Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-07-10

### Added
- Initial release of MonoUI remake
- Core addon framework with Ace3 integration
- Modular architecture for easy customization
- Complete unit frame system
  - Player, Target, Pet, Focus, Target of Target frames
  - Health and power bars with percentages
  - Class-colored names and health
  - Optional portrait display
  - Level and classification indicators
- Action bar system
  - Support for up to 6 action bars
  - Customizable button size and spacing
  - Pet and stance/shapeshift bars
  - Hotkey and macro name display options
- Minimap customization
  - Square or round design options
  - Customizable size
  - Organized minimap buttons
  - Mouse wheel zoom support
  - Clean styling with backdrop
- Chat frame enhancements
  - Styled chat frames with custom fonts
  - Chat copy functionality
  - Clean tab design
  - Customizable fade time
  - Enhanced edit box styling
- Unified bag interface
  - All bags in one window
  - Search functionality
  - Gold and slot count display
  - Bank support
  - Item button styling
- Nameplate improvements
  - Custom styling with backdrops
  - Health value display
  - Cast bar support with icons
  - Threat coloring system
  - Reaction-based coloring
- Enhanced tooltips
  - Item level display for gear
  - Player specialization display
  - Item ID display
  - Guild information
  - Target information
  - Custom styling and backdrop
- Buff and debuff display
  - Organized layout with customizable size
  - Cooldown spirals
  - Duration timers
  - Stack count display
  - Debuff type coloring
  - Separate buff and debuff frames
- Utility systems
  - Backdrop creation helpers
  - Number formatting (K, M, B)
  - Time formatting
  - Unit color helpers
  - Font string creation
  - Pixel-perfect scaling support
  - Frame movement helpers
- Configuration system
  - Comprehensive default settings
  - Saved variables support
  - Profile system via AceDB
  - Per-module enable/disable
  - Color customization
  - Font customization
- Slash commands
  - `/monoui` or `/mui` for help
  - `/monoui reset` to reset settings
  - `/monoui version` to show version
- Complete documentation
  - README with feature overview
  - Installation guide
  - Development documentation
  - Code comments throughout

### Technical Details
- Built on Ace3 framework
- Modular architecture for extensibility
- Event-driven design
- Secure templates for combat compliance
- Efficient memory usage
- Clean code organization

### Known Limitations
- Configuration GUI not yet implemented (planned for future release)
- Some features may need adjustment for ultrawide displays
- Library dependencies must be installed separately

### Credits
- Inspired by the original MonoUI addon
- Built with Ace3 library framework
- Thanks to the WoW addon community

---

## Future Plans

### Planned for 1.1.0
- In-game configuration GUI (Ace3 Config)
- Additional customization options
- Raid frame support
- Arena frame support
- Class-specific features

### Planned for 1.2.0
- Custom artwork and textures
- Animation effects
- Sound notifications
- LibSharedMedia integration
- Media packs

### Planned for Future Releases
- Mouseover casting support
- Custom aura filters
- Click-casting support
- Advanced automation options
- Profiles import/export
- Integration with popular addons (DBM, BigWigs, etc.)

---

## Version History Format

```
## [Version Number] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes to existing features

### Deprecated
- Features that will be removed

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security fixes
```

---

*Note: This is a remake/rewrite of the classic MonoUI addon. It is not affiliated with the original MonoUI project.*
