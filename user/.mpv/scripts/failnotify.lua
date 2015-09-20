local utils = require('mp.utils')

local path = 'file'

mp.add_hook('on_load', 50, function()
    path = mp.get_property('stream-open-filename')
end)

function notify(event)
    if event.reason == 'error' then
        utils.subprocess({
            args={'notify-send', '-t', '1000', 'mpv', 'Failed to play '..path},
            cancellable=false,
        })
    end
end

mp.register_event('end-file', notify)
