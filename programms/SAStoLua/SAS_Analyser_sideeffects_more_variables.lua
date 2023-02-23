--This programm collect data from SAS programms and their sub programms in a recursive manner. There can be more than one include file in one include statement. It shows side effects of variables and macro variables to build a tree of dependent variables with side effects.

--0. definition of searched variables
searchVariableTable={
"test_variable",
"variable1",
"variable2",

}

neededTable={}
neededTable["neededVariable1"]="needed"
neededTable["neededVariable2"]="needed"



--1. set searched text and files to be analysed

fileTable={}
fileTable[#fileTable+1]="C:\\Temp\\test.sas"

--1.1 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--1.2 function to print or write results
printOut=print
function printOut(a)
	outputFile:write(a .. "\n")
end --function printOut(a)


--2. uniqueTable to write node only once
uniqueTable={}
numberProgramm=0

--3. recursive function to seek for informations in SAS programms and in sub programms
function RecursiveTreatSAS(SASFile,numberTabs)
	numberProgramm=numberProgramm+1
	print(SASFile,numberTabs)
	inputfile=io.open(SASFile) --"C:\\Temp\\SAS_Analyser.sas"
	text=inputfile:read("*all")
	inputfile:close()
	--treat the file
	printOut(string.rep("\t",numberTabs) .. SASFile)
	for semikolon in (text .. "\n")
								:gsub(" ?= ?"," = ")
								:gsub("(/%*[^%*/]*%*/)"," ")
								:gsub("(/%*[^%*]*%*/)"," ")
								:gsub("%( ?","( ")
								:gsub("\t ?","\t ")
								:gsub(" ?%- ?"," - ")
								:gsub(" ?%+ ?"," + ")
								:gsub(" ?%)"," )")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(INCLUDE[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(Include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub("(include[^;]*)/%*[^%*/]*%*/([^;]*;)","%1 %2")
								:gsub(" +;",";")
								:gsub(" *%) *"," ) ")
								:gsub(" *%( *"," ( ")
								:gsub(" *> *"," > ")
								:gsub(" *< *"," < ")
								:gsub(" */ *"," / ")
								:gsub(" *: *"," : ")
								:gsub("(Var [^;]*);([^;]*Output Out)","%1 %2")
								:gsub(" *%* *"," * ")
								:gsub(";[^;]*set "," set ")
								:gsub(";[^;]*Set "," set ")
								:gsub(";[^;]*SET "," set ")
								:gsub(";[^;]*merge "," merge ")
								:gsub(";[^;]*Merge "," merge ")
								:gsub(";[^;]*MERGE "," merge ")
								:gsub(";[^;]*%%else "," %%else ")
								:gsub(";[^;]*%%Else "," %%else ")
								:gsub(";[^;]*%%ELSE "," %%else ")
								:gsub(";[^;]*[^%%]else "," else ")
								:gsub(";[^;]*[^%%]Else "," else ")
								:gsub(";[^;]*[^%%]ELSE "," else ")
								:gmatch("[^;]*;") do
		semikolon=semikolon:gsub("\n"," "):gsub("^ +",""):gsub("^\t+",""):gsub(","," , "):gsub(";"," ;"):gsub(" +"," ")
		if semikolon:lower():match("^%%include") then
			for field in semikolon:gsub(";"," ;"):gsub(" +"," "):gmatch('"[^"]*"') do
				print(numberProgramm .. ". include: " .. field)
				if field:match(":\\") then
					DateiText=field:match('"([^"]*)"')
				else --take the path from the SASFile and the sub path and filename of include
					DateiText=SASFile:match("(.*)\\[^\\]*") .. field:match('"([^"]*)"'):gsub("%&sascode%.","")
				end --if field:match(":\\") then
				--printOut(string.rep("\t",numberTabs+1) .. "Rekursion: " .. DateiText)
				--recursion
				RecursiveTreatSAS(DateiText,numberTabs+1)
				--printOut(string.rep("\t",numberTabs+2) .. "Rekursionsende: " .. DateiText)
				uniqueTable={}
			end --for field in semikolon:gsub(";"," ;"):gsub(" +"," "):gmatch('"[^"]*"') do
		else
			printOut(string.rep("\t",numberTabs+1) .. semikolon)
		end --if semikolon:lower():match("^proc") then
	end --for semikolon in text:gsub("/%*[^%*/]*%*/"," "):gmatch("[^;]*;") do
end --function RecursiveTreatSAS(SASFile)

--4. building a result file with categorisations of data
outputFile=io.open("C:\\Temp\\SAS_searcher_raw.txt","w")


--4.1 apply recursive function
for i,v in pairs(fileTable) do
	DateiText=v --"C:\\Temp\\SAS_Analyser.sas"
	RecursiveTreatSAS(DateiText,0)
end --for i,v in pairs(fileTable) do

--4.2 close the file
outputFile:close()

--5. open the result file
--test with: os.execute('start "d" "C:\\Temp\\SAS_searcher_raw.txt"')


--4. building a result file with categorisations of data
outputFile=io.open("C:\\Temp\\SAS_searcher_raw_sideeffects.txt","w")

sideEffectsTable={}
for line in io.lines("C:\\Temp\\SAS_searcher_raw.txt") do
	line=line:gsub("%%let keep[^;]* rename","rename")
		:gsub("%%let keep[^;]* Rename","rename")
		:gsub("%%Let keep[^;]* rename;","rename")
		:gsub("%%Let Keep[^;]* Rename;","rename")
		:gsub("%%LET KEEP[^;]* RENAME;","rename")
		:gsub("%%let keep[^;]*;","")
		:gsub("%%Let keep[^;]*;","")
		:gsub("%%Let Keep[^;]*;","")
		:gsub("%%LET KEEP[^;]*;","")
		:gsub("format[^;]*;","")
		:gsub("Format[^;]*;","")
		:gsub("FORMAT[^;]*;","")
		:gsub("attrib[^;]*;","")
		:gsub("Attrib[^;]*;","")
		:gsub("ATTRIB[^;]*;","")
		:gsub("%( keep[^%)]*where","where")
		:gsub("%( Keep[^%)]*where","where")
		:gsub("%( Keep[^%)]*Where","where")
		:gsub("%( KEEP[^%)]*WHERE","where")
		:gsub("%( keep[^%)]*rename","rename")
		:gsub("%( Keep[^%)]*rename","rename")
		:gsub("%( Keep[^%)]*Rename","rename")
		:gsub("%( KEEP[^%)]*RENAME","rename")
		:gsub("%( keep[^%)]*%)","")
		:gsub("%( Keep[^%)]*%)","")
		:gsub("%( KEEP[^%)]*%)","")
	for i,v in pairs(searchVariableTable) do
		if line:lower():match("rename = %([^%)]*[^=] " .. v:lower() .. " =[^%)]*%)") then
			sideEffectsTable[v .. ": Rename: ".. line]=true
		elseif line:lower():match("rename = %(" .. v:lower() .. " =[^%)]*%)") then
			sideEffectsTable[v .. ": Rename: ".. line]=true
		elseif line:lower():match("rename[^;]* = %([^%)]*[^=] " .. v:lower() .. " =[^%)]*%)") then
			sideEffectsTable[v .. ": Rename: ".. line]=true
		elseif line:lower():match("rename[^;]* = " .. v:lower() .. " =[^%)]*%)") then
			sideEffectsTable[v .. ": Rename: ".. line]=true
		elseif line:lower():match("rename = [^;]*[^=] " .. v:lower() .. " =[^;]*;") then
			sideEffectsTable[v .. ": Rename: ".. line]=true
		elseif line:lower():match("rename = " .. v:lower() .. " =[^;]*;") then
			sideEffectsTable[v .. ": Rename: ".. line]=true
		elseif line:lower():match("rename = ?%([^%)]*=[^;]* " .. v:lower() .. " [^=][^%)]*%)") then
			--no sideEffectsTable[v .. ": Rename: ".. line]=true
		elseif line:lower():match("rename = [^;]*= " .. v:lower() .. " [^=][^;]*;") then
			--no sideEffectsTable[v .. ": Rename: ".. line]=true
		elseif line:lower():match("and [^;]*;[^;]*=[^;]* " .. v:lower() .. " ") then
			--see if for = no 
			sideEffectsTable[v .. ": Definition: ".. line]=true
		elseif line:lower():match("or [^;]*;[^;]*=[^;]* " .. v:lower() .. " ") then
			--see for = no 
			sideEffectsTable[v .. ": Definition: ".. line]=true
		elseif line:lower():match("= " .. v:lower() .. " ") then
			sideEffectsTable[v .. ": Definition: ".. line]=true
		elseif line:lower():gsub("if ","~ "):match("^[^~]*=[^;]* " .. v:lower() .. " ") then --^[^~] zur Verschnellerung
			sideEffectsTable[v .. ": Definition: ".. line]=true
		elseif line:lower():gsub(" if ","~"):gsub(" or ","~"):gsub(" and ","~"):gsub(" then ","~"):gsub(" else ","~"):match("=[^;~]* " .. v:lower() .. " ") then
			sideEffectsTable[v .. ": Definition-unsicher: ".. line]=true
		end --line:lower():match("rename = ?%([^%)]*" .. v:lower() .. " =[^%)]*%)") then
		if line:lower():match("where [^;]* " .. v:lower() .. " ") or line:lower():match("where " .. v:lower() .. " ") then
			sideEffectsTable[v .. ": Where-Bedingung: " .. line]=true
		elseif line:lower():match("where " .. v:lower() .. " ") or line:lower():match("where " .. v:lower() .. " ") then
			sideEffectsTable[v .. ": Where-Bedingung: " .. line]=true
		end --if line:lower():match("where [^;]* " .. v:lower() .. " ") or line:lower():match("where " .. v:lower() .. " ") then
		if line:lower():match("by [^;]* " .. v:lower() .. " ") or line:lower():match("by " .. v:lower() .. " ") then
			sideEffectsTable[v .. ": By-Merge: " .. line]=true
		elseif line:lower():match("by " .. v:lower() .. " ") or line:lower():match("by " .. v:lower() .. " ") then
			sideEffectsTable[v .. ": By-Merge: " .. line]=true
		elseif line:lower():match(" on [^;]* " .. v:lower() .. " ") then
			sideEffectsTable[v .. ": On-Merge: " .. line]=true
		elseif line:lower():match(" on " .. v:lower() .. " ") then
			sideEffectsTable[v .. ": On-Merge: " .. line]=true
		elseif line:lower():match(" on [^;]*%." .. v:lower() .. " ") then
			sideEffectsTable[v .. ": On-Merge: " .. line]=true
		end --if line:lower():match("by [^;]* " .. v:lower() .. " ") or line:lower():match("by " .. v:lower() .. " ") then
		if line:lower():match("case when [^;]* " .. v:lower() .. " [^;]* then") then
			sideEffectsTable[v .. ": Case when-Bedingung: " .. line]=true
		elseif line:lower():match("case when " .. v:lower() .. " [^;]* then") then
			sideEffectsTable[v .. ": Case when-Bedingung: " .. line]=true
		elseif line:lower():match("when [^;]* " .. v:lower() .. " [^;]*;") then
			sideEffectsTable[v .. ": when-Bedingung: " .. line]=true
		elseif line:lower():match("when " .. v:lower() .. " [^;]*;") then
			sideEffectsTable[v .. ": when-Bedingung: " .. line]=true
		end --if line:lower():match("if [^;]* " .. v:lower() .. " [^;]* then") or line:lower():match("if " .. v:lower() .. " [^;]* then") then
		if line:lower():match("if [^;]* " .. v:lower() .. " [^;]* then") or line:lower():match("if " .. v:lower() .. " [^;]* then") then
			sideEffectsTable[v .. ": If-Bedingung: " .. line]=true
		elseif line:lower():match("if " .. v:lower() .. " [^;]* then") or line:lower():match("if " .. v:lower() .. " [^;]* then") then
			sideEffectsTable[v .. ": If-Bedingung: " .. line]=true
		elseif line:lower():match("if " .. v:lower() .. " [^;]* then") or line:lower():match("if " .. v:lower() .. " [^;]* then") then
			sideEffectsTable[v .. ": If-Bedingung: " .. line]=true
		elseif line:lower():match("then")==nil and (line:lower():match("if " .. v:lower() .. " [^;~]*;") or line:lower():match("if [^;]* " .. v:lower() .. " [^;~]*;")) then
			sideEffectsTable[v .. ": If-Einschränkung: " .. line]=true
		end --if line:lower():match("if [^;]* " .. v:lower() .. " [^;]* then") or line:lower():match("if " .. v:lower() .. " [^;]* then") then
	end --for i,v in pairs(searchVariableTable) do
end --for line in io.lines("C:\\Temp\\SAS_searcher_raw.txt") do

sideEffectsSortedTable={}
for k,v in pairs(sideEffectsTable) do
	sideEffectsSortedTable[#sideEffectsSortedTable+1]=k
end --for k,v in pairs(sideEffectsTable) do
table.sort(sideEffectsSortedTable,function(a,b) return a<b end)
for i,v in ipairs(sideEffectsSortedTable) do
	printOut(v)
end --for i,v in ipairs(sideEffectsSortedTable) do

--4.2 close the file
outputFile:close()


--test with: os.execute('start "d" "C:\\Temp\\SAS_searcher_raw_sideeffects.txt"')

outputFile2=io.open("C:\\Temp\\SAS_searcher_raw_sideeffects_tree.lua","w")
outputFile2:write('Tree={branchname="Seiteneffekt-Baumansicht",\n')
lineTable={}
for line in io.lines("C:\\Temp\\SAS_searcher_raw_sideeffects.txt") do
	if lineTable[line:match("^([^:]*):")]==nil then
		lineTable[line:match("^([^:]*):")]='{branchname="' .. string.escape_forbidden_char(line:match("^[^:]*:(.*)"):gsub("\t"," "):gsub("^ +","")):gsub(": +",'","') .. '",}'
	else
		lineTable[line:match("^([^:]*):")]=lineTable[line:match("^([^:]*):")] .. ', \n\t{branchname="' .. string.escape_forbidden_char(line:match("^[^:]*:(.*)"):gsub("\t"," "):gsub("^ +","")):gsub(": +",'","') .. '",}'
	end --if lineTable[line:match("^([^:]*):")] then
end --for line in io.lines("C:\\Temp\\SAS_searcher_raw_sideeffects.txt") do

for i,v in pairs(searchVariableTable) do
	if lineTable[v] then
		outputFile2:write('{branchname="' .. v .. '","Variable_entfernt, jetzt aus CrisDa",{branchname="Seiteneffekte",' .. lineTable[v] .. '\n},\n},\n')
	else
		outputFile2:write('{branchname="' .. v .. '","Variable_entfernt, jetzt aus CrisDa",\n},\n')
	end --if lineTable[v] then
end --for i,v in pairs(searchVariableTable) do

for k,v in pairs(neededTable) do
	outputFile2:write('{branchname="' .. k .. '","' .. v .. '",\n},\n')
end --for i,v in pairs(neededTable) do
outputFile2:write('}\n')
outputFile2:close()
