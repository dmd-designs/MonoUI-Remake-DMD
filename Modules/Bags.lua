--[[
    MonoUI - Bags Module
    Unified bag interface
]]--

local ADDON_NAME, private = ...
local MonoUI = private.MonoUI
local Utils = private.Utils

local Bags = {}
MonoUI:RegisterModule("Bags", Bags)

local bagFrame, bankFrame

function Bags:Enable()
    if not MonoUI.db.profile.bags.enabled then return end
    
    self:CreateBagFrame()
    self:CreateBankFrame()
    
    -- Hook bag toggles
    self:HookBagToggles()
end

function Bags:Disable()
    if bagFrame then bagFrame:Hide() end
    if bankFrame then bankFrame:Hide() end
end

function Bags:Update()
    if bagFrame then
        self:UpdateBag()
    end
end

function Bags:HookBagToggles()
    -- Hook the bag toggle
    hooksecurefunc("ToggleAllBags", function()
        if bagFrame then
            if bagFrame:IsShown() then
                bagFrame:Hide()
            else
                bagFrame:Show()
                self:UpdateBag()
            end
        end
    end)
    
    hooksecurefunc("ToggleBag", function(id)
        if bagFrame then
            if bagFrame:IsShown() then
                bagFrame:Hide()
            else
                bagFrame:Show()
                self:UpdateBag()
            end
        end
    end)
end

function Bags:CreateBagFrame()
    local frame = CreateFrame("Frame", "MonoUI_BagFrame", UIParent)
    frame:SetSize(400, 500)
    frame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -100, -100)
    frame:SetFrameStrata("HIGH")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()
    
    Utils:CreateBackdrop(frame, 4)
    
    -- Title
    local title = Utils:CreateFontString(frame, private.Fonts.normal, 14)
    title:SetPoint("TOP", 0, -10)
    title:SetText("Bags")
    frame.title = title
    
    -- Close button
    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -2, -2)
    close:SetScript("OnClick", function() frame:Hide() end)
    
    -- Container for bag slots
    local container = CreateFrame("Frame", nil, frame)
    container:SetPoint("TOPLEFT", 10, -40)
    container:SetPoint("BOTTOMRIGHT", -10, 40)
    frame.container = container
    
    -- Gold display
    local gold = Utils:CreateFontString(frame, private.Fonts.normal, 12)
    gold:SetPoint("BOTTOMLEFT", 10, 10)
    frame.gold = gold
    
    -- Bag slots display
    local slots = Utils:CreateFontString(frame, private.Fonts.normal, 12)
    slots:SetPoint("BOTTOM", 0, 10)
    frame.slots = slots
    
    bagFrame = frame
    
    -- Register events
    frame:RegisterEvent("BAG_UPDATE")
    frame:RegisterEvent("PLAYER_MONEY")
    frame:SetScript("OnEvent", function(self, event)
        if event == "BAG_UPDATE" or event == "PLAYER_MONEY" then
            Bags:UpdateBag()
        end
    end)
end

function Bags:CreateBankFrame()
    local frame = CreateFrame("Frame", "MonoUI_BankFrame", UIParent)
    frame:SetSize(500, 600)
    frame:SetPoint("LEFT", UIParent, "LEFT", 100, 0)
    frame:SetFrameStrata("HIGH")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()
    
    Utils:CreateBackdrop(frame, 4)
    
    -- Title
    local title = Utils:CreateFontString(frame, private.Fonts.normal, 14)
    title:SetPoint("TOP", 0, -10)
    title:SetText("Bank")
    
    -- Close button
    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -2, -2)
    close:SetScript("OnClick", function() frame:Hide() end)
    
    bankFrame = frame
end

function Bags:UpdateBag()
    if not bagFrame or not bagFrame:IsShown() then return end
    
    -- Update gold
    local gold = GetMoney()
    local goldText = GetCoinTextureString(gold)
    bagFrame.gold:SetText(goldText)
    
    -- Calculate total and free slots
    local totalSlots = 0
    local freeSlots = 0
    
    for i = 0, NUM_BAG_SLOTS do
        local slots = C_Container.GetContainerNumSlots(i)
        if slots then
            totalSlots = totalSlots + slots
            freeSlots = freeSlots + C_Container.GetContainerNumFreeSlots(i)
        end
    end
    
    bagFrame.slots:SetFormattedText("Slots: %d / %d", totalSlots - freeSlots, totalSlots)
    
    -- Update bag items (simplified - full implementation would create item buttons)
    self:UpdateBagItems()
end

function Bags:UpdateBagItems()
    -- Clear existing items
    if bagFrame.items then
        for _, item in pairs(bagFrame.items) do
            item:Hide()
        end
    else
        bagFrame.items = {}
    end
    
    local spacing = MonoUI.db.profile.bags.spacing
    local buttonSize = 32
    local columns = 10
    local index = 0
    
    -- Iterate through all bags
    for bag = 0, NUM_BAG_SLOTS do
        local slots = C_Container.GetContainerNumSlots(bag)
        if slots then
            for slot = 1, slots do
                local info = C_Container.GetContainerItemInfo(bag, slot)
                
                -- Create or reuse button
                if not bagFrame.items[index + 1] then
                    local button = CreateFrame("ItemButton", "MonoUI_BagItem" .. (index + 1), bagFrame.container, "ContainerFrameItemButtonTemplate")
                    button:SetSize(buttonSize, buttonSize)
                    
                    local row = math.floor(index / columns)
                    local col = index % columns
                    
                    button:SetPoint("TOPLEFT", bagFrame.container, "TOPLEFT", 
                        col * (buttonSize + spacing), 
                        -row * (buttonSize + spacing))
                    
                    Utils:CreateBackdrop(button, 1)
                    bagFrame.items[index + 1] = button
                end
                
                local button = bagFrame.items[index + 1]
                button:SetID(slot)
                button:Show()
                
                -- Set the bag ID for the button
                button.bag = bag
                
                index = index + 1
            end
        end
    end
end

-- Search functionality
function Bags:CreateSearchBox()
    if not bagFrame then return end
    
    local search = CreateFrame("EditBox", "MonoUI_BagSearch", bagFrame)
    search:SetSize(200, 20)
    search:SetPoint("TOPRIGHT", bagFrame, "TOPRIGHT", -30, -10)
    search:SetFont(private.Fonts.normal, 11)
    search:SetAutoFocus(false)
    
    Utils:CreateBackdrop(search, 2)
    
    search:SetScript("OnTextChanged", function(self)
        local text = self:GetText():lower()
        Bags:FilterBagItems(text)
    end)
    
    search:SetScript("OnEscapePressed", function(self)
        self:SetText("")
        self:ClearFocus()
    end)
    
    -- Placeholder text
    local placeholder = search:CreateFontString(nil, "OVERLAY")
    placeholder:SetFont(private.Fonts.normal, 11)
    placeholder:SetPoint("LEFT", 5, 0)
    placeholder:SetTextColor(0.5, 0.5, 0.5)
    placeholder:SetText("Search...")
    
    search:HookScript("OnEditFocusGained", function() placeholder:Hide() end)
    search:HookScript("OnEditFocusLost", function(self)
        if self:GetText() == "" then
            placeholder:Show()
        end
    end)
end

function Bags:FilterBagItems(searchText)
    if not bagFrame or not bagFrame.items then return end
    
    for _, button in pairs(bagFrame.items) do
        if searchText == "" then
            button:SetAlpha(1)
        else
            local itemName = button.itemName or ""
            if itemName:lower():find(searchText) then
                button:SetAlpha(1)
            else
                button:SetAlpha(0.3)
            end
        end
    end
end
