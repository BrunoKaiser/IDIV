--This programm collects data from a SAS programm to show the data flows, i.e. input and output tables

--1. filename
filename="C:\\Temp\\SAS_script.sas"

--1.1 standardize the sas file to get lines with end semicolon
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
		outputfile1:write(lineLogic:gsub("; *$","~"):gsub(";",";\n"):gsub("~$",";") .. "\n")
		lineEnd="yes"
		lineLogic=line
		outputfile1:write(lineLogic:gsub("; *$","~"):gsub(";",";\n"):gsub("~$",";") .. "\n")
		lineLogic=""
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
	if dataline and dataline:gsub("[ \t]*","")~=tostring(setline):gsub("[ \t]*","") then
		outputfile3:write("--dataline\n")
		for field in dataline:gmatch("[^ \t]+") do
			if field~="MERGE" and field~="SET" then
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
	end --if dataline then
	if dupoutline then
		outputfile3:write("--dupoutline\n")
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
	end --if dupoutline then
	if outline then
		outputfile3:write("--outline\n")
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
	end --if outline then
	if createtableline then
		outputfile3:write("--createtableline\n")
		outputfile3:write(createtableline .. "\n")
		if createtablelikeline then outputfile3:write("\t" .. createtablelikeline .. "\n") end
		if createtablefromline then outputfile3:write("\t" .. createtablefromline .. "\n") end
	end --if createtableline then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output.txt") do
outputfile3:close()


--9.1 read tabulator tree and collect only input data and only output data
outputTable={}
inputTable={}
for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree.txt") do
	if line:match("^\t")==nil then
		outputTable[line]="output"
	else
		inputTable[line:match("^\t([^\t]+)")]="input"
	end --if line:match("^\t")==nil then
end --for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree.txt") do 
for k,v in pairs(inputTable) do
	if outputTable[k] then inputTable[k]="input und output" end
end --for k,v in pairs() do
--test with: for k,v in pairs(inputTable) do print(k,v) end
for k,v in pairs(outputTable) do
	if inputTable[k] then outputTable[k]="output und input" end
end --for k,v in pairs() do
--test with: for k,v in pairs(outputTable) do print(k,v) end

--9.2 write the corresponding Lua tree from tabulator tree
outputfile4=io.open("C:\\Temp\\SAS_programm_logic_input_output_tree.lua","w")
inputNumber=0
for k,v in pairs(inputTable) do
	if v=="input" then
		inputNumber=inputNumber+1
		outputfile4:write(k .. '={branchname="' .. k:gsub("XXX","&"):gsub("YYYZ",".."):gsub("YYY",".") .. '","' .. v .. ' ' .. inputNumber .. '"}\n')
	end --if v=="input" then
end --for k,v in pairs(inputTable) do
outputfile4:write('Datei={branchname="' .. filename:gsub("\\","\\\\") .. '",\n')

for line in io.lines("C:\\Temp\\SAS_programm_logic_input_output_tree.txt") do 
	if line:match("^\t")==nil and line:match("^%-%-")==nil then
		outputfile4:write('}\n' .. line .. '={branchname="' .. line:gsub("XXX","&"):gsub("YYYZ",".."):gsub("YYY",".") .. '",\n') 
	else
		outputfile4:write(line .. ',\n') 
	end --if line:match("^Seiteneffektketten") then
end --for line in io.lines("C:\\Temp\\SAS_searcher_output_tree.txt") do
outputfile4:write('}\n') 
outputfile4:write('Tree={branchname="Datenfluss: ' .. filename:gsub("\\","\\\\") .. '",\n')
for k,v in pairs(outputTable) do
	if v=="output" and k:match("^%-%-")==nil then
		outputfile4:write(k .. ',\n')
	end --if v=="input" then
end --for k,v in pairs(outputTable) do
outputfile4:write('}\n') 
outputfile4:close()

