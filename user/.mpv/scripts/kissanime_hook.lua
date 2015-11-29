local utils = require('mp.utils')

mp.add_hook("on_load", 9, function()
    local url = mp.get_property("stream-open-filename")

    if (url:find('https://kissanime.to') == 1) then
        local url = utils.subprocess({args={'kissanime-stream-url', url}}).stdout
        mp.set_property('stream-open-filename', url)
    end
end)
