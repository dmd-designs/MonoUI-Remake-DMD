--[[
    MonoUI - Action Bars Module
    Custom action bars with modern styling
]]--

local ADDON_NAME, private = ...
local MonoUI = private.MonoUI
local Utils = private.Utils

local ActionBars = {}
MonoUI:RegisterModule("ActionBars", ActionBars)

local bars = {}
local NUM_ACTIONBAR_BUTTONS = 12

function ActionBars:Enable()
    if not MonoUI.db.profile.actionbars.enabled then return end
    
    -- Hide default action bars
    self:HideBlizzardBars()
    
    -- Create custom bars
    for i = 1, MonoUI.db.profile.actionbars.numBars do
        self:CreateActionBar(i)
    end
    
    -- Position bars
    self:PositionBars()
    
    -- Update buttons
    self:UpdateAllButtons()
end

function ActionBars:Disable()
    for _, bar in pairs(bars) do
        bar:Hide()
    end
end

function ActionBars:Update()
    self:UpdateAllButtons()
end

function ActionBars:HideBlizzardBars()
    -- Main action bar
    MainMenuBar:SetParent(UIParent)
    MainMenuBar:UnregisterAllEvents()
    MainMenuBar:Hide()
    MainMenuBar.Show = function() end
    
    -- Override bar
    OverrideActionBar:SetParent(UIParent)
    OverrideActionBar:UnregisterAllEvents()
    OverrideActionBar:Hide()
    
    -- Micro menu
    MicroButtonAndBagsBar:SetParent(UIParent)
    MicroButtonAndBagsBar:Hide()
    
    -- Status bars
    StatusTrackingBarManager:SetParent(UIParent)
    StatusTrackingBarManager:Hide()
    
    -- Pet bar
    if PetActionBarFrame then
        PetActionBarFrame:SetParent(UIParent)
        PetActionBarFrame:UnregisterAllEvents()
        PetActionBarFrame:Hide()
    end
    
    -- Stance bar
    if StanceBarFrame then
        StanceBarFrame:SetParent(UIParent)
        StanceBarFrame:UnregisterAllEvents()
        StanceBarFrame:Hide()
    end
end

function ActionBars:CreateActionBar(barID)
    local bar = CreateFrame("Frame", "MonoUI_ActionBar" .. barID, UIParent, "SecureHandlerStateTemplate")
    bar:SetSize(
        (MonoUI.db.profile.actionbars.buttonSize * NUM_ACTIONBAR_BUTTONS) + 
        (MonoUI.db.profile.actionbars.buttonSpacing * (NUM_ACTIONBAR_BUTTONS - 1)),
        MonoUI.db.profile.actionbars.buttonSize
    )
    
    bars[barID] = bar
    bar.buttons = {}
    
    -- Create buttons
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = self:CreateActionButton(bar, barID, i)
        bar.buttons[i] = button
    end
    
    return bar
end

function ActionBars:CreateActionButton(parent, barID, buttonID)
    local buttonName = "MonoUI_ActionButton" .. barID .. "_" .. buttonID
    local actionID = ((barID - 1) * NUM_ACTIONBAR_BUTTONS) + buttonID
    
    -- Use default action button as template
    local button = CreateFrame("CheckButton", buttonName, parent, "ActionBarButtonTemplate")
    button:SetSize(MonoUI.db.profile.actionbars.buttonSize, MonoUI.db.profile.actionbars.buttonSize)
    button:SetID(actionID)
    
    -- Position button
    if buttonID == 1 then
        button:SetPoint("LEFT", parent, "LEFT", 0, 0)
    else
        button:SetPoint("LEFT", parent.buttons[buttonID - 1], "RIGHT", MonoUI.db.profile.actionbars.buttonSpacing, 0)
    end
    
    -- Style button
    self:StyleActionButton(button)
    
    return button
end

function ActionBars:StyleActionButton(button)
    -- Remove default textures
    local name = button:GetName()
    
    -- Border
    if _G[name .. "Border"] then
        _G[name .. "Border"]:Hide()
    end
    
    -- Flash texture
    if _G[name .. "Flash"] then
        _G[name .. "Flash"]:SetTexture(nil)
    end
    
    -- Normal texture
    if button.NormalTexture then
        button.NormalTexture:SetTexture(nil)
        button.NormalTexture:Hide()
        button.NormalTexture.Show = function() end
    end
    
    -- Create custom backdrop
    if not button.backdrop then
        Utils:CreateBackdrop(button, 2)
    end
    
    -- Icon
    local icon = _G[name .. "Icon"]
    if icon then
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
        icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    end
    
    -- Cooldown
    local cooldown = _G[name .. "Cooldown"]
    if cooldown then
        cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
        cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    end
    
    -- Hotkey
    local hotkey = _G[name .. "HotKey"]
    if hotkey then
        hotkey:ClearAllPoints()
        hotkey:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, -2)
        hotkey:SetFont(private.Fonts.normal, 10, "OUTLINE")
        
        if not MonoUI.db.profile.actionbars.showHotkeys then
            hotkey:Hide()
        end
    end
    
    -- Count
    local count = _G[name .. "Count"]
    if count then
        count:ClearAllPoints()
        count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
        count:SetFont(private.Fonts.number, 11, "OUTLINE")
    end
    
    -- Macro name
    local macroName = _G[name .. "Name"]
    if macroName then
        macroName:ClearAllPoints()
        macroName:SetPoint("BOTTOM", button, "BOTTOM", 0, 2)
        macroName:SetFont(private.Fonts.normal, 9)
        
        if not MonoUI.db.profile.actionbars.showMacroNames then
            macroName:Hide()
        end
    end
end

function ActionBars:PositionBars()
    local spacing = 5
    
    -- Bar 1 - Main bar
    if bars[1] then
        bars[1]:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 50)
    end
    
    -- Bar 2 - Above main bar
    if bars[2] then
        bars[2]:SetPoint("BOTTOM", bars[1], "TOP", 0, spacing)
    end
    
    -- Bar 3 - Above bar 2
    if bars[3] then
        bars[3]:SetPoint("BOTTOM", bars[2], "TOP", 0, spacing)
    end
    
    -- Bar 4 - Right side
    if bars[4] then
        bars[4]:SetPoint("RIGHT", UIParent, "RIGHT", -50, 0)
    end
    
    -- Bar 5 - Right side (second column)
    if bars[5] then
        bars[5]:SetPoint("RIGHT", bars[4], "LEFT", -spacing, 0)
    end
    
    -- Bar 6 - Left side
    if bars[6] then
        bars[6]:SetPoint("LEFT", UIParent, "LEFT", 50, 0)
    end
end

function ActionBars:UpdateAllButtons()
    for barID, bar in pairs(bars) do
        for buttonID, button in pairs(bar.buttons) do
            self:UpdateButton(button)
        end
    end
end

function ActionBars:UpdateButton(button)
    -- Update is handled by Blizzard's action button code
    -- We just need to make sure our styling persists
    self:StyleActionButton(button)
end

-- Create pet bar
function ActionBars:CreatePetBar()
    local bar = CreateFrame("Frame", "MonoUI_PetBar", UIParent)
    bar:SetSize(
        (MonoUI.db.profile.actionbars.buttonSize * NUM_PET_ACTION_SLOTS) + 
        (MonoUI.db.profile.actionbars.buttonSpacing * (NUM_PET_ACTION_SLOTS - 1)),
        MonoUI.db.profile.actionbars.buttonSize
    )
    bar:SetPoint("BOTTOM", bars[1], "TOP", 0, 50)
    
    for i = 1, NUM_PET_ACTION_SLOTS do
        local button = _G["PetActionButton" .. i]
        if button then
            button:SetParent(bar)
            button:ClearAllPoints()
            
            if i == 1 then
                button:SetPoint("LEFT", bar, "LEFT", 0, 0)
            else
                button:SetPoint("LEFT", _G["PetActionButton" .. (i-1)], "RIGHT", MonoUI.db.profile.actionbars.buttonSpacing, 0)
            end
            
            self:StyleActionButton(button)
        end
    end
    
    bars.pet = bar
end

-- Create stance/shapeshift bar
function ActionBars:CreateStanceBar()
    local bar = CreateFrame("Frame", "MonoUI_StanceBar", UIParent)
    bar:SetSize(
        (MonoUI.db.profile.actionbars.buttonSize * NUM_STANCE_SLOTS) + 
        (MonoUI.db.profile.actionbars.buttonSpacing * (NUM_STANCE_SLOTS - 1)),
        MonoUI.db.profile.actionbars.buttonSize
    )
    bar:SetPoint("BOTTOMLEFT", bars[1], "TOPLEFT", 0, 5)
    
    for i = 1, NUM_STANCE_SLOTS do
        local button = _G["StanceButton" .. i]
        if button then
            button:SetParent(bar)
            button:ClearAllPoints()
            
            if i == 1 then
                button:SetPoint("LEFT", bar, "LEFT", 0, 0)
            else
                button:SetPoint("LEFT", _G["StanceButton" .. (i-1)], "RIGHT", MonoUI.db.profile.actionbars.buttonSpacing, 0)
            end
            
            self:StyleActionButton(button)
        end
    end
    
    bars.stance = bar
end
