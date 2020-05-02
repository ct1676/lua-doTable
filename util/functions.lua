--[[
 @authors caituo
 @date    2020-02-7 15:19:34
]]--
function import(moduleName, currentModuleName)
    local currentModuleNameParts
    local moduleFullName = moduleName
    local offset = 1
    
    while true do
        if string.byte(moduleName, offset) ~= 46 then -- .
            moduleFullName = string.sub(moduleName, offset)
            if currentModuleNameParts and #currentModuleNameParts > 0 then
                moduleFullName = table.concat(currentModuleNameParts, ".") .. "." .. moduleFullName
            end
            break
        end
        offset = offset + 1
        
        if not currentModuleNameParts then
            if not currentModuleName then
                local n, v = debug.getlocal(3, 1)
                currentModuleName = v
            end
            currentModuleNameParts = string.split(currentModuleName, ".")
        end
        table.remove(currentModuleNameParts, #currentModuleNameParts)
    end
    
    return require(moduleFullName)
end

function class(classname, super)
    local superType = type(super)
    local cls
    
    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end
    
    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}
        
        if superType == "table" then
            -- copy fields from super
            for k, v in pairs(super) do
                cls[k] = v
            end
            cls.__create = super.__create
            cls.super = super
        else
            cls.__create = super
            cls.ctor = function() end
        end
        
        cls.__cname = classname
        cls.__ctype = 1
        
        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k, v in pairs(cls) do
                instance[k] = v
            end
            instance.class = cls
            instance:ctor(...)
            return instance
        end
        
    else
        -- inherited from Lua Object
        if super then
            cls = {}
            setmetatable(cls, {__index = super})
            cls.super = super
        else
            cls = {ctor = function() end}
        end
        
        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls
        
        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end
    
    return cls
end

function checknumber(value, base)
    return tonumber(value, base) or 0
end

function checkint(value)
    return math.floor(checknumber(value))
end

function checkfloat(value, floatLength)
    floatLength = floatLength or 0
    local multi = math.pow(10, floatLength)
    return checkint(value * multi) / multi
end

function checkbool(value)
    return (value ~= nil and value ~= false)
end

function checktable(value)
    if type(value) ~= "table" then value = {} end
    return value
end

function checkkongstring(value)
    return (type(value) == "string" and value == "")
end

function bool2number(value)
    return (value and 1 or 0)
end

--返回 (数值,是否非法)
function stringformat2number(_value)
    local value = tonumber(_value)
    if value then
        return value, false
    else
        if tostring(value) ~= _value then
            return 0, true
        end
    end
end

function number2bool(value)
    return not not(value and (value > 0 and true or false))
end

--proto数组转table
function prototable2luatable(pt)
    local ret = {}
    for _, v in ipairs(pt) do
        table.insert(ret, v)
    end
    return ret
end

--table随便取一个值
function tablepickoneval(tbl)
    for _, v in pairs(tbl) do
        return v
    end
end

--表转颜色函数需要的参数
function table2colorarray(tbl)
    local _a = tbl[4] or 255
    return tbl[1] / 255, tbl[2] / 255, tbl[3] / 255, _a / 255
end

--策划表内的道具列表转{id,num}格式
function rewardtable2formattable(otbl)
    local ret = {}
    for i = 1, #otbl, 2 do
        table.insert(ret, {
            id = otbl[i],
            num = otbl[i + 1],
        })
    end
    return ret
end

function iskindof(obj, classname)
    local t = type(obj)
    local mt
    if t == "table" then
        mt = getmetatable(obj)
    elseif t == "userdata" then
        --mt = tolua.getpeer(obj)
    end
    
    while mt do
        if mt.__cname == classname then
            return true
        end
        mt = mt.super
    end
    
    return false
end

function handler(obj, method)
    return function(...)
        if not method then
            print("函数未注册")
            dump(obj, "handler数据")
        end
        return method(obj, ...)
    end
end

--数值转罗马数字字符串
function normalInt2RomanInt(num)
    local ans = ''
    local flag = 0
    -- 四位数处理
    if num > 999 then
        -- 取千位直接增加：千位个M
        ans = string.rep('M', (num / 1000))
        -- 三位数处理
    end
    if num > 99 then
        -- 取百位
        flag = (num / 100) % 10
        if flag == 4 then
            ans = ans .. 'CD'
        elseif flag == 9 then
            ans = ans .. 'CM'
        elseif flag >= 5 then
            ans = ans .. 'D' .. string.rep('C', (flag - 5))
        else
            ans = ans .. string.rep('C', flag)
        end
        -- 二位数处理
    end
    if num > 9 then
        flag = (num / 10) % 10
        if flag == 4 then
            ans = ans .. 'XL'
        elseif flag == 9 then
            ans = ans .. 'XC'
        elseif flag >= 5 then
            ans = ans .. 'L' .. string.rep('X', (flag - 5))
        else
            ans = ans .. string.rep('X', flag)
        end
    end
    
    flag = num % 10
    if flag == 4 then
        ans = ans .. 'IV'
    elseif flag == 9 then
        ans = ans .. 'IX'
    elseif flag >= 5 then
        ans = ans .. 'V' .. string.rep('I', (flag - 5))
    else
        ans = ans .. string.rep('I', flag)
    end
    
    return ans
end

function HexNumToRGB(str_num, notfloat, alpha)
    local str_num_six
    if string.len(str_num) == 6 then
        str_num_six = str_num
    else
        str_num_six = string.sub(str_num, 1, 7)
    end
    
    local RGB = {}
    RGB.r = tonumber(string.sub(str_num_six, 1, 2), 16)
    RGB.g = tonumber(string.sub(str_num_six, 3, 4), 16)
    RGB.b = tonumber(string.sub(str_num_six, 5, 6), 16)
    
    if alpha then
        RGB.a = alpha
    else
        RGB.a = 255
    end
    
    if not notfloat then
        RGB.r = RGB.r / 255
        RGB.g = RGB.g / 255
        RGB.b = RGB.b / 255
        RGB.a = RGB.a / 255
    end
    
    return RGB
end