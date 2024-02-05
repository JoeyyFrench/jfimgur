RX = RX or function(x) x / 1920 * ScrW() end
RY = RY or function(y) y / 1080 * ScrH() end

local IMGUR = JFImgur:Register("heart", "https://i.imgur.com/PoIoDvU.png")
hook.Add("HUDPaint", "JFImgur:HUDPaint", function()

    IMGUR:DownloadImage()
    local mMaterial = JFImgur:GetImgurImage("heart")

    surface.SetDrawColor(color_white)
    surface.SetMaterial(mMaterial)
    surface.DrawTexturedRect(RX(100), RY(100), RX(100), RY(100))

end)