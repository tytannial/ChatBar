-- 原作者：Nevo 邮箱地址 : Neavo7@gmail.com
-- 修改者 五区-塞拉摩-Leyvaten 插件更新地址 http://nga.178.com/read.php?tid=9633520
-- 感谢NGA “雪白的黑牛” 添加和制作 装备图标和装等显示 以及进入频道和离开按钮 以及部分代码优化

--[[============================== 基本设置区域 ==========================]] --

-- 频道选择条位置瞄点
local ChatBarOffsetX = -160 -- 相对于默认位置的X坐标
local ChatBarOffsetY = -30 -- 相对于默认位置的Y坐标

-- 输入框位置调整
local UseTopInput = false -- 启用上方聊天框
 --

--[[=============================== END ==============================]] -- Nevo_Chatbar主框体 --
local chatFrame = SELECTED_DOCK_FRAME -- 聊天框架
local inputbox = chatFrame.editBox -- 输入框

COLORSCHEME_BORDER = {0.3, 0.3, 0.3, 1} -- 边框颜色

local chat = CreateFrame("Frame", "chat", UIParent)
chat:SetWidth(300) -- 主框体宽度
chat:SetHeight(20) -- 主框体高度
chat:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", ChatBarOffsetX, ChatBarOffsetY)

if UseTopInput then
    inputbox:ClearAllPoints()
    inputbox:SetPoint("BOTTOMLEFT", chatFrame, "TOPLEFT", 0, 20)
    inputbox:SetPoint("BOTTOMRIGHT", chatFrame, "TOPRIGHT", 0, 20)
    chat:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", ChatBarOffsetX, ChatBarOffsetY + 30)
end

-- "说(/s)" --
local ChannelSay = CreateFrame("Button", "ChannelSay", chat)
ChannelSay:SetWidth(23) -- 按钮宽度
ChannelSay:SetHeight(23) -- 按钮高度
ChannelSay:SetPoint("TOP", chat, "TOP", 10, 0) -- 锚点
ChannelSay:RegisterForClicks("AnyUp")
ChannelSay:SetScript(
    "OnClick",
    function()
        ChannelSay_OnClick()
    end
)

ChannelSayText = ChannelSay:CreateFontString("ChannelSayText", "OVERLAY")
ChannelSayText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE") -- 字体设置
ChannelSayText:SetJustifyH("CENTER")
ChannelSayText:SetWidth(25)
ChannelSayText:SetHeight(25)
ChannelSayText:SetText("说") -- 显示的文字
ChannelSayText:SetPoint("CENTER", 0, 0)
ChannelSayText:SetTextColor(1, 1, 1) -- 文字按钮的颜色

function ChannelSay_OnClick()
    ChatFrame_OpenChat("/s ", chatFrame)
end

-- "喊(/y)" --
local ChannelYell = CreateFrame("Button", "ChannelYell", chat)
ChannelYell:SetWidth(23)
ChannelYell:SetHeight(23)
ChannelYell:SetPoint("TOP", chat, "TOP", 40, 0)
ChannelYell:RegisterForClicks("AnyUp")
ChannelYell:SetScript(
    "OnClick",
    function()
        ChannelYell_OnClick()
    end
)

ChannelYellText = ChannelYell:CreateFontString("ChannelYellText", "OVERLAY")
ChannelYellText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
ChannelYellText:SetJustifyH("CENTER")
ChannelYellText:SetWidth(25)
ChannelYellText:SetHeight(25)
ChannelYellText:SetText("喊")
ChannelYellText:SetPoint("CENTER", 0, 0)
ChannelYellText:SetTextColor(255 / 255, 64 / 255, 64 / 255)

function ChannelYell_OnClick()
    ChatFrame_OpenChat("/y ", chatFrame)
end

-- "队伍(/p)" --
local ChannelParty = CreateFrame("Button", "ChannelParty", chat)
ChannelParty:SetWidth(23)
ChannelParty:SetHeight(23)
ChannelParty:SetPoint("TOP", chat, "TOP", 70, 0)
ChannelParty:RegisterForClicks("AnyUp")
ChannelParty:SetScript(
    "OnClick",
    function()
        ChannelParty_OnClick()
    end
)

ChannelPartyText = ChannelParty:CreateFontString("ChannelPartyText", "OVERLAY")
ChannelPartyText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
ChannelPartyText:SetJustifyH("CENTER")
ChannelPartyText:SetWidth(25)
ChannelPartyText:SetHeight(25)
ChannelPartyText:SetText("队")
ChannelPartyText:SetPoint("CENTER", 0, 0)
ChannelPartyText:SetTextColor(170 / 255, 170 / 255, 255 / 255)

function ChannelParty_OnClick()
    ChatFrame_OpenChat("/p ", chatFrame)
end

-- "公会(/g)" --
local ChannelGuild = CreateFrame("Button", "ChannelGuild", chat)
ChannelGuild:SetWidth(23)
ChannelGuild:SetHeight(23)
ChannelGuild:SetPoint("TOP", chat, "TOP", 100, 0)
ChannelGuild:RegisterForClicks("AnyUp")
ChannelGuild:SetScript(
    "OnClick",
    function()
        ChannelGuild_OnClick()
    end
)

ChannelGuildText = ChannelGuild:CreateFontString("ChannelGuildText", "OVERLAY")
ChannelGuildText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
ChannelGuildText:SetJustifyH("CENTER")
ChannelGuildText:SetWidth(25)
ChannelGuildText:SetHeight(25)
ChannelGuildText:SetText("会")
ChannelGuildText:SetPoint("CENTER", 0, 0)
ChannelGuildText:SetTextColor(64 / 255, 255 / 255, 64 / 255)

function ChannelGuild_OnClick()
    ChatFrame_OpenChat("/g ", chatFrame)
end

-- "团队(/raid)" --
local ChannelRaid = CreateFrame("Button", "ChannelRaid", chat)
ChannelRaid:SetWidth(23)
ChannelRaid:SetHeight(23)
ChannelRaid:SetPoint("TOP", chat, "TOP", 130, 0)
ChannelRaid:RegisterForClicks("AnyUp")
ChannelRaid:SetScript(
    "OnClick",
    function()
        ChannelRaid_OnClick()
    end
)

ChannelRaidText = ChannelRaid:CreateFontString("ChannelRaidText", "OVERLAY")
ChannelRaidText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
ChannelRaidText:SetJustifyH("CENTER")
ChannelRaidText:SetWidth(25)
ChannelRaidText:SetHeight(25)
ChannelRaidText:SetText("团")
ChannelRaidText:SetPoint("CENTER", 0, 0)
ChannelRaidText:SetTextColor(255 / 255, 127 / 255, 0)

function ChannelRaid_OnClick()
    ChatFrame_OpenChat("/raid ", chatFrame)
end

-- "副本(/bg)" --
local ChannelBG = CreateFrame("Button", "ChannelBG", chat)
ChannelBG:SetWidth(23)
ChannelBG:SetHeight(23)
ChannelBG:SetPoint("TOP", chat, "TOP", 160, 0)
ChannelBG:RegisterForClicks("AnyUp")
ChannelBG:SetScript(
    "OnClick",
    function()
        ChannelBG_OnClick()
    end
)

ChannelBGText = ChannelBG:CreateFontString("ChannelBGText", "OVERLAY")
ChannelBGText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
ChannelBGText:SetJustifyH("CENTER")
ChannelBGText:SetWidth(25)
ChannelBGText:SetHeight(25)
ChannelBGText:SetText("副")
ChannelBGText:SetPoint("CENTER", 0, 0)
ChannelBGText:SetTextColor(255 / 255, 127 / 255, 0)

function ChannelBG_OnClick()
    ChatFrame_OpenChat("/bg ", chatFrame)
end

-- "综合频道(/1)" --
local Channel_01 = CreateFrame("Button", "Channel_01", chat)
Channel_01:SetWidth(23)
Channel_01:SetHeight(23)
Channel_01:SetPoint("TOP", chat, "TOP", 190, 0)
Channel_01:RegisterForClicks("AnyUp")
Channel_01:SetScript(
    "OnClick",
    function()
        Channel_01_OnClick()
    end
)

Channel_01Text = Channel_01:CreateFontString("Channel_01Text", "OVERLAY")
Channel_01Text:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
Channel_01Text:SetJustifyH("CENTER")
Channel_01Text:SetWidth(25)
Channel_01Text:SetHeight(25)
Channel_01Text:SetText("综")
Channel_01Text:SetPoint("CENTER", 0, 0)
Channel_01Text:SetTextColor(210 / 255, 180 / 255, 140 / 255)

function Channel_01_OnClick()
    ChatFrame_OpenChat("/1 ", chatFrame)
end

-- "大脚世界频道" --
local ChannelWorld = CreateFrame("Button", "ChannelWorld", chat)
ChannelWorld:SetWidth(23)
ChannelWorld:SetHeight(23)
ChannelWorld:SetPoint("TOP", chat, "TOP", 220, 0)
ChannelWorld:RegisterForClicks("AnyUp")
ChannelWorld:SetScript(
    "OnClick",
    function(self, button)
        ChannelWorld_OnClick(self, button)
    end
)

ChannelWorldText = ChannelWorld:CreateFontString("ChannelWorldText", "OVERLAY")
ChannelWorldText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
ChannelWorldText:SetJustifyH("CENTER")
ChannelWorldText:SetWidth(25)
ChannelWorldText:SetHeight(25)
ChannelWorldText:SetText("世")
ChannelWorldText:SetPoint("CENTER", 0, 0)
ChannelWorldText:SetTextColor(200 / 255, 255 / 255, 150 / 255)

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

-- "表情" --
local ChatEmote = CreateFrame("Button", "ChatEmote", chat)
ChatEmote:SetWidth(23)
ChatEmote:SetHeight(23)
ChatEmote:SetPoint("TOP", chat, "TOP", 250, 0)
ChatEmote:RegisterForClicks("AnyUp")
ChatEmote:SetScript(
    "OnClick",
    function()
        ChatEmote_OnClick()
    end
)

ChatEmoteText = ChatEmote:CreateFontString("ChatEmoteText", "OVERLAY")
ChatEmoteText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
ChatEmoteText:SetJustifyH("CENTER")
ChatEmoteText:SetWidth(25)
ChatEmoteText:SetHeight(25)
ChatEmoteText:SetText("表")
ChatEmoteText:SetPoint("CENTER", 0, 0)
ChatEmoteText:SetTextColor(255 / 255, 255 / 255, 0)

function ChatEmote_OnClick()
    ToggleEmoteTable()
end

-- Roll --
local roll = CreateFrame("Button", "rollMacro", UIParent, "SecureActionButtonTemplate")
roll:SetAttribute("*type*", "macro")
roll:SetAttribute("macrotext", "/roll")
roll:SetWidth(23)
roll:SetHeight(23)
roll:SetPoint("TOP", chat, "TOP", 280, 0)
rollText = roll:CreateFontString("rollText", "OVERLAY")
rollText:SetFont("fonts\\ARHei.ttf", 15, "OUTLINE")
rollText:SetJustifyH("CENTER")
rollText:SetWidth(25)
rollText:SetHeight(25)
rollText:SetText("骰")
rollText:SetPoint("CENTER", 0, 0)
rollText:SetTextColor(255 / 255, 255 / 255, 0 / 255)

-- 加入/离开大脚世界频道图标
local bf = CreateFrame("Frame", "bf", ChatFrame1)
local msg
bf:SetSize(23, 23) -- 大小
bf.t = bf:CreateTexture()
bf.t:SetAllPoints()
bf.t:SetTexture("Interface\\AddOns\\ChatBar\\icon\\icon.tga")
bf:SetAlpha(0.2)
bf:ClearAllPoints()
bf:SetPoint("TOP", chat, "TOP", 310, 0) --位置
bf:SetScript(
    "OnEnter",
    function(self)
        self:SetAlpha(1)
    end
)
bf:SetScript(
    "OnLeave",
    function(self)
        self:SetAlpha(0.2)
    end
)
bf:SetScript(
    "OnMouseUp",
    function(self)
        local channels = {GetChannelList()}
        local isInCustomChannel = false
        local customChannelName = "大脚世界频道"
        for i = 1, #channels do
            if channels[i] == customChannelName then
                isInCustomChannel = true
            end
        end
        if isInCustomChannel then
            msg = "\124cffff0000退出世界频道\124r"
            LeaveChannelByName(customChannelName)
        else
            JoinPermanentChannel(customChannelName, nil, 1)
            msg = "\124cff00ff00加入世界频道\124r"
            ChatFrame_AddChannel(ChatFrame1, customChannelName)
            ChatFrame_RemoveMessageGroup(ChatFrame1, "CHANNEL")
        end
        print(msg)
    end
)

local rules = {
    --!!不要改
    {pat = "|c%x+|HChatCopy|h.-|h|r", repl = ""},
    {pat = "|c%x%x%x%x%x%x%x%x(.-)|r", repl = "%1"},
    --左鍵
    {pat = "|Hchannel:.-|h.-|h", repl = "", button = "LeftButton"},
    {pat = "|Hplayer:.-|h.-|h" .. ":", repl = "", button = "LeftButton"},
    {pat = "|Hplayer:.-|h.-|h" .. "：", repl = "", button = "LeftButton"},
    {pat = "|HBNplayer:.-|h.-|h" .. ":", repl = "", button = "LeftButton"},
    {pat = "|HBNplayer:.-|h.-|h" .. "：", repl = "", button = "LeftButton"},
    --右鍵
    {pat = "|Hchannel:.-|h(.-)|h", repl = "%1", button = "RightButton"},
    {pat = "|Hplayer:.-|h(.-)|h", repl = "%1", button = "RightButton"},
    {pat = "|HBNplayer:.-|h(.-)|h", repl = "%1", button = "RightButton"},
    --!!不要改
    {pat = "|H.-|h(.-)|h", repl = "%1"},
    {pat = "|TInterface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|t", repl = "{rt%1}"},
    {pat = "|T.-|t", repl = ""},
    {pat = "^%s+", repl = ""}
}

--字符
local function clearMessage(msg, button)
    for _, rule in ipairs(rules) do
        if (not rule.button or rule.button == button) then
            msg = msg:gsub(rule.pat, rule.repl)
        end
    end
    return msg
end

--信息
local function showMessage(msg, button)
    local editBox = ChatEdit_ChooseBoxForSend()
    msg = clearMessage(msg, button)
    ChatEdit_ActivateChat(editBox)
    editBox:SetText(editBox:GetText() .. msg)
    editBox:HighlightText()
end

--信息
local function getMessage(...)
    local object
    for i = 1, select("#", ...) do
        object = select(i, ...)
        if (object:IsObjectType("FontString") and MouseIsOver(object)) then
            return object:GetText()
        end
    end
    return ""
end

--HACK
local _SetItemRef = SetItemRef

SetItemRef = function(link, text, button, chatFrame)
    if (link:sub(1, 8) == "ChatCopy") then
        local msg = getMessage(chatFrame.FontStringContainer:GetRegions())
        return showMessage(msg, button)
    end
    _SetItemRef(link, text, button, chatFrame)
end

--HACK
local function AddMessage(self, text, ...)
    if (type(text) ~= "string") then
        text = tostring(text)
    end
    text = format("|cff68ccef|HChatCopy|h%s|h|r %s", "+", text)
    self.OrigAddMessage(self, text, ...)
end

local chatFrame

for i = 1, NUM_CHAT_WINDOWS do
    chatFrame = _G["ChatFrame" .. i]
    if (chatFrame) then
        chatFrame.OrigAddMessage = chatFrame.AddMessage
        chatFrame.AddMessage = AddMessage
    end
end
