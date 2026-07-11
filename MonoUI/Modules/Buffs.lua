--[[
    MonoUI - Buffs Module
    Buff and debuff display
]]--

local ADDON_NAME, private = ...
local MonoUI = private.MonoUI
local Utils = private.Utils

local Buffs = {}
MonoUI:RegisterModule("Buffs", Buffs)

local buffFrame, debuffFrame

function Buffs:Enable()
    if not MonoUI.db.profile.buffs.enabled then return end
    
    self:CreateBuffFrame()
    self:CreateDebuffFrame()
    self:HideBlizzardBuffs()
    
    -- Register events
    MonoUI:RegisterEvent("UNIT_AURA", function(_, unit)
        if unit == "player" then
            Buffs:UpdateBuffs()
            Buffs:UpdateDebuffs()
        end
    end)
    
    self:UpdateBuffs()
    self:UpdateDebuffs()
end

function Buffs:Disable()
    if buffFrame then buffFrame:Hide() end
    if debuffFrame then debuffFrame:Hide() end
end

function Buffs:Update()
    self:UpdateBuffs()
    self:UpdateDebuffs()
end

function Buffs:HideBlizzardBuffs()
    -- Hide default buff frame
    BuffFrame:UnregisterAllEvents()
    BuffFrame:Hide()
    BuffFrame.Show = function() end
    
    -- Hide default debuff frame
    if DebuffFrame then
        DebuffFrame:UnregisterAllEvents()
        DebuffFrame:Hide()
        DebuffFrame.Show = function() end
    end
    
    -- Hide default temporary enchants
    if TemporaryEnchantFrame then
        TemporaryEnchantFrame:UnregisterAllEvents()
        TemporaryEnchantFrame:Hide()
        TemporaryEnchantFrame.Show = function() end
    end
end

function Buffs:CreateBuffFrame()
    local frame = CreateFrame("Frame", "MonoUI_BuffFrame", UIParent)
    frame:SetSize(400, 200)
    frame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -200, -20)
    
    frame.buttons = {}
    buffFrame = frame
end

function Buffs:CreateDebuffFrame()
    local frame = CreateFrame("Frame", "MonoUI_DebuffFrame", UIParent)
    frame:SetSize(400, 200)
    frame:SetPoint("TOP", buffFrame, "BOTTOM", 0, -5)
    
    frame.buttons = {}
    debuffFrame = frame
end

function Buffs:UpdateBuffs()
    if not buffFrame then return end
    
    local size = MonoUI.db.profile.buffs.size
    local spacing = 2
    local maxPerRow = 16
    local index = 0
    
    -- Iterate through buffs
    for i = 1, 40 do
        local aura = C_UnitAuras.GetBuffDataByIndex("player", i)
        if not aura then break end
        
        local button = self:GetOrCreateAuraButton(buffFrame, index + 1, "buff")
        self:UpdateAuraButton(button, aura, size)
        
        -- Position button
        local row = math.floor(index / maxPerRow)
        local col = index % maxPerRow
        
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", buffFrame, "TOPLEFT", 
            col * (size + spacing), 
            -row * (size + spacing))
        
        button:Show()
        index = index + 1
    end
    
    -- Hide unused buttons
    for i = index + 1, #buffFrame.buttons do
        buffFrame.buttons[i]:Hide()
    end
end

function Buffs:UpdateDebuffs()
    if not debuffFrame then return end
    
    local size = MonoUI.db.profile.buffs.size
    local spacing = 2
    local maxPerRow = 16
    local index = 0
    
    -- Iterate through debuffs
    for i = 1, 40 do
        local aura = C_UnitAuras.GetDebuffDataByIndex("player", i)
        if not aura then break end
        
        local button = self:GetOrCreateAuraButton(debuffFrame, index + 1, "debuff")
        self:UpdateAuraButton(button, aura, size)
        
        -- Position button
        local row = math.floor(index / maxPerRow)
        local col = index % maxPerRow
        
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", debuffFrame, "TOPLEFT", 
            col * (size + spacing), 
            -row * (size + spacing))
        
        button:Show()
        index = index + 1
    end
    
    -- Hide unused buttons
    for i = index + 1, #debuffFrame.buttons do
        debuffFrame.buttons[i]:Hide()
    end
end

function Buffs:GetOrCreateAuraButton(parent, index, auraType)
    if not parent.buttons[index] then
        local button = CreateFrame("Button", "MonoUI_" .. auraType:gsub("^%l", string.upper) .. "Button" .. index, parent)
        
        -- Background
        Utils:CreateBackdrop(button, 2)
        
        -- Icon
        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        button.icon = icon
        
        -- Count
        local count = Utils:CreateFontString(button, private.Fonts.number, 12)
        count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
        button.count = count
        
        -- Duration
        local duration = Utils:CreateFontString(button, private.Fonts.normal, 10)
        duration:SetPoint("TOP", button, "BOTTOM", 0, -2)
        button.duration = duration
        
        -- Cooldown frame
        local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
        cooldown:SetAllPoints(icon)
        cooldown:SetDrawEdge(false)
        button.cooldown = cooldown
        
        -- Border for debuff type
        local border = button:CreateTexture(nil, "OVERLAY")
        border:SetTexture("Interface\\Buttons\\WHITE8x8")
        border:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
        border:Hide()
        button.border = border
        
        -- Tooltip
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if self.auraInstanceID then
                GameTooltip:SetUnitBuffByAuraInstanceID("player", self.auraInstanceID)
            end
            GameTooltip:Show()
        end)
        
        button:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
        
        parent.buttons[index] = button
    end
    
    return parent.buttons[index]
end

function Buffs:UpdateAuraButton(button, auraData, size)
    button:SetSize(size, size)
    button.auraInstanceID = auraData.auraInstanceID
    
    -- Set icon
    button.icon:SetTexture(auraData.icon)
    
    -- Set count
    if auraData.applications and auraData.applications > 1 then
        button.count:SetText(auraData.applications)
        button.count:Show()
    else
        button.count:Hide()
    end
    
    -- Set duration
    if auraData.expirationTime and auraData.expirationTime > 0 then
        local remaining = auraData.expirationTime - GetTime()
        if remaining > 0 then
            button.duration:SetText(Utils:FormatTime(remaining))
            button.cooldown:SetCooldown(GetTime() - (auraData.duration - remaining), auraData.duration)
            button.cooldown:Show()
        else
            button.duration:SetText("")
            button.cooldown:Hide()
        end
    else
        button.duration:SetText("")
        button.cooldown:Hide()
    end
    
    -- Set border color for debuffs
    if auraData.dispelName then
        local color = DebuffTypeColor[auraData.dispelName] or {r = 0.8, g = 0, b = 0}
        button.border:SetVertexColor(color.r, color.g, color.b, 1)
        button.border:Show()
    else
        button.border:Hide()
    end
end

-- Consolidate buffs feature
function Buffs:ConsolidateBuffs()
    if not MonoUI.db.profile.buffs.consolidate then return end
    
    -- Create consolidate button
    if not buffFrame.consolidate then
        local button = CreateFrame("Button", "MonoUI_ConsolidateBuffs", buffFrame)
        button:SetSize(32, 32)
        button:SetPoint("TOPRIGHT", buffFrame, "TOPRIGHT", 0, 0)
        
        Utils:CreateBackdrop(button, 2)
        
        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        
        button:SetScript("OnClick", function(self)
            -- Toggle consolidated buffs
            if self.frame then
                if self.frame:IsShown() then
                    self.frame:Hide()
                else
                    self.frame:Show()
                end
            end
        end)
        
        buffFrame.consolidate = button
    end
end
