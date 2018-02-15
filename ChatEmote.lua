-- 修改者 五区-塞拉摩-Leyvaten 插件更新地址 http://nga.178.com/read.php?tid=9633520

local _, ns = ...
local CurEB = "ChatFrame1EditBox"

--[[
配置选项 
iconSize 表情大小你可以根据聊天字号调整
offsetX 标情况相当于输入框中心的X偏移
offsetY 标情况相当于输入框中心的Y偏移
enableEmoteInput 允许解析聊天输入表情
enableBubbleEmote 允许解析聊天泡泡表情
]]
local Config = {
	iconSize = 16,
	offsetX = 30,
	offsetY = 30,
	enableEmoteInput = true,
	enableBubbleEmote = true
}

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
	{"{天使}", [=[Interface\Addons\ChatBar\icon\Angel]=]},
	{"{生气}", [=[Interface\Addons\ChatBar\icon\Angry]=]},
	{"{大笑}", [=[Interface\Addons\ChatBar\icon\Biglaugh]=]},
	{"{鼓掌}", [=[Interface\Addons\ChatBar\icon\Clap]=]},
	{"{酷}", [=[Interface\Addons\ChatBar\icon\Cool]=]},
	{"{哭}", [=[Interface\Addons\ChatBar\icon\Cry]=]},
	{"{可爱}", [=[Interface\Addons\ChatBar\icon\Cutie]=]},
	{"{鄙视}", [=[Interface\Addons\ChatBar\icon\Despise]=]},
	{"{美梦}", [=[Interface\Addons\ChatBar\icon\Dreamsmile]=]},
	{"{尴尬}", [=[Interface\Addons\ChatBar\icon\Embarrass]=]},
	{"{邪恶}", [=[Interface\Addons\ChatBar\icon\Evil]=]},
	{"{兴奋}", [=[Interface\Addons\ChatBar\icon\Excited]=]},
	{"{晕}", [=[Interface\Addons\ChatBar\icon\Faint]=]},
	{"{打架}", [=[Interface\Addons\ChatBar\icon\Fight]=]},
	{"{流感}", [=[Interface\Addons\ChatBar\icon\Flu]=]},
	{"{呆}", [=[Interface\Addons\ChatBar\icon\Freeze]=]},
	{"{皱眉}", [=[Interface\Addons\ChatBar\icon\Frown]=]},
	{"{致敬}", [=[Interface\Addons\ChatBar\icon\Greet]=]},
	{"{鬼脸}", [=[Interface\Addons\ChatBar\icon\Grimace]=]},
	{"{龇牙}", [=[Interface\Addons\ChatBar\icon\Growl]=]},
	{"{开心}", [=[Interface\Addons\ChatBar\icon\Happy]=]},
	{"{心}", [=[Interface\Addons\ChatBar\icon\Heart]=]},
	{"{恐惧}", [=[Interface\Addons\ChatBar\icon\Horror]=]},
	{"{生病}", [=[Interface\Addons\ChatBar\icon\Ill]=]},
	{"{无辜}", [=[Interface\Addons\ChatBar\icon\Innocent]=]},
	{"{功夫}", [=[Interface\Addons\ChatBar\icon\Kongfu]=]},
	{"{花痴}", [=[Interface\Addons\ChatBar\icon\Love]=]},
	{"{邮件}", [=[Interface\Addons\ChatBar\icon\Mail]=]},
	{"{化妆}", [=[Interface\Addons\ChatBar\icon\Makeup]=]},
	{"{马里奥}", [=[Interface\Addons\ChatBar\icon\Mario]=]},
	{"{沉思}", [=[Interface\Addons\ChatBar\icon\Meditate]=]},
	{"{可怜}", [=[Interface\Addons\ChatBar\icon\Miserable]=]},
	{"{好}", [=[Interface\Addons\ChatBar\icon\Okay]=]},
	{"{漂亮}", [=[Interface\Addons\ChatBar\icon\Pretty]=]},
	{"{吐}", [=[Interface\Addons\ChatBar\icon\Puke]=]},
	{"{握手}", [=[Interface\Addons\ChatBar\icon\Shake]=]},
	{"{喊}", [=[Interface\Addons\ChatBar\icon\Shout]=]},
	{"{闭嘴}", [=[Interface\Addons\ChatBar\icon\Shuuuu]=]},
	{"{害羞}", [=[Interface\Addons\ChatBar\icon\Shy]=]},
	{"{睡觉}", [=[Interface\Addons\ChatBar\icon\Sleep]=]},
	{"{微笑}", [=[Interface\Addons\ChatBar\icon\Smile]=]},
	{"{吃惊}", [=[Interface\Addons\ChatBar\icon\Suprise]=]},
	{"{失败}", [=[Interface\Addons\ChatBar\icon\Surrender]=]},
	{"{流汗}", [=[Interface\Addons\ChatBar\icon\Sweat]=]},
	{"{流泪}", [=[Interface\Addons\ChatBar\icon\Tear]=]},
	{"{悲剧}", [=[Interface\Addons\ChatBar\icon\Tears]=]},
	{"{想}", [=[Interface\Addons\ChatBar\icon\Think]=]},
	{"{偷笑}", [=[Interface\Addons\ChatBar\icon\Titter]=]},
	{"{猥琐}", [=[Interface\Addons\ChatBar\icon\Ugly]=]},
	{"{胜利}", [=[Interface\Addons\ChatBar\icon\Victory]=]},
	{"{雷锋}", [=[Interface\Addons\ChatBar\icon\Volunteer]=]},
	{"{委屈}", [=[Interface\Addons\ChatBar\icon\Wronged]=]}
}

local fmtstring = format("\124T%%s:%d\124t", max(floor(select(2, SELECTED_CHAT_FRAME:GetFont())), Config.iconSize))

local function myChatFilter(self, event, msg, ...)
	for i = customEmoteStartIndex, #emotes do
		if msg:find(emotes[i][1]) then
			msg = msg:gsub(emotes[i][1], format(fmtstring, emotes[i][2]), 1)
			break
		end
	end
	return false, msg, ...
end

local ShowEmoteTableButton
local EmoteTableFrame

function EmoteIconMouseUp(frame, button)
	if (button == "LeftButton") then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(frame.text)
	end
	ToggleEmoteTable()
end

function CreateEmoteTableFrame()
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
	EmoteTableFrame:SetBackdropColor(0.05, 0.05, 0.05)
	EmoteTableFrame:SetBackdropBorderColor(0.3, 0.3, 0.3)
	EmoteTableFrame:SetWidth((Config.iconSize + 2) * 12 + 10)
	EmoteTableFrame:SetHeight((Config.iconSize + 2) * 5 + 10)
	EmoteTableFrame:SetPoint("BOTTOM", ChatFrame1EditBox, Config.offsetX, Config.offsetY) -- 表情选择框出现位置 默认30,30
	EmoteTableFrame:Hide()
	EmoteTableFrame:SetFrameStrata("DIALOG")

	local icon, row, col
	row = 1
	col = 1
	for i = 1, #emotes do
		text = emotes[i][1]
		texture = emotes[i][2]
		icon = CreateFrame("Frame", format("IconButton%d", i), EmoteTableFrame)
		icon:SetWidth(Config.iconSize)
		icon:SetHeight(Config.iconSize)
		icon.text = text
		icon.texture = icon:CreateTexture(nil, "ARTWORK")
		icon.texture:SetTexture(texture)
		icon.texture:SetAllPoints(icon)
		icon:Show()
		icon:SetPoint("TOPLEFT", 5 + (col - 1) * (Config.iconSize + 2), -5 - (row - 1) * (Config.iconSize + 2))
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

local MaxBubbleWidth = 250

function HandleBubbleEmote(frame, fontstring)
	if not frame:IsShown() then
		fontstring.cachedText = nil
		return
	end

	MaxBubbleWidth = math.max(frame:GetWidth(), MaxBubbleWidth)

	local text = fontstring:GetText() or ""

	if text == fontstring.cachedText then
		return
	end

	frame:SetBackdropBorderColor(fontstring:GetTextColor())
	--fontstring:SetFont(ChatFrame1:GetFont(),select(2,ChatFrame1:GetFont()))
	local term
	for tag in string.gmatch(text, "%b{}") do
		term = strlower(string.gsub(tag, "[{}]", ""))
		if (ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]]) then
			text = string.gsub(text, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t")
		end
	end

	for i = customEmoteStartIndex, #emotes do
		if text:find(emotes[i][1]) then
			text = text:gsub(emotes[i][1], format(fmtstring, emotes[i][2]), 1)
			break
		end
	end
	fontstring:SetText(text)
	fontstring.cachedText = text
	fontstring:SetWidth(math.min(fontstring:GetStringWidth(), MaxBubbleWidth - 14))
end

function CheckBubbles()
	for i = 1, WorldFrame:GetNumChildren() do
		local v = select(i, WorldFrame:GetChildren())

		if (v:IsForbidden()) then
			return
		end

		local b = v:GetBackdrop()
		if b and b.bgFile == "Interface\\Tooltips\\ChatBubble-Background" then
			for i = 1, v:GetNumRegions() do
				local frame = v
				local v = select(i, v:GetRegions())
				if v:GetObjectType() == "FontString" then
					HandleBubbleEmote(frame, v)
				end
			end
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", myChatFilter)

if (Config.enableEmoteInput) then
	CreateEmoteTableFrame()
end

if (Config.enableBubbleEmote) then
	local BubbleScanInterval = 0.15
	AddonFrame = CreateFrame("Frame")
	AddonFrame.interval = BubbleScanInterval
	AddonFrame:SetScript(
		"OnUpdate",
		function(frame, elapsed)
			frame.interval = frame.interval - elapsed
			if frame.interval < 0 then
				frame.interval = BubbleScanInterval
				if IsInInstance() == false then
					CheckBubbles()
				end
			end
		end
	)
end

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
local function filter(self, event, msg, ...)
	msg = msg:gsub("(|H%w+:%d+:.-|h.-|h)", SetChatLinkIcon)
	return false, msg, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filter)

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
	--HACK
	local _SetItemRef = SetItemRef
	SetItemRef = function(link, text, button, chatFrame)
		if (link:sub(1, 12) == "ChatLinkIcon") then
			return
		end
		_SetItemRef(link, text, button, chatFrame)
	end
end

----------------------------------------------
-- 聊天超鏈接增加物品等級 (支持大祕境鑰匙等級)
-- @Author:M
----------------------------------------------

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
local function filter(self, event, msg, ...)
	if (not TinyChatDB or not TinyChatDB.hideLinkLevel) then
		msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", SetChatLinkLevel)
	end
	return false, msg, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filter)
