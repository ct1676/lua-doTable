--[[
 @authors caituo
 @date    2020-02-7 15:19:34
]]--
local lfs = require"lfs"

function attrdir(path)
    local list = {}
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
        	local idx = string.find(file, ".lua")
            if idx then
				file = string.sub(file, 1, idx - 1) 
                table.insert(list, file)
            end
        end
    end
    return list
end
