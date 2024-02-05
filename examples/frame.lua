RX = RX or function(x) x / 1920 * ScrW() end
RY = RY or function(y) y / 1080 * ScrH() end

local IMGUR = JFImgur:Register("heart", "https://i.imgur.com/PoIoDvU.png")
function JFImgur:OpenMainMenu()

    IMGUR:DownloadImage()
    if IsValid(self.vMainMenu) then self.vMainMenu:Remove() end

    local vFrame = vgui.Create("DFrame")
    vFrame:SetSize(RX(400), RY(400))
    vFrame:Center()
    vFrame:SetTitle("")
    vFrame:MakePopup()
    vFrame:SetDraggable(false)
    function vFrame:Paint(w, h)

        local mMaterial = JFImgur:GetImgurImage("heart")

        surface.SetDrawColor(color_white)
        surface.SetMaterial(mMaterial)
        surface.DrawTexturedRectRotated(w/2, h/2, w/1.4, h/1.4, 0)

    end

    vFrame.vMainMenu = vFrame

end