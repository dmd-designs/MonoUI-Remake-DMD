# Contributing to MonoUI

Thank you for your interest in contributing to MonoUI! This document provides guidelines and information for contributors.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [How to Contribute](#how-to-contribute)
3. [Development Setup](#development-setup)
4. [Coding Standards](#coding-standards)
5. [Submitting Changes](#submitting-changes)
6. [Reporting Bugs](#reporting-bugs)
7. [Feature Requests](#feature-requests)

## Code of Conduct

- Be respectful and constructive
- Welcome newcomers and help them learn
- Focus on what's best for the community
- Keep discussions relevant to the project

## How to Contribute

There are many ways to contribute:

- **Code**: Fix bugs, add features, improve performance
- **Documentation**: Improve guides, add examples, fix typos
- **Testing**: Test new features, report bugs
- **Design**: Create textures, sounds, or UI mockups
- **Support**: Help other users in forums or Discord

## Development Setup

### Prerequisites

- World of Warcraft (Retail version)
- Text editor (VS Code, Sublime, Notepad++, etc.)
- Basic Lua knowledge
- Git (for version control)

### Setup Steps

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/MonoUI.git
   ```

2. **Install to WoW AddOns folder**
   - Windows: `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\MonoUI`
   - Mac: `/Applications/World of Warcraft/_retail_/Interface/AddOns/MonoUI`

3. **Install dependencies**
   - Download [Ace3](https://www.curseforge.com/wow/addons/ace3)
   - Extract to `MonoUI\Libs\`

4. **Test in-game**
   - Launch WoW
   - Enable MonoUI
   - Test your changes

### Development Workflow

1. Create a new branch for your feature
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. Make your changes

3. Test thoroughly in-game

4. Commit with clear messages
   ```bash
   git commit -m "Add: New feature description"
   ```

5. Push to your fork
   ```bash
   git push origin feature/my-new-feature
   ```

6. Create a Pull Request

## Coding Standards

### Lua Style Guide

#### Indentation and Spacing
- Use **4 spaces** for indentation (no tabs)
- Add blank lines between logical sections
- Keep lines under 120 characters when possible

#### Naming Conventions
```lua
-- Variables: camelCase
local myVariable = true
local playerHealth = 100

-- Functions: PascalCase for public, camelCase for private
function MyModule:PublicFunction()
end

local function privateHelper()
end

-- Constants: UPPER_SNAKE_CASE
local MAX_BUTTONS = 12
local DEFAULT_SIZE = 32

-- Module tables: PascalCase
local UnitFrames = {}
```

#### Comments
```lua
-- Single-line comments for brief explanations
local value = 10

--[[
    Multi-line comments for detailed explanations
    Use for function headers and complex logic
]]--
function MyModule:ComplexFunction()
end
```

#### File Headers
```lua
--[[
    MonoUI - Module Name
    Brief description of what this module does
]]--

local ADDON_NAME, private = ...
local MonoUI = private.MonoUI
```

### Module Structure

Every module should follow this pattern:

```lua
--[[
    MonoUI - Module Name
    Description
]]--

local ADDON_NAME, private = ...
local MonoUI = private.MonoUI
local Utils = private.Utils

local ModuleName = {}
MonoUI:RegisterModule("ModuleName", ModuleName)

-- Module variables (private)
local localVar = {}

function ModuleName:Enable()
    -- Called when module is enabled
end

function ModuleName:Disable()
    -- Called when module is disabled
end

function ModuleName:Update()
    -- Called to update module
end

-- Private helper functions
local function helperFunction()
end
```

### Best Practices

1. **Performance**
   - Cache frequently used values
   - Avoid creating functions in loops
   - Use local variables when possible
   - Clean up frames and events when disabled

2. **Memory**
   - Reuse frames instead of creating new ones
   - Unregister events when not needed
   - Clear references to allow garbage collection

3. **Compatibility**
   - Use secure templates for combat-related frames
   - Test with other popular addons
   - Don't override Blizzard functions unnecessarily

4. **Error Handling**
   - Check if units/frames exist before using them
   - Validate user input
   - Provide meaningful error messages

### Code Examples

#### Good
```lua
-- Cache frequently used functions
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax

function ModuleName:UpdateHealth(unit)
    if not UnitExists(unit) then return end
    
    local health = UnitHealth(unit)
    local maxHealth = UnitHealthMax(unit)
    
    if maxHealth > 0 then
        local percent = (health / maxHealth) * 100
        self.healthBar:SetValue(percent)
    end
end
```

#### Bad
```lua
function ModuleName:UpdateHealth(unit)
    -- No validation
    self.healthBar:SetValue((UnitHealth(unit) / UnitHealthMax(unit)) * 100)
end
```

## Submitting Changes

### Pull Request Process

1. **Update documentation**
   - Update README.md if adding features
   - Add comments to new functions
   - Update CHANGELOG.md

2. **Test thoroughly**
   - Test in combat and out of combat
   - Test with different classes
   - Test with other addons enabled

3. **Create clear commits**
   - One logical change per commit
   - Clear commit messages
   - Reference issues if applicable

4. **Submit Pull Request**
   - Describe what changed
   - Explain why the change is needed
   - Include screenshots if UI changes
   - List any breaking changes

### Commit Message Format

```
Type: Brief description

Detailed explanation if needed

Fixes #123
```

**Types:**
- `Add:` New feature
- `Fix:` Bug fix
- `Update:` Update existing feature
- `Remove:` Remove feature
- `Refactor:` Code restructuring
- `Docs:` Documentation changes
- `Style:` Code style changes
- `Test:` Test additions/changes

**Examples:**
```
Add: Health percentage display on unit frames

Added configurable health percentage text to all unit frames.
Can be enabled/disabled in settings.

Fixes #45
```

```
Fix: Action bar buttons not showing after reload

Fixed issue where action bar buttons would disappear after
a /reload command due to improper event registration.

Fixes #78
```

## Reporting Bugs

### Before Reporting

1. Update to the latest version
2. Disable other addons to check for conflicts
3. Check if the bug is already reported
4. Gather error messages (use BugGrabber/BugSack)

### Bug Report Template

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Error messages**
Paste any error messages here.

**Environment:**
- WoW Version: [e.g., 10.2.0]
- MonoUI Version: [e.g., 1.0.0]
- Other Addons: [list conflicting addons]

**Additional context**
Any other relevant information.
```

## Feature Requests

### Before Requesting

1. Check if it's already planned (CHANGELOG.md)
2. Search existing feature requests
3. Consider if it fits MonoUI's goals

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
What you want to happen.

**Describe alternatives you've considered**
Other solutions you've thought about.

**Additional context**
Screenshots, mockups, examples from other addons.
```

## Questions?

- Check the documentation first
- Look at existing code for examples
- Ask in discussions or issues
- Be patient - this is a community project

## Recognition

Contributors will be:
- Listed in CHANGELOG.md
- Credited in commit history
- Mentioned in release notes (for significant contributions)

## License

By contributing, you agree that your contributions will be licensed under the same license as MonoUI (MIT License).

---

Thank you for contributing to MonoUI! 🎉
