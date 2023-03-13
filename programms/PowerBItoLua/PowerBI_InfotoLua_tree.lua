--This script builds a tree from the infos of a power BI file

--1. name of the text file with info copied from power bi file
FileName="C:\\Temp\\testPB_Info.txt"

--1.1 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--2. read input file and put lines together to standardize it 
inputFile=io.open(FileName,"r")
inputText=inputFile:read("*a")
inputFile:close()
inputText=inputText:gsub(",\n",", ")

--2.1 open output file for the tree
outputFile=io.open(FileName:gsub(".txt","_tree.lua"),"w")

--3. put informations about input data and tables in power bi in a Lua table
InputTable={}
for line in inputText:gmatch("([^\n]*)\n") do
	line=line:gsub(", %[CreateNavigationProperties=true%]","")
	if line:match("^ *Quelle *= *.*File.Contents") then
		--test with: print('{branchname="' .. string.escape_forbidden_char(line:match('File.Contents%("([^%)]*)"%)')) .. '",')
		--test with: print(line:match('Item="([^"]*)"'))
		if InputTable[string.escape_forbidden_char(line:match('File.Contents%("([^%)]*)"%)'))] then
			table.insert(InputTable[string.escape_forbidden_char(line:match('File.Contents%("([^%)]*)"%)'))], line:match('Item="([^"]*)"'))
		else
			InputTable[string.escape_forbidden_char(line:match('File.Contents%("([^%)]*)"%)'))]={line:match('Item="([^"]*)"')}
		end --if InputTable[string.escape_forbidden_char(line:match('File.Contents%("([^%)]*)"%)'))] then
	end --if line:match("^Quelle") then
end --for line in inputText:gmatch("([^\n]*)\n") do

--3.1 sort the Lua table
InputsortedTable={}
for k,v in pairs(InputTable) do
	table.insert(InputsortedTable,k)
end --for k,v in pairs(InputTable) do
table.sort(InputsortedTable, function(a,b) return a<b end)

--4. write the tree text file
outputFile:write('Tree={branchname="' .. string.escape_forbidden_char(FileName:gsub(".txt",".pbix")) .. '",\n')
for k,v in pairs(InputsortedTable) do
	outputFile:write('{branchname="' .. v .. '",\n')
	table.sort(InputTable[v], function(a,b) return a<b end)
	for k1,v1 in pairs(InputTable[v]) do
		outputFile:write('"' .. v1 .. '",\n') 
	end --for k1,v1 in pairs(InputTable) do
	outputFile:write('},\n')
end --for k,v in pairs(InputTable) do 
outputFile:write('}\n')
outputFile:close()
