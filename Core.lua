--[[
	Core.lua
        配置和一些乱七八糟的东西
    插件更新地址 http://nga.178.com/read.php?tid=9633520
--]]
--[[=========================== 基本设置区域 ==========================]]
local SimpleChat = LibStub("AceAddon-3.0"):NewAddon("SimpleChat", "AceEvent-3.0", "AceConsole-3.0")

local SimpleChat_Config = {
    profile = {
        -- 聊天条
        UseTopInput = false, -- 启用上方输入框
        UseVertical = false, -- 启用竖直聊天框
        UseTopChatbar = true, -- 启用上方聊天框/如果启用了竖直则为左右 false为下/右 true为上/左
        ChatBarOffsetX = 0, -- 相对于默认位置的X坐标偏移
        ChatBarOffsetY = 0, -- 相对于默认位置的Y坐标偏移
        DistanceVertical = 25, -- 垂直排列间隔
        DistanceHorizontal = 30, -- 水平排列间隔
        AlphaOnEnter = 1.0, -- 鼠标移入按钮时的透明度
        AlphaOnLeave = 0.5, -- 鼠标移开时按钮的透明度
        -- 聊天物品链接增强
        ShowChatLinkIlvl = true, -- 显示物品链接装等
        ShowChatLinkIcon = true, -- 显示物品链接图标
        ShowChatLinkBigIcon = true, -- 鼠标移动到链接图标上时会放大
        -- 聊天表情
        EmoteIconSize = 18, -- 聊天文字中的表情大小，你可以根据聊天字号调整
        EmoteIconListSize = 30, -- 表情选择器的图标大小
        EmoteOffsetX = 30, -- 标情况相当于输入框中心的X偏移
        EmoteOffsetY = 30, -- 标情况相当于输入框中心的Y偏移
        EnableEmoteInput = true, --允许解析聊天输入表情
        -- 聊天信息
        ShortChannel = true, -- 缩写聊天频道
        -- 储存聊天条位置
        Position = nil
    }
}
--[[=============================== END ==============================]]
-- 载入插件配置

function SimpleChat:RegisterFilter(event, callback)
	local frames = {GetFramesRegisteredForEvent(event)}
	ChatFrame_AddMessageEventFilter(event, callback)
	for i = 1, #frames do
		local frame = frames[i]
		frame:UnregisterEvent(event)
		frame:RegisterEvent(event)
	end
end

function SimpleChat:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SimpleChatDB",SimpleChat_Config)
	-- 加载功能模块
	self:InitChatBar() -- 加载聊天条
	self:InitChannel() -- 频道增强
	self:InitChatLinkIlvl() -- 聊天链接装等显示
	self:InitChatLinkIcon() -- 聊天链接图标显示
	self:InitChatLinkBigIconFrame() -- 聊天链接大图标框架
	self:InitEmoteTableFrame() -- 表情选择框架
end

-- SimpleChat_Config.panel = CreateFrame("Frame", "SimpleChat", UIParent)
-- SimpleChat_Config.panel.name = "简易聊天增强"
-- InterfaceOptions_AddCategory(SimpleChat_Config.panel)
