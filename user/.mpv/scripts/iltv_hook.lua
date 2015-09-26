local utils = require('mp.utils')

mp.add_hook("on_load", 9, function()
    local url = mp.get_property("stream-open-filename")

    if (url:find('http://www.iltalehti.fi/iltv') == 1) then
        local url = utils.subprocess({args={'iltv-url', url, '^.*?mp4$'}}).stdout
        mp.set_property('stream-open-filename', url)
    end
end)
