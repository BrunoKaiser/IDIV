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
for line in inputText:gmatch("([^\n]*)\n") do
	if line:match("^[^ =%[]* *=") and line:match("^VAR ")== nil then
		outputFile:write('},\n')
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
outputFile:write('}\n')
outputFile:close()
