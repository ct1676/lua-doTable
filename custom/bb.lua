--[[
 @authors caituo
 @date    2020-02-7 15:19:34
]]--
local bb = class("bb", global.doTableBase)

function bb.combine()
	return "club_level"
end

function bb:before(upTable)
    upTable = table.CutField(upTable, {"up_grading", "active_club_standard", "R4member_limit", "R5member_limit", "manager_limit"})
    return upTable
end

function bb:work(upTable)
    self:SetNewTable("bb", upTable)
    return upTable
end

function bb:after(upTable)
    self:ExportTable2File()
end

return bb
