# lua-doTable
 build custom lua table files from input table files by codeing less in this project.
# lua的二次导表工具

####依赖：
    LuaDist
    https://github.com/LuaDist/Binaries/archive/LuaDist-batteries-0.9.8-Windows-x86.zip
####用法：
```cmd
cmd.exe lua.exe [thisproject]\main.lua [targetTablePath]
```
####换索引例子
待处理表
```lua
local ret = {
    [1] = {up_grading="a", },
    [2] = {up_grading="b", },
    [3] = {up_grading="c", },
    [4] = {up_grading="d", },
    [5] = {up_grading="e", },
    [6] = {up_grading="f", },
    [7] = {up_grading="g", },
    [8] = {up_grading="h", },
    [9] = {up_grading="i", },
    [10] = {up_grading="j", },
    [11] = {up_grading="k", },
    [12] = {up_grading="l", },
    [13] = {up_grading="m", },
    [14] = {up_grading="n", },
    [15] = {up_grading="o", },
};return ret;
```
处理完
```lua
local ret = {
    ['a']={ ['up_grading']='a', }, 
    ['b']={ ['up_grading']='b', }, 
    ['c']={ ['up_grading']='c', }, 
    ['d']={ ['up_grading']='d', }, 
    ['e']={ ['up_grading']='e', }, 
    ['f']={ ['up_grading']='f', }, 
    ['g']={ ['up_grading']='g', }, 
    ['h']={ ['up_grading']='h', }, 
    ['i']={ ['up_grading']='i', }, 
    ['j']={ ['up_grading']='j', }, 
    ['k']={ ['up_grading']='k', }, 
    ['l']={ ['up_grading']='l', }, 
    ['m']={ ['up_grading']='m', }, 
    ['n']={ ['up_grading']='n', }, 
    ['o']={ ['up_grading']='o', }, 
};return ret;
```
命令行输出
```cmd
tablePath:F:\work\client\racing\Assets\Lua\game\logicModule\data
scriptPath:F:\work\doTable\
- "need_trans_table" = {
-     "club_level" = {
-         cc = *MAX NESTING*
-     }
- }
----begin do [club_level]----
[tip] export table file:        club_level_cc.lua
----end do [club_level]----     cost time:0s
```
换索引脚本
```lua
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
```
只要新增自定义脚本到custom目录，工具会自动识别运行喂食原表，产出新表。
