--This script calculates the parts on each branch and distributes the value on the root node into the tree nodes

--1. tree
Tree={branchname="Gesamt:12345.35",
    {branchname="Halle 1;0.5",},
    {branchname="Halle 2;0.4",},
    {branchname="Gebäude 1",
        {branchname="Gebäude 1.1;",
        },
        {branchname="Gebäude 1.2;0.9",
        }
    }
}

--2. recursive function for calculating the missing part
function sumPartRecursive(TreeTable)
    local sumPart=1
    local iBlank
    for i,v in ipairs(TreeTable) do
        if v.branchname:match(";(%d+%.?%d*)") then
            sumPart=sumPart-tostring(v.branchname:match(";(%d+%.?%d*)"))
        else
            v.branchname=v.branchname:gsub(";$","")
            iBlank=i
        end --if v.branchname:match(";(%d+%.?%d*)") then
    end --for i,v in ipairs(TreeTable) do
    if iBlank then
        TreeTable[iBlank].branchname=TreeTable[iBlank].branchname .. ";" .. sumPart
    end --if iBlank then
    for i,v in ipairs(TreeTable) do
        if type(v)=="table" then
            sumPartRecursive(v)
        end --if type(v)=="table" then
    end --for i,v in ipairs(TreeTable) do
end --function sumPartRecursive(TreeTable)

--3. recursive function distributing the value of the branchname into all sub branches
function distributeRecursive(TreeTable)
    local totalNumber=0
    if TreeTable.branchname:match(":(%d+%.?%d*)") then
        totalNumber=tonumber(TreeTable.branchname:match(":(%d+%.?%d*)"))
    end --if TreeTable.branchname:match(":%d+%.?%d*")
    for i,v in ipairs(TreeTable) do
        if v.branchname:match(";(%d+%.?%d*)") then
            v.branchname=v.branchname .. ":" .. tostring(v.branchname:match(";(%d+%.?%d*)"))*totalNumber
        end --if v.branchname:match(";(%d+%.?%d*)") then
    end --for i,v in ipairs(TreeTable) do
    for i,v in ipairs(TreeTable) do
        if type(v)=="table" then
            distributeRecursive(v)
        end --if type(v)=="table" then
    end --for i,v in ipairs(TreeTable) do
end --function distributeRecursive(TreeTable)

--4. applying calculation of parts
sumPartRecursive(Tree)

--print example
print(Tree[3].branchname)
print(Tree[3][1].branchname)

--5. applying distribution of value
distributeRecursive(Tree)

--print example
print(Tree[3].branchname)
print(Tree[3][1].branchname)
