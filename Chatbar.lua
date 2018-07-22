-- 原作者：Nevo 邮箱地址 : Neavo7@gmail.com
-- 修改者 五区-塞拉摩-Leyvaten 插件更新地址 http://nga.178.com/read.php?tid=9633520
-- 感谢 NGA@雪白的黑牛 添加和制作，装备图标和装等显示，以及进入频道和离开按钮，以及部分代码优化。
--
-- ChatBar = LibStub("AceAddon-3.0"):NewAddon("ChatBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
--
--[[=========================== 基本设置区域 ==========================]]
-- 频道选择条位置瞄点
local ChatBarOffsetX = 0 -- 相对于默认位置的X坐标偏移
local ChatBarOffsetY = 0 -- 相对于默认位置的Y坐标偏移

local AlphaOnEnter = 1.0 -- 鼠标移入按钮时的透明度
local AlphaOnLeave = 0.2 -- 鼠标移开时按钮的透明度

-- 输入框位置调整
local UseTopInput = false -- 启用上方聊天框/如果启用了竖直则为左右 false为下/右 true为上/左
local UseVertical = false -- 启用竖直聊天框
--[[=============================== END ==============================]]
local chatFrame = SELECTED_DOCK_FRAME -- 聊天框架
local inputbox = chatFrame.editBox -- 输入框

COLORSCHEME_BORDER = {0.3, 0.3, 0.3, 1}
-- 边框颜色

-- 主框架初始化
local chat = CreateFrame("Frame", "chat", UIParent)

if UseVertical then
    chat:SetWidth(30)
    -- 主框体宽度
    chat:SetHeight(250)
    -- 主框体高度
    if UseTopInput then
        chat:SetPoint("TOPRIGHT", chatFrame, "TOPLEFT", ChatBarOffsetX - 40, ChatBarOffsetY + 25)
    else
        chat:SetPoint("TOPLEFT", chatFrame, "TOPRIGHT", ChatBarOffsetX, ChatBarOffsetY + 25)
    end
else
    chat:SetWidth(300)
    -- 主框体宽度
    chat:SetHeight(23)
    -- 主框体高度
    -- 上方输入框
    if UseTopInput then
        inputbox:ClearAllPoints()
        inputbox:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", 0, 20)
        inputbox:SetPoint("BOTTOMRIGHT", chatFrame, "TOPRIGHT", 0, 20)
        chat:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", ChatBarOffsetX, ChatBarOffsetY - 15)
    else
        chat:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", ChatBarOffsetX, ChatBarOffsetY - 30)
    end
end

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
            print("|cff00d200已加入大脚世界频道|r")
        else
            LeaveChannelByName("大脚世界频道")
            print("|cffd20000已离开大脚世界频道|r")
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
    {name = "report", text = "报", color = {0.80, 0.30, 0.30}, callback = Report_OnClick}
}

local function CreateChannelButton(data, index)
    local frame = CreateFrame("Button", "frameName", chat)
    frame:SetWidth(23)
    -- 按钮宽度
    frame:SetHeight(23)
    -- 按钮高度
    self:SetAlpha(AlphaOnLeave)

    frame:SetScript(
        "OnEnter",
        function(self)
            self:SetAlpha(AlphaOnEnter)
        end
    )
    frame:SetScript(
        "OnLeave",
        function(self)
            self:SetAlpha(AlphaOnLeave)
        end
    )

    if UseVertical then
        -- 锚点 25为间距
        frame:SetPoint("TOP", chat, "TOP", 0, (1 - index) * 25)
    else
        -- 锚点 30为间距
        frame:SetPoint("LEFT", chat, "LEFT", 10 + (index - 1) * 30, 0)
    end

    frame:RegisterForClicks("AnyUp")
    frame:SetScript("OnClick", data.callback)
    frameText = frame:CreateFontString(data.name .. "Text", "OVERLAY")
    frameText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
    -- 字体设置
    frameText:SetJustifyH("CENTER")
    frameText:SetWidth(25)
    frameText:SetHeight(25)
    frameText:SetText(data.text)
    -- 显示的文字
    frameText:SetPoint("CENTER", 0, 0)
    frameText:SetTextColor(data.color[1], data.color[2], data.color[3])
    -- 文字按钮的颜色
end

for i = 1, #ChannelButtons do -- 对非战斗记录聊天框的信息进行处理
    CreateChannelButton(ChannelButtons[i], i)
end
