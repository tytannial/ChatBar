--[[
    EasyChannel.lua
        频道和密语对象的快速切换
        提取自网易有爱163Chat
    插件更新地址 http://nga.178.com/read.php?tid=9633520
--]]
function ChatEdit_CustomTabPressed(...)
    return ChatEdit_CustomTabPressed_Inner(...)
end

local cycles = {
        -- "说"
        {
            chatType = "SAY",
            use = function(self, editbox)
                return 1
            end
        },
        --大喊
        {
            chatType = "YELL",
            use = function(self, editbox)
                return 1
            end
        },
        --小队
        {
            chatType = "PARTY",
            use = function(self, editbox)
                return IsInGroup()
            end
        },
        --团队
        {
            chatType = "RAID",
            use = function(self, editbox)
                return IsInRaid()
            end
        },
        --实时聊天
        {
            chatType = "INSTANCE_CHAT",
            use = function(self, editbox)
                return select(2, IsInInstance()) == "pvp"
            end
        },
        --公会
        {
            chatType = "GUILD",
            use = function(self, editbox)
                return IsInGuild()
            end
        },
        --频道
        {
            chatType = "CHANNEL",
            use = function(self, editbox, currChatType)
                local currNum
                if currChatType ~= "CHANNEL" then
                    currNum = IsShiftKeyDown() and 21 or 0
                else
                    currNum = editbox:GetAttribute("channelTarget")
                end
                local h, r, step = currNum + 1, 20, 1
                if IsShiftKeyDown() then
                    h, r, step = currNum - 1, 1, -1
                end
                for i = h, r, step do
                    local channelNum, channelName = GetChannelName(i)
                    if channelNum > 0 and channelName:find("大脚世界频道") then
                        --print(channelName); --DEBUG
                        editbox:SetAttribute("channelTarget", i)
                        return true
                    end
                end
            end
        },
        {
            chatType = "SAY",
            use = function(self, editbox)
                return 1
            end
        }
}

local chatTypeBeforeSwitch, tellTargetBeforeSwitch --记录在频道和密语之间切换时的状态
function ChatEdit_CustomTabPressed_Inner(self)
    if strsub(tostring(self:GetText()), 1, 1) == "/" then
        return
    end
    local currChatType = self:GetAttribute("chatType")
    if (IsControlKeyDown()) then
        if (currChatType == "WHISPER" or currChatType == "BN_WHISPER") then
            --记录之前的密语对象，以便后续切回
            self:SetAttribute("chatType", chatTypeBeforeSwitch or "SAY")
            ChatEdit_UpdateHeader(self)
            chatTypeBeforeSwitch = "WHISPER"
            tellTargetBeforeSwitch = self:GetAttribute("tellTarget")
            return --这里和下面不同，这里可以不返回true
        else
            local newTarget, newTargetType = ChatEdit_GetNextTellTarget()
            if tellTargetBeforeSwitch or (newTarget and newTarget ~= "") then
                self:SetAttribute("chatType", tellTargetBeforeSwitch and chatTypeBeforeSwitch or newTargetType)
                self:SetAttribute("tellTarget", tellTargetBeforeSwitch or newTarget)
                ChatEdit_UpdateHeader(self)
                chatTypeBeforeSwitch = currChatType
                tellTargetBeforeSwitch = nil
                return true --这里必须返回true，否则会被暴雪默认的再切换一次密语对象
            end
        end
    end
    
    --对于说然后SHIFT的情况，因为没有return，所以第一层循环会一直遍历到最后的SAY
    for i, curr in ipairs(cycles) do
        if curr.chatType == currChatType then
            local h, r, step = i + 1, #cycles, 1
            if IsShiftKeyDown() then
                h, r, step = i - 1, 1, -1
            end
            if currChatType == "CHANNEL" then
                h = i
            end --频道仍然要测试一下
            for j = h, r, step do
                if cycles[j]:use(self, currChatType) then
                    self:SetAttribute("chatType", cycles[j].chatType)
                    ChatEdit_UpdateHeader(self)
                    return
                end
            end
        end
    end
end
