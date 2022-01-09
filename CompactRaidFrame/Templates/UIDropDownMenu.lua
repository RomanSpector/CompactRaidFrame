local function CUFUIDropDownMenu_CreateUnChecked(object)
    local uncheck = _G[object:GetName().."UnCheck"];
    if ( uncheck ) then
        return;
    end

    uncheck = object:CreateTexture("$parentUnCheck", "BORDER");
    _G[object:GetName().."UnCheck"] = uncheck;
    uncheck:SetSize(16, 16);
    uncheck:SetPoint("Left");
end

hooksecurefunc("UIDropDownMenu_AddButton", function(info, level)
    if ( not level ) then
        level = 1;
    end

    local listFrame = _G["DropDownList"..level];
    local index = listFrame and listFrame.numButtons or 1;

    listFrame = listFrame or _G["DropDownList"..level];
    local listFrameName = listFrame:GetName();

    local button = _G[listFrameName.."Button"..index];
    CUFUIDropDownMenu_CreateUnChecked(button);

    if ( not info.notCheckable ) then
        local check = _G[listFrameName.."Button"..index.."Check"];
        local uncheck = _G[listFrameName.."Button"..index.."UnCheck"];
        if ( info.disabled ) then
            check:SetDesaturated(true);
            check:SetAlpha(0.5);
            uncheck:SetDesaturated(true);
            uncheck:SetAlpha(0.5);
        else
            check:SetDesaturated(false);
            check:SetAlpha(1);
            uncheck:SetDesaturated(false);
            uncheck:SetAlpha(1);
        end

        if ( info.isRadio ) then
            check:SetTexCoord(0.0, 0.5, 0.5, 1.0);
            check:SetTexture("Interface\\AddOns\\CompactRaidFrame\\Media\\COMMON\\UI-DropDownRadioChecks");
            uncheck:SetTexCoord(0.5, 1.0, 0.5, 1.0);
            uncheck:SetTexture("Interface\\AddOns\\CompactRaidFrame\\Media\\COMMON\\UI-DropDownRadioChecks");
        else
            check:SetTexCoord(0, 1, 0, 1);
            check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check");
        end

        -- Checked can be a function now
        local checked = info.checked;
        if ( type(checked) == "function" ) then
            checked = checked(button);
        end
        -- Show the check if checked
        if ( checked ) then
            button:LockHighlight();
            check:Show();
            uncheck:Hide();
        else
            button:UnlockHighlight();
            check:Hide();
            uncheck:Show();
        end
    else
        _G[listFrameName.."Button"..index.."Check"]:Hide();
        _G[listFrameName.."Button"..index.."UnCheck"]:Hide();
    end

    if ( not info.isRadio ) then
        _G[listFrameName.."Button"..index.."UnCheck"]:Hide();
    end

    button.checked = info.checked;
end)