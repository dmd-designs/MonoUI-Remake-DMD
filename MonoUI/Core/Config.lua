--[[
    MonoUI - Configuration
    Shared configuration and constants
]]--

local ADDON_NAME, private = ...

-- Color palette
private.Colors = {
    primary = {0.0, 1.0, 0.0},      -- Green
    secondary = {1.0, 1.0, 1.0},    -- White
    background = {0.0, 0.0, 0.0, 0.8},
    border = {0.3, 0.3, 0.3},
    
    -- Class colors
    classColors = {
        WARRIOR = {0.78, 0.61, 0.43},
        PALADIN = {0.96, 0.55, 0.73},
        HUNTER = {0.67, 0.83, 0.45},
        ROGUE = {1.0, 0.96, 0.41},
        PRIEST = {1.0, 1.0, 1.0},
        DEATHKNIGHT = {0.77, 0.12, 0.23},
        SHAMAN = {0.0, 0.44, 0.87},
        MAGE = {0.25, 0.78, 0.92},
        WARLOCK = {0.53, 0.53, 0.93},
        MONK = {0.0, 1.0, 0.59},
        DRUID = {1.0, 0.49, 0.04},
        DEMONHUNTER = {0.64, 0.19, 0.79},
        EVOKER = {0.2, 0.58, 0.5},
    },
    
    -- Power colors
    powerColors = {
        MANA = {0.0, 0.5, 1.0},
        RAGE = {0.9, 0.1, 0.1},
        FOCUS = {1.0, 0.5, 0.25},
        ENERGY = {1.0, 1.0, 0.0},
        RUNIC_POWER = {0.0, 0.82, 1.0},
    },
    
    -- Reaction colors
    reaction = {
        [1] = {0.8, 0.1, 0.1},  -- Hated
        [2] = {0.8, 0.1, 0.1},  -- Hostile
        [3] = {0.8, 0.1, 0.1},  -- Unfriendly
        [4] = {1.0, 1.0, 0.0},  -- Neutral
        [5] = {0.0, 1.0, 0.0},  -- Friendly
        [6] = {0.0, 1.0, 0.0},  -- Honored
        [7] = {0.0, 1.0, 0.0},  -- Revered
        [8] = {0.0, 1.0, 0.0},  -- Exalted
    },
}

-- Font paths
private.Fonts = {
    normal = "Fonts\\FRIZQT__.TTF",
    bold = "Fonts\\ARIALN.TTF",
    number = "Fonts\\ARIALN.TTF",
}

-- Media paths
private.Media = {
    textures = {
        blank = "Interface\\Buttons\\WHITE8x8",
        gradient = "Interface\\AddOns\\MonoUI\\Media\\gradient",
        statusbar = "Interface\\AddOns\\MonoUI\\Media\\statusbar",
    },
    sounds = {},
}

-- Constants
private.Constants = {
    PIXEL_SCALE = 1,
    MAX_BARS = 6,
    BUTTON_SIZE = 32,
    SPACING = 2,
}

-- Helper to get class color
function private:GetClassColor(class)
    if not class then
        local _, class = UnitClass("player")
        return self.Colors.classColors[class] or self.Colors.primary
    end
    return self.Colors.classColors[class] or self.Colors.primary
end

-- Helper to get power color
function private:GetPowerColor(powerType)
    local powerName = PowerBarColor[powerType]
    if powerName then
        return powerName.r, powerName.g, powerName.b
    end
    return unpack(self.Colors.primary)
end

-- Helper to get reaction color
function private:GetReactionColor(unit)
    if not UnitExists(unit) then return unpack(self.Colors.primary) end
    
    local reaction = UnitReaction(unit, "player")
    if reaction then
        return unpack(self.Colors.reaction[reaction] or self.Colors.primary)
    end
    return unpack(self.Colors.primary)
end
