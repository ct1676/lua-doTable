--[[
 @authors caituo
 @date    2020-02-7 15:19:34
]]--
function _dump2String(value)
    local function _value(v)
        if type(v) == "number" then
            v = "[" .. v .. "]"
        elseif type(v) == "string" then
            v = "['" .. v .. "']"
        end
        return v
    end
    
    local function _key(v)
        if type(v) == "string" then
            v = "'" .. v .. "'"
        elseif type(v) == "boolean" then
            v = v and "true" or "false"
        end
        return v
    end
    
    local function _dump(value, desciption)
        local ret = ""
        if type(value) ~= "table" then
            if desciption then
                ret = ret .. string.format("%s=%s, ", _value(desciption), _key(value))
            else
                ret = ret .. _key(value)
            end
        else
            if desciption then
                ret = ret .. string.format("%s={ ", _value(desciption))
            else
                ret = ret .. "{"
            end
            table.loopMapTable(value, function (i, k, v)
                if type(k) == "number" then
                    if type(v) ~= "table" then
                        ret = ret .. _value(k) .. "=" .. _key(v) .. ", "
                    else
                        ret = ret .. _dump(v, k)
                    end
                else
                    ret = ret .. _dump(v, k)
                end
            end)
            ret = ret .. "}, "
        end
        return ret
    end
    
    if type(value) == "table" then
        local result = ""
        result = "local ret = {\n"
        table.loopMapTable(value, function (i, k, v)
            result = result .. "    " .. _dump(v, k) .. "\n"
        end)
        result = result .. "};return ret;"
        return result
    else
        return values
    end
end

function dumpString(tag, ...)
    local ret = _dump2String(...)
    local func = loadstring(ret)
    local status, err = pcall(func)
    if not status then
        printError(tag, err)
        return
    end
    return ret
end

function dump(value, desciption, nesting)
    if type(nesting) ~= "number" then
        nesting = 3
    end
    
    local lookupTable = {}
    local result = {}
    
    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end
    
    local traceback = string.split(debug.traceback("", 2), "\n")
    local text = "dump from: " .. string.trim(traceback[4])
    
    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(value) ~= "table" then
            result[# result + 1] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
        elseif lookupTable[value] then
            result[# result + 1] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[# result + 1] = string.format("%s%s = *MAX NESTING*", indent, desciption)
            else
                result[# result + 1] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent .. "    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[# keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then
                        keylen = vkl
                    end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[# result + 1] = string.format("%s}", indent)
            end
        end
    end
    _dump(value, desciption, "- ", 1)
    
    for i, line in ipairs(result) do
        print(line)
    end
end

function printWarning(str, ...)
    print("[warning] " .. str, ...)
end

function printTip(str, ...)
    print("[tip] " .. str, ...)
end

function printError(str, ...)
    print("[error] " .. str, ...)
end

function printCostTime(func, flag)
    print("----begin do [" .. flag .. "]----")
    local s = os.clock()
    func()
    local e = os.clock()
    print("----end do [" .. flag .. "]----", "cost time:"..e - s.."s")
end
