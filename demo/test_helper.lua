--[[
 @authors caituo
 @date    2020-02-7 15:19:34
]]--
local test_helper = class("test_helper", global.doMultTableBase)

function test_helper.combine()
    return {"building_func_upgradation", "building_func_assistance", "building_func_military", "building_func_production", }
end

function test_helper:before(tableMap)
    self.newMapList = {}
    for _, tab in pairs(tableMap) do
        for _, v in pairs(tab) do
            if not self.newMapList[v.build_id] then
                self.newMapList[v.build_id] = {}
            end
            if not self.newMapList[v.build_id][v.level] then
                self.newMapList[v.build_id][v.level] = {}
            end
            self.newMapList[v.build_id][v.level] = table.mergeHashTables(self.newMapList[v.build_id][v.level], v)
        end
    end
    return tableMap
end

function test_helper:work(tableMap)
    for k, v in pairs(self.newMapList) do
        self:SetNewTable("build" .. k, v)
    end
    return tableMap
end

function test_helper:after(tableMap)
    self:ExportTable2File()
end

return test_helper
