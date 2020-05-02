--[[
 @authors caituo
 @date    2020-02-7 15:19:34
]]--
local ss = class("ss", global.doTableBase)

function ss.combine()
	return "task_source"
end

function ss:before(upTable)
    upTable = table.SetIndexField(upTable, "title")
    return upTable
end

function ss:work(upTable)
    self:SetNewTable("ss", upTable)
    return upTable
end

function ss:after(upTable)
    self:ExportTable2File()
end

return ss