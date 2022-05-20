local Texture, FontString
local Frame = getmetatable(CreateFrame("Frame"))
local Button = getmetatable(CreateFrame("Button"))
local Slider = getmetatable(CreateFrame("Slider"))
local StatusBar = getmetatable(CreateFrame("StatusBar"))
local ScrollFrame = getmetatable(CreateFrame("ScrollFrame"))
local CheckButton = getmetatable(CreateFrame("CheckButton"))

local FrameData = {
    CreateFrame("Frame"),
    CreateFrame("Button"),
    CreateFrame("Slider"),
    CreateFrame("StatusBar"),
    CreateFrame("ScrollFrame"),
    CreateFrame("CheckButton"),
}

function InitSubFrame()
    for _, v in pairs(FrameData) do
        Texture = getmetatable(v:CreateTexture())
        FontString = getmetatable(v:CreateFontString())
    end
end

InitSubFrame()

local function Method_SetShown(self, ...)
    if ... then
        self:Show()
    else
        self:Hide()
    end
end

local function Method_SetEnabled(self, ...)
    if ... then
        self:Enable()
    else
        self:Disable()
    end
end

local function Method_SetColorTexture(self, r, g, b, a)
    local rType, gType, bType, aType = type(r), type(g), type(b), type(a);

    if rType ~= "number" then
        error("Invalid type r: " .. rType);
    end
    if gType ~= "number" then
        error("Invalid type g: " .. gType);
    end
    if bType ~= "number" then
        error("Invalid type b: " .. bType);
    end
    if aType ~= "number" and aType ~= "nil" then
        error("Invalid type a: " .. aType);
    end

    local texture = self:SetTexture(r, g, b, a or 1);

    return texture;
end

local function Method_SetRemainingTime(self, _time, daysformat)
    local time = _time
    local dayInSeconds = 86400
    local days = ""

    self:SetText("")

    if type(time) ~= "number" then
        -- printc("EROR: Method_SetRemainingTime time is not number. Frame "..self:GetName())
        return
    end

    if daysformat then
        if time > 86400 then
            self:SetText(math.floor(time / dayInSeconds)..string.format(" |4день:дня:дней;", time % 10))
        else
            self:SetText(date("!%X", time))
        end
    else
        if time > dayInSeconds then
            days = math.floor(time / dayInSeconds) .. "д "
            time = time % dayInSeconds
        end

        if time and time >= 0 then
            self:SetText(days .. date("!%X", time))
        end
    end
end

local function Method_SetSubTexCoord(self, left, right, top, bottom)
    local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = self:GetTexCoord()

    local leftedge = ULx
    local rightedge = URx
    local topedge = ULy
    local bottomedge = LLy

    local width  = rightedge - leftedge
    local height = bottomedge - topedge

    leftedge = ULx + width * left
    topedge  = ULy  + height * top
    rightedge = math.max(rightedge * right, ULx)
    bottomedge = math.max(bottomedge * bottom, ULy)

    ULx = leftedge
    ULy = topedge
    LLx = leftedge
    LLy = bottomedge
    URx = rightedge
    URy = topedge
    LRx = rightedge
    LRy = bottomedge

    self:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
end

local function Method_SetPortrait(self, displayID)
    local portrait = "Interface\\PORTRAITS\\Portrait_model_"..tonumber(displayID)
    self:SetTexture(portrait)
end

local Panels = { "CollectionsJournal", "EncounterJournal" }
local function Method_FixOpenPanel( self )
    -- Хак, в связи с странностями работы системы позиционирования.
    -- Необходим для корректной работы системы Профессий.
    for i = 1, #Panels do
        local panel = _G[Panels[i]]

        if panel then
            if panel:IsShown() then
                HideUIPanel(panel)
                ShowUIPanel(self)
                return true
            end
        end
    end
end

local CONST_ATLAS_WIDTH			= 1
local CONST_ATLAS_HEIGHT		= 2
local CONST_ATLAS_LEFT			= 3
local CONST_ATLAS_RIGHT			= 4
local CONST_ATLAS_TOP			= 5
local CONST_ATLAS_BOTTOM		= 6
local CONST_ATLAS_TILESHORIZ	= 7
local CONST_ATLAS_TILESVERT		= 8
local CONST_ATLAS_TEXTUREPATH	= 9

local function Method_SetAtlas(self, atlasName, useAtlasSize)
    assert(self, "SetAtlas: not found object");
    assert(atlasName, "SetAtlas: AtlasName must be specified");
    assert(ATLAS_INFO_STORAGE[atlasName], "SetAtlas: Atlas named "..atlasName.." does not exist");

    local atlas = ATLAS_INFO_STORAGE[atlasName];

    self:SetTexture(atlas[CONST_ATLAS_TEXTUREPATH] or "", atlas[CONST_ATLAS_TILESHORIZ], atlas[CONST_ATLAS_TILESVERT]);

    if useAtlasSize then
        self:SetWidth(atlas[CONST_ATLAS_WIDTH])
        self:SetHeight(atlas[CONST_ATLAS_HEIGHT])
    end

    self:SetTexCoord(atlas[CONST_ATLAS_LEFT], atlas[CONST_ATLAS_RIGHT], atlas[CONST_ATLAS_TOP], atlas[CONST_ATLAS_BOTTOM])

    self:SetHorizTile(atlas[CONST_ATLAS_TILESHORIZ])
    self:SetVertTile(atlas[CONST_ATLAS_TILESVERT])

    self.atlasName = atlasName;
end

local function Method_GetAtlas(self)
    return self.atlasName
end

local function Method_SmoothSetValue(self, value)
    -- local smoothFrame = self._SmoothUpdateFrame or CreateFrame("Frame")
    -- self._SmoothUpdateFrame =  smoothFrame
end

local function Method_SetDesaturated(self, toggle, color)
    if toggle then
        self:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
    else
        if color then
            self:SetTextColor(color.r, color.g, color.b)
        else
            self:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
        end
    end
end

local function Method_SetParentArray(self, arrayName, element, setInSelf)
    local parent = not setInSelf and self:GetParent() or self

    if not parent[arrayName] then
        parent[arrayName] = {}
    end

    table.insert(parent[arrayName], element or self)
end

local function Method_ClearAndSetPoint(self, ...)
    self:ClearAllPoints()
    self:SetPoint(...)
end

-- Frame Method
function Frame.__index:SetShown( ... ) Method_SetShown( self, ... ) end
function Frame.__index:FixOpenPanel( ... ) Method_FixOpenPanel( self, ... ) end
function Frame.__index:SetParentArray( arrayName, element, setInSelf ) Method_SetParentArray( self, arrayName, element, setInSelf ) end
function Frame.__index:ClearAndSetPoint( ... ) Method_ClearAndSetPoint( self, ... ) end
function Frame.__index:SetColorTexture( ... ) Method_SetColorTexture(self,... ) end

-- Button Method
function Button.__index:SetShown( ... ) Method_SetShown( self, ... ) end
function Button.__index:SetEnabled( ... ) Method_SetEnabled( self, ... ) end
function Button.__index:SetParentArray( arrayName, element, setInSelf ) Method_SetParentArray( self, arrayName, element, setInSelf ) end
function Button.__index:ClearAndSetPoint( ... ) Method_ClearAndSetPoint( self, ... ) end
function Button.__index:SetColorTexture( ... ) Method_SetColorTexture(self,... ) end
function Button.__index:SetNormalAtlas( atlasName, useAtlasSize, filterMode ) Method_SetAtlas( self:GetNormalTexture(), atlasName, useAtlasSize, filterMode )  end
function Button.__index:SetPushedAtlas( atlasName, useAtlasSize, filterMode ) Method_SetAtlas( self:GetPushedTexture(), atlasName, useAtlasSize, filterMode )  end
function Button.__index:SetDisabledAtlas( atlasName, useAtlasSize, filterMode ) Method_SetAtlas( self:GetDisabledTexture(), atlasName, useAtlasSize, filterMode )  end
function Button.__index:SetHighlightAtlas( atlasName, useAtlasSize, filterMode ) Method_SetAtlas( self:GetHighlightTexture(), atlasName, useAtlasSize, filterMode )  end

-- Slider Method
function Slider.__index:SetShown( ... ) Method_SetShown( self, ... ) end
function Slider.__index:SetParentArray( arrayName, element, setInSelf ) Method_SetParentArray( self, arrayName, element, setInSelf ) end
function Slider.__index:ClearAndSetPoint( ... ) Method_ClearAndSetPoint( self, ... ) end

-- Texture Method
function Texture.__index:SetShown( ... ) Method_SetShown( self, ... ) end
function Texture.__index:SetSubTexCoord( left, right, top, bottom ) Method_SetSubTexCoord( self, left, right, top, bottom ) end
function Texture.__index:SetPortrait( displayID ) Method_SetPortrait( self, displayID ) end
function Texture.__index:SetAtlas( atlasName, useAtlasSize, filterMode ) Method_SetAtlas( self, atlasName, useAtlasSize, filterMode ) end
function Texture.__index:GetAtlas() return Method_GetAtlas( self ) end
function Texture.__index:SetParentArray( arrayName, element, setInSelf ) Method_SetParentArray( self, arrayName, element, setInSelf ) end
function Texture.__index:ClearAndSetPoint( ... ) Method_ClearAndSetPoint( self, ... ) end

-- StatusBar Method
function StatusBar.__index:SetShown( ... ) Method_SetShown( self, ... ) end
function StatusBar.__index:SmoothSetValue( value ) Method_SmoothSetValue( self, value ) end
function StatusBar.__index:SetParentArray( arrayName, element, setInSelf ) Method_SetParentArray( self, arrayName, element, setInSelf ) end
function StatusBar.__index:ClearAndSetPoint( ... ) Method_ClearAndSetPoint( self, ... ) end
function StatusBar.__index:SetColorTexture( ... ) Method_SetColorTexture(self,... ) end

-- FontString Method
function FontString.__index:SetShown( ... ) Method_SetShown( self, ... ) end
function FontString.__index:SetRemainingTime( time, daysformat ) Method_SetRemainingTime( self, time, daysformat ) end
function FontString.__index:SetDesaturated( toggle, color ) Method_SetDesaturated( self, toggle, color ) end
function FontString.__index:SetParentArray( arrayName, element, setInSelf ) Method_SetParentArray( self, arrayName, element, setInSelf ) end
function FontString.__index:ClearAndSetPoint( ... ) Method_ClearAndSetPoint( self, ... ) end

-- ScrollFrame Method
function ScrollFrame.__index:SetShown( ... ) Method_SetShown( self, ... ) end
function ScrollFrame.__index:SetParentArray( arrayName, element, setInSelf ) Method_SetParentArray( self, arrayName, element, setInSelf ) end
function ScrollFrame.__index:ClearAndSetPoint( ... ) Method_ClearAndSetPoint( self, ... ) end

-- CheckButton Method
function CheckButton.__index:SetShown( ... ) Method_SetShown( self, ... ) end
function CheckButton.__index:SetEnabled( ... ) Method_SetEnabled( self, ... ) end
function CheckButton.__index:SetParentArray( arrayName, element, setInSelf ) Method_SetParentArray( self, arrayName, element, setInSelf ) end
function CheckButton.__index:ClearAndSetPoint( ... ) Method_ClearAndSetPoint( self, ... ) end
