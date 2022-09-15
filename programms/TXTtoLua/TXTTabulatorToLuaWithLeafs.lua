--This script converts a tabulator tree in a text file in a Lua tree with leafs

--1. read input text file in a text variable
inputFile=io.open("C:\\Temp\\text_xlsx_worksheetscontent.txt","r")
text=inputFile:read("*all")
inputFile:close()

--2.1 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--2.2 function for output of result
printOut=print
function printOut(a)
	outputFile:write(a .. "\n")
end --function printOut(a)

--3. read data from text
outputText='tree_tabtext_script={branchname="Neuer Baum"' --is omitted by get only the new tree without title
pos_prevline=0
pos_curline=0
for line in (text .. "\n"):gmatch("([^\n]*)\n") do
	if line~="" and line:match('%S')~=nil then
		pos_prevline=pos_curline --update position
		pos_curline=0
		local helpstring='\t' .. line
		while helpstring:match('^\t')~=nil do -- get position of current line
			pos_curline=pos_curline+1
			helpstring=helpstring:gsub('^\t','')
		end --while helpstring:match('^\t')~=nil do
		-- modify helpstring in order to get desired results
		while helpstring:match('^ ')~=nil do
			helpstring=helpstring:gsub('^ ', '')
		end --while helpstring:match('^ ')~=nil do
		while helpstring:match('^ ')~=nil do
			helpstring=helpstring:gsub('^ ', '')
		end --while helpstring:match('^ ')~=nil do
		helpstring=string.escape_forbidden_char(helpstring)
		--print(pos_curline, pos_prevline)
		if pos_curline<pos_prevline then
			for i=1, pos_prevline-pos_curline +1 do
				outputText=outputText .. '\n},' 
			end --for i=1, pos_prevline-pos_curline +1 do
		elseif pos_curline==pos_prevline and pos_curline~=0 then
			outputText=outputText .. '\n},' 
		elseif pos_curline==pos_prevline+1 then
			outputText=outputText .. ','
		elseif pos_curline>pos_prevline then
			for i=1, pos_curline-pos_prevline-1 do
				outputText=outputText .. ','
				outputText=outputText .. '\n{branchname="missing",'
			end --for i=1, pos_prevline-pos_curline-1 do
		end --if pos_curline<pos_prevline then
		--if lines are to long then build leafs with the rest of the lines up to a maximum length beeing lower than 259 for IUP tree
		local maxLength=259 --must be lower than 259 for a IUP tree
		if #helpstring>maxLength then
			--collect words from textTable
			local wordTable={}
			for textWord in (helpstring .. " "):gmatch(".- ") do 
				wordTable[#wordTable+1]=textWord 
			end --for textWord in (helpstring .. " "):gmatch(".- ") do 
			--put word in lines together with up to 259 characters until maxLength
			local lineTable={}
			local lineNumber=1
			lineTable[lineNumber]=""
			for i2,k2 in ipairs(wordTable) do 
				if #(lineTable[lineNumber] .. k2) > maxLength then 
					lineNumber=lineNumber+1
					lineTable[lineNumber]=k2
				else
					lineTable[lineNumber]=lineTable[lineNumber] .. k2
				end --if #(lineTable[lineNumber] .. k2) > maxLength then --259
			end --for i2,k2 in ipairs(wordTable) do 
			--put lines to the tree
			outputText=outputText .. '\n{branchname="' .. lineTable[1]:gsub(" $","") .. '",'
			for i=2,#lineTable-1 do
				outputText=outputText .. '\n"' .. lineTable[i]:gsub(" $","") .. '",'
			end --for i=2,#lineTable do
			outputText=outputText .. '\n"' .. lineTable[#lineTable]:gsub(" $","") .. '"'
		else
			outputText=outputText .. '\n{branchname="' .. helpstring:gsub(" $","") .. '"'
		end --if #helpstring>maxLength then
	end --if line~="" and line:match('%S')~=nil then
end --for line in (text .. "\n"):gmatch("([^\n]*)\n") do

--3.1 write end curly brackets
for i=1, pos_curline+1 do
	outputText=outputText .. '\n}'
end --for i=1, pos_curline+1 do
outputText=outputText:gsub(",,",",") --correction for '\n{branchname="missing",' when to or more missings
--test with: print(outputText:match("%b{}"))
--test with: print(outputText)
--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here

--3.2 get only the new tree without title
outputText=outputText:gsub('{branchname="Neuer Baum",',''):gsub('}$','')
if _VERSION=='Lua 5.1' then
	loadstring(outputText)()
else
	load(outputText)() --now actualtree is the table.
end --if _VERSION=='Lua 5.1' then
outputTextLeaf="Tree="

--3.3 build recursively leafs if there is no table as child
local function makeLeafsRecursive(TreeTable,outputTreeTable)
	outputTreeTable.branchname=TreeTable.branchname
	outputTextLeaf=outputTextLeaf .. '{branchname="' .. string.escape_forbidden_char(TreeTable.branchname) .. '",\n'
	--test with: print("B " .. outputTreeTable.branchname)
	for i,v in ipairs(TreeTable) do
		if type(v)=="table" and #v > 0 then
			--test with: print(v.branchname)
			outputTreeTable[i]={}
			makeLeafsRecursive(v,outputTreeTable[i])
		elseif type(v)=="table" then
			outputTreeTable[i]=string.escape_forbidden_char(v.branchname)
			--test with: print("Leaf: " .. v.branchname)
			--test with: print("Leaf: " .. type(outputTreeTable[i]))
			outputTextLeaf=outputTextLeaf .. '"' .. string.escape_forbidden_char(v.branchname) .. '",\n'
		else
			outputTreeTable[i]=string.escape_forbidden_char(v)
			outputTextLeaf=outputTextLeaf .. '"' .. string.escape_forbidden_char(v) .. '",\n'
		end --if #TreeTable > 0 then
	end --for i,v in ipairs(TreeTable) do
	outputTextLeaf=outputTextLeaf .. '},\n'
end --function makeLeafsRecursive(TreeTable,outputTreeTable)
outputtree_tabtext_script={}
makeLeafsRecursive(tree_tabtext_script,outputtree_tabtext_script)

--3.4 omit the last commma
outputTextLeaf=outputTextLeaf:gsub("},\n$","}\n")

--4. write the output file and close it
outputFile=io.open("C:\\Temp\\text_xlsx_worksheetscontent_tree.lua","w")
printOut(outputTextLeaf )
outputFile:close()
