--[[
    MonoUI - Nameplates Module
    Custom nameplate styling
]]--

local ADDON_NAME, private = ...
local MonoUI = private.MonoUI
local Utils = private.Utils

local Nameplates = {}
MonoUI:RegisterModule("Nameplates", Nameplates)

function Nameplates:Enable()
    if not MonoUI.db.profile.nameplates.enabled then return end
    
    -- Use CVars to configure nameplates
    SetCVar("nameplateShowAll", 1)
    SetCVar("nameplateShowEnemies", 1)
    SetCVar("nameplateShowFriends", 1)
    
    -- Hook nameplate creation
    hooksecurefunc("CompactUnitFrame_UpdateAll", function(frame)
        self:StyleNameplate(frame)
    end)
    
    -- Register callback
    local function OnNameplateAdded(unit)
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
        if nameplate then
            self:StyleNameplate(nameplate.UnitFrame)
        end
    end
    
    local function OnNameplateRemoved(unit)
        -- Cleanup if needed
    end
    
    MonoUI:RegisterEvent("NAME_PLATE_UNIT_ADDED", function(_, unit)
        OnNameplateAdded(unit)
    end)
    
    MonoUI:RegisterEvent("NAME_PLATE_UNIT_REMOVED", function(_, unit)
        OnNameplateRemoved(unit)
    end)
end

function Nameplates:Disable()
    -- Restore defaults (not implemented)
end

function Nameplates:Update()
    -- Update all visible nameplates
    for _, nameplate in pairs(C_NamePlate.GetNamePlates()) do
        if nameplate.UnitFrame then
            self:StyleNameplate(nameplate.UnitFrame)
        end
    end
end

function Nameplates:StyleNameplate(frame)
    if not frame or frame.MonoUIStyled then return end
    
    local healthBar = frame.healthBar
    local castBar = frame.castBar
    local name = frame.name
    
    if healthBar then
        -- Health bar styling
        healthBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
        
        if not healthBar.backdrop then
            Utils:CreateBackdrop(healthBar, 1)
        end
        
        -- Health value text
        if MonoUI.db.profile.nameplates.showHealthValue then
            if not healthBar.value then
                healthBar.value = Utils:CreateFontString(healthBar, private.Fonts.number, 10)
                healthBar.value:SetPoint("RIGHT", healthBar, "RIGHT", -2, 0)
            end
            
            -- Update health text
            local health = UnitHealth(frame.unit)
            local maxHealth = UnitHealthMax(frame.unit)
            local healthPercent = (health / maxHealth) * 100
            
            healthBar.value:SetFormattedText("%.0f%%", healthPercent)
        end
    end
    
    if castBar and MonoUI.db.profile.nameplates.showCastbar then
        -- Cast bar styling
        castBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
        
        if not castBar.backdrop then
            Utils:CreateBackdrop(castBar, 1)
        end
        
        -- Cast bar text
        if castBar.Text then
            castBar.Text:SetFont(private.Fonts.normal, 10, "OUTLINE")
        end
        
        -- Cast bar icon
        if castBar.Icon then
            castBar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            if not castBar.Icon.backdrop then
                Utils:CreateBackdrop(castBar.Icon, 1)
            end
        end
    end
    
    if name then
        -- Name styling
        name:SetFont(private.Fonts.normal, 11, "OUTLINE")
        name:SetShadowOffset(1, -1)
    end
    
    frame.MonoUIStyled = true
end

function Nameplates:UpdateNameplateColor(frame)
    if not frame or not frame.unit then return end
    
    local healthBar = frame.healthBar
    if not healthBar then return end
    
    -- Get unit color based on reaction
    local r, g, b = Utils:GetUnitColor(frame.unit)
    healthBar:SetStatusBarColor(r, g, b)
end

-- Threat coloring
function Nameplates:UpdateThreatColor(frame)
    if not frame or not frame.unit then return end
    
    local healthBar = frame.healthBar
    if not healthBar then return end
    
    local status = UnitThreatSituation("player", frame.unit)
    
    if status and status > 0 then
        -- Color based on threat
        if status == 3 then
            -- High threat (tanking) - Red
            healthBar:SetStatusBarColor(1, 0, 0)
        elseif status == 2 then
            -- Medium threat - Orange
            healthBar:SetStatusBarColor(1, 0.5, 0)
        elseif status == 1 then
            -- Low threat - Yellow
            healthBar:SetStatusBarColor(1, 1, 0)
        end
    else
        -- No threat - use normal color
        self:UpdateNameplateColor(frame)
    end
end
