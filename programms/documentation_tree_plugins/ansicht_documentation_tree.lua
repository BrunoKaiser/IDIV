--This script runs a graphical user interface (GUI) in order to built up a documentation tree of the current repository and a documentation of related files and repositories. It displays the tree saved in documentation_tree.lua, the dynamic tree in documentation_tree_script.lua and the dynamic repository statistics stored in documentation_tree_statistics.lua

--1. basic data

--1.1 libraries and clipboard
--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iuplua_scintilla") --for Scintilla-editor

--1.1.2 initalize clipboard
clipboard=iup.clipboard{}

--1.1.3 empty temporary tree needed to copy node with all its child nodes
tree_temp={} --An Zuordnung senden, Verdoppeln

--1.1.4 math.integer for Lua 5.1 and Lua 5.2
if _VERSION=='Lua 5.1' then
	function math.tointeger(a) return a end
elseif _VERSION=='Lua 5.2' then
	function math.tointeger(a) return a end
end --if _VERSION=='Lua 5.1' then


--1.1.5 securisation by allowing only necessary os.execute commands
do --sandboxing
	local old=os.date("%H%M%S")
	local secureTable={}
	secureTable[old]=os.execute
	function os.execute(a)
		if 
		a:lower():match("^sftp ") or
		a:lower():match("^dir ") or
		a:lower():match("^pause") or
		a:lower():match("^title") or
		a:lower():match("^md ") or
		a:lower():match("^copy ") or
		a:lower():match("^color ") or
		a:lower():match("^start ") 
		then
			return secureTable[old](a)
		else
			print(a .." ist nicht erlaubt.")
		end --if a:match("del") then 
	end --function os.execute(a)
	secureTable[old .. "1"]=io.popen
	function io.popen(a)
		if 
		a:lower():match("^dir ") or
		a:lower():match('^"dir ') 
		then
			return secureTable[old .. "1"](a)
		else
			print(a .." ist nicht erlaubt.")
		end --if a:match("del") then 
	end --function io.popen(a)
end --do --sandboxing

--1.2 color section
--1.2.1 color of the console associated with the graphical user interface if started with lua54.exe and not wlua54.exe
os.execute('color 71')

--1.2.2 Beckmann und Partner colors
color_red_bpc="135 31 28"
color_light_color_grey_bpc="196 197 199"
color_grey_bpc="162 163 165"
color_blue_bpc="18 32 86"

--1.2.3 color definitions
color_background=color_light_color_grey_bpc
color_buttons=color_blue_bpc -- works only for flat buttons, "18 32 86" is the blue of BPC
color_button_text="255 255 255"
color_background_tree="246 246 246"


--1.3 path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)


--2. installation of the repositories and scripts
p=io.popen('dir "' .. path .. '" /b/o')
installTable={}
for fileName in p:lines() do
	fileName=fileName:lower()
	--print(fileName)
	if     fileName=="archiv"                            then installTable[fileName]="repository" 
	elseif fileName=="documentation_tree.lua"            then installTable[fileName]="Lua script" 
	elseif fileName=="documentation_tree_script.lua"     then installTable[fileName]="Lua script" 
	elseif fileName=="documentation_tree_statistics.lua" then installTable[fileName]="Lua script" 
	end --if fileName:lower()=="archiv" then
end --for fileName in p:lines() do

--2.1 make repository or make directory Archiv
if installTable["archiv"]==nil then os.execute('md "' .. path .. '\\Archiv"') end

--2.2 install skript documentation_tree.lua
documentation_tree_ProgrammText=[[

lua_tree_output={ branchname="Verzeichnisdokumentation", 
{ branchname="Verzeichnis-Dokumentation", 
state="COLLAPSED",
 "]] .. path:gsub("\\","\\\\") .. [[\\]] .. thisfilename .. [[", 
{ branchname="Baumdokumentationen Skripte", 
state="COLLAPSED",
 "]] .. path:gsub("\\","\\\\") .. [[\\documentation_tree.lua", 
 "]] .. path:gsub("\\","\\\\") .. [[\\documentation_tree_script.lua", 
 "]] .. path:gsub("\\","\\\\") .. [[\\documentation_tree_statistics.lua", 
},
{ branchname="Baumdokumentationen Verzeichnisse", 
state="COLLAPSED",
 "]] .. path:gsub("\\","\\\\") .. [[", 
 "]] .. path:gsub("\\","\\\\") .. [[\\Archiv", 
},
},
}
]]
if installTable["documentation_tree.lua"]==nil then 
	outputfile1=io.open(path .. "\\documentation_tree.lua","w") 
	outputfile1:write(documentation_tree_ProgrammText)
	outputfile1:close()
end --if installTable["documentation_tree.lua"]==nil then
--2.2 install skript documentation_tree.lua end

--2.3 install skript documentation_tree_script.lua
documentation_tree_script_ProgrammText=[[


path_script="]] .. path:gsub("\\","\\\\") .. [["

Taskslist={branchname="Taskslist",
"]] .. os.date("%d.%m.%Y") .. [[: Neuanlage der Verzeichnisse und der Skripte",
}


tree_script={branchname="Nicht dokumentierte Dateien auf: " .. path_script, --Verbesserung durch Pfadangabe
}


--Dateien in einer Tabelle pro Kategorie speichern
DateiTabelle={}
temp_folder_content=io.popen('"dir /b /s "' .. path_script ..'""') --execute command to obtain the current directory. /s can be left out, if the subdirectories should not be considered
while true do
	local line = temp_folder_content:read("*line")
	if line == nil then break end
	--direktes Schreiben: tree_script[#tree_script+1]=line:sub(path_script:len()+1, -1)
	--indirektes Schreiben:
	Datei=line:sub(path_script:len()+1, -1)
	if     Datei:match("\\[^\\%.]+$") then DateiTabelle[Datei]="Verzeichnisse"
	elseif Datei:match("_Version%d+") then DateiTabelle[Datei]="Versionsdateien"
	elseif Datei:match("%d%d%d%d%d%d%d%d") then DateiTabelle[Datei]="Archivierungen"
	elseif Datei:lower():match("tree.*%.lua$") then DateiTabelle[Datei]="Lua-Tree-Dateien"
	elseif Datei:lower():match("tree.*%.iup.*lua.*$") then DateiTabelle[Datei]="Lua-Tree-Dateien"
	elseif Datei:lower():match("%.lua$") then DateiTabelle[Datei]="Lua-Skripte"
	elseif Datei:lower():match("%.iup.*lua.*$") then DateiTabelle[Datei]="IUP-Lua Benutzeroberflächen"
	elseif Datei:lower():match("%.wlua$") then DateiTabelle[Datei]="IUP-Lua Benutzeroberflächen"
	elseif Datei:lower():match("%.bat$") then DateiTabelle[Datei]="Batch-Dateien"
	elseif Datei:lower():match("%.exe$") then DateiTabelle[Datei]="Ausführbare Dateien"
	elseif Datei:lower():match("%.csv$") then DateiTabelle[Datei]="CSV-Dateien"
	elseif Datei:lower():match("%.je?pg$") then DateiTabelle[Datei]="Bild-Dateien"
	elseif Datei:lower():match("%.png$") then DateiTabelle[Datei]="Bild-Dateien"
	elseif Datei:lower():match("%.bmp$") then DateiTabelle[Datei]="Bild-Dateien"
	elseif Datei:lower():match("%.lnk$") then DateiTabelle[Datei]="Verknüpfungen"
	elseif Datei:lower():match("%.java$") then DateiTabelle[Datei]="Java-Dateien"
	elseif Datei:lower():match("%.jar$") then DateiTabelle[Datei]="Java-Dateien"
	elseif Datei:lower():match("%.class$") then DateiTabelle[Datei]="Java-Dateien"
	elseif Datei:lower():match("%.xlsx?$") then DateiTabelle[Datei]="Excel-Dateien"
	elseif Datei:lower():match("%.xlsm$") then DateiTabelle[Datei]="Excel-Dateien"
	elseif Datei:lower():match("%.docx?$") then DateiTabelle[Datei]="Word-Dateien"
	elseif Datei:lower():match("%.docm$") then DateiTabelle[Datei]="Word-Dateien"
	elseif Datei:lower():match("%.mdb$") then DateiTabelle[Datei]="Access-Dateien"
	elseif Datei:lower():match("%.accdb$") then DateiTabelle[Datei]="Access-Dateien"
	elseif Datei:lower():match("%.pdf$") then DateiTabelle[Datei]="Pdf-Dateien"
	elseif Datei:lower():match("%.pptx?$") then DateiTabelle[Datei]="Präsentationen"
	elseif Datei:lower():match("%.html?$") then DateiTabelle[Datei]="Html-Dateien"
	elseif Datei:lower():match("%.txt$") then DateiTabelle[Datei]="Text-Dateien"
	elseif Datei:lower():match("%.sas$") then DateiTabelle[Datei]="SAS-Skripte"
	else
                         DateiTabelle[Datei]="Sonstige"
	end --if     Datei:match("\\[^\\%.]+$") then
end --while true do
--Kategorien ermitteln
KategorieOhneDublikateTabelle={}
for k,v in pairs(DateiTabelle) do KategorieOhneDublikateTabelle[v]=v end
KategorieTabelle={}
for k,v in pairs(KategorieOhneDublikateTabelle) do KategorieTabelle[#KategorieTabelle+1]=v end
table.sort(KategorieTabelle,function (a,b) return a<b end)
--Dateien sammeln und an Kategorie pro Kategorie anhängen
for ka,va in pairs(KategorieTabelle) do
---Testen mit: iup.Message(ka,va)
for k,v in pairs(DateiTabelle) do
if v==va then
FundKnoten=""
for k1,v1 in pairs(tree_script) do if tree_script[k1].branchname==v then FundKnoten=v break end end
if FundKnoten=="" then
tree_script[#tree_script+1]={branchname=v} 
tree_script[#tree_script].state="COLLAPSED"
end --if FundKnoten=="" then
tree_script[#tree_script][#tree_script[#tree_script]+1]=k
table.sort(tree_script[#tree_script],function (a,b) return a<b end)
end --if v==ka then
end --for k,v in pairs(DateiTabelle) do
end --for ka,va in pairs(KategorieTabelle) do
--Anzahl Dateien ausgeben
for ka,va in pairs(KategorieTabelle) do
for k1,v1 in pairs(tree_script) do if tree_script[k1].branchname==va then tree_script[k1].branchname=tree_script[k1].branchname .. ": " .. #tree_script[k1] break end end
end --for ka,va in pairs(KategorieTabelle) do



Chronik={branchname="Chronik",state="COLLAPSED",}
Aktivitaeten={branchname="Aktivitäten",}
for k,v in ipairs(Taskslist) do
local DatumTag,DatumMonat,DatumJahr=v:match("(%d%d).(%d%d).(%d%d%d%d)")
local DatumText
if DatumJahr then DatumText=DatumJahr .. DatumMonat .. DatumTag end
if DatumText and DatumText<os.date("%Y%m%d") then
Chronik[#Chronik+1]=v
else
Aktivitaeten[#Aktivitaeten+1]=v
end --if DatumText and DatumText<os.date("%Y%m%d") then
end --for k,v in ipairs(Taskslist) do

tree_script[#tree_script+1]=Aktivitaeten
tree_script[#tree_script+1]=Chronik



]]
if installTable["documentation_tree_script.lua"]==nil then 
	outputfile1=io.open(path .. "\\documentation_tree_script.lua","w") 
	outputfile1:write(documentation_tree_script_ProgrammText)
	outputfile1:close()
end --if installTable["documentation_tree_script.lua"]==nil then
--2.3 install skript documentation_tree_script.lua end

--2.4 install skript documentation_tree_statistics.lua
documentation_tree_statistics_ProgrammText=[[


--Ordnerstruktur mit Anzahl Dateien
OrdnerTabelle={}
Anzahl=0 p=io.popen('dir "]] .. path:gsub("\\","\\\\") .. [[\\*.*" /b/o') for Datei in p:lines() do if Datei:match("%.[^\\]+") then Anzahl=Anzahl+1 end end OrdnerTabelle["]] .. path:gsub("\\","\\\\") .. [["]=Anzahl
Anzahl=0 p=io.popen('dir "]] .. path:gsub("\\","\\\\") .. [[\\Archiv\\*.*" /b/o') for Datei in p:lines() do if Datei:match("%.[^\\]+") then Anzahl=Anzahl+1 end end OrdnerTabelle["]] .. path:gsub("\\","\\\\") .. [[\\Archiv"]=Anzahl

--Wertebaum auf der untersten Stufe mit Werten
WerteTree={branchname="Ordnerübersicht mit Anzahl Dateien", state="COLLAPSED",
{branchname="Standard-Verzeichnisse",
{branchname="]] .. path:gsub("\\","\\\\") .. [[",OrdnerTabelle["]] .. path:gsub("\\","\\\\") .. [["] or 0,},
{branchname="]] .. path:gsub("\\","\\\\") .. [[\\Archiv",OrdnerTabelle["]] .. path:gsub("\\","\\\\") .. [[\\Archiv"] or 0,},
},
}

--Aggregation
Tiefe=0
TiefeRecursion(WerteTree)
print(Tiefe)
AnwendungTiefeRecursion(WerteTree)
WerteTreeAnsicht={}
AnsichtRecursion(WerteTree,WerteTreeAnsicht)
RemoveRecursion(WerteTreeAnsicht)
WerteTreeAnteile={}
AnteilRecursion(WerteTree,WerteTree,WerteTreeAnteile)
RemoveRecursion(WerteTreeAnteile)
WerteTreeAnteile.branchname="Ordnerübersicht mit Anteil Dateien"

--Fertiger Wertebaum
tree_statistics={branchname="Ordnerstatistik" ,
--WerteTree,
WerteTreeAnsicht,
WerteTreeAnteile,
}




]]
if installTable["documentation_tree_statistics.lua"]==nil then 
	outputfile1=io.open(path .. "\\documentation_tree_statistics.lua","w") 
	outputfile1:write(documentation_tree_statistics_ProgrammText)
	outputfile1:close()
end --if installTable["documentation_tree_statistics.lua"]==nil then
--2.4 install skript documentation_tree_statistics.lua end

--test with (status before installment): for k,v in pairs(installTable) do print(k,v) end


--2.5 script for manual tree
path_documentation_tree= path .. "\\documentation_tree.lua"

--2.5.1 search for valid tree
inputfile1=io.open(path .. "\\documentation_tree.lua","r")
if inputfile1 then
	while true do 
		TextInput=inputfile1:read()
		if TextInput and TextInput:match('lua_tree_output={ branchname="') then break end
		if TextInput==nil then break end
	end --while true do 
	inputfile1:close()
end --if inputfile then 

--2.5.2 if no valid tree is found in manual tree then take the securised file
if TextInput==nil then
	os.execute('copy "' .. path .. '\\Archiv\\documentation_tree_Sicherung.lua" "' .. path_documentation_tree .. '"' )
end --if TextInput==nil then

--2.5.3 securise file with date and with standard name
os.execute('copy "' .. path_documentation_tree .. '" "' .. path .. '\\Archiv\\documentation_tree' .. os.date("_%Y%m%d") .. '.lua"' )
os.execute('copy "' .. path_documentation_tree .. '" "' .. path .. '\\Archiv\\documentation_tree_Sicherung.lua"' )



--3 functions

--3.1 general Lua functions

--3.1.1 function checking if file exits
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end --function file_exists(name)

--3.1.2 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)



--3.2 functions for GUI

--3.2.1 function for deleting all nodes of an given tree, but that does not delete the tree
function delete_nodes_of_tree(tree_given)
	tree_given.delnode0 = "CHILDREN"
	tree_given.title=''
end --function delete_nodes_of_tree(tree_given)


--3.2.2.1 function which deletes nodes in the second tree, if they occur in the tree of the first argument
function delete_nodes_2nd_arg(tree,tree2)
	local existTreeTable={}
	for i=0, tree.count-1 do
		existTreeTable[tree["TITLE" .. i]]=true
	end --for i=0, tree.count-1 do
	for j=tree2.count -1,0,-1  do
		if existTreeTable[tree2.title0:match(".:\\.*") .. tree2["TITLE" .. j]] then --neu: relativ und absolut vergleichen
			tree2["DELNODE" .. j]="SELECTED"
		end --if tree["TITLE" .. i]==tree2.title0:match(".:\\.*") .. tree2["TITLE" .. j] then
	end --for j=0, tree2.count -1 do
end --function delete_nodes_2nd_arg(tree,tree2)


--3.2.2.2 function which deletes nodes in the second tree, if they occur in the tree of the first argument
function mark_nodes_2nd_arg(tree,tree2)
	local existTreeTable={}
	for i=0, tree.count-1 do
		existTreeTable[tree["TITLE" .. i]]=true
	end --for i=0, tree.count-1 do
	for j=0, tree2.count -1 do
		if existTreeTable[tree2.title0:match(".:\\.*") .. tree2["TITLE" .. j]] then --neu: relativ und absolut vergleichen
			iup.TreeSetNodeAttributes(tree2,j,{color="0 0 250",})
		end --if tree["TITLE" .. i]==tree2.title0:match(".:\\.*") .. tree2["TITLE" .. j] then
	end --for j=0, tree2.count -1 do
end --function mark_nodes_2nd_arg(tree,tree2)


--3.2.3 function which saves the current iup tree as a Lua table
function save_tree_to_lua(tree, outputfile_path)
	local output_tree_text="lua_tree_output=" --the output string
	local outputfile=io.output(outputfile_path) --a output file
	for i=0,tree.count - 1 do --loop for all nodes
		if tree["KIND" .. i ]=="BRANCH" then --consider cases, if actual node is a branch
			if (i > 0 and (tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) ) ) or i==0 then --consider cases if depth increases
				output_tree_text = output_tree_text .. '{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n' -- we open a new branch
				--save state
				if tree["STATE" .. i ]=="COLLAPSED" then
					output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
				end --if tree["STATE" .. i ]=="COLLAPSED" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) < tonumber(tree["DEPTH" .. i-1 ]) then --if depth decreases
				if tree["KIND" .. i-1 ] == "BRANCH" then --depending if the predecessor node was a branch we need to close one bracket more
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
					output_tree_text = output_tree_text .. '{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n' --and we open the new branch
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				else
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do -- or if the predecessor node was a leaf
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
					output_tree_text = output_tree_text .. '{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n' --and we open the new branch
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				end --if tree["KIND" .. i-1 ] == "BRANCH" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) == tonumber(tree["DEPTH" .. i-1 ]) then --or if depth stays the same
				if tree["KIND" .. i-1 ] == "BRANCH" then --again consider if the predecessor node was a branch
					output_tree_text = output_tree_text .. '},\n{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n'
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				else --or a leaf
					output_tree_text = output_tree_text .. '\n{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n'
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				end --if tree["KIND" .. i-1 ] == "BRANCH" then
			end --if (i > 0 and (tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) ) ) or i==0 then
		elseif tree["KIND" .. i ]=="LEAF" then --or if actual node is a leaf
			if (i > 0 and tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) )  or i==0 then
				output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",' --we add the leaf
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) < tonumber(tree["DEPTH" .. i-1 ]) then
				if tree["KIND" .. i-1 ] == "LEAF" then --in the same manner as above, depending if the predecessor node was a leaf or branch, we have to close a different number of brackets
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
					output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",' --and in each case we add the new leaf
				else
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
					output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",'
				end --if tree["KIND" .. i-1 ] == "LEAF" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) == tonumber(tree["DEPTH" .. i-1 ]) then
				if tree["KIND" .. i-1 ] == "LEAF" then
					output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n'
				else
					output_tree_text = output_tree_text .. '},\n "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n'
				end --if tree["KIND" .. i-1 ] == "LEAF" then
			end --if (i > 0 and tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) )  or i==0 then
		end --if tree["KIND" .. i ]=="BRANCH" then
	end --for i=0,tree.count - 1 do
	for j=1, tonumber(tree["DEPTH" .. tree.count-1]) do
		output_tree_text = output_tree_text .. "}" --close as many brackets as needed
	end --for j=1, tonumber(tree["DEPTH" .. tree.count-1]) do
	if tree["KIND" .. tree.count-1]=="BRANCH" then
		output_tree_text = output_tree_text .. "}" -- we need to close one more bracket if last node was a branch
	end --if tree["KIND" .. tree.count-1]=="BRANCH" then
	--output_tree_text=string.escape_forbidden_char(output_tree_text)
	outputfile:write(output_tree_text) --write everything into the outputfile
	outputfile:close()
end --function save_tree_to_lua(tree, outputfile_path)



--3.2.4 functions which compares first text file with second text file
function compare_files_raw(fileText,compareFileText)
	compareText=compareText .. "\nDatei: " .. fileText .. "\n\n"
	--build the compare-table bTable from compareFileText
	bTable={} i=0
	for textLine in io.lines(compareFileText) do i=i+1 bTable[i]={bLine=textLine}
		for c in textLine:gmatch(".") do
			bTable[i][#bTable[i]+1]=c
		end --for c in textLine:gmatch(".") do
	end --for textLine in io.lines(fileText) do 
	--compare of all rows of fileText
	comp1,comp2="","" j=0 j_raw=0
	for textLine in io.lines(fileText) do
		--find row to compare
		j_raw=j_raw+1
		j=j_raw
		for naechster=1,#bTable do
			if bTable[naechster] and bTable[naechster].bLine and textLine==bTable[naechster].bLine then
			j=naechster break
			end --if bTable[naechster] and bTable[naechster].bLine and textLine==bTable[naechster].bLine then
		end --for naechster=1,#bTable do
		--test with: print(j_raw,j)
		if bTable[j] and textLine==bTable[j].bLine then
			comp1,comp2="O","K"
		elseif bTable[j] then
			textLine=textLine .. string.rep(" ",math.max(#bTable[j].bLine-#textLine,0)) 
			k=0 comp1,comp2="",""
			--compare character by character
			for c in textLine:gmatch(".") do
				k=k+1
				if c~=bTable[j][k] then
					comp1=comp1 .. c comp2=comp2 .. tostring(bTable[j][k]):gsub("nil"," ")
				elseif c=="\t" and tostring(bTable[j][k])=="\t" then
					comp1=comp1 .. "\t" comp2=comp2 .. "\t"
				elseif tostring(bTable[j][k])=="\t" then
					comp1=comp1 .. " " comp2=comp2 .. "\t"
				elseif c=="\t" then
					comp1=comp1 .. "\t" comp2=comp2 .. " "
				else
					comp1=comp1 .. " " comp2=comp2 .. " "
				end --if c~=bTable[j][k] then
			end --for c in textLine:gmatch(".") do
			compareText=compareText .. j_raw .. "\t" .. j .. "________________________" .. "\n" .. textLine .. "\n" .. comp1 .. "\n" .. comp2 .. "\n"
		else
			comp1,comp2="",""
			compareText=compareText .. j_raw .. "\t" .. j .. "________________________" .. "\n" .. textLine .. "\n" .. comp1 .. "\n" .. comp2 .. "\n"
		end --if bTable[j] and textLine==bTable[j].bLine then
	end --for textLine in io.lines(fileText) do
end --function compare_files_raw(fileText,compareFileText)
function compare_files(file1,file2)
	compare_files_raw(file1,file2)
	compare_files_raw(file2,file1)
end --function compare_files(file1,file2)


--3.2 functions for GUI end
 
--3.3 functions for writing text files

--3.3.1 function for writing tree in a text file (function for printing tree)
function printtree()
	--open a filedialog
	filedlg2=iup.filedlg{dialogtype="SAVE",title="Ziel auswählen",filter="*.txt",filterinfo="Text Files", directory="c:\\temp"}
	filedlg2:popup(iup.ANYWHERE,iup.ANYWHERE)
	if filedlg2.status=="1" or filedlg2.status=="0" then
		local outputfile=io.output(filedlg2.value) --setting the outputfile
		for i=0,tree.totalchildcount0 do
			local helper=tree['title' .. i]:gsub("\n","\\n")
			for j=1,tree['depth' .. i] do
				helper='\t' ..  helper
			end --for j=1,tree['depth' .. i] do
			outputfile:write(helper, '\n')
		end --for i=0,tree.totalchildcount0 do
		outputfile:close() --close the outputfile
	else --no outputfile was choosen
		iup.Message("Schließen","Keine Datei ausgewählt")
		iup.NextField(maindlg)
	end --if filedlg2.status=="1" or filedlg2.status=="0" then
end --function printtree()


--3.3.2 function for printing dependencies in a csv file
function printdependencies()
	--open a filedialog
	filedlg3=iup.filedlg{dialogtype="SAVE",title="Ziel auswählen",filter="*.csv",filterinfo="csv Files", directory="c:\\temp"}
	filedlg3:popup(iup.ANYWHERE,iup.ANYWHERE)
	if filedlg3.status=="1" or filedlg3.status=="0" then
		local outputfile=io.output(filedlg3.value)--setting the outputfile
		-- want to write dependencies in output file, so each decendent in first colum, parent in second. This for all relations.		
		for i=0, tree.count - 1 do -- loop for nodes. in the loop we list all descendants in first generation in outputfile
			local j=i+1 -- variable for decendents
			while j<=tree.count -1 and tree["depth"..i]<tree["depth"..j] do -- while current node lies higher then following nodes -> then we are looking in descendants of current node
				if tonumber(tree["depth"..i] + 1) == tonumber(tree["depth"..j]) then -- check if decendent is 1st generation
					outputfile:write(tree["title"..j]:gsub("\n","\\n") .. ";" .. tree["title".. i]:gsub("\n","\\n")) --write the dependency
					outputfile:write("\n")
				end --if tonumber(tree["depth"..i] + 1) == tonumber(tree["depth"..j]) then
				j=j+1
			end --while j<=tree.count -1 and tree["depth"..i]<tree["depth"..j] do
		end --for i=0, tree.count - 1 do
		outputfile:close()--close the outputfile
	else --no file was choosen
		iup.Message("Schließen","Keine Datei ausgewählt")
		iup.NextField(maindlg)
	end --if filedlg3.status=="1" or filedlg3.status=="0" then
end --function printdependencies()

--3.3 functions for writing text files end




--3.4 functions for summing up in the tree
--3.4.1 function for recursion to build the sum backwards
function BackwardRecursion(WerteTabelle)
	local Summe=nil
	local AnzahlNumber=0
	for k,v in pairs(WerteTabelle) do
		if type(v)=="table" and type(v[1])~="number" then
			BackwardRecursion(v)
		elseif type(v)=="table" and type(v[1])=="number" then print(k,v[1])
			if Summe then Summe=Summe+v[1] else Summe = v[1] end
			AnzahlNumber=AnzahlNumber+1
		else print(k,v)
		end --if type(v)=="table" and type(v[1])~="number" then
	end --for k,v in pairs(WerteTabelle) do
	print("AnzahlNumber",AnzahlNumber,#WerteTabelle)
	if AnzahlNumber==#WerteTabelle and type(WerteTabelle[1])~="number" then
		table.insert(WerteTabelle,1,Summe)
		print(Summe)
	end --if AnzahlNumber==#WerteTabelle[1] and type(WerteTabelle[1])~="number" then
end --function BackwardRecursion(WerteTabelle)


--3.4.2 calculate the depth to reduce number of recursions
function TiefeRecursion(WerteTabelle)
	Tiefe=(Tiefe or 0)+1
	for k,v in pairs(WerteTabelle) do
		if type(v)=="table" then
			TiefeRecursion(v)
		end --if type(v)=="table" then
	end --for k,v in pairs(WerteTabelle) do
end --function TiefeRecursion(WerteTabelle)

--3.4.3 function to use the recursion until depth to avoid endless loop
function AnwendungTiefeRecursion(WerteTabelle)
	local i=0
	while i<Tiefe do
		i=i+1
		if type(WerteTabelle[1])=="number" then break 
		else
			BackwardRecursion(WerteTabelle)
		end --if type(WerteTabelle[1])=="number" then break 
	end --while i<Tiefe do
end --function AnwendungTiefeRecursion(WerteTabelle)

--3.4.4 function for visualisation of the backward recursion to have values in the same line as the texts
--idea: TreeZurAnsicht recursiv branchname with element 1 to be added and delete element 1 TreeAusgabe wth function RemoveRecursion()
function AnsichtRecursion(TreeZurAnsicht,TreeAusgabe)
	TreeAusgabe.state="COLLAPSED"
	TreeAusgabe.branchname=TreeZurAnsicht.branchname:gsub(" +$","") .. ": " .. tostring(TreeZurAnsicht[1]):gsub("%.(%d+)",",%1 "):gsub("(%d?%d?%d)(%d%d%d,)","%1.%2"):gsub("(%d?%d?%d)(%d%d%d)$","%1.%2"):gsub("(%d?%d?%d)(%d%d%d%.)","%1.%2"):gsub("(%d?%d?%d)(%d%d%d%.)","%1.%2"):gsub("(%d?%d?%d)(%d%d%d%.)","%1.%2"):gsub("(%d?%d?%d)(%d%d%d%.)","%1.%2"):gsub(" $","")
	TreeAusgabe[1]=TreeZurAnsicht[1]
	for k,v in ipairs(TreeZurAnsicht) do
		if k>1 then TreeAusgabe[k]={} AnsichtRecursion(TreeZurAnsicht[k],TreeAusgabe[k]) end
	end --for k,v in ipairs(TreeZurAnsicht) do
end --function AnsichtRecursion(TreeZurAnsicht,TreeAusgabe)

--3.4.5 function to calculate the portions with the sums of the levels above
function AnteilRecursion(TreeAnteile,SummeTabelle,TreeAusgabe)
	TreeAusgabe.state="COLLAPSED"
	TreeAusgabe.branchname=TreeAnteile.branchname .. ": " .. math.floor(TreeAnteile[1]/SummeTabelle[1]*100+0.5)/100
	TreeAusgabe[1]=TreeAnteile[1]
	for k,v in ipairs(TreeAnteile) do
		if type(v)=="table" then TreeAusgabe[k]={} AnteilRecursion(v,TreeAnteile,TreeAusgabe[k]) end
	end --for k,v in ipairs(TreeAnteile) do
end --function AnteilRecursion(TreeAnteile,SummeTabelle,TreeAusgabe)

--3.4.6 function to delete the first elements if it is a number
function RemoveRecursion(WerteTabelle)
	if type(WerteTabelle[1])=="number" then table.remove(WerteTabelle,1) end
	for k,v in ipairs(WerteTabelle) do
		if type(v)=="table" then RemoveRecursion(v) end
	end --for k,v in ipairs(WerteTabelle) do
end --function RemoveRecursion(WerteTabelle)

--3.4 functions for summing up in the tree end


--4. dialogs

--4.1 rename dialog
--ok button
ok = iup.flatbutton{title = "OK",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function ok:flat_action()
	tree.title = text.value
	return iup.CLOSE
end --function ok:flat_action()

--cancel button
cancel = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function cancel:flat_action()
	return iup.CLOSE
end --function cancel:flat_action()

text = iup.multiline{size="120x50",border="YES",expand="YES",wordwrap="YES"} --textfield
label1 = iup.label{title="Name:"}--label for textfield

--open the dialog for renaming branch/leaf
dlg_rename = iup.dialog{
	iup.vbox{label1, text, iup.hbox{ok,cancel}}; 
	title="Knoten bearbeiten",
	size="QUARTER",
	startfocus=text,
	}

--4.1 rename dialog end


--4.2 search dialog
searchtext = iup.multiline{border="YES",expand="YES", SELECTION="ALL",wordwrap="YES"} --textfield for search

--search in downward direction
searchdown    = iup.flatbutton{title = "Abwärts",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function searchdown:flat_action()
	local help=false
	--downward search
	if checkboxforcasesensitive.value=="ON"  then
		for i=tree.value + 1, tree.count-1 do
			if tree["title" .. i]:match(searchtext.value)~= nil then
				tree.value= i
				help=true
				break
			end --if tree["title" .. i]:match(searchtext.value)~= nil then
		end --for i=tree.value + 1, tree.count-1 do
	else
		for i=tree.value + 1, tree.count-1 do
			if tree["title" .. i]:lower():match(searchtext.value:lower())~= nil then
				tree.value= i
				help=true
				break
			end --if tree["title" .. i]:lower():match(searchtext.value:lower())~= nil then
		end --for i=tree.value + 1, tree.count-1 do
	end --if checkboxforcasesensitive.value=="ON" then
	if help==false then
		iup.Message("Suche","Ende des Baumes erreicht.")
		tree.value=0 --starting again from the top
		iup.NextField(maindlg)
		iup.NextField(dlg_search)
	end --if help==false then
end --function searchdown:flat_action()

--search to mark without going to the any node
searchmark    = iup.flatbutton{title = "Markieren",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function searchmark:flat_action()
	--unmark all nodes
	for i=0, tree.count - 1 do
			tree["color" .. i]="0 0 0"
	end --for i=0, tree.count - 1 do
	for i=0, tree2.count - 1 do
			tree2["color" .. i]="0 0 0"
	end --for i=0, tree2.count - 1 do
	for i=0, tree3.count - 1 do
			tree3["color" .. i]="0 0 0"
	end --for i=0, tree3.count - 1 do
	--unmark all nodes end
	--mark all nodes
	for i=0, tree.count - 1 do
		if tree["title" .. i]:upper():match(searchtext.value:upper())~= nil then
			iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
		end --if tree["title" .. i]:upper():match(searchtext.value:upper())~= nil then
	end --for i=0, tree2.count - 1 do
	for i=0, tree2.count - 1 do
		if tree2["title" .. i]:upper():match(searchtext.value:upper())~= nil then
			iup.TreeSetAncestorsAttributes(tree2,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree2,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree2,i,{color="90 195 0"})
		end --if tree2["title" .. i]:upper():match(searchtext.value:upper())~= nil then
	end --for i=0, tree2.count - 1 do
	for i=0, tree3.count - 1 do
		if tree3["title" .. i]:upper():match(searchtext.value:upper())~= nil then
			iup.TreeSetAncestorsAttributes(tree3,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree3,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree3,i,{color="90 195 0"})
		end --if tree3["title" .. i]:upper():match(searchtext.value:upper())~= nil then
	end --for i=0, tree3.count - 1 do
	--mark all nodes end
	for i=0, tree.count - 1 do
		--search in text files if checkbox on
		if checkboxforsearchinfiles.value=="ON"  and file_exists(tree["title" .. i]) 
			and (tree["title" .. i]:lower():match("^.:\\.*%.txt$")
			 or tree["title" .. i]:lower():match("^.:\\.*%.sas$") 
			 or tree["title" .. i]:lower():match("^.:\\.*%.csv$") 
			 or tree["title" .. i]:lower():match("^.:\\.*%.lua%d*$")
			 or tree["title" .. i]:lower():match("^.:\\.*%.iup%d*lua%d*$")
			 or tree["title" .. i]:lower():match("^.:\\.*%.wlua$")
			)
			then
			DateiFundstelle=""
			for textLine in io.lines(tree["title" .. i]) do if textLine:lower():match(searchtext.value:lower()) then DateiFundstelle=DateiFundstelle .. textLine .. "\n"  end end
			if DateiFundstelle~="" then
				iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
				iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
				iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
			end --if DateiFundstelle~="" then
		end --if checkboxforsearchinfiles.value=="ON"  and file_exists(tree["title" .. i])
		--search in text files if checkbox on end
	end --for i=0, tree.count - 1 do

	for i=0, tree2.count - 1 do
		--search in text files if checkbox on
		if checkboxforsearchinfiles.value=="ON"  and file_exists(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) 
		and ((tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.txt$")
		or (tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.sas$") 
		 or (tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.csv$") 
		 or (tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.lua%d*$")
		 or (tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.iup%d*lua%d*$")
		 or (tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.wlua$")
		)
		then
			DateiFundstelle=""
			for textLine in io.lines(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) do if textLine:lower():match(searchtext.value:lower()) then DateiFundstelle=DateiFundstelle .. textLine .. "\n"  end end
			if DateiFundstelle~="" then
					iup.TreeSetAncestorsAttributes(tree2,i,{color="255 0 0",})
					iup.TreeSetNodeAttributes(tree2,i,{color="0 0 250",})
					iup.TreeSetDescendantsAttributes(tree2,i,{color="90 195 0"})
			end --if DateiFundstelle~="" then
		end --if checkboxforsearchinfiles.value=="ON"  and file_exists(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i])
		--search in text files if checkbox on end
	end --for i=0, tree2.count - 1 do
end --function searchmark:flat_action()

--unmark without leaving the search-window
unmark    = iup.flatbutton{title = "Entmarkieren",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function unmark:flat_action()
--unmark all nodes
for i=0, tree.count - 1 do
	tree["color" .. i]="0 0 0"
end --for i=0, tree.count - 1 do
for i=0, tree2.count - 1 do
	tree2["color" .. i]="0 0 0"
end --for i=0, tree2.count - 1 do
for i=0, tree3.count - 1 do
	tree3["color" .. i]="0 0 0"
end --for i=0, tree3.count - 1 do
--unmark all nodes end
end --function unmark:flat_action()

--search in upward direction
searchup   = iup.flatbutton{title = "Aufwärts",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function searchup:flat_action()
	local help=false
	--upward search
	if checkboxforcasesensitive.value=="ON" then
		for i=tree.value - 1, 0, -1 do
			if tree["title" .. i]:match(searchtext.value)~= nil then
				tree.value= i
				help=true
				break
			end --if tree["title" .. i]:match(searchtext.value)~= nil then
		end --for i=tree.value - 1, 0, -1 do
	else
		for i=tree.value - 1, 0, -1 do
			if tree["title" .. i]:lower():match(searchtext.value:lower())~= nil then
				tree.value= i
				help=true
				break
			end --if tree["title" .. i]:lower():match(searchtext.value:lower())~= nil then
		end --for i=tree.value - 1, 0, -1 do
	end --if checkboxforcasesensitive.value=="ON" then
	if help==false then
		iup.Message("Suche","Anfang des Baumes erreicht.")
		tree.value=tree.count-1 --starting again from the bottom
		iup.NextField(maindlg)
		iup.NextField(dlg_search)
	end --if help==false then
end --	function searchup:flat_action()

checkboxforcasesensitive = iup.toggle{title="Groß-/Kleinschreibung", value="OFF"} --checkbox for casesensitiv search
checkboxforsearchinfiles = iup.toggle{title="Suche in den Textdateien", value="OFF"} --checkbox for searcg in text files
search_label=iup.label{title="Suchfeld:"} --label for textfield


--search searchtext.value in textfield1
search_in_textfield1   = iup.flatbutton{title = "Suche in der Vorschau",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
searchPosition=1
function search_in_textfield1:flat_action()
from,to=textfield1.value:find(searchtext.value,searchPosition)
searchPosition=to
if from==nil then 
searchPosition=1 
iup.Message("Suchtext in der Vorschau nicht gefunden","Suchtext in der Vorschau nicht gefunden")
else
textfield1.SELECTIONPOS=from-1 .. ":" .. to
end --if from==nil then 
end --	function search_in_textfield1:flat_action()


--put above together in a search dialog
dlg_search =iup.dialog{
			iup.vbox{iup.hbox{search_label,searchtext,}, 

			iup.label{title="Sonderzeichen: %. für ., %- für -, %+ für +, %% für %, %[ für [, %] für ], %( für (, %) für ), %^ für ^, %$ für $, %? für ?",},
			iup.hbox{searchmark,unmark,checkboxforsearchinfiles,}, 
			iup.label{title="rot: übergeordnete Knoten",fgcolor = "255 0 0", },
			iup.label{title="blau: gleicher Knoten",fgcolor = "0 0 255", },
			iup.label{title="grün: untergeordnete Knoten",fgcolor = "90 195 0", },
			iup.hbox{searchdown, searchup,checkboxforcasesensitive,},
			iup.hbox{search_in_textfield1,},

			}; 
		title="Suchen",
		size="420x100",
		startfocus=searchtext
		}

--4.2 search dialog end



--4.3 replace dialog

--cancel button for search dialog
cancel_replace = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function cancel_replace:flat_action()
	--make everything black again
	for i=0, tree.count - 1 do
		tree["color" .. i]="0 0 0"
	end --for i=0, tree.count - 1 do
	for i=0, tree2.count - 1 do
		tree2["color" .. i]="0 0 0"
	end --for i=0, tree2.count - 1 do
	return iup.CLOSE
end --function cancel_replace:flat_action()

searchtext_replace = iup.multiline{border="YES",expand="YES", SELECTION="ALL", wordwrap="YES"} --textfield for search
replacetext_replace = iup.multiline{border="YES",expand="YES", SELECTION="ALL", wordwrap="YES"} --textfield for replace

--search in upward direction
search_replace   = iup.flatbutton{title = "Ersetzen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function search_replace:flat_action()
	for i=0, tree.count-1 do
		if tree["TITLE" .. i]:match(searchtext_replace.value)~=nil then
			tree["TITLE" .. i]=tree["TITLE" .. i]:gsub(searchtext_replace.value,replacetext_replace.value)
		end --if tree["TITLE" .. i]:match(searchtext_replace.value)~=nil then
	end --for i=0, tree.count-1 do
end --function search_replace:flat_action()

search_label_replace=iup.label{title= "Suchfeld:    "} --label for textfield
replace_label_replace=iup.label{title="Ersetzen mit:"} --label for textfield

--put above together in a search dialog
dlg_search_replace =iup.dialog{
				iup.vbox{
					iup.hbox{search_label_replace,searchtext_replace},
					iup.hbox{replace_label_replace,replacetext_replace},
					iup.hbox{search_replace, cancel_replace,},
					iup.label{title="Sonderzeichen: %. für ., %- für -, %+ für +, %% für %, %[ für [, %] für ], %( für (, %) für ), %^ für ^, %$ für $, %? für ?",},
				}; 
				title="Suchen und Ersetzen",
				size="420x100",
				startfocus=replacetext_replace
				}
--4.3 replace dialog end

--4. dialogs end


--5. context menus (menus for right mouse click)

--5.1 menu of tree
--5.1.1 copy node of tree
startcopy = iup.item {title = "Knoten kopieren"}
function startcopy:action() --copy node
	 clipboard.text = tree['title']
end --function startcopy:action()

--5.1.1.1 copy node of tree with all children and add to the root
startcopy_doubling = iup.item {title = "Verdoppeln"}
function startcopy_doubling:action() --copy first node with same text as selected node with all its child nodes
	local TreeText=""
	local takeNode="yes"
	local actualDepth=1
	local kindEndNode=""
	local countNodeandChildren=0
	local numberOfNode=math.tointeger(tonumber(tree.value))
	local depthOfNode=tree["DEPTH" .. numberOfNode]
	for i=numberOfNode, tree.count-1 do
		if i==numberOfNode then
			kindEndNode=tree["KIND" .. i ]
			--test with: print(tree["TITLE" .. i])
			TreeText='{branchname="' .. string.escape_forbidden_char(tree["TITLE"]) .. '",'
			countNodeandChildren=countNodeandChildren+1
		elseif i>numberOfNode and tonumber(tree["DEPTH" .. i])>tonumber(depthOfNode) and takeNode=="yes" and tonumber(tree["DEPTH" .. i])>actualDepth then
			kindEndNode=tree["KIND" .. i ]
			actualDepth=tonumber(tree["DEPTH" .. i])
			if tree["KIND" .. i ]=="LEAF" then
				TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree["TITLE" .. i]) .. '",'
			else
				TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i]) .. '",'
			end --if tree["KIND" .. i ]=="LEAF" then
			countNodeandChildren=countNodeandChildren+1
		elseif i>numberOfNode and tonumber(tree["DEPTH" .. i])>tonumber(depthOfNode) and takeNode=="yes" and tonumber(tree["DEPTH" .. i])<actualDepth then
			if tree["KIND" .. i-1 ]=="BRANCH" then
				TreeText=TreeText .. '},\n'
			end -- if tree["KIND" .. i ]=="BRANCH" and tree["KIND" .. i ]=="BRANCH" then
			kindEndNode=tree["KIND" .. i ]
			local numberOfcurlybrakets=math.tointeger(actualDepth-tonumber(tree["DEPTH" .. i]))
			actualDepth=tonumber(tree["DEPTH" .. i])
			for i=1,numberOfcurlybrakets do
				TreeText=TreeText .. '},\n'
			end --for i=1,numberOfcurlybrakets do
			if tree["KIND" .. i ]=="LEAF" then
				TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree["TITLE" .. i]) .. '",'
			else
				TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i]) .. '",'
			end --if tree["KIND" .. i ]=="LEAF" then
			countNodeandChildren=countNodeandChildren+1
		elseif i>numberOfNode and tonumber(tree["DEPTH" .. i])>tonumber(depthOfNode) and takeNode=="yes" then
			--tonumber(tree["DEPTH" .. i])==actualDepth
			if tree["KIND" .. i-1 ]=="BRANCH" then
				TreeText=TreeText .. '},\n'
			end -- if tree["KIND" .. i ]=="BRANCH" and tree["KIND" .. i ]=="BRANCH" then
			kindEndNode=tree["KIND" .. i ]
			--test with: print(tree["DEPTH" .. i],tree.title0:match(".:\\.*") .. tree["TITLE" .. i])
			if tree["KIND" .. i ]=="LEAF" then
				TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree["TITLE" .. i]) .. '",'
			else
				TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i]) .. '",'
			end --if tree["KIND" .. i ]=="LEAF" then
			countNodeandChildren=countNodeandChildren+1
		elseif i>numberOfNode then
			takeNode="no"
		end --if takeNode=="yes" then
	end --for i=0, tree.count-1 do
	--test with: print(kindEndNode)
	--test with: print("countNodeandChildren: " .. countNodeandChildren)
	--with countNodeandChildren==1 the curly braket is set by the last one
	if kindEndNode=="BRANCH" and countNodeandChildren>1 then
		TreeText=TreeText .. '},\n'
	end -- if kindEndNode=="BRANCH" and countNodeandChildren>1 then
	endnumberOfcurlybrakets=math.max(math.tointeger(actualDepth-depthOfNode-1),0)
	for i=1,endnumberOfcurlybrakets do
	TreeText=TreeText .. '},'
	end --for i=1,endnumberOfcurlybrakets do
	TreeText=TreeText .. '}'
	--test with: print(TreeText)
	--load TreeText as tree_temp
	local _,numberCurlyBraketsBegin=TreeText:gsub("{","")
	local _,numberCurlyBraketsEnd=TreeText:gsub("}","")
	if numberCurlyBraketsBegin==numberCurlyBraketsEnd and _VERSION=='Lua 5.1' then
		loadstring('tree_temp='..TreeText)()
		--test with: 	for k,v in pairs(tree_temp) do print(k,v) end
		tree_temp={branchname=tree["title0"],tree_temp}
		iup.TreeAddNodes(tree,tree_temp)
	elseif numberCurlyBraketsBegin==numberCurlyBraketsEnd then
		load('tree_temp='..TreeText)() --now tree_temp is filled
		--test with: 	for k,v in pairs(tree_temp) do print(k,v) end
		tree_temp={branchname=tree["title0"],tree_temp}
		iup.TreeAddNodes(tree,tree_temp)
	else
		iup.Message("Der Knoten kann nicht verdoppelt werden.","Der Knoten kann nicht verdoppelt werden.")
	end --if numberCurlyBraketsBegin==numberCurlyBraketsEnd and _VERSION=='Lua 5.1' then
end --function startcopy_doubling:action() 


--5.1.2 rename node and rename action for other needs of tree
renamenode = iup.item {title = "Knoten bearbeiten"}
function renamenode:action()
	text.value = tree['title']
	dlg_rename:popup(iup.CENTER, iup.CENTER) --popup rename dialog
	iup.SetFocus(tree)
end --function renamenode:action()

--5.1.3 add branch to tree
addbranch = iup.item {title = "Ast hinzufügen"}
function addbranch:action()
	tree.addbranch = ""
	tree.value=tree.value+1
	renamenode:action()
end --function addbranch:action()

--5.1.4 add branch of tree from clipboard
addbranch_fromclipboard = iup.item {title = "Ast aus Zwischenablage"}
function addbranch_fromclipboard:action()
	tree.addbranch = clipboard.text
	tree.value=tree.value+1
end --function addbranch_fromclipboard:action()

--5.1.5 add leaf of tree
addleaf = iup.item {title = "Blatt hinzufügen"}
function addleaf:action()
	tree.addleaf = ""
	tree.value=tree.value+1
	renamenode:action()
end --function addleaf:action()

--5.1.6 add leaf of tree from clipboard
addleaf_fromclipboard = iup.item {title = "Blatt aus Zwischenablage"}
function addleaf_fromclipboard:action()
	tree.addleaf = clipboard.text
	tree.value=tree.value+1
end --function addleaf_fromclipboard:action()

--5.1.7 copy a version of the file selected in the tree and give it the next version number
startversion = iup.item {title = "Version archivieren"}
function startversion:action()
	--get the version of the file
	if tree['title']:match(".:\\.*%.[^\\]+") then
		Version=0
		p=io.popen('dir "' .. tree['title']:gsub("(%.+)","_Version*%1") .. '" /b/o')
		for Datei in p:lines() do 
			--test with: iup.Message("Version",Datei) 
			if Datei:match("_Version(%d+)") then Version_alt=Version Version=tonumber(Datei:match("_Version(%d+)")) if Version<Version_alt then Version=Version_alt end end
			--test with: iup.Message("Version",Version) 
		end --for Datei in p:lines() do 
		--test with: iup.Message(Version,Version+1)
		Version=Version+1
		iup.Message("Archivieren der Version:",tree['title']:gsub("(%.+)","_Version" .. Version .. "%1"))
		os.execute('copy "' .. tree['title'] .. '" "' .. tree['title']:gsub("(%.+)","_Version" .. Version .. "%1") .. '"')
	end --if tree['title']:match(".:\\.*%.[^\\]+") then
end --function startversion:action()

--5.1.8.1 start node of tree as a tree GUI or save a new one if not existing
startastree = iup.item {title = "Als Tree starten"}
function startastree:action()
	--look for a tree GUI in the repositories in the path
	--copy the GUI to have the GUI update to the last version used by the GUI from which it starts
	if file_exists(tree['title'] .. '\\' .. thisfilename ) then
	--g:match(".:\\[^\\]+")
		os.execute('copy "' .. path .. '\\' .. thisfilename .. '" "' .. tree['title'] .. '\\' .. thisfilename .. '"')
		--test with: iup.Message("Benutzeroberfläche kopiert",tree['title'] .. '\\' .. thisfilename)
		os.execute('start "D" "' .. tree['title'] .. '\\' .. thisfilename .. '"')
	elseif tree['title']:lower():match("\\archiv")==nil and tree['title']:match("\\[^\\%.]+$") then
		BenutzeroberflaechenText=""
		p=io.popen('dir "' .. tree['title']:match(".:\\[^\\]+") .. '\\' .. thisfilename .. '" /b/o/s')
		for Ordner in p:lines() do BenutzeroberflaechenText=BenutzeroberflaechenText .. Ordner .. "\n" end
		--tree GUI only if user want it
		AnlegeAlarm=iup.Alarm("Benutzeroberfläche angelegen?","Es gibt folgende Benutzeroberflächen:\n" .. BenutzeroberflaechenText .. "\nWas möchten Sie für das Verzeichnis mit der neuen Benutzeroberfläche tun??","Anlegen","Nicht anlegen")
		if AnlegeAlarm==1 then 
			os.execute('copy "' .. path .. '\\' .. thisfilename .. '" "' .. tree['title'] .. '\\' .. thisfilename .. '"')
			iup.Message("Benutzeroberfläche angelegt",tree['title'] .. '\\' .. thisfilename)
		elseif AnlegeAlarm==2 then
			iup.Message("Benutzeroberfläche wird nicht angelegt","Danke, nicht zu viele Benutzeroberflächen anzulegen.")
		end --if AnlegeAlarm==1 then 
	elseif tree['title']:lower():match("\\archiv") then
		iup.Message("Kein Tree bei einem Archiv","Bei einem Archiv (" .. tree['title'] .. ") wird kein Tree angelegt.")
	else 
		iup.Message("Kein Tree","Bei " .. tree['title'] .. " wird kein Tree angelegt.")
	end --if file_exists(tree['title'] .. '\\' .. thisfilename ) then
end --function startastree:action()

--5.1.8.2 start the directory of the file of the node of tree
start_repository_of_node = iup.item {title = "Ordner des Knotens starten"}
function start_repository_of_node:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "D" "' .. tree['title']:match("(.*)\\") .. '"') 
	end --if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
end --function start_repository_of_node:action()

--5.1.9 start file of node of tree in IUP Lua scripter or start empty file in notepad or start empty scripter
startnodescripter = iup.item {title = "Skripter starten"}
function startnodescripter:action()
	--read first line of file. If it is empty then scripter cannot open it. So open file with notepad.exe
	if file_exists(tree['title']) then inputfile=io.open(tree['title'],"r") ErsteZeile=inputfile:read() inputfile:close() end
	if file_exists(tree['title']) and ErsteZeile then 
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. tree['title'] .. '"')
	elseif file_exists(tree['title']) then 
		os.execute('start "d" notepad.exe "' .. tree['title'] .. '"')
	else
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe ')
	end --if file_exists(tree['title']) and ErsteZeile then 
end --function startnodescripter:action()

--5.1.10.1 start a preview of file of tree with columns for csv files or dir for repository or the text of the node
starteditor = iup.item {title = "Vorschau"}
function starteditor:action() --start preview
	if file_exists(tree['title']) then
		inputfile1=io.open(tree['title'],"r")
		inputText=inputfile1:read("*a")
		inputfile1:close()
		if tree['title']:match("%.csv") then
			inputText=inputText:gsub(";","\t"):gsub(",","\t")
			i=13 --minimum number of length of tabulator 
			while true do
				Textselbst,Anzahl=inputText:gsub("\n","\t"):gsub(string.rep("[^\t]",i),"")
				if Anzahl==0 then break end i=i+1
			end --while true do
			i=i-1 --because for i=0 there is no length
			i=math.min(i,80) --maximum number is 80 caracters
			outputText=""
			for textLine in (inputText .. "\n"):gmatch("([^\n]*)\n") do
				for Feld in (textLine .. "\t"):gmatch("([^\t]*)\t") do 
					if Feld:match("^%-?%d+") then
						outputText=outputText .. string.rep(" ",math.max(i-#Feld,0)) .. Feld .. "\t"
					else
						outputText=outputText .. Feld .. string.rep(" ",math.max(i-#Feld,0)) .. "\t"
					end --if Feld:match("^%-?%d+") then
				end --for Feld in (textLine .. "\t") do 
				outputText=outputText .. "\n"
			end --for textLine in inputText:match("([^\n]*)\n") do
			textfield1.value=outputText
		else
			textfield1.value=inputText
		end --if tree['title']:match("%.csv") then
	elseif tree['title']:match("^.:\\.*%.[^\\ ]+$")==nil and tree['title']:match("^.:\\.*[^\\]+$") then
		p=io.popen('dir "' .. tree['title'] .. '"')
		Verzeichnisliste=""
		for Datei in p:lines() do
			Verzeichnisliste=Verzeichnisliste .. Datei:gsub("ÿ",".") .. "\n"
		end --for Datei in p:lines() do
		textfield1.value=Verzeichnisliste
	else --substitute line break in preview
		textfield1.value=tree['title']:gsub("\\n","\n")
	end --if file_exists(tree['title']) then
end --function starteditor:action()

--5.1.10.2 start a preview of path and filenames of the scipt chosen in node
starteditor_path_files_of_script = iup.item {title = "Vorschau Pfade und Dateien"}
function starteditor_path_files_of_script:action()
	local takeLine
	local inputOutputData=""
	local pathThisfilenameTable={}
	if file_exists(tree['title']) then
		for line in io.lines(tree['title']) do
			if line:match('arg%[0%]') and line:match("^\t*%-%-")==nil and line:match("^\t*end ?%-%-")==nil then
				--test with: inputOutputData=inputOutputData .. "exchange_" .. line:gsub("^ *",""):gsub("^\t*",""):gsub('arg%[0%]','("' .. string.escape_forbidden_char(tree['title']) .. '")') .. "\n"
				pathThisfilenameTable[line:match("^[^=]+"):gsub(" ","")]=line:match("^[^=]+"):gsub(" ","")
			end --if line:match('arg%[0%]") then
		end --for line in io.lines(tree['title']) do
		for line in io.lines(tree['title']) do
			takeLine="no"
			for k,v in pairs(pathThisfilenameTable) do
				if (" " .. line .. " "):match("[^a-zA-Z0-9_]" .. k .. "[^a-zA-Z0-9_]") then takeLine="yes" end
			end --for k,v in pairs(pathThisfilenameTable) do
			if line:match("^\t*%-%-")==nil and line:match("^\t*end ?%-%-")==nil then
				if takeLine=="yes" then
					inputOutputData=inputOutputData .. line .. "\n"
				elseif line:match('\\\\[a-zA-Z0-9_]+%.[a-zA-Z0-9]+') then
					inputOutputData=inputOutputData .. line .. "\n"
				elseif line:match('\\[a-zA-Z0-9_]+%.[a-zA-Z0-9]+') then
					inputOutputData=inputOutputData .. line .. "\n"
				elseif line:match('"[a-zA-Z0-9_]+%.[a-zA-Z0-9]+"') then
					inputOutputData=inputOutputData .. line .. "\n"
				elseif line:match("'[a-zA-Z0-9_]+%.[a-zA-Z0-9]+'") then
					inputOutputData=inputOutputData .. line .. "\n"
				end --if line:match('\\[a-zA-Z0-9_]+%.[a-zA-Z0-9]+') then
			end --if line:match("^\t*%-%-")==nil and line:match("^\t*end ?%-%-")==nil then
		end --for line in io.lines(tree['title']) do
		textfield1.value=inputOutputData
	end --if file_exists(tree['title']) then
end --function starteditor_path_files_of_script:action()

--5.1.11 start the file or repository of the node of tree
startnode = iup.item {title = "Starten"}
function startnode:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "D" "' .. tree['title'] .. '"') 
	elseif tree['title']:match("sftp .*") then 
		os.execute(tree['title']) 
	end --if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
end --function startnode:action()

--5.1.12 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,
		startcopy_doubling,
		renamenode, 
		addbranch, 
		addbranch_fromclipboard, 
		addleaf,
		addleaf_fromclipboard,
		startversion,
		startastree, 
		start_repository_of_node, 
		startnodescripter, 
		starteditor,
		starteditor_path_files_of_script,
		startnode, 
		}
--5.1 menu of tree end


--5.2 menu of tree2
--5.2.1 copy node of tree2
startcopy2 = iup.item {title = "Knoten kopieren"}
function startcopy2:action() --copy node
	if tree2['title']:match("^\\.*") then
		clipboard.text=tree2.title0:match(".:\\.*") .. tree2['title']
	else
		clipboard.text=tree2['title']
	end --if tree2['title']:match("^\\.*") then
end --function startcopy2:action() 

--5.2.1.1 copy node of tree2 with all children and add to the root of the tree
startcopy_withchilds2 = iup.item {title = "An Zuordnung senden"}
function startcopy_withchilds2:action() --copy first node with same text as selected node with all its child nodes
	local TreeText=""
	local takeNode="yes"
	local actualDepth=1
	local numberOfNode=math.tointeger(tonumber(tree2.value))
	local depthOfNode=tree2["DEPTH" .. numberOfNode]
	for i=numberOfNode, tree2.count-1 do
		if tree2["KIND" .. numberOfNode ]=="LEAF" then
			--test with: print(tree2["KIND" .. i],tree2["MARKED" .. i])
			if tree2["KIND" .. i]=="LEAF" and tree2["MARKED" .. i]=="YES" then
				if tree2["TITLE" .. i]:match("^\\.*") then
					tree.addleaf = tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]
				else
					tree.addleaf = tree2["TITLE" .. i]
				end --if tree2["TITLE" .. i]:match("^\\.*") then
					tree.value=tree.value+1
			elseif tree2["KIND" .. i]=="BRANCH" and tree2["MARKED" .. i]=="YES" then
				if tree2["TITLE" .. i]:match("^\\.*") then
					tree.addbranch = tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]
				else
					tree.addbranch = tree2["TITLE" .. i]
				end --if tree2["TITLE" .. i]:match("^\\.*") then
				tree.value=tree.value+1
			end --if tree2["KIND" .. i]=="LEAF" and tree2["MARKED" .. i] then
		else
			if i==numberOfNode then
				--test with: print(tree2["DEPTH" .. i],tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i])
				if tree2["TITLE" .. i]:match("^\\.*") then
					TreeText='{branchname="' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
				else
					TreeText='{branchname="' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
				end --if tree2["TITLE" .. i]:match("^\\.*") then
			elseif i>numberOfNode and tonumber(tree2["DEPTH" .. i])>tonumber(depthOfNode) and takeNode=="yes" and tonumber(tree2["DEPTH" .. i])>actualDepth then
				actualDepth=tonumber(tree2["DEPTH" .. i])
				if tree2["KIND" .. i ]=="LEAF" then
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				else
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				end --if tree2["KIND" .. i ]=="LEAF" then
			elseif i>numberOfNode and tonumber(tree2["DEPTH" .. i])>tonumber(depthOfNode) and takeNode=="yes" and tonumber(tree2["DEPTH" .. i])<actualDepth then
				local numberOfcurlybrakets=math.tointeger(actualDepth-tonumber(tree2["DEPTH" .. i]))
				actualDepth=tonumber(tree2["DEPTH" .. i])
				for i=1,numberOfcurlybrakets do
					TreeText=TreeText .. '},\n'
				end --for i=1,numberOfcurlybrakets do
				if tree2["KIND" .. i ]=="LEAF" then
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				else
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				end --if tree2["KIND" .. i ]=="LEAF" then
			elseif i>numberOfNode and tonumber(tree2["DEPTH" .. i])>tonumber(depthOfNode) and takeNode=="yes" then
				--test with: print(tree2["DEPTH" .. i],tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i])
				if tree2["KIND" .. i ]=="LEAF" then
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				else
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				end --if tree2["KIND" .. i ]=="LEAF" then
			elseif i>numberOfNode then
				takeNode="no"
			end --if i==numberOfNode then
		end --if tree2["KIND" .. numberOfNode ]=="LEAF" then
	end --for i=0, tree2.count-1 do
	endnumberOfcurlybrakets=math.max(math.tointeger(actualDepth-depthOfNode-1),0)
	for i=1,endnumberOfcurlybrakets do
	TreeText=TreeText .. '},'
	end --for i=1,endnumberOfcurlybrakets do
	TreeText=TreeText .. '}'
	--test with: print(TreeText)
	--load TreeText as tree_temp
	local _,numberCurlyBraketsBegin=TreeText:gsub("{","")
	local _,numberCurlyBraketsEnd=TreeText:gsub("}","")
	if numberCurlyBraketsBegin==numberCurlyBraketsEnd and _VERSION=='Lua 5.1' then
		loadstring('tree_temp='..TreeText)()
		--test with: 	for k,v in pairs(tree_temp) do print(k,v) end
		tree_temp={branchname=tree["title0"],tree_temp}
		iup.TreeAddNodes(tree,tree_temp)
	elseif numberCurlyBraketsBegin==numberCurlyBraketsEnd then
		load('tree_temp='..TreeText)() --now tree_temp is filled
		--test with: 	for k,v in pairs(tree_temp) do print(k,v) end
		tree_temp={branchname=tree["title0"],tree_temp}
		iup.TreeAddNodes(tree,tree_temp)
	elseif tree2["KIND" .. numberOfNode ]=="LEAF" then
		--do nothing because marked leafs sent
	else
		iup.Message("Der Knoten kann nicht gesendet werden.","Der Knoten kann nicht gesendet werden.")
	end --if numberCurlyBraketsBegin==numberCurlyBraketsEnd and _VERSION=='Lua 5.1' then
end --function startcopy_withchilds2:action() 

--5.2.2 start file of node of tree2 in IUP Lua scripter or start empty file in notepad or start empty scripter
startnodescripter2 = iup.item {title = "Skripter starten"}
function startnodescripter2:action()
	--read first line of file. If it is empty then scripter cannot open it. So open file with notepad.exe
	if file_exists(tree2.title0:match(".:\\.*") .. tree2['title']) then inputfile=io.open(tree2.title0:match(".:\\.*") .. tree2['title'],"r") ErsteZeile=inputfile:read() inputfile:close() end
	if file_exists(tree2.title0:match(".:\\.*") .. tree2['title']) and ErsteZeile then 
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. tree2.title0:match(".:\\.*") .. tree2['title'] .. '"')
	elseif file_exists(tree2.title0:match(".:\\.*") .. tree2['title']) then
		os.execute('start "d" notepad.exe "' .. tree2.title0:match(".:\\.*") .. tree2['title'] .. '"')
	else
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe ')
	end --if ErsteZeile then 
end --function startnodescripter2:action()

--5.2.3 start a preview of file of tree2 with columns for csv files or dir for repository or the text of the node
starteditor2 = iup.item {title = "Vorschau"}
function starteditor2:action()
	if file_exists(tree2.title0:match(".:\\.*") .. tree2['title']) then
		inputfile1=io.open(tree2.title0:match(".:\\.*") .. tree2['title'],"r")
		inputText=inputfile1:read("*a")
		inputfile1:close()
		if tree2['title']:match("%.csv") then
			inputText=inputText:gsub(";","\t"):gsub(",","\t")
			i=13 --minimum number of length of tabulator 
			while true do
				Textselbst,Anzahl=inputText:gsub("\n","\t"):gsub(string.rep("[^\t]",i),"")
				if Anzahl==0 then break end i=i+1
			end --while true do
			i=i-1 --because for i=0 there is no length
			i=math.min(i,80) --maximum number is 80 caracters
			outputText=""
			for textLine in (inputText .. "\n"):gmatch("([^\n]*)\n") do
				for Feld in (textLine .. "\t"):gmatch("([^\t]*)\t") do 
					if Feld:match("^%-?%d+") then
						outputText=outputText .. string.rep(" ",math.max(i-#Feld,0)) .. Feld .. "\t"
					else
						outputText=outputText .. Feld .. string.rep(" ",math.max(i-#Feld,0)) .. "\t"
					end --if Feld:match("^%-?%d+") then
				end --for Feld in (textLine .. "\t") do 
				outputText=outputText .. "\n"
			end --for textLine in inputText:match("([^\n]*)\n") do
			textfield1.value=outputText
		else
			textfield1.value=inputText
		end --if tree2['title']:match("%.csv") then
	elseif tree2['title']:match("^\\.*%.[^\\ ]+$")==nil and tree2['title']:match("^\\.*[^\\]+$") then
		p=io.popen('dir "' .. tree2.title0:match(".:\\.*") .. tree2['title'] .. '"')
		Verzeichnisliste=""
		for Datei in p:lines() do
			Verzeichnisliste=Verzeichnisliste .. Datei:gsub("ÿ",".") .. "\n"
		end --for Datei in p:lines() do
		textfield1.value=Verzeichnisliste
	else --substitute line break in preview
		textfield1.value=(tree2.title0:match(".:\\.*") .. tree2['title']):gsub("\\n","\n")
	end --if file_exists(tree['title']) then
end --function starteditor2:action()

--5.2.4 start the file or repository of the node of tree2
startnode2 = iup.item {title = "Starten"}
function startnode2:action()
	if tree2['title']:match("Nicht dokumentierte Dateien auf: ") then
		os.execute('start "D" "' .. tree2['title']:match("Nicht dokumentierte Dateien auf: (.*)") .. '"')
	elseif tree2['title']:match("^\\.*[^\\]+$") then
		os.execute('start "D" "' .. tree2.title0:match(".:\\.*") .. tree2['title'] .. '"')
	end --if tree2['title']:match("Nicht dokumentierte Dateien auf: ") then
end --function startnode2:action()

--5.2.5 put the menu items together in the menu for tree2
menu2 = iup.menu{
		startcopy2,
		startcopy_withchilds2,
		startnodescripter2, 
		starteditor2,
		startnode2, 
		}
--5.2 menu of tree2 end

--5. context menus (menus for right mouse click) end


--6 buttons
--6.1 logo image definition and button with logo
img_logo = iup.image{
  { 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,3,3,1,1,3,3,3,1,1,1,1,1,3,1,1,1,3,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,3,3,1,1,3,1,1,3,1,1,1,1,3,1,1,3,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,3,3,3,3,1,1,1,1,1,3,1,1,3,1,1,1,1,3,1,3,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,3,3,3,4,4,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,3,3,3,3,4,4,3,3,1,1,1,3,1,1,1,3,1,1,1,3,1,3,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,3,3,3,3,3,3,3,3,1,1,1,3,1,1,1,3,1,1,1,3,1,1,3,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,3,3,3,3,3,3,3,3,1,1,1,3,3,3,3,1,1,3,1,3,1,1,1,3,1,3,1,1,4,4,4 }, 
  { 4,1,1,1,3,3,3,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,3,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,1,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,3,1,3,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,1,1,1,3,1,3,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,3,3,1,3,1,3,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,4,4,4,4,4,4,4,1,1,3,3,1,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,4,4,4,4,4,3,3,4,4,4,4,1,3,3,1,1,1,1,1,1,1,4,4,4,4 },
  { 4,1,1,1,1,1,1,1,4,4,4,4,3,3,3,3,3,3,4,4,4,3,1,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,4,4,4,4,4,3,3,3,3,3,3,3,3,3,4,3,4,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,1,1,1,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,1,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,4,4,4 }, 
  { 4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4 }, 
  { 4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4 },  
  { 4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4 },  
  { 4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3 },  
  { 4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 },  
  { 3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 },  
  { 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 }  
  ; colors = { color_grey_bpc, color_light_color_grey_bpc, color_blue_bpc, "255 255 255" }
}
button_logo=iup.button{image=img_logo,title="", size="23x20"}
function button_logo:action()
	iup.Message("Beckmann & Partner CONSULT","BERATUNGSMANUFAKTUR\nMeisenstraße 79\n33607 Bielefeld\nDr. Bruno Kaiser\nLizenz Open Source")
end --function button_logo:flat_action()

--6.2 button for saving tree
button_save_lua_table=iup.flatbutton{title="Baum speichern \n(als Text Strg+P)", size="95x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	save_tree_to_lua(tree, path .. "\\documentation_tree.lua")
end --function button_save_lua_table:flat_action()

--6.3 button for search in tree, tree2 and tree3
button_search=iup.flatbutton{title="Suchen\n(Strg+F)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
	searchtext.value=tree.title
	searchtext.SELECTION="ALL"
	dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_search:flat_action()

--6.4 button for replacing in tree
button_replace=iup.flatbutton{title="Suchen und Ersetzen\n(Strg+H)", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_replace:flat_action()
	searchtext_replace.value=tree.title
	replacetext_replace.SELECTION="ALL"
	dlg_search_replace:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_replace:flat_action()

--6.5 button for comparing text file of tree and text file of tree2
button_compare=iup.flatbutton{title="Textdateien vergleichen\n(Strg+T)", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_compare:flat_action()
	compareText=""
	if tree.TITLE:match(".:\\.*%.[^\\]+") and (tree2.title0:match(".:\\.*") .. tree2.TITLE):match(".:\\.*%.[^\\]+") then
		compare_files(tree.TITLE , tree2.title0:match(".:\\.*") .. tree2.TITLE)
		textfield1.value=compareText
	else
		textfield1.value="Kein Vergleich von " .. tree.TITLE .. " \nmit " .. tree2.title0:match(".:\\.*") .. tree2.TITLE
	end --if tree.TITLE:match(".:\\.*%.[^\\]+") and (tree2.title0:match(".:\\.*") .. tree2.TITLE):match(".:\\.*%.[^\\]+") then
end --function button_compare:flat_action()

--6.6 button to update tree2, mark non existing files in grey and copy node with path
button_copy_title=iup.flatbutton{title="Aktualisieren Arbeitsvorrat \nDateipfad in Zwischenablage", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_copy_title:flat_action()
	clipboard.text=tree2.title0:match(".:\\.*") .. tree2.title
	textfield1.value=tree2.title0:match(".:\\.*") .. tree2.title
	delete_nodes_of_tree(tree2)
	if file_exists(path .. "\\documentation_tree_script.lua") then
		dofile(path .. "\\documentation_tree_script.lua")
		tree_script=tree_script or {branchname="Nicht dokumentierte Dateien auf: " .. path, --copy with path
		}
	else
		tree_script={branchname="Nicht dokumentierte Dateien auf: " .. path, --copy with path
		}
		temp_folder_content=io.popen('"dir /b /s "' .. path ..'""') --execute command to obtain the current directory. /s can be left out, if the subdirectories should not be considered
		while true do
			local line = temp_folder_content:read("*line")
			if line == nil then break end
			tree_script[#tree_script+1]=line:sub(path:len()+1, -1)
		end --while true do
	end --if file_exists(path .. "\\documentation_tree_script.lua") then
	iup.TreeAddNodes(tree2, tree_script)
	--delete_nodes_2nd_arg(tree,tree2)
--[[
	for i=0, tree.count-1 do
		if file_exists(tree["TITLE" .. i]) then --existing files in black
			iup.TreeSetNodeAttributes(tree,i,{color="0 0 0",})
		elseif tree["TITLE" .. i]:match("\\[^\\]+%.[^\\]+$") then    --mark not existing files in grey
			iup.TreeSetNodeAttributes(tree,i,{color="200 200 150",})
		end --if file_exists(tree["TITLE" .. i]) then
	end --for i=0, tree.count-1 do
--]]
end --function button_copy_title:flat_action()

--6.7 button to edit in IUP Lua scripter the script for tree2
button_edit_treescript=iup.flatbutton{title="Programmieren des \nArbeitsvorrats", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_treescript:flat_action()
	os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. path .. '\\documentation_tree_script.lua"')
end --function button_edit_treescript:flat_action()

--6.8 button to update tree3
button_statisticsupdate=iup.flatbutton{title="Aktualisieren der \nOrdnerstatistik", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_statisticsupdate:flat_action()
	delete_nodes_of_tree(tree3)
	if file_exists(path .. "\\documentation_tree_statistics.lua") then
		dofile(path .. "\\documentation_tree_statistics.lua")
	else
		iup.Message("Es gibt keine Statistik","Es gibt keine Statistik")
	end --if file_exists(path .. "\\documentation_tree_script.lua") then
	iup.TreeAddNodes(tree3, tree_statistics)
end --function button_statisticsupdate:flat_action()

--6.9 button to edit in IUP Lua scripter the script for tree3
button_edit_treestatistics=iup.flatbutton{title="Programmieren der \nOrdnerstatistik", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_treestatistics:flat_action()
	os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. path .. '\\documentation_tree_statistics.lua"')
end --function button_edit_treestatistics:flat_action()

--6.10 button to delete files from tree2 if they are in tree
button_delete_files_from_tree2=iup.flatbutton{title="Löschen der Dateien\naus dem Arbeitsvorrat", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_delete_files_from_tree2:flat_action()
	delete_nodes_2nd_arg(tree,tree2)
end --function button_delete_files_from_tree2:flat_action()

--6.11 button to mark files from tree2 if they are in tree
button_mark_files_from_tree2=iup.flatbutton{title="Markieren der Dateien\naus dem Arbeitsvorrat", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_mark_files_from_tree2:flat_action()
	mark_nodes_2nd_arg(tree,tree2)
end --function button_mark_files_from_tree2:flat_action()

--6.12 button to check whether files exist
button_check_whether_files_exist=iup.flatbutton{title="Prüfung, ob die\nDateien existieren", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_check_whether_files_exist:flat_action()
	for i=0, tree.count-1 do
		if file_exists(tree["TITLE" .. i]) then --existing files in black
			iup.TreeSetNodeAttributes(tree,i,{color="0 0 0",})
		elseif tree["TITLE" .. i]:match("\\[^\\]+%.[^\\]+$") then    --mark not existing files in grey
			iup.TreeSetNodeAttributes(tree,i,{color="200 200 150",})
		end --if file_exists(tree["TITLE" .. i]) then
	end --for i=0, tree.count-1 do
end --function button_check_whether_files_exist:flat_action()

--6.13 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Beckmann & Partner CONSULT","BERATUNGSMANUFAKTUR\nMeisenstraße 79\n33607 Bielefeld\nDr. Bruno Kaiser\nLizenz Open Source")
end --function button_logo:flat_action()

--6 buttons end


--7 Main Dialog
--7.1 load tree from file
if file_exists(path_documentation_tree) then
	dofile(path_documentation_tree) --initialize the tree, read from the Lua file
	for line in io.lines(path_documentation_tree) do
		if line:match('=')~= nil then 
			tablename=line:sub(1,line:find('=')-1):gsub(' ', '')
			break
		end --if line:match('=')~= nil then 
	end --for line in io.lines(path_documentation_tree) do
	--save table in the variable actualtree
	--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
	if _VERSION=='Lua 5.1' then
		loadstring('actualtree='..tablename)()
	else
		load('actualtree='..tablename)() --now actualtree is the table.
	end --if _VERSION=='Lua 5.1' then
end --if file_exists(path_documentation_tree) then
tree=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree)
end, --function(self)
SIZE="400x200",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}
--set the background color of the tree
tree.BGCOLOR=color_background_tree
-- Callback of the right mouse button click
function tree:rightclick_cb(id)
	tree.value = id
	menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function tree:rightclick_cb(id)
-- Callback called when a node will be doubleclicked
function tree:executeleaf_cb(id)
	if tree['title' .. id]:match("^.:\\.*%.[^\\ ]+$") or tree['title' .. id]:match("^.:\\.*[^\\]+$") or tree['title' .. id]:match("^.:\\$") or tree['title' .. id]:match("^[^ ]*//[^ ]+$") then os.execute('start "d" "' .. tree['title' .. id] .. '"') end
end --function tree:executeleaf_cb(id)
-- Callback for pressed keys
function tree:k_any(c)
	if c == iup.K_DEL then
		-- do a totalchildcount of marked node. Then pop the table entries, which correspond to them.
		for j=0,tree.totalchildcount do
			--table.remove(attributes, tree.value+1)
		end --for j=0,tree.totalchildcount do
		tree.delnode = "MARKED"
	elseif c == iup.K_cP then -- added output of current table to a text file and dependencies to a csv file
		printtree()
		printdependencies()
	elseif c == iup.K_cT then -- compare text files of tree and tree2
		compareText=""
		if tree.TITLE:match(".:\\.*%.[^\\]+") and (tree2.title0:match(".:\\.*") .. tree2.TITLE):match(".:\\.*%.[^\\]+") then
			compare_files(tree.TITLE , tree2.title0:match(".:\\.*") .. tree2.TITLE)
			textfield1.value=compareText
		else
			textfield1.value="Kein Vergleich von " .. tree.TITLE .. " \nmit " .. tree2.title0:match(".:\\.*") .. tree2.TITLE
		end --if tree.TITLE:match(".:\\.*%.[^\\]+") and (tree2.title0:match(".:\\.*") .. tree2.TITLE):match(".:\\.*%.[^\\]+") then
	elseif c == iup.K_cF then
			searchtext.value=tree.title
			searchtext.SELECTION="ALL"
			dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_cH then
			searchtext_replace.value=tree.title
			replacetext_replace.SELECTION="ALL"
			dlg_search_replace:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_cD then
			printdependencies()
	elseif c == iup.K_Menu then
		menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function tree:k_any(c)

--7.2 load tree2 from file
if file_exists(path .. "\\documentation_tree_script.lua") then
dofile(path .. "\\documentation_tree_script.lua")
tree_script=tree_script or {branchname="Nicht dokumentierte Dateien auf: " .. path, --Verbesserung durch Pfadangabe
}
else
tree_script={branchname="Nicht dokumentierte Dateien auf: " .. path, --Verbesserung durch Pfadangabe
}
temp_folder_content=io.popen('"dir /b /s "' .. path ..'""') --execute command to obtain the current directory. /s can be left out, if the subdirectories should not be considered
while true do
	local line = temp_folder_content:read("*line")
	if line == nil then break end
	tree_script[#tree_script+1]=line:sub(path:len()+1, -1)
end --while true do
end --if file_exists(path .. "\\documentation_tree_script.lua") then
tree2=iup.tree{
map_cb=function(self)
self:AddNodes(tree_script)
end, --function(self)
showrename="YES",--F2 key active
markmode="MULTIPLE",--for Drag & Drop SINGLE not MULTIPLE
}
--set the background color of the tree
tree2.BGCOLOR=color_background_tree
-- Callback of the right mouse button click
function tree2:rightclick_cb(id)
	tree2.value = id
	menu2:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function tree2:rightclick_cb(id)
-- Callback called when a node will be doubleclicked
function tree2:executeleaf_cb(id)
	os.execute('start "d" "' .. tree2.title0:match(".:\\.*") .. tree2['title' .. id] .. '"')
end --function tree:executeleaf_cb(id)
-- Callback for pressed keys
function tree2:k_any(c)
	if c == iup.K_cF then
		searchtext.value=tree2.title
		searchtext.SELECTION="ALL"
		dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_cT then -- compare text files of tree and tree2
		compareText=""
		if tree.TITLE:match(".:\\.*%.[^\\]+") and (tree2.title0:match(".:\\.*") .. tree2.TITLE):match(".:\\.*%.[^\\]+") then
			compare_files(tree.TITLE , tree2.title0:match(".:\\.*") .. tree2.TITLE)
			textfield1.value=compareText
		else
			textfield1.value="Kein Vergleich von " .. tree.TITLE .. " \nmit " .. tree2.title0:match(".:\\.*") .. tree2.TITLE
		end --if tree.TITLE:match(".:\\.*%.[^\\]+") and (tree2.title0:match(".:\\.*") .. tree2.TITLE):match(".:\\.*%.[^\\]+") then
	elseif c == iup.K_Menu then
		menu2:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_cF then
end --function tree2:k_any(c)

--7.3 load tree3 from file
dofile(path .. "\\documentation_tree_statistics.lua")
tree3=iup.tree{
map_cb=function(self)
self:AddNodes(tree_statistics)
end, --function(self)
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
}
tree3.BGCOLOR=color_background_tree
-- Callback for pressed keys
function tree3:k_any(c)
	if c == iup.K_cF then
		searchtext.value=tree3.title:match("(.*):")
		searchtext.SELECTION="ALL"
		dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
	end --if c == iup.K_cF then
end --function tree3:k_any(c)

--7.4 preview field as scintilla editor
textfield1=iup.scintilla{}
textfield1.SIZE="440x120" --I think this is not optimal! (since the size is so appears to be fixed)
--textfield1.wordwrap="WORD" --enable wordwarp
textfield1.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
textfield1.FONT="Courier New, 8" --font of shown code
textfield1.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
textfield1.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
textfield1.STYLEFGCOLOR0="0 0 0"      -- 0-Default
textfield1.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
textfield1.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
textfield1.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
textfield1.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
textfield1.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
textfield1.STYLEFGCOLOR6="160 20 180"  -- 6-String 
textfield1.STYLEFGCOLOR7="128 0 0"    -- 7-Character
textfield1.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
textfield1.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
textfield1.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--textfield1.STYLEBOLD10="YES"
--textfield1.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--textfield1.STYLEITALIC10="YES"
textfield1.MARGINWIDTH0="40"
-- Callback for pressed keys
function textfield1:k_any(c)
	if c == iup.K_cF then
		searchtext.value=textfield1.value
		searchtext.SELECTION="ALL"
		dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
	end --if c == iup.K_cF then
end --function tree2:k_any(c)

--7.5 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	--simply show a box with buttons
	iup.vbox{
		--first row of buttons
		iup.hbox{
			button_logo,
			button_save_lua_table,
			button_search,
			button_replace,
			iup.label{size="10x",},
			button_compare,
			iup.label{size="10x",},
			button_copy_title,
			button_edit_treescript,
			iup.label{size="10x",},
			button_statisticsupdate,
			button_edit_treestatistics,
			iup.fill{},
			button_delete_files_from_tree2,
			button_mark_files_from_tree2,
			button_check_whether_files_exist,
			button_logo2,
		},
		
		iup.hbox{
			iup.frame{title="Manuelle Zuordnung als Baum",tree,},
			iup.frame{title="Arbeitsvorrat als Baum",tree2,},
			},
		iup.hbox{
			iup.frame{title="Vorschau und Text-Dateivergleich",textfield1,},
			iup.frame{title="Ordnerstatistik als Baum",tree3,},
			},

	},

	icon = img_logo,
	title = path .. " Documentation Tree",
	SIZE = 'FULLxFULL',
	BACKGROUND=color_background
}

--7.5.1 read plugins directory
pluginRegisterTable = pluginRegisterTable or {}
p=io.popen('dir "' .. path .. '\\documentation_tree_plugins\\*.lua" /b/o/s')
--test with: print(p)
print("Documentation Tree Plugins")
print(path .. "\\documentation_tree_plugins\\*.lua") 
for pluginFile in p:lines() do
	print(pluginFile)
	if pluginRegisterTable[pluginFile]==true then
		dofile(pluginFile)
	else
		print("Plugin " .. pluginFile .. " nicht registriert")
	end --if pluginRegisterTable[pluginFile]==true then
end --for pluginFile in p:lines() do

--7.5.1.1 show the dialog
maindlg:show()

--7.5.2 delete nodes in tree2 that are in tree and mark not existing files in grey (is possible only after having the GUI shown)
--delete_nodes_2nd_arg(tree,tree2)
--
--[[
for i=0, tree.count-1 do
	if file_exists(tree["TITLE" .. i]) then --existing files in black
		iup.TreeSetNodeAttributes(tree,i,{color="0 0 0",})
	elseif tree["TITLE" .. i]:match("\\[^\\]+%.[^\\]+$") then    --mark not existing files in grey
		iup.TreeSetNodeAttributes(tree,i,{color="200 200 150",})
	end --if file_exists(tree["TITLE" .. i]) then
end --for i=0, tree.count-1 do
--]]

--7.6 callback on close of the main dialog for saving or restoring
function maindlg:close_cb()
	EndeAlarm=iup.Alarm("Alarm","Wollen Sie den Baum speichern oder die Vorversion wiederherstellen?","Speichern","Wiederherstellen")
	if EndeAlarm==1 then 
		save_tree_to_lua(tree, path .. "\\documentation_tree.lua")
		iup.ExitLoop()
		maindlg:destroy()
		return iup.IGNORE
	elseif EndeAlarm==2 then
		timer1.run="NO"
		os.execute('copy "' .. path .. '\\Archiv\\documentation_tree' .. os.date("_%Y%m%d") .. '.lua" "' .. path_documentation_tree .. '"' )
		iup.ExitLoop()
		maindlg:destroy()
		return iup.IGNORE
	end --if EndeAlarm==1 then 
end --function maindlg:close_cb()

--7.7 Timer for autosave of tree
timer1=iup.timer{time=10000}
function timer1:action_cb()
	--test with: textfield1.value="Timer"
	save_tree_to_lua(tree, path .. "\\documentation_tree.lua")
end --function timer1:action_cb()
--turn timer on
timer1.run="YES"

--7.8 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then
