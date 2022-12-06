--This programm collect data from SAS programms and their sub programms in a recursive manner to show in a tab tree results of a search of standardized lines

--1.1 set searched text and files to be analysed
searchText="data"
fileTable={}
fileTable[#fileTable+1]="C:\\Temp\\SAS_Analyser.sas"
fileTable[#fileTable+1]="C:\\Temp\\SAS_Analyser_2.sas"
fileTable[#fileTable+1]="C:\\Temp\\test\\SAS_Analyser_2.sas"

--1.2 function to print or write results
printOut=print
function printOut(a)
	outputFile:write(a .. "\n")
end --function printOut(a)

--2. uniqueTable to write node only once
uniqueTable={}

--3. recursive function to seek for informations in SAS programms and in sub programms

function RecursiveTreatSAS(SASFile,numberTabs)
	print(SASFile,numberTabs)
	inputfile=io.open(SASFile) --"C:\\Temp\\SAS_Analyser.sas"
	text=inputfile:read("*all")
	inputfile:close()
	--treat the file
	for semikolon in (text .. "\n")
								:gsub(" ?= ?"," = ")
								:gsub("%( ?","( ")
								:gsub(" ?%- ?"," - ")
								:gsub(" ?%+ ?"," + ")
								:gsub(" ?%)"," )")
								:gsub("/%*[^%*/]*%*/"," ")
								:gsub(" +;",";")
								:gmatch("[^;]*;") do
		semikolon=semikolon:gsub("\n"," "):gsub("^ +",""):gsub("^\t+",""):gsub(","," , "):gsub(";"," ;"):gsub(" +"," ")
		if semikolon:lower():match("^%%include") then
			if semikolon:match(":\\") then
				DateiText=semikolon:match('"([^"]*)"')
			else
				DateiText=SASFile:match("(.*)\\[^\\]*") .. "\\" .. semikolon:match('"([^"]*)"') --C:\\Temp
			end --if semikolon:match(":\\") then
			printOut(string.rep("\t",numberTabs+1) .. "Rekursion: " .. semikolon:gsub("INCLUDE","INCLUDE: "):gsub("include","INCLUDE: ") .. ": Datei: " .. DateiText)
			RecursiveTreatSAS(DateiText,numberTabs+1)
			printOut(string.rep("\t",numberTabs+2) .. "Rekursionsende: " .. semikolon:gsub("INCLUDE","INCLUDE: "):gsub("include","INCLUDE: ") .. ": Datei: " .. DateiText)
			uniqueTable={}
		elseif semikolon:lower():match(searchText:lower()) then
			if uniqueTable[SASFile]==nil then
				printOut(string.rep("\t",numberTabs) .. SASFile)
				os.execute('start "d" "' .. SASFile .. '"')
				uniqueTable[SASFile]=true
			end --if uniqueTable==nil then
			printOut(string.rep("\t",numberTabs+1) .. semikolon)
		end --if semikolon:lower():match("^proc") then
	end --for semikolon in text:gsub("/%*[^%*/]*%*/"," "):gmatch("[^;]*;") do
end --function RecursiveTreatSAS(SASFile)

--4. building a result file with categorisations of data
outputFile=io.open("C:\\Temp\\SAS_searcher.txt","w")

--4.1 apply recursive function
for i,v in pairs(fileTable) do
	DateiText=v --"C:\\Temp\\SAS_Analyser.sas"
	RecursiveTreatSAS(DateiText,0)
end --for i,v in pairs(fileTable) do

--4.2 close the file
outputFile:close()

--5. open the result file
os.execute('start "d" "C:\\Temp\\SAS_searcher.txt"')
