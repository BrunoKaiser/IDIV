--This script writes the informations of new tables, new columns and measures in DAX in power bi in a tree.

--1. input file name
FileName = "C:\\Temp\\Risikobericht_PBI_DAX_Formeln.txt"


--1.1 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--2. read file of DAX formulae
inputFile=io.open(FileName,"r")
inputText=inputFile:read("*a")
inputFile:close()

--3. treat lines as logical lines
outputFile=io.open(FileName:gsub(".txt","_logic_tree.lua"),"w")
outputFile:write('tree_DAX={branchname="' .. string.escape_forbidden_char(FileName) .. '",\n{branchname="DAX-Formeln",')
variableLineNumber=0
for line in inputText:gmatch("([^\n]*)\n") do
	if line:match("^[^ =%[]* *=") and line:match("^VAR ")== nil then
		variableLineNumber=variableLineNumber+1
		if variableLineNumber==1 then
			outputFile:write('\n')
		else
			outputFile:write('},\n')
		end --if variableLineNumber>1 then 
		outputFile:write('{branchname="' .. line:match("^([^ =%[]*) *=") .. '",\n')
		if line:match("^[^ =%[]* *=(.*)"):gsub(" *","")~="" then
			outputFile:write('"' .. string.escape_forbidden_char(line:match("^[^ =%[]* *=(.*)")) .. '",')
		end --if line:match("^[^ =%[]* *=(.*)"):gsub(" *","")~="" then
	else
		if line:gsub(" *","")~="" then
			outputFile:write('"' .. string.escape_forbidden_char(line) .. '",\n')
		end --if line:gsub(" *","")~="" then
	end --if line:match("^[^ =%[]* *=") and line:match("^VAR ")== nil then
end --for line in inputText:gmatch("([^\n]*)\n") do
outputFile:write('},\n')
outputFile:write('},\n')

--4. execute the tree in a Lua table
dofile(FileName:gsub(".txt","_logic_tree.lua"))

--5. read recursive the tree as Lua table and build dependencies of formulae to dataset
formulaeTable={}
function searchDAXTableRecursive(TreeTable)
	for i,v in ipairs(TreeTable) do
		if type(v)=="table" then
			searchDAXTableRecursive(v)
		else
			if v:match("'[^']*'") then
				--test with: print(i,v:match("'([^']*)'"))
				if formulaeTable[v:match("'([^']*)'")] then
					formulaeTable[v:match("'([^']*)'")][TreeTable.branchname]=true
				else
					formulaeTable[v:match("'([^']*)'")] = {[TreeTable.branchname]=true}
				end --if formulaeTable[v:match("'([^']*)'")] then
				--test with: print(TreeTable.branchname)
			end --if v:match("'[^']*'") then
		end --if type(v)=="table" then
	end --for i,v in ipairs(TreeTable) do
end --function searchDAXTableRecursive(TreeTable)
searchDAXTableRecursive(tree_DAX)

--6. build sorted table of formulae
formulaeSortedTable={}
for k,v in pairs(formulaeTable) do
	--test with: print(k,v)
	formulaeSortedTable[k]={}
	for k1,v1 in pairs(v) do
		--test with: print(k1,v1)
		table.insert(formulaeSortedTable[k],k1)
		table.sort(formulaeSortedTable[k],function (a,b) return a<b end)
	end --for k1,v1 in pairs(v) do
end --for k,v in pairs(formulaeTable) do

--7. build tree for dependencies of formulae from datasets
	outputFile:write('{branchname="Datasets und abhängige berechnete Spalten und Measures",\n')
for k,v in pairs(formulaeSortedTable) do
	--test with: print(k,v)
	outputFile:write('{branchname="' .. k .. '",\n')
	for k1,v1 in pairs(v) do
		--test with: print(k1,v1)
		outputFile:write('"' .. v1 .. '",\n')
	end --for k1,v1 in pairs(v) do
	outputFile:write('},\n')
end --for k,v in pairs(formulaeTable) do
outputFile:write('},\n')

--8. close output file
outputFile:write('}\n')
outputFile:close()
