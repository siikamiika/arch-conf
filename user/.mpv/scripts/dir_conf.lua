local utils = require('mp.utils')

function readAll(file)
    local f = io.open(file, "rb")
    local content = ""
    if f then
        content = f:read("*all")
        f:close()
    end
    return content
end

function string:split(delim, max_splits)
    if max_splits == nil or max_splits < 1 then
        max_splits = 0
    end
    local result = {}
    local pattern = "(.-)"..delim.."()"
    local splits = 0
    local last_pos = 1
    for part, pos in self:gmatch(pattern) do
        splits = splits + 1
        result[splits] = part
        last_pos = pos
        if splits == max_splits then break end
    end
    result[splits + 1] = self:sub(last_pos)
    return result
end

function script_dir()
   local path = debug.getinfo(2, "S").source:sub(2)
   path = utils.split_path(path)
   return path
end

local properties = {
    ['vid']='auto',
    ['aid']='auto',
    ['sid']='auto',
    ['secondary-sid']='auto',
    ['audio-delay']='0.0',
    ['sub-delay']='0.0',
    ['video-aspect']='-1.0',
    ['volume']='70.0',
    ['vf']='',
    ['af']='',
}

local hook_executed = false
local storage_path = nil
local new_properties = {}

mp.add_hook("on_load", 50, function ()
    if hook_executed then return end

    for p in pairs(properties) do
        mp.observe_property(p, 'string', function(property, value)
            if value then
                if property == 'video-aspect' then
                    local par = mp.get_property_native('video-params/par')
                    local default = properties[property]
                    if par then
                        if math.abs(par - 1) < 0.01 then
                            value = default
                        end
                    else
                        value = default
                    end
                end
                new_properties[property] = value
            end
        end)
    end

    local protocol = nil
    local media_path = mp.get_property('path')
    local filename = nil

    for _, p in pairs({'http://', 'https://', 'ftp://'}) do
        if media_path:find(p) == 1 then
            protocol = p
            break
        end
    end

    if protocol then
        filename = media_path:sub(protocol:len() + 1)
        filename = filename:split('/', 1)[1]..'.domain'
    else
        local media_dir = utils.getcwd()
        media_dir = utils.join_path(media_dir, media_path)
        media_dir = utils.split_path(media_dir)
        filename = media_dir
    end

    storage_path = utils.join_path(script_dir(), 'dir_conf_storage')
    utils.subprocess({args={'mkdir', storage_path}})
    storage_path = utils.join_path(storage_path, filename:gsub('[\\/:]', '_'))

    for line in readAll(storage_path):gmatch("[^\r\n]+") do
        line = line:split("=", 1)
        mp.set_property('options/'..line[1], line[2])
    end

    hook_executed = true
end)

function save_properties()
    local file_content = {}

    for property, value in pairs(new_properties) do
        file_content[#file_content+1] = property..'='..value
    end

    file_content = table.concat(file_content, '\n')
    local f = io.open(storage_path, 'w')
    f:write(file_content)
end

mp.add_key_binding('F', 'dir_conf_enable', function()
    mp.register_event('shutdown', save_properties)
    mp.osd_message('Current properties will be saved for this directory.')
end)

mp.add_key_binding('D', 'dir_conf_delete', function()
    mp.unregister_event(save_properties)
    os.remove(storage_path)
    for p, v in pairs(properties) do
        mp.set_property(p, v)
    end
    mp.osd_message('Directory specific properties deleted and restored to default values.')
end)
