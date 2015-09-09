local utils = require('mp.utils')

function update_nowplaying(text)
    utils.subprocess({
        args={"socat-arg", text, "/tmp/mpv-music.sock"},
        cancellable=false,
    })
end

mp.observe_property('media-title', 'string', function(_, title)
    update_nowplaying(title)
end)

mp.register_event('shutdown', function()
    update_nowplaying('')
end)
