CUF_Texture = CUF_Texture or {};
local CONST_ATLAS_WIDTH			= 1;
local CONST_ATLAS_HEIGHT		= 2;
local CONST_ATLAS_LEFT			= 3;
local CONST_ATLAS_RIGHT			= 4;
local CONST_ATLAS_TOP			= 5;
local CONST_ATLAS_BOTTOM		= 6;
local CONST_ATLAS_TILESHORIZ	= 7;
local CONST_ATLAS_TILESVERT		= 8;
local CONST_ATLAS_TEXTUREPATH	= 9;

function CUF_Texture.GetAtlasInfo( atlas )
    assert(atlas, "C_Texture.GetAtlasInfo: AtlasName must be specified");
    assert(ATLAS_INFO_STORAGE[atlas], "C_Texture.GetAtlasInfo: Atlas named "..atlas.." does not exist");
    local info = ATLAS_INFO_STORAGE[atlas];
    return {
        width 				= info[CONST_ATLAS_WIDTH],
        height 				= info[CONST_ATLAS_HEIGHT],
        leftTexCoord 		= info[CONST_ATLAS_LEFT],
        rightTexCoord 		= info[CONST_ATLAS_RIGHT],
        topTexCoord 		= info[CONST_ATLAS_TOP],
        bottomTexCoord 		= info[CONST_ATLAS_BOTTOM],
        tilesHorizontally 	= info[CONST_ATLAS_TILESHORIZ],
        tilesVertically 	= info[CONST_ATLAS_TILESVERT],
        filename 			= info[CONST_ATLAS_TEXTUREPATH],
    };
end
