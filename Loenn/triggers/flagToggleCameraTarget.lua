local enums = require("consts.celeste_enums")

local trigger = {}

trigger.name = "MaxHelpingHand/FlagToggleCameraTargetTrigger"
trigger.nodeLimits = {1, 1}
trigger.placements = {
    name = "trigger",
    data = {
        lerpStrength = 0.0,
        positionMode = "NoEffect",
        xOnly = false,
        yOnly = false,
        deleteFlag = "",
        flag = "flag_toggle_camera_target",
        inverted = false
    }
}

trigger.fieldInformation = {
    positionMode = {
        options = enums.trigger_position_modes,
        editable = false
    }
}

return trigger