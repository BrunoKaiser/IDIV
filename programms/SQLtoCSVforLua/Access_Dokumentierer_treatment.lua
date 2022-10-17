--This script treats the test file with the Access Dokumentierer and builds a tree with it

--1. general data
TabellenAbfragenTable={}

--2. function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--2.1 function for output print
printOut=print
function printOut(a)
	outputFile:write(a .. "\n")
end --function printOut(a)

--2.2 output file
outputFile=io.open("C:\\Temp\\Access_Dokumentierer_Tree.lua","w")
printOut('Tree={branchname="Access-Dokumentierer",{branchname="Übersicht Datenbank",{branchname="Dr. Bruno Kaiser",{branchname="Alle Objekte",')

--3. treat the Access Dokumentierer
for line in io.lines("C:\\Temp\\Access_Dokumentierer.txt") do 
	if (line:match(":")==nil and
		line~="Eigenschaften" and
		line:match("^                   +")==nil and
		line:match("^Alternate")==nil and
		line:match("^Pressed")==nil and
		line:match("^HoverFore")==nil and
		line:match("^BackTheme")==nil and
		line:match("^BorderTheme")==nil and
		line:match("^Gruppenebene")==nil and
		line:match("^erAndPageFoot")==nil and
		line:match("^KeyboardLa")==nil and
		line:match("^TextFont")==nil and
		line:match("^OnClickEm")==nil and
		line:match("^Gridline")==nil and
		line:match("^Datasheet")==nil and
		line:match("^Benutzerberechtigungen")==nil and
		line:match("^Gruppenberechtigungen")==nil and
		line:match(" lesen;")==nil and
		line:match(" aktualisieren;")==nil and
		line~="" 
		)
		or
		(
		line:match("^                       +")==nil and
		line:match("^                    +") )
		then
		printOut('"' .. string.escape_forbidden_char(line) .. '",') 
	elseif line:match("Tabelle: ") and TabellenAbfragenTable[line:gsub("Seite: %d+",""):gsub(" +"," ")]==nil then
		printOut('},\n{branchname="' .. string.escape_forbidden_char(line:gsub("Seite: %d+","")):gsub(" +"," ") .. '",state="COLLAPSED",')
		TabellenAbfragenTable[line:gsub("Seite: %d+",""):gsub(" +"," ")]=true
	elseif line:match("Abfrage: ") and TabellenAbfragenTable[line:gsub("Seite: %d+",""):gsub(" +"," ")]==nil then
		printOut('},\n{branchname="' .. string.escape_forbidden_char(line:gsub("Seite: %d+","")):gsub(" +"," ") .. '",state="COLLAPSED",')
		TabellenAbfragenTable[line:gsub("Seite: %d+",""):gsub(" +"," ")]=true
	elseif line:match("Formular: ") and TabellenAbfragenTable[line:gsub("Seite: %d+",""):gsub(" +"," ")]==nil then
		printOut('},\n{branchname="' .. string.escape_forbidden_char(line:gsub("Seite: %d+","")):gsub(" +"," ") .. '",state="COLLAPSED",')
		TabellenAbfragenTable[line:gsub("Seite: %d+",""):gsub(" +"," ")]=true
	elseif line:match("Bericht: ") and TabellenAbfragenTable[line:gsub("Seite: %d+",""):gsub(" +"," ")]==nil then
		printOut('},\n{branchname="' .. string.escape_forbidden_char(line:gsub("Seite: %d+","")):gsub(" +"," ") .. '",state="COLLAPSED",')
		TabellenAbfragenTable[line:gsub("Seite: %d+",""):gsub(" +"," ")]=true
	elseif line:match("Modul: ") and TabellenAbfragenTable[line:gsub("Seite: %d+",""):gsub(" +"," ")]==nil then
		printOut('},\n{branchname="' .. string.escape_forbidden_char(line:gsub("Seite: %d+","")):gsub(" +"," ") .. '",state="COLLAPSED",')
		TabellenAbfragenTable[line:gsub("Seite: %d+",""):gsub(" +"," ")]=true
	end --if line:match(":")==nil then
end --for line in io.lines("C:\\Users\\RK\\Beckmann & Partner Consult GmbH\\Team_Test_IDIV - 
printOut('}\n}\n}\n}')

--5. close output file
outputFile:close()

