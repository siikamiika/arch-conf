local utils = require("mp.utils")

function dunno()
    mp.add_timeout(1, function()
        mp.commandv('cycle', 'fullscreen')
        mp.add_timeout(0.5, function()
            mp.commandv('cycle', 'fullscreen')
        end)
    end)
    mp.unregister_event(dunno)
end


if not mp.get_property_bool("option-info/vo/set-from-commandline") then
    local vo_no_compton = "opengl:interpolation"
    local vo_compton = "opengl"

    local compton_exists = utils.subprocess({ args={"pgrep", "compton"} }).status

    if compton_exists == 0 then
        mp.set_property("options/vo", vo_compton)
    else
        mp.set_property("options/vo", vo_no_compton)
        mp.register_event('file-loaded', dunno)
    end
end
