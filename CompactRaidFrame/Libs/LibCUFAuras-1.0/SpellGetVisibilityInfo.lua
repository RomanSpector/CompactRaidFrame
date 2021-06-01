local MAJOR, MINOR = "LibCUFAuras-1.0", 90000;
if ( not LibStub ) then error(MAJOR .. " requires LibStub") return end

local lib = LibStub:NewLibrary(MAJOR, MINOR);
if ( not lib ) then return end

lib.callbacks = lib.callbacks or LibStub("CallbackHandler-1.0"):New(lib);
if ( not lib.callbacks ) then error(MAJOR .. " requires CallbackHandler-1.0") return end

local GetSpellInfo, UnitClass = GetSpellInfo, select(2, UnitClass("player"));

lib.spellList = {
    --== PRIEST ==--
    -- Weakened Soul
    [GetSpellInfo(6788)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  =  UnitClass == "PRIEST",
            showForMySpec = UnitClass == "PRIEST",
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  =  UnitClass == "PRIEST",
            showForMySpec = UnitClass == "PRIEST",
        },
    },
    -- Divine Spirit
    [GetSpellInfo(48073)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "PRIEST",
        },
    },
    -- Prayer of Spirit
    [GetSpellInfo(48074)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "PRIEST",
        },
    },
    -- Shadow Protection
    [GetSpellInfo(48169)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "PRIEST",
        },
    },
    -- Prayer of Shadow Protection
    [GetSpellInfo(48170)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "PRIEST",
        },
    },
    -- Prayer of Fortitude
    [GetSpellInfo(48162)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "PRIEST",
        },
    },
    -- Power Word: Fortitude
    [GetSpellInfo(48161)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "PRIEST",
        },
    },

    --== DEATHKNIGHT ==--
    -- Winter Horn
    [GetSpellInfo(57623)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "DEATHKNIGHT",
        },
    },
    -- Path of Frost
    [GetSpellInfo(3714)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "DEATHKNIGHT",
        },
    },

    --== PALADIN ==--
    -- Blessing of Kings
    [GetSpellInfo(20217)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = true,
            showForMySpec = UnitClass == "PALADIN",
        },
    },
    -- Greater Blessing of Kings
    [GetSpellInfo(25898)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = true,
            showForMySpec = UnitClass == "PALADIN",
        },
    },
    -- Blessing of Wisdom
    [GetSpellInfo(48936)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = true,
            showForMySpec = UnitClass == "PALADIN",
        },
    },
    -- Greater Blessing of Wisdom
    [GetSpellInfo(48938)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = true,
            showForMySpec = UnitClass == "PALADIN",
        },
    },
    -- Blessing of Might
    [GetSpellInfo(48932)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = true,
            showForMySpec = UnitClass == "PALADIN",
        },
    },
    -- Greater Blessing of Might
    [GetSpellInfo(48934)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "PALADIN",
        },
    },
    -- Blessing of Sanctuary
    [GetSpellInfo(20911)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = true,
            showForMySpec = UnitClass == "PALADIN",
        },
    },

    --== DRUID ==--
    -- Mark of the Wild
    [GetSpellInfo(48469)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = true,
            showForMySpec = UnitClass == "DRUID",
        },
    },
    -- Gift of the Wild
    [GetSpellInfo(48470)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "DRUID",
        },
    },
    -- Thorns
    [GetSpellInfo(53307)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "DRUID",
        },
    },

    --== SHAMAN ==--
    -- Earth Shield
    [GetSpellInfo(49284)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = true,
            showForMySpec = UnitClass == "SHAMAN",
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = true,
            showForMySpec = UnitClass == "SHAMAN",
        },
    },
    -- Windfury Totem
    [GetSpellInfo(8515)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "SHAMAN",
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "SHAMAN",
        },
    },
    -- Grounding Totem
    [GetSpellInfo(8177)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "SHAMAN",
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "SHAMAN",
        },
    },

    --== WARRIOR ==--
    -- Battle Shout
    [GetSpellInfo(47436)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "WARRIOR",
        },
    },
    -- Commanding Shout
    [GetSpellInfo(47440)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "WARRIOR",
        },
    },

    --== MAGE ==--
    -- Arcane Intellect
    [GetSpellInfo(42995)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "MAGE",
        },
    },
    -- Dalaran Intellect
    [GetSpellInfo(61024)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "MAGE",
        },
    },
    -- Dalaran Brilliance
    [GetSpellInfo(61316)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "MAGE",
        },
    },
    -- Arcane Brilliance
    [GetSpellInfo(43002)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "MAGE",
        },
    },
    -- Dampen Magic
    [GetSpellInfo(43015)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "MAGE",
        },
    },
    -- Focus Magic
    [GetSpellInfo(54646)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "MAGE",
        },
    },

    --== WARLOCK ==--
    -- Unending Breath
    [GetSpellInfo(5697)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = UnitClass == "WARLOCK",
        },
    },

    --== ANY DEBUFF SPELLS ==--
    -- Chill of the Throne
    [GetSpellInfo(69127)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = true,
        },
    },
    -- Deserter
    [GetSpellInfo(26013)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = true,
        },
    },
    -- Strange Feeling
    [GetSpellInfo(31694)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
    },
    -- Quel'Delar's Compulsion
    [GetSpellInfo(70013)] = {
        ["RAID_INCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
        ["RAID_OUTOFCOMBAT"] = {
            hasCustom = true,
            alwaysShowMine  = false,
            showForMySpec = false,
        },
    },
};