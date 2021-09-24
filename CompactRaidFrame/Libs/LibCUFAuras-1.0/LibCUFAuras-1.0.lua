local lib, version = LibStub("LibCUFAuras-1.0");
if ( lib and version < 90000 ) then
    return;
end

local pairs = pairs;
local tinsert, tremove = table.insert, table.remove;

local UnitAura = UnitAura;
local UnitGUID = UnitGUID;
local UnitExists = UnitExists;
local GetSpellInfo = GetSpellInfo;
local UnitAffectingCombat = UnitAffectingCombat;
local VSInfoList = lib.spellList;
local _, class = UnitClass("player");
local CAN_APPLY_AURA  = lib.CAN_APPLY_AURA[class];

lib.CASHE = lib.CASHE or {};

lib.trackAuras = true;
lib.callbacksUsed = {};

function lib.callbacks:OnUsed(target, eventname)
	lib.callbacksUsed[eventname] = lib.callbacksUsed[eventname] or {};
	tinsert(lib.callbacksUsed[eventname], #lib.callbacksUsed[eventname]+1, target);
	lib.trackAuras = true;

	lib.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	lib.frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	lib.frame:RegisterEvent("PLAYER_TARGET_CHANGED");
	lib.frame:RegisterEvent("PLAYER_REGEN_DISABLED");
	lib.frame:RegisterEvent("PLAYER_REGEN_ENABLED");
	lib.frame:RegisterEvent("UNIT_TARGET");
	lib.frame:RegisterEvent("UNIT_AURA");
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

	lib.trackAuras = false;

	lib.frame:UnregisterEvent("PLAYER_ENTERING_WORLD");
	lib.frame:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
	lib.frame:UnregisterEvent("PLAYER_TARGET_CHANGED");
	lib.frame:UnregisterEvent("PLAYER_REGEN_DISABLED");
	lib.frame:UnregisterEvent("PLAYER_REGEN_ENABLED");
	lib.frame:UnregisterEvent("UNIT_TARGET");
	lib.frame:UnregisterEvent("UNIT_AURA");
end

local function ResetUnitAuras(unitID)
	lib:RemoveAllAurasFromGUID(UnitGUID(unitID));
end

local function inCombatPriority(number, value)
	 if ( value ) then
		 return number + 1;
	 else
		return number
	 end
end

local function SetAuraPriority(name, spellID, unitCaster)
	local index = 0;
	local lossOfControl = C_LossOfControl.ControlList[name];

	local hasCustom, alwaysShowMine, showForMySpec = lib:SpellGetVisibilityInfo(spellID, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");
	local canApplyAura = CAN_APPLY_AURA[name];

	if ( canApplyAura ) then
		index = inCombatPriority(1, UnitAffectingCombat("player") and not CAN_APPLY_AURA[name].selfBuff);
	end
	if ( hasCustom and canApplyAura ) then
		index = inCombatPriority(1, showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle")));
	end
	if ( lossOfControl ) then
		index = lossOfControl[2];
	end

	return index;
end

function lib:AddAuraFromUnitID(index, filterType, dstGUID, ...)
	local name, texture, stackCount, dispelType, duration, expirationTime, 
			unitCaster, canStealOrPurge, shouldConsolidate, spellID, canApplyAura, isBossDebuff = ...;

	self.CASHE[dstGUID] = self.CASHE[dstGUID] or {};
	tinsert(self.CASHE[dstGUID], #self.CASHE[dstGUID] + 1, {
		index = index,
        filterType = filterType,
		priorityIndex = SetAuraPriority(name, spellID, unitCaster),
		name = name,
		texture = texture,
		stackCount = stackCount,
		debuffType = dispelType,
		duration = duration,
		expirationTime = expirationTime,
		unitCaster = unitCaster,
		canStealOrPurge = canStealOrPurge,
		shouldConsolidate = shouldConsolidate,
		spellID = spellID,
		canApplyAura = canApplyAura or false,
		isBossDebuff = isBossDebuff or false,
	});

	table.sort(self.CASHE[dstGUID], function (a,b)
		if ( a.priorityIndex == b.priorityIndex ) then
			return a.expirationTime > b.expirationTime;
		else
			return a.priorityIndex > b.priorityIndex;
		end
	end);

end

local CheckUnitAuras;

do
	local index
	local _, name, texture, stackCount, dispelType, duration, expirationTime, unitCaster, shouldConsolidate, spellID, canStealOrPurge, canApplyAura, isBossDebuff;
	local dstGUID;
	function CheckUnitAuras(unitID, filterType)
		if not ( UnitInParty(unitID) or UnitInRaid(unitID) ) then
			return;
		end

		dstGUID = UnitGUID(unitID)
		index = 1
		while true do
			name, _, texture, stackCount, dispelType, duration, expirationTime, unitCaster, 
												canStealOrPurge, shouldConsolidate, spellID = UnitAura(unitID, index, filterType)
			if not ( name ) then break end
			canApplyAura = (CAN_APPLY_AURA[name] and CAN_APPLY_AURA[name].canApply);

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
					canApplyAura,
					isBossDebuff
				);
			index = index + 1;
		end

		lib.callbacks:Fire("COMPACT_UNIT_FRAME_UNIT_AURA", dstGUID);
	end
end

lib.frame = lib.frame or CreateFrame("Frame")
lib.frame:SetScript("OnEvent", function(self, event, ...)
	if ( self[event] ) then
		self[event](self, event, ...);
	end
end)

local function UpdateAllAuras(unitID)
	ResetUnitAuras(unitID);
	CheckUnitAuras(unitID, "HELPFUL");
	CheckUnitAuras(unitID, "HARMFUL");
	CheckUnitAuras(unitID, "HARMFUL|RAID");
end

function lib.frame:UNIT_AURA(_, unitID)
	if not unitID then return; end
	UpdateAllAuras(unitID);
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

function lib.frame:PLAYER_ENTERING_WORLD()
	local unitRoster = GetUnitsRoster()
	for _, unitID in pairs(unitRoster) do
		if ( UnitExists(unitID) ) then
			UpdateAllAuras(unitID);
		end
	end
end

function lib.frame:PLAYER_REGEN_ENABLED()
	local unitRoster = GetUnitsRoster()
	for _, unitID in pairs(unitRoster) do
		if ( UnitExists(unitID) ) then
			UpdateAllAuras(unitID);
		end
	end
end

function lib.frame:PLAYER_REGEN_DISABLED()
	local unitRoster = GetUnitsRoster()
	for _, unitID in pairs(unitRoster) do
		if ( UnitExists(unitID) ) then
			UpdateAllAuras(unitID);
		end
	end
end

-- Remove all auras on a GUID. They must have died
function lib:RemoveAllAurasFromGUID(dstGUID)
	if self.CASHE[dstGUID] then
        for i = #self.CASHE[dstGUID], 1, -1 do
            tremove(self.CASHE[dstGUID], i);
        end
	end
end

local function GetAurasValue(sizeTable, value)
	return sizeTable >= value and value or nil;
end

local function IsNull(object)
	return #object == 0;
end

local slots, countValue;
function lib:UnitAuraSlots(unit, filter, maxCount, continuationToken)
    if ( continuationToken or not self.CASHE[UnitGUID(unit)] ) then 
        return;
    end

    slots = {}
    for key, value in ipairs(self.CASHE[UnitGUID(unit)]) do
        if ( value.filterType == filter ) then
            slots[#slots + 1] = key;
        end
    end

	countValue = GetAurasValue(#slots, maxCount);

	if ( IsNull(slots) ) then
		return nil;
	end

    return countValue, unpack(slots, 1, countValue or #slots);
end

function lib:UnitAuraBySlot(unit, slot)
	assert(unit, "UnitAuraBySlot: not found unit");
	assert(slot, "UnitAuraBySlot: not found slot");
	assert(type(unit)=="string", "UnitAuraBySlot: unit is not string value.");
	assert(type(slot)=="number", "UnitAuraBySlot: slot is not number value.");

    if ( self.CASHE[UnitGUID(unit)] and self.CASHE[UnitGUID(unit)][slot] ) then
        local info = self.CASHE[UnitGUID(unit)][slot];
        return info.name, info.texture, 
                info.stackCount, info.debuffType, 
                info.duration, info.expirationTime, 
                info.unitCaster, info.shouldConsolidate, 
                info.spellID, info.spellID, info.canApplyAura,
                info.isBossDebuff, info.index;
    end
end

function lib:SpellGetVisibilityInfo(spellID, visType)
	local info = VSInfoList[GetSpellInfo(spellID)];
	if ( not info ) then
		return false;
	end
	return info[visType].hasCustom, info[visType].alwaysShowMine, info[visType].showForMySpec;
end

function lib:SpellIsSelfBuff(spellID)
	assert(spellID, "not found spellID");
	assert(type(spellID)=="number", "spellID is not number value");

	return CAN_APPLY_AURA[GetSpellInfo(spellID)];
end