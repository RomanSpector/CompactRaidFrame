local lib, version = LibStub("LibCUFAuras-1.0");
if ( not lib ) then error("not found LibCUFAuras-1.0") end
if ( version > 1 ) then return end

local pairs   = pairs;
local tinsert = table.insert;
local tremove = table.remove;

local UnitAura             = UnitAura;
local UnitGUID             = UnitGUID;
local UnitExists           = UnitExists;
local CLASS_AURAS          = lib.CLASS_AURAS;
local GetSpellInfo         = GetSpellInfo;
local CanApplyAuras        = lib.UNIT_CAN_APPLY_AURAS[select(2, UnitClass("player"))];
local GetNumRaidMembers    = GetNumRaidMembers;
local UnitAffectingCombat  = UnitAffectingCombat;

lib.CASHE = {};
lib.callbacksUsed = {};

function lib.callbacks:OnUsed(target, eventname)
    lib.callbacksUsed[eventname] = lib.callbacksUsed[eventname] or {};
    tinsert(lib.callbacksUsed[eventname], #lib.callbacksUsed[eventname] + 1, target);

    lib.events:RegisterEvent("UNIT_AURA");
    lib.events:RegisterEvent("UNIT_TARGET");
    lib.events:RegisterEvent("PLAYER_ENTERING_WORLD");
    lib.events:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
    lib.events:RegisterEvent("PLAYER_TARGET_CHANGED");
    lib.events:RegisterEvent("PLAYER_REGEN_DISABLED");
    lib.events:RegisterEvent("PLAYER_REGEN_ENABLED");
end

function lib.callbacks:OnUnused(target, eventname)
    if ( lib.callbacksUsed[eventname] ) then
        for i = #lib.callbacksUsed[eventname], 1, -1 do
            if ( lib.callbacksUsed[eventname][i] == target ) then
                tremove(lib.callbacksUsed[eventname], i);
            end
        end
    end

    for event, value in pairs(lib.callbacksUsed) do
        if ( #value == 0 ) then
            lib.callbacksUsed[event] = nil;
        end
    end

    lib.events:UnregisterEvent("UNIT_AURA");
    lib.events:UnregisterEvent("UNIT_TARGET");
    lib.events:UnregisterEvent("PLAYER_ENTERING_WORLD");
    lib.events:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
    lib.events:UnregisterEvent("PLAYER_TARGET_CHANGED");
    lib.events:UnregisterEvent("PLAYER_REGEN_DISABLED");
    lib.events:UnregisterEvent("PLAYER_REGEN_ENABLED");
end

local function ResetUnitAuras(unitID)
    lib:RemoveAllAurasFromGUID(UnitGUID(unitID));
end

local function GetAuraPriority(name, spellId)

    if CanApplyAuras[name] then
        if CanApplyAuras[name].appliesOnlyYourself then
            return 1;
        end
        return UnitAffectingCombat("player") and 1 or 2;
    end

    if ( LOSS_OF_CONTROL_STORAGE[spellId] ) then
        return LOSS_OF_CONTROL_STORAGE[spellId][2];
    end

    if lib.HealingTakenEffect[spellId] then
        return 1;
    end

    return 0;
end

local sortPriorFunc = function (a,b)
    if a.priorityIndex == b.priorityIndex then
        return a.expirationTime > b.expirationTime;
    end

    return a.priorityIndex > b.priorityIndex;
end

function lib:AddAuraFromUnitID(index, filterType, dstGUID, ...)
    local spellName, texture, stackCount, dispelType, duration, expirationTime, unitCaster, canStealOrPurge, shouldConsolidate, spellID, canApplyAura = ...;

    local tracker = self.CASHE[dstGUID] or {};
    tinsert(tracker, #tracker + 1, {
        index = index,
        filterType = filterType,
        priorityIndex = GetAuraPriority(spellName, spellID),
        name = spellName,
        texture = texture,
        stackCount = stackCount,
        debuffType = dispelType,
        duration = duration,
        expirationTime = expirationTime,
        unitCaster = unitCaster,
        canStealOrPurge = canStealOrPurge,
        shouldConsolidate = shouldConsolidate,
        spellID = spellID,
        canApplyAura = canApplyAura,
        isBossDebuff = LOSS_OF_CONTROL_STORAGE[spellID],
    });

    table.sort(tracker, sortPriorFunc);
    self.CASHE[dstGUID] = tracker;
end

 local function CheckUnitAuras(unitID, filterType)
    local index = 1;
    local dstGUID = UnitGUID(unitID);
    local _, name, texture, stackCount, dispelType, duration, expirationTime, unitCaster, shouldConsolidate, spellID, canStealOrPurge;
    while ( true ) do
        name, _, texture, stackCount, dispelType, duration, expirationTime, unitCaster, canStealOrPurge, shouldConsolidate, spellID = UnitAura(unitID, index, filterType);
        if ( not name ) then break end
        lib:AddAuraFromUnitID(
                                index,
                                filterType,
                                dstGUID,
                                name,
                                texture,
                                stackCount,
                                dispelType,
                                duration,
                                expirationTime,
                                unitCaster,
                                canStealOrPurge,
                                shouldConsolidate,
                                spellID,
                                ( CanApplyAuras[name] and CanApplyAuras[name].canApplyAura )
                            );
        index = index + 1;
    end

    lib.callbacks:Fire("COMPACT_UNIT_FRAME_UNIT_AURA", dstGUID);
end

local function UnitAurasUpdate(unitID)
    ResetUnitAuras(unitID);

    CheckUnitAuras(unitID, "HELPFUL");
    CheckUnitAuras(unitID, "HARMFUL");
    CheckUnitAuras(unitID, "HARMFUL|RAID");
end

function lib.events:UNIT_AURA(_, unitID)
    if not unitID then return; end
    UnitAurasUpdate(unitID);
end

local function IsInRaid()
    return GetNumRaidMembers() > 0;
end

local function GetUnitsRoster()
    local roster = { "player" };
    local unit = IsInRaid() and "raid" or "party";
    local MAX_UNIT_INDEX = IsInRaid() and 40 or 4;

    for i=1, MAX_UNIT_INDEX do
        tinsert(roster, unit..i);
    end

    return roster;
end

local function UnitsAurasUpdate()
    for _, unitID in ipairs(GetUnitsRoster()) do
        if ( UnitExists(unitID) ) then
            UnitAurasUpdate(unitID);
        end
    end
end

function lib.events:PLAYER_ENTERING_WORLD()
    UnitsAurasUpdate();
end

function lib.events:PLAYER_REGEN_ENABLED()
    UnitsAurasUpdate();
end

function lib.events:PLAYER_REGEN_DISABLED()
    UnitsAurasUpdate();
end

-- Remove all auras on a GUID. They must have died
function lib:RemoveAllAurasFromGUID(dstGUID)
    local tracker = self.CASHE[dstGUID];
    if ( tracker ) then
        for i = #tracker, 1, -1 do
            tremove(tracker, i);
        end
    end
end

local function GetAurasValue(sizeTable, value)
    return sizeTable >= value and value or nil;
end

local function IsNull(object)
    return #object == 0;
end

do

    local auraSlots = {};
    function lib:UnitAuraSlots(unit, filter, maxCount, continuationToken)
        if ( continuationToken or not self.CASHE[UnitGUID(unit)] ) then
            return;
        end

        table.wipe(auraSlots);
        for key, value in ipairs(self.CASHE[UnitGUID(unit)]) do
            if ( value.filterType == filter ) then
                auraSlots[#auraSlots + 1] = key;
            end
        end

        local countValue = GetAurasValue(#auraSlots, maxCount);

        if ( IsNull(auraSlots) ) then
            return nil;
        end

        return countValue, unpack(auraSlots, 1, countValue or #auraSlots);
    end

end

function lib:UnitAuraBySlot(unit, slot)
    assert(unit, "UnitAuraBySlot: not found unit");
    assert(slot, "UnitAuraBySlot: not found slot");
    assert(type(unit)=="string", "UnitAuraBySlot: unit is not string value.");
    assert(type(slot)=="number", "UnitAuraBySlot: slot is not number value.");

    local tracker = self.CASHE[UnitGUID(unit)];
    local info = tracker and tracker[slot];
    if ( info ) then
        return info.name,              -- 1
               info.texture,           -- 2
               info.stackCount,        -- 3
               info.debuffType,        -- 4
               info.duration,          -- 5
               info.expirationTime,    -- 6
               info.unitCaster,        -- 7
               info.shouldConsolidate, -- 8
               info.spellID,           -- 9
               info.spellID,           -- 10
               info.canApplyAura,      -- 11
               info.isBossDebuff,      -- 12
               info.index;             -- 13
    end
end

function lib:SpellGetVisibilityInfo(spellID, visType)
    spellID = tonumber(spellID);
    assert(type(spellID)=="number", "spellID is not number value");
    local info = CLASS_AURAS[GetSpellInfo(spellID)];
    if ( not info ) then
        return false;
    end
    return info[visType].hasCustom, info[visType].alwaysShowMine, info[visType].showForMySpec;
end

function lib:SpellIsSelfBuff(spellID)
    spellID = tonumber(spellID);
    assert(type(spellID)=="number", "spellID is not number value");

    return CanApplyAuras[GetSpellInfo(spellID)];
end
