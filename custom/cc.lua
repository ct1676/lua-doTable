--[[
 @authors caituo
 @date    2020-02-7 15:19:34
]]--
local cc = class("cc", global.doTableBase)

function cc.combine()
	return "club_level"
end

function cc:before(upTable)
    upTable = table.SetIndexField(upTable, "up_grading")
    return upTable
end

function cc:work(upTable)
    self:SetNewTable("cc", upTable)
    return upTable
end

function cc:after(upTable)
    self:ExportTable2File()
end

return cc