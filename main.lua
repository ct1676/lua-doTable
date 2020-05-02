--[[
 @authors caituo
 @date    2020-02-7 15:19:34
]]--
--[[
	依赖
	LuaDist
	https://github.com/LuaDist/Binaries/archive/LuaDist-batteries-0.9.8-Windows-x86.zip
]]
--usage:cmd.exe lua.exe [thisproject]\main.lua [targetTablePath]
global = global or {}

local tablePath = ...
print("tablePath:" .. tablePath)

local info = debug.getinfo(1, "S")
local path = info.source
path = string.sub(path, 2, -1)
local scriptPath = string.match(path, "^.*\\")
global.slash = scriptPath and "\\" or "/"
if not scriptPath then
	scriptPath = string.match(path, "^.*/")
end
print("scriptPath:" .. scriptPath)

--搜索路径
package.path = package.path .. ';' .. tablePath .. global.slash ..'?.lua'
package.path = package.path .. ';' .. scriptPath .. '?.lua'

require("util.string")
require("util.table")
require("util.functions")
require("util.logger")
require("util.file")

global.doTableBase = require("doTableBase")
global.tablePath = tablePath
global.scriptPath = scriptPath
global.customPath = scriptPath .. "custom"
 
local need_trans_table = {}
 
--实例化处理脚本
local customScripts = attrdir(global.customPath)
for _,fileName in ipairs(customScripts) do
	local doClass = require("custom." .. fileName).new()
	local combineTable = doClass.combine()
	if "_none_" == combineTable then
		printWarning("combinetable missed", fileName)
	else
		if not need_trans_table[combineTable] then
			need_trans_table[combineTable] = {}
		end
		need_trans_table[combineTable][fileName] = doClass
	end
end

dump(need_trans_table,"need_trans_table",2)

--遍历把源表输入进处理脚本处理
for tableName, v in pairs(need_trans_table) do
	local tableData = require(tableName)
	if tableData then
		printCostTime(function ( ... )
			for _, doClass in pairs(v) do
				doClass:Init(tableName, clone(tableData))
				doClass:Start()
			end
		end, tableName)
	end
end