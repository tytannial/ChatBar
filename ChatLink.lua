----------------------------------------------
-- 聊天超链接增强模块
-- @原作者:M TinyChat
-- 修改日志：
-- 合并物品等级和图标解析，增加货币解析。移除了鼠标提示，预计下版本重新加入。
----------------------------------------------
local SimpleChat = LibStub("AceAddon-3.0"):GetAddon("SimpleChat")

local SimpleChat_Config

--生成新的ICON超链接
local function GetHyperlink(Hyperlink, texture)
    if not texture then
        return Hyperlink
    else
        return "|T" .. texture .. ":0|t|h" .. Hyperlink
    end
end

--等级图标显示
local function SetChatLinkIcon(Hyperlink)
    local schema, id = string.match(Hyperlink, "|H(%w+):(%d+):")
    local texture
    if (schema == "item") then
        texture = select(10, GetItemInfo(tonumber(id)))
    elseif (schema == "currency") then
        texture = select(3, GetCurrencyInfo(tonumber(id)))
    elseif (schema == "spell") then
        texture = select(3, GetSpellInfo(tonumber(id)))
    elseif (schema == "achievement") then
        texture = select(10, GetAchievementInfo(tonumber(id)))
    end
    return GetHyperlink(Hyperlink, texture)
end

--等级图标显示
local function SetChatLinkLevel(Hyperlink)
    local link = string.match(Hyperlink, "|H(.-)|h")
    local level = select(4, GetItemInfo(link))
    if (level) then
        Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h[" .. level .. ":%1]|h")
    end
    return Hyperlink
end

--过滤器
local function ChatLinkFilter(self, event, msg, ...)
    if not SimpleChat_Config then
        return false, msg, ...
    end

    -- if SimpleChat_Config.ShowChatLinkIlvl then
    --     msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", SetChatLinkLevel)
    -- end
    if SimpleChat_Config.ShowChatLinkIcon then
        msg = msg:gsub("(|H%w+:%d+:.-|h.-|h)", SetChatLinkIcon)
    end
    return false, msg, ...
end

function SimpleChat:InitChatLink()
    SimpleChat_Config = self.db.profile
    self:RegisterFilter("CHAT_MSG_CHANNEL", ChatLinkFilter)-- 公共频道
    self:RegisterFilter("CHAT_MSG_SAY", ChatLinkFilter)-- 说
    self:RegisterFilter("CHAT_MSG_YELL", ChatLinkFilter)-- 大喊
    self:RegisterFilter("CHAT_MSG_RAID", ChatLinkFilter)-- 团队
    self:RegisterFilter("CHAT_MSG_RAID_LEADER", ChatLinkFilter)-- 团队领袖
    self:RegisterFilter("CHAT_MSG_PARTY", ChatLinkFilter)-- 队伍
    self:RegisterFilter("CHAT_MSG_PARTY_LEADER", ChatLinkFilter)-- 队伍领袖
    self:RegisterFilter("CHAT_MSG_GUILD", ChatLinkFilter)-- 公会
    
    self:RegisterFilter("CHAT_MSG_AFK", ChatLinkFilter)-- AFK玩家自动回复
    self:RegisterFilter("CHAT_MSG_DND", ChatLinkFilter)-- 切勿打扰自动回复
    -- 副本和副本领袖
    self:RegisterFilter("CHAT_MSG_INSTANCE_CHAT", ChatLinkFilter)
    self:RegisterFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", ChatLinkFilter)
    -- 解析战网私聊
    self:RegisterFilter("CHAT_MSG_WHISPER", ChatLinkFilter)
    self:RegisterFilter("CHAT_MSG_WHISPER_INFORM", ChatLinkFilter)
    self:RegisterFilter("CHAT_MSG_BN_WHISPER", ChatLinkFilter)
    self:RegisterFilter("CHAT_MSG_BN_WHISPER_INFORM", ChatLinkFilter)
    -- 解析社区聊天内容
    self:RegisterFilter("CHAT_MSG_COMMUNITIES_CHANNEL", ChatLinkFilter)
    --拾取信息
    self:RegisterFilter("CHAT_MSG_LOOT", ChatLinkFilter)
    self:RegisterFilter("CHAT_MSG_CURRENCY", ChatLinkFilter)
end
