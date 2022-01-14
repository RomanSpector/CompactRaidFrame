local lib, version = LibStub("LibCUFAuras-1.0");
if ( not lib ) then error("not found LibCUFAuras-1.0") end
if ( version > 1 ) then return end

local companion        = "MOUNT";
local UnitClass        = UnitClass;
local GetSpellInfo     = GetSpellInfo;
local GetCompanionInfo = GetCompanionInfo;
local GetNumCompanions = GetNumCompanions;
local PLAYER_CLASS     = select(2, UnitClass("player"));

local function SetAuraInfo(canApplyAura, appliesOnlyYourself)
    return {
        canApplyAura = canApplyAura,
        appliesOnlyYourself = appliesOnlyYourself
    };
end

local UNIT_CAN_APPLY_AURAS = {
    ["DEATHKNIGHT"] =
        {
            [GetSpellInfo(48265)] = SetAuraInfo(true, true),  -- Unholy Presence
            [GetSpellInfo(48263)] = SetAuraInfo(true, true),  -- Frost Presence
            [GetSpellInfo(48266)] = SetAuraInfo(true, true),  -- Blood Presence
            [GetSpellInfo(45529)] = SetAuraInfo(true, true),  -- Blood Tap
            [GetSpellInfo(49016)] = SetAuraInfo(true, false), -- Hysteria
        },
    ["DRUID"] =
        {
            [GetSpellInfo(29166)] = SetAuraInfo(true, false), -- Innervate
            [GetSpellInfo(9634)]  = SetAuraInfo(true, true),  -- Dire Bear Form
            [GetSpellInfo(768)]   = SetAuraInfo(true, true),  -- Cat Form
            [GetSpellInfo(48451)] = SetAuraInfo(true, false), -- Lifebloom
            [GetSpellInfo(48441)] = SetAuraInfo(true, false), -- Rejuvenation
            [GetSpellInfo(48443)] = SetAuraInfo(true, false), -- Regrowth
            [GetSpellInfo(53251)] = SetAuraInfo(true, false), -- Wild Growth
            [GetSpellInfo(61336)] = SetAuraInfo(true, true),  -- Survival Instincts
            [GetSpellInfo(50334)] = SetAuraInfo(true, true),  -- Berserk
            [GetSpellInfo(5229)]  = SetAuraInfo(true, true),  -- Enrage
            [GetSpellInfo(22812)] = SetAuraInfo(true, true),  -- Barkskin
            [GetSpellInfo(53312)] = SetAuraInfo(true, true),  -- Nature's Grasp
            [GetSpellInfo(22842)] = SetAuraInfo(true, true),  -- Frenzied Regeneration
            [GetSpellInfo(2893)]  = SetAuraInfo(true, false), -- Abolish Poison
        },
    ["HUNTER"] =
        {
            [GetSpellInfo(5384)]  = SetAuraInfo(true, true),  -- Feign Death
            [GetSpellInfo(3045)]  = SetAuraInfo(true, true),  -- Rapid Fire
            [GetSpellInfo(53480)] = SetAuraInfo(true, false), -- Roar of Sacrifice
            [GetSpellInfo(53271)] = SetAuraInfo(true, false), -- Master's Call
        },
    ["MAGE"] =
        {
            [GetSpellInfo(43039)] = SetAuraInfo(true, true),  -- Ice Barrier
            [GetSpellInfo(45438)] = SetAuraInfo(true, true),  -- Ice Block
            [GetSpellInfo(42995)] = SetAuraInfo(true, false), -- Arcane Intellect
            [GetSpellInfo(61316)] = SetAuraInfo(true, false), -- Dalaran Brilliance
            [GetSpellInfo(43002)] = SetAuraInfo(true, false), -- Arcane Brilliance
            [GetSpellInfo(43015)] = SetAuraInfo(true, false), -- Dampen Magic
            [GetSpellInfo(54646)] = SetAuraInfo(true, false), -- Focus Magic
            [GetSpellInfo(61024)] = SetAuraInfo(true, false), -- Dalaran Intellect
            [GetSpellInfo(43012)] = SetAuraInfo(true, true),  -- Frost Ward
            [GetSpellInfo(43008)] = SetAuraInfo(true, true),  -- Ice Armor
            [GetSpellInfo(7301)]  = SetAuraInfo(true, true),  -- Frost Armor
            [GetSpellInfo(12472)] = SetAuraInfo(true, true),  -- Icy Veins
            [GetSpellInfo(43010)] = SetAuraInfo(true, true),  -- Fire Ward
            [GetSpellInfo(43046)] = SetAuraInfo(true, true),  -- Molten Armor
            [GetSpellInfo(43020)] = SetAuraInfo(true, true),  -- Mana Shield
            [GetSpellInfo(43024)] = SetAuraInfo(true, true),  -- Mage Armor
            [GetSpellInfo(66)]    = SetAuraInfo(true, true),  -- Invisibility
            [GetSpellInfo(130)]   = SetAuraInfo(true, false), -- Slow Fall
            [GetSpellInfo(11213)] = SetAuraInfo(true, true),  -- Arcane Concentration
            [GetSpellInfo(12043)] = SetAuraInfo(true, true),  -- Presence of Mind
            [GetSpellInfo(12042)] = SetAuraInfo(true, true),  -- Arcane Power
            [GetSpellInfo(31579)] = SetAuraInfo(true, true),  -- Arcane Empowerment
        },
    ["PALADIN"] =
        {
            [GetSpellInfo(53601)] = SetAuraInfo(true, false), -- Sacred Shield
            [GetSpellInfo(53563)] = SetAuraInfo(true, false), -- Beacon of Light
            [GetSpellInfo(6940)]  = SetAuraInfo(true, false), -- Hand of Sacrifice
            [GetSpellInfo(64205)] = SetAuraInfo(true, true),  -- Divine Sacrifice
            [GetSpellInfo(31821)] = SetAuraInfo(true, true),  -- Aura Mastery
            [GetSpellInfo(642)]   = SetAuraInfo(true, true),  -- Divine Shield
            [GetSpellInfo(1022)]  = SetAuraInfo(true, false), -- Hand of Protection
            [GetSpellInfo(10278)] = SetAuraInfo(true, false), -- Hand of Protection
            [GetSpellInfo(1044)]  = SetAuraInfo(true, false), -- Hand of Freedom
            [GetSpellInfo(54428)] = SetAuraInfo(true, true),  -- Divine Plea
            [GetSpellInfo(20217)] = SetAuraInfo(true, false), -- Blessing of Kings
            [GetSpellInfo(25898)] = SetAuraInfo(true, false), -- Greater Blessing of Kings
            [GetSpellInfo(48936)] = SetAuraInfo(true, false), -- Blessing of Wisdom
            [GetSpellInfo(48938)] = SetAuraInfo(true, false), -- Greater Blessing of Wisdom
            [GetSpellInfo(48932)] = SetAuraInfo(true, false), -- Blessing of Might
            [GetSpellInfo(48934)] = SetAuraInfo(true, false), -- Greater Blessing of Might
            [GetSpellInfo(25899)] = SetAuraInfo(true, false), -- Greater Blessing of Sanctuary
            [GetSpellInfo(20911)] = SetAuraInfo(true, false), -- Blessing of Sanctuary
            [GetSpellInfo(70940)] = SetAuraInfo(true, false), -- Divine Guardian
            [GetSpellInfo(48952)] = SetAuraInfo(true, true),  -- Holy Shield
            [GetSpellInfo(48942)] = SetAuraInfo(true, true),  -- Devotion Aura
            [GetSpellInfo(54043)] = SetAuraInfo(true, true),  -- Retribution Aura
            [GetSpellInfo(19746)] = SetAuraInfo(true, true),  -- Concentration Aura
            [GetSpellInfo(48943)] = SetAuraInfo(true, true),  -- Shadow Resistance Aura
            [GetSpellInfo(48945)] = SetAuraInfo(true, true),  -- Frost Resistance Aura
            [GetSpellInfo(48947)] = SetAuraInfo(true, true),  -- Fire Resistance Aura
            [GetSpellInfo(32223)] = SetAuraInfo(true, true),  -- Crusader Aura
            [GetSpellInfo(31884)] = SetAuraInfo(true, true),  -- Avenging Wrath
            [GetSpellInfo(54203)] = SetAuraInfo(true, false), -- Sheath of Light
            [GetSpellInfo(20053)] = SetAuraInfo(true, true),  -- Vengeance
            [GetSpellInfo(59578)] = SetAuraInfo(true, true),  -- The Art of War
        },
    ["PRIEST"] =
        {
            [GetSpellInfo(48111)] = SetAuraInfo(true, false), -- Prayer of Mending
            [GetSpellInfo(33206)] = SetAuraInfo(true, false), -- Pain Suppression
            [GetSpellInfo(48068)] = SetAuraInfo(true, false), -- Renew
            [GetSpellInfo(48162)] = SetAuraInfo(true, false), -- Prayer of Fortitude
            [GetSpellInfo(48161)] = SetAuraInfo(true, false), -- Power Word: Fortitude
            [GetSpellInfo(48066)] = SetAuraInfo(true, false), -- Power Word: Shield
            [GetSpellInfo(48073)] = SetAuraInfo(true, false), -- Divine Spirit
            [GetSpellInfo(48074)] = SetAuraInfo(true, false), -- Prayer of Spirit
            [GetSpellInfo(48169)] = SetAuraInfo(true, false), -- Shadow Protection
            [GetSpellInfo(48170)] = SetAuraInfo(true, false), -- Prayer of Shadow Protection
            [GetSpellInfo(72418)] = SetAuraInfo(true, true),  -- Chilling Knowledge
            [GetSpellInfo(47930)] = SetAuraInfo(true, false), -- Grace
            [GetSpellInfo(10060)] = SetAuraInfo(true, true),  -- Power Infusion
            [GetSpellInfo(586)]   = SetAuraInfo(true, true),  -- Fade
            [GetSpellInfo(48168)] = SetAuraInfo(true, true),  -- Inner Fire
            [GetSpellInfo(14751)] = SetAuraInfo(true, true),  -- Inner Focus
            [GetSpellInfo(6346)]  = SetAuraInfo(true, true),  -- Fear Ward
            [GetSpellInfo(64901)] = SetAuraInfo(true, false), -- Hymn of Hope
            [GetSpellInfo(64904)] = SetAuraInfo(true, true),  -- Hymn of Hope
            [GetSpellInfo(1706)]  = SetAuraInfo(true, false), -- Levitate
            [GetSpellInfo(64843)] = SetAuraInfo(true, false), -- Divine Hymn
            [GetSpellInfo(59891)] = SetAuraInfo(true, true),  -- Borrowed Time
            [GetSpellInfo(552)]   = SetAuraInfo(true, false), -- Abolish Disease
            [GetSpellInfo(15473)] = SetAuraInfo(true, true),  -- Shadowform
            [GetSpellInfo(15286)] = SetAuraInfo(true, true),  -- Vampiric Embrace
            [GetSpellInfo(49694)] = SetAuraInfo(true, true),  -- Improved Spirit Tap
            [GetSpellInfo(47788)] = SetAuraInfo(true, false), -- Guardian Spirit
            [GetSpellInfo(33151)] = SetAuraInfo(true, true),  -- Surge of Light
            [GetSpellInfo(33151)] = SetAuraInfo(true, true),  -- Inspiration
            [GetSpellInfo(7001)]  = SetAuraInfo(true, false), -- Lightwell Renew
            [GetSpellInfo(27827)] = SetAuraInfo(true, true),  -- Spirit of Redemption
            [GetSpellInfo(63734)] = SetAuraInfo(true, true),  -- Serendipity
            [GetSpellInfo(65081)] = SetAuraInfo(true, false), -- Body and Soul
            [GetSpellInfo(63944)] = SetAuraInfo(true, false), -- Renewed Hope
        },
    ["ROGUE"] =
        {
            [GetSpellInfo(1784)]  = SetAuraInfo(true, true),  -- Stealth
            [GetSpellInfo(31665)] = SetAuraInfo(true, true),  -- Master of Subtlety
            [GetSpellInfo(26669)] = SetAuraInfo(true, true),  -- Evasion
            [GetSpellInfo(11305)] = SetAuraInfo(true, true),  -- Sprint
            [GetSpellInfo(26888)] = SetAuraInfo(true, true),  -- Vanish
            [GetSpellInfo(36554)] = SetAuraInfo(true, true),  -- Shadowstep
            [GetSpellInfo(48659)] = SetAuraInfo(true, true),  -- Feint
            [GetSpellInfo(31224)] = SetAuraInfo(true, true),  -- Clock of Shadow
            [GetSpellInfo(51713)] = SetAuraInfo(true, true),  -- Shadow dance
            [GetSpellInfo(14177)] = SetAuraInfo(true, true),  -- Cold Blood
            [GetSpellInfo(57934)] = SetAuraInfo(true, false), -- Tricks of the Trade
        },
    ["SHAMAN"] =
        {
            [GetSpellInfo(49284)] = SetAuraInfo(true, false), -- Earth Shield
            [GetSpellInfo(8515)]  = SetAuraInfo(true, false), -- Windfury Totem
            [GetSpellInfo(8177)]  = SetAuraInfo(true, false), -- Grounding Totem
            [GetSpellInfo(32182)] = SetAuraInfo(true, false), -- Heroism
            [GetSpellInfo(2825)]  = SetAuraInfo(true, false), -- Bloodlust
            [GetSpellInfo(61301)] = SetAuraInfo(true, false), -- Riptide
        },
    ["WARLOCK"] = {    },
    ["WARRIOR"] =
        {
            [GetSpellInfo(2687)]  = SetAuraInfo(true, true),  -- Bloodrage
            [GetSpellInfo(18499)] = SetAuraInfo(true, true),  -- Berserker Rage
            [GetSpellInfo(12328)] = SetAuraInfo(true, true),  -- Sweeping Strikes
            [GetSpellInfo(23920)] = SetAuraInfo(true, true),  -- Spell Reflection
            [GetSpellInfo(871)]   = SetAuraInfo(true, true),  -- Shield Wall
            [GetSpellInfo(2565)]  = SetAuraInfo(true, true),  -- Shield Block
            [GetSpellInfo(55694)] = SetAuraInfo(true, true),  -- Enraged Regeneration
            [GetSpellInfo(1719)]  = SetAuraInfo(true, true),  -- Recklessness
            [GetSpellInfo(57522)] = SetAuraInfo(true, true),  -- Enrage
            [GetSpellInfo(20230)] = SetAuraInfo(true, true),  -- Retaliation
            [GetSpellInfo(46924)] = SetAuraInfo(true, true),  -- Bladestorm
            [GetSpellInfo(47440)] = SetAuraInfo(true, false), -- Commanding Shout
            [GetSpellInfo(47436)] = SetAuraInfo(true, false), -- Battle Shout
            [GetSpellInfo(46913)] = SetAuraInfo(true, true),  -- Bloodsurge
            [GetSpellInfo(12292)] = SetAuraInfo(true, true),  -- Death Wish
            [GetSpellInfo(16492)] = SetAuraInfo(true, true),  -- Blood Craze
            [GetSpellInfo(65156)] = SetAuraInfo(true, true),  -- Juggernaut
            [GetSpellInfo(3411)]  = SetAuraInfo(true, false), -- Intervene
        },
};
lib.UNIT_CAN_APPLY_AURAS = UNIT_CAN_APPLY_AURAS;

local function SetNewCompanion(spellID)
    UNIT_CAN_APPLY_AURAS[PLAYER_CLASS][GetSpellInfo(spellID)] = { canApplyAura = true,  appliesOnlyYourself = true };
end

local function Companion_Inizialization()
    for index = 1, GetNumCompanions(companion) do
        local _, _, spellID = GetCompanionInfo(companion, index);
        SetNewCompanion(spellID);
    end
end

function lib.events:PLAYER_LOGIN()
    Companion_Inizialization();
end

function lib.events:COMPANION_UPDATE(_, arg1)
    if ( arg1 == companion ) then
        Companion_Inizialization();
    end
end

lib.events:RegisterEvent("COMPANION_UPDATE");
lib.events:RegisterEvent("PLAYER_LOGIN");
