-------------------------------------
-- 聊天超鏈接增加ICON
-- @Author:M
-------------------------------------
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
    elseif (schema == "spell") then
        texture = select(3, GetSpellInfo(tonumber(id)))
    elseif (schema == "achievement") then
        texture = select(10, GetAchievementInfo(tonumber(id)))
    end
    return GetHyperlink(Hyperlink, texture)
end

--过滤器
local function ChatIconFilter(self, event, msg, ...)
    msg = msg:gsub("(|H%w+:%d+:.-|h.-|h)", SetChatLinkIcon)
    return false, msg, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", ChatIconFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", ChatIconFilter)

-- 鼠标图标大图显示
-- 如果你不想让鼠标移动到图标上显示大图标 把以下这段do end删了或者注释掉
do
    local bigIconFrame = CreateFrame("Frame", nil, UIParent)
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
