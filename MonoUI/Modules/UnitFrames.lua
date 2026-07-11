--[[
    MonoUI - Unit Frames Module
    Custom unit frames for player, target, pet, focus, etc.
]]--

local ADDON_NAME, private = ...
local MonoUI = private.MonoUI
local Utils = private.Utils

local UnitFrames = {}
MonoUI:RegisterModule("UnitFrames", UnitFrames)

-- Module variables
local frames = {}

function UnitFrames:Enable()
    if not MonoUI.db.profile.unitframes.enabled then return end
    
    -- Hide default frames
    self:HideBlizzardFrames()
    
    -- Create custom frames
    self:CreatePlayerFrame()
    self:CreateTargetFrame()
    self:CreatePetFrame()
    self:CreateFocusFrame()
    self:CreateTargetTargetFrame()
    
    -- Register events
    MonoUI:RegisterEvent("PLAYER_TARGET_CHANGED", function() self:UpdateTarget() end)
    MonoUI:RegisterEvent("PLAYER_FOCUS_CHANGED", function() self:UpdateFocus() end)
    MonoUI:RegisterEvent("UNIT_PET", function() self:UpdatePet() end)
end

function UnitFrames:Disable()
    -- Clean up frames
    for _, frame in pairs(frames) do
        frame:Hide()
    end
end

function UnitFrames:Update()
    self:UpdatePlayer()
    self:UpdateTarget()
    self:UpdatePet()
    self:UpdateFocus()
end

function UnitFrames:HideBlizzardFrames()
    -- Hide default Blizzard frames
    PlayerFrame:UnregisterAllEvents()
    PlayerFrame:Hide()
    PlayerFrame.Show = function() end
    
    TargetFrame:UnregisterAllEvents()
    TargetFrame:Hide()
    TargetFrame.Show = function() end
    
    if PetFrame then
        PetFrame:UnregisterAllEvents()
        PetFrame:Hide()
        PetFrame.Show = function() end
    end
    
    if FocusFrame then
        FocusFrame:UnregisterAllEvents()
        FocusFrame:Hide()
        FocusFrame.Show = function() end
    end
    
    if TargetFrameToT then
        TargetFrameToT:UnregisterAllEvents()
        TargetFrameToT:Hide()
        TargetFrameToT.Show = function() end
    end
end

function UnitFrames:CreateUnitFrame(unit, width, height)
    local frame = CreateFrame("Button", "MonoUI_" .. unit:gsub("^%l", string.upper) .. "Frame", UIParent, "SecureUnitButtonTemplate")
    frame:SetSize(width, height)
    frame.unit = unit
    frame:RegisterForClicks("AnyUp")
    frame:SetAttribute("*type1", "target")
    frame:SetAttribute("*type2", "togglemenu")
    frame:SetAttribute("unit", unit)
    
    -- Background
    Utils:CreateBackdrop(frame, 2)
    
    -- Health bar
    local health = CreateFrame("StatusBar", nil, frame)
    health:SetPoint("TOPLEFT", 2, -2)
    health:SetPoint("TOPRIGHT", -2, -2)
    health:SetHeight(height - 18)
    health:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
    health:SetStatusBarColor(0, 1, 0)
    frame.health = health
    
    -- Health background
    local healthBG = health:CreateTexture(nil, "BACKGROUND")
    healthBG:SetAllPoints(health)
    healthBG:SetColorTexture(0.1, 0.1, 0.1, 0.5)
    
    -- Health text
    local healthText = Utils:CreateFontString(health, private.Fonts.normal, 11)
    healthText:SetPoint("CENTER")
    frame.healthText = healthText
    
    -- Power bar
    local power = CreateFrame("StatusBar", nil, frame)
    power:SetPoint("BOTTOMLEFT", 2, 2)
    power:SetPoint("BOTTOMRIGHT", -2, 2)
    power:SetHeight(12)
    power:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
    power:SetStatusBarColor(0, 0.5, 1)
    frame.power = power
    
    -- Power background
    local powerBG = power:CreateTexture(nil, "BACKGROUND")
    powerBG:SetAllPoints(power)
    powerBG:SetColorTexture(0.1, 0.1, 0.1, 0.5)
    
    -- Name text
    local name = Utils:CreateFontString(frame, private.Fonts.normal, 12)
    name:SetPoint("BOTTOMLEFT", health, "TOPLEFT", 2, 2)
    name:SetJustifyH("LEFT")
    frame.name = name
    
    -- Level text
    local level = Utils:CreateFontString(frame, private.Fonts.normal, 10)
    level:SetPoint("BOTTOMRIGHT", health, "TOPRIGHT", -2, 2)
    level:SetJustifyH("RIGHT")
    frame.level = level
    
    -- Portrait (if enabled)
    if MonoUI.db.profile.unitframes.showPortrait then
        local portrait = CreateFrame("PlayerModel", nil, frame)
        portrait:SetSize(height - 4, height - 4)
        portrait:SetPoint("RIGHT", frame, "LEFT", -2, 0)
        Utils:CreateBackdrop(portrait, 2)
        frame.portrait = portrait
    end
    
    return frame
end

function UnitFrames:CreatePlayerFrame()
    local frame = self:CreateUnitFrame("player", 250, 60)
    frame:SetPoint("CENTER", UIParent, "CENTER", -300, -200)
    Utils:MakeMovable(frame)
    frames.player = frame
    
    -- Update function
    frame:SetScript("OnEvent", function(self, event, unit)
        if unit == "player" or not unit then
            UnitFrames:UpdateUnitFrame(self)
        end
    end)
    
    frame:RegisterEvent("UNIT_HEALTH")
    frame:RegisterEvent("UNIT_MAXHEALTH")
    frame:RegisterEvent("UNIT_POWER_UPDATE")
    frame:RegisterEvent("UNIT_MAXPOWER")
    frame:RegisterEvent("UNIT_LEVEL")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    
    self:UpdateUnitFrame(frame)
end

function UnitFrames:CreateTargetFrame()
    local frame = self:CreateUnitFrame("target", 250, 60)
    frame:SetPoint("CENTER", UIParent, "CENTER", 300, -200)
    Utils:MakeMovable(frame)
    frames.target = frame
    
    frame:SetScript("OnEvent", function(self, event, unit)
        if unit == "target" or not unit then
            UnitFrames:UpdateUnitFrame(self)
        end
    end)
    
    frame:RegisterEvent("UNIT_HEALTH")
    frame:RegisterEvent("UNIT_MAXHEALTH")
    frame:RegisterEvent("UNIT_POWER_UPDATE")
    frame:RegisterEvent("UNIT_MAXPOWER")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    
    self:UpdateUnitFrame(frame)
end

function UnitFrames:CreatePetFrame()
    local frame = self:CreateUnitFrame("pet", 150, 40)
    frame:SetPoint("TOPLEFT", frames.player, "BOTTOMLEFT", 0, -10)
    Utils:MakeMovable(frame)
    frames.pet = frame
    
    frame:SetScript("OnEvent", function(self, event, unit)
        if unit == "pet" or event == "UNIT_PET" or not unit then
            UnitFrames:UpdateUnitFrame(self)
        end
    end)
    
    frame:RegisterEvent("UNIT_HEALTH")
    frame:RegisterEvent("UNIT_MAXHEALTH")
    frame:RegisterEvent("UNIT_POWER_UPDATE")
    frame:RegisterEvent("UNIT_PET")
    
    self:UpdateUnitFrame(frame)
end

function UnitFrames:CreateFocusFrame()
    local frame = self:CreateUnitFrame("focus", 200, 50)
    frame:SetPoint("TOP", frames.target, "BOTTOM", 0, -10)
    Utils:MakeMovable(frame)
    frames.focus = frame
    
    frame:SetScript("OnEvent", function(self, event, unit)
        if unit == "focus" or event == "PLAYER_FOCUS_CHANGED" or not unit then
            UnitFrames:UpdateUnitFrame(self)
        end
    end)
    
    frame:RegisterEvent("UNIT_HEALTH")
    frame:RegisterEvent("UNIT_MAXHEALTH")
    frame:RegisterEvent("UNIT_POWER_UPDATE")
    frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
    
    self:UpdateUnitFrame(frame)
end

function UnitFrames:CreateTargetTargetFrame()
    local frame = self:CreateUnitFrame("targettarget", 120, 35)
    frame:SetPoint("TOPLEFT", frames.target, "TOPRIGHT", 5, 0)
    Utils:MakeMovable(frame)
    frames.targettarget = frame
    
    frame:SetScript("OnEvent", function(self, event, unit)
        UnitFrames:UpdateUnitFrame(self)
    end)
    
    frame:RegisterEvent("UNIT_HEALTH")
    frame:RegisterEvent("UNIT_MAXHEALTH")
    frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    
    self:UpdateUnitFrame(frame)
end

function UnitFrames:UpdateUnitFrame(frame)
    local unit = frame.unit
    
    if not UnitExists(unit) then
        frame:Hide()
        return
    end
    
    frame:Show()
    
    -- Update health
    local health = UnitHealth(unit)
    local maxHealth = UnitHealthMax(unit)
    frame.health:SetMinMaxValues(0, maxHealth)
    frame.health:SetValue(health)
    
    -- Update health color
    local r, g, b = Utils:GetUnitColor(unit)
    frame.health:SetStatusBarColor(r, g, b)
    
    -- Update health text
    local healthPercent = (health / maxHealth) * 100
    frame.healthText:SetFormattedText("%s / %s (%.0f%%)", 
        Utils:FormatNumber(health), 
        Utils:FormatNumber(maxHealth), 
        healthPercent)
    
    -- Update power
    local power = UnitPower(unit)
    local maxPower = UnitPowerMax(unit)
    frame.power:SetMinMaxValues(0, maxPower)
    frame.power:SetValue(power)
    
    -- Update power color
    local powerType = UnitPowerType(unit)
    local pr, pg, pb = private:GetPowerColor(powerType)
    frame.power:SetStatusBarColor(pr, pg, pb)
    
    -- Update name
    local name = UnitName(unit)
    frame.name:SetText(name or "Unknown")
    frame.name:SetTextColor(r, g, b)
    
    -- Update level
    local level = UnitLevel(unit)
    if level == -1 then
        level = "??"
    end
    local classification = UnitClassification(unit)
    local classificationText = ""
    if classification == "elite" then
        classificationText = "+"
    elseif classification == "rareelite" then
        classificationText = "+R"
    elseif classification == "rare" then
        classificationText = "R"
    elseif classification == "worldboss" then
        classificationText = "Boss"
    end
    frame.level:SetText(level .. classificationText)
    
    -- Update portrait
    if frame.portrait and UnitIsVisible(unit) then
        frame.portrait:SetUnit(unit)
        frame.portrait:SetCamera(0)
    end
end

function UnitFrames:UpdatePlayer()
    if frames.player then
        self:UpdateUnitFrame(frames.player)
    end
end

function UnitFrames:UpdateTarget()
    if frames.target then
        self:UpdateUnitFrame(frames.target)
    end
    if frames.targettarget then
        self:UpdateUnitFrame(frames.targettarget)
    end
end

function UnitFrames:UpdatePet()
    if frames.pet then
        self:UpdateUnitFrame(frames.pet)
    end
end

function UnitFrames:UpdateFocus()
    if frames.focus then
        self:UpdateUnitFrame(frames.focus)
    end
end
