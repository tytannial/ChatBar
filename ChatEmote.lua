--[[
    ChatEmote.lua
        聊天表情相关代码
    修正只解析一个表情
    插件更新地址 http://nga.178.com/read.php?tid=9633520
--]]
local SimpleChat = LibStub("AceAddon-3.0"):GetAddon("SimpleChatClassic")

local SimpleChat_Config

-- 表情选择器框架
local EmoteTableFrame

-- 表情解析规则
local fmtstring

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
        {"{天使}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Angel]=]},
        {"{生气}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Angry]=]},
        {"{大笑}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Biglaugh]=]},
        {"{鼓掌}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Clap]=]},
        {"{酷}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Cool]=]},
        {"{哭}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Cry]=]},
        {"{可爱}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Cutie]=]},
        {"{鄙视}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Despise]=]},
        {"{美梦}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Dreamsmile]=]},
        {"{尴尬}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Embarrass]=]},
        {"{邪恶}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Evil]=]},
        {"{兴奋}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Excited]=]},
        {"{晕}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Faint]=]},
        {"{打架}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Fight]=]},
        {"{流感}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Flu]=]},
        {"{呆}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Freeze]=]},
        {"{皱眉}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Frown]=]},
        {"{致敬}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Greet]=]},
        {"{鬼脸}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Grimace]=]},
        {"{龇牙}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Growl]=]},
        {"{开心}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Happy]=]},
        {"{心}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Heart]=]},
        {"{恐惧}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Horror]=]},
        {"{生病}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Ill]=]},
        {"{无辜}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Innocent]=]},
        {"{功夫}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Kongfu]=]},
        {"{花痴}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Love]=]},
        {"{邮件}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Mail]=]},
        {"{化妆}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Makeup]=]},
        -- {"{马里奥}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Mario]=]},
        {"{沉思}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Meditate]=]},
        {"{可怜}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Miserable]=]},
        {"{好}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Okay]=]},
        {"{漂亮}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Pretty]=]},
        {"{吐}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Puke]=]},
        {"{握手}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Shake]=]},
        {"{喊}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Shout]=]},
        {"{闭嘴}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Shuuuu]=]},
        {"{害羞}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Shy]=]},
        {"{睡觉}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Sleep]=]},
        {"{微笑}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Smile]=]},
        {"{吃惊}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Suprise]=]},
        {"{失败}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Surrender]=]},
        {"{流汗}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Sweat]=]},
        {"{流泪}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Tear]=]},
        {"{悲剧}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Tears]=]},
        {"{想}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Think]=]},
        {"{偷笑}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Titter]=]},
        {"{猥琐}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Ugly]=]},
        {"{胜利}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Victory]=]},
        {"{雷锋}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Volunteer]=]},
        {"{委屈}", [=[Interface\Addons\SimpleChatClassic\Textures\Emotion\Wronged]=]}
}

local function ChatEmoteFilter(self, event, msg, ...)
    if (SimpleChat_Config and SimpleChat_Config.EnableEmoteInput) then
        for i = customEmoteStartIndex, #emotes do
            if msg:find(emotes[i][1]) then
                msg = msg:gsub(emotes[i][1], format(fmtstring, emotes[i][2]), 1)
            end
        end
    end
    return false, msg, ...
end

local function EmoteIconMouseUp(frame, button)
    if (button == "LeftButton") then
		local chatFrame = GetCVar("chatStyle")=="im" and SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME
        local eb = chatFrame and chatFrame.editBox
        if(eb) then
            eb:Insert(frame.text)
            eb:Show();
            eb:SetFocus()
        end
    end
    SimpleChat:ToggleEmoteTable()
end

function SimpleChat:InitEmoteTableFrame()
    SimpleChat_Config = self.db.profile
    fmtstring = format("\124T%%s:%d\124t", max(floor(select(2, SELECTED_CHAT_FRAME:GetFont())), SimpleChat_Config.EmoteIconSize))
    
    EmoteTableFrame = CreateFrame("Frame", "EmoteTableFrame", UIParent)
    
    EmoteTableFrame:SetMovable(true)
    EmoteTableFrame:RegisterForDrag("LeftButton")
    EmoteTableFrame:SetScript("OnDragStart", EmoteTableFrame.StartMoving)
    EmoteTableFrame:SetScript("OnDragStop", EmoteTableFrame.StopMovingOrSizing)
    EmoteTableFrame:EnableMouse(true)
    
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
    EmoteTableFrame:SetWidth((SimpleChat_Config.EmoteIconListSize + 6) * 12 + 10)
    EmoteTableFrame:SetHeight((SimpleChat_Config.EmoteIconListSize + 6) * 5 + 10)
    EmoteTableFrame:SetPoint("BOTTOM", ChatFrame1EditBox, SimpleChat_Config.EmoteOffsetX, SimpleChat_Config.EmoteOffsetY)
    -- 表情选择框出现位置 默认30,30
    EmoteTableFrame:Hide()
    EmoteTableFrame:SetFrameStrata("DIALOG")
    
    local icon, row, col
    row = 1
    col = 1
    for i = 1, #emotes do
        text = emotes[i][1]
        texture = emotes[i][2]
        icon = CreateFrame("Frame", format("IconButton%d", i), EmoteTableFrame)
        icon:SetWidth(SimpleChat_Config.EmoteIconListSize + 6)
        icon:SetHeight(SimpleChat_Config.EmoteIconListSize + 6)
        icon.text = text
        icon.texture = icon:CreateTexture(nil, "ARTWORK")
        icon.texture:SetTexture(texture)
        icon.texture:SetAllPoints(icon)
        icon:Show()
        icon:SetPoint(
            "TOPLEFT",
            5 + (col - 1) * (SimpleChat_Config.EmoteIconListSize + 6),
            -5 - (row - 1) * (SimpleChat_Config.EmoteIconListSize + 6)
        )
        icon:SetScript("OnMouseUp", EmoteIconMouseUp)
        icon:EnableMouse(true)
        col = col + 1
        if (col > 12) then
            row = row + 1
            col = 1
        end
    end
    
    self:RegisterFilter("CHAT_MSG_CHANNEL", ChatEmoteFilter)-- 公共频道
    self:RegisterFilter("CHAT_MSG_SAY", ChatEmoteFilter)-- 说
    self:RegisterFilter("CHAT_MSG_YELL", ChatEmoteFilter)-- 大喊
    self:RegisterFilter("CHAT_MSG_RAID", ChatEmoteFilter)-- 团队
    self:RegisterFilter("CHAT_MSG_RAID_LEADER", ChatEmoteFilter)-- 团队领袖
    self:RegisterFilter("CHAT_MSG_PARTY", ChatEmoteFilter)-- 队伍
    self:RegisterFilter("CHAT_MSG_PARTY_LEADER", ChatEmoteFilter)-- 队伍领袖
    self:RegisterFilter("CHAT_MSG_GUILD", ChatEmoteFilter)-- 公会
    
    self:RegisterFilter("CHAT_MSG_AFK", ChatEmoteFilter)-- AFK玩家自动回复
    self:RegisterFilter("CHAT_MSG_DND", ChatEmoteFilter)-- 切勿打扰自动回复
    
    -- 副本和副本领袖
    self:RegisterFilter("CHAT_MSG_INSTANCE_CHAT", ChatEmoteFilter)
    self:RegisterFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", ChatEmoteFilter)
    -- 解析战网私聊
    self:RegisterFilter("CHAT_MSG_WHISPER", ChatEmoteFilter)
    self:RegisterFilter("CHAT_MSG_WHISPER_INFORM", ChatEmoteFilter)
    self:RegisterFilter("CHAT_MSG_BN_WHISPER", ChatEmoteFilter)
    self:RegisterFilter("CHAT_MSG_BN_WHISPER_INFORM", ChatEmoteFilter)
    -- 解析社区聊天内容
    self:RegisterFilter("CHAT_MSG_COMMUNITIES_CHANNEL", ChatEmoteFilter)
end

function SimpleChat:ToggleEmoteTable()
    if (EmoteTableFrame:IsShown()) then
        EmoteTableFrame:Hide()
    else
        EmoteTableFrame:Show()
    end
end
