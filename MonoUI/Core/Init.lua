--[[
    MonoUI - A comprehensive UI replacement
    Core Initialization
]]--

local ADDON_NAME, private = ...

-- Create main addon object
MonoUI = LibStub("AceAddon-3.0"):NewAddon("MonoUI", "AceConsole-3.0", "AceEvent-3.0")
local MonoUI = MonoUI

-- Version information
MonoUI.version = GetAddOnMetadata(ADDON_NAME, "Version")
MonoUI.modules = {}

-- Local reference to private namespace
private.MonoUI = MonoUI

function MonoUI:OnInitialize()
    -- Initialize database
    self.db = LibStub("AceDB-3.0"):New("MonoUIDB", self:GetDefaults(), true)
    
    -- Setup slash commands
    self:RegisterChatCommand("monoui", "SlashCommand")
    self:RegisterChatCommand("mui", "SlashCommand")
    
    -- Print welcome message
    self:Print(format("|cff00ff00MonoUI|r version |cffffffff%s|r loaded. Type |cffFFD700/monoui|r for options.", self.version))
end

function MonoUI:OnEnable()
    -- Enable all modules
    for name, module in pairs(self.modules) do
        if module.Enable then
            module:Enable()
        end
    end
    
    -- Register events
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld")
end

function MonoUI:OnDisable()
    -- Disable all modules
    for name, module in pairs(self.modules) do
        if module.Disable then
            module:Disable()
        end
    end
end

function MonoUI:OnPlayerEnteringWorld()
    -- Initialize UI elements after entering world
    self:UpdateAllModules()
end

function MonoUI:UpdateAllModules()
    for name, module in pairs(self.modules) do
        if module.Update then
            module:Update()
        end
    end
end

function MonoUI:SlashCommand(input)
    if not input or input:trim() == "" then
        self:ShowConfig()
    elseif input:lower() == "reset" then
        self.db:ResetDB()
        self:Print("Database reset to defaults.")
        ReloadUI()
    elseif input:lower() == "version" then
        self:Print(format("Version: |cffffffff%s|r", self.version))
    else
        self:Print("Commands:")
        self:Print("  |cffFFD700/monoui|r - Open configuration")
        self:Print("  |cffFFD700/monoui reset|r - Reset all settings")
        self:Print("  |cffFFD700/monoui version|r - Show version")
    end
end

function MonoUI:ShowConfig()
    self:Print("Configuration panel would open here. (Not yet implemented)")
end

function MonoUI:GetDefaults()
    return {
        profile = {
            general = {
                scale = 1.0,
                pixelPerfect = true,
            },
            unitframes = {
                enabled = true,
                showPortrait = true,
                showCastbar = true,
                healthColor = {0.0, 1.0, 0.0},
                powerColor = {0.0, 0.5, 1.0},
            },
            actionbars = {
                enabled = true,
                numBars = 6,
                buttonSize = 32,
                buttonSpacing = 2,
                showHotkeys = true,
                showMacroNames = true,
            },
            minimap = {
                enabled = true,
                size = 140,
                shape = "square",
                hideZoomButtons = true,
            },
            chat = {
                enabled = true,
                fontSize = 12,
                fadeTime = 120,
                width = 400,
                height = 150,
            },
            bags = {
                enabled = true,
                oneContainerBag = true,
                spacing = 2,
            },
            nameplates = {
                enabled = true,
                showHealthValue = true,
                showCastbar = true,
            },
            tooltip = {
                enabled = true,
                showItemLevel = true,
                showSpecialization = true,
            },
            buffs = {
                enabled = true,
                consolidate = true,
                size = 30,
            },
        },
    }
end

-- Register module function
function MonoUI:RegisterModule(name, module)
    self.modules[name] = module
end
