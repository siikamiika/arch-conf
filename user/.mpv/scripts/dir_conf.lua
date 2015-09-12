local utils = require('mp.utils')

function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

local completed = false
local storage_path = nil
local new_options = {}

local options = Set{
    'vid',
    'aid',
    'sid',
    'secondary-sid',
    'audio-delay',
    'sub-delay',
    'video-aspect',
    'volume',
}

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

mp.add_hook("on_load", 50, function ()
    if completed then return end
    for p in pairs(options) do
        mp.observe_property(p, 'string', function(property, value)
            if value then
                new_options[property] = value
            end
        end)
    end
    local path = utils.getcwd()
    path = utils.join_path(path, mp.get_property('path'))
    path = utils.split_path(path)
    storage_path = utils.join_path(script_dir(), 'dir_conf_storage')
    storage_path = utils.join_path(storage_path, path:gsub('[\\/:]', '.'))

    for line in readAll(storage_path):gmatch("[^\r\n]+") do
        line = line:split("=", 1)
        mp.set_property('options/'..line[1], line[2])
    end
    completed = true
end)


mp.register_event('shutdown', function()
    local file_content = {}
    for property, value in pairs(new_options) do
        file_content[#file_content+1] = property..'='..value
    end
    file_content = table.concat(file_content, '\n')
    local f = io.open(storage_path, 'w')
    f:write(file_content)
end)
