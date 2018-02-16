-- 原作者：Nevo 邮箱地址 : Neavo7@gmail.com
-- 修改者 五区-塞拉摩-Leyvaten 插件更新地址 http://nga.178.com/read.php?tid=9633520
-- 感谢 NGA@雪白的黑牛 添加和制作，装备图标和装等显示，以及进入频道和离开按钮，以及部分代码优化。

-- ChatBar = LibStub("AceAddon-3.0"):NewAddon("ChatBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

--[[=========================== 基本设置区域 ==========================]]
-- 频道选择条位置瞄点
local ChatBarOffsetX = 0 -- 相对于默认位置的X坐标
local ChatBarOffsetY = 0 -- 相对于默认位置的Y坐标

-- 输入框位置调整
local UseTopInput = false -- 启用上方聊天框
--[[=============================== END ==============================]]

local chatFrame = SELECTED_DOCK_FRAME -- 聊天框架
local inputbox = chatFrame.editBox -- 输入框

COLORSCHEME_BORDER = {0.3, 0.3, 0.3, 1} -- 边框颜色

-- 主框架初始化
local chat = CreateFrame("Frame", "chat", UIParent)
chat:SetWidth(300) -- 主框体宽度
chat:SetHeight(23) -- 主框体高度
chat:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", ChatBarOffsetX, ChatBarOffsetY - 30)

-- 上方输入框
if UseTopInput then
    inputbox:ClearAllPoints()
    inputbox:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", 0, 20)
    inputbox:SetPoint("BOTTOMRIGHT", chatFrame, "TOPRIGHT", 0, 20)
    chat:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", ChatBarOffsetX, ChatBarOffsetY - 15)
end

function ChannelSay_OnClick()
    ChatFrame_OpenChat("/s ", chatFrame)
end

function ChannelYell_OnClick()
    ChatFrame_OpenChat("/y ", chatFrame)
end

function ChannelParty_OnClick()
    ChatFrame_OpenChat("/p ", chatFrame)
end

function ChannelGuild_OnClick()
    ChatFrame_OpenChat("/g ", chatFrame)
end

function ChannelRaid_OnClick()
    ChatFrame_OpenChat("/raid ", chatFrame)
end

function ChannelBG_OnClick()
    ChatFrame_OpenChat("/bg ", chatFrame)
end

function ChatEmote_OnClick()
    ToggleEmoteTable()
end

function Channel01_OnClick()
    ChatFrame_OpenChat("/1 ", chatFrame)
end

function ChannelWorld_OnClick(self, button)
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
        ChatFrame_OpenChat("/" .. channel .. " ", chatFrame)
    end
end

function Roll_OnClick()
    RandomRoll(1, 100)
end

function Report_OnClick()
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
    {name = "chn01", text = "综", color = {0.82, 0.70, 0.55}, callback = Channel01_OnClick},
    {name = "world", text = "世", color = {0.78, 1.00, 0.59}, callback = ChannelWorld_OnClick},
    {name = "emote", text = "表", color = {1.00, 0.50, 1.00}, callback = ChatEmote_OnClick},
    {name = "roll", text = "骰", color = {1.00, 1.00, 0.00}, callback = Roll_OnClick},
    {name = "report", text = "报", color = {0.80, 0.30, 0.30}, callback = Report_OnClick}
}

function CreateChannelButton(data, index)
    local frame = CreateFrame("Button", "frameName", chat)
    frame:SetWidth(23) -- 按钮宽度
    frame:SetHeight(23) -- 按钮高度
    frame:SetPoint("LEFT", chat, "LEFT", 10 + (index - 1) * 30, 0) -- 锚点
    frame:RegisterForClicks("AnyUp")
    frame:SetScript("OnClick", data.callback)
    frameText = frame:CreateFontString(data.name .. "Text", "OVERLAY")
    frameText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE") -- 字体设置
    frameText:SetJustifyH("CENTER")
    frameText:SetWidth(25)
    frameText:SetHeight(25)
    frameText:SetText(data.text) -- 显示的文字
    frameText:SetPoint("CENTER", 0, 0)
    frameText:SetTextColor(data.color[1], data.color[2], data.color[3]) -- 文字按钮的颜色
end

for i = 1, #ChannelButtons do -- 对非战斗记录聊天框的信息进行处理
    local button = ChannelButtons[i]
    CreateChannelButton(button, i)
end

-- function ChatBar:ChatEdit_UpdateHeader(editBox)
--     local type = editBox:GetAttribute("chatType")
--     if (type) then
--         local header = _G[editBox:GetName() .. "Header"]
--         local headerText = header and header:GetText()
--         if (headerText) then
--             if headerText:find("大脚世界频道") then
--                 header:SetText(string.gsub(headerText, "大脚世界频道", "世"))
--             else
--                 return
--             end
--             editBox:SetTextInsets(15 + header:GetWidth(), 13, 0, 0)
--         end
--     end
-- end

-- function ChatBar:OnInitialize()
--     -- print("ChatBar Loaded")
--     -- Called when the addon is loaded
-- end

-- function ChatBar:OnEnable()
--     self:SecureHook("ChatEdit_UpdateHeader")
--     -- Called when the addon is enabled
-- end

-- function ChatBar:OnDisable()
--     -- Called when the addon is disabled
-- end
