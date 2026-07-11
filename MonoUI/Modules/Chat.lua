--[[
    MonoUI - Chat Module
    Custom chat frame styling and positioning
]]--

local ADDON_NAME, private = ...
local MonoUI = private.MonoUI
local Utils = private.Utils

local Chat = {}
MonoUI:RegisterModule("Chat", Chat)

function Chat:Enable()
    if not MonoUI.db.profile.chat.enabled then return end
    
    for i = 1, NUM_CHAT_WINDOWS do
        self:StyleChatFrame(_G["ChatFrame" .. i])
    end
    
    self:PositionChatFrames()
    self:SetupChatTabs()
end

function Chat:Disable()
    -- Restore defaults (not implemented)
end

function Chat:Update()
    for i = 1, NUM_CHAT_WINDOWS do
        self:StyleChatFrame(_G["ChatFrame" .. i])
    end
end

function Chat:StyleChatFrame(frame)
    if not frame then return end
    
    local name = frame:GetName()
    local fontSize = MonoUI.db.profile.chat.fontSize
    
    -- Set font
    frame:SetFont(private.Fonts.normal, fontSize, "OUTLINE")
    frame:SetShadowOffset(1, -1)
    frame:SetShadowColor(0, 0, 0, 1)
    
    -- Set fading
    frame:SetFading(true)
    frame:SetTimeVisible(MonoUI.db.profile.chat.fadeTime)
    frame:SetFadeDuration(3)
    
    -- Remove textures
    for i = 1, #CHAT_FRAME_TEXTURES do
        local texture = _G[name .. CHAT_FRAME_TEXTURES[i]]
        if texture then
            texture:SetTexture(nil)
        end
    end
    
    -- Remove buttons
    if _G[name .. "ButtonFrame"] then
        _G[name .. "ButtonFrame"]:Hide()
    end
    
    -- Edit box
    local editBox = _G[name .. "EditBox"]
    if editBox then
        editBox:ClearAllPoints()
        editBox:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 5)
        editBox:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 5)
        
        -- Style edit box
        if not editBox.backdrop then
            Utils:CreateBackdrop(editBox, 2)
        end
        
        -- Remove textures
        for i = 1, #CHAT_FRAME_TEXTURES do
            local texture = _G[name .. "EditBox" .. CHAT_FRAME_TEXTURES[i]]
            if texture then
                texture:SetTexture(nil)
            end
        end
    end
    
    -- Create backdrop
    if not frame.backdrop then
        local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
        backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -5, 5)
        backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, -5)
        backdrop:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        backdrop:SetBackdropColor(0, 0, 0, 0.6)
        backdrop:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
        backdrop:SetFrameLevel(frame:GetFrameLevel())
        frame.backdrop = backdrop
    end
end

function Chat:PositionChatFrames()
    local width = MonoUI.db.profile.chat.width
    local height = MonoUI.db.profile.chat.height
    
    -- Main chat frame (ChatFrame1)
    local cf1 = ChatFrame1
    cf1:ClearAllPoints()
    cf1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 20, 20)
    cf1:SetSize(width, height)
    cf1:SetUserPlaced(true)
    FCF_SavePositionAndDimensions(cf1)
    
    -- Combat log (ChatFrame2)
    if ChatFrame2 then
        ChatFrame2:ClearAllPoints()
        ChatFrame2:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -20, 20)
        ChatFrame2:SetSize(width, height)
        ChatFrame2:SetUserPlaced(true)
        FCF_SavePositionAndDimensions(ChatFrame2)
    end
end

function Chat:SetupChatTabs()
    for i = 1, NUM_CHAT_WINDOWS do
        local tab = _G["ChatFrame" .. i .. "Tab"]
        if tab then
            -- Style tab
            tab:SetAlpha(0.5)
            
            -- Font
            local text = _G["ChatFrame" .. i .. "TabText"]
            if text then
                text:SetFont(private.Fonts.normal, 11, "OUTLINE")
                text:SetShadowOffset(1, -1)
            end
            
            -- Remove textures
            local left = _G["ChatFrame" .. i .. "TabLeft"]
            local middle = _G["ChatFrame" .. i .. "TabMiddle"]
            local right = _G["ChatFrame" .. i .. "TabRight"]
            
            if left then left:SetTexture(nil) end
            if middle then middle:SetTexture(nil) end
            if right then right:SetTexture(nil) end
            
            -- Hover
            tab:HookScript("OnEnter", function(self)
                self:SetAlpha(1)
            end)
            
            tab:HookScript("OnLeave", function(self)
                if self:GetID() == SELECTED_CHAT_FRAME:GetID() then
                    self:SetAlpha(1)
                else
                    self:SetAlpha(0.5)
                end
            end)
        end
    end
end

-- Copy chat button
local copyButton = CreateFrame("Button", "MonoUI_CopyChatButton", UIParent)
copyButton:SetSize(60, 20)
copyButton:SetPoint("TOPRIGHT", ChatFrame1, "TOPRIGHT", 0, 20)
copyButton:SetText("Copy")
copyButton:SetNormalFontObject("GameFontNormal")

copyButton:SetScript("OnClick", function()
    -- Create copy frame
    if not MonoUI_CopyChatFrame then
        local frame = CreateFrame("Frame", "MonoUI_CopyChatFrame", UIParent, "BackdropTemplate")
        frame:SetSize(500, 300)
        frame:SetPoint("CENTER")
        frame:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 2,
        })
        frame:SetBackdropColor(0, 0, 0, 0.9)
        frame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
        frame:SetFrameStrata("DIALOG")
        frame:EnableMouse(true)
        frame:SetMovable(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
        
        -- Title
        local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", 0, -10)
        title:SetText("Copy Chat")
        
        -- Edit box
        local editBox = CreateFrame("EditBox", nil, frame)
        editBox:SetMultiLine(true)
        editBox:SetMaxLetters(0)
        editBox:EnableMouse(true)
        editBox:SetAutoFocus(true)
        editBox:SetFont(private.Fonts.normal, 11)
        editBox:SetSize(480, 240)
        editBox:SetPoint("TOP", title, "BOTTOM", 0, -10)
        editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
        frame.editBox = editBox
        
        -- Scroll frame
        local scroll = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 10, -10)
        scroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 40)
        scroll:SetScrollChild(editBox)
        
        -- Close button
        local close = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        close:SetSize(80, 22)
        close:SetPoint("BOTTOM", 0, 10)
        close:SetText("Close")
        close:SetScript("OnClick", function() frame:Hide() end)
    end
    
    -- Copy chat text
    local text = ""
    for i = 1, ChatFrame1:GetNumMessages() do
        text = text .. ChatFrame1:GetMessageInfo(i) .. "\n"
    end
    
    MonoUI_CopyChatFrame.editBox:SetText(text)
    MonoUI_CopyChatFrame.editBox:HighlightText()
    MonoUI_CopyChatFrame:Show()
end)

Utils:CreateBackdrop(copyButton, 2)
