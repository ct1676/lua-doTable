--[[
 @authors caituo
 @date    2020-02-7 15:19:34
]]--

local doTableBase = class("doTableBase")

function doTableBase.combine()
    return "_none_"
end

function doTableBase:Init(tableName, inputTable)
    self.tableName = tableName
    self.inputTable = inputTable
    self.exportConfig = {}
end

function doTableBase:SetNewTable(filename, tbl)
    filename = self.tableName .. "_" .. filename
    self:_setNewTable(filename, tbl)
end

function doTableBase:_setNewTable(filename, tbl)
    self.exportConfig[filename] = tbl
end

function doTableBase:Start(...)
    return self:after(self:work(self:before(self.inputTable)))
end

function doTableBase:before(...)
    return ...
end

function doTableBase:work(...)
    return ...
end

function doTableBase:after(...)
    return ...
end

function doTableBase:ExportTable2File()
    for filename, content in pairs(self.exportConfig) do
        self:_save2file(filename, dumpString(filename, content))
    end
end

function doTableBase:_save2file(filename, content)
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

return doTableBase
