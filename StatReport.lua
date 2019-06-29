--[[
    StatReport.lua
        属性通报
    适配Bfa正式版本，汇报神器项链。修正汇报护甲为0
    插件更新地址 http://nga.178.com/read.php?tid=9633520
--]]
local SimpleChat = LibStub("AceAddon-3.0"):GetAddon("SimpleChat")

local SimpleChat_Config

local slotNames = {
    "HeadSlot",
    "NeckSlot",
    "ShoulderSlot",
    "BackSlot",
    "ChestSlot",
    "ShirtSlot",
    "TabardSlot",
    "WristSlot",
    "HandsSlot",
    "WaistSlot",
    "LegsSlot",
    "FeetSlot",
    "Finger0Slot",
    "Finger1Slot",
    "Trinket0Slot",
    "Trinket1Slot",
    "MainHandSlot",
    "SecondaryHandSlot",
    "AmmoSlot"
}

-- 本地化专精
local function Talent()
    local Spec = GetSpecialization()
    local SpecName = Spec and select(2, GetSpecializationInfo(Spec)) or "无"
    return SpecName
end

-- 格式化血量
local function HealText()
    local HP = UnitHealthMax("player")
    if HP > 1e4 then
        return format("%.2f万", HP / 1e4)
    else
        return HP
    end
end

-- 神器等级
local function ArtifactLevel()
    local currentLevel = " "
    local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
    if azeriteItemLocation then
        currentLevel = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
    end
    return currentLevel
end

-- 特质装等级
local function AzeriteItemLevel(slotNum)
    local currentLevel = "0"
    
    local slotId = GetInventorySlotInfo(slotNames[slotNum])
    local itemLink = GetInventoryItemLink("player", slotId)
    
    if itemLink then
        local itemLoc
        if ItemLocation then
            itemLoc = ItemLocation:CreateFromEquipmentSlot(slotId)
        end
        if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLoc) then
            return select(4, GetItemInfo(itemLink))
        end
    end
    return currentLevel
end

-- 基础属性
local function BaseInfo()
    local BaseStat = ""
    BaseStat = BaseStat .. ("[%s] "):format(UnitClass("player"))
    BaseStat = BaseStat .. ("[%s] "):format(Talent())
    BaseStat = BaseStat .. ("最高装等:%.1f 当前:%.1f "):format(GetAverageItemLevel())
    BaseStat = BaseStat .. ("血量:%s "):format(HealText())
    BaseStat = BaseStat .. ("神器:%s "):format(ArtifactLevel())-- 项链等级
    BaseStat = BaseStat .. ("头部:%s "):format(AzeriteItemLevel(1))-- 头部特质装等级
    BaseStat = BaseStat .. ("肩部:%s "):format(AzeriteItemLevel(3))-- 肩部特质装等级
    BaseStat = BaseStat .. ("胸部:%s "):format(AzeriteItemLevel(5))-- 胸部特质装等级
    return BaseStat
end

-- 输出属性(9 = 暴击 12 = 溅射 17 = 吸血 18 = 急速 21 = 闪避 26 = 精通 29 = 装备+自身全能 31 = 装备全能)
-- by图图
local function DpsInfo()
    local DpsStat = {"", "", ""}
    local specAttr = {
            --纯力敏智属性职业
            WARRIOR = {1, 1, 1},
            DEATHKNIGHT = {1, 1, 1},
            ROGUE = {2, 2, 2},
            HUNTER = {2, 2, 2},
            DEMONHUNTER = {2, 2},
            MAGE = {3, 3, 3},
            WARLOCK = {3, 3, 3},
            PRIEST = {3, 3, 3},
            --混合力敏智属性职业
            SHAMAN = {3, 2, 3},
            MONK = {2, 3, 2},
            DRUID = {3, 2, 2, 3},
            PALADIN = {3, 1, 1}
    }
    local specId = GetSpecialization()
    --    print("specId = "..specId)
    local classCN, classEnName = UnitClass("player")
    local classSpecArr = specAttr[classEnName]
    DpsStat[1] = ("力量:%s "):format(UnitStat("player", 1))
    DpsStat[2] = ("敏捷:%s "):format(UnitStat("player", 2))
    DpsStat[3] = ("智力:%s "):format(UnitStat("player", 4))
    return DpsStat[classSpecArr[specId]]
end

-- 坦克属性
local function TankInfo()
    local TankStat = ""
    TankStat = TankStat .. ("耐力:%s "):format(UnitStat("player", 3))
    TankStat = TankStat .. ("护甲:%s "):format(select(3, UnitArmor("player")))
    TankStat = TankStat .. ("躲闪:%.0f%% "):format(GetDodgeChance())
    TankStat = TankStat .. ("招架:%.0f%% "):format(GetParryChance())
    TankStat = TankStat .. ("格挡:%.0f%% "):format(GetBlockChance())
    return TankStat
end

-- 治疗属性
local function HealInfo()
    local HealStat = ""
    -- HealStat = HealStat..("精神:%s "):format(UnitStat("player", 5))
    -- HealStat = HealStat .. ("法力回复:%d "):format(GetManaRegen() * 5)
    return HealStat
end

-- 增强属性
local function MoreInfo()
    local MoreStat = ""
    MoreStat = MoreStat .. ("爆击:%.0f%% "):format(GetCritChance())
    MoreStat = MoreStat .. ("急速:%.0f%% "):format(GetMeleeHaste())
    MoreStat = MoreStat .. ("精通:%.0f%% "):format(GetMasteryEffect())
    --MoreStat = MoreStat..("溅射:%s "):format(GetMultistrike())
    MoreStat =
        MoreStat ..
        ("全能:%.0f%% "):format(
            GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
    )
    -- MoreStat = MoreStat .. ("吸血:%.0f%% "):format(GetCombatRating(17) / 230)
    -- MoreStat = MoreStat .. ("闪避:%.0f%% "):format(GetCombatRating(21) / 110)
    return MoreStat
end

-- 属性收集
function SimpleChat:StatReport()
    if UnitLevel("player") < 10 then
        return BaseInfo()
    end
    local StatInfo = ""
    local Role = GetSpecializationRole(GetSpecialization())
    if Role == "HEALER" then
        StatInfo = StatInfo .. BaseInfo() .. DpsInfo() .. HealInfo() .. MoreInfo()
    elseif Role == "TANK" then
        StatInfo = StatInfo .. BaseInfo() .. DpsInfo() .. TankInfo() .. MoreInfo()
    else
        StatInfo = StatInfo .. BaseInfo() .. DpsInfo() .. MoreInfo()
    end
    return StatInfo
end
