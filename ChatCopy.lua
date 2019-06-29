--[[
	ChatCopy.lua
		聊天复制
		修改自 siweia@NGA 的 NDui http://nga.178.com/read.php?tid=5483616
	插件更新地址 http://nga.178.com/read.php?tid=9633520
--]]
local SimpleChat = LibStub("AceAddon-3.0"):GetAddon("SimpleChat")

local lines = {}

local chatCopyFrame = CreateFrame("Frame", "ChatCopyFrame", UIParent)
chatCopyFrame:SetPoint("CENTER", UIParent, "CENTER")
chatCopyFrame:SetSize(700, 400)
chatCopyFrame:Hide()
chatCopyFrame:SetFrameStrata("DIALOG")
chatCopyFrame.close = CreateFrame("Button", nil, chatCopyFrame, "UIPanelCloseButton")
chatCopyFrame.close:SetPoint("TOPRIGHT", chatCopyFrame, "TOPRIGHT")
chatCopyFrame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = {left = 4, right = 4, top = 4, bottom = 4}
})

local scrollArea = CreateFrame("ScrollFrame", "ChatCopyScrollFrame", chatCopyFrame, "UIPanelScrollFrameTemplate")
scrollArea:SetPoint("TOPLEFT", chatCopyFrame, "TOPLEFT", 10, -30)
scrollArea:SetPoint("BOTTOMRIGHT", chatCopyFrame, "BOTTOMRIGHT", -30, 10)

local editBox = CreateFrame("EditBox", nil, chatCopyFrame)
editBox:SetMultiLine(true)
editBox:SetMaxLetters(99999)
editBox:EnableMouse(true)
editBox:SetAutoFocus(false)
editBox:SetFontObject(ChatFontNormal)
editBox:SetWidth(scrollArea:GetWidth())
editBox:SetHeight(270)
editBox:SetScript("OnEscapePressed", function(f)f:GetParent():GetParent():Hide()f:SetText("") end)
scrollArea:SetScrollChild(editBox)

function SimpleChat:CopyFunc()
    local cf = SELECTED_CHAT_FRAME
    local _, size = cf:GetFont()
    FCF_SetChatWindowFontSize(cf, cf, .01)
    local ct = 1
    for i = select("#", cf.FontStringContainer:GetRegions()), 1, -1 do
        local region = select(i, cf.FontStringContainer:GetRegions())
        if region:GetObjectType() == "FontString" then
            if region:GetText() ~= nil then
                lines[ct] = tostring(region:GetText())
                ct = ct + 1
            end
        end
    end
    local lineCt = ct - 1
    local text = table.concat(lines, "\n", 1, lineCt)
    FCF_SetChatWindowFontSize(cf, cf, size)
    chatCopyFrame:Show()
    editBox:SetText(text)
    editBox:HighlightText(0)
    wipe(lines)
end
