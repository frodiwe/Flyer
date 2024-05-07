local MAX_CAMERA_ZOOM = 50
local MIN_CAMERA_ZOOM = 15

local Flyer = CreateFrame("Frame")
local isMountedBefore = IsMounted()

Flyer:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
Flyer:RegisterEvent("ADDON_LOADED")
Flyer:SetScript("OnEvent", function(self,event,...) self[event](self,event,...);end)

function Flyer:PLAYER_MOUNT_DISPLAY_CHANGED(self, event)
    local isMountedNow = IsMounted()
    local inInstance, instanceType = IsInInstance()

    if inInstance and not enabledInInstances then
        print("kek")
        return
    end
    print("lol")

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
end

function Flyer:ADDON_LOADED(self, addon)
    if not unmountedZoom then
        unmountedZoom = MIN_CAMERA_ZOOM
    end

    if not mountedZoom then
        mountedZoom = MAX_CAMERA_ZOOM
    end

    if not enabledInInstances then
        enabledInInstances = true
    end

    SLASH_FLYER1 = "/flyer"
end

-- /flyer inst on
-- /flyer inst off 
function SlashCmdList.FLYER(msg)
	msg = string.lower(msg)
	cmd, state = strsplit(" ", msg, 2)

    if cmd == "inst" then
        enabledInInstances = (state == "on")

        if enabledInInstances then
            print("Addon enabled in instances (raids, arena, bg)", enabledInInstances)
        else
            print("Addon disabled in instances")
        end
    end
end