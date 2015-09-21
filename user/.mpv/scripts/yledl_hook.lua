local utils = require('mp.utils')
local BASE = '/tmp/ylestream/'

function string:ends(End)
    return End == '' or self:sub(-End:len()) == End
end

mp.add_hook("on_load", 9, function()

    local url = mp.get_property("stream-open-filename")

    if (url:find('http://yle.fi') == 1) or
        (url:find('http://areena.yle.fi') == 1) or
        (url:find('http://arenan.yle.fi') == 1) or
        (url:find('http://svenska.yle.fi') == 1) or
        (url:find('http://www.yle.fi') == 1) then

        os.execute('mkdir '..BASE)

        mp.register_event('end-file', function()
            os.execute('kill $(cat '..BASE..'pid)')
            os.execute('rm -rf '..BASE)
        end)

        utils.subprocess({args={'yle-stream', url}})

        local counter = 0
        while true do
            local f = io.open(BASE..'ylestream.mp4', 'r')
            if f ~= nil then
                io.close(f)
                break
            end
            counter = counter + 1
            if counter > 10 then break end
            os.execute('sleep 1')
        end

        mp.set_property('file-local-options/keep-open', 'yes')
        mp.set_property('stream-open-filename', BASE..'ylestream.mp4')

        function add_subs()
            local files = utils.readdir(BASE, 'files')
            for _, f in pairs(files) do
                if (f:ends('.srt')) then
                    mp.commandv('sub-add', utils.join_path(BASE, f))
                end
            end
            mp.unregister_event(add_subs)
        end

        mp.register_event('playback-restart', add_subs)
    end
end)
