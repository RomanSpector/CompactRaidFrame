local function GetNineSlicePiece(container, pieceName)
    if container.GetNineSlicePiece then
        local piece = container:GetNineSlicePiece(pieceName);
        if piece then
            return piece, true;
        end
    end
    local piece = container[pieceName];
    if piece then
        return piece, true;
    else
        piece = container:CreateTexture()
        container[pieceName] = piece;
        return piece, false;
    end
end

local function PropagateLayoutSettingsToPieceLayout(userLayout, pieceLayout)
    -- Only apply mirrorLayout if it wasn't explicitly defined
    if pieceLayout.mirrorLayout == nil then
        pieceLayout.mirrorLayout = userLayout.mirrorLayout;
    end
    -- ... and other settings that apply to the whole nine-slice
end

local function SetupTextureCoordinates(piece, setupInfo, pieceLayout)
    local left, right, top, bottom = 0, 1, 0, 1;
    if pieceLayout.mirrorLayout then
        if setupInfo.mirrorVertical then
            top, bottom = bottom, top;
        end
        if setupInfo.mirrorHorizontal then
            left, right = right, left;
        end
    end
    piece:SetHorizTile(setupInfo.tileHorizontal);
    piece:SetVertTile(setupInfo.tileVertical);
    piece:SetTexCoord(left, right, top, bottom);
end

local function SetupPieceVisuals(piece, setupInfo, pieceLayout, textureKit, userLayout)
    --- Change texture coordinates before applying atlas.
    SetupTextureCoordinates(piece, setupInfo, pieceLayout, userLayout);
    -- textureKit is optional, that's fine; but if it's nil the caller should ensure that there are no format specifiers in .atlas
    local atlasName = CUFGetFinalNameFromTextureKit(pieceLayout.atlas, textureKit);
    local info = CUF_Texture.GetAtlasInfo(atlasName);
    piece:SetHorizTile(info and info.tilesHorizontally or false);
    piece:SetVertTile(info and info.tilesVertically or false);
    piece:CUFSetAtlas(atlasName, true);
end

local function SetupCorner(container, piece, setupInfo, pieceLayout)
    piece:ClearAllPoints();
    piece:SetPoint(pieceLayout.point or setupInfo.point, container, pieceLayout.relativePoint or setupInfo.point, pieceLayout.x, pieceLayout.y);
end

local function SetupEdge(container, piece, setupInfo, pieceLayout)
    piece:ClearAllPoints();
    piece:SetPoint(setupInfo.point, GetNineSlicePiece(container, setupInfo.relativePieces[1]), setupInfo.relativePoint, pieceLayout.x, pieceLayout.y);
    piece:SetPoint(setupInfo.relativePoint, GetNineSlicePiece(container, setupInfo.relativePieces[2]), setupInfo.point, pieceLayout.x1, pieceLayout.y1);
end

local function SetupCenter(container, piece, setupInfo, pieceLayout)
    piece:ClearAllPoints();
    piece:SetPoint("TOPLEFT", GetNineSlicePiece(container, "TopLeftCorner"), "BOTTOMRIGHT", pieceLayout.x, pieceLayout.y);
    piece:SetPoint("BOTTOMRIGHT", GetNineSlicePiece(container, "BottomRightCorner"), "TOPLEFT", pieceLayout.x1, pieceLayout.y1);
end
-- Defines the order in which each piece should be set up, and how to do the setup.
--
-- Mirror types: As a texture memory and effort savings, many borders are assembled from a single topLeft corner, and top/left edges.
-- That's all that's required if everything is symmetrical (left edge is also superfluous, but allows for more detail variation)
-- The mirror flags specify which texture coords to flip relative to the piece that would use default texture coordinates: left = 0, top = 0, right = 1, bottom = 1
local nineSliceSetup =
{
    { pieceName = "TopLeftCorner", point = "TOPLEFT", fn = SetupCorner, },
    { pieceName = "TopRightCorner", point = "TOPRIGHT", mirrorHorizontal = true, fn = SetupCorner, },
    { pieceName = "BottomLeftCorner", point = "BOTTOMLEFT", mirrorVertical = true, fn = SetupCorner, },
    { pieceName = "BottomRightCorner", point = "BOTTOMRIGHT", mirrorHorizontal = true, mirrorVertical = true, fn = SetupCorner, },
    { pieceName = "TopEdge", point = "TOPLEFT", relativePoint = "TOPRIGHT", relativePieces = { "TopLeftCorner", "TopRightCorner" }, fn = SetupEdge, tileHorizontal = true },
    { pieceName = "BottomEdge", point = "BOTTOMLEFT", relativePoint = "BOTTOMRIGHT", relativePieces = { "BottomLeftCorner", "BottomRightCorner" }, mirrorVertical = true, tileHorizontal = true, fn = SetupEdge, },
    { pieceName = "LeftEdge", point = "TOPLEFT", relativePoint = "BOTTOMLEFT", relativePieces = { "TopLeftCorner", "BottomLeftCorner" }, tileVertical = true, fn = SetupEdge, },
    { pieceName = "RightEdge", point = "TOPRIGHT", relativePoint = "BOTTOMRIGHT", relativePieces = { "TopRightCorner", "BottomRightCorner" }, mirrorHorizontal = true, tileVertical = true, fn = SetupEdge, },
    { pieceName = "Center", fn = SetupCenter, },
};

local layouts =
{
    SimplePanelTemplate =
    {
        mirrorLayout = true,
        TopLeftCorner =	{ atlas = "UI-Frame-SimpleMetal-CornerTopLeft", x = -5, y = 0, },
        TopRightCorner = { atlas = "UI-Frame-SimpleMetal-CornerTopLeft", x = 2, y = 0, },
        BottomLeftCorner = { atlas = "UI-Frame-SimpleMetal-CornerTopLeft", x = -5, y = -3, },
        BottomRightCorner =	{ atlas = "UI-Frame-SimpleMetal-CornerTopLeft", x = 2, y = -3, },
        TopEdge = { atlas = "_UI-Frame-SimpleMetal-EdgeTop", },
        BottomEdge = { atlas = "_UI-Frame-SimpleMetal-EdgeTop", },
        LeftEdge = { atlas = "!UI-Frame-SimpleMetal-EdgeLeft", },
        RightEdge = { atlas = "!UI-Frame-SimpleMetal-EdgeLeft", },
    },
    PortraitFrameTemplate =
    {
        TopLeftCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-PortraitMetal-CornerTopLeft", x = -13, y = 16, },
        TopRightCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerTopRight", x = 4, y = 16, },
        BottomLeftCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerBottomLeft", x = -13, y = -3, },
        BottomRightCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerBottomRight", x = 4, y = -3, },
        TopEdge = { layer="OVERLAY", atlas = "_UI-Frame-Metal-EdgeTop", x = 0, y = 0, x1 = 0, y1 = 0, },
        BottomEdge = { layer = "OVERLAY", atlas = "_UI-Frame-Metal-EdgeBottom", x = 0, y = 0, x1 = 0, y1 = 0, },
        LeftEdge = { layer = "OVERLAY", atlas = "!UI-Frame-Metal-EdgeLeft", x = 0, y = 0, x1 = 0, y1 = 0 },
        RightEdge = { layer = "OVERLAY", atlas = "!UI-Frame-Metal-EdgeRight", x = 0, y = 0, x1 = 0, y1 = 0, },
    },
    PortraitFrameTemplateMinimizable =
    {
        TopLeftCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-PortraitMetal-CornerTopLeft", x = -13, y = 16, },
        TopRightCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerTopRightDouble", x = 4, y = 16, },
        BottomLeftCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerBottomLeft", x = -13, y = -3, },
        BottomRightCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerBottomRight", x = 4, y = -3, },
        TopEdge = { layer="OVERLAY", atlas = "_UI-Frame-Metal-EdgeTop", x = 0, y = 0, x1 = 0, y1 = 0, },
        BottomEdge = { layer = "OVERLAY", atlas = "_UI-Frame-Metal-EdgeBottom", x = 0, y = 0, x1 = 0, y1 = 0, },
        LeftEdge = { layer = "OVERLAY", atlas = "!UI-Frame-Metal-EdgeLeft", x = 0, y = 0, x1 = 0, y1 = 0 },
        RightEdge = { layer = "OVERLAY", atlas = "!UI-Frame-Metal-EdgeRight", x = 0, y = 0, x1 = 0, y1 = 0, },
    },
    ButtonFrameTemplateNoPortrait =
    {
        TopLeftCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerTopLeft", x = -12, y = 16, },
        TopRightCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerTopRight", x = 4, y = 16, },
        BottomLeftCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerBottomLeft", x = -12, y = -3, },
        BottomRightCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerBottomRight", x = 4, y = -3, },
        TopEdge = { layer = "OVERLAY", atlas = "_UI-Frame-Metal-EdgeTop", },
        BottomEdge = { layer = "OVERLAY", atlas = "_UI-Frame-Metal-EdgeBottom", },
        LeftEdge = { layer = "OVERLAY", atlas = "!UI-Frame-Metal-EdgeLeft", },
        RightEdge = { layer = "OVERLAY", atlas = "!UI-Frame-Metal-EdgeRight", },
    },
    ButtonFrameTemplateNoPortraitMinimizable =
    {
        TopLeftCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerTopLeft", x = -12, y = 16, },
        TopRightCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerTopRightDouble", x = 4, y = 16, },
        BottomLeftCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerBottomLeft", x = -12, y = -3, },
        BottomRightCorner =	{ layer = "OVERLAY", atlas = "UI-Frame-Metal-CornerBottomRight", x = 4, y = -3, },
        TopEdge = { layer = "OVERLAY", atlas = "_UI-Frame-Metal-EdgeTop", },
        BottomEdge = { layer = "OVERLAY", atlas = "_UI-Frame-Metal-EdgeBottom", },
        LeftEdge = { layer = "OVERLAY", atlas = "!UI-Frame-Metal-EdgeLeft", },
        RightEdge = { layer = "OVERLAY", atlas = "!UI-Frame-Metal-EdgeRight", },
    },
    InsetFrameTemplate =
    {
        TopLeftCorner = { layer = "BORDER", subLevel = -5, atlas = "UI-Frame-InnerTopLeft", },
        TopRightCorner = { layer = "BORDER", subLevel = -5, atlas = "UI-Frame-InnerTopRight", },
        BottomLeftCorner = { layer = "BORDER", subLevel = -5, atlas = "UI-Frame-InnerBotLeftCorner", x = 0, y = -1, },
        BottomRightCorner = { layer = "BORDER", subLevel = -5, atlas = "UI-Frame-InnerBotRight", x = 0, y = -1, },
        TopEdge = { layer = "BORDER", subLevel = -5, atlas = "_UI-Frame-InnerTopTile", },
        BottomEdge = { layer = "BORDER", subLevel = -5, atlas = "_UI-Frame-InnerBotTile", },
        LeftEdge = { layer = "BORDER", subLevel = -5, atlas = "!UI-Frame-InnerLeftTile", },
        RightEdge = { layer = "BORDER", subLevel = -5, atlas = "!UI-Frame-InnerRightTile", },
    },
    BFAMissionHorde =
    {
        mirrorLayout = true,
        TopLeftCorner =	{ atlas = "HordeFrame-Corner-TopLeft", x = -6, y = 6, },
        TopRightCorner =	{ atlas = "HordeFrame-Corner-TopLeft", x = 6, y = 6, },
        BottomLeftCorner =	{ atlas = "HordeFrame-Corner-TopLeft", x = -6, y = -6, },
        BottomRightCorner =	{ atlas = "HordeFrame-Corner-TopLeft", x = 6, y = -6, },
        TopEdge = { atlas = "_HordeFrameTile-Top", },
        BottomEdge = { atlas = "_HordeFrameTile-Top", },
        LeftEdge = { atlas = "!HordeFrameTile-Left", },
        RightEdge = { atlas = "!HordeFrameTile-Left", },
    },
    BFAMissionAlliance =
    {
        mirrorLayout = true,
        TopLeftCorner =	{ atlas = "AllianceFrameCorner-TopLeft", x = -6, y = 6, },
        TopRightCorner =	{ atlas = "AllianceFrameCorner-TopLeft", x = 6, y = 6, },
        BottomLeftCorner =	{ atlas = "AllianceFrameCorner-TopLeft", x = -6, y = -6, },
        BottomRightCorner =	{ atlas = "AllianceFrameCorner-TopLeft", x = 6, y = -6, },
        TopEdge = { atlas = "_AllianceFrameTile-Top", },
        BottomEdge = { atlas = "_AllianceFrameTile-Top", },
        LeftEdge = { atlas = "!AllianceFrameTile-Left", },
        RightEdge = { atlas = "!AllianceFrameTile-Left", },
    },
    CovenantMissionFrame =
    {
        mirrorLayout = true,
        TopLeftCorner =	{ atlas = "Oribos-NineSlice-CornerTopLeft", x = -6, y = 6, },
        TopRightCorner =	{ atlas = "Oribos-NineSlice-CornerTopLeft", x = 6, y = 6, },
        BottomLeftCorner =	{ atlas = "Oribos-NineSlice-CornerTopLeft", x = -6, y = -6, },
        BottomRightCorner =	{ atlas = "Oribos-NineSlice-CornerTopLeft", x = 6, y = -6, },
        TopEdge = { atlas = "_Oribos-NineSlice-EdgeTop", },
        BottomEdge = { atlas = "_Oribos-NineSlice-EdgeTop", },
        LeftEdge = { atlas = "!Oribos-NineSlice-EdgeLeft", },
        RightEdge = { atlas = "!Oribos-NineSlice-EdgeLeft", },
    },
    GenericMetal =
    {
        TopLeftCorner =	{ atlas = "UI-Frame-GenericMetal-Corner", x = -6, y = 6, mirrorLayout = true, },
        TopRightCorner =	{ atlas = "UI-Frame-GenericMetal-Corner", x = 6, y = 6, mirrorLayout = true, },
        BottomLeftCorner =	{ atlas = "UI-Frame-GenericMetal-Corner", x = -6, y = -6, mirrorLayout = true, },
        BottomRightCorner =	{ atlas = "UI-Frame-GenericMetal-Corner", x = 6, y = -6, mirrorLayout = true, },
        TopEdge = { atlas = "_UI-Frame-GenericMetal-EdgeTop", },
        BottomEdge = { atlas = "_UI-Frame-GenericMetal-EdgeBottom", },
        LeftEdge = { atlas = "!UI-Frame-GenericMetal-EdgeLeft", },
        RightEdge = { atlas = "!UI-Frame-GenericMetal-EdgeRight", },
    },
    Dialog =
    {
        TopLeftCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerTopLeft", },
        TopRightCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerTopRight", },
        BottomLeftCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerBottomLeft", },
        BottomRightCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerBottomRight", },
        TopEdge = { atlas = "_UI-Frame-DiamondMetal-EdgeTop", },
        BottomEdge = { atlas = "_UI-Frame-DiamondMetal-EdgeBottom", },
        LeftEdge = { atlas = "!UI-Frame-DiamondMetal-EdgeLeft", },
        RightEdge = { atlas = "!UI-Frame-DiamondMetal-EdgeRight", },
    },
    WoodenNeutralFrameTemplate =
    {
        mirrorLayout = true,
        TopLeftCorner =	{ atlas = "Neutral-NineSlice-Corner", x = -6, y = 6, },
        TopRightCorner =	{ atlas = "Neutral-NineSlice-Corner", x = 6, y = 6, },
        BottomLeftCorner =	{ atlas = "Neutral-NineSlice-Corner", x = -6, y = -6, },
        BottomRightCorner =	{ atlas = "Neutral-NineSlice-Corner", x = 6, y = -6, },
        TopEdge = { atlas = "_Neutral-NineSlice-EdgeTop", },
        BottomEdge = { atlas = "_Neutral-NineSlice-EdgeBottom", mirrorLayout = false, },
        LeftEdge = { atlas = "!Neutral-NineSlice-EdgeLeft", },
        RightEdge = { atlas = "!Neutral-NineSlice-EdgeRight", mirrorLayout = false, },
    },
    Runeforge =
    {
        TopLeftCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerTopLeft", },
        TopRightCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerTopRight", },
        BottomLeftCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerBottomLeft", },
        BottomRightCorner =	{ atlas = "UI-Frame-DiamondMetal-CornerBottomRight", },
        TopEdge = { atlas = "_UI-Frame-DiamondMetal-EdgeTop", },
        BottomEdge = { atlas = "_UI-Frame-DiamondMetal-EdgeBottom", },
        LeftEdge = { atlas = "!UI-Frame-DiamondMetal-EdgeLeft", },
        RightEdge = { atlas = "!UI-Frame-DiamondMetal-EdgeRight", },
    },
    AdventuresMissionComplete =
    {
        TopLeftCorner =	{ atlas = "AdventuresFrame-Corner-Small-TopLeft", mirrorLayout = true, },
        TopRightCorner =	{ atlas = "AdventuresFrame-Corner-Small-TopLeft", mirrorLayout = true, },
        BottomLeftCorner =	{ atlas = "AdventuresFrame-Corner-Small-TopLeft", mirrorLayout = true, },
        BottomRightCorner =	{ atlas = "AdventuresFrame-Corner-Small-TopLeft", mirrorLayout = true, },
        TopEdge = { layer = "BACKGROUND", atlas = "_AdventuresFrame-Small-Top", x = -10, y = 3, x1 = 10, y1 = 3, },
        BottomEdge = { layer = "BACKGROUND", atlas = "_AdventuresFrame-Small-Top", x = -10, y = -3, x1 = 10, y1 = -3, mirrorLayout = true, },
        LeftEdge = { layer = "BACKGROUND", atlas = "!AdventuresFrame-Right", x = -3, y = 10, x1 = -3, y1 = -10,},
        RightEdge = { layer = "BACKGROUND", atlas = "!AdventuresFrame-Left", x = 3, y = 10, x1 = 3, y1 = -10,},
    },
    CharacterCreateDropdown =
    {
        TopLeftCorner =	{ atlas = "CharacterCreateDropdown-NineSlice-CornerTopLeft", x=-30, y=20 },
        TopRightCorner =	{ atlas = "CharacterCreateDropdown-NineSlice-CornerTopRight", x=30, y=20 },
        BottomLeftCorner =	{ atlas = "CharacterCreateDropdown-NineSlice-CornerBottomLeft", x=-30, y=-20 },
        BottomRightCorner =	{ atlas = "CharacterCreateDropdown-NineSlice-CornerBottomRight", x=30, y=-20 },
        TopEdge = { atlas = "_CharacterCreateDropdown-NineSlice-EdgeTop", },
        BottomEdge = { atlas = "_CharacterCreateDropdown-NineSlice-EdgeBottom", },
        LeftEdge = { atlas = "!CharacterCreateDropdown-NineSlice-EdgeLeft", },
        RightEdge = { atlas = "!CharacterCreateDropdown-NineSlice-EdgeRight", },
        Center = { atlas = "CharacterCreateDropdown-NineSlice-Center", },
    },
    ChatBubble =
    {
        TopLeftCorner =	{ atlas = "ChatBubble-NineSlice-CornerTopLeft", },
        TopRightCorner =	{ atlas = "ChatBubble-NineSlice-CornerTopRight", },
        BottomLeftCorner =	{ atlas = "ChatBubble-NineSlice-CornerBottomLeft", },
        BottomRightCorner =	{ atlas = "ChatBubble-NineSlice-CornerBottomRight", },
        TopEdge = { atlas = "_ChatBubble-NineSlice-EdgeTop", },
        BottomEdge = { atlas = "_ChatBubble-NineSlice-EdgeBottom", },
        LeftEdge = { atlas = "!ChatBubble-NineSlice-EdgeLeft", },
        RightEdge = { atlas = "!ChatBubble-NineSlice-EdgeRight", },
        Center = { atlas = "ChatBubble-NineSlice-Center", },
    },
    UniqueCornersLayout =
    {
        ["TopRightCorner"] = { atlas = "%s-NineSlice-CornerTopRight" },
        ["TopLeftCorner"] = { atlas = "%s-NineSlice-CornerTopLeft" },
        ["BottomLeftCorner"] = { atlas = "%s-NineSlice-CornerBottomLeft" },
        ["BottomRightCorner"] = { atlas = "%s-NineSlice-CornerBottomRight" },
        ["TopEdge"] = { atlas = "_%s-NineSlice-EdgeTop" },
        ["BottomEdge"] = { atlas = "_%s-NineSlice-EdgeBottom" },
        ["LeftEdge"] = { atlas = "!%s-NineSlice-EdgeLeft" },
        ["RightEdge"] = { atlas = "!%s-NineSlice-EdgeRight" },
        ["Center"] = { atlas = "%s-NineSlice-Center" },
    };
    IdenticalCornersLayout =
    {
        ["TopRightCorner"] = { atlas = "%s-NineSlice-Corner", mirrorLayout = true, },
        ["TopLeftCorner"] = { atlas = "%s-NineSlice-Corner", mirrorLayout = true,},
        ["BottomLeftCorner"] = { atlas = "%s-NineSlice-Corner", mirrorLayout = true, },
        ["BottomRightCorner"] = { atlas = "%s-NineSlice-Corner",  mirrorLayout = true,},
        ["TopEdge"] = { atlas = "_%s-NineSlice-EdgeTop" },
        ["BottomEdge"] = { atlas = "_%s-NineSlice-EdgeBottom" },
        ["LeftEdge"] = { atlas = "!%s-NineSlice-EdgeLeft" },
        ["RightEdge"] = { atlas = "!%s-NineSlice-EdgeRight" },
        ["Center"] = { atlas = "%s-NineSlice-Center" },
    };
};
--------------------------------------------------
-- NINE SLICE UTILS
CUFNineSliceUtil = {};
function CUFNineSliceUtil.ApplyUniqueCornersLayout(self, textureKit)
    CUFNineSliceUtil.ApplyLayout(self, layouts.UniqueCornersLayout, textureKit);
end

function CUFNineSliceUtil.ApplyIdenticalCornersLayout(self, textureKit)
    CUFNineSliceUtil.ApplyLayout(self, layouts.IdenticalCornersLayout, textureKit);
end

function CUFNineSliceUtil.ApplyLayout(container, userLayout, textureKit)
    for pieceIndex, setup in ipairs(nineSliceSetup) do
        local pieceName = setup.pieceName;
        local pieceLayout = userLayout[pieceName];
        if pieceLayout then
            PropagateLayoutSettingsToPieceLayout(userLayout, pieceLayout);
            local piece, pieceAlreadyExisted = GetNineSlicePiece(container, pieceName);
            if not pieceAlreadyExisted then
                container[pieceName] = piece;
                piece:SetDrawLayer(pieceLayout.layer or "BORDER", pieceLayout.subLevel);
            end
            -- Piece setup can change arbitrary properties, do it before changing the texture.
            setup.fn(container, piece, setup, pieceLayout);
            if userLayout.setupPieceVisualsFunction then
                userLayout.setupPieceVisualsFunction(container, piece, setup, pieceLayout, textureKit);
            else
                SetupPieceVisuals(piece, setup, pieceLayout, textureKit);
            end
        end
    end
end

function CUFNineSliceUtil.DisableSharpening(container)
    for pieceIndex, setup in ipairs(nineSliceSetup) do
        local piece = GetNineSlicePiece(container, setup.pieceName);
        piece:SetTexelSnappingBias(0);
        piece:SetSnapToPixelGrid(false);
    end
end

function CUFNineSliceUtil.ApplyLayoutByName(container, userLayoutName, textureKit)
    return CUFNineSliceUtil.ApplyLayout(container, CUFNineSliceUtil.GetLayout(userLayoutName), textureKit);
end

function CUFNineSliceUtil.GetLayout(layoutName)
    return layouts[layoutName];
end

function CUFNineSliceUtil.AddLayout(layoutName, layout)
    layouts[layoutName] = layout;
end
--------------------------------------------------
-- NINE SLICE PANEL MIXIN
CUFNineSlicePanelMixin = {};

function CUFNineSlicePanelMixin:GetFrameLayoutType()
    return self.layoutType or self:GetParent().layoutType;
end

function CUFNineSlicePanelMixin:OnLoad()
    local layout = CUFNineSliceUtil.GetLayout(self:GetFrameLayoutType());
    if layout then
        CUFNineSliceUtil.ApplyLayout(self, layout, self.layoutTextureKit);
    end
end
