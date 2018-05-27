-- 修改者 五区-塞拉摩-Leyvaten 插件更新地址 http://nga.178.com/read.php?tid=9633520
--[[
配置选项
iconSize 表情大小你可以根据聊天字号调整
offsetX 标情况相当于输入框中心的X偏移
offsetY 标情况相当于输入框中心的Y偏移
enableEmoteInput 允许解析聊天输入表情
enableBubbleEmote 允许解析聊天泡泡表情
]]
local Config = {
    iconSize = 18,
    offsetX = 30,
    offsetY = 30,
    enableEmoteInput = true
-- ,enableBubbleEmote = false -- 这个功能会扫描所有聊天泡泡框架解析表情，容易扫描到被保护的框架，所以暂时移除了。
}

-- 表情选择器框架
local EmoteTableFrame

-- 表情解析规则
local fmtstring = format("\124T%%s:%d\124t", max(floor(select(2, SELECTED_CHAT_FRAME:GetFont())), Config.iconSize))

-- 自定义表情开始的序号
local customEmoteStartIndex = 9

local emotes = {
        --原版暴雪提供的8个图标
        {"{rt1}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_1]=]},
        {"{rt2}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_2]=]},
        {"{rt3}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_3]=]},
        {"{rt4}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_4]=]},
        {"{rt5}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_5]=]},
        {"{rt6}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_6]=]},
        {"{rt7}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_7]=]},
        {"{rt8}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_8]=]},
        --自定义表情
        {"{天使}", [=[Interface\Addons\ChatBar\Textures\Emotion\Angel]=]},
        {"{生气}", [=[Interface\Addons\ChatBar\Textures\Emotion\Angry]=]},
        {"{大笑}", [=[Interface\Addons\ChatBar\Textures\Emotion\Biglaugh]=]},
        {"{鼓掌}", [=[Interface\Addons\ChatBar\Textures\Emotion\Clap]=]},
        {"{酷}", [=[Interface\Addons\ChatBar\Textures\Emotion\Cool]=]},
        {"{哭}", [=[Interface\Addons\ChatBar\Textures\Emotion\Cry]=]},
        {"{可爱}", [=[Interface\Addons\ChatBar\Textures\Emotion\Cutie]=]},
        {"{鄙视}", [=[Interface\Addons\ChatBar\Textures\Emotion\Despise]=]},
        {"{美梦}", [=[Interface\Addons\ChatBar\Textures\Emotion\Dreamsmile]=]},
        {"{尴尬}", [=[Interface\Addons\ChatBar\Textures\Emotion\Embarrass]=]},
        {"{邪恶}", [=[Interface\Addons\ChatBar\Textures\Emotion\Evil]=]},
        {"{兴奋}", [=[Interface\Addons\ChatBar\Textures\Emotion\Excited]=]},
        {"{晕}", [=[Interface\Addons\ChatBar\Textures\Emotion\Faint]=]},
        {"{打架}", [=[Interface\Addons\ChatBar\Textures\Emotion\Fight]=]},
        {"{流感}", [=[Interface\Addons\ChatBar\Textures\Emotion\Flu]=]},
        {"{呆}", [=[Interface\Addons\ChatBar\Textures\Emotion\Freeze]=]},
        {"{皱眉}", [=[Interface\Addons\ChatBar\Textures\Emotion\Frown]=]},
        {"{致敬}", [=[Interface\Addons\ChatBar\Textures\Emotion\Greet]=]},
        {"{鬼脸}", [=[Interface\Addons\ChatBar\Textures\Emotion\Grimace]=]},
        {"{龇牙}", [=[Interface\Addons\ChatBar\Textures\Emotion\Growl]=]},
        {"{开心}", [=[Interface\Addons\ChatBar\Textures\Emotion\Happy]=]},
        {"{心}", [=[Interface\Addons\ChatBar\Textures\Emotion\Heart]=]},
        {"{恐惧}", [=[Interface\Addons\ChatBar\Textures\Emotion\Horror]=]},
        {"{生病}", [=[Interface\Addons\ChatBar\Textures\Emotion\Ill]=]},
        {"{无辜}", [=[Interface\Addons\ChatBar\Textures\Emotion\Innocent]=]},
        {"{功夫}", [=[Interface\Addons\ChatBar\Textures\Emotion\Kongfu]=]},
        {"{花痴}", [=[Interface\Addons\ChatBar\Textures\Emotion\Love]=]},
        {"{邮件}", [=[Interface\Addons\ChatBar\Textures\Emotion\Mail]=]},
        {"{化妆}", [=[Interface\Addons\ChatBar\Textures\Emotion\Makeup]=]},
        -- {"{马里奥}", [=[Interface\Addons\ChatBar\Textures\Emotion\Mario]=]},
        {"{沉思}", [=[Interface\Addons\ChatBar\Textures\Emotion\Meditate]=]},
        {"{可怜}", [=[Interface\Addons\ChatBar\Textures\Emotion\Miserable]=]},
        {"{好}", [=[Interface\Addons\ChatBar\Textures\Emotion\Okay]=]},
        {"{漂亮}", [=[Interface\Addons\ChatBar\Textures\Emotion\Pretty]=]},
        {"{吐}", [=[Interface\Addons\ChatBar\Textures\Emotion\Puke]=]},
        {"{握手}", [=[Interface\Addons\ChatBar\Textures\Emotion\Shake]=]},
        {"{喊}", [=[Interface\Addons\ChatBar\Textures\Emotion\Shout]=]},
        {"{闭嘴}", [=[Interface\Addons\ChatBar\Textures\Emotion\Shuuuu]=]},
        {"{害羞}", [=[Interface\Addons\ChatBar\Textures\Emotion\Shy]=]},
        {"{睡觉}", [=[Interface\Addons\ChatBar\Textures\Emotion\Sleep]=]},
        {"{微笑}", [=[Interface\Addons\ChatBar\Textures\Emotion\Smile]=]},
        {"{吃惊}", [=[Interface\Addons\ChatBar\Textures\Emotion\Suprise]=]},
        {"{失败}", [=[Interface\Addons\ChatBar\Textures\Emotion\Surrender]=]},
        {"{流汗}", [=[Interface\Addons\ChatBar\Textures\Emotion\Sweat]=]},
        {"{流泪}", [=[Interface\Addons\ChatBar\Textures\Emotion\Tear]=]},
        {"{悲剧}", [=[Interface\Addons\ChatBar\Textures\Emotion\Tears]=]},
        {"{想}", [=[Interface\Addons\ChatBar\Textures\Emotion\Think]=]},
        {"{偷笑}", [=[Interface\Addons\ChatBar\Textures\Emotion\Titter]=]},
        {"{猥琐}", [=[Interface\Addons\ChatBar\Textures\Emotion\Ugly]=]},
        {"{胜利}", [=[Interface\Addons\ChatBar\Textures\Emotion\Victory]=]},
        {"{雷锋}", [=[Interface\Addons\ChatBar\Textures\Emotion\Volunteer]=]},
        {"{委屈}", [=[Interface\Addons\ChatBar\Textures\Emotion\Wronged]=]}
}

local function ChatEmoteFilter(self, event, msg, ...)
    for i = customEmoteStartIndex, #emotes do
        if msg:find(emotes[i][1]) then
            msg = msg:gsub(emotes[i][1], format(fmtstring, emotes[i][2]), 1)
            break
        end
    end
    return false, msg, ...
end

local function EmoteIconMouseUp(frame, button)
    if (button == "LeftButton") then
        local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
        if (not ChatFrameEditBox:IsShown()) then
            ChatEdit_ActivateChat(ChatFrameEditBox)
        end
        ChatFrameEditBox:Insert(frame.text)
    end
    ToggleEmoteTable()
end

local function CreateEmoteTableFrame()
    EmoteTableFrame = CreateFrame("Frame", "EmoteTableFrame", UIParent)
    
    EmoteTableFrame:SetBackdrop(
        {
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = {left = 3, right = 3, top = 3, bottom = 3}
        }
    )
    EmoteTableFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
    EmoteTableFrame:SetBackdropBorderColor(0.3, 0.3, 0.3)
    EmoteTableFrame:SetWidth((Config.iconSize + 6) * 12 + 10)
    EmoteTableFrame:SetHeight((Config.iconSize + 6) * 5 + 10)
    EmoteTableFrame:SetPoint("BOTTOM", ChatFrame1EditBox, Config.offsetX, Config.offsetY)-- 表情选择框出现位置 默认30,30
    EmoteTableFrame:Hide()
    EmoteTableFrame:SetFrameStrata("DIALOG")
    
    local icon, row, col
    row = 1
    col = 1
    for i = 1, #emotes do
        text = emotes[i][1]
        texture = emotes[i][2]
        icon = CreateFrame("Frame", format("IconButton%d", i), EmoteTableFrame)
        icon:SetWidth(Config.iconSize + 6)
        icon:SetHeight(Config.iconSize + 6)
        icon.text = text
        icon.texture = icon:CreateTexture(nil, "ARTWORK")
        icon.texture:SetTexture(texture)
        icon.texture:SetAllPoints(icon)
        icon:Show()
        icon:SetPoint("TOPLEFT", 5 + (col - 1) * (Config.iconSize + 6), -5 - (row - 1) * (Config.iconSize + 6))
        icon:SetScript("OnMouseUp", EmoteIconMouseUp)
        icon:EnableMouse(true)
        col = col + 1
        if (col > 12) then
            row = row + 1
            col = 1
        end
    end
end

function ToggleEmoteTable()
    if (not EmoteTableFrame) then
        CreateEmoteTableFrame()
    end
    if (EmoteTableFrame:IsShown()) then
        EmoteTableFrame:Hide()
    else
        EmoteTableFrame:Show()
    end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", ChatEmoteFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", ChatEmoteFilter)
