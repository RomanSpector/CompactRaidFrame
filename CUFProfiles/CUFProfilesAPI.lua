--[[
This is a demo version of the addon!
All saved settings will be erased after the session ends or the interface is restarted, and profiles will not work.

To get the full version of the addon, you can contact me in discord https://discord.gg/mQEmyP4HXZ

Это демо версия аддон!
Все сохраненные настройки будут стираться после завершения сеанса или перезагрузки интерфейса, а также не будет работать профили.

Чтобы получить полную версию аддона, вы можете связаться со мной в дискорде https://discord.gg/mQEmyP4HXZ
]]
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
	["healthText"] = 0,
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

function GetNumRaidProfiles()
	return 0;
end

function GetRaidProfileName()
	return DEFAULT_CUF_PROFILE_NAME
end

function RaidProfileExists()
	return false;
end

function HasLoadedCUFProfiles()
	return true;
end

function RaidProfileHasUnsavedChanges()
	
end

function CreateNewRaidProfile()

end

function DeleteRaidProfile()

end

function SaveRaidProfileCopy()

end

function SetRaidProfileOption(_, optionName, value)
	DEFAULT_PROFILE[optionName] = value;
end

function GetRaidProfileOption(_, optionName)
	return DEFAULT_PROFILE[optionName];
end

function GetRaidProfileFlattenedOptions()
	return DEFAULT_PROFILE;
end

function SetRaidProfileSavedPosition()

end

function GetRaidProfileSavedPosition()
	return true
end

function GetMaxNumCUFProfiles()
	return MAX_CUF_PROFILES;
end

function SetActiveRaidProfile()

end

function GetActiveRaidProfile()
	return DEFAULT_CUF_PROFILE_NAME;
end

C_CVar = C_CVar or {}
function C_CVar:SetValue()

end

function C_CVar:GetValue()
	return "1";
end

function C_CVar:GetCVarBool()
	return true;
end