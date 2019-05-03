-------------------------------------
-- 聊天超鏈接增加ICON
-- @Author:M TinyChat
-------------------------------------
local SimpleChat = LibStub("AceAddon-3.0"):GetAddon("SimpleChat")

local SimpleChat_Config

--生成新的ICON超链接
local function GetHyperlink(Hyperlink, texture)
    if (not texture or (TinyChatDB and TinyChatDB.hideLinkIcon)) then
        return Hyperlink
    else
        return "|HChatLinkIcon|h|T" .. texture .. ":0|t|h" .. Hyperlink
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

--过滤器
local function ChatIconFilter(self, event, msg, ...)
    if (SimpleChat_Config and SimpleChat_Config.ShowChatLinkIcon) then
        msg = msg:gsub("(|H%w+:%d+:.-|h.-|h)", SetChatLinkIcon)
    end
    return false, msg, ...
end

function SimpleChat:InitChatLinkIcon()
    SimpleChat_Config = self.db.profile
    self:RegisterFilter("CHAT_MSG_CHANNEL", ChatIconFilter)-- 公共频道
    self:RegisterFilter("CHAT_MSG_SAY", ChatIconFilter)-- 说
    self:RegisterFilter("CHAT_MSG_YELL", ChatIconFilter)-- 大喊
    self:RegisterFilter("CHAT_MSG_RAID", ChatIconFilter)-- 团队
    self:RegisterFilter("CHAT_MSG_RAID_LEADER", ChatIconFilter)-- 团队领袖
    self:RegisterFilter("CHAT_MSG_PARTY", ChatIconFilter)-- 队伍
    self:RegisterFilter("CHAT_MSG_PARTY_LEADER", ChatIconFilter)-- 队伍领袖
    self:RegisterFilter("CHAT_MSG_GUILD", ChatIconFilter)-- 公会
    
    self:RegisterFilter("CHAT_MSG_AFK", ChatIconFilter)-- AFK玩家自动回复
    self:RegisterFilter("CHAT_MSG_DND", ChatIconFilter)-- 切勿打扰自动回复
    -- 副本和副本领袖
    self:RegisterFilter("CHAT_MSG_INSTANCE_CHAT", ChatIconFilter)
    self:RegisterFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", ChatIconFilter)
    -- 解析战网私聊
    self:RegisterFilter("CHAT_MSG_WHISPER", ChatIconFilter)
    self:RegisterFilter("CHAT_MSG_WHISPER_INFORM", ChatIconFilter)
    self:RegisterFilter("CHAT_MSG_BN_WHISPER", ChatIconFilter)
    self:RegisterFilter("CHAT_MSG_BN_WHISPER_INFORM", ChatIconFilter)
    -- 解析社区聊天内容
    self:RegisterFilter("CHAT_MSG_COMMUNITIES_CHANNEL", ChatIconFilter)
    -- 拾取信息
    self:RegisterFilter("CHAT_MSG_LOOT", ChatIconFilter)
    self:RegisterFilter("CHAT_MSG_CURRENCY", ChatIconFilter)
end

local bigIconFrame
-- 鼠标图标大图显示
function SimpleChat:InitChatLinkBigIconFrame()
    bigIconFrame = CreateFrame("Frame", nil, UIParent)
    bigIconFrame:SetSize(48, 48)
    bigIconFrame:SetFrameStrata("TOOLTIP")
    bigIconFrame.icon = bigIconFrame:CreateTexture(nil, "BACKGROUND")
    bigIconFrame.icon:SetSize(48, 48)
    bigIconFrame.icon:SetPoint("CENTER")
    bigIconFrame:Hide()
    local function OnHyperlinkEnter(self, linkData, link)
        local schema = strsplit(":", linkData)
        --if (schema == "item" or schema == "spell" or schema == "achievement") then
        --    ShowUIPanel(ItemRefTooltip)
        --    if (not ItemRefTooltip:IsShown()) then
        --        ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
        --    end
        --    ItemRefTooltip:SetHyperlink(link)
        --end
        if (schema == "ChatLinkIcon") then
            local texture = link:match("%|T(.-):.-%|t")
            if (texture) then
                local cursorX, cursorY = GetCursorPosition()
                bigIconFrame.icon:SetTexture(texture)
                bigIconFrame:SetPoint(
                    "TOP",
                    UIParent,
                    "BOTTOMLEFT",
                    cursorX / UIParent:GetScale() + 24,
                    cursorY / UIParent:GetScale() + 10
                )
                bigIconFrame:Show()
            end
        end
    end
    local function OnHyperlinkLeave(self, linkData, link)
        bigIconFrame:Hide()
    end
    for i = 1, NUM_CHAT_WINDOWS do
        _G["ChatFrame" .. i]:HookScript("OnHyperlinkEnter", OnHyperlinkEnter)
        _G["ChatFrame" .. i]:HookScript("OnHyperlinkLeave", OnHyperlinkLeave)
    end
end
