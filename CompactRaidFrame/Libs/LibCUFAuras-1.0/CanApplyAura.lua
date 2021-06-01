local lib, version = LibStub("LibCUFAuras-1.0");
if ( lib and version < 90000 ) then
    return;
end

local companion = "MOUNT";
local UnitClass = UnitClass;
local GetSpellInfo = GetSpellInfo;
local GetCompanionInfo = GetCompanionInfo;
local GetNumCompanions = GetNumCompanions;

lib.CAN_APPLY_AURA = {};
local CAN_APPLY_AURA = lib.CAN_APPLY_AURA;

CAN_APPLY_AURA["DEATHKNIGHT"] = {
    [GetSpellInfo(48265)] = { canApply = true, selfBuff = true  }, -- Unholy Presence
    [GetSpellInfo(48263)] = { canApply = true, selfBuff = true  }, -- Frost Presence
    [GetSpellInfo(48266)] = { canApply = true, selfBuff = true  }, -- Blood Presence
    [GetSpellInfo(45529)] = { canApply = true, selfBuff = true  }, -- Blood Tap
    [GetSpellInfo(49016)] = { canApply = true, selfBuff = false }, -- Hysteria
};

CAN_APPLY_AURA["DRUID"] = {
    [GetSpellInfo(29166)] = { canApply = true, selfBuff = false }, -- Innervate
    [GetSpellInfo(9634)]  = { canApply = true, selfBuff = true  }, -- Dire Bear Form
    [GetSpellInfo(768)]   = { canApply = true, selfBuff = true  }, -- Cat Form
    [GetSpellInfo(48451)] = { canApply = true, selfBuff = false }, -- Lifebloom
    [GetSpellInfo(48441)] = { canApply = true, selfBuff = false }, -- Rejuvenation
    [GetSpellInfo(48443)] = { canApply = true, selfBuff = false }, -- Regrowth
    [GetSpellInfo(53251)] = { canApply = true, selfBuff = false }, -- Wild Growth
    [GetSpellInfo(61336)] = { canApply = true, selfBuff = true  }, -- Survival Instincts
    [GetSpellInfo(50334)] = { canApply = true, selfBuff = true  }, -- Berserk
    [GetSpellInfo(5229)]  = { canApply = true, selfBuff = true  }, -- Enrage
    [GetSpellInfo(22812)] = { canApply = true, selfBuff = true  }, -- Barkskin
    [GetSpellInfo(53312)] = { canApply = true, selfBuff = true  }, -- Nature's Grasp
    [GetSpellInfo(22842)] = { canApply = true, selfBuff = true  }, -- Frenzied Regeneration
    [GetSpellInfo(2893)]  = { canApply = true, selfBuff = false }, -- Abolish Poison
};

CAN_APPLY_AURA["HUNTER"] = {
    [GetSpellInfo(5384)]  = { canApply = true, selfBuff = true  }, -- Feign Death
    [GetSpellInfo(3045)]  = { canApply = true, selfBuff = true  }, -- Rapid Fire
    [GetSpellInfo(53480)] = { canApply = true, selfBuff = false }, -- Roar of Sacrifice
    [GetSpellInfo(53271)] = { canApply = true, selfBuff = false }, -- Master's Call
};

CAN_APPLY_AURA["MAGE"] = {
    [GetSpellInfo(43039)] = { canApply = true, selfBuff = true  }, -- Ice Barrier
    [GetSpellInfo(45438)] = { canApply = true, selfBuff = true  }, -- Ice Block
    [GetSpellInfo(42995)] = { canApply = true, selfBuff = false }, -- Arcane Intellect
    [GetSpellInfo(61316)] = { canApply = true, selfBuff = false }, -- Dalaran Brilliance
    [GetSpellInfo(43002)] = { canApply = true, selfBuff = false }, -- Arcane Brilliance
    [GetSpellInfo(43015)] = { canApply = true, selfBuff = false }, -- Dampen Magic
    [GetSpellInfo(54646)] = { canApply = true, selfBuff = false }, -- Focus Magic
    [GetSpellInfo(61024)] = { canApply = true, selfBuff = false }, -- Dalaran Intellect
    [GetSpellInfo(43012)] = { canApply = true, selfBuff = true  }, -- Frost Ward
    [GetSpellInfo(43008)] = { canApply = true, selfBuff = true  }, -- Ice Armor
    [GetSpellInfo(7301)]  = { canApply = true, selfBuff = true  }, -- Frost Armor
    [GetSpellInfo(12472)] = { canApply = true, selfBuff = true  }, -- Icy Veins
    [GetSpellInfo(43010)] = { canApply = true, selfBuff = true  }, -- Fire Ward
    [GetSpellInfo(43046)] = { canApply = true, selfBuff = true  }, -- Molten Armor
    [GetSpellInfo(43020)] = { canApply = true, selfBuff = true  }, -- Mana Shield
    [GetSpellInfo(43024)] = { canApply = true, selfBuff = true  }, -- Mage Armor
    [GetSpellInfo(66)]    = { canApply = true, selfBuff = true  }, -- Invisibility
    [GetSpellInfo(130)]   = { canApply = true, selfBuff = false }, -- Slow Fall
    [GetSpellInfo(11213)] = { canApply = true, selfBuff = true  }, -- Arcane Concentration
    [GetSpellInfo(12043)] = { canApply = true, selfBuff = true  }, -- Presence of Mind
    [GetSpellInfo(12042)] = { canApply = true, selfBuff = true  }, -- Arcane Power
    [GetSpellInfo(31579)] = { canApply = true, selfBuff = true  }, -- Arcane Empowerment
};

CAN_APPLY_AURA["PALADIN"] = {
    [GetSpellInfo(53601)] = { canApply = true, selfBuff = false }, -- Sacred Shield
    [GetSpellInfo(53563)] = { canApply = true, selfBuff = false }, -- Beacon of Light
    [GetSpellInfo(6940)]  = { canApply = true, selfBuff = false }, -- Hand of Sacrifice
    [GetSpellInfo(64205)] = { canApply = true, selfBuff = true  }, -- Divine Sacrifice
    [GetSpellInfo(31821)] = { canApply = true, selfBuff = true  }, -- Aura Mastery
    [GetSpellInfo(642)]   = { canApply = true, selfBuff = true  }, -- Divine Shield
    [GetSpellInfo(1022)]  = { canApply = true, selfBuff = false }, -- Hand of Protection
    [GetSpellInfo(10278)] = { canApply = true, selfBuff = false }, -- Hand of Protection
    [GetSpellInfo(1044)]  = { canApply = true, selfBuff = false }, -- Hand of Freedom
    [GetSpellInfo(54428)] = { canApply = true, selfBuff = true  }, -- Divine Plea
    [GetSpellInfo(20217)] = { canApply = true, selfBuff = false }, -- Blessing of Kings
    [GetSpellInfo(25898)] = { canApply = true, selfBuff = false }, -- Greater Blessing of Kings
    [GetSpellInfo(48936)] = { canApply = true, selfBuff = false }, -- Blessing of Wisdom
    [GetSpellInfo(48938)] = { canApply = true, selfBuff = false }, -- Greater Blessing of Wisdom
    [GetSpellInfo(48932)] = { canApply = true, selfBuff = false }, -- Blessing of Might
    [GetSpellInfo(48934)] = { canApply = true, selfBuff = false }, -- Greater Blessing of Might
    [GetSpellInfo(70940)] = { canApply = true, selfBuff = false }, -- Divine Guardian
    [GetSpellInfo(48942)] = { canApply = true, selfBuff = true  }, -- Devotion Aura
    [GetSpellInfo(54043)] = { canApply = true, selfBuff = true  }, -- Retribution Aura
    [GetSpellInfo(19746)] = { canApply = true, selfBuff = true  }, -- Concentration Aura
    [GetSpellInfo(48943)] = { canApply = true, selfBuff = true  }, -- Shadow Resistance Aura
    [GetSpellInfo(48945)] = { canApply = true, selfBuff = true  }, -- Frost Resistance Aura
    [GetSpellInfo(48947)] = { canApply = true, selfBuff = true  }, -- Fire Resistance Aura
    [GetSpellInfo(32223)] = { canApply = true, selfBuff = true  }, -- Crusader Aura
    [GetSpellInfo(31884)] = { canApply = true, selfBuff = true  }, -- Avenging Wrath
    [GetSpellInfo(54203)] = { canApply = true, selfBuff = false }, -- Sheath of Light
    [GetSpellInfo(20053)] = { canApply = true, selfBuff = true  }, -- Vengeance
    [GetSpellInfo(59578)] = { canApply = true, selfBuff = true  }, -- The Art of War
};

CAN_APPLY_AURA["PRIEST"] = {
    [GetSpellInfo(48111)] = { canApply = true, selfBuff = false }, -- Prayer of Mending
    [GetSpellInfo(33206)] = { canApply = true, selfBuff = false }, -- Pain Suppression
    [GetSpellInfo(48068)] = { canApply = true, selfBuff = false }, -- Renew
    [GetSpellInfo(48162)] = { canApply = true, selfBuff = false }, -- Prayer of Fortitude
    [GetSpellInfo(48161)] = { canApply = true, selfBuff = false }, -- Power Word: Fortitude
    [GetSpellInfo(48066)] = { canApply = true, selfBuff = false }, -- Power Word: Shield
    [GetSpellInfo(48073)] = { canApply = true, selfBuff = false }, -- Divine Spirit
    [GetSpellInfo(48074)] = { canApply = true, selfBuff = false }, -- Prayer of Spirit
    [GetSpellInfo(48169)] = { canApply = true, selfBuff = false }, -- Shadow Protection
    [GetSpellInfo(48170)] = { canApply = true, selfBuff = false }, -- Prayer of Shadow Protection
    [GetSpellInfo(72418)] = { canApply = true, selfBuff = true  }, -- Chilling Knowledge
    [GetSpellInfo(47930)] = { canApply = true, selfBuff = false }, -- Grace
    [GetSpellInfo(10060)] = { canApply = true, selfBuff = true  }, -- Power Infusion
    [GetSpellInfo(586)]   = { canApply = true, selfBuff = true  }, -- Fade
    [GetSpellInfo(48168)] = { canApply = true, selfBuff = true  }, -- Inner Fire
    [GetSpellInfo(14751)] = { canApply = true, selfBuff = true  }, -- Inner Focus
    [GetSpellInfo(6346)]  = { canApply = true, selfBuff = true  }, -- Fear Ward
    [GetSpellInfo(64901)] = { canApply = true, selfBuff = false }, -- Hymn of Hope
    [GetSpellInfo(64904)] = { canApply = true, selfBuff = true  }, -- Hymn of Hope
    [GetSpellInfo(1706)]  = { canApply = true, selfBuff = false }, -- Levitate
    [GetSpellInfo(64843)] = { canApply = true, selfBuff = false }, -- Divine Hymn
    [GetSpellInfo(59891)] = { canApply = true, selfBuff = true  }, -- Borrowed Time
    [GetSpellInfo(552)]   = { canApply = true, selfBuff = false }, -- Abolish Disease
    [GetSpellInfo(15473)] = { canApply = true, selfBuff = true  }, -- Shadowform
    [GetSpellInfo(15286)] = { canApply = true, selfBuff = true  }, -- Vampiric Embrace
    [GetSpellInfo(49694)] = { canApply = true, selfBuff = true  }, -- Improved Spirit Tap
    [GetSpellInfo(47788)] = { canApply = true, selfBuff = false }, -- Guardian Spirit
    [GetSpellInfo(33151)] = { canApply = true, selfBuff = true  }, -- Surge of Light
    [GetSpellInfo(33151)] = { canApply = true, selfBuff = true  }, -- Inspiration
    [GetSpellInfo(7001)]  = { canApply = true, selfBuff = false }, -- Lightwell Renew
    [GetSpellInfo(27827)] = { canApply = true, selfBuff = true  }, -- Spirit of Redemption
    [GetSpellInfo(63734)] = { canApply = true, selfBuff = true  }, -- Serendipity
    [GetSpellInfo(65081)] = { canApply = true, selfBuff = false }, -- Body and Soul
    [GetSpellInfo(63944)] = { canApply = true, selfBuff = false }, -- Renewed Hope
};

CAN_APPLY_AURA["ROGUE"] = {
    [GetSpellInfo(1784)]  = { canApply = true, selfBuff = true  }, -- Stealth
    [GetSpellInfo(31665)] = { canApply = true, selfBuff = true  }, -- Master of Subtlety
    [GetSpellInfo(26669)] = { canApply = true, selfBuff = true  }, -- Evasion
    [GetSpellInfo(11305)] = { canApply = true, selfBuff = true  }, -- Sprint
    [GetSpellInfo(26888)] = { canApply = true, selfBuff = true  }, -- Vanish
    [GetSpellInfo(36554)] = { canApply = true, selfBuff = true  }, -- Shadowstep
    [GetSpellInfo(48659)] = { canApply = true, selfBuff = true  }, -- Feint
    [GetSpellInfo(31224)] = { canApply = true, selfBuff = true  }, -- Clock of Shadow
    [GetSpellInfo(51713)] = { canApply = true, selfBuff = true  }, -- Shadow dance
    [GetSpellInfo(14177)] = { canApply = true, selfBuff = true  }, -- Cold Blood
    [GetSpellInfo(57934)] = { canApply = true, selfBuff = false }, -- Tricks of the Trade
};

CAN_APPLY_AURA["SHAMAN"] = {
    [GetSpellInfo(49284)] = { canApply = true, selfBuff = false }, -- Earth Shield
    [GetSpellInfo(8515)]  = { canApply = true, selfBuff = false }, -- Windfury Totem
    [GetSpellInfo(8177)]  = { canApply = true, selfBuff = false }, -- Grounding Totem
    [GetSpellInfo(32182)] = { canApply = true, selfBuff = false }, -- Heroism
    [GetSpellInfo(2825)]  = { canApply = true, selfBuff = false }, -- Bloodlust
    [GetSpellInfo(61301)] = { canApply = true, selfBuff = false }, -- Riptide
};

CAN_APPLY_AURA["WARLOCK"] = {

};

CAN_APPLY_AURA["WARRIOR"] = {
    [GetSpellInfo(2687)]  = { canApply = true, selfBuff = true  }, -- Bloodrage
    [GetSpellInfo(18499)] = { canApply = true, selfBuff = true  }, -- Berserker Rage
    [GetSpellInfo(12328)] = { canApply = true, selfBuff = true  }, -- Sweeping Strikes
    [GetSpellInfo(23920)] = { canApply = true, selfBuff = true  }, -- Spell Reflection
    [GetSpellInfo(871)]   = { canApply = true, selfBuff = true  }, -- Shield Wall
    [GetSpellInfo(2565)]  = { canApply = true, selfBuff = true  }, -- Shield Block
    [GetSpellInfo(55694)] = { canApply = true, selfBuff = true  }, -- Enraged Regeneration
    [GetSpellInfo(1719)]  = { canApply = true, selfBuff = true  }, -- Recklessness
    [GetSpellInfo(57522)] = { canApply = true, selfBuff = true  }, -- Enrage
    [GetSpellInfo(20230)] = { canApply = true, selfBuff = true  }, -- Retaliation
    [GetSpellInfo(46924)] = { canApply = true, selfBuff = true  }, -- Bladestorm
    [GetSpellInfo(47440)] = { canApply = true, selfBuff = false }, -- Commanding Shout
    [GetSpellInfo(47436)] = { canApply = true, selfBuff = false }, -- Battle Shout
    [GetSpellInfo(46913)] = { canApply = true, selfBuff = true  }, -- Bloodsurge
    [GetSpellInfo(12292)] = { canApply = true, selfBuff = true  }, -- Death Wish
    [GetSpellInfo(16492)] = { canApply = true, selfBuff = true  }, -- Blood Craze
    [GetSpellInfo(65156)] = { canApply = true, selfBuff = true  }, -- Juggernaut
    [GetSpellInfo(3411)]  = { canApply = true, selfBuff = false }, -- Intervene
};

local function Companion_Inizialization()
    local num = GetNumCompanions(companion);
    local _, class = UnitClass("player");
    for i=1,num do
        local _, _, spellID = GetCompanionInfo(companion, i);
        CAN_APPLY_AURA[class][GetSpellInfo(spellID)] = { canApply = true, selfBuff = true };
    end
end

lib.frame = lib.frame or CreateFrame("Frame");
lib.frame:RegisterEvent("COMPANION_UPDATE");
lib.frame:RegisterEvent("PLAYER_LOGIN");

lib.frame:SetScript("OnEvent", function(self, event, ...)
	if ( self[event] ) then
		self[event](self, event, ...);
	end
end)

-- lib.frame:SetScript("OnEvent", function(self, event, arg1, ...)
--     if ( event == "PLAYER_LOGIN" ) then
--         Companion_Inizialization();
--     elseif ( event == "COMPANION_UPDATE" and arg1 == companion ) then
--         Companion_Inizialization();
--     end
-- end)

function lib.frame:PLAYER_LOGIN()
    Companion_Inizialization();
end

function lib.frame:COMPANION_UPDATE(_, arg1)
    if ( arg1 == companion ) then
        Companion_Inizialization();
    end
end