local frame = CreateFrame("Frame")
local isMountedInitially = IsMounted()
local initialZoom = GetCameraZoom()

local MAX_CAMERA_ZOOM = 50;

frame:SetScript("OnEvent", function(self, event, ...)
    if event ~= "COMPANION_UPDATE" then
        return
    end

    local companionType = ...

    if companionType ~= "MOUNT" then
        return
    end
    
    C_Timer.NewTicker(0.1, function ()
        local isMountedNow = IsMounted()

        if isMountedNow == isMountedInitially then
            return
        end

        if isMountedNow then
            initialZoom = GetCameraZoom()
            CameraZoomOut(MAX_CAMERA_ZOOM)
        else
            CameraZoomIn(GetCameraZoom() - initialZoom)
        end

        isMountedInitially = isMountedNow
    end, 5)
end)

frame:RegisterEvent("COMPANION_UPDATE")
