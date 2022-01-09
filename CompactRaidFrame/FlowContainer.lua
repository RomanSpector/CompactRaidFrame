function CUFFlowContainer_Initialize(container)
    container.flowFrames = {};
    --Default orientation to horizontal for now.
    CUFFlowContainer_SetOrientation(container, "horizontal");

    --So far, we haven't actually used any space.
    container.flowMaxPrimaryUsed = 0;
    container.flowMaxSecondaryUsed = 0;
end

function CUFFlowContainer_PauseUpdates(container)
    container.flowPauseUpdates = true;
end

function CUFFlowContainer_ResumeUpdates(container)
    container.flowPauseUpdates = false;
    CUFFlowContainer_DoLayout(container);
end

function CUFFlowContainer_SetOrientation(container, orientation)	--"vertical" or "horizontal". This is the direction it tries to fill first.
    container.flowOrientation = orientation;
    CUFFlowContainer_DoLayout(container);
end

function CUFFlowContainer_SetMaxPerLine(container, maxPerLine)	--nil means we fit as much as possible.
    container.flowMaxPerLine = maxPerLine;
    CUFFlowContainer_DoLayout(container);
end

function CUFFlowContainer_SetHorizontalSpacing(container, horizontalSpacing)
    container.flowHorizontalSpacing = horizontalSpacing;
    CUFFlowContainer_DoLayout(container);
end

function CUFFlowContainer_SetVerticalSpacing(container, verticalSpacing)
    container.flowVerticalSpacing = verticalSpacing;
    CUFFlowContainer_DoLayout(container);
end

function CUFFlowContainer_AddObject(container, object)
    tinsert(container.flowFrames, object);	--Do we want to let people choose where it will appear?
    CUFFlowContainer_DoLayout(container);
end

function CUFFlowContainer_AddLineBreak(container)
    tinsert(container.flowFrames, "linebreak");
    CUFFlowContainer_DoLayout(container);
end

function CUFFlowContainer_AddSpacer(container, spacerSize)
    tinsert(container.flowFrames, spacerSize);
    CUFFlowContainer_DoLayout(container);
end

function CUFFlowContainer_BeginAtomicAdd(container)
    tinsert(container.flowFrames, "beginatomic");
    CUFFlowContainer_DoLayout(container);
end

function CUFFlowContainer_EndAtomicAdd(container)
    tinsert(container.flowFrames, "endatomic");
    CUFFlowContainer_DoLayout(container);
end

function CUFFlowContainer_RemoveObject(container, object)
    assert(type(object) == "table");	--For now, Remove can't be used with non-widgets.
    for i=1, #container.flowFrames do	--Used instead of tRemoveItem to eliminate dependencies.
        if ( container.flowFrames[i] == object ) then
            tremove(container.flowFrames, i);
            break;
        end
    end
    CUFFlowContainer_DoLayout(container);
end

function CUFFlowContainer_RemoveAllObjects(container)
    container.flowFrames = {};	--GC no worse than a table.wipe here.
end

function CUFFlowContainer_GetUsedBounds(container)	--Return x, y
    if ( container.flowOrientation == "horizontal" ) then
        return container.flowMaxSecondaryUsed, container.flowMaxPrimaryUsed;
    else
        return container.flowMaxPrimaryUsed, container.flowMaxSecondaryUsed;
    end
end

function CUFFlowContainer_SetStartingOffset(container, xOffset, yOffset)
    if ( container.flowOrientation == "horizontal" ) then
        container.startingSecondaryOffset = xOffset;
        container.startingPrimaryOffset = -yOffset;
    else
        container.startingSecondaryOffset = -yOffset;
        container.startingPrimaryOffset = xOffset;
    end
end

--:GetWidth() and :GetHeight() are used in this function. --meta-comment: Comment added in case anyone ever searches all files for these.
function CUFFlowContainer_DoLayout(container)
    if ( container.flowPauseUpdates ) then
        return;
    end

    local primaryDirection, secondaryDirection;
    local primarySpacing, secondarySpacing;
    if ( container.flowOrientation == "horizontal" ) then
        primaryDirection = "Width";
        secondaryDirection  = "Height";
        primarySpacing = container.flowHorizontalSpacing or 0;
        secondarySpacing = container.flowVerticalSpacing or 0;
    else
        primaryDirection = "Height";
        secondaryDirection  = "Width";
        primarySpacing = container.flowVerticalSpacing or 0;
        secondarySpacing = container.flowHorizontalSpacing or 0;
    end

    --To make things easier to understand, I'll comment this as if it was horizontal. To see the vertical comments, just turn your head 90 degrees.
    local currentSecondaryLine, currentPrimaryLine = 1, 1;
    local currentSecondaryOffset, currentPrimaryOffset = container.startingSecondaryOffset or 0, container.startingPrimaryOffset or 0;
    local lineMaxSize = 0;
    local maxSecondaryOffset = 0;
    local atomicAddStart = nil;
    local atomicAtBeginning = nil;
    local i = 1;
    while ( i <= #container.flowFrames ) do
        local object = container.flowFrames[i];
        local doContinue = false;
        --If it doesn't fit on the current row, move to the next.
        if ( object == "linebreak" or	--Force a new line
            type(object) == "table" and	--Make sure this is an actual object before checking further.
                ((container.flowMaxPerLine and currentPrimaryLine > container.flowMaxPerLine) or	--We went past the max number of columns
                    currentSecondaryOffset + object["Get"..primaryDirection](object) > container["Get"..primaryDirection](container)) ) then	--We went past the max pixel width.

                if ( not (atomicAddStart and atomicAtBeginning) ) then	--If we're in an atomic add and we started at the beginning of the line, Wrapping won't help us
                    currentSecondaryOffset = 0;	--Move back all the way to the left
                    currentPrimaryLine = 1;	--Reset column count
                    currentPrimaryOffset = currentPrimaryOffset + lineMaxSize + secondarySpacing;	--Move down by the size of the biggest object in the last row
                    currentSecondaryLine = currentSecondaryLine + 1;	--Move to the next row.
                    lineMaxSize = 0;
                    if ( atomicAddStart ) then
                        --We Wrapped around. So we want to move back to the first item in the atomic add and continue from the position we're leaving off (the new line).
                        i = atomicAddStart;
                        atomicAtBeginning = true;
                        doContinue = true;
                    end
                end
        end

        if ( not doContinue ) then
            local objectType = type(object);
            if ( objectType == "table" ) then	--This is an actual frame
                --Did we completely run out of room? Assert for now. --Scratch that, we're just going to keep growing. When we have time, we'll probably want a "didn't fit" callback.
                --assert(currentPrimaryOffset + object["Get"..secondaryDirection](object) < container["Get"..secondaryDirection](container));

                --Add it.
                object:ClearAllPoints();
                if ( container.flowOrientation == "horizontal" ) then
                    object:SetPoint("TOPLEFT", container, "TOPLEFT", currentSecondaryOffset, -currentPrimaryOffset);
                else
                    object:SetPoint("TOPLEFT", container, "TOPLEFT", currentPrimaryOffset, -currentSecondaryOffset);
                end

                currentSecondaryOffset = currentSecondaryOffset + object["Get"..primaryDirection](object) + primarySpacing;

                if ( not atomicAddStart ) then	--If we're in the middle of an atomic add, we'll save off the last part when we finish the add.
                    maxSecondaryOffset = max(maxSecondaryOffset, currentSecondaryOffset);
                end

                currentPrimaryLine = currentPrimaryLine + 1;
                lineMaxSize = max(lineMaxSize, object["Get"..secondaryDirection](object));
            elseif ( objectType == "number" ) then	--This is a spacer.
                currentSecondaryOffset = currentSecondaryOffset + object;
            elseif ( objectType == "string" ) then
                if ( object == "beginatomic" ) then
                    if ( currentSecondaryOffset == 0 ) then
                        atomicAtBeginning = true;		--If we're already at the top, we don't want to move anything to the next row. (There's no way it would help.)
                    end
                    atomicAddStart = i + 1;
                elseif ( object == "endatomic" ) then
                    maxSecondaryOffset = max(maxSecondaryOffset, currentSecondaryOffset);	--We weren't updating the max offset while in an atomic add, so we have to do it now.
                    atomicAddStart = nil;
                    atomicAtBeginning = nil;
                end
            end
            i = i + 1;
        end
    end

    --Save off how much we actually used.
    container.flowMaxPrimaryUsed = currentPrimaryOffset + lineMaxSize;
    container.flowMaxSecondaryUsed = maxSecondaryOffset;
end
