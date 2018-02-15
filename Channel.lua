-- 修改者 五区-塞拉摩-Leyvaten 插件更新地址 http://nga.178.com/read.php?tid=9633520

--[[============================== 基本设置区域 ==========================]] --
-- true(启用)/false(关闭)
local ShortChannel = true -- 精简公共频道
--local ShowChatLinkIcon = true	-- 聊天连接图标WIP
local TimeStampFormat = false -- 聊天时间戳
 --

--[[============================== 默认的聊天标签,可修改汉字自定义 ==========================]] if (GetLocale() == "zhTW") then
	--公会
	CHAT_GUILD_GET = "|Hchannel:GUILD|h[公會]|h %s: "
	CHAT_OFFICER_GET = "|Hchannel:OFFICER|h[官員]|h %s: "

	--团队
	CHAT_RAID_GET = "|Hchannel:RAID|h[團隊]|h %s: "
	CHAT_RAID_WARNING_GET = "[通知] %s: "
	CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h[團長]|h %s: "

	--队伍
	CHAT_PARTY_GET = "|Hchannel:PARTY|h[隊伍]|h %s: "
	CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|h[隊長]|h %s: "
	CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|h[向導]|h %s: "

	--战场
	CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|h[戰場]|h %s: "
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|h[領袖]|h %s: "

	--说 / 喊
	CHAT_SAY_GET = "%s: "
	CHAT_YELL_GET = "%s: "

	--密语
	CHAT_WHISPER_INFORM_GET = "發送給%s: "
	CHAT_WHISPER_GET = "%s悄悄話: "

	--flags
	CHAT_FLAG_AFK = "[暫離] "
	CHAT_FLAG_DND = "[勿擾] "
	CHAT_FLAG_GM = "[GM] "
elseif (GetLocale() == "zhCN") then
	--公会
	CHAT_GUILD_GET = "|Hchannel:GUILD|h[公会]|h %s: "
	CHAT_OFFICER_GET = "|Hchannel:OFFICER|h[官员]|h %s: "

	--团队
	CHAT_RAID_GET = "|Hchannel:RAID|h[团队]|h %s: "
	CHAT_RAID_WARNING_GET = "[通知] %s: "
	CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h[团长]|h %s: "

	--队伍
	CHAT_PARTY_GET = "|Hchannel:PARTY|h[队伍]|h %s: "
	CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|h[队长]|h %s: "
	CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|h[向导]:|h %s: "

	--战场
	CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|h[副本]|h %s: "
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|h[领袖]|h %s: "

	--密语
	CHAT_WHISPER_INFORM_GET = "发送给%s: "
	CHAT_WHISPER_GET = "%s悄悄的说: "
	CHAT_BN_WHISPER_INFORM_GET = "发送给%s "
	CHAT_BN_WHISPER_GET = "悄悄的说%s "

	--说 / 喊
	CHAT_SAY_GET = "%s: "
	CHAT_YELL_GET = "%s: "

	--flags
	CHAT_FLAG_AFK = "[暂离] "
	CHAT_FLAG_DND = "[勿扰] "
	CHAT_FLAG_GM = "[GM] "
else
	CHAT_GUILD_GET = "|Hchannel:GUILD|hG|h %s "
	CHAT_OFFICER_GET = "|Hchannel:OFFICER|hO|h %s "
	CHAT_RAID_GET = "|Hchannel:RAID|hR|h %s "
	CHAT_RAID_WARNING_GET = "RW %s "
	CHAT_RAID_LEADER_GET = "|Hchannel:RAID|hRL|h %s "
	CHAT_PARTY_GET = "|Hchannel:PARTY|hP|h %s "
	CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|hPL|h %s "
	CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|hPG|h %s "
	CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|hB|h %s "
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|hBL|h %s "
	CHAT_WHISPER_INFORM_GET = "to %s "
	CHAT_WHISPER_GET = "from %s "
	CHAT_BN_WHISPER_INFORM_GET = "to %s "
	CHAT_BN_WHISPER_GET = "from %s "
	CHAT_SAY_GET = "%s "
	CHAT_YELL_GET = "%s "
	CHAT_FLAG_AFK = "[AFK] "
	CHAT_FLAG_DND = "[DND] "
	CHAT_FLAG_GM = "[GM] "
end

--================================公共频道和自定义频道精简================================--

local gsub = _G.string.gsub
local newAddMsg = {}
local chn, rplc
if (GetLocale() == "zhCN") then ---国服
	rplc = {
		"[%1综]",
		"[%1交]",
		"[%1防]",
		"[%1组]",
		"[%1守]",
		"[%1招]",
		"[%1世]",
		"[%1自定义]" -- 自定义频道缩写请自行修改
	}
elseif (GetLocale() == "zhTW") then ---台服
	rplc = {
		"[%1綜合]",
		"[%1貿易]",
		"[%1防務]",
		"[%1組隊]",
		"[%1世界]",
		"[%1招募]",
		"[%1世]",
		"[%1自定义]" -- 自定义频道缩写请自行修改
	}
else
	rplc = {
		"[GEN]",
		"[TR]",
		"[WD]",
		"[LD]",
		"[LFG]",
		"[GR]",
		"[BFC]",
		"[CL]" -- 英文缩写
	}
end

chn = {
	"%[%d+%. General.-%]",
	"%[%d+%. Trade.-%]",
	"%[%d+%. LocalDefense.-%]",
	"%[%d+%. LookingForGroup%]",
	"%[%d+%. WorldDefense%]",
	"%[%d+%. GuildRecruitment.-%]",
	"%[%d+%. BigFootChannel.-%]",
	"%[%d+%. CustomChannel.-%]" -- 自定义频道英文名随便填写
}

local L = GetLocale()
---------------------------------------- 国服简体中文 ---------------------------------------------
if L == "zhCN" then
	---------------------------------------- 台服繁体中文 ---------------------------------------------
	chn[1] = "%[%d+%. 综合.-%]"
	chn[2] = "%[%d+%. 交易.-%]"
	chn[3] = "%[%d+%. 本地防务.-%]"
	chn[4] = "%[%d+%. 寻求组队%]"
	chn[5] = "%[%d+%. 世界防务%]"
	chn[6] = "%[%d+%. 公会招募.-%]"
	chn[7] = "%[%d+%. 大脚世界频道.-%]"
	chn[8] = "%[%d+%. 自定义频道.-%]" -- 请修改频道名对应你游戏里的频道
elseif L == "zhTW" then
	chn[1] = "%[%d+%. 綜合.-%]"
	chn[2] = "%[%d+%. 貿易.-%]"
	chn[3] = "%[%d+%. 本地防務.-%]"
	chn[4] = "%[%d+%. 尋求組隊%]"
	chn[5] = "%[%d+%. 世界防務%]"
	chn[6] = "%[%d+%. 公會招募.-%]"
	chn[7] = "%[%d+%. 大脚世界频道.-%]"
	chn[8] = "%[%d+%. 自定义频道.-%]" -- 请修改频道名对应你游戏里的频道
else
	---------------------------------------- 其他语言均为英文 -----------------------------------------------
	chn[1] = "%[%d+%. General.-%]"
	chn[2] = "%[%d+%. Trade.-%]"
	chn[3] = "%[%d+%. LocalDefense.-%]"
	chn[4] = "%[%d+%. LookingForGroup%]"
	chn[5] = "%[%d+%. WorldDefense%]"
	chn[6] = "%[%d+%. GuildRecruitment.-%]"
	chn[7] = "%[%d+%. BigFootChannel.-%]"
	chn[8] = "%[%d+%. CustomChannel.-%]" -- 请修改频道名对应你游戏里的频道
end

-- 时间戳染色
local ts = "|cff68ccef|h%s|h|r %s"
-- 文字修改函数
local function AddMessage(frame, text, ...)
	-- 频道标签精简
	if ShortChannel then
		for i = 1, 8 do -- 对应上面几个频道(如果有9个频道就for i = 1, 9 do)
			text = gsub(text, chn[i], rplc[i])
		end
		text = gsub(text, "%[(%d0?)%. .-%]", "%1.")
	end
	-- 聊天时间戳
	if TimeStampFormat then
		if (type(text) ~= "string") then
			text = tostring(text)
		end
		text = format(ts, date("%H:%M:%S"), text)
	end
	return newAddMsg[frame:GetName()](frame, text, ...)
end

--RemoveChatWindowMessages(ChatFrame1,"messageGroup") -- 屏蔽出入频道信息

for i = 1, NUM_CHAT_WINDOWS do -- 对非战斗记录聊天框的信息进行处理
	if i ~= 2 then -- 跳过战斗记录框
		local f = _G[format("%s%d", "ChatFrame", i)]
		newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
		f.AddMessage = AddMessage
	end
end

--================================修理装备提示================================--
local frame = CreateFrame("Frame", nil, UIParent)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 400) -- 调整frame在屏幕的位置
frame:SetWidth(1200) -- 足够大点，不然点击不到
frame:SetHeight(40)
frame:Hide()
frame:SetScale(1)
frame:EnableMouse(true) -- 确保鼠标按键有效

local FrameText = frame:CreateFontString(nil, "ARTWORK")
FrameText:SetFontObject(GameFontNormal)
FrameText:SetFont(STANDARD_TEXT_FONT, 40, "outline")
FrameText:SetTextColor(0.8, 0, 0, 1) -- change this to change color
FrameText:SetPoint("CENTER") -- text正常设置到frame自身
FrameText:SetText("装备都红了，还不滚去修！") -- 没其他用途，就只需要设置一次

frame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript(
	"OnEvent",
	function(self)
		for id = 20, 1, -1 do
			local cur, max = GetInventoryItemDurability(id)
			if cur and max and cur / max <= 0.2 then --这里修改需要提醒的百分比
				frame:Show()
				return -- 只要有一件，不做多余检查，否则你的代码只有第一件装备需要修理时才会显示
			end
		end
		frame:Hide()
	end
)

-- 处理右键点击
frame:SetScript(
	"OnMouseUp",
	function(self, btn)
		if btn == "RightButton" then
			frame:Hide()
		end
	end
)
