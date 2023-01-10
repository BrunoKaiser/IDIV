--This programm collect data from SAS programms and their sub programms in a recursive manner. There can be more than one include file in one include statement. It shows dependencies of variables and macro variables to build a tree of dependent variables with side effects.

--1.1 set searched text and files to be analysed
searchText=" Searchtext " 
fileTable={}
fileTable[#fileTable+1]="C:\\Temp\\SAS_Analyser.sas"

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
								:gsub("(Var [^;]*);([^;]*Output Out)","%1 %2")
								:gsub(" *%* *"," * ")
								:gsub(";[^;]*else"," else")
								:gsub(";[^;]*Else"," else")
								:gsub(";[^;]*ELSE"," else")
								:gmatch("[^;]*;") do
		semikolon=semikolon:gsub("\n"," "):gsub("^ +",""):gsub("^\t+",""):gsub(","," , "):gsub(";"," ;"):gsub(" +"," ")
		if semikolon:lower():match("^%%include") then
			for field in semikolon:gsub(";"," ;"):gsub(" +"," "):gmatch('"[^"]*"') do
				print(numberProgramm .. ". include: " .. field)
				if field:match(":\\") then
					DateiText=field:match('"([^"]*)"')
				else
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
printOut("Suche von: '" .. searchText .. "'")

--4.1 apply recursive function
for i,v in pairs(fileTable) do
	DateiText=v --"C:\\Temp\\SAS_Analyser.sas"
	RecursiveTreatSAS(DateiText,0)
end --for i,v in pairs(fileTable) do

--4.2 close the file
outputFile:close()

--5. open the result file
os.execute('start "d" "C:\\Temp\\SAS_searcher_raw.txt"')

--]====]

doLevel=0

outputFile=io.open("C:\\Temp\\SAS_searcher_raw2.txt","w")


letTable={}

outputFile:write("manuell bestimmte Macro-Variablen\n")
for k,v in pairs(letTable) do
	outputFile:write("M:L:T: " .. k .. ": " .. v .. "\n")
end --for k,v in pairs(letTable) do


for line in io.lines("C:\\Temp\\SAS_searcher_raw.txt") do
	line=line:gsub("%%let keep[^;]*;","")
		:gsub("%%Let keep[^;]*;","")
		:gsub("%%Let Keep[^;]*;","")
		:gsub("%%LET KEEP[^;]*;","")
		:gsub("format[^;]*;","")
		:gsub("Format[^;]*;","")
		:gsub("FORMAT[^;]*;","")
		:gsub("%( keep[^%)]*%)","")
		:gsub("%( Keep[^%)]*%)","")
		:gsub("%( KEEP[^%)]*%)","")

	if line:lower():gsub("let ","~"):gsub("sysfunc","~"):match("%%[^ ~]+ *%(.*=.*%)") then --exclude let, sysfunc, while with :gsub("let ","~"):gsub("sysfunc","~")
		--test with: outputFile:write("M:L:A: " .. line:lower():gsub("let ","~"):match("%%[^ ~]+ *%(.*%)") .. "\n")
		for field in line:gmatch("[^ ]+ *= +[^=,%)]*") do
			if field:match("[^ ]+ *= +([^=,%)]*)"):gsub(" +","")~="" then
				--test with: outputFile:write('M:L:M: letTable["' .. field:match("([^ ]+) *= +[^=,%)]*") .. '"]="' .. field:match("[^ ]+ *= +([^=,%)]*)") .. '"\n')
				if letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")]==nil then
					letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")]=field:match("[^ ]+ *= +([^=,%)]*)")
				elseif letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")]==field:match("[^ ]+ *= +([^=,%)]*)") then
					--the content exists already
				elseif letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")]:match(field:match("[^ ]+ *= +([^=,%)]*)")) then
					--the content exists already
				else
					letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")]=letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")] .. "/" .. field:match("[^ ]+ *= +([^=,%)]*)")
				end --if letTable[field:match("([^ ]+) *= +[^=,%)]*")]==nil then

				outputFile:write("M:L:A: " .. field:lower():match("([^ ]+) *= +[^=,%)]*") .. ": " .. letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")] .. "\n")
			else
				outputFile:write("M:L:A: " .. field:lower():match("([^ ]+) *= +[^=,%)]*") .. ": " .. field:match("[^ ]+ *= +([^=,%)]*)") .. "\n")
			end --if field:match("[^ ]+ *= +([^=,%)]*)"):gsub(" +","")~="" then
		end --for field in line:gmatch("[^ ]+ *= +[^=,%)]*") do
	elseif line:lower():match("%%macro [^ ]+ *%(.*%)") then 
		for field in line:gmatch("[^ ]+ *= +[^=,%)]*") do
			--field=field:lower()
			if field:match("[^ ]+ *= +([^=,%)]*)"):gsub(" +","")~="" then
				--test with: outputFile:write('M:L:M: letTable["' .. field:match("([^ ]+) *= +[^=,%)]*") .. '"]="' .. field:match("[^ ]+ *= +([^=,%)]*)") .. '"\n')
				if letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")]==nil then
					letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")]=field:match("[^ ]+ *= +([^=,%)]*)")
				elseif letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")]==field:match("[^ ]+ *= +([^=,%)]*)") then
					--the content exists already
				elseif letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")]:match(field:match("[^ ]+ *= +([^=,%)]*)")) then
					--the content exists already
				else
					letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")]=letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")] .. "/" .. field:match("[^ ]+ *= +([^=,%)]*)")
				end --if letTable[field:match("([^ ]+) *= +[^=,%)]*")]==nil then

				outputFile:write("M:L:M: " .. field:lower():match("([^ ]+) *= +[^=,%)]*") .. ": " .. letTable[field:lower():match("([^ ]+) *= +[^=,%)]*")] .. "\n")
			else
				outputFile:write("M:L:M: " .. field:lower():match("([^ ]+) *= +[^=,%)]*") .. ": " .. field:match("[^ ]+ *= +([^=,%)]*)") .. "\n")
			end --if field:match("[^ ]+ *= +([^=,%)]*)"):gsub(" +","")~="" then
		end --for field in line:gmatch("[^ ]+ *= +[^=,%)]*") do
	elseif line:lower():match("symputx%( '[^ ]+' , [^%)]+ %)") then
		if letTable[line:lower():match("symputx%( '([^ ]+)' , [^%)]+ %)")]==nil then
			letTable[line:lower():match("symputx%( '([^ ]+)' , [^%)]+ %)")]=line:lower():match("symputx%( '[^ ]+' , ([^%)]+)%)")
		else
			letTable[line:lower():match("symputx%( '([^ ]+)' , [^%)]+ %)")]=letTable[line:lower():match("symputx%( '([^ ]+)' , [^%)]+ %)")] .. "/" .. line:lower():match("symputx%( '[^ ]+' , ([^%)]+)%)")
		end --if letTable[line:lower():match("symputx%( '([^ ]+)' , [^%)]+ %)")]==nil then
		outputFile:write("M:L:S: " .. line:lower():match("symputx%( '([^ ]+)' , [^%)]+ %)") .. ": " .. letTable[line:lower():match("symputx%( '([^ ]+)' , [^%)]+ %)")] .. "\n")
	elseif line:lower():match("%%let [^ ]+ = [^;]+;") then
		if letTable[line:lower():match("%%let ([^ ]+) = [^;]+;")]==nil then
			letTable[line:lower():match("%%let ([^ ]+) = [^;]+;")]=line:lower():match("%%let [^ ]+ = ([^;]+);")
		elseif letTable[line:lower():match("%%let ([^ ]+) = [^;]+;")]==line:lower():match("%%let [^ ]+ = ([^;]+);") then
			--the content exists already
		elseif letTable[line:lower():match("%%let ([^ ]+) = [^;]+;")]:match(line:lower():match("%%let [^ ]+ = ([^;]+);")) then
			--the content exists already
		else
			letTable[line:lower():match("%%let ([^ ]+) = [^;]+;")]=letTable[line:lower():match("%%let ([^ ]+) = [^;]+;")] .. "/" .. line:lower():match("%%let [^ ]+ = ([^;]+);")
		end --if letTable[line:lower():match("%%let ([^ ]+) = [^;]+;")]==nil then
		outputFile:write("M:L:L: " .. line:lower():match("%%let ([^ ]+) = [^;]+;")	.. ": " .. letTable[line:lower():match("%%let ([^ ]+) = [^;]+;")] .. "\n")

--]======]


	end --if line:lower():match("%%let [^ ]+ = [^;]+;") then
--[==[to avoid problems please change = to eq when there is a comparison in if-condition
	line=line:gsub("if ([^=]-) = ([^=]-) and ([^=]-) = ([^=]-) %%then","if %1 eq %2 and %3 eq %4 %%then")
						:gsub("if ([^=]-) = ([^=]-) or ([^=]-) = ([^=]-) %%then","if %1 eq %2 or %3 eq %4 %%then")
						:gsub("If ([^=]-) = ([^=]-) OR ([^=]-) = ([^=]-) %%Then","if %1 eq %2 or %3 eq %4 %%then")
						:gsub("if ([^=]-) = ([^=]-) and ([^=]-) = ([^=]-) then","if %1 eq %2 and %3 eq %4 then")
						:gsub("if ([^=]-) = ([^=]-) or ([^=]-) = ([^=]-) then","if %1 eq %2 or %3 eq %4 then")
						:gsub("if ([^=]-) = ([^=]-) %%then","if %1 eq %2 %%then")
						:gsub("If ([^=]-) = ([^=]-) %%Then","if %1 eq %2 %%then")
						:gsub("if ([^=]-) = ([^=]-) then","if %1 eq %2 then")
						:gsub("If ([^=]-) = ([^=]-) Then","if %1 eq %2 then")
--]==]
	if line:lower():match("\\.*.sas") then
		doLevel=0
		outputFile:write(doLevel .. ":" .. line	.. "\n")
	elseif line:lower():match("%%mend") then
		doLevel=0
		outputFile:write(doLevel .. ":" .. line	.. "\n")
	elseif line:lower():match("endrsubmit") then
		doLevel=0
		outputFile:write(doLevel .. ":" .. line	.. "\n")
	elseif line:lower():match("if.* then .* else .*;") and line:lower():match(" do ")==nil then
		doLevel=doLevel
		outputFile:write(doLevel .. ":" .. line	.. "\n")
	elseif line:lower():match("%%end else %%if.*do") then
		doLevel=doLevel
		outputFile:write(doLevel .. ":" .. line	.. "\n")
	elseif line:lower():match("%%do i =") then
		doLevel=doLevel+1
		outputFile:write(doLevel .. ":" .. line	.. "\n")
	elseif line:lower():match("if .* do ") then
		doLevel=doLevel+1
		outputFile:write(doLevel .. ":" .. line	.. "\n")
	elseif line:lower():match("end *;") then
		outputFile:write(doLevel .. ": do-end ;\n")
		doLevel=math.max(doLevel-1,0)
		outputFile:write(doLevel .. ":" .. line	.. "\n")
	else
		outputFile:write(doLevel .. ":" .. line	.. "\n")
	end --if line:lower():match("\\.*.sas") then
	if line:lower():match("&[^ ]") then
		local lineMacro = line:lower()
		for k,v in pairs(letTable) do
			v=v:gsub("%%","%%%%")
			lineMacro=lineMacro:gsub("&" .. k .. "%.",v)
			lineMacro=lineMacro:gsub("&" .. k .. " ",v)
		end --for k,v in pairs(letTable) do
		--in macro variables can be macro variables, so gsub for them
		for k,v in pairs(letTable) do
			v=v:gsub("%%","%%%%")
			lineMacro=lineMacro:gsub("&" .. k .. "%.",v)
			lineMacro=lineMacro:gsub("&" .. k .. " ",v)
		end --for k,v in pairs(letTable) do
		outputFile:write("M:K:" .. lineMacro	.. "\n")
	end --if line:lower():match("&[^ ]") then
	
	if line:lower():match(" on .*" .. searchText:gsub(" ",""):lower() .. "[^=]*=.*;") 
		or line:lower():match(" on .*=[^=]*" .. searchText:gsub(" ",""):lower() .. ".*;") then
		outputFile:write("" .. searchText .. ":\tjoin-Variable " .. "\n")
		outputFile:write("\t" .. "join-Variable \n")
	elseif line:lower():match("by.*" .. searchText:lower() .. ".*;") then
		outputFile:write("" .. searchText .. ":\tby-Variable " .. "\n")
		outputFile:write("\t" .. "by-Variable \n")
	elseif line:lower():match("select.*" .. searchText:lower() .. ".*into *:") then
		outputFile:write("" .. searchText .. ":\tinto: " .. line:lower():match("select.*into *: *([^ ]*)") .. "\n")
		outputFile:write("\t" .. line:lower():match("select.*into *: *([^ ]*)") .. "\n")
	elseif line:lower():match("rename")==nil then
		for field_raw in line:gsub("else","~"):gmatch(" ([^ ]* =[^=~]+)") do
			local field=field_raw:match("([^ ]*) =")
			local fieldAddition=field_raw:match("=[^=~]+")
			if fieldAddition:lower():match(searchText:lower()) and field:lower()~=searchText:gsub(" ",""):lower() 
			and field:lower()~="keep" and field:lower()~="drop" and field:lower()~="rename" 
			and field:lower()~="where" and field:lower()~="in" and field:lower()~="sum" then
				if line:lower():match(searchText:lower()) then
				outputFile:write("" .. searchText .. ":\t" .. field .. "\n")
				outputFile:write("\t" .. field .. "\n")
				outputFile:write("\tFormel: " .. fieldAddition .. "\n")
				end --if line:lower():match(searchText:lower()) then
			elseif fieldAddition:lower():match(searchText:lower()) then
				--do nothing
			elseif (line:lower():gsub("then","~"):match("if " .. searchText:gsub(" ",""):lower() .. "[^~]* ~") or
				line:lower():gsub("then","~"):match("if [^~]*" .. searchText:lower() .. "[^~]* ~")) 
				 and field:lower()~=searchText:gsub(" ",""):lower() then
				outputFile:write("" .. searchText .. ":\t" .. field .. "\n")
				outputFile:write("\t" .. field .. "\n")
				outputFile:write("\tFormel2: " .. fieldAddition .. "\n")
			elseif line:lower():match("when.*%(.*" .. searchText:gsub(" ",""):lower() .. ".*%) .*;") 
				 and field:lower()~=searchText:gsub(" ",""):lower() then
				outputFile:write("" .. searchText .. ":\t" .. field .. "\n")
				outputFile:write("\t" .. field .. "\n")
				outputFile:write("\tFormel3: " .. fieldAddition .. "\n")
			end --if fieldAddition:match(searchText:lower()) and field:lower()~=searchText:gsub(" ",""):lower() and field:lower()~="keep" and field:lower()~="drop" and field:lower()~="rename" and field:lower()~="where" and field:lower()~="in" then
		end --for field_raw in line:gsub("else","~"):gmatch(" ([^ ]* =[^=~]+)") do
	elseif line:lower():match("rename") then
		for field in line:gmatch(" ([^ ]* =[ \t]*[^ ]*)") do
			if field:lower():match(" rename ")==nil then
				if line:lower():match(searchText:lower()) and (" " .. field .. " "):lower():match((searchText .. "="):lower()) then
					outputFile:write("" .. searchText .. ":->\t" .. field .. "\n")
					outputFile:write("\t" .. field:match("=[ \t]*([^ ]*)") .. " (rename) \n")
				end --if line:lower():match(searchText:lower()) and (" " .. field .. " "):lower():match((searchText .. "="):lower()) then
			end --if field:lower()~=searchText:gsub(" ",""):lower() and field:lower()~="keep" and field:lower()~="drop" and field:lower()~="rename" and field:lower()~="where" and field:lower()~="in" then
		end --for field in line:gmatch(" ([^ ]*) =") do
	end --if line:lower():match("rename") then

	if line:lower():match(" if .* then.* delete ;") then
				if line:lower():match(searchText:lower()) then
					outputFile:write("" .. searchText .. ": delete \t" .. line .. "\n")
					outputFile:write("\t" .. line:gsub("\t+"," "):gsub(" +"," "):lower():match(" if .* then.* delete ;") .. " (delete) \n")
				end --if line:lower():match(searchText:lower()) then
	elseif line:lower():match("then[^o]*output") then
				if line:lower():match(searchText:lower()) then
					outputFile:write("" .. searchText .. ": output \t" .. line:match("output (.*);") .. "\n")
					outputFile:write("\t" .. line:match("output (.*);") .. " (output) \n")
				end --if line:lower():match(searchText:lower()) and (" " .. field .. " "):lower():match((searchText .. "="):lower()) then
	elseif line:lower():match("output[^o]*out") then
				if line:lower():match(searchText:lower()) then
					outputFile:write("" .. searchText .. ": output out\t" .. line:lower():match("output[^o]*out(.*);") .. "\n")
					outputFile:write("\t" .. line:lower():match("output[^o]*out = *([^ ]*)") .. " (output out) \n")
				end --if line:lower():match(searchText:lower()) and (" " .. field .. " "):lower():match((searchText .. "="):lower()) then
	end --if line:lower():match("rename") then
end --for line in io.lines("C:\\Temp\\SAS_searcher_raw.txt") do
outputFile:close()

--6. open the result file
os.execute('start "d" "C:\\Temp\\SAS_searcher_raw2.txt"')

--6.1 test the Lua table letTable
--test with: for k,v in pairs(letTable) do print(k,v) end

--7. write the results in a result tree with tabulators
writeOutput="no"
levelSearch="0"
ifFound="no"
outputFile3=io.open("C:\\Temp\\SAS_searcher_output.txt","w")

--7.1 write in text file only relevant lines with tabulators
for line in io.lines("C:\\Temp\\SAS_searcher_raw2.txt") do
	--initialize for line with 0:
	if line:match("^0:") then
		ifFound="no"
	end --if line:match("^0:") then
	if line:lower():match(searchText:lower()) then
		writeOutput="yes"
		if line:lower():match("[ \t]if.* do ") then
			ifFound="yes"
		elseif ifFound=="yes" and levelSearch and levelSearch>"0" and line:lower():match("[ \t]if.* do ")==nil then
			 --schon ein ifFound=="yes", aber mit levelSearch>"0" ein line:lower():match("[ \t]if.* do ")==nil bleibt yes
			ifFound="yes"
		else
			ifFound="no"
		end --if line:lower():match("if") then
		if line:match("^(%d+):") then
			levelSearch=line:match("^(%d+):")
		end --if line:match("^(%d+):") then
	elseif line:match("^0:") then
		writeOutput="no"
	elseif line:match("^(%d+):") then
		local doLevelCurrent=line:match("^(%d+):")
		if levelSearch and doLevelCurrent<levelSearch then
			writeOutput="no"
		elseif levelSearch=="0" then
			writeOutput="no"
		elseif ifFound=="no" then
			writeOutput="no"
		end --if doLevelCurrent<levelSearch or levelSearch=="0" or ifFound=="no" then
	end --if line:match(searchText) then
	if writeOutput=="yes" then
		--test with: 
outputFile3:write(ifFound .. "(" .. tostring(levelSearch) .. ")" .. line .. "\n")
		if levelSearch and levelSearch>"0" and ifFound=="yes" then
			outputFile3:write("\t" .. line .. "\n")
		else
			outputFile3:write(line .. "\n")
		end --if levelSearch>"0" then
	end --if writeOutput=="yes" then
	if line:match("^\t") and line:match("^\tFormel%d*:")==nil then
		outputFile3:write(line .. "\n")
		writeOutput="no"
	end --if line:match("^\t") then
end --for line in io.lines("C:\\Temp\\SAS_searcher_raw2.txt") do
outputFile3:close()

--7.2 open the tabulator tree file
os.execute('start "d" "C:\\Temp\\SAS_searcher_output.txt"')

--8. write the tabulator tree in a text file with only unique lines for nodes
uniqueTable={}
outputFile4=io.open("C:\\Temp\\SAS_searcher_output_tree.txt","w")
outputFile4:write("Seiteneffektketten von " .. searchText .. "\n")
outputFile4:write(searchText:gsub(" ","") .. "\n")
for line in io.lines("C:\\Temp\\SAS_searcher_output.txt") do
	if line:match("^\t") and line:match("^[\t]+Formel:")==nil and line:match("^\t\t[^ ]*")==nil 
	and line:lower():match(searchText:gsub(" ",""):lower() .. " :\t")==nil and uniqueTable[line:lower()]==nil then
		uniqueTable[line:lower()]=true
		if line:match(" if .*;")==nil and line:match("%d+:")==nil and line:match(" do%-end ")==nil then
			outputFile4:write(line .. " ...\n")
		else
			outputFile4:write(line .. "\n")
		end --if line:match(" if .*;")==nil and line:match(" do%-end ")==nil then
		if line:match(" [^= ]* =") and uniqueTable["\t" .. line:match(" ([^= ]*) ="):lower()]==nil then
			outputFile4:write("\t" .. line:match(" ([^= ]*) =") .. " ...\n")
			--outputFile4:write("\t\t..." .. "\n")
			uniqueTable["\t" .. line:match(" ([^= ]*) ="):lower()]=true
		end --if line:match("[^=]=") then
	end --if line:match("^\t") then 
end --for line in io.lines("C:\\Temp\\SAS_searcher_output.txt") do
outputFile4:close()

--8.1 start the tabulator tree text file
os.execute('start "d" "C:\\Temp\\SAS_searcher_output_tree.txt"')

--9. write the corresponding Lua tree from tabulator tree
outputFile5=io.open("C:\\Temp\\SAS_searcher_output_tree.lua","w")
for line in io.lines("C:\\Temp\\SAS_searcher_output_tree.txt") do 
	if line:match("^Seiteneffektketten") then
		outputFile5:write(line:gsub(" $","="):gsub(" ","_"):upper() .. "\n") 
	elseif line:match("^\t")==nil then
		outputFile5:write('{branchname="' .. line:upper() .. '",\n') 
	elseif line:match("^\t%d+: do%-end") then
		--do nothing
	elseif line:match("%-.*%.%.%.") or line:match("&") then
		outputFile5:write('"' .. line:gsub("by%-Variable +%.%.%.","by-Variable wird benötigt") .. '",\n') 
	elseif line:match("^\t%d+:\t")==nil and line:lower():match(" %(output out%)") then
		outputFile5:write('"' .. line:upper() .. '",\n') 
	elseif line:match("^\t%d+:\t")==nil and line:lower():match(" %(delete%)") then
		outputFile5:write('"' .. line:upper() .. ' ...",\n') 
	elseif line:match("^\t%d+:\t")==nil then
		outputFile5:write(line:upper():gsub("%.%.%.",""):gsub(" %(RENAME%)","") .. ',\n') 
	end --if line:match("^Seiteneffektketten") then
end --for line in io.lines("C:\\Temp\\SAS_searcher_output_tree.txt") do
outputFile5:write('}\n') 
outputFile5:close()

--9.1 start the Lua tree text file
os.execute('start "d" "C:\\Program Files (x86)\\Notepad++\\notepad++.exe" "C:\\Temp\\SAS_searcher_output_tree.lua"')
