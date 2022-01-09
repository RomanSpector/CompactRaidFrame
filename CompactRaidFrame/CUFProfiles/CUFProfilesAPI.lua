local CompactRaidFrame = LibStub("AceAddon-3.0"):NewAddon("CompactRaidFrame", "AceConsole-3.0", "AceEvent-3.0");
_G["CompactRaidFrame"] = CompactRaidFrame;
local AceDB = LibStub("AceDB-3.0");

local PROFILES, CUF_CONFIG;
local SAVED_PROFILE = { };
local MAX_CUF_PROFILES = 5;

local DEFAULT_PROFILE = {
	name = DEFAULT_CUF_PROFILE_NAME,
	isDynamic = true,

	shown = true,
	locked = true,
	keepGroupsTogether = false,
	horizontalGroups = false,
	sortBy = "group",
	displayHealPrediction = true,
	displayPowerBar = false,
	displayAggroHighlight = true,
	useClassColors = false,
	displayPets = false,
	displayMainTankAndAssist = true,
	displayBorder = true,
	displayNonBossDebuffs = true,
	displayOnlyDispellableDebuffs = false,
	healthText = "none",
	frameWidth = 72,
	frameHeight = 36,
	autoActivate2Players = false,
	autoActivate3Players = false,
	autoActivate5Players = false,
	autoActivate10Players = false,
	autoActivate15Players = false,
	autoActivate25Players = false,
	autoActivate40Players = false,
	autoActivatePvP = false,
	autoActivatePvE = false,
};

local FLATTENDED_OPTIONS = {
	["locked"] = 0,
	["shown"] = 0,
	["keepGroupsTogether"] = 1,
	["horizontalGroups"] = 1,
	["sortBy"] = 1,
	["displayHealPrediction"] = 1,
	["displayPowerBar"] = 1,
	["displayAggroHighlight"] = 1,
	["useClassColors"] = 1,
	["displayPets"] = 1,
	["displayMainTankAndAssist"] = 1,
	["displayBorder"] = 1,
	["displayNonBossDebuffs"] = 1,
	["displayOnlyDispellableDebuffs"] = 0,
	["healthText"] = 1,
	["frameWidth"] = 1,
	["frameHeight"] = 1,
	["autoActivate2Players"] = 1,
	["autoActivate3Players"] = 1,
	["autoActivate5Players"] = 1,
	["autoActivate10Players"] = 1,
	["autoActivate15Players"] = 1,
	["autoActivate25Players"] = 1,
	["autoActivate40Players"] = 1,
	["autoActivatePvP"] = 1,
	["autoActivatePvE"] = 1,
};

function CompactRaidFrame:OnInitialize()
    self.db = AceDB:New("CompactRaidFrameDB");
	self.db.char.cvar = self.db.char.cvar or {};
	self.db.char.profile = self.db.char.profile or {};
	PROFILES = self.db.char.profile;
	CUF_CONFIG = self.db.char.cvar;

	if ( not ROMANSPECTOR_DISCORD ) then
		ROMANSPECTOR_DISCORD = true;
		DEFAULT_CHAT_FRAME:AddMessage("|cffbaf5aeCompactRaidFrame|r: Join my Discord |cff44d3e3https://discord.gg/wXw6pTvxMQ|r");
	end

	CompactUnitFrameProfiles_OnEvent(CompactUnitFrameProfiles, "COMPACT_UNIT_FRAME_PROFILES_LOADED");
end

function CUFGetNumRaidProfiles()
	if ( not PROFILES ) then
		return 0;
	end

	return #PROFILES;
end

function CUFGetRaidProfileName(index)
	if ( not PROFILES or not index ) then
		return;
	end

	if PROFILES[index] then
		return PROFILES[index].name;
	end
end

function CUFRaidProfileExists(profile)
	if ( not PROFILES or not profile ) then
		return;
	end

	for _, profileData in ipairs(PROFILES) do
		if ( profileData.name == profile ) then
			return true;
		end
	end
end

function HasLoadedCUFProfiles()
	return PROFILES and true or false;
end

function CUFRaidProfileHasUnsavedChanges()
	if not ( PROFILES and SAVED_PROFILE ) then
		return;
	end


	for _, profileData in ipairs(PROFILES) do
		if ( profileData.name == SAVED_PROFILE.name ) then
			for option, noIgnore in pairs(FLATTENDED_OPTIONS) do
				if ( noIgnore == 1 and profileData[option] ~= SAVED_PROFILE[option] ) then
					return true;
				end
			end
		end
	end

end

function CUFRestoreRaidProfileFromCopy()
	if ( not SAVED_PROFILE ) then
		return;
	end

	for _, profileData in ipairs(PROFILES) do
		if ( profileData.name == SAVED_PROFILE.name ) then
			for option, noIgnore in pairs(FLATTENDED_OPTIONS) do
				if ( noIgnore == 1 and profileData[option] ~= SAVED_PROFILE[option] ) then
					profileData[option] = SAVED_PROFILE[option];
				end
			end
		end
	end
end

function CUFCreateNewRaidProfile(name, baseOnProfile)
	if ( not PROFILES or not name ) then
		return;
	end

	local profile
	if ( baseOnProfile and baseOnProfile ~= DEFAULTS ) then
		for _, profileData in ipairs(PROFILES) do
			if ( profileData.name == baseOnProfile ) then
				profile = CopyTable(profileData);
				break;
			end
		end
	else
		profile = CopyTable(DEFAULT_PROFILE);
	end

	profile.name = name;
	table.insert(PROFILES, profile);
end

function CUFDeleteRaidProfile(profile)
	if ( not PROFILES or not profile ) then
		return;
	end

	if ( type(profile) == "number" ) then
		table.remove(PROFILES, profile);
	else
		for index, profileData in ipairs(PROFILES) do
			if ( profileData.name == profile ) then
				table.remove(PROFILES, index);
				break;
			end
		end
	end
end

function CUFSaveRaidProfileCopy(profile)
	if ( not PROFILES or not profile ) then
		return;
	end

	for _, profileData in ipairs(PROFILES) do
		if ( profileData.name == profile ) then
			SAVED_PROFILE = CopyTable(profileData);
			break;
		end
	end
end

function CUFSetRaidProfileOption(profile, optionName, value)
	if ( not PROFILES or not profile or not optionName ) then
		return;
	end

	for index, profileData in ipairs(PROFILES) do
		if ( profileData.name == profile ) then
			PROFILES[index][optionName] = value;
			break;
		end
	end
end

function CUFGetRaidProfileOption(profile, optionName)
	if ( not PROFILES or not profile or not optionName ) then
		return;
	end

	for _, profileData in ipairs(PROFILES) do
		if ( profileData.name == profile ) then
			return profileData[optionName];
		end
	end
end

function CUFGetRaidProfileFlattenedOptions(profile)
	if ( not PROFILES or not profile ) then
		return;
	end

	for _, profileData in ipairs(PROFILES) do
		if ( profileData.name == profile ) then
			local flattenedOptions = {};
			for option, value in pairs(profileData) do
				if FLATTENDED_OPTIONS[option] then
					flattenedOptions[option] = value;
				end
			end
			return flattenedOptions;
		end
	end
end

function CUFSetRaidProfileSavedPosition(profile, isDynamic, topPoint, topOffset, bottomPoint, bottomOffset, leftPoint, leftOffset)
	if ( not PROFILES or not profile ) then
		return;
	end

	for _, profileData in ipairs(PROFILES) do
		if ( profileData.name == profile ) then
			profileData.isDynamic = isDynamic;
			profileData.topPoint = topPoint;
			profileData.topOffset = topOffset;
			profileData.bottomPoint = bottomPoint;
			profileData.bottomOffset = bottomOffset;
			profileData.leftPoint = leftPoint;
			profileData.leftOffset = leftOffset;
			break;
		end
	end
end

function CUFGetRaidProfileSavedPosition(profile)
	if ( not PROFILES or not profile ) then
		return;
	end

	for _, profileData in ipairs(PROFILES) do
		if ( profileData.name == profile ) then
			return profileData.isDynamic, profileData.topPoint, profileData.topOffset, profileData.bottomPoint, profileData.bottomOffset, profileData.leftPoint, profileData.leftOffset;
		end
	end
end

function GetMaxNumCUFProfiles()
	return MAX_CUF_PROFILES;
end

function CUFSetActiveRaidProfile(profile)
	CUF_CVar:SetValue("CVAR_SET_ACTIVE_CUF_PROFILE", profile);
end

function CUFGetActiveRaidProfile()
	return CUF_CVar:GetValue("CVAR_SET_ACTIVE_CUF_PROFILE");
end

CUF_CVar = {}
function CUF_CVar:SetValue(cvar, value)
	if ( not CUF_CONFIG ) then
		return;
	end

	CUF_CONFIG[cvar] = value;
end

function CUF_CVar:GetValue(cvar, addon)
	if ( not CUF_CONFIG ) then
		return;
	end

	return CUF_CONFIG[cvar];
end

function CUF_CVar:GetCVarBool(cvar)
	return self:GetValue(cvar) == "1" and true or false
end
