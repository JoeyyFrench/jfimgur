-- This library has been created by JoeyyFrench
-- You can use it to upload an imgur image to a player and use it as material.

-- You are allowed to use it anywhere but you must credit me (JoeyyFrench).
-- Have fun !

JFImgur = JFImgur or {}
JFImgur.ImgursRegistered = JFImgur.ImgursRegistered or {}
JFImgur.Constants = JFImgur.Constants or {}

JFImgur.__index = JFImgur

-- Create a new imgur image
function JFImgur:Register(sImageName, sImageLink)

    if not isstring(sImageName) then
        return false, error("sImageName must be a string")
    end

    if not isstring(sImageLink) then
        return false, error("sImageLink must be a string")
    end

    local sImageID = sImageLink:gsub("https://i.imgur.com/", ""):gsub(".jpeg", ".jpg")
    local sURL = ("https://i.imgur.com/%s"):format(sImageID)

    local sFileName = ("%s%s"):format(sImageName, sImageID:sub(#sImageID - 3, #sImageID))

    local tImgur = {
        sImageName = sImageName,
        sImageLink = sImageLink,
        sFileName = sFileName,
        sDirectNameFile = ("../data/jf_imgur/%s"):format(sFileName),
        sURL = sURL,
        sImageID = sImageID,
        mImage = nil
    }

    if JFImgur.ImgursRegistered[sImageName] then
        JFImgur.ImgursRegistered[sImageName] = nil
    end

    -- Add the imgur image in the table JFImgur.ImgursRegistered
    JFImgur.ImgursRegistered[sImageName] = tImgur

    if CLIENT and not file.IsDir("jf_imgur", "DATA") then
        file.CreateDir("jf_imgur")
    end

    setmetatable(tImgur, self)
    return tImgur

end

-- Check if the image is already downloaded
function JFImgur:IsDownloaded()
    return file.Exists(("jf_imgur/%s"):format(self.sFileName), "DATA")
end

-- Make the image imgur downloaded
function JFImgur:DownloadImage()

    if self:IsDownloaded() then
        JFImgur.Constants[self.sImageName] = Material(self.sDirectNameFile)
        return false
    end

    if CLIENT then
    
        -- Fetch the data from the image and save it to a data file
        http.Fetch(self.sURL, function(sData)
    
            if not file.IsDir("jf_imgur/", "DATA") then
                file.CreateDir("jf_imgur/")
            end
    
            self.sImageID = self.sImageID:lower()
            local sFileName = self.sDirectNameFile
            
            if file.Exists(("jf_imgur/%s"):format(self.sFileName), "DATA") then
    
                local mMaterial = Material(sFileName)
                JFImgur.Constants[self.sImageName] = mMaterial
                return
    
            end
    
            file.Write(("jf_imgur/%s"):format(self.sFileName), sData)
            local mMaterial = Material(sFileName)

            JFImgur.Constants[self.sImageName] = mMaterial
            self.mImage = mMaterial
    
        end)

    end

    return self

end

-- Get the imgur image
function JFImgur:GetImage()

    if not self.mImage then
        return Material("icon16/user.png")
    end

    return self.mImage

end

setmetatable(JFImgur, {__call = JFImgur.Register})

-- Get a imgur image from the constants
function JFImgur:GetImgurImage(sImageName)

    if not isstring(sImageName) then
        return false, error("sImageName must be a string")
    end

    if not JFImgur.ImgursRegistered[sImageName] then
        return false, error("The imgur image is not registered")
    end

    return JFImgur.Constants[sImageName]

end