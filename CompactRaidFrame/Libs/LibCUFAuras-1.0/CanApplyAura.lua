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
            [48265] = SetAuraInfo(true, true),  -- Unholy Presence
            [48263] = SetAuraInfo(true, true),  -- Frost Presence
            [48266] = SetAuraInfo(true, true),  -- Blood Presence
            [45529] = SetAuraInfo(true, true),  -- Blood Tap
            [49016] = SetAuraInfo(true, false), -- Hysteria
        },
    ["DRUID"] =
        {
            [29166] = SetAuraInfo(true, false), -- Innervate
            [9634]  = SetAuraInfo(true, true),  -- Dire Bear Form
            [768]   = SetAuraInfo(true, true),  -- Cat Form
            [48451] = SetAuraInfo(true, false), -- Lifebloom
            [48441] = SetAuraInfo(true, false), -- Rejuvenation
            [48443] = SetAuraInfo(true, false), -- Regrowth
            [53251] = SetAuraInfo(true, false), -- Wild Growth
            [61336] = SetAuraInfo(true, true),  -- Survival Instincts
            [50334] = SetAuraInfo(true, true),  -- Berserk
            [5229]  = SetAuraInfo(true, true),  -- Enrage
            [22812] = SetAuraInfo(true, true),  -- Barkskin
            [53312] = SetAuraInfo(true, true),  -- Nature's Grasp
            [22842] = SetAuraInfo(true, true),  -- Frenzied Regeneration
            [2893]  = SetAuraInfo(true, false), -- Abolish Poison
        },
    ["HUNTER"] =
        {
            [5384]  = SetAuraInfo(true, true),  -- Feign Death
            [3045]  = SetAuraInfo(true, true),  -- Rapid Fire
            [53480] = SetAuraInfo(true, false), -- Roar of Sacrifice
            [53271] = SetAuraInfo(true, false), -- Master's Call
        },
    ["MAGE"] =
        {
            [43039] = SetAuraInfo(true, true),  -- Ice Barrier
            [45438] = SetAuraInfo(true, true),  -- Ice Block
            [42995] = SetAuraInfo(true, false), -- Arcane Intellect
            [61316] = SetAuraInfo(true, false), -- Dalaran Brilliance
            [43002] = SetAuraInfo(true, false), -- Arcane Brilliance
            [43015] = SetAuraInfo(true, false), -- Dampen Magic
            [54646] = SetAuraInfo(true, false), -- Focus Magic
            [61024] = SetAuraInfo(true, false), -- Dalaran Intellect
            [43012] = SetAuraInfo(true, true),  -- Frost Ward
            [43008] = SetAuraInfo(true, true),  -- Ice Armor
            [7301]  = SetAuraInfo(true, true),  -- Frost Armor
            [12472] = SetAuraInfo(true, true),  -- Icy Veins
            [43010] = SetAuraInfo(true, true),  -- Fire Ward
            [43046] = SetAuraInfo(true, true),  -- Molten Armor
            [43020] = SetAuraInfo(true, true),  -- Mana Shield
            [43024] = SetAuraInfo(true, true),  -- Mage Armor
            [66]    = SetAuraInfo(true, true),  -- Invisibility
            [130]   = SetAuraInfo(true, false), -- Slow Fall
            [11213] = SetAuraInfo(true, true),  -- Arcane Concentration
            [12043] = SetAuraInfo(true, true),  -- Presence of Mind
            [12042] = SetAuraInfo(true, true),  -- Arcane Power
            [31579] = SetAuraInfo(true, true),  -- Arcane Empowerment
        },
    ["PALADIN"] =
        {
            [53601] = SetAuraInfo(true, false), -- Sacred Shield
            [53563] = SetAuraInfo(true, false), -- Beacon of Light
            [6940]  = SetAuraInfo(true, false), -- Hand of Sacrifice
            [64205] = SetAuraInfo(true, true),  -- Divine Sacrifice
            [31821] = SetAuraInfo(true, true),  -- Aura Mastery
            [642]   = SetAuraInfo(true, true),  -- Divine Shield
            [1022]  = SetAuraInfo(true, false), -- Hand of Protection
            [10278] = SetAuraInfo(true, false), -- Hand of Protection
            [1044]  = SetAuraInfo(true, false), -- Hand of Freedom
            [54428] = SetAuraInfo(true, true),  -- Divine Plea
            [20217] = SetAuraInfo(true, false), -- Blessing of Kings
            [25898] = SetAuraInfo(true, false), -- Greater Blessing of Kings
            [48936] = SetAuraInfo(true, false), -- Blessing of Wisdom
            [48938] = SetAuraInfo(true, false), -- Greater Blessing of Wisdom
            [48932] = SetAuraInfo(true, false), -- Blessing of Might
            [48934] = SetAuraInfo(true, false), -- Greater Blessing of Might
            [25899] = SetAuraInfo(true, false), -- Greater Blessing of Sanctuary
            [20911] = SetAuraInfo(true, false), -- Blessing of Sanctuary
            [70940] = SetAuraInfo(true, false), -- Divine Guardian
            [48952] = SetAuraInfo(true, true),  -- Holy Shield
            [48942] = SetAuraInfo(true, true),  -- Devotion Aura
            [54043] = SetAuraInfo(true, true),  -- Retribution Aura
            [19746] = SetAuraInfo(true, true),  -- Concentration Aura
            [48943] = SetAuraInfo(true, true),  -- Shadow Resistance Aura
            [48945] = SetAuraInfo(true, true),  -- Frost Resistance Aura
            [48947] = SetAuraInfo(true, true),  -- Fire Resistance Aura
            [32223] = SetAuraInfo(true, true),  -- Crusader Aura
            [31884] = SetAuraInfo(true, true),  -- Avenging Wrath
            [54203] = SetAuraInfo(true, false), -- Sheath of Light
            [20053] = SetAuraInfo(true, true),  -- Vengeance
            [59578] = SetAuraInfo(true, true),  -- The Art of War
        },
    ["PRIEST"] =
        {
            [48111] = SetAuraInfo(true, false), -- Prayer of Mending
            [33206] = SetAuraInfo(true, false), -- Pain Suppression
            [48068] = SetAuraInfo(true, false), -- Renew
            [48162] = SetAuraInfo(true, false), -- Prayer of Fortitude
            [48161] = SetAuraInfo(true, false), -- Power Word: Fortitude
            [48066] = SetAuraInfo(true, false), -- Power Word: Shield
            [48073] = SetAuraInfo(true, false), -- Divine Spirit
            [48074] = SetAuraInfo(true, false), -- Prayer of Spirit
            [48169] = SetAuraInfo(true, false), -- Shadow Protection
            [48170] = SetAuraInfo(true, false), -- Prayer of Shadow Protection
            [72418] = SetAuraInfo(true, true),  -- Chilling Knowledge
            [47930] = SetAuraInfo(true, false), -- Grace
            [10060] = SetAuraInfo(true, true),  -- Power Infusion
            [586]   = SetAuraInfo(true, true),  -- Fade
            [48168] = SetAuraInfo(true, true),  -- Inner Fire
            [14751] = SetAuraInfo(true, true),  -- Inner Focus
            [6346]  = SetAuraInfo(true, true),  -- Fear Ward
            [64901] = SetAuraInfo(true, false), -- Hymn of Hope
            [64904] = SetAuraInfo(true, true),  -- Hymn of Hope
            [1706]  = SetAuraInfo(true, false), -- Levitate
            [64843] = SetAuraInfo(true, false), -- Divine Hymn
            [59891] = SetAuraInfo(true, true),  -- Borrowed Time
            [552]   = SetAuraInfo(true, false), -- Abolish Disease
            [15473] = SetAuraInfo(true, true),  -- Shadowform
            [15286] = SetAuraInfo(true, true),  -- Vampiric Embrace
            [49694] = SetAuraInfo(true, true),  -- Improved Spirit Tap
            [47788] = SetAuraInfo(true, false), -- Guardian Spirit
            [33151] = SetAuraInfo(true, true),  -- Surge of Light
            [33151] = SetAuraInfo(true, true),  -- Inspiration
            [7001]  = SetAuraInfo(true, false), -- Lightwell Renew
            [27827] = SetAuraInfo(true, true),  -- Spirit of Redemption
            [63734] = SetAuraInfo(true, true),  -- Serendipity
            [65081] = SetAuraInfo(true, false), -- Body and Soul
            [63944] = SetAuraInfo(true, false), -- Renewed Hope
        },
    ["ROGUE"] =
        {
            [1784]  = SetAuraInfo(true, true),  -- Stealth
            [31665] = SetAuraInfo(true, true),  -- Master of Subtlety
            [26669] = SetAuraInfo(true, true),  -- Evasion
            [11305] = SetAuraInfo(true, true),  -- Sprint
            [26888] = SetAuraInfo(true, true),  -- Vanish
            [36554] = SetAuraInfo(true, true),  -- Shadowstep
            [48659] = SetAuraInfo(true, true),  -- Feint
            [31224] = SetAuraInfo(true, true),  -- Clock of Shadow
            [51713] = SetAuraInfo(true, true),  -- Shadow dance
            [14177] = SetAuraInfo(true, true),  -- Cold Blood
            [57934] = SetAuraInfo(true, false), -- Tricks of the Trade
        },
    ["SHAMAN"] =
        {
            [49284] = SetAuraInfo(true, false), -- Earth Shield
            [8515]  = SetAuraInfo(true, false), -- Windfury Totem
            [8177]  = SetAuraInfo(true, false), -- Grounding Totem
            [32182] = SetAuraInfo(true, false), -- Heroism
            [2825]  = SetAuraInfo(true, false), -- Bloodlust
            [61301] = SetAuraInfo(true, false), -- Riptide
        },
    ["WARLOCK"] = {    },
    ["WARRIOR"] =
        {
            [2687]  = SetAuraInfo(true, true),  -- Bloodrage
            [18499] = SetAuraInfo(true, true),  -- Berserker Rage
            [12328] = SetAuraInfo(true, true),  -- Sweeping Strikes
            [23920] = SetAuraInfo(true, true),  -- Spell Reflection
            [871]   = SetAuraInfo(true, true),  -- Shield Wall
            [2565]  = SetAuraInfo(true, true),  -- Shield Block
            [55694] = SetAuraInfo(true, true),  -- Enraged Regeneration
            [1719]  = SetAuraInfo(true, true),  -- Recklessness
            [57522] = SetAuraInfo(true, true),  -- Enrage
            [20230] = SetAuraInfo(true, true),  -- Retaliation
            [46924] = SetAuraInfo(true, true),  -- Bladestorm
            [47440] = SetAuraInfo(true, false), -- Commanding Shout
            [47436] = SetAuraInfo(true, false), -- Battle Shout
            [46913] = SetAuraInfo(true, true),  -- Bloodsurge
            [12292] = SetAuraInfo(true, true),  -- Death Wish
            [16492] = SetAuraInfo(true, true),  -- Blood Craze
            [65156] = SetAuraInfo(true, true),  -- Juggernaut
            [3411]  = SetAuraInfo(true, false), -- Intervene
        },
};
lib.UNIT_CAN_APPLY_AURAS = UNIT_CAN_APPLY_AURAS;

local function SetNewCompanion(spellID)
    UNIT_CAN_APPLY_AURAS[PLAYER_CLASS][spellID] = { canApplyAura = true,  appliesOnlyYourself = true };
end

local function Companion_Inizialization()
    for index = 1, GetNumCompanions(companion) do
        local _, _, spellID = GetCompanionInfo(companion, index);
        SetNewCompanion(spellID);
    end
end

function lib.handler:PLAYER_LOGIN()
    Companion_Inizialization();
end

function lib.handler:COMPANION_UPDATE(_, arg1)
    if ( arg1 == companion ) then
        Companion_Inizialization();
    end
end

lib.handler:RegisterEvent("COMPANION_UPDATE");
lib.handler:RegisterEvent("PLAYER_LOGIN");
