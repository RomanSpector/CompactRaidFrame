local lib, version = LibStub("LibCUFAuras-1.0");
if ( not lib ) then error("not found LibCUFAuras-1.0") end
if ( version > 1 ) then return end

local PLAYER_CLASS = select(2, UnitClass("player"));

local function SetRaidCombatInfo(hasCustom, alwaysShowMine, showForMySpec)
    return {
        hasCustom = hasCustom, -- whether the spell visibility should be customized, if false it means always display
        alwaysShowMine = alwaysShowMine,-- whether to show the spell if cast by the player/player's pet/vehicle (e.g. the Paladin Forbearance debuff)
        showForMySpec = showForMySpec, -- whether to show the spell for the current specialization of the player
    };
end

local CLASS_AURAS = {
    --== PRIEST ==--
    -- Weakened Soul
    [GetSpellInfo(6788)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, PLAYER_CLASS == "PRIEST", PLAYER_CLASS == "PRIEST"),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, PLAYER_CLASS == "PRIEST", PLAYER_CLASS == "PRIEST"),
    },
    -- Divine Spirit
    [GetSpellInfo(48073)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "PRIEST"),
    },
    -- Prayer of Spirit
    [GetSpellInfo(48074)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "PRIEST"),
    },
    -- Shadow Protection
    [GetSpellInfo(48169)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "PRIEST"),
    },
    -- Prayer of Shadow Protection
    [GetSpellInfo(48170)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "PRIEST"),
    },
    -- Prayer of Fortitude
    [GetSpellInfo(48162)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "PRIEST"),
    },
    -- Power Word: Fortitude
    [GetSpellInfo(48161)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "PRIEST"),
    },

    --== DEATHKNIGHT ==--
    -- Winter Horn
    [GetSpellInfo(57623)] = {
        ["RAID_INCOMBAT"]   = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "DEATHKNIGHT"),
    },
    -- Path of Frost
    [GetSpellInfo(3714)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "DEATHKNIGHT"),
    },

    --== PALADIN ==--
    -- Blessing of Kings
    [GetSpellInfo(20217)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, true, PLAYER_CLASS == "PALADIN"),
    },
    -- Greater Blessing of Kings
    [GetSpellInfo(25898)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, true, PLAYER_CLASS == "PALADIN"),
    },
    -- Blessing of Wisdom
    [GetSpellInfo(48936)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, true, PLAYER_CLASS == "PALADIN"),
    },
    -- Greater Blessing of Wisdom
    [GetSpellInfo(48938)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, true, PLAYER_CLASS == "PALADIN"),
    },
    -- Blessing of Might
    [GetSpellInfo(48932)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, true, PLAYER_CLASS == "PALADIN"),
    },
    -- Greater Blessing of Might
    [GetSpellInfo(48934)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "PALADIN"),
    },
    -- Blessing of Sanctuary
    [GetSpellInfo(20911)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, true, PLAYER_CLASS == "PALADIN"),
    },
    -- Greater Blessing of Sanctuary
    [GetSpellInfo(25899)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, true, PLAYER_CLASS == "PALADIN"),
    },

    --== DRUID ==--
    -- Mark of the Wild
    [GetSpellInfo(48469)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, true, PLAYER_CLASS == "DRUID"),
    },
    -- Gift of the Wild
    [GetSpellInfo(48470)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "DRUID"),
    },
    -- Thorns
    [GetSpellInfo(53307)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "DRUID"),
    },

    --== SHAMAN ==--
    -- Earth Shield
    [GetSpellInfo(49284)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, true, PLAYER_CLASS == "SHAMAN"),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, true, PLAYER_CLASS == "SHAMAN"),
    },
    -- Windfury Totem
    [GetSpellInfo(8515)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, PLAYER_CLASS == "SHAMAN"),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "SHAMAN"),
    },
    -- Grounding Totem
    [GetSpellInfo(8177)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, PLAYER_CLASS == "SHAMAN"),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "SHAMAN"),
    },

    --== WARRIOR ==--
    -- Battle Shout
    [GetSpellInfo(47436)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "WARRIOR"),
    },
    -- Commanding Shout
    [GetSpellInfo(47440)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "WARRIOR"),
    },

    --== MAGE ==--
    -- Arcane Intellect
    [GetSpellInfo(42995)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "MAGE"),
    },
    -- Dalaran Intellect
    [GetSpellInfo(61024)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "MAGE"),
    },
    -- Dalaran Brilliance
    [GetSpellInfo(61316)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "MAGE"),
    },
    -- Arcane Brilliance
    [GetSpellInfo(43002)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "MAGE"),
    },
    -- Dampen Magic
    [GetSpellInfo(43015)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "MAGE"),
    },
    -- Focus Magic
    [GetSpellInfo(54646)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "MAGE"),
    },

    --== WARLOCK ==--
    -- Unending Breath
    [GetSpellInfo(5697)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, PLAYER_CLASS == "WARLOCK"),
    },

    --== ANY DEBUFF SPELLS ==--
    -- Chill of the Throne
    [GetSpellInfo(69127)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, true),
    },
    -- Deserter
    [GetSpellInfo(26013)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, true),
    },
    -- Strange Feeling
    [GetSpellInfo(31694)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, false),
    },
    -- Quel'Delar's Compulsion
    [GetSpellInfo(70013)] = {
        ["RAID_INCOMBAT"]    = SetRaidCombatInfo(true, false, false),
        ["RAID_OUTOFCOMBAT"] = SetRaidCombatInfo(true, false, false),
    },
};
lib.CLASS_AURAS = CLASS_AURAS;
