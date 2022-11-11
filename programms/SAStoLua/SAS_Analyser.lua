--This programm collect data from a SAS programm and sub programms of it in a recursive manner to show in a tree the variables used

--1.1 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--1.2 function to print or write results
printOut=print
function printOut(a)
	outputFile:write(a .. "\n")
end --function printOut(a)
printOut2=print
function printOut2(a)
	outputFile2:write(a .. "\n")
end --function printOut2(a)

--2. contenTable to collect data from SAS programms
contentTable={}
contentTable["Rekursion"]={}
contentTable["Rekursionsende"]={}
contentTable["Rekursion"]["%INCLUDE"]={}
contentTable["Rekursionsende"]["%INCLUDE"]={}
contentTable["Datei"]={}
contentTable["Variable"]={}
contentTable["Variable"]["nil"]={}
contentTable["Variable"]["THEN"]={}
contentTable["Variable"]["%THEN"]={}
contentTable["Variable"]["THEN WHERE"]={}
contentTable["Variable"]["%THEN WHERE"]={}
contentTable["Variable"]["ELSE"]={}
contentTable["Variable"]["%ELSE"]={}
contentTable["Variable"]["ELSEIF"]={}
contentTable["Variable"]["%ELSEIF"]={}
contentTable["Variablen"]={}
contentTable["Variablen"]["By"]={}
contentTable["Variablen"]["nil"]={}
contentTable["Variablen"]["INPUT"]={}
contentTable["Variablen"]["KEEP"]={}
contentTable["Variablen"]["SELECT"]={}
contentTable["Variablen"]["DROP"]={}
contentTable["Variablen"]["VAR"]={}
contentTable["Variablen"]["CLASS"]={}
contentTable["Variablen"]["MODEL"]={}
contentTable["Variablen"]["PAIRED"]={}
contentTable["Variablen"]["TABLES"]={}
contentTable["Variablen"]["WEIGHT"]={}
contentTable["Variablen"]["HISTOGRAM"]={}

--3. recursive function to seek for informations in SAS programms and in sub programms
function RecursiveTreatSAS(SASFile)
	print(SASFile)
	inputfile=io.open(SASFile) --"C:\\Temp\\SAS_Analyser.sas"
	text=inputfile:read("*a")
	inputfile:close()
	--treat the file
	for semikolon in (text .. "\n")
								:gsub("\t"," ")
								:gsub("([^ ])=","%1 =")
								:gsub("=([^ ])","= %1")
								:gsub("/%*[^%*/]*%*/"," ")
								:gsub("%*[^ ][^;]*;"," ")
								:gsub("\n%*[^;]*;"," ")
								:gsub("into ?:","into double dot")
								:gsub("histogram([^/]*)/","HISTOGRAM%1;/")
								:gsub("HISTOGRAM([^/]*)/","HISTOGRAM%1;/")
								:gsub("select ",";SELECT ")
								:gsub("SELECT ",";SELECT ")
								:gsub("from ",";from ")
								:gsub("FROM ",";FROM ")
								:gsub("DATA([^%(]*)%(keep=([^%)]*)%)","DATA%1;keep %2")
								:gsub("data([^%(]*)%(keep=([^%)]*)%)","DATA%1;keep %2")
								:gsub("CARDS;[^;]*;","")
								:gsub("cards;[^;]*;","")
								:gsub("DATALINES;[^;]*;","")
								:gsub("datalines;[^;]*;","")
								:gsub("/ NOUNI",";/ NOUNI")
								:gsub("/ fisher",";/ fisher")
								:gsub("/ fisher",";/ FISHER")
								:gsub("/ ?label",";/ LABEL")
								:gsub("/ ?LABEL",";/ LABEL")
								:gsub("/ ?chisq",";/CHISQ")
								:gsub("/ ?CHISQ",";/CHISQ")
								:gsub(" +;",";")
								:gsub("%%else %%if"," ; %%ELSEIF")
								:gsub("%%ELSE %%IF"," ; %%ELSEIF")
								:gsub(" %%then where"," ; %%THEN WHERE")
								:gsub(" %%THEN WHERE"," ; %%THEN WHERE")
								:gsub(" %%then"," ; %%THEN")
								:gsub(" %%THEN"," ; %%THEN")
								:gsub(" then"," ; THEN")
								:gsub(" THEN"," ; THEN")
								:gmatch("[^;]*;") do
		--test with: 
		print("line: " .. semikolon)
		--for LuaJ :gsub("\r\n"," ")
		semikolon=semikolon:gsub("\n"," ")
							:gsub("^ +","")
							:gsub("^\t+","")
							:gsub(","," ,")
							:gsub(";"," ;")
							:gsub(" +"," ")
		if semikolon:lower():match("^%%include") then
			--take all includes separated by blanks
			for field in semikolon:gsub(";"," ;"):gsub(" +"," "):gmatch('"[^"]*"') do
				if field:match('"([^"]*)"') then
					print("include: " .. field)
					if field:match(":\\") then
						DateiText=field:match('"([^"]*)"')
					else
						DateiText="C:\\Temp" .. field:match('"([^"]*)"'):gsub("%&sascode%.","")
					end --if field:match(":\\") then
					--printOut("Rekursion: " .. semikolon:gsub("INCLUDE","INCLUDE: "):gsub("include","INCLUDE: ") .. ": Datei: " .. DateiText)
					printOut("Rekursion: " .. DateiText)
					contentTable["Rekursion"]["%INCLUDE"]=semikolon:gsub("%%INCLUDE ",""):gsub("%%include ","")
					contentTable["Datei"][DateiText]=true
					--recursion
					RecursiveTreatSAS(DateiText)
					--printOut("Rekursionsende: " .. semikolon:gsub("INCLUDE","INCLUDE: "):gsub("include","INCLUDE: ") .. ": Datei: " .. DateiText)
					printOut("Rekursionsende: " .. DateiText)
					contentTable["Rekursionsende"]["%INCLUDE"]=semikolon:gsub("%%INCLUDE ",""):gsub("%%include ","")
					contentTable["Datei"][DateiText]=true
				end --if field:match('"([^"]*)"') then
			end --for field in semikolon:gsub(";"," ;"):gsub(" +"," "):gmatch("([^ ]*) ") do
		elseif semikolon:lower():match("^proc") then
			--test with: printOut("Prozedur: " .. semikolon)
		elseif semikolon:lower():match("^data") or 
			semikolon:lower():match("^set") or 
			semikolon:lower():match("^merge") or
			semikolon:lower():match("^if .*then output") or
			semikolon:lower():match("^else.*output") or
			semikolon:lower():match("^ods output") then
			--test with: printOut("Datastep: " .. semikolon)
		elseif semikolon:lower():match("^label") or semikolon:lower():match("^title") or semikolon:lower():match("^footnote") then
			--test with: printOut("Labels: " .. semikolon)
		elseif semikolon:lower():match("^format") or semikolon:lower():match("^length") then
			--test with: printOut("Formate: " .. semikolon)
		elseif semikolon:lower():match("^/") or semikolon:lower():match("^repeated") or semikolon:lower():match("^means") then
			--test with: printOut("Optionen: " .. semikolon)
		elseif semikolon:lower():match("^where") then
			--test with: printOut("Bedingung: " .. semikolon)
		elseif semikolon:lower():match("^by") then
			local variablenText = semikolon:gsub("by ","BY: ")
												:gsub("BY ","BY: ")
												:gsub("%(","")
												:gsub("%)","")
												:gsub(";"," ;")
			printOut("Variablen: " .. variablenText)
			for field in variablenText:gsub(" +"," "):gmatch("([^ ]*) ") do
				if field:match(":$")==nil then
					contentTable["Variablen"]["By"][field]=true
				end --if field:match(":$")==nil then
			end --for field in variablenText:gmatch("([^ ]*) ") do
		elseif semikolon:lower():match("^input") or 
			semikolon:lower():match("^keep") or 
			semikolon:lower():match("^select") or 
			semikolon:lower():match("^drop") or 
			semikolon:lower():match("^var ") or 
			semikolon:lower():match("^class ") or 
			semikolon:lower():match("^model ") or 
			semikolon:lower():match("^paired ") or 
			semikolon:lower():match("^tables ") or 
			semikolon:lower():match("^weight ") or 
			semikolon:lower():match("^histogram") then
			local variablenText=semikolon:gsub("input ","INPUT: ")
											:gsub("INPUT ","INPUT: ")
											:gsub("keep ","KEEP: ")
											:gsub("KEEP ","KEEP: ")
											:gsub("select ","SELECT: ")
											:gsub("SELECT ","SELECT: ")
											:gsub("drop ","DROP: ")
											:gsub("DROP ","DROP: ")
											:gsub("var ","VAR: ")
											:gsub("VAR ","VAR: ")
											:gsub("class ","CLASS: ")
											:gsub("CLASS ","CLASS: ")
											:gsub("model ","MODEL: ")
											:gsub("MODEL ","MODEL: ")
											:gsub("paired ","PAIRED: ")
											:gsub("PAIRED ","PAIRED: ")
											:gsub("tables ","TABLES: ")
											:gsub("TABLES ","TABLES: ")
											:gsub("weight ","WEIGHT: ")
											:gsub("WEIGHT ","WEIGHT: ")
											:gsub("histogram ","HISTOGRAM: ")
											:gsub("HISTOGRAM ","HISTOGRAM: ")
											:gsub(" %$"," ")
											:gsub(" %d+%."," ")
											:gsub("length=%d+"," ")
											:gsub("@%d+"," ")
											:gsub("@@"," ")
											:gsub("%u+%d+%."," ")
											:gsub("%l+%d+%."," ")
											:gsub("%(","")
											:gsub("%)","")
			printOut("Variablen: " .. variablenText)
			--print(variablenText)
			for field in variablenText:gsub(" +"," "):gmatch("([^ ]*) ") do
				if field:match(":$")==nil and field~="," and field~="=" then
					contentTable["Variablen"][tostring(variablenText:match("([^:]*):"))][field]=true
				end --if field:match(":$")==nil and field~="," and field~="=" then
			end --for field in variablenText:gsub(" +"," "):gmatch("([^ ]*) ") do
		elseif (semikolon:match("=") or
			semikolon:match(" eq ") or
			semikolon:match(" ne ") or
			semikolon:match(" le ") or
			semikolon:match(" lt ") or
			semikolon:match(" ge ") or
			semikolon:match(" gt ") 
			) and (semikolon:match("if") or semikolon:match("=.*=")==nil ) then
			local variablenText=semikolon:gsub("else ","ELSE: ")
							:gsub("ELSE ","ELSE: ")
							:gsub("then ","THEN: ")
							:gsub("THEN ","THEN: ")
			printOut("Variable: " .. variablenText)
			--test with: print("->" .. variablenText .. "-> " .. tostring(variablenText:match("([^:]*):")) .. " -> " .. tostring(variablenText:match(": ?([^:]*)")))
			if variablenText:match("([^:]*):") then
				contentTable["Variable"][variablenText:match("([^:]*):")][variablenText:match(": ?([^:]*)")]=true
			else
				contentTable["Variable"]["nil"][variablenText]=true
			end --if variablenText:match("([^:]*):") then
		elseif semikolon:match("=") and semikolon:match("=.*=") then
			--test with: printOut("Liste: " .. semikolon)
		elseif semikolon:lower()~="run;" and 
		semikolon:lower()~=";" and 
		semikolon:match("^%*.*;$")==nil and
		semikolon~="quit;" 
		then
			--test with: printOut(semikolon)
		end --if semikolon:lower():match("^%%include") then
	end --for semikolon in (text .. "\n") etc...
end --function RecursiveTreatSAS(SASFile)

--4. building a result file with categorisations of data
outputFile=io.open("C:\\Temp\\SAS_Analyser.txt","w")

--4.1 apply recursive function
RecursiveTreatSAS("C:\\Temp\\SAS_Analyser.sas")

--4.2 close the file
outputFile:close()

--5. build the tree
treeText='Tree={branchname="SAS-Programmbaumansicht",{branchname="Inputdaten finden","Es werden die Daten aus den Rekursionen der INCLUDE-Statements gesammelt.","Die Dateinamen und die Variablen erscheinen in der Baumansicht.",'

--5.1 collect data from result for the tree
for k,v in pairs(contentTable) do
	if type(v)=="table" then
		treeText=treeText .. '\n},{branchname="' .. string.escape_forbidden_char(tostring(k)) .. '",'
		for k1,v1 in pairs(v) do
			if type(v1)=="table" then
				treeText=treeText .. '\n    {branchname="' .. string.escape_forbidden_char(tostring(k1)) .. '", '
				for k2,v2 in pairs(v1) do
						treeText=treeText .. '"' .. string.escape_forbidden_char(tostring(k2)) .. '",'
				end --for k2,v2 in pairs(v1) do
				treeText=treeText .. ' },'
			else
				if v1==true then
					treeText=treeText .. '\n    "' .. string.escape_forbidden_char(tostring(k1)) .. '",'
				else
					treeText=treeText .. '\n    {branchname="' .. string.escape_forbidden_char(tostring(k1)) .. '","' .. string.escape_forbidden_char(tostring(v1)) .. '",},'
				end --if v1~=true then
			end --if type(v1)=="table" then
		end --for k1,v1 in pairs(v) do
	else
		print("k: " .. k,v)
	end --if type(v)=="table" then
end --for k,v in pairs(contentTable) do
treeText=treeText .. '\n},\n}\n'

--5.2 print result tree in the console
outputFile2=io.open("C:\\Temp\\SAS_Analyser_tree.lua","w")
printOut2(treeText)
outputFile2:close()

