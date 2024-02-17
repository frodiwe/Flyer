local MAX_CAMERA_ZOOM = 50;
local MIN_CAMERA_ZOOM = 15;

local frame = CreateFrame("Frame")
local isMountedBefore = IsMounted()
local unmountedZoom = MIN_CAMERA_ZOOM
local mountedZoom = MAX_CAMERA_ZOOM

frame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
frame:SetScript("OnEvent", function(self, event, ...)
    if event ~= "PLAYER_MOUNT_DISPLAY_CHANGED" then
        return
    end
    
    local isMountedNow = IsMounted()

    if isMountedNow == isMountedBefore then
        return
    end

    if isMountedNow then
        unmountedZoom = GetCameraZoom()
        CameraZoomOut(mountedZoom - unmountedZoom)
    else
        mountedZoom = GetCameraZoom()
        CameraZoomIn(mountedZoom - unmountedZoom)
    end

    isMountedBefore = isMountedNow
end)
