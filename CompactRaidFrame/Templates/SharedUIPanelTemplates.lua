UIMenuButtonStretchMixin = {}

function UIMenuButtonStretchMixin:SetTextures(texture)
    self.TopLeft:SetTexture(texture);
    self.TopRight:SetTexture(texture);
    self.BottomLeft:SetTexture(texture);
    self.BottomRight:SetTexture(texture);
    self.TopMiddle:SetTexture(texture);
    self.MiddleLeft:SetTexture(texture);
    self.MiddleRight:SetTexture(texture);
    self.BottomMiddle:SetTexture(texture);
    self.MiddleMiddle:SetTexture(texture);
end

function UIMenuButtonStretchMixin:OnMouseDown(button)
    if ( self:IsEnabled() ) then
        self:SetTextures("Interface\\Buttons\\UI-Silver-Button-Down");
        if ( self.Icon ) then
            if ( not self.Icon.oldPoint ) then
                local point, relativeTo, relativePoint, x, y = self.Icon:GetPoint(1);
                self.Icon.oldPoint = point;
                self.Icon.oldX = x;
                self.Icon.oldY = y;
            end
            self.Icon:SetPoint(self.Icon.oldPoint, self.Icon.oldX + 1, self.Icon.oldY - 1);
        end
    end
end

function UIMenuButtonStretchMixin:OnMouseUp(button)
    if ( self:IsEnabled() ) then
        self:SetTextures("Interface\\Buttons\\UI-Silver-Button-Up");
        if ( self.Icon ) then
            self.Icon:SetPoint(self.Icon.oldPoint, self.Icon.oldX, self.Icon.oldY);
        end
    end
end

function UIMenuButtonStretchMixin:OnShow()
    -- we need to reset our textures just in case we were hidden before a mouse up fired
    self:SetTextures("Interface\\Buttons\\UI-Silver-Button-Up");
end

function UIMenuButtonStretchMixin:OnEnable()
    self:SetTextures("Interface\\Buttons\\UI-Silver-Button-Up");
end

function UIMenuButtonStretchMixin:OnEnter()
    if(self.tooltipText ~= nil) then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip_SetTitle(GameTooltip, self.tooltipText);
        GameTooltip:Show();
    end
end

function UIMenuButtonStretchMixin:OnLeave()
    if(self.tooltipText ~= nil) then
        GameTooltip:Hide();
    end
end
