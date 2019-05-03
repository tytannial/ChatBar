----------------------------------------------
-- 聊天超鏈接增加物品等級 (支持大祕境鑰匙等級)
-- @Author:M TinyChat
----------------------------------------------
local SimpleChat = LibStub("AceAddon-3.0"):GetAddon("SimpleChat")

local SimpleChat_Config

local tooltip = CreateFrame("GameTooltip", "ChatLinkLevelTooltip", UIParent, "GameTooltipTemplate")

local ItemLevelPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
local ItemPowerPattern = gsub(CHALLENGE_MODE_ITEM_POWER_LEVEL, "%%d", "(%%d+)")
local ItemNamePattern = gsub(CHALLENGE_MODE_KEYSTONE_NAME, "%%s", "(.+)")

--获取物品实际等级
local function GetItemLevelAndTexture(ItemLink)
    local texture = select(10, GetItemInfo(ItemLink))
    if (not texture) then
        return
    end
    local text, level, extraname
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:ClearLines()
    tooltip:SetHyperlink(ItemLink)
    for i = 2, 4 do
        text = _G[tooltip:GetName() .. "TextLeft" .. i]:GetText() or ""
        level = string.match(text, ItemLevelPattern)
        if (level) then
            break
        end
        level = string.match(text, ItemPowerPattern)
        if (level) then
            -- extraname = string.match(_G[tooltip:GetName().."TextLeft1"]:GetText(), ItemNamePattern)
            -- break
            end
    end
    return level, texture, extraname
end

--等级图标显示
local function SetChatLinkLevel(Hyperlink)
    local link = string.match(Hyperlink, "|H(.-)|h")
    local level, texture, extraname = GetItemLevelAndTexture(link)
    if (level and extraname) then
        Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. ":%1:" .. extraname .. "]|h")
    elseif (level) then
        Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. ":%1]|h")
    end
    return Hyperlink
end

--过滤器
local function ChatLinkIlvlFilter(self, event, msg, ...)
    if (SimpleChat_Config and SimpleChat_Config.ShowChatLinkIlvl) then
        msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", SetChatLinkLevel)
    end
    return false, msg, ...
end

function SimpleChat:InitChatLinkIlvl()
    SimpleChat_Config = self.db.profile
    self:RegisterFilter("CHAT_MSG_CHANNEL", ChatLinkIlvlFilter)-- 公共频道
    self:RegisterFilter("CHAT_MSG_SAY", ChatLinkIlvlFilter)-- 说
    self:RegisterFilter("CHAT_MSG_YELL", ChatLinkIlvlFilter)-- 大喊
    self:RegisterFilter("CHAT_MSG_RAID", ChatLinkIlvlFilter)-- 团队
    self:RegisterFilter("CHAT_MSG_RAID_LEADER", ChatLinkIlvlFilter)-- 团队领袖
    self:RegisterFilter("CHAT_MSG_PARTY", ChatLinkIlvlFilter)-- 队伍
    self:RegisterFilter("CHAT_MSG_PARTY_LEADER", ChatLinkIlvlFilter)-- 队伍领袖
    self:RegisterFilter("CHAT_MSG_GUILD", ChatLinkIlvlFilter)-- 公会
    
    self:RegisterFilter("CHAT_MSG_AFK", ChatLinkIlvlFilter)-- AFK玩家自动回复
    self:RegisterFilter("CHAT_MSG_DND", ChatLinkIlvlFilter)-- 切勿打扰自动回复
    -- 副本和副本领袖
    self:RegisterFilter("CHAT_MSG_INSTANCE_CHAT", ChatLinkIlvlFilter)
    self:RegisterFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", ChatLinkIlvlFilter)
    -- 解析战网私聊
    self:RegisterFilter("CHAT_MSG_WHISPER", ChatLinkIlvlFilter)
    self:RegisterFilter("CHAT_MSG_WHISPER_INFORM", ChatLinkIlvlFilter)
    self:RegisterFilter("CHAT_MSG_BN_WHISPER", ChatLinkIlvlFilter)
    self:RegisterFilter("CHAT_MSG_BN_WHISPER_INFORM", ChatLinkIlvlFilter)
    -- 解析社区聊天内容
    self:RegisterFilter("CHAT_MSG_COMMUNITIES_CHANNEL", ChatLinkIlvlFilter)
    --拾取信息
    self:RegisterFilter("CHAT_MSG_LOOT", ChatLinkIlvlFilter)
end
