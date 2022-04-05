--This script runs a graphical user interface (GUI) in order to built up a documentation tree of the balance of an enterprise. It displays the tree saved in documentation_tree_balance.lua, the passive tree in documentation_tree_balance_passive.lua and the active tree stored in documentation_tree_balance_active.lua

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
	end --function os.execute(a)
end --do --sandboxing

--1.2 color section
--1.2.1 color of the console associated with the graphical user interface if started with lua54.exe and not wlua54.exe
os.execute('color 71')

--1.2.2 colors
color_red="135 131 28"
color_light_color_grey="96 197 199"
color_grey="162 163 165"
color_blue="18 132 86"

--1.2.3 color definitions
color_background=color_light_color_grey
color_buttons=color_blue -- works only for flat buttons
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
	if fileName=="documentation_tree_balance.lua"            then installTable[fileName]="Lua script" 
	elseif fileName=="documentation_tree_balance_passive.lua"     then installTable[fileName]="Lua script" 
	elseif fileName=="documentation_tree_balance_active.lua" then installTable[fileName]="Lua script" 
	elseif fileName=="documentation_tree_balance_indicators.lua" then installTable[fileName]="Lua script" 
	end --if fileName:lower()=="archiv" then
end --for fileName in p:lines() do


--2.1 install skript documentation_tree_balance.lua
documentation_tree_ProgrammText=[[

lua_tree_output={ branchname="Verzeichnisdokumentation", 
{ branchname="Verzeichnis-Dokumentation", 
state="COLLAPSED",
 "]] .. path:gsub("\\","\\\\") .. [[\\]] .. thisfilename .. [[", 
{ branchname="Baumdokumentationen Skripte", 
state="COLLAPSED",
 "]] .. path:gsub("\\","\\\\") .. [[\\documentation_tree_balance.lua", 
 "]] .. path:gsub("\\","\\\\") .. [[\\documentation_tree_balance_passive.lua", 
 "]] .. path:gsub("\\","\\\\") .. [[\\documentation_tree_balance_active.lua", 
 "]] .. path:gsub("\\","\\\\") .. [[\\documentation_tree_balance_indicators.lua", 
},
{ branchname="Baumdokumentationen Verzeichnisse", 
state="COLLAPSED",
 "]] .. path:gsub("\\","\\\\") .. [[", 
 "]] .. path:gsub("\\","\\\\") .. [[\\Archiv", 
},
},
}
]]
if installTable["documentation_tree_balance.lua"]==nil then 
	outputfile1=io.open(path .. "\\documentation_tree_balance.lua","w") 
	outputfile1:write(documentation_tree_ProgrammText)
	outputfile1:close()
end --if installTable["documentation_tree_balance.lua"]==nil then
--2.1 install skript documentation_tree_balance.lua end

--2.2 install skript documentation_tree_balance_passive.lua
documentation_tree_script_ProgrammText=[[





--Wertebaum auf der untersten Stufe mit Werten
WerteTree={branchname="Bilanzausschnitt Passiva ohne Eigenkapital", 
{branchname="Passiva Rückstellungen und Rücklagen",
{branchname="Rückstellungen",1000,},
{branchname="Rücklagen",32345,},
},
{branchname="Passiva Kredite",
{branchname="Kredite an Banken",600000,},
{branchname="Kredite an private Gläubiger",1112345,},
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
WerteTreeAnteile.branchname="Passivseitenübersicht mit Anteilen"

--Fertiger Wertebaum
tree_script={branchname="Passivseite ohne Eigenkapital" ,
--WerteTree,
WerteTreeAnsicht,
WerteTreeAnteile,
}






]]
if installTable["documentation_tree_balance_passive.lua"]==nil then 
	outputfile1=io.open(path .. "\\documentation_tree_balance_passive.lua","w") 
	outputfile1:write(documentation_tree_script_ProgrammText)
	outputfile1:close()
end --if installTable["documentation_tree_balance_passive.lua"]==nil then
--2.2 install skript documentation_tree_balance_passive.lua end

--2.3 install skript documentation_tree_balance_active.lua
documentation_tree_statistics_ProgrammText=[[





--Wertebaum auf der untersten Stufe mit Werten
WerteTree={branchname="Aktiva",
{branchname="Aktiva Waren",
{branchname="Fertigprodukte",1000000,},
{branchname="Halbfertigprodukte",1232345,},
},
{branchname="Aktiva flüssige Mittel",
{branchname="Guthaben bei Banken",100000,},
{branchname="Kasse",2345,},
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
WerteTreeAnteile.branchname="Aktivseitenübersicht mit Anteilen"

--Fertiger Wertebaum
tree_statistics={branchname="Aktivseite" ,
--WerteTree,
WerteTreeAnsicht,
WerteTreeAnteile,
}





]]
if installTable["documentation_tree_balance_active.lua"]==nil then 
	outputfile1=io.open(path .. "\\documentation_tree_balance_active.lua","w") 
	outputfile1:write(documentation_tree_statistics_ProgrammText)
	outputfile1:close()
end --if installTable["documentation_tree_balance_active.lua"]==nil then
--2.3 install skript documentation_tree_balance_active.lua end


--2.4 install skript documentation_tree_balance_indicators.lua
documentation_tree_statistics_ProgrammText=[[






Aktivseitensumme                   = tree3['title1']:match(": (%d[^ ]*%d)[^%d]*"):gsub("%.","")
Aktivseitensumme                   = tonumber(Aktivseitensumme)
Passivseitensumme_ohne_Eigenkapital= tree2['title1']:match(": (%d[^ ]*%d)[^%d]*"):gsub("%.","")
Passivseitensumme_ohne_Eigenkapital= tonumber(Passivseitensumme_ohne_Eigenkapital)
Eigenkapitalsumme                  = Aktivseitensumme -  Passivseitensumme_ohne_Eigenkapital
Eigenkapitalquote                  = Eigenkapitalsumme / Aktivseitensumme
textfield1.value="Eigenkapital: " .. Eigenkapitalsumme .. "\n" .. 
"Eigenkapitalquote: " .. Eigenkapitalquote .. "\n" .. 
"Weitere Bilanzkennzahlen abhängig von der Bilanzstruktur ermitteln..."




]]
if installTable["documentation_tree_balance_indicators.lua"]==nil then 
	outputfile1=io.open(path .. "\\documentation_tree_balance_indicators.lua","w") 
	outputfile1:write(documentation_tree_statistics_ProgrammText)
	outputfile1:close()
end --if installTable["documentation_tree_balance_indicators.lua"]==nil then
--2.4 install skript documentation_tree_balance_indicators.lua end

--test with (status before installment): for k,v in pairs(installTable) do print(k,v) end


--2.5 script for manual tree
path_documentation_tree= path .. "\\documentation_tree_balance.lua"

--2.5.1 search for valid tree
inputfile1=io.open(path .. "\\documentation_tree_balance.lua","r")
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


--3.2.2 function which saves the current iup tree as a Lua table
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

--3.2.3 function which deletes nodes in the second tree, if they occur in the tree of the first argument
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


--3.4 function to change expand/collapse relying on depth
--This function is needed in the expand/collapsed dialog. This function relies on the depth of the given level.
function change_state_level(new_state,level,descendants_also,tree)
	if descendants_also=="YES" then
		for i=0,tree.count-1 do
			if tree["depth" .. i]==level then
				iup.TreeSetNodeAttributes(tree,i,{state=new_state}) --changing the state of current node
				iup.TreeSetDescendantsAttributes(tree,i,{state=new_state})
			end --if tree["depth" .. i]==level then
		end --for i=0,tree.count-1 do
	else
		for i=0,tree.count-1 do
			if tree["depth" .. i]==level then
				iup.TreeSetNodeAttributes(tree,i,{state=new_state})
			end --if tree["depth" .. i]==level then
		end --for i=0,tree.count-1 do
	end --if descendants_also=="YES" then
end --function change_state_level(new_state,level,descendants_also,tree)


--3.5 function to change expand/collapse relying on keyword
--This function is needed in the expand/collapsed dialog. This function changes the state for all nodes, which match a keyword. Otherwise it works like change_stat_level.
function change_state_keyword(new_state,keyword,descendants_also,tree)
	if descendants_also=="YES" then
		for i=0,tree.count-1 do
			if tree["title" .. i]:match(keyword)~=nil then
				iup.TreeSetNodeAttributes(tree,i,{state=new_state})
				iup.TreeSetDescendantsAttributes(tree,i,{state=new_state})
			end --if tree["title" .. i]:match(keyword)~=nil then
		end --for i=0,tree.count-1 do
	else
		for i=0,tree.count-1 do
			if tree["title" .. i]:match(keyword)~=nil then
				iup.TreeSetNodeAttributes(tree,i,{state=new_state})
			end --if tree["title" .. i]:match(keyword)~=nil then 
		end --for i=0,tree.count-1 do
	end --if descendants_also=="YES" then
end --function change_state_keyword(new_state,level,descendants_also,tree)




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
	--TreeAusgabe.state="COLLAPSED"
	TreeAusgabe.branchname=TreeZurAnsicht.branchname:gsub(" +$","") .. ": " .. tostring(TreeZurAnsicht[1]):gsub("%.(%d+)",",%1 "):gsub("(%d?%d?%d)(%d%d%d,)","%1.%2"):gsub("(%d?%d?%d)(%d%d%d)$","%1.%2"):gsub("(%d?%d?%d)(%d%d%d%.)","%1.%2"):gsub("(%d?%d?%d)(%d%d%d%.)","%1.%2"):gsub("(%d?%d?%d)(%d%d%d%.)","%1.%2"):gsub("(%d?%d?%d)(%d%d%d%.)","%1.%2"):gsub(" $","")
	TreeAusgabe[1]=TreeZurAnsicht[1]
	for k,v in ipairs(TreeZurAnsicht) do
		if k>1 then TreeAusgabe[k]={} AnsichtRecursion(TreeZurAnsicht[k],TreeAusgabe[k]) end
	end --for k,v in ipairs(TreeZurAnsicht) do
end --function AnsichtRecursion(TreeZurAnsicht,TreeAusgabe)

--3.4.5 function to calculate the portions with the sums of the levels above
function AnteilRecursion(TreeAnteile,SummeTabelle,TreeAusgabe)
	--TreeAusgabe.state="COLLAPSED"
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
			iup.hbox{searchmark,unmark,}, 
			iup.label{title="rot: übergeordnete Knoten",fgcolor = "255 0 0", },
			iup.label{title="blau: gleicher Knoten",fgcolor = "0 0 255", },
			iup.label{title="grün: untergeordnete Knoten",fgcolor = "90 195 0", },
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

--4.4 expand and collapse dialog

--function needed for the expand and collapse dialog
function button_expand_collapse(new_state,tree)
	if toggle_level.value=="ON" then
		if checkbox_descendants_collapse.value=="ON" then
			change_state_level(new_state,tree.depth,"YES",tree)
			change_state_level(new_state,tree.depth,"YES",tree2)
			change_state_level(new_state,tree.depth,"YES",tree3)
		else
			change_state_level(new_state,tree.depth,"NO",tree)
			change_state_level(new_state,tree.depth,"NO",tree2)
			change_state_level(new_state,tree.depth,"NO",tree3)
		end --if checkbox_descendants_collapse.value="ON" then
	elseif toggle_keyword.value=="ON" then
		if checkbox_descendants_collapse.value=="ON" then
			change_state_keyword(new_state,text_expand_collapse.value,"YES",tree)
			change_state_keyword(new_state,text_expand_collapse.value,"YES",tree2)
			change_state_keyword(new_state,text_expand_collapse.value,"YES",tree3)
		else
			change_state_keyword(new_state,text_expand_collapse.value,"NO",tree)
			change_state_keyword(new_state,text_expand_collapse.value,"NO",tree2)
			change_state_keyword(new_state,text_expand_collapse.value,"NO",tree3)
		end --if checkbos_descendants_collapse.value=="ON" then
	end --if toggle_level.value="ON" then
end --function button_expand_collapse(new_state,tree)

--button for expanding branches
expand_button=iup.flatbutton{title="Ausklappen",size="EIGHTH",BGCOLOR=color_buttons,FGCOLOR=color_button_text}
function expand_button:flat_action()
	button_expand_collapse("EXPANDED",tree) --call above function with expand as new state
end --function expand_button:flat_action()

--button for collapsing branches
collapse_button=iup.flatbutton{title="Einklappen",size="EIGHTH",BGCOLOR=color_buttons,FGCOLOR=color_button_text}
function collapse_button:flat_action()
	button_expand_collapse("COLLAPSED",tree) --call above function with collapsed as new state
end --function collapse_button:flat_action()

--button for cancelling the dialog
cancel_expand_collapse_button=iup.flatbutton{title="Abbrechen",size="EIGHTH",BGCOLOR=color_buttons,FGCOLOR=color_button_text}
function cancel_expand_collapse_button:flat_action()
	return iup.CLOSE
end --function cancel_expand_collapse_button:flat_action()

--toggle if expand/collapse should be applied to current depth
toggle_level=iup.toggle{title="Nach aktueller Ebene", value="ON"}
function toggle_level:action()
	text_expand_collapse.active="NO"
end --function toggle_level:action()

--toggle if expand/collapse should be applied to search, i.e. to all nodes containing the text in the searchfield
toggle_keyword=iup.toggle{title="Nach Suchwort", value="OFF"}
function toggle_keyword:action()
	text_expand_collapse.active="YES"
end --function toggle_keyword:action()

--radiobutton for toggles, if search field or depth expand/collapse function
radio=iup.radio{iup.hbox{toggle_level,toggle_keyword},value=toggle_level}

--text field for expand/collapse
text_expand_collapse=iup.text{active="NO",expand="YES"}

--checkbox if descendants also be changed
checkbox_descendants_collapse=iup.toggle{title="Auf untergeordnete Knoten anwenden",value="ON"}

--put this together into a dialog
dlg_expand_collapse=iup.dialog{
	iup.vbox{
		iup.hbox{radio},
		iup.hbox{text_expand_collapse},
		iup.hbox{checkbox_descendants_collapse},
		iup.hbox{expand_button,collapse_button,cancel_expand_collapse_button},
	};
	defaultenter=expand_button,
	defaultesc=cancel_expand,
	title="Ein-/Ausklappen",
	size="QUARTER",
	startfocus=searchtext,

}

--4.4 expand and collapse dialog end

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
		--test with: for k,v in pairs(tree_temp) do print(k,v) end
		tree_temp={branchname=tree["title0"],tree_temp}
		iup.TreeAddNodes(tree,tree_temp)
	elseif numberCurlyBraketsBegin==numberCurlyBraketsEnd then
		load('tree_temp='..TreeText)() --now tree_temp is filled
		--test with: for k,v in pairs(tree_temp) do print(k,v) end
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


--5.1.8 start file of node of tree in IUP Lua scripter or start empty file in notepad or start empty scripter
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

--5.1.9 start the file or repository of the node of tree
startnode = iup.item {title = "Starten"}
function startnode:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "D" "' .. tree['title'] .. '"') 
	elseif tree['title']:match("sftp .*") then 
		os.execute(tree['title']) 
	end --if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
end --function startnode:action()

--5.1.10 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,
		startcopy_doubling,
		renamenode, 
		addbranch, 
		addbranch_fromclipboard, 
		addleaf,
		addleaf_fromclipboard,
		startversion, 
		startnodescripter,
		startnode, 
		}
--5.1 menu of tree end


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
  ; colors = { "255 255 255", color_light_color_grey, color_blue, "255 255 255" }
}
button_logo=iup.button{image=img_logo,title="", size="23x20"}
function button_logo:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de")
end --function button_logo:flat_action()

--6.2 button for saving tree
button_save_lua_table=iup.flatbutton{title="Baum speichern \n(als Text Strg+P)", size="95x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	save_tree_to_lua(tree, path .. "\\documentation_tree_balance.lua")
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


--6.5 button for expand and collapse
button_expand_collapse_dialog=iup.flatbutton{title="Ein-/Ausklappen\n(Strg+R)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_expand_collapse_dialog:flat_action()
	text_expand_collapse.value=tree.title
	dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_expand_collapse_dialog:flat_action()


--6.6 button to update tree2, mark non existing files in grey and copy node with path
button_copy_title=iup.flatbutton{title="Aktualisieren der Passivseite", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_copy_title:flat_action()
	--clipboard.text=tree2.title0:match(".:\\.*") .. tree2.title
	--textfield1.value=tree2.title0:match(".:\\.*") .. tree2.title
	delete_nodes_of_tree(tree2)
	if file_exists(path .. "\\documentation_tree_balance_passive.lua") then
		dofile(path .. "\\documentation_tree_balance_passive.lua")
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
	end --if file_exists(path .. "\\documentation_tree_balance_passive.lua") then
	iup.TreeAddNodes(tree2, tree_script)
end --function button_copy_title:flat_action()

--6.7 button to edit in IUP Lua scripter the script for tree2
button_edit_treescript=iup.flatbutton{title="Programmieren der \nPassivseite", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_treescript:flat_action()
	os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. path .. '\\documentation_tree_balance_passive.lua"')
end --function button_edit_treescript:flat_action()

--6.8 button to update tree3
button_statisticsupdate=iup.flatbutton{title="Aktualisieren der \nAktivseite", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_statisticsupdate:flat_action()
	delete_nodes_of_tree(tree3)
	if file_exists(path .. "\\documentation_tree_balance_active.lua") then
		dofile(path .. "\\documentation_tree_balance_active.lua")
	else
		iup.Message("Es gibt keine Statistik","Es gibt keine Statistik")
	end --if file_exists(path .. "\\documentation_tree_balance_passive.lua") then
	iup.TreeAddNodes(tree3, tree_statistics)
end --function button_statisticsupdate:flat_action()

--6.9 button to edit in IUP Lua scripter the script for tree3
button_edit_treestatistics=iup.flatbutton{title="Programmieren der \nAktivseite", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_treestatistics:flat_action()
	os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. path .. '\\documentation_tree_balance_active.lua"')
end --function button_edit_treestatistics:flat_action()


--6.10 button to update indicators
button_indicators_update=iup.flatbutton{title="Aktualisieren der \nKennzahlen", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_indicators_update:flat_action()
	if file_exists(path .. "\\documentation_tree_balance_indicators.lua") then
		dofile(path .. "\\documentation_tree_balance_indicators.lua")
	else
		iup.Message("Es gibt keine Statistik","Es gibt keine Statistik")
	end --if file_exists(path .. "\\documentation_tree_balance_passive.lua") then
end --function button_indicators_update:flat_action()

--6.11 button to edit in IUP Lua scripter the script for indicators
button_indicators_edit=iup.flatbutton{title="Programmieren der \nKennzahlen", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_indicators_edit:flat_action()
	os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. path .. '\\documentation_tree_balance_indicators.lua"')
end --function button_indicators_edit:flat_action()

--6.12 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de")
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
SIZE="400x10",
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
if file_exists(path .. "\\documentation_tree_balance_passive.lua") then
dofile(path .. "\\documentation_tree_balance_passive.lua")
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
end --if file_exists(path .. "\\documentation_tree_balance_passive.lua") then
tree2=iup.tree{
map_cb=function(self)
self:AddNodes(tree_script)
end, --function(self)
SIZE="400x400",
showrename="YES",--F2 key active
markmode="MULTIPLE",--for Drag & Drop SINGLE not MULTIPLE
}
--set the background color of the tree
tree2.BGCOLOR=color_background_tree
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
	end --if c == iup.K_cF then
end --function tree2:k_any(c)

--7.3 load tree3 from file
dofile(path .. "\\documentation_tree_balance_active.lua")
tree3=iup.tree{
map_cb=function(self)
self:AddNodes(tree_statistics)
end, --function(self)
SIZE="550x400",
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
			button_expand_collapse_dialog,
			iup.label{size="10x",},
			button_statisticsupdate,
			button_edit_treestatistics,
			iup.fill{},
			button_copy_title,
			button_edit_treescript,
			button_indicators_update,
			button_indicators_edit,
			iup.label{size="10x",},
			button_logo2,
		},
		
		iup.hbox{
		iup.vbox{
			iup.frame{title="Aktivseite als Baum",tree3,},
			iup.frame{title="Dateienstruktur als Baum",tree,},
			},
		iup.vbox{
			iup.frame{title="Passivseite ohne Eigenkapital als Baum",tree2,},
			iup.frame{title="Eigenkapital und Bilanzkennzahlen",textfield1,},
			},
			},

	},

	icon = img_logo,
	title = path .. " Documentation Tree",
	SIZE = 'FULLxFULL',
	BACKGROUND=color_background
}



--7.5.1 show the dialog
maindlg:show()

--7.5.2 build indicators with the execution of an individual script
dofile(path .. "\\documentation_tree_balance_indicators.lua")

--7.6 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then
