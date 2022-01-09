
function CompactUnitFrameProfiles_OnLoad(self)
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
	self:RegisterEvent("PARTY_MEMBERS_CHANGED");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("RAID_ROSTER_UPDATE");

	--Get this working with the InterfaceOptions panel.
	self.name = COMPACT_UNIT_FRAME_PROFILES_LABEL;
	self.options = {
		useCompactPartyFrames = { text = "USE_RAID_STYLE_PARTY_FRAMES" },
	}

	BlizzardOptionsPanel_OnLoad(self, CompactUnitFrameProfiles_SaveChanges, CompactUnitFrameProfiles_CancelCallback, CompactUnitFrameProfiles_DefaultCallback, CompactUnitFrameProfiles_UpdateCurrentPanel);
	InterfaceOptions_AddCategory(self);
end

function CompactUnitFrameProfiles_OnEvent(self, event, ...)
	--Do normal BlizzardOptionsPanel code too.
	--BlizzardOptionsPanel_OnEvent(self, event, ...);
	if ( event == "COMPACT_UNIT_FRAME_PROFILES_LOADED" ) then
		--HasLoadedCUFProfiles will now return true.
		self:UnregisterEvent(event);
		CompactUnitFrameProfiles_ValidateProfilesLoaded(self);
	elseif ( event == "VARIABLES_LOADED" ) then
		self.variablesLoaded = true;
		self:UnregisterEvent(event);
		CompactUnitFrameProfiles_ValidateProfilesLoaded(self);
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then	--Check for zoning
		CompactUnitFrameProfiles_CheckAutoActivation();
	elseif ( event == "PLAYER_SPECIALIZATION_CHANGED" ) then	--Check for changing specs
		CompactUnitFrameProfiles_CheckAutoActivation();
	elseif ( event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" or event == "PLAYER_REGEN_ENABLED" ) then
		CompactUnitFrameProfiles_CheckAutoActivation();
	end
end

function CompactUnitFrameProfiles_ValidateProfilesLoaded(self)
	if ( HasLoadedCUFProfiles() and self.variablesLoaded ) then
		if ( CUFRaidProfileExists(CUFGetActiveRaidProfile()) ) then
			CompactUnitFrameProfiles_ActivateRaidProfile(CUFGetActiveRaidProfile());
		elseif ( CUFGetNumRaidProfiles() == 0 ) then	--If we don't have any profiles, we need to create a new one.
			CompactUnitFrameProfiles_ResetToDefaults();
		else
			CompactUnitFrameProfiles_ActivateRaidProfile(CUFGetRaidProfileName(1));
		end
	end
end

function CompactUnitFrameProfiles_DefaultCallback(self)
	CompactUnitFrameProfiles_ResetToDefaults();
end

function CompactUnitFrameProfiles_ResetToDefaults()
	local profiles = {};
	for i=1, CUFGetNumRaidProfiles() do
		tinsert(profiles, CUFGetRaidProfileName(i));
	end
	for i=1, #profiles do
		CUFDeleteRaidProfile(profiles[i]);
	end
	CUFCreateNewRaidProfile(DEFAULT_CUF_PROFILE_NAME);
	CompactUnitFrameProfiles_ActivateRaidProfile(DEFAULT_CUF_PROFILE_NAME);
end

function CompactUnitFrameProfiles_SaveChanges(self)
	CUFSaveRaidProfileCopy(self.selectedProfile);	--Save off the current version in case we cancel.
	CompactUnitFrameProfiles_UpdateManagementButtons();
end

function CompactUnitFrameProfiles_CancelCallback(self)
	CompactUnitFrameProfiles_CancelChanges(self);
end

function CompactUnitFrameProfiles_CancelChanges(self)
	CUFRestoreRaidProfileFromCopy();
	CompactUnitFrameProfiles_UpdateCurrentPanel();
	CompactUnitFrameProfiles_ApplyCurrentSettings();
end

function CompactUnitFrameProfilesNewProfileDialogBaseProfileSelector_SetUp(self)
	UIDropDownMenu_SetWidth(self, 190);
	UIDropDownMenu_Initialize(self, CompactUnitFrameProfilesNewProfileDialogBaseProfileSelector_Initialize);
end

function CompactUnitFrameProfilesNewProfileDialogBaseProfileSelector_Initialize()
	local info = UIDropDownMenu_CreateInfo();

	info.text = DEFAULTS;
	info.disabled  = UnitAffectingCombat("player");
	info.value = nil;
	info.func = CompactUnitFrameProfilesNewProfileDialogBaseProfileSelectorButton_OnClick;
	info.checked = CompactUnitFrameProfiles.newProfileDialog.baseProfile == info.value;
	info.isRadio = true;
	UIDropDownMenu_AddButton(info);

	for i=1, CUFGetNumRaidProfiles() do
		local name = CUFGetRaidProfileName(i);
		info.text = name;
		info.disabled  = UnitAffectingCombat("player");
		info.value = name;
		info.func = CompactUnitFrameProfilesNewProfileDialogBaseProfileSelectorButton_OnClick;
		info.checked = CompactUnitFrameProfiles.newProfileDialog.baseProfile == info.value;
		UIDropDownMenu_AddButton(info);
	end
end

function CompactUnitFrameProfilesNewProfileDialogBaseProfileSelectorButton_OnClick(self)
	CompactUnitFrameProfiles.newProfileDialog.baseProfile = self.value;
	UIDropDownMenu_SetSelectedValue(CompactUnitFrameProfilesNewProfileDialogBaseProfileSelector, self.value);
end

function CompactUnitFrameProfilesProfileSelector_SetUp(self)
	UIDropDownMenu_SetWidth(self, 190);
	UIDropDownMenu_Initialize(self, CompactUnitFrameProfilesProfileSelector_Initialize);
	--UIDropDownMenu_SetSelectedValue(self, CUFGetActiveRaidProfile());
end

function CompactUnitFrameProfilesProfileSelector_Initialize()
	local info = UIDropDownMenu_CreateInfo();
	for i=1, CUFGetNumRaidProfiles() do 
		local name = CUFGetRaidProfileName(i);
		info.text = name;
		info.disabled  = UnitAffectingCombat("player");
		info.func = CompactUnitFrameProfilesProfileSelectorButton_OnClick;
		info.value = name;
		info.checked = CompactUnitFrameProfiles.selectedProfile == name;
		info.isRadio = true;
		UIDropDownMenu_AddButton(info);
	end

	info.text = NEW_COMPACT_UNIT_FRAME_PROFILE;
	info.disabled  = UnitAffectingCombat("player");
	info.func = CompactUnitFrameProfiles_NewProfileButtonClicked;
	info.value = nil;
	info.checked = false;
	info.notCheckable = true;
	info.disabled = CUFGetNumRaidProfiles() >= GetMaxNumCUFProfiles();
	info.isRadio = true;
	UIDropDownMenu_AddButton(info);
end

function CompactUnitFrameProfilesProfileSelectorButton_OnClick(self)
	if ( CUFRaidProfileHasUnsavedChanges() ) then
		CompactUnitFrameProfiles_ConfirmUnsavedChanges("select", self.value);
	else
		CompactUnitFrameProfiles_ActivateRaidProfile(self.value);
	end
end

function CompactUnitFrameProfiles_NewProfileButtonClicked()
	if ( CUFRaidProfileHasUnsavedChanges() ) then
		CompactUnitFrameProfiles_ConfirmUnsavedChanges("new");
	else
		CompactUnitFrameProfiles_ShowNewProfileDialog();
	end
end

function CompactUnitFrameProfiles_ActivateRaidProfile(profile)
	CompactUnitFrameProfiles.selectedProfile = profile;
	CUFSaveRaidProfileCopy(profile);	--Save off the current version in case we cancel.
	CUFSetActiveRaidProfile(profile);
	UIDropDownMenu_SetSelectedValue(CompactUnitFrameProfilesProfileSelector, profile);
	UIDropDownMenu_SetText(CompactUnitFrameProfilesProfileSelector, profile);
	UIDropDownMenu_SetSelectedValue(CompactRaidFrameManagerDisplayFrameProfileSelector, profile);
	UIDropDownMenu_SetText(CompactRaidFrameManagerDisplayFrameProfileSelector, profile);

	CompactUnitFrameProfiles_HidePopups();
	CompactUnitFrameProfiles_UpdateCurrentPanel();
	CompactUnitFrameProfiles_ApplyCurrentSettings();
end

function CompactUnitFrameProfiles_ApplyCurrentSettings()
	CompactUnitFrameProfiles_ApplyProfile(CUFGetActiveRaidProfile());
end

function CompactUnitFrameProfiles_UpdateCurrentPanel()
	local panel = CompactUnitFrameProfiles.optionsFrame;
	for i=1, #panel.optionControls do
		panel.optionControls[i]:updateFunc();
	end
	CompactUnitFrameProfiles_UpdateManagementButtons();
	CompactUnitFrameProfile_UpdateAutoActivationDisabledLabel();
end

function CompactUnitFrameProfiles_CreateProfile(profileName)
	CUFCreateNewRaidProfile(profileName, CompactUnitFrameProfiles.newProfileDialog.baseProfile);
	CompactUnitFrameProfiles_ActivateRaidProfile(profileName);
end

function CompactUnitFrameProfiles_UpdateNewProfileCreateButton()
	local button = CompactUnitFrameProfiles.newProfileDialog.createButton;
	local text = strtrim(CompactUnitFrameProfiles.newProfileDialog.editBox:GetText());

	if ( text == "" or CUFRaidProfileExists(text) or strlower(text) == strlower(DEFAULTS) ) then
		button:Disable();
	else
		button:Enable();
	end
end

function CompactUnitFrameProfiles_HideNewProfileDialog()
	CompactUnitFrameProfiles.newProfileDialog:Hide();
end

function CompactUnitFrameProfiles_ShowNewProfileDialog()
	UIDropDownMenu_SetSelectedValue(CompactUnitFrameProfilesNewProfileDialogBaseProfileSelector, nil);
	UIDropDownMenu_SetText(CompactUnitFrameProfilesNewProfileDialogBaseProfileSelector, DEFAULTS);
	CompactUnitFrameProfiles.newProfileDialog.baseProfile = nil;
	CompactUnitFrameProfiles.newProfileDialog:Show();
	CompactUnitFrameProfiles.newProfileDialog.editBox:SetText("");
	CompactUnitFrameProfiles.newProfileDialog.editBox:SetFocus();
	CompactUnitFrameProfiles_UpdateNewProfileCreateButton();
end

function CompactUnitFrameProfiles_ConfirmProfileDeletion(profile)
	CompactUnitFrameProfiles.deleteProfileDialog.profile = profile;
	CompactUnitFrameProfiles.deleteProfileDialog.label:SetFormattedText(CONFIRM_COMPACT_UNIT_FRAME_PROFILE_DELETION, profile);
	CompactUnitFrameProfiles.deleteProfileDialog:Show();
end

function CompactUnitFrameProfiles_UpdateManagementButtons()
	if ( CUFGetNumRaidProfiles() <= 1 ) then
		CompactUnitFrameProfilesDeleteButton:Disable();
	else
		CompactUnitFrameProfilesDeleteButton:Enable();
	end

	if CUFRaidProfileHasUnsavedChanges() then 
		CompactUnitFrameProfilesSaveButton:Enable();
	else
		CompactUnitFrameProfilesSaveButton:Disable();
	end
end

function CompactUnitFrameProfiles_ConfirmUnsavedChanges(action, profileArg)
	CompactUnitFrameProfiles.unsavedProfileDialog.action = action;
	CompactUnitFrameProfiles.unsavedProfileDialog.profile = profileArg;
	CompactUnitFrameProfiles.unsavedProfileDialog.label:SetFormattedText(CONFIRM_COMPACT_UNIT_FRAME_PROFILE_UNSAVED_CHANGES, CompactUnitFrameProfiles.selectedProfile);
	CompactUnitFrameProfiles.unsavedProfileDialog:Show();
end

function CompactUnitFrameProfiles_AfterConfirmUnsavedChanges()
	local action = CompactUnitFrameProfiles.unsavedProfileDialog.action;
	local profileArg = CompactUnitFrameProfiles.unsavedProfileDialog.profile;
	if ( action == "select" ) then
		CompactUnitFrameProfiles_ActivateRaidProfile(profileArg);
	elseif ( action == "new" ) then
		CompactUnitFrameProfiles_ShowNewProfileDialog();
	end
end

function CompactUnitFrameProfiles_HidePopups()
	CompactUnitFrameProfiles.newProfileDialog:Hide();
	CompactUnitFrameProfiles.deleteProfileDialog:Hide();
	CompactUnitFrameProfiles.unsavedProfileDialog:Hide();
end

local autoActivateGroupSizes = { 2, 3, 5, 10, 15, 25, 40 };
local countMap = {};	--Maps number of players to the category. (For example, so that AQ20 counts as a 25-man.)

for i, autoActivateGroupSize in ipairs(autoActivateGroupSizes) do
	local groupSizeStart = i > 1 and (autoActivateGroupSizes[i - 1] + 1) or 1;
	for groupSize = groupSizeStart, autoActivateGroupSize do
		countMap[groupSize] = autoActivateGroupSize;
	end
end

function CompactUnitFrameProfiles_GetAutoActivationState()
	local name, instanceType, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo();
	if ( not name ) then	--We don't have info.
		return false;
	end

	local numPlayers, profileType, enemyType;

	if ( instanceType == "party" or instanceType == "raid" ) then
		numPlayers = maxPlayers > 0 and countMap[maxPlayers] or 5;
		profileType = instanceType;
		enemyType = "PvE";
	elseif ( instanceType == "arena" ) then
		numPlayers = countMap[CUFGetNumGroupMembers()];
		profileType = instanceType;
		enemyType = "PvP";
	elseif ( instanceType == "pvp" ) then
		if ( false ) then -- IsRatedBattleground()
			numPlayers = 10;
		else
			numPlayers = countMap[CUFGetMaxUnitNumberBattleground()]; -- временно maxPlayers
		end

		profileType = instanceType;
		enemyType = "PvP";
	else
		numPlayers = countMap[CUFGetNumGroupMembers()];
		profileType = "world";
		enemyType = "PvE";
	end

	if ( not numPlayers ) then
		return false;
	end

	return true, numPlayers, profileType, enemyType;
end

local checkAutoActivationTimer;
function CompactUnitFrameProfiles_CheckAutoActivation()
	--We only want to adjust the profile when you 1) Zone or 2) change specs. We don't want to automatically
	--change the profile when you are in the uninstanced world.
	if ( not CUFIsInGroup() ) then
		CompactUnitFrameProfiles_SetLastActivationType(nil, nil, nil, nil);
		return;
	end

	local success, numPlayers, activationType, enemyType = CompactUnitFrameProfiles_GetAutoActivationState();

	if ( not success ) then
		--We didn't have all the relevant info yet. Update again soon.
		if ( checkAutoActivationTimer ) then
			checkAutoActivationTimer:Cancel();
		end
		checkAutoActivationTimer = C_Timer.NewTimer(3, CompactUnitFrameProfiles_CheckAutoActivation);
		return;
	else
		if ( checkAutoActivationTimer ) then
			checkAutoActivationTimer:Cancel();
			checkAutoActivationTimer = nil;
		end
	end

	local spec = GetActiveTalentGroup();
	local lastActivationType, lastNumPlayers, lastSpec, lastEnemyType = CompactUnitFrameProfiles_GetLastActivationType();
	if ( lastActivationType == activationType and lastNumPlayers == numPlayers and lastSpec == spec and lastEnemyType == enemyType ) then
		--If we last auto-adjusted for this same thing, we don't change. (In case they manually changed the profile.)
		return;
	end

	if ( CompactUnitFrameProfiles_ProfileMatchesAutoActivation(CUFGetActiveRaidProfile(), numPlayers, spec, enemyType) ) then
		CompactUnitFrameProfiles_SetLastActivationType(activationType, numPlayers, spec, enemyType);
	else
		for i=1, CUFGetNumRaidProfiles() do
			local profile = CUFGetRaidProfileName(i);
			if ( CompactUnitFrameProfiles_ProfileMatchesAutoActivation(profile, numPlayers, spec, enemyType) ) then
				CompactUnitFrameProfiles_ActivateRaidProfile(profile);
				CompactUnitFrameProfiles_SetLastActivationType(activationType, numPlayers, spec, enemyType);
			end
		end
	end
end

function CompactUnitFrameProfiles_SetLastActivationType(activationType, numPlayers, spec, enemyType)
	CompactUnitFrameProfiles.lastActivationType = activationType;
	CompactUnitFrameProfiles.lastNumPlayers = numPlayers;
	CompactUnitFrameProfiles.lastSpec = spec;
	CompactUnitFrameProfiles.lastEnemyType = enemyType;
end

function CompactUnitFrameProfiles_GetLastActivationType()
	return CompactUnitFrameProfiles.lastActivationType, CompactUnitFrameProfiles.lastNumPlayers, 
		CompactUnitFrameProfiles.lastSpec, CompactUnitFrameProfiles.lastEnemyType;
end

function CompactUnitFrameProfiles_ProfileMatchesAutoActivation(profile, numPlayers, spec, enemyType)
	return CUFGetRaidProfileOption(profile, "autoActivate"..numPlayers.."Players") and CUFGetRaidProfileOption(profile, "autoActivateSpec"..spec) and
		CUFGetRaidProfileOption(profile, "autoActivate"..enemyType);
end

function CompactUnitFrameAutoActivateSpec_OnLoad(self)
	CompactUnitFrameProfilesCheckButton_InitializeWidget(self, "autoActivateSpec"..self:GetID());
end

function CompactUnitFrameProfilesGeneralOptionsFrame_OnShow(self)
	-- For the version of the game 3.3.5a (wotlk), this option is not suitable
	-- local height = 293 + 26 + 26
	-- local numSpecializations = GetNumSpecializations();
	-- for i, option in ipairs(self.AutoActivateSpecs) do
	-- 	if ( option:GetID() <= numSpecializations ) then
	-- 		local specID, specName = GetSpecializationInfo(option:GetID());
	-- 		option.label:SetText(specName);
	-- 		option:Show();
	-- 		height = height + 26;
	-- 		if ( option:GetID() == numSpecializations ) then
	-- 			self.AutoActivatePvP:ClearAllPoints();
	-- 			self.AutoActivatePvP:SetPoint("TOPLEFT", option, "BOTTOMLEFT", 0, -15);
	-- 		end
	-- 	else
	-- 		option:Hide();
	-- 	end
	-- end

	self.autoActivateBG:SetHeight(345);
end

function CompactUnitFrameProfile_UpdateAutoActivationDisabledLabel()
	local profile = CUFGetActiveRaidProfile();
	local hasGroupSize = false;
	for i=1, #autoActivateGroupSizes do
		if ( CUFGetRaidProfileOption(profile, "autoActivate"..autoActivateGroupSizes[i].."Players") ) then
			hasGroupSize = true;
			break;
		end
	end

	local hasTalentSpec = false;
	if ( CUFGetRaidProfileOption(profile, "autoActivateSpec1") or CUFGetRaidProfileOption(profile, "autoActivateSpec2") )  then
		hasTalentSpec = true;
	end

	local hasEnemyType = false;
	if ( CUFGetRaidProfileOption(profile, "autoActivatePvP") or CUFGetRaidProfileOption(profile, "autoActivatePvE") ) then
		hasEnemyType = true;
	end

	if ( hasGroupSize == hasTalentSpec and hasTalentSpec == hasEnemyType ) then
		CompactUnitFrameProfiles.optionsFrame.autoActivateDisabledLabel:Hide();
	elseif ( not hasGroupSize ) then
		CompactUnitFrameProfiles.optionsFrame.autoActivateDisabledLabel:SetText(AUTO_ACTIVATE_PROFILE_NO_SIZE);
		CompactUnitFrameProfiles.optionsFrame.autoActivateDisabledLabel:Show();
	elseif ( not hasTalentSpec ) then
		CompactUnitFrameProfiles.optionsFrame.autoActivateDisabledLabel:SetText(AUTO_ACTIVATE_PROFILE_NO_TALENT);
		CompactUnitFrameProfiles.optionsFrame.autoActivateDisabledLabel:Show();
	elseif ( not hasEnemyType ) then
		CompactUnitFrameProfiles.optionsFrame.autoActivateDisabledLabel:SetText(AUTO_ACTIVATE_PROFILE_NO_ENEMYTYPE);
		CompactUnitFrameProfiles.optionsFrame.autoActivateDisabledLabel:Show();
	end
end

--------------------------------------------------------------
-----------------UI Option Templates---------------------
--------------------------------------------------------------
function CompactUnitFrameProfilesOption_OnLoad(self)
	if ( not self:GetParent().optionControls ) then
		self:GetParent().optionControls = {};
	end
	tinsert(self:GetParent().optionControls, self);
end
-------------------------
----Dropdown--------
-------------------------
-- Required key/value pairs:
-- .optionName - String, name of option
-- .options - Array, array of possible options
-- Required strings:
-- COMPACT_UNIT_FRAME_PROFILE_≤OPTION_NAME>
-- COMPACT_UNIT_FRAME_PROFILE_≤OPTION_NAME>_≤OPTION_VALUE>
function CompactUnitFrameProfilesDropdown_InitializeWidget(self, optionName, options, updateFunc)
	self.optionName = optionName;
	self.options = options;
	local tag = format("COMPACT_UNIT_FRAME_PROFILE_%s", strupper(optionName));
	self.label:SetText(_G[tag] or "Need string: "..tag);
	self.updateFunc = updateFunc or CompactUnitFrameProfilesDropdown_Update;
	CompactUnitFrameProfilesOption_OnLoad(self);
end

function CompactUnitFrameProfilesDropdown_OnShow(self)
	UIDropDownMenu_SetWidth(self, self.width or 160);
	UIDropDownMenu_Initialize(self, CompactUnitFrameProfilesDropdown_Initialize);
	CompactUnitFrameProfilesDropdown_Update(self);
end

function CompactUnitFrameProfilesDropdown_Update(self)
	UIDropDownMenu_Initialize(self, CompactUnitFrameProfilesDropdown_Initialize);
	UIDropDownMenu_SetSelectedValue(self, CUFGetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, self.optionName)); --
end

function CompactUnitFrameProfilesDropdown_Initialize(dropDown)
	local info = UIDropDownMenu_CreateInfo();

	local currentValue = CUFGetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, dropDown.optionName);
	for i=1, #dropDown.options do
		local id = dropDown.options[i];
		local tag = format("COMPACT_UNIT_FRAME_PROFILE_%s_%s", strupper(dropDown.optionName), strupper(id));
		info.text = _G[tag] or "Need string: "..tag;
		info.disabled  = UnitAffectingCombat("player");
		info.func = CompactUnitFrameProfilesDropdownButton_OnClick;
		info.arg1 = dropDown;
		info.value = id;
		info.checked = currentValue == id;
		info.isRadio = true;
		UIDropDownMenu_AddButton(info);
	end
end

function CompactUnitFrameProfilesDropdownButton_OnClick(button, dropDown)
	CUFSetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, dropDown.optionName, button.value);
	UIDropDownMenu_SetSelectedValue(dropDown, button.value);
	CompactUnitFrameProfiles_ApplyCurrentSettings();
	CompactUnitFrameProfiles_UpdateCurrentPanel();
end
------------------------------
----------Slider-------------
------------------------------
function CompactUnitFrameProfilesSlider_InitializeWidget(self, optionName, minText, maxText, updateFunc)
	self.optionName = optionName;
	local tag = format("COMPACT_UNIT_FRAME_PROFILE_%s", strupper(optionName));
	self.label:SetText(_G[tag] or "Need string: "..tag);
	if ( minText ) then
		self.minLabel:SetText(minText);
	end
	if ( maxText ) then
		self.maxLabel:SetText(maxText);
	end

	self.updateFunc = updateFunc or CompactUnitFrameProfilesSlider_Update;
	CompactUnitFrameProfilesOption_OnLoad(self);
end

function CompactUnitFrameProfilesSlider_Update(self)
	local currentValue = CUFGetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, self.optionName);
	self:SetValue(currentValue);
end

function CompactUnitFrameProfilesSlider_OnValueChanged(self, value, userInput)
	if ( userInput ) then
		CUFSetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, self.optionName, value);
		CompactUnitFrameProfiles_ApplyCurrentSettings();
		CompactUnitFrameProfiles_UpdateCurrentPanel();
	end
end
-------------------------------
-------Check Button---------
-------------------------------
function CompactUnitFrameProfilesCheckButton_InitializeWidget(self, optionName, updateFunc)
	self.optionName = optionName;
	local tag = format("COMPACT_UNIT_FRAME_PROFILE_%s", strupper(optionName));
	self.label:SetText(_G[tag] or "Need string: "..tag);
	self.updateFunc = updateFunc or CompactUnitFrameProfilesCheckButton_Update;
	CompactUnitFrameProfilesOption_OnLoad(self);
end

function CompactUnitFrameProfilesCheckButton_Update(self)
	local currentValue = CUFGetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, self.optionName);
	self:SetChecked(currentValue);
end

function CompactUnitFrameProfilesCheckButton_OnClick(self, button)
	if ( self:GetChecked() ) then
		PlaySoundFile(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	else
		PlaySoundFile(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end

	CUFSetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, self.optionName, self:GetChecked() or false);
	CompactUnitFrameProfiles_ApplyCurrentSettings();
	CompactUnitFrameProfiles_UpdateCurrentPanel();
end
-------------------------------------------------------------
-----------------Applying of Options----------------------
-------------------------------------------------------------
function CompactUnitFrameProfiles_ApplyProfile(profile)
	local settings = CUFGetRaidProfileFlattenedOptions(profile);
	for settingName, value in pairs(settings) do
		local func = CUFProfileActionTable[settingName];
		if ( func ) then
			func(value);
		end
	end

	--Refresh all frames to make sure the changes stick.
	CompactRaidFrameContainer_ApplyToFrames(CompactRaidFrameContainer, "normal", DefaultCompactUnitFrameSetup);
	CompactRaidFrameContainer_ApplyToFrames(CompactRaidFrameContainer, "normal", CompactUnitFrame_UpdateAll);
	CompactRaidFrameContainer_ApplyToFrames(CompactRaidFrameContainer, "mini", DefaultCompactMiniFrameSetup);
	CompactRaidFrameContainer_ApplyToFrames(CompactRaidFrameContainer, "mini", CompactUnitFrame_UpdateAll);
	--CompactRaidFrameContainer_ApplyToFrames(CompactRaidFrameContainer, "group", CompactRaidGroup_UpdateLayout);	--UpdateBorder calls UpdateLayout.

	--Update the borders on the group frames.
	CompactRaidFrameContainer_ApplyToFrames(CompactRaidFrameContainer, "group", CompactRaidGroup_UpdateBorder);

	--Update the position of the container.
	CompactRaidFrameManager_ResizeFrame_LoadPosition(CompactRaidFrameManager);

	--Update the container in case sizes and such changed.
	CompactRaidFrameContainer_TryUpdate(CompactRaidFrameContainer);
end

local function CompactUnitFrameProfiles_GenerateRaidManagerSetting(optionName)
	return function(value)
		CompactRaidFrameManager_SetSetting(optionName, value);
	end
end

local function CompactUnitFrameProfiles_GenerateOptionSetter(optionName, optionTarget)
	return function(value)
		if ( optionTarget == "normal" or optionTarget == "all" ) then
			DefaultCompactUnitFrameOptions[optionName] = value;
		end
		if ( optionTarget == "mini" or optionTarget == "all" ) then
			DefaultCompactMiniFrameOptions[optionName] = value;
		end
	end
end

local function CompactUnitFrameProfiles_GenerateSetUpOptionSetter(optionName, optionTarget)
	return function(value)
		if ( optionTarget == "normal" or optionTarget == "all" ) then
			DefaultCompactUnitFrameSetupOptions[optionName] = value;
		end
		if ( optionTarget == "mini" or optionTarget == "all" ) then
			DefaultCompactMiniFrameSetUpOptions[optionName] = value;
		end
	end
end

CUFProfileActionTable = {
	--Settings
	keepGroupsTogether = CompactUnitFrameProfiles_GenerateRaidManagerSetting("KeepGroupsTogether"),
	sortBy = CompactUnitFrameProfiles_GenerateRaidManagerSetting("SortMode"),
	displayPets = CompactUnitFrameProfiles_GenerateRaidManagerSetting("DisplayPets"),
	displayMainTankAndAssist = CompactUnitFrameProfiles_GenerateRaidManagerSetting("DisplayMainTankAndAssist"),
	displayHealPrediction = CompactUnitFrameProfiles_GenerateOptionSetter("displayHealPrediction", "all"),
	displayPowerBar = CompactUnitFrameProfiles_GenerateSetUpOptionSetter("displayPowerBar", "normal"),
	displayAggroHighlight = CompactUnitFrameProfiles_GenerateOptionSetter("displayAggroHighlight", "all"),
	displayNonBossDebuffs = CompactUnitFrameProfiles_GenerateOptionSetter("displayNonBossDebuffs", "normal"),
	displayOnlyDispellableDebuffs = CompactUnitFrameProfiles_GenerateOptionSetter("displayOnlyDispellableDebuffs", "normal"),
	useClassColors = CompactUnitFrameProfiles_GenerateOptionSetter("useClassColors", "normal"),
	horizontalGroups = CompactUnitFrameProfiles_GenerateRaidManagerSetting("HorizontalGroups");
	healthText = CompactUnitFrameProfiles_GenerateOptionSetter("healthText", "normal"),
	frameWidth = CompactUnitFrameProfiles_GenerateSetUpOptionSetter("width", "all");
	frameHeight = 	function(value)
								DefaultCompactUnitFrameSetupOptions.height = value;
								DefaultCompactMiniFrameSetUpOptions.height = value / 2;
							end,
	displayBorder = function(value)
								RAID_BORDERS_SHOWN = value;
								DefaultCompactUnitFrameSetupOptions.displayBorder = value;
								DefaultCompactMiniFrameSetUpOptions.displayBorder = value;
								CompactRaidFrameManager_SetSetting("ShowBorders", value);
							end,

	--State
	locked = CompactUnitFrameProfiles_GenerateRaidManagerSetting("Locked"),
	shown = CompactUnitFrameProfiles_GenerateRaidManagerSetting("IsShown"),
}
