local UnitName					= UnitName;
local UnitGUID					= UnitGUID;
local UnitIsUnit				= UnitIsUnit;
local UnitExists				= UnitExists;
local UnitIsEnemy				= UnitIsEnemy
local GetSpellInfo				= GetSpellInfo;
local UnitIsPlayer				= UnitIsPlayer;
local UnitIsConnected			= UnitIsConnected;
local DemoteAssistant			= DemoteAssistant;
local SendChatMessage			= SendChatMessage;
local GetRaidRosterInfo			= GetRaidRosterInfo;
local GetNumRaidMembers			= GetNumRaidMembers;
local PromoteToAssistant		= PromoteToAssistant;
local GetNumPartyMembers		= GetNumPartyMembers;
local GetPartyLeaderIndex		= GetPartyLeaderIndex;
local GetPlayerMapPosition		= GetPlayerMapPosition;
local GetRealNumRaidMembers		= GetRealNumRaidMembers;
local IsActiveBattlefieldArena	= IsActiveBattlefieldArena;

local MAX_RAID_MEMBERS = MAX_RAID_MEMBERS;

SOUNDKIT = SOUNDKIT or {};
SOUNDKIT.IG_MAINMENU_OPTION 			= "Interface\\AddOns\\CompactRaidFrame\\Media\\Sounds\\SOUNDKIT\\852.ogg";
SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON = "Interface\\AddOns\\CompactRaidFrame\\Media\\Sounds\\SOUNDKIT\\856.ogg";

hooksecurefunc("BlizzardOptionsPanel_OnEvent", function(self, event, ...)
    if ( self:GetName() == "CompactUnitFrameProfiles" ) then
        CompactUnitFrameProfiles_OnEvent(self, event, ...);
    end
end)

function IsRaidMarkerActive(index)
    return false;
end

function PassClickToParent(self, ...)
    self:GetParent():Click(...);
end

function ApplyCoordFix(v, default)
    return ( v > 10001 or v < -10001 ) and ( default or 1 ) or v;
end

function IsInGroup()
    return GetNumRaidMembers() > 0 or GetNumPartyMembers() > 0;
end

function IsInRaid()
    return GetNumRaidMembers() > 0;
end

function GetNumSubgroupMembers()
    return GetNumPartyMembers();
end

function GetNumGroupMembers()
    return IsInRaid() and GetNumRaidMembers() or GetNumPartyMembers();
end

function GetDisplayedAllyFrames()
    local useCompact = CUF_CVar:GetCVarBool("useCompactPartyFrames");
    if ( IsActiveBattlefieldArena() and not useCompact ) then
        return "party";
    elseif ( IsInGroup() and ( IsInRaid() or useCompact ) ) then
        return "raid";
    elseif ( IsInGroup() ) then
        return "party";
    else
        return nil;
    end
end

function UnitIsGroupLeader(unit)
    local isLeader = false;
    if ( not IsInGroup() ) then
        isLeader = false;
    elseif ( unit == "player" ) then
        isLeader = IsInRaid() and IsRaidLeader() or IsPartyLeader();
    else
        local index = unit:match("%d+");
        isLeader = index and GetPartyLeaderIndex() == index;
    end
    return isLeader;
end

function UnitIsGroupAssistant(unit)
    local isAssistant = false;
    if ( not IsInRaid() ) then
        isAssistant = false;
    else
        -- UnitIsRaidOfficer return correctly also for party
        isAssistant = UnitIsRaidOfficer(unit) and not UnitIsGroupLeader(unit);
    end
    return isAssistant;
end

function UnitDistanceSquared(unit)
    if ( UnitIsConnected(unit) ) then
        local px, py = GetPlayerMapPosition("player");
        local ux, uy = GetPlayerMapPosition(unit);
        return CalculateDistance(px, py, ux, uy) * 100000, true;
    end
    return 0, false;
end

function CanBeRaidTarget(unit)
    if ( not unit ) then
        return;
    end

    if ( UnitExists(unit) and UnitIsConnected(unit) ) then
        return not ( UnitIsPlayer(unit) and UnitIsEnemy("player", unit) );
    end
end

local MAX_BATTLEGOUND_UNIT = {
    AlteracValley 		= 40,
    ArathiBasin 		= 15,
    NetherstormArena 	= 15,
    WarsongGulch 		= 10,
    IsleofConquest 		= 40,
    StrandoftheAncients = 15,
    LakeWintergrasp 	= 40,
};

local CrossLocation = {
    ["Кратер Азшары"] = true,
};

C_PvP = C_PvP or {};
function C_PvP.IsRatedBattleground()
    return false;
end

function C_PvP.IsWarModeDesired()
    return false;
end

function C_PvP.IsPvPMap()
    local inInstance, instanceType = IsInInstance();
    if ( not inInstance ) then
        return;
    end

    return instanceType == "pvp" or instanceType == "arena";
end

function UnitPhaseReason(unit)
    if ( C_PvP.IsPvPMap() or UnitIsUnit("player", unit) ) then
        return;
    end

    if not ( IsInRaid() and UnitIsConnected(unit) ) then
        return;
    end

    for i = 1, MAX_RAID_MEMBERS do
        local name, rank, subgroup, level, class, fileName, zone = GetRaidRosterInfo(i)
        if ( not name ) then
            break;
        end

        if name == UnitName(unit) then
            return CrossLocation[zone];
        end
    end

end

function GetMaxUnitNumberBattleground()
    return MAX_BATTLEGOUND_UNIT[GetMapInfo()];
end

C_Map = C_Map or {};
C_Map.WorldMap = {};

local function LoadZones(obj, ...)
    local n = select('#', ...);
    for i=1, n do
        local zone = select(i, ...);
        tinsert(obj, zone);
    end
end

for continentIndex = 1, 4 do
    LoadZones(C_Map.WorldMap, GetMapZones(continentIndex));
end

function C_Map.IsWorldMap(uiMap)
    for _, value in pairs(C_Map.WorldMap) do
        if ( value == uiMap ) then
            return true;
        end
    end
end

function UnitInOtherParty(unit)
    if not C_Map.IsWorldMap(GetZoneText()) or UnitPhaseReason(unit) then
        return false;
    end

    if not ( IsInRaid() and UnitIsConnected(unit) ) then
        return;
    end

    for i = 1, GetRealNumRaidMembers() do
        local name, rank, subgroup, level, class, fileName, zone = GetRaidRosterInfo(i);
        if ( name == UnitName(unit) ) then
            return not C_Map.IsWorldMap(zone);
        end
    end

end

function GetTexCoordsForRoleSmallCircle(role)
    if ( role == "TANK" ) then
        return 0, 19/64, 22/64, 41/64;
    elseif ( role == "HEALER" ) then
        return 20/64, 39/64, 1/64, 20/64;
    elseif ( role == "DAMAGER" ) then
        return 20/64, 39/64, 22/64, 41/64;
    else
        error("Unknown role: "..tostring(role));
    end
end

function CooldownFrame_Clear(self)
    self:Hide();
end

Enum = Enum or {};
Enum.SummonStatus = {
    None = 0,
    Pending = 1,
    Accepted = 2,
    Declined = 3
};

Enum.PhaseReason = {
    Phasing = 0,
    Sharding = 1,
    WarMode = 2,
    ChromieTime = 3
};

C_IncomingSummon = C_IncomingSummon or {};
C_IncomingSummon.HasIncomingSummon = function(unit)
    return false;
end

C_IncomingSummon.IncomingSummonStatus = function(unit)
    return 0;
end


C_PartyInfo = C_PartyInfo or {};

do

    local countdownTicker;
    C_PartyInfo.DoCountdown = function(count)
        if ( countdownTicker ) then
            return;
        end

        local channel = IsInRaid() and "RAID_WARNING" or "PARTY";
        local countdown = count;

        local func = function()
            local timer = string.format(COMPACT_UNIT_FRAME_COUNTDOWN_START, countdown);
            local now = COMPACT_UNIT_FRAME_COUNTDOWN_NOW;
            if ( countdown == 0 ) then
                countdownTicker = nil;
            end
            SendChatMessage(countdown > 0 and timer or now, channel);
            countdown = countdown - 1;
        end

        countdownTicker = C_Timer.NewTicker(1, func, count + 1)
    end

    local isAllAssistant = false;
    function IsEveryoneAssistant()
        return isAllAssistant;
    end

    CUF_SET_ASSIST_DELAY = 0.15;

    local assistantTicker;
    function SetEveryoneIsAssistant(enable)
        if ( assistantTicker ) then
            assistantTicker:Cancel();
            assistantTicker = nil;
        end

        local index = 1;
        local numMembers = GetRealNumRaidMembers();

        local func = function()
            local unit = "raid"..index;
            if ( IsEveryoneAssistant() ) then
                PromoteToAssistant(unit);
            else
                DemoteAssistant(unit);
            end
            index = index + 1;
        end

        isAllAssistant = enable;
        assistantTicker = C_Timer.NewTicker(CUF_SET_ASSIST_DELAY, func, numMembers);
    end

end

local function HidePartyFrame()
    for i=1, MAX_PARTY_MEMBERS, 1 do
        _G["PartyMemberFrame"..i]:SetAlpha(0);
        _G["PartyMemberFrame"..i]:Hide();
        _G["PartyMemberFrame"..i]:UnregisterAllEvents();
    end
end

local function ShowPartyFrame()
    for i=1, MAX_PARTY_MEMBERS, 1 do
        if ( UnitExists("party"..i) ) then
            _G["PartyMemberFrame"..i]:SetAlpha(1);
            _G["PartyMemberFrame"..i]:Show();
            PartyMemberFrame_OnLoad(_G["PartyMemberFrame"..i]);
        end
    end
end

function RaidOptionsFrame_UpdatePartyFrames()
    if ( InCombatLockdown() ) then
        return;
    end
    if ( GetDisplayedAllyFrames() ~= "party" ) then
        HidePartyFrame();
    else
        HidePartyFrame();
        ShowPartyFrame();
    end
    UpdatePartyMemberBackground();
end

local LibGT      = LibStub:GetLibrary("LibGroupTalents-1.0");
local LibAbsorb  = LibStub:GetLibrary("SpecializedAbsorbs-1.0");
local HealComm   = LibStub:GetLibrary("LibHealComm-4.0");
local LibAura    = LibStub:GetLibrary("LibCUFAuras-1.0");
local LibResComm = LibStub:GetLibrary("LibResComm-1.0");

do

    local function CompactUnitFrame_FireEvent(self, event)
        CompactUnitFrame_OnEvent(self, event, self.unit or self.displayedUnit);
    end

    local function LibEventCallback(self, event, ... )
        local arg1, arg2, arg3, arg4, arg5 = ...;
        if ( not UnitExists(self.unit) ) then
            return;
        end

        if ( event == "LibGroupTalents_RoleChange" ) then
            CompactUnitFrame_FireEvent(self, "PLAYER_ROLES_ASSIGNED");
        elseif ( event == "ResComm_ResStart" and arg3 == UnitName(self.unit) ) then
            CompactUnitFrame_FireEvent(self, "INCOMING_RESURRECT_CHANGED");
        elseif ( event == "ResComm_ResEnd" and arg2 == UnitName(self.unit) ) then
            CompactUnitFrame_FireEvent(self, "INCOMING_RESURRECT_CHANGED");
        elseif ( event == "EffectApplied" and arg3 == UnitGUID(self.unit) ) then
            CompactUnitFrame_FireEvent(self, "UNIT_HEAL_ABSORB_AMOUNT_CHANGED");
        else
            local unitMatches = arg1 == UnitGUID(self.unit) or arg5 == UnitGUID(self.unit);
            if ( unitMatches ) then
                if ( event == "HealComm_HealUpdated" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_PREDICTION");
                elseif ( event == "HealComm_HealStarted" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_PREDICTION");
                elseif ( event == "HealComm_HealDelayed" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_PREDICTION");
                elseif ( event == "HealComm_HealStopped" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_PREDICTION");
                elseif ( event == "HealComm_ModifierChanged" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_PREDICTION");
                elseif ( event == "HealComm_GUIDDisappeared" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_PREDICTION");
                elseif ( event == "UnitUpdated" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_ABSORB_AMOUNT_CHANGED");
                elseif ( event == "EffectRemoved" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_ABSORB_AMOUNT_CHANGED");
                elseif ( event == "UnitCleared" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_ABSORB_AMOUNT_CHANGED");
                elseif ( event == "AreaCreated" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_ABSORB_AMOUNT_CHANGED");
                elseif ( event == "AreaCleared" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_ABSORB_AMOUNT_CHANGED");
                elseif ( event == "UnitAbsorbed" ) then
                    CompactUnitFrame_FireEvent(self, "UNIT_HEAL_ABSORB_AMOUNT_CHANGED");
                elseif ( event == "COMPACT_UNIT_FRAME_UNIT_AURA" ) then
                    CompactUnitFrame_FireEvent(self, "COMPACT_UNIT_FRAME_UNIT_AURA");
                end
            end
        end
    end

    function CompactUnitFrame_RegisterCallback(self)
        LibGT.RegisterCallback(self, "LibGroupTalents_RoleChange", LibEventCallback, self);

        LibAbsorb.RegisterCallback(self, "EffectApplied", LibEventCallback, self);
        LibAbsorb.RegisterCallback(self, "EffectUpdated", LibEventCallback, self);
        LibAbsorb.RegisterCallback(self, "EffectRemoved", LibEventCallback, self);
        LibAbsorb.RegisterCallback(self, "UnitUpdated", LibEventCallback, self);
        LibAbsorb.RegisterCallback(self, "UnitCleared", LibEventCallback, self);
        LibAbsorb.RegisterCallback(self, "AreaCreated", LibEventCallback, self);
        LibAbsorb.RegisterCallback(self, "AreaCleared", LibEventCallback, self);
        LibAbsorb.RegisterCallback(self, "UnitAbsorbed", LibEventCallback, self);

        HealComm.RegisterCallback(self, "HealComm_HealStarted", LibEventCallback, self);
        HealComm.RegisterCallback(self, "HealComm_HealUpdated", LibEventCallback, self);
        HealComm.RegisterCallback(self, "HealComm_HealDelayed", LibEventCallback, self);
        HealComm.RegisterCallback(self, "HealComm_HealStopped", LibEventCallback, self);
        HealComm.RegisterCallback(self, "HealComm_ModifierChanged", LibEventCallback, self);
        HealComm.RegisterCallback(self, "HealComm_GUIDDisappeared", LibEventCallback, self);

        LibAura.RegisterCallback(self, "COMPACT_UNIT_FRAME_UNIT_AURA", LibEventCallback, self);

        LibResComm.RegisterCallback(self, "ResComm_CanRes", LibEventCallback, self)
        LibResComm.RegisterCallback(self, "ResComm_Ressed", LibEventCallback, self)
        LibResComm.RegisterCallback(self, "ResComm_ResExpired", LibEventCallback, self)
        LibResComm.RegisterCallback(self, "ResComm_ResStart", LibEventCallback, self)
        LibResComm.RegisterCallback(self, "ResComm_ResEnd", LibEventCallback, self)
    end

end

do
    local function LibEventCallback(self, event, ... )
        if ( event == "LibGroupTalents_RoleChange" ) then
            CompactRaidFrameManager_OnEvent(self, "UPDATE_ACTIVE_BATTLEFIELD");
        end
    end

    function CompactRaidFrameManager_RegisterCallback(self)
        LibGT.RegisterCallback(self, "LibGroupTalents_RoleChange", LibEventCallback, self);
    end
end

function UnitHasIncomingResurrection(unit)
    if not ( unit and LibResComm ) then
        return;
    end

    return LibResComm:IsUnitBeingRessed(UnitName(unit));
end

function UnitGetIncomingHeals(unit, healer)
    if not ( unit and HealComm ) then
        return;
    end

    if ( healer ) then
        return HealComm:GetCasterHealAmount(UnitGUID(healer), HealComm.CASTED_HEALS, GetTime() + 5);
    else
        return HealComm:GetHealAmount(UnitGUID(unit), HealComm.ALL_HEALS, GetTime() + 5);
    end
end

function UnitGetTotalAbsorbs(unit)
    if not ( unit and LibAbsorb ) then
        return;
    end

    return LibAbsorb.UnitTotal(UnitGUID(unit));
end

function UnitGetTotalHealAbsorbs(unit) -- there is nothing like this in the WotLK patch
    return 0;
end

local LibGTConvertRole = {
    ["melee"]   = "DAMAGER",
    ["caster"]  = "DAMAGER",
    ["healer"]  = "HEALER",
    ["tank"]    = "TANK",
};

function GetSpecializationRole(specIndex)
    if ( not LibGT ) then
        return "NONE";
    end

    return LibGTConvertRole[LibGT:GetUnitRole("player")] or "NONE";
end

function UnitGroupRoles(unit)
    local role;
    -- For 3.3.5 roles are assigned only for LFG, so the API UnitGroupRolesAssigned works only for LFG
    -- For LFG, do not need to use third-party methods to define a role that is not always defined correctly.
    local isTank, isHealer, isDamage = UnitGroupRolesAssigned(unit);
    if ( isTank ) then
        role = "TANK";
    elseif ( isHealer ) then
        role = "HEALER";
    elseif ( isDamage ) then
        role = "DAMAGER";
    else
        -- It makes no sense to use third-party methods to define a role if the role of this class is only one.
        local _,class = UnitClass(unit);
        local damager = class == "HUNTER" or class == "ROGUE" or class == "MAGE" or class == "WARLOCK";
        if ( damager ) then
            role = "DAMAGER";
        elseif ( LibGT ) then
            role = LibGTConvertRole[LibGT:GetUnitRole(unit)];
        end
    end

    return role or "NONE";
end

function UnitShouldDisplayName(unitToken)
    return unitToken;
end

function UnitNameplateShowsWidgetsOnly(unitToken)
    return not unitToken;
end

function SpellIsPriorityAura(spellId)
    if ( not LOSS_OF_CONTROL_STORAGE ) then
        return false;
    end

    return LOSS_OF_CONTROL_STORAGE[spellId] and true;
end

function SpellIsSelfBuff(spellId)
    local info = LibAura:SpellIsSelfBuff(spellId)
    if ( not info ) then
        return false;
    end

    return info.appliesOnlyYourself;
end

function SpellGetVisibilityInfo(spellId, visType)
    if ( not LibAura ) then
        return false;
    end

    return LibAura:SpellGetVisibilityInfo(spellId, visType)
end

function UnitAuraBySlot(unit, slot)
    if not ( unit and LibAura ) then
        return;
    end

    return LibAura:UnitAuraBySlot(unit, slot);
end

function UnitAuraSlots(unit, filter, maxCount, continuationToken)
    if not ( unit and LibAura ) then
        return;
    end

    return LibAura:UnitAuraSlots(unit, filter, maxCount, continuationToken);
end

------------------------------------------------------------------------------------
StaticPopupDialogs["CUF_CLICK_LINK_CLICKURL"] = {
    text = COMPACT_UNIT_FRAME_STATIC_POPUP_TEXT,
    button1 = "OK",
    timeout = 0,
    hasEditBox = true,
    hasWideEditBox = true,
    OnShow = function (self, data)
        local EditBox = _G[this:GetName().."WideEditBox"];
        if ( EditBox ) then
            EditBox:SetText("https://discord.gg/wXw6pTvxMQ");
            EditBox:SetFocus();
            EditBox:HighlightText();
            EditBox:ClearAllPoints();
            EditBox:SetPoint("BOTTOM", self, "BOTTOM", 0, 25);
        end
    end,
};

local function GetAddonVerseion(value)
    local num1, num2, num3 = string.match(value, "(%d+)[^%d]+(%d+)[^%d]+(%d+)");
    return tonumber(num1..num2..num3);
end

local function VersionConflict_OnEvent(_, _, addon)
    if ( addon ~= "WeakAuras" ) then
        return;
    end

    local value  = GetAddOnMetadata("WeakAuras", "Version");
    local number = GetAddonVerseion(value);
    if ( number < 321 ) then
        StaticPopup_Show("CUF_CLICK_LINK_CLICKURL");
    end
end

local VersionConflict = CreateFrame("Frame");
VersionConflict:RegisterEvent("ADDON_LOADED");
VersionConflict:SetScript("OnEvent", VersionConflict_OnEvent);
