--[[
 @authors caituo
 @date    2020-02-7 15:19:34
]]--
--类似栈pop
function table.pop(t)
    local last = t[#t]
    table.remove(t, #t)
    return last
end

--清空表
function table.clear(t)
    for k, v in pairs(t) do
        t[k] = nil
    end
end

--表数量
function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

--copy
function table.copy(ori_table, new_table)
    if type(ori_table) ~= "table" or type(new_table) ~= "table" or #new_table ~= 0 then
        return
    end
    
    for k, v in pairs(ori_table) do
        local vtype = type(v)
        if vtype == "table" then
            new_table[k] = {}
            table.copy(v, new_table[k])
        else
            new_table[k] = v
        end
    end
end

--克隆
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

--反转
function table.reverse(t)
    local cloneTable = clone(t)
    
    for i = 1, #t do
        t[i] = cloneTable[#t - i + 1]
    end
end

function table.removeTableData(tb, conditionFunc, once)
    if tb and next(tb) then
        for i = #tb, 1, -1 do
            if conditionFunc(tb[i]) then
                table.remove(tb, i)
                if once then
                    break
                end
            end
        end
    end
end

function table.mergeTables(...)
    local tabs = {...}
    if not tabs then
        return {}
    end
    local origin = tabs[1]
    for i = 2, #tabs do
        if origin then
            if tabs[i] then
                for k, v in pairs(tabs[i]) do
                    table.insert(origin, v)
                end
            end
        else
            origin = tabs[i]
        end
    end
    return origin
end

function table.mergeHashTables(...)
    local tabs = {...}
    if not tabs then
        return {}
    end
    local origin = tabs[1]
    for i = 2, #tabs do
        if origin then
            if tabs[i] then
                for k, v in pairs(tabs[i]) do
                    origin[k] = v
                end
            end
        else
            origin = tabs[i]
        end
    end
    return origin
end

function table.isInTable(tb, _v)
    for _, v in pairs(tb) do
        if v == _v then
            return true
        end
    end
    return false
end

--取表范围内的表
function table.capture(tb, st, et)
    local ret = {}
    if #tb >= st then
        for i = st, et do
            local val = tb[i]
            if val then
                table.insert(ret, val)
            end
        end
    end
    return ret
end

--按顺序循环map的table
function table.loopMapTable(tb, handl, isFall)
    local keys = {}
    local values = {}
    for k, v in pairs(tb) do
        keys[#keys + 1] = k
        values[k] = v
    end
    table.sort(keys, function(a, b)
        if type(a) == "number" and type(b) == "number" then
            if isFall then
                return a > b
            else
                return a < b
            end
        else
            return tostring(a) < tostring(b)
        end
    end)
    for i, k in ipairs(keys) do
        handl(i, k, values[k])
    end
end

function table.SetIndexField(tbl, fieldName)
    local ret = {}
    local keys = {}
    local values = {}
    for _, v in pairs(tbl) do
        local newKey = v[fieldName]
        if values[newKey] then
            printWarning("key repeat:", newKey)
        else
            keys[#keys + 1] = newKey
            values[newKey] = v
        end
    end
    table.sort(keys, function(a, b)
        if type(a) == "number" and type(b) == "number" then
            return a < b
        else
            return tostring(a) < tostring(b)
        end
    end)
    for _, v in ipairs(keys) do
        ret[v] = values[v]
    end
    return ret
end

function table.SetIndexFieldAndFoldSubTblIn(tbl, fieldName)
    local ret = {}
    local keys = {}
    local values = {}
    for _, v in pairs(tbl) do
        local newKey = v[fieldName]
        if values[newKey] then
            table.insert(values[newKey], v)
        else
            keys[#keys + 1] = newKey
            values[newKey] = {v}
        end
    end
    table.sort(keys, function(a, b)
        if type(a) == "number" and type(b) == "number" then
            return a < b
        else
            return tostring(a) < tostring(b)
        end
    end)
    for _, v in ipairs(keys) do
        ret[v] = values[v]
    end
    return ret
end

function table.SetIndexFieldAndFoldSubTblInByOriIdx(tbl, fieldName)
    local ret = {}
    local keys = {}
    local values = {}
    for k, v in pairs(tbl) do
        local newKey = v[fieldName]
        if values[newKey] then
            values[newKey][k] = v
        else
            keys[#keys + 1] = newKey
            values[newKey] = {[k] = v}
        end
    end
    table.sort(keys, function(a, b)
        if type(a) == "number" and type(b) == "number" then
            return a < b
        else
            return tostring(a) < tostring(b)
        end
    end)
    for _, v in ipairs(keys) do
        ret[v] = values[v]
    end
    return ret
end

function table.SetIndexFieldAndFoldSubTblInByOtherField(tbl, fieldName, otherFieldName)
    local ret = {}
    local keys = {}
    local values = {}
    for k, v in pairs(tbl) do
        local newKey = v[fieldName]
        if values[newKey] then
            values[newKey][v[otherFieldName]] = v
        else
            keys[#keys + 1] = newKey
            values[newKey] = {[v[otherFieldName]] = v}
        end
    end
    table.sort(keys, function(a, b)
        if type(a) == "number" and type(b) == "number" then
            return a < b
        else
            return tostring(a) < tostring(b)
        end
    end)
    for _, v in ipairs(keys) do
        ret[v] = values[v]
    end
    return ret
end

--遍历子表排序
function table.SortSubTbl(tbl, sortFunc)
    for _, v in pairs(tbl) do
        table.sort(v, sortFunc)
    end
    return tbl
end

function table.RemoveRecord(tbl, func, once)
    local saveList = {}
    for k, v in pairs(tbl) do
        if func(v) then
            saveList[k] = v
            if once then
                break
            end
        end
    end
    return saveList
end

function table.CutField(tbl, fieldNames)
    local _cuts = {}
    for _, v in ipairs(fieldNames) do
        _cuts[v] = true
    end
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            for key, value in pairs(v) do
                if _cuts[key] then
                    tbl[k][key] = nil
                end
            end
        end
    end
    return tbl
end

function table.RetainField(tbl, fieldNames)
    local _cuts = {}
    for _, v in ipairs(fieldNames) do
        _cuts[v] = true
    end
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            for key, value in pairs(v) do
                if not _cuts[key] then
                    tbl[k][key] = nil
                end
            end
        end
    end
    return tbl
end
