--[[============================== 属性通报 ==========================]] --

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

local function ArtifactLevel()
    local HPlv = " "
    if C_ArtifactUI.GetEquippedArtifactInfo() then
        HPlv = select(6, C_ArtifactUI.GetEquippedArtifactInfo())
    end
    return HPlv
end

-- 基础属性
local function BaseInfo()
    local BaseStat = ""
    BaseStat = BaseStat .. ("[%s] "):format(UnitClass("player"))
    BaseStat = BaseStat .. ("[%s] "):format(Talent())
    BaseStat = BaseStat .. ("最高装等:%.1f 当前:%.1f "):format(GetAverageItemLevel())
    BaseStat = BaseStat .. ("血量:%s "):format(HealText())
    BaseStat = BaseStat .. ("神器:%s "):format(ArtifactLevel())
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
    TankStat = TankStat .. ("护甲:%s "):format(UnitArmor("player"))
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
    MoreStat = MoreStat .. ("吸血:%.0f%% "):format(GetCombatRating(17) / 230)
    MoreStat = MoreStat .. ("闪避:%.0f%% "):format(GetCombatRating(21) / 110)
    return MoreStat
end

-- 属性收集
function StatReport()
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
