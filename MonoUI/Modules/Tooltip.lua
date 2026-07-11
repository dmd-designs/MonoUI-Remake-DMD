--[[
    MonoUI - Tooltip Module
    Enhanced tooltip with additional information
]]--

local ADDON_NAME, private = ...
local MonoUI = private.MonoUI
local Utils = private.Utils

local Tooltip = {}
MonoUI:RegisterModule("Tooltip", Tooltip)

function Tooltip:Enable()
    if not MonoUI.db.profile.tooltip.enabled then return end
    
    self:StyleTooltips()
    self:HookTooltips()
end

function Tooltip:Disable()
    -- Restore defaults (not implemented)
end

function Tooltip:Update()
    self:StyleTooltips()
end

function Tooltip:StyleTooltips()
    local tooltips = {
        GameTooltip,
        ItemRefTooltip,
        ShoppingTooltip1,
        ShoppingTooltip2,
        WorldMapTooltip,
        WorldMapCompareTooltip1,
        WorldMapCompareTooltip2,
    }
    
    for _, tooltip in pairs(tooltips) do
        if tooltip then
            self:StyleTooltip(tooltip)
        end
    end
end

function Tooltip:StyleTooltip(tooltip)
    if not tooltip or tooltip.MonoUIStyled then return end
    
    -- Set backdrop
    tooltip:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    })
    tooltip:SetBackdropColor(0, 0, 0, 0.9)
    tooltip:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
    
    tooltip.MonoUIStyled = true
end

function Tooltip:HookTooltips()
    -- Hook unit tooltips
    GameTooltip:HookScript("OnTooltipSetUnit", function(self)
        Tooltip:OnTooltipSetUnit(self)
    end)
    
    -- Hook item tooltips
    GameTooltip:HookScript("OnTooltipSetItem", function(self)
        Tooltip:OnTooltipSetItem(self)
    end)
    
    -- Anchor tooltip to cursor
    hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
        tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    end)
end

function Tooltip:OnTooltipSetUnit(tooltip)
    local _, unit = tooltip:GetUnit()
    if not unit then return end
    
    -- Get unit info
    local name, realm = UnitName(unit)
    local level = UnitLevel(unit)
    local race = UnitRace(unit)
    local class = UnitClass(unit)
    local guild, guildRank = GetGuildInfo(unit)
    
    -- Add realm to name if cross-realm
    if realm and realm ~= "" then
        GameTooltipTextLeft1:SetText(name .. " - " .. realm)
    end
    
    -- Color name by class
    local r, g, b = Utils:GetUnitColor(unit)
    GameTooltipTextLeft1:SetTextColor(r, g, b)
    
    -- Add target line
    if UnitExists(unit .. "target") then
        local targetName = UnitName(unit .. "target")
        tooltip:AddLine("Target: " .. targetName, 1, 1, 1)
    end
    
    -- Add guild info
    if guild and MonoUI.db.profile.tooltip.showSpecialization then
        tooltip:AddLine("<" .. guild .. ">", 0.25, 1, 0.25)
        if guildRank then
            tooltip:AddLine(guildRank, 0.5, 0.5, 0.5)
        end
    end
    
    -- Add specialization for players
    if UnitIsPlayer(unit) and MonoUI.db.profile.tooltip.showSpecialization then
        local specID = GetInspectSpecialization(unit)
        if specID and specID > 0 then
            local _, specName = GetSpecializationInfoByID(specID)
            if specName then
                tooltip:AddLine(specName, 1, 1, 1)
            end
        end
    end
    
    tooltip:Show()
end

function Tooltip:OnTooltipSetItem(tooltip)
    local _, link = tooltip:GetItem()
    if not link then return end
    
    -- Add item level
    if MonoUI.db.profile.tooltip.showItemLevel then
        local itemLevel = GetDetailedItemLevelInfo(link)
        if itemLevel and itemLevel > 0 then
            tooltip:AddLine("Item Level: " .. itemLevel, 1, 1, 1)
        end
    end
    
    -- Add item ID
    local itemID = tonumber(link:match("item:(%d+)"))
    if itemID then
        tooltip:AddLine("ID: " .. itemID, 0.5, 0.5, 0.5)
    end
    
    tooltip:Show()
end

-- Show/hide tooltip based on modifier key
function Tooltip:ModifierTooltip(show)
    if show then
        GameTooltip:Show()
    else
        GameTooltip:Hide()
    end
end

-- Format tooltip money
function Tooltip:FormatMoney(money)
    if not money or money == 0 then return "0" end
    
    local gold = floor(money / 10000)
    local silver = floor((money - (gold * 10000)) / 100)
    local copper = money % 100
    
    local str = ""
    if gold > 0 then
        str = str .. "|cffffd700" .. gold .. "g|r "
    end
    if silver > 0 then
        str = str .. "|cffc7c7cf" .. silver .. "s|r "
    end
    if copper > 0 or str == "" then
        str = str .. "|cffeda55f" .. copper .. "c|r"
    end
    
    return str
end
