local utils = require("mp.utils")

local vo_compton = "opengl:waitvsync:interpolation"

function dunno()
    mp.add_timeout(1, function()
        mp.commandv('cycle', 'fullscreen')
        mp.add_timeout(0.5, function()
            mp.commandv('cycle', 'fullscreen')
        end)
    end)
    mp.unregister_event(dunno)
end


if os.getenv('DISPLAY') == ':0' then
    if not mp.get_property_bool("option-info/vo/set-from-commandline") then
        if utils.subprocess({ args={"pgrep", "compton"} }).status == 0 then
            mp.set_property("options/vo", vo_compton)
        else
            local hdmi_connected = os.execute('xrandr | grep "HDMI1 connected"')
            if not hdmi_connected then
                mp.register_event('file-loaded', dunno)
            end
        end
    end
end
