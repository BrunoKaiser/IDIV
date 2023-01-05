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

ifLevel=0

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
		ifLevel=0
	elseif line:lower():match("%%mend") then
		ifLevel=0
	elseif line:lower():match("endrsubmit") then
		ifLevel=0
	elseif line:lower():match("%%end else %%if.*do") then
		ifLevel=ifLevel
	elseif line:lower():match("%%do i =") then
		ifLevel=ifLevel+1
	elseif line:lower():match("if .*do") then
		ifLevel=ifLevel+1
	elseif line:lower():match("end *;") then
		ifLevel=math.max(ifLevel-1,0)
	end
	outputFile:write(ifLevel .. ":" .. line	.. "\n")
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


	for field_raw in line:gmatch(" ([^ ]* =[^=]+)") do
		local field=field_raw:match("([^ ]*) =")
		local fieldAddition=field_raw:lower():gsub("else","~"):match("(=[^=~]+)")
		if fieldAddition:match(searchText:lower()) and field:lower()~=searchText:gsub(" ",""):lower() and field:lower()~="keep" and field:lower()~="drop" and field:lower()~="rename" and field:lower()~="where" and field:lower()~="in" then
			if line:lower():match(searchText:lower()) then
			outputFile:write("" .. searchText .. ":\t" .. field .. "\n")
			outputFile:write("\t" .. field .. "\n")
			outputFile:write("\tFormel: " .. fieldAddition .. "\n")
			end --if line:lower():match(searchText:lower()) then
		end --if fieldAddition:match(searchText:lower()) and field:lower()~=searchText:gsub(" ",""):lower() and field:lower()~="keep" and field:lower()~="drop" and field:lower()~="rename" and field:lower()~="where" and field:lower()~="in" then
	end --for field_raw in line:gmatch(" ([^ ]* =[^=]+)") do
	if line:lower():match("rename") then
		for field in line:gmatch(" ([^ ]* = [^ ]*)") do
			if field:lower():match(" rename ")==nil then
				if line:lower():match(searchText:lower()) and (" " .. field .. " "):lower():match((searchText .. "="):lower()) then
					outputFile:write("" .. searchText .. ":->\t" .. field .. "\n")
					outputFile:write("\t" .. field:match("= ([^ ]*)") .. " (rename) \n")
				end --if line:lower():match(searchText:lower()) and (" " .. field .. " "):lower():match((searchText .. "="):lower()) then
			end --if field:lower()~=searchText:gsub(" ",""):lower() and field:lower()~="keep" and field:lower()~="drop" and field:lower()~="rename" and field:lower()~="where" and field:lower()~="in" then
		end --for field in line:gmatch(" ([^ ]*) =") do
	end --if line:lower():match("rename") then


end --for line in io.lines("C:\\Temp\\SAS_searcher_raw.txt") do

outputFile:close()

--6. open the result file
os.execute('start "d" "C:\\Temp\\SAS_searcher_raw2.txt"')

--6.1 test the Lua table letTable
--test with: for k,v in pairs(letTable) do print(k,v) end
