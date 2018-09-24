--[[
	Chatbar.lua
        聊天条代码
    插件更新地址 http://nga.178.com/read.php?tid=9633520
--]]

--[[=========================== 变量区 ==========================]]
-- 是否可移动的标记
local IsMovable = false -- 没事干别动这个，你改成ture那么进入游戏后聊天条就是可以移动的
local Config = SimpleChat_Config
--[[=============================== END ==============================]]
local chatFrame = SELECTED_DOCK_FRAME -- 聊天框架
local inputbox = chatFrame.editBox -- 输入框

COLORSCHEME_BORDER = {0.3, 0.3, 0.3, 1}
-- 边框颜色

-- 主框架初始化
local ChatBar = CreateFrame("Frame", nil, UIParent)
SimpleChatBar = ChatBar

local function ChannelSay_OnClick()
    ChatFrame_OpenChat("/s " .. inputbox:GetText(), chatFrame)
end

local function ChannelYell_OnClick()
    ChatFrame_OpenChat("/y " .. inputbox:GetText(), chatFrame)
end

local function ChannelParty_OnClick()
    ChatFrame_OpenChat("/p " .. inputbox:GetText(), chatFrame)
end

local function ChannelGuild_OnClick()
    ChatFrame_OpenChat("/g " .. inputbox:GetText(), chatFrame)
end

local function ChannelRaid_OnClick()
    ChatFrame_OpenChat("/raid " .. inputbox:GetText(), chatFrame)
end

local function ChannelBG_OnClick()
    ChatFrame_OpenChat("/bg " .. inputbox:GetText(), chatFrame)
end

-- function Channel01_OnClick()
--     ChatFrame_OpenChat("/1 ", chatFrame)
-- end
local function ChatEmote_OnClick()
    ToggleEmoteTable()
end

local function ChannelWorld_OnClick(self, button)
    if button == "RightButton" then
        local _, channelName, _ = GetChannelName("大脚世界频道")
        if channelName == nil then
            JoinPermanentChannel("大脚世界频道", nil, 1, 1)
            ChatFrame_RemoveMessageGroup(chatFrame, "CHANNEL")
            ChatFrame_AddChannel(chatFrame, "大脚世界频道")
            print("|cffffe00a<|r|cffff7d0aSimpleChat|r|cffffe00a>|r |cff00d200已加入大脚世界频道|r")
        else
            LeaveChannelByName("大脚世界频道")
            print("|cffffe00a<|r|cffff7d0aSimpleChat|r|cffffe00a>|r |cffd20000已离开大脚世界频道|r")
        end
    else
        local channel, _, _ = GetChannelName("大脚世界频道")
        ChatFrame_OpenChat("/" .. channel .. " " .. inputbox:GetText(), chatFrame)
    end
end

local function Roll_OnClick()
    RandomRoll(1, 100)
end

local function Report_OnClick()
    print("我的属性：" .. StatReport())
    ChatEdit_ActivateChat(inputbox)
    inputbox:SetText(StatReport())
end

local function Movelock_OnClick(self, button)
    if button == "LeftButton" then
        if IsMovable then
            print("|cffffe00a<|r|cffff7d0aSimpleChat|r|cffffe00a>|r |cffd20000锁定聊天条|r")
            IsMovable = false
            ChatBar:SetBackdrop(nil)

            local point, relativeTo, relativePoint, xOfs, yOfs = ChatBar:GetPoint()

			if relativeTo then
				SimpleChatChrConfig = {
					Position = {point = point, relativeTo = relativeTo:GetName(), relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs}
				}
			else	
				SimpleChatChrConfig = {
					Position = {point = point, relativeTo = nil, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs}
				}
			end
        else
            print("|cffffe00a<|r|cffff7d0aSimpleChat|r|cffffe00a>|r |cff00d200解锁聊天条|r")
            IsMovable = true
            ChatBar:SetBackdrop(
                {
                    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
                    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
                    tile = true,
                    tileSize = 16,
                    edgeSize = 16,
                    insets = {left = 4, right = 4, top = 4, bottom = 4}
                }
            )
        end
        ChatBar:EnableMouse(IsMovable)
    elseif button == "MiddleButton" then
        if IsMovable == false then
            return
        end
        ChatBar:ClearAllPoints()
        if Config.UseVertical then
            if Config.UseTopChatbar then
                ChatBar:SetPoint("TOPRIGHT", "ChatFrame1", "TOPLEFT", Config.ChatBarOffsetX - 30, Config.ChatBarOffsetY + 25)
            else
                ChatBar:SetPoint("TOPLEFT", "ChatFrame1", "TOPRIGHT", Config.ChatBarOffsetX + 30, Config.ChatBarOffsetY + 25)
            end
        else
            if Config.UseTopChatbar then
                ChatBar:SetPoint("BOTTOMLEFT", "ChatFrame1", "TOPLEFT", Config.ChatBarOffsetX, Config.ChatBarOffsetY + 30)
            else
                ChatBar:SetPoint("TOPLEFT", "ChatFrame1", "BOTTOMLEFT", Config.ChatBarOffsetX, Config.ChatBarOffsetY - 30)
            end
        end
    end
end

local ChannelButtons = {
    {name = "say", text = "说", color = {1.00, 1.00, 1.00}, callback = ChannelSay_OnClick},
    {name = "yell", text = "喊", color = {1.00, 0.25, 0.25}, callback = ChannelYell_OnClick},
    {name = "party", text = "队", color = {0.66, 0.66, 1.00}, callback = ChannelParty_OnClick},
    {name = "guild", text = "会", color = {0.25, 1.00, 0.25}, callback = ChannelGuild_OnClick},
    {name = "raid", text = "团", color = {1.00, 0.50, 0.00}, callback = ChannelRaid_OnClick},
    {name = "LFT", text = "副", color = {1.00, 0.50, 0.00}, callback = ChannelBG_OnClick},
    -- {name = "chn01", text = "综", color = {0.82, 0.70, 0.55}, callback = Channel01_OnClick},
    {name = "world", text = "世", color = {0.78, 1.00, 0.59}, callback = ChannelWorld_OnClick},
    {name = "emote", text = "表", color = {1.00, 0.50, 1.00}, callback = ChatEmote_OnClick},
    {name = "roll", text = "骰", color = {1.00, 1.00, 0.00}, callback = Roll_OnClick},
    {name = "report", text = "报", color = {0.80, 0.30, 0.30}, callback = Report_OnClick},
    {name = "movelock", text = "锁", color = {0.20, 0.20, 0.80}, callback = Movelock_OnClick}
}

local function CreateChannelButton(data, index)
    local frame = CreateFrame("Button", "frameName", ChatBar)
    frame:SetWidth(22)
    -- 按钮宽度
    frame:SetHeight(22)
    -- 按钮高度
    frame:SetAlpha(Config.AlphaOnLeave)

    frame:SetScript(
        "OnEnter",
        function(self)
            self:SetAlpha(Config.AlphaOnEnter)
        end
    )
    frame:SetScript(
        "OnLeave",
        function(self)
            self:SetAlpha(Config.AlphaOnLeave)
        end
    )

    if Config.UseVertical then
        frame:SetPoint("TOP", ChatBar, "TOP", 0, (1 - index) * Config.DistanceVertical)
    else
        frame:SetPoint("LEFT", ChatBar, "LEFT", 10 + (index - 1) * Config.DistanceHorizontal, 0)
    end

    frame:RegisterForClicks("AnyUp")
    frame:SetScript("OnClick", data.callback)
    -- 显示的文字
    frameText = frame:CreateFontString(data.name .. "Text", "OVERLAY")
    -- 字体设置
    frameText:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE")

    frameText:SetJustifyH("CENTER")
    frameText:SetWidth(26)
    frameText:SetHeight(26)
    frameText:SetText(data.text)
    frameText:SetPoint("CENTER", 0, 0)

    -- 文字按钮的颜色
    frameText:SetTextColor(data.color[1], data.color[2], data.color[3])
end

function SimpleChat_InitChatBar()
    -- 使用竖直布局
    if Config.UseVertical then
        -- 主框体宽度
        ChatBar:SetWidth(30)
        -- 主框体高度
        ChatBar:SetHeight(#ChannelButtons * Config.DistanceVertical + 10)
    else
        -- 主框体宽度
        ChatBar:SetWidth(#ChannelButtons * Config.DistanceHorizontal + 10)
        -- 主框体高度
        ChatBar:SetHeight(30)
    end

    -- 上方聊天输入框
    if Config.UseTopInput then
        inputbox:ClearAllPoints()
        inputbox:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", 0, 20)
        inputbox:SetPoint("BOTTOMRIGHT", chatFrame, "TOPRIGHT", 0, 20)
    end

    -- 位置设定
    if SimpleChatChrConfig.Position == nil then
        if Config.UseVertical then
            if Config.UseTopChatbar then
                ChatBar:SetPoint("TOPRIGHT", "ChatFrame1", "TOPLEFT", Config.ChatBarOffsetX - 30, Config.ChatBarOffsetY + 25)
            else
                ChatBar:SetPoint("TOPLEFT", "ChatFrame1", "TOPRIGHT", Config.ChatBarOffsetX + 30, Config.ChatBarOffsetY + 25)
            end
        else
            if Config.UseTopChatbar then
                ChatBar:SetPoint("BOTTOMLEFT", "ChatFrame1", "TOPLEFT", Config.ChatBarOffsetX, Config.ChatBarOffsetY + 30)
            else
                ChatBar:SetPoint("TOPLEFT", "ChatFrame1", "BOTTOMLEFT", Config.ChatBarOffsetX, Config.ChatBarOffsetY - 30)
            end
        end
        print("|cffffe00a<|r|cffff7d0aSimpleChat|r|cffffe00a>|r 聊天条位置初始化完毕")
    else
        local point = SimpleChatChrConfig.Position.point
        local relativeTo = SimpleChatChrConfig.Position.relativeTo
        local relativePoint = SimpleChatChrConfig.Position.relativePoint
        local xOfs = SimpleChatChrConfig.Position.xOfs
        local yOfs = SimpleChatChrConfig.Position.yOfs
        ChatBar:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end

    ChatBar:SetMovable(true)
    ChatBar:RegisterForDrag("LeftButton")
    ChatBar:SetScript("OnDragStart", ChatBar.StartMoving)
    ChatBar:SetScript("OnDragStop", ChatBar.StopMovingOrSizing)

    for i = 1, #ChannelButtons do -- 对非战斗记录聊天框的信息进行处理
        CreateChannelButton(ChannelButtons[i], i)
    end
end
