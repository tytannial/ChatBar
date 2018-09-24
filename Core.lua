--[[
	Core.lua
        配置和一些乱七八糟的东西
        插件更新地址 http://nga.178.com/read.php?tid=9633520
--]]
--[[=========================== 基本设置区域 ==========================]]
SimpleChatBar = nil -- 聊天条

SimpleChat_Config = {
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
    TimeStampFormat = false -- 把复制用的加号改成时间戳
}
--[[=============================== END ==============================]]
-- 载入插件配置
local Name, Addon = ...
local f = CreateFrame("Frame")

local function SimpleChat_Loaded(self, event, addon)
    if event == "ADDON_LOADED" and addon == "SimpleChat" then
        if SimpleChatChrConfig == nil then
            SimpleChatChrConfig = {Position = nil}
        end
    end

    if event == "PLAYER_LOGOUT" and addon == "SimpleChat" then
        local point, relativeTo, relativePoint, xOfs, yOfs = SimpleChatBar:GetPoint()
        SimpleChatChrConfig = {
            Position = {point = point, relativeTo = relativeTo:GetName(), relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs}
        }
    end

    -- 加载功能模块
    SimpleChat_InitChatBar() -- 加载聊天条
    SimpleChat_InitChannel() -- 频道增强
    SimpleChat_InitChatLinkIlvl() -- 聊天链接装等显示
    SimpleChat_InitChatLinkIcon() -- 聊天链接图标显示
    SimpleChat_InitChatLinkBigIconFrame() -- 聊天链接大图标框架
    SimpleChat_InitEmoteTableFrame() -- 表情选择框架

    f:UnregisterEvent("ADDON_LOADED")
end

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGOUT")
f:SetScript("OnEvent", SimpleChat_Loaded)

SimpleChat_Config.panel = CreateFrame("Frame", "SimpleChat", UIParent)
-- Register in the Interface Addon Options GUI
-- Set the name for the Category for the Options Panel
SimpleChat_Config.panel.name = "简易聊天增强"
-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(SimpleChat_Config.panel)
