--[[
    MonoUI - Utilities
    Helper functions and utilities
]]--

local ADDON_NAME, private = ...

private.Utils = {}
local Utils = private.Utils

-- Create a simple backdrop
function Utils:CreateBackdrop(frame, inset)
    inset = inset or 0
    
    local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -inset, inset)
    backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", inset, -inset)
    backdrop:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets = {left = 0, right = 0, top = 0, bottom = 0},
    })
    backdrop:SetBackdropColor(0, 0, 0, 0.8)
    backdrop:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
    backdrop:SetFrameLevel(frame:GetFrameLevel())
    
    frame.backdrop = backdrop
    return backdrop
end

-- Format large numbers
function Utils:FormatNumber(num)
    if num >= 1000000000 then
        return format("%.1fB", num / 1000000000)
    elseif num >= 1000000 then
        return format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

-- Format time
function Utils:FormatTime(seconds)
    if seconds >= 3600 then
        return format("%dh", seconds / 3600)
    elseif seconds >= 60 then
        return format("%dm", seconds / 60)
    else
        return format("%ds", seconds)
    end
end

-- Get unit color
function Utils:GetUnitColor(unit)
    if not UnitExists(unit) then return 1, 1, 1 end
    
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        if class then
            local color = private.Colors.classColors[class]
            if color then
                return unpack(color)
            end
        end
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            local color = private.Colors.reaction[reaction]
            if color then
                return unpack(color)
            end
        end
    end
    
    return 1, 1, 1
end

-- Create font string
function Utils:CreateFontString(parent, font, size, outline)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(font or private.Fonts.normal, size or 12, outline or "OUTLINE")
    fs:SetShadowOffset(1, -1)
    fs:SetShadowColor(0, 0, 0, 1)
    return fs
end

-- Create texture
function Utils:CreateTexture(parent, layer, sublayer)
    local texture = parent:CreateTexture(nil, layer or "ARTWORK", nil, sublayer or 0)
    return texture
end

-- Shorten text
function Utils:ShortenText(text, maxLength)
    if not text then return "" end
    if #text > maxLength then
        return text:sub(1, maxLength - 3) .. "..."
    end
    return text
end

-- RGB to Hex
function Utils:RGBToHex(r, g, b)
    return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

-- Fade in animation
function Utils:FadeIn(frame, duration)
    UIFrameFadeIn(frame, duration or 0.3, frame:GetAlpha(), 1)
end

-- Fade out animation
function Utils:FadeOut(frame, duration)
    UIFrameFadeOut(frame, duration or 0.3, frame:GetAlpha(), 0)
end

-- Position frame
function Utils:SetPoint(frame, point, relativeFrame, relativePoint, x, y)
    frame:ClearAllPoints()
    frame:SetPoint(point, relativeFrame, relativePoint, x or 0, y or 0)
end

-- Lock/Unlock frame
function Utils:LockFrame(frame)
    frame:EnableMouse(false)
    frame:SetMovable(false)
end

function Utils:UnlockFrame(frame)
    frame:EnableMouse(true)
    frame:SetMovable(true)
end

-- Make frame movable
function Utils:MakeMovable(frame)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
end

-- Get pixel scale
function Utils:GetPixelScale()
    local scale = 768 / string.match(GetCVar("gxResolution"), "%d+x(%d+)")
    return scale
end

-- Apply pixel perfect scale
function Utils:SetPixelScale(frame, scale)
    scale = scale or 1
    local pixelScale = self:GetPixelScale()
    frame:SetScale(pixelScale * scale)
end
