--This programm collects data from a SAS programm to show the data flows, i.e. input and output tables

--1.1 filename
filename="C:\\Temp\\SAS_script.sas"

--1.2 standardize the sas file to get lines with end semicolon
outputfile1=io.open("C:\\Temp\\SAS_programm_logic.sas","w")
lineEnd="no"
lineLogic=""
lineNumber=0
for line in io.lines(filename) do
	lineNumber=lineNumber+1
	if line:match(";") then
		lineEnd="yes"
		lineLogic=lineLogic .. line
		outputfile1:write(lineLogic:gsub("; *$","~"):gsub(";",";\n"):gsub("~$",";") .. "\n")
		lineLogic=""
	elseif line:match("^[ \t]*/%*[^;]*%*/$") then
		--take out comments in one line
		lineEnd="no"
	else
		lineEnd="no"
		lineLogic=lineLogic .. line
	end --if line:match(";") then
end --for line in io.lines("P:\\DIS-WS\\CrisDa - Phase 3\\07 SAS\\Masterlist\\Makros\\Module\\AS400_Syst_EWB.sas") do
outputfile1:close()

--2. choose the input and output statements
outputfile2=io.open("C:\\Temp\\SAS_programm_logic_input_output.txt","w")
for line in io.lines("C:\\Temp\\SAS_programm_logic.sas") do
	line=line:lower():gsub("%([^%(%)]*%)",""):gsub("%([^%(%)]*%)",""):gsub("%([^%(%)]*%)",""):gsub("%([^%(%)]*%)",""):gsub("%([^%(%)]*%)","")
		:gsub("/%*%-%-&","xxx")
		:gsub("&","xxx")
		:gsub("%.%.%-%-%*/","yyyz")
		:gsub("%.","yyy")
		:gsub("[ \t]*end[ \t]*=[ \t]*anzahl ;",";")
		:gsub("nodupkey","")
		:gsub("proc sort data[ \t]*=[ \t]*[^ ]+[ \t]*;",";")
	if line:lower():match("^[ \t]*data ") then outputfile2:write(line)
	elseif line:lower():match(" data[ \t]*=") then outputfile2:write(line .. "\n")
	elseif line:lower():match("[ \t]*create table[ \t]*") then outputfile2:write(line .. "\n")
	elseif line:lower():match(" out[ \t]*=") then outputfile2:write(line .. "\n")
	elseif line:lower():match("dupout[ \t]*=") then outputfile2:write(line .. "\n")
	elseif line:lower():match("^[ \t]*set[ \t]*") then outputfile2:write(line .. "\n") 
	elseif line:lower():match("^[ \t]*merge[ \t]*") then outputfile2:write(line .. "\n") end
end --for line in io.lines("C:\\Temp\\SAS_programm_logic.sas") do
outputfile2:close()

--3. build output tree with tabs
_NULL_Number=0
outputfile3=io.open("C:\\Temp\\SAS_programm_logic_input_output_tree.txt","w")
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output.txt") do
	line=line:upper():gsub("[ \t]*=[ \t]*","=")
	local dataline=line:upper():match("^[ \t]*DATA([^;]*);") 
	local setline=line:upper():match("[ \t]*SET([^;]*);") 
	local mergeline=line:upper():match("[ \t]*MERGE([^;]*);") 
	local dataequalline=line:upper():gsub("FILE","~"):match(" DATA=([^;]*)[ \t]+OUT[~]?=") 
	local dupoutline=line:upper():gsub("OUT=.*DUPOUT","DUPOUT"):match("[ \t]*DUPOUT[ \t]*=([^;]*);") 
	local outline=line:upper():gsub("DUPOUT=.*;",";"):gsub("FILE","~"):match("[ \t]*OUT[~]?=([^;]*);") 
	local createtableline=line:upper():match("^[ \t]*CREATE TABLE[ \t]*([^ ]*)[ \t]*") 
	local createtablelikeline=line:upper():match("^[ \t]*CREATE TABLE[ \t]*[^ ]*[ \t]*LIKE[ \t]*([^ ;]*)[ \t]*") 
	local createtablefromline=line:upper():match("^[ \t]*CREATE TABLE[ \t]*.*[ \t]*FROM[ \t]*([^ ;]*)[ \t]*") 
	if dataline and dataline:gsub("[ \t]*$","")~=tostring(setline):gsub("[ \t]*$","") then
		for field in dataline:gmatch("[^ \t]+") do
			if field=="_NULL_" then
				_NULL_Number=_NULL_Number+1
				outputfile3:write(field .. _NULL_Number .. "\n")
			elseif field~="MERGE" and field~="SET" then
				outputfile3:write(field .. "\n")
			end --if field~="MERGE" and field~="SET" then
			if setline then
				for fieldset in setline:gmatch("[^ \t]+") do 
					if fieldset:match("[^ \t]+=[^ \t]+")==nil then
						outputfile3:write("\t" .. fieldset .. "\n")
					end --if fieldset:match("[^ \t]+=[^ \t]+")==nil then
				end --for fieldset in setline:gmatch("[^ \t]+") do 
			end --if setline then
			if mergeline then
				for fieldmerge in mergeline:gmatch("[^ \t]+") do 
					outputfile3:write("\t" .. fieldmerge .. "\n")
				end --for fieldmerge in mergeline:gmatch("[^ \t]+") do 
			end --if mergeline then
		end --for field in dataline:gmatch("[^ \t]+") do 
		outputfile3:write("--dataline: " .. dataline .. " < " .. tostring(setline):gsub("[ \t]*$","") .. " / " .. tostring(mergeline):gsub("[ \t]*$","") .. "\n")
	end --if dataline then
	if dupoutline and dupoutline:gsub("[ \t]","") ~= dataequalline:gsub("[ \t]","") then
		dupoutline=dupoutline:upper():gsub("DBMS=EXCEL",""):gsub("[ \t]*SORTSIZE[ \t]*=[ \t]*[^ \t;]*",""):gsub("REPLACE",""):gsub("\\","\\\\")
		for field in dupoutline:gmatch("[^ \t]+") do 
			outputfile3:write(field .. "\n")
			if dataequalline then
				for fielddataequal in dataequalline:gmatch("[^ \t]+") do 
					if fielddataequal:match("[^ \t]+=[^ \t]+")==nil then
						outputfile3:write("\t" .. fielddataequal .. "\n")
					end --if fielddataequal:match("[^ \t]+=[^ \t]+")==nil then
				end --for fielddataequal in dataequalline:gmatch("[^ \t]+") do 
			end --if dataequalline then
		end --for field in dupoutline:gmatch("[^ \t]+") do 
		outputfile3:write("--dupoutline: " .. dupoutline:gsub("[ \t]*$","") .. " < " .. dataequalline:gsub("[ \t]*$","") .. "\n")
	end --if dupoutline then
	if outline and outline:gsub("[ \t]","") ~= dataequalline:gsub("[ \t]","") then
		outline=outline:upper():gsub("DBMS=EXCEL",""):gsub("[ \t]*SORTSIZE[ \t]*=[ \t]*[^ \t;]*",""):gsub("[ \t]*SUM[ \t]*=[ \t]*[^ \t;]*",""):gsub("REPLACE",""):gsub("\\","\\\\")
		for field in outline:gmatch("[^ \t]+") do 
			outputfile3:write(field .. "\n")
			if dataequalline then
				for fielddataequal in dataequalline:gmatch("[^ \t]+") do 
					if fielddataequal:match("[^ \t]+=[^ \t]+")==nil then
						outputfile3:write("\t" .. fielddataequal .. "\n")
					end --if fielddataequal:match("[^ \t]+=[^ \t]+")==nil then
				end --for fielddataequal in dataequalline:gmatch("[^ \t]+") do 
			end --if dataequalline then
		end --for field in outline:gmatch("[^ \t]+") do 
		outputfile3:write("--outline: " .. outline:gsub("[ \t]*$","") .. " < " .. dataequalline:gsub("[ \t]*$","") .. "\n")
	end --if outline then
	if createtableline then
		outputfile3:write(createtableline .. "\n")
		if createtablelikeline then outputfile3:write("\t" .. createtablelikeline .. "\n") end
		if createtablefromline then outputfile3:write("\t" .. createtablefromline .. "\n") end
		outputfile3:write("--createtableline: " .. createtableline .. "<" .. tostring(createtablelikeline) .. " / " .. tostring(createtablefromline) .. "\n")
	end --if createtableline then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output.txt") do
outputfile3:close()


--4. read tabulator tree and take branches together and sorted
outputfile4=io.open("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted.txt","w")
sortTable={}
lineTable={}
lineSortTable={}
currentLineInput=""
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree.txt") do
	if line:match("^\t")==nil and line:match("^%-%-")==nil then
		--test with: print(line)
		currentLineInput=line
		if lineTable[currentLineInput]==nil then
			lineTable[currentLineInput]={}
			lineSortTable[currentLineInput]={}
			sortTable[#sortTable+1]=currentLineInput
		end --if lineTable[currentLineInput]==nil then
	elseif line:gsub("\t","")~=currentLineInput then
		--test with: print(line)
		lineTable[currentLineInput][line]=true
	end --if line:match("^\t")==nil and line:match("^%-%-")==nil then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree.txt") do
--sort tree
for k,v in pairs(lineTable) do
	for k1,v1 in pairs(v) do
		lineSortTable[k][#lineSortTable[k]+1]=k1
	end --for k1,v1 in pairs(lineTable[v]) do
end --for i,v in pairs(sortTable) do
for i,v in pairs(sortTable) do
	outputfile4:write(v .. "\n")
	table.sort(lineSortTable[v],function(a,b) return a<b end)
	for i1,v1 in pairs(lineSortTable[v]) do
		outputfile4:write(v1 .. "\n")
	end --for k1,v1 in pairs(lineSortTable[v]) do
end --for i,v in pairs(sortTable) do
outputfile4:close()


--5. read tabulator tree and collect only input data and only output data
outputTable={}
inputTable={}
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted.txt") do
	if line:match("^\t")==nil then
		outputTable[line]="output"
	else
		inputTable[line:match("^\t([^\t]+)")]="input"
	end --if line:match("^\t")==nil then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted.txt") do 
for k,v in pairs(inputTable) do
	if outputTable[k] then inputTable[k]="input und output" end
end --for k,v in pairs() do
--test with: for k,v in pairs(inputTable) do print(k,v) end
for k,v in pairs(outputTable) do
	if inputTable[k] then outputTable[k]="output und input" end
end --for k,v in pairs() do
--test with: for k,v in pairs(outputTable) do print(k,v) end


--6. write the corresponding Lua tree from tabulator tree
outputfile5=io.open("C:\\Temp\\SAS_programm_logic_input_output_tree.lua","w")
inputNumber=0
inputAndoutputNumber=0
inputOnlySortedTable={}
inputAndoutputSortedTable={}
for k,v in pairs(inputTable) do
	if v=="input" then
		inputOnlySortedTable[#inputOnlySortedTable+1]= k
	else
		inputAndoutputSortedTable[#inputAndoutputSortedTable+1]= k
	end --if v=="input" then
end --for k,v in pairs(inputTable) do
table.sort(inputOnlySortedTable,function(a,b) return a<b end)
for i,v in pairs(inputOnlySortedTable) do
	inputNumber=inputNumber+1
	outputfile5:write(v .. '={branchname="' .. v:gsub("XXX","&"):gsub("YYYZ",".."):gsub("YYY",".") .. '","Input ' .. string.rep(" ",3-#tostring(inputNumber)) .. inputNumber .. '"}\n')
end --for i,v in pairs(inputOnlySortedTable) do
table.sort(inputAndoutputSortedTable,function(a,b) return a<b end)
for i,v in pairs(inputAndoutputSortedTable) do
	--test with: print(i,v)
	inputAndoutputNumber=inputAndoutputNumber+1
	outputfile5:write(v .. '={branchname="' .. v:gsub("XXX","&"):gsub("YYYZ",".."):gsub("YYY",".") .. '","Input und Output ' .. string.rep(" ",3-#tostring(inputAndoutputNumber)) .. inputAndoutputNumber .. '"}\n')
end --for i,v in pairs(inputOnlySortedTable) do
outputNumber=0
outputOnlySortedTable={}
for k,v in pairs(outputTable) do
	if v=="output" then
		outputOnlySortedTable[#outputOnlySortedTable+1]= k
	end --if v=="output" then
end --for k,v in pairs(outputTable) do
table.sort(outputOnlySortedTable,function(a,b) return a<b end)
for i,v in pairs(outputOnlySortedTable) do
	outputNumber=outputNumber+1
	outputfile5:write(v .. '={branchname="' .. v:gsub("XXX","&"):gsub("YYYZ",".."):gsub("YYY",".") .. '","Output ' .. string.rep(" ",3-#tostring(outputNumber)) .. outputNumber .. '"}\n')
end --for i,v in pairs(outputOnlySortedTable) do


outputfile5:write('Datei={branchname="' .. filename:gsub("\\","\\\\") .. '",\n')

for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted.txt") do
	if line:match("^\t")==nil and line:match("^%-%-")==nil then
		outputfile5:write('}\n' .. line .. '={branchname="' .. line:gsub("XXX","&"):gsub("YYYZ",".."):gsub("YYY",".") .. '",\n') 
	else
		outputfile5:write(line .. ',\n') 
	end --if line:match("^Seiteneffektketten") then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted.txt") do
outputfile5:write('}\n') 
outputfile5:write('Tree={branchname="Datenfluss: ' .. filename:gsub("\\","\\\\") .. '",\n')
outputSortedTable={}
for k,v in pairs(outputTable) do
	if v=="output" and k:match("^%-%-")==nil then
		outputSortedTable[#outputSortedTable+1]=k
	end --if v=="output" and k:match("^%-%-")==nil then
end --for k,v in pairs(outputTable) do
table.sort(outputSortedTable,function(a,b) return a<b end)
for i,v in pairs(outputSortedTable) do
	outputfile5:write(v .. ',\n')
end --for i,v in pairs(outputSortedTable) do
--find not defined branches
definedTable={}
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted.txt") do 
	if line:match("^\t")==nil and line:match("^%-%-")==nil then
		 definedTable[line]=true
	elseif line:match("^%-%-")==nil then
		if definedTable[line:gsub("\t","")]==nil and inputTable[line:gsub("\t","")]~="input" then
			outputfile5:write(line:gsub("\t","") .. ', --used but defined after\n')
		end --if definedTable[line:gsub("\t","")]==nil and inputTable[line:gsub("\t","")]~="input" then
	end --if line:match("^\t")==nil and line:match("^%-%-")==nil then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted.txt") do 
outputfile5:write('}\n') 
outputfile5:close()

--7. check whether there are variables defined twice or more times
variableTable={}
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree.lua") do
	if line:match("^([^ =]+)=") and line:match("Input")==nil and line:match("Output")==nil and variableTable[line:match("^([^ =]+)=")]==nil then
		variableTable[line:match("^([^ =]+)=")]=1
	elseif line:match("^([^ =]+)=") and line:match("Input")==nil and line:match("Output")==nil then
		variableTable[line:match("^([^ =]+)=")]=variableTable[line:match("^([^ =]+)=")]+1
	end --if if line:match("[^ =]+=") and variableTable[line:match("([^ =]+)=")]==nil then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree.lua") do
for k,v in pairs(variableTable) do
	if v>1 then print(k,v) end
end --for k,v in pairs(variableTable) do

--os.execute('start "d" "C:\\Program Files (x86)\\Notepad++\\notepad++.exe" "C:\\Temp\\SAS_programm_logic_input_output_tree.lua"')



--8. make relation file
outputfile6=io.open("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_relation.txt","w")
lineGoal=""
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted.txt") do
	if line:match("\t")==nil and line:match("^%-%-")==nil then
		lineGoal=line
	elseif line:match("^%-%-")==nil then
		outputfile6:write(lineGoal .. '\n' .. line .. '\n')
	end --if line:match("\t")==nil and line:match("^%-%-")==nil then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted.txt") do
outputfile6:close()

--9. take file in reversed order
maximumLineNumber=0
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_relation.txt") do
	maximumLineNumber=maximumLineNumber+1
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_relation.txt") do
reversedTable={}
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_relation.txt") do
	reversedTable[maximumLineNumber]=line
	maximumLineNumber=maximumLineNumber-1
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_relation.txt") do
outputfile7=io.open("C:\\Temp\\SAS_programm_logic_input_output_tree_mirror.txt","w")
for i,v in pairs(reversedTable) do
	if v:match("^\t") then
		outputfile7:write(v:gsub("\t","") .. '\n')
	else
		outputfile7:write("\t" .. v .. '\n')
	end --if v:match("^\t") then
end --for i,v in pairs(reversedTable) do
outputfile7:close()


--10. read tabulator tree and take branches together and sorted
outputfile7a=io.open("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_mirror.txt","w")
sortTable={}
lineTable={}
lineSortTable={}
currentLineInput=""
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_mirror.txt") do
	if line:match("^\t")==nil and line:match("^%-%-")==nil then
		--test with: print(line)
		currentLineInput=line
		if lineTable[currentLineInput]==nil then
			lineTable[currentLineInput]={}
			lineSortTable[currentLineInput]={}
			sortTable[#sortTable+1]=currentLineInput
		end --if lineTable[currentLineInput]==nil then
	elseif line:gsub("\t","")~=currentLineInput then
		--test with: print(line)
		lineTable[currentLineInput][line]=true
	end --if line:match("^\t")==nil and line:match("^%-%-")==nil then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_mirror.txt") do
--sort tree
for k,v in pairs(lineTable) do
	for k1,v1 in pairs(v) do
		lineSortTable[k][#lineSortTable[k]+1]=k1
	end --for k1,v1 in pairs(lineTable[v]) do
end --for i,v in pairs(sortTable) do
for i,v in pairs(sortTable) do
	outputfile7a:write(v .. "\n")
	table.sort(lineSortTable[v],function(a,b) return a<b end)
	for i1,v1 in pairs(lineSortTable[v]) do
		outputfile7a:write(v1 .. "\n")
	end --for k1,v1 in pairs(lineSortTable[v]) do
end --for i,v in pairs(sortTable) do
outputfile7a:close()



--11. read tabulator tree and collect only input data and only output data
inputmirrorTable={}
outputmirrorTable={}
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_mirror.txt") do
	if line:match("^\t")==nil then
		inputmirrorTable[line]="inputmirror"
	else
		outputmirrorTable[line:match("^\t([^\t]+)")]="outputmirror"
	end --if line:match("^\t")==nil then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_mirror.txt") do 
for k,v in pairs(outputmirrorTable) do
	if inputmirrorTable[k] then outputmirrorTable[k]="outputmirror und inputmirror" end
end --for k,v in pairs() do
--test with: for k,v in pairs(outputmirrorTable) do print(k,v) end
for k,v in pairs(inputmirrorTable) do
	if outputmirrorTable[k] then inputmirrorTable[k]="inputmirror und outputmirror" end
end --for k,v in pairs() do
--test with: for k,v in pairs(inputmirrorTable) do print(k,v) end

--12. write the corresponding Lua tree from tabulator tree
outputfile8=io.open("C:\\Temp\\SAS_programm_logic_input_output_mirror_tree.lua","w")
outputmirrorNumber=0
outputAndinputmirrorNumber=0
outputmirrorOnlySortedTable={}
outputAndinputmirrorSortedTable={}
for k,v in pairs(outputmirrorTable) do
	if v=="outputmirror" then
		outputmirrorOnlySortedTable[#outputmirrorOnlySortedTable+1]= k
	else
		outputAndinputmirrorSortedTable[#outputAndinputmirrorSortedTable+1]= k
	end --if v=="outputmirror" then
end --for k,v in pairs(outputmirrorTable) do
table.sort(outputmirrorOnlySortedTable,function(a,b) return a<b end)
for i,v in pairs(outputmirrorOnlySortedTable) do
	outputmirrorNumber=outputmirrorNumber+1
	outputfile8:write(v .. '={branchname="' .. v:gsub("XXX","&"):gsub("YYYZ",".."):gsub("YYY",".") .. '","Output ' .. string.rep(" ",3-#tostring(outputmirrorNumber)) .. outputmirrorNumber .. '"}\n')
end --for i,v in pairs(outputmirrorOnlySortedTable) do
table.sort(outputAndinputmirrorSortedTable,function(a,b) return a<b end)
for i,v in pairs(outputAndinputmirrorSortedTable) do
	--test with: print(i,v)
	outputAndinputmirrorNumber=outputAndinputmirrorNumber+1
	outputfile8:write(v .. '={branchname="' .. v:gsub("XXX","&"):gsub("YYYZ",".."):gsub("YYY",".") .. '","Output und Input ' .. string.rep(" ",3-#tostring(outputAndinputmirrorNumber)) .. outputAndinputmirrorNumber .. '"}\n')
end --for i,v in pairs(inputOnlySortedTable) do
inputNumber=0
inputOnlySortedTable={}
for k,v in pairs(inputTable) do
	if v=="input" then
		inputOnlySortedTable[#inputOnlySortedTable+1]= k
	end --if v=="input" then
end --for k,v in pairs(inputTable) do
table.sort(inputOnlySortedTable,function(a,b) return a<b end)
for i,v in pairs(inputOnlySortedTable) do
	inputNumber=inputNumber+1
	outputfile8:write(v .. '={branchname="' .. v:gsub("XXX","&"):gsub("YYYZ",".."):gsub("YYY",".") .. '","Input ' .. string.rep(" ",3-#tostring(inputNumber)) .. inputNumber .. '"}\n')
end --for i,v in pairs(inputOnlySortedTable) do

outputfile8:write('Datei={branchname="' .. filename:gsub("\\","\\\\") .. '",\n')
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_mirror.txt") do 
	if line:match("^\t")==nil and line:match("^%-%-")==nil then
		 outputfile8:write('}\n' .. line .. '={branchname="' .. line:gsub("XXX","&"):gsub("YYYZ",".."):gsub("YYY",".") .. '",\n') 
	else
		 outputfile8:write(line .. ',\n') 
	end --if line:match("^Seiteneffektketten") then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_mirror.txt") do
outputfile8:write('}\n') 
outputfile8:write('tree_tabtext_script={branchname="Datenfluss: ' .. filename:gsub("\\","\\\\") .. '",\n')
inputmirrorSortedTable={}
for k,v in pairs(inputmirrorTable) do
	if v=="inputmirror" and k:match("^%-%-")==nil then
		inputmirrorSortedTable[#inputmirrorSortedTable+1]=k
	end --if v=="inputmirror" and k:match("^%-%-")==nil then
end --for k,v in pairs(inputmirrorTable) do
table.sort(inputmirrorSortedTable,function(a,b) return a<b end)
for i,v in pairs(inputmirrorSortedTable) do
	outputfile8:write(v .. ',\n')
end --for i,v in pairs(inputmirrorSortedTable) do
--find not defined branches
definedTable={}
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_mirror.txt") do 
	if line:match("^\t")==nil and line:match("^%-%-")==nil then
		 definedTable[line]=true
	elseif line:match("^%-%-")==nil then
		if definedTable[line:gsub("\t","")]==nil and outputmirrorTable[line:gsub("\t","")]~="outputmirror" then
			outputfile8:write(line:gsub("\t","") .. ', --used but defined after\n')
		end --if definedTable[line:gsub("\t","")]==nil and outputmirrorTable[line:gsub("\t","")]~="outputmirror" then
	end --if line:match("^\t")==nil and line:match("^%-%-")==nil then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree_sorted_mirror.txt") do 
outputfile8:write('}\n') 
outputfile8:close()

--13. check whether there are variables defined twice or more times
variableTable={}
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_mirror_tree.lua") do
	if line:match("^([^ =]+)=") and line:match("Input")==nil and line:match("Output")==nil and variableTable[line:match("^([^ =]+)=")]==nil then
		variableTable[line:match("^([^ =]+)=")]=1
	elseif line:match("^([^ =]+)=") and line:match("Input")==nil and line:match("Output")==nil then
		variableTable[line:match("^([^ =]+)=")]=variableTable[line:match("^([^ =]+)=")]+1
	end --if if line:match("[^ =]+=") and variableTable[line:match("([^ =]+)=")]==nil then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree.lua") do
for k,v in pairs(variableTable) do
	if v>1 then print(k,v) end
end --for k,v in pairs(variableTable) do

os.execute('start "d" "C:\\Program Files (x86)\\Notepad++\\notepad++.exe" "C:\\Temp\\SAS_programm_logic_input_output_mirror_tree.lua"')


