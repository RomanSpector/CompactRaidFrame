CUFColorMixin = {};
function CUFCreateColor(r, g, b, a)
    local color = CUFCreateFromMixins(CUFColorMixin);
    color:OnLoad(r, g, b, a);
    return color;
end

function CUFColorMixin:OnLoad(r, g, b, a)
    self:SetRGBA(r, g, b, a);
end

function CUFColorMixin:IsEqualTo(otherColor)
    return self.r == otherColor.r
        and self.g == otherColor.g
        and self.b == otherColor.b
        and self.a == otherColor.a;
end

function CUFColorMixin:GetRGB()
    return self.r, self.g, self.b;
end

function CUFColorMixin:GetRGBAsBytes()
    return self.r * 255, self.g * 255, self.b * 255;
end

function CUFColorMixin:GetRGBA()
    return self.r, self.g, self.b, self.a;
end

function CUFColorMixin:GetRGBAAsBytes()
    return self.r * 255, self.g * 255, self.b * 255, (self.a or 1) * 255;
end

function CUFColorMixin:SetRGBA(r, g, b, a)
    self.r = r;
    self.g = g;
    self.b = b;
    self.a = a;
end

function CUFColorMixin:SetRGB(r, g, b)
    self:SetRGBA(r, g, b, nil);
end

function CUFColorMixin:GenerateHexColor()
    return ("ff%.2x%.2x%.2x"):format(self:GetRGBAsBytes());
end

function CUFColorMixin:GenerateHexColorMarkup()
    return "|c"..self:GenerateHexColor();
end

function CUFColorMixin:CUFWrapTextInColorCode(text)
    return CUFWrapTextInColorCode(text, self:GenerateHexColor());
end

function CUFWrapTextInColorCode(text, colorHexString)
    return ("|c%s%s|r"):format(colorHexString, text);
end
