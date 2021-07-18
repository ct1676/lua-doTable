--[[
 @authors caituo
 @date    2020-02-7 15:19:34
]]--

local doMultTableBase = class("doMultTableBase")

function doMultTableBase:ctor()
    self.inputTableList = {}
    self.exportConfig = {}
end

function doMultTableBase.combine()
    return "_none_"
end

function doMultTableBase:AddTable(tableName, inputTable)
    self.inputTableList[tableName] = inputTable
end

function doMultTableBase:SetNewTable(filename, tbl)
    self:_setNewTable(filename, tbl)
end

function doMultTableBase:_setNewTable(filename, tbl)
    self.exportConfig[filename] = tbl
end

function doMultTableBase:Start(...)
    return self:after(self:work(self:before(self.inputTableList)))
end

function doMultTableBase:before(...)
    return ...
end

function doMultTableBase:work(...)
    return ...
end

function doMultTableBase:after(...)
    return ...
end

function doMultTableBase:ExportTable2File()
    for filename, content in pairs(self.exportConfig) do
        self:_save2file(filename, dumpString(filename, content))
    end
end

function doMultTableBase:_save2file(filename, content)
    function writefile(path, content, mode)
        mode = mode or "w+b"
        local file = io.open(path, mode)
        if file then
            if file:write(content) == nil then return false end
            io.close(file)
            return true
        else
            return false
        end
    end
    local realFilename = filename .. ".lua"
    writefile(global.tablePath .. global.slash .. realFilename, content)
    printTip("export table file:", realFilename)
end

return doMultTableBase
