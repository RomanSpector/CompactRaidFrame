CUFPixelUtil = {};

function CUFPixelUtil.GetPixelToUIUnitFactor()
    local physicalWidth, physicalHeight = string.match((({GetScreenResolutions()})[GetCurrentResolution()] or ""), "(%d+).-(%d+)");
    physicalWidth, physicalHeight  = tonumber(physicalWidth),tonumber(physicalHeight)
    return 768.0 / physicalHeight;
end

function CUFPixelUtil.GetNearestPixelSize(uiUnitSize, layoutScale, minPixels)
    if uiUnitSize == 0 and (not minPixels or minPixels == 0) then
        return 0;
    end

    local uiUnitFactor = CUFPixelUtil.GetPixelToUIUnitFactor();
    local numPixels = CUFRound((uiUnitSize * layoutScale) / uiUnitFactor);
    if minPixels then
        if uiUnitSize < 0.0 then
            if numPixels > -minPixels then
                numPixels = -minPixels;
            end
        else
            if numPixels < minPixels then
                numPixels = minPixels;
            end
        end
    end

    return numPixels * uiUnitFactor / layoutScale;
end

function CUFPixelUtil.SetWidth(region, width, minPixels)
    region:SetWidth(CUFPixelUtil.GetNearestPixelSize(width, region:GetEffectiveScale(), minPixels));
end

function CUFPixelUtil.SetHeight(region, height, minPixels)
    region:SetHeight(CUFPixelUtil.GetNearestPixelSize(height, region:GetEffectiveScale(), minPixels));
end

function CUFPixelUtil.SetSize(region, width, height, minWidthPixels, minHeightPixels)
    CUFPixelUtil.SetWidth(region, width, minWidthPixels);
    CUFPixelUtil.SetHeight(region, height, minHeightPixels);
end

function CUFPixelUtil.SetPoint(region, point, relativeTo, relativePoint, offsetX, offsetY, minOffsetXPixels, minOffsetYPixels)
    region:SetPoint(point, relativeTo, relativePoint,
        CUFPixelUtil.GetNearestPixelSize(offsetX, region:GetEffectiveScale(), minOffsetXPixels),
        CUFPixelUtil.GetNearestPixelSize(offsetY, region:GetEffectiveScale(), minOffsetYPixels)
    );
end

function CUFPixelUtil.SetStatusBarValue(statusBar, value)
    local width = statusBar:GetWidth();
    if width and width > 0.0 then
        local min, max = statusBar:GetMinMaxValues();
        local percent = CUFClampedPercentageBetween(value, min, max);
        if percent == 0.0 or percent == 1.0 then
            statusBar:SetValue(value);
        else
            local numPixels = CUFPixelUtil.GetNearestPixelSize(statusBar:GetWidth() * percent, statusBar:GetEffectiveScale());
            local roundedValue = CUFLerp(min, max, numPixels / width);
            statusBar:SetValue(roundedValue);
        end
    else
        statusBar:SetValue(value);
    end
end
