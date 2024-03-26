-- This library has been created by JoeyyFrench
-- You can use it to upload an imgur image to a player and use it as material.

-- You are allowed to use it anywhere but you must credit me (JoeyyFrench).
-- Have fun !

JFImgur = JFImgur or {}
JFImgur.ImgursRegistered = JFImgur.ImgursRegistered or {}
JFImgur.Constants = JFImgur.Constants or {}

JFImgur.__index = JFImgur

local function CheckExist(sImageName, sImageLink)
   
    if not isstring(sImageName) then
        return false, error("sImageName must be a string")
    end

    if not isstring(sImageLink) then
        return false, error("sImageLink must be a string")
    end

	for i, t in ipairs(JFImgur.ImgursRegistered) do
		if t.sImageName == sImageName and t.sImageLink == sImageLink then return true, i end
	end

	return false
 
end

-- Create a new imgur image
function JFImgur:Register(sImageName, sImageLink)

    if not isstring(sImageName) then
        return false, error("sImageName must be a string")
    end

    if not isstring(sImageLink) then
        return false, error("sImageLink must be a string")
    end
	
    local bExist, iIndex = CheckExist(sImageName, sImageLink)
    if bExist then table.remove(JFImgur.ImgursRegistered, iIndex) end

    local sImageID = sImageLink:gsub("https://i.imgur.com/", ""):gsub(".jpeg", ".jpg")
    local sURL = ("https://i.imgur.com/%s"):format(sImageID)

    local sImageNameWithoutAccents = sImageName:gsub("[éèàêÉÈ]", "")
    local sFileName = ("%s%s"):format(sImageNameWithoutAccents, sImageID:sub(#sImageID - 3, #sImageID))
    
    local tImgur = {
        sImageName = sImageName,
        sImageLink = sImageLink,
        sFileName = sFileName,
        sDirectNameFile = ("../data/jf_imgurs/%s"):format(sFileName),
        sURL = sURL,
        sImageID = sImageID,
        mImage = nil
    }

    -- Add the imgur image in the table JFImgur.ImgursRegistered
    JFImgur.ImgursRegistered[#JFImgur.ImgursRegistered + 1] = tImgur

    if CLIENT and not file.IsDir("jf_imgurs", "DATA") then
        file.CreateDir("jf_imgurs")
    end

    setmetatable(tImgur, self)
    return tImgur

end

-- Check if the image is already downloaded
function JFImgur:IsDownloaded()

    local bValid = file.Exists(("jf_imgurs/%s"):format(self.sFileName), "DATA")

    if bValid and not JFImgur.Constants[self.sImageName] then
        JFImgur.Constants[self.sImageName] = Material(self.sDirectNameFile)
    end

    return bValid

end

-- Make the image imgur downloaded
function JFImgur:DownloadImage()

    if self:IsDownloaded() and not JFImgur.Constants[self.sImageName] then
        JFImgur.Constants[self.sImageName] = Material(self.sDirectNameFile)
        return false
    end

    if CLIENT then
    
        -- Fetch the data from the image and save it to a data file
        http.Fetch(self.sURL, function(sData)
    
            if not file.IsDir("jf_imgurs/", "DATA") then
                file.CreateDir("jf_imgurs/")
            end
    
            self.sImageID = self.sImageID:lower()
            local sFileName = self.sDirectNameFile
            
            if file.Exists(("jf_imgurs/%s"):format(self.sFileName), "DATA") then
    
                local mMaterial = Material(sFileName)
                JFImgur.Constants[self.sImageName] = mMaterial
                return
    
            end
    
            file.Write(("jf_imgurs/%s"):format(self.sFileName), sData)
            local mMaterial = Material(sFileName)

            JFImgur.Constants[self.sImageName] = mMaterial
            self.mImage = mMaterial
    
        end)

    end

    return self

end

-- Remove all the imgur images from the data
function JFImgur:RemoveImgurImages()
   
	local tFiles, tFolders = file.Find("jf_imgurs", "DATA")
	for i, sFileName in ipairs(tFiles) do
        
        if file.Exists(("jf_imgurs/%s"):format(sFileName), "DATA") then
        	file.Delete(("jf_imgurs/%s"):format(sFileName), "DATA")
        end
        
    end
    
end

-- Get the imgur image
function JFImgur:GetImage()

    if not self.mImage then
        return Material("icon16/arrow_refresh.png")
    end

    return self.mImage

end

setmetatable(JFImgur, {__call = JFImgur.Register})

-- Make the player download all the imgur images registered with a delay between each image
function JFImgur:DownloadRegisterImages(iDelay, fcCallback)

    iDelay = iDelay or 0.1
    local tSeqTable = JFImgur.ImgursRegistered

    local sImageName = ""
    local iIndex = 0

    local sTimerName = "JFImgur:DownloadImgurImages"
    if timer.Exists(sTimerName) then timer.Remove(sTimerName) end

    timer.Create(sTimerName, iDelay, #tSeqTable, function()
    
        iIndex = iIndex + 1
        local tImage = tSeqTable[iIndex]

        if tImage:IsDownloaded() then
            if isfunction(fcCallback) then fcCallback(#tSeqTable, iIndex + 1, sImageName) end
            return
        end

        sImageName = tImage.sImageName
        tImage:DownloadImage()

        if isfunction(fcCallback) then fcCallback(#tSeqTable, iIndex, sImageName) end

    end)

    return #tSeqTable

end

local function CheckImageValid(sImageName)
   
    if not isstring(sImageName) then
        return false
   	end     

    for i, t in ipairs(JFImgur.ImgursRegistered) do
   		if t.sImageName == sImageName then return true end
    end
    
    return false
    
end

-- Get a imgur image from the constants
function JFImgur:GetImgurImage(sImageName)

    if not isstring(sImageName) then
        return Material("icon16/arrow_refresh.png")
    end

    if not CheckImageValid(sImageName) then
        return Material("icon16/arrow_refresh.png")
    end

    return JFImgur.Constants[sImageName] or Material("icon16/arrow_refresh.png")

end
