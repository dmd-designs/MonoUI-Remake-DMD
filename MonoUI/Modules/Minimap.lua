--[[
    MonoUI - Minimap Module
    Custom minimap styling and positioning
]]--

local ADDON_NAME, private = ...
local MonoUI = private.MonoUI
local Utils = private.Utils

local Minimap = {}
MonoUI:RegisterModule("Minimap", Minimap)

function Minimap:Enable()
    if not MonoUI.db.profile.minimap.enabled then return end
    
    self:StyleMinimap()
    self:PositionMinimap()
    self:CreateMinimapButtons()
end

function Minimap:Disable()
    -- Restore defaults (not implemented)
end

function Minimap:Update()
    self:StyleMinimap()
end

function Minimap:StyleMinimap()
    local size = MonoUI.db.profile.minimap.size
    
    -- Set size
    Minimap:SetSize(size, size)
    
    -- Square shape
    if MonoUI.db.profile.minimap.shape == "square" then
        Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")
    end
    
    -- Remove default border
    MinimapBorder:Hide()
    MinimapBorderTop:Hide()
    
    -- Hide zoom buttons
    if MonoUI.db.profile.minimap.hideZoomButtons then
        MinimapZoomIn:Hide()
        MinimapZoomOut:Hide()
    end
    
    -- Hide default tracking button
    MiniMapTracking:Hide()
    
    -- Create backdrop
    if not Minimap.backdrop then
        Utils:CreateBackdrop(Minimap, 2)
    end
    
    -- Clock
    if TimeManagerClockButton then
        TimeManagerClockButton:Hide()
    end
    
    -- Mail icon
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 2, 2)
    
    -- Instance difficulty
    MiniMapInstanceDifficulty:ClearAllPoints()
    MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 2, -2)
    
    -- LFG icon
    QueueStatusButton:ClearAllPoints()
    QueueStatusButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", -2, 2)
    
    -- Tracking icon
    if MiniMapTrackingFrame then
        MiniMapTrackingFrame:ClearAllPoints()
        MiniMapTrackingFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -2, -2)
    end
end

function Minimap:PositionMinimap()
    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -20)
    
    -- Make movable
    Utils:MakeMovable(Minimap)
end

function Minimap:CreateMinimapButtons()
    -- Create a container for minimap buttons
    local buttonFrame = CreateFrame("Frame", "MonoUI_MinimapButtons", Minimap)
    buttonFrame:SetSize(200, 30)
    buttonFrame:SetPoint("TOP", Minimap, "BOTTOM", 0, -5)
    
    -- Collect and organize minimap buttons
    local buttons = {}
    for i, child in ipairs({Minimap:GetChildren()}) do
        if child:IsObjectType("Button") and child:GetName() then
            table.insert(buttons, child)
        end
    end
    
    -- Position buttons in a row
    for i, button in ipairs(buttons) do
        button:SetParent(buttonFrame)
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("LEFT", buttonFrame, "LEFT", 0, 0)
        else
            button:SetPoint("LEFT", buttons[i-1], "RIGHT", 2, 0)
        end
        button:SetSize(24, 24)
    end
end

-- Mouse wheel zoom
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, delta)
    if delta > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)
