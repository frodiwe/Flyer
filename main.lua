local MAX_CAMERA_ZOOM = 50
local MIN_CAMERA_ZOOM = 15

local Flyer = CreateFrame("Frame")
local isMountedBefore = IsMounted()

-- Useful commands:
--
-- /console scriptErrors 0 | 1 -- show addon errors in-game
-- /run print((select(4, GetBuildInfo()))) -- get current WoW version (for ##Interface line in .toc file)

Flyer:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
Flyer:RegisterEvent("ADDON_LOADED")
Flyer:SetScript("OnEvent", function(self,event,...) self[event](self,event,...);end)

function Flyer:ADDON_LOADED(self, addon)
    if isDebugOn == nil then
        isDebugOn = false
    end

    if isDebugOn then print("Saved unmounted zoom", unmountedZoom) end
    
    if not unmountedZoom then
        unmountedZoom = MIN_CAMERA_ZOOM
    end

    if isDebugOn then print("Saved mounted zoom", mountedZoom) end
    if not mountedZoom then
        mountedZoom = MAX_CAMERA_ZOOM
    end

    if not enabledInInstances then
        enabledInInstances = true
    end

    SLASH_FLYER1 = "/flyer"
end

function Flyer:PLAYER_MOUNT_DISPLAY_CHANGED(self, event)
    local isMountedNow = IsMounted()
    local inInstance, instanceType = IsInInstance()

    if isDebugOn then print("inInstance", inInstance) end
    if isDebugOn then print("instanceType", instanceType) end

    if inInstance and not enabledInInstances then
        if isDebugOn then print("Inside instance") end
        return
    end

    if isDebugOn then print("Outside instance") end

    if isMountedNow == isMountedBefore then
        return
    end

    if isMountedNow then
        unmountedZoom = GetCameraZoom()
        if isDebugOn then print("Saving unmounted zoom", unmountedZoom) end
        CameraZoomOut(mountedZoom - unmountedZoom)
    else
        mountedZoom = GetCameraZoom()
        if isDebugOn then print("Saving mounted zoom", mountedZoom) end
        CameraZoomIn(mountedZoom - unmountedZoom)
    end

    isMountedBefore = isMountedNow
end

function SlashCmdList.FLYER(msg)
	msg = string.lower(msg)
	cmd, state = strsplit(" ", msg, 2)

    if cmd == "inst" then
        enabledInInstances = (state == "on")

        if enabledInInstances then
            print("Flyer is now enabled in instances (raids, arena, bg)")
        else
            print("Flyer is now disabled in instances")
        end
    elseif cmd == "debug" then
        isDebugOn = not isDebugOn

        if isDebugOn then
            print("Flyer debugging enabled")
        else
            print("Flyer debugging disabled")
        end
    else
        print("/flyer inst on -- enables addon in instances (raids, arena, bg)")
        print("/flyer inst off -- disables addon in instances (raids, arena, bg)")
    end
end