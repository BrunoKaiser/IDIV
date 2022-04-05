lua_tree_output={ branchname="example of a reflexive tree", 
{ branchname="Ordner für Lua", 
{ branchname="C:\\Lua", 
state="COLLAPSED",
},
{ branchname="Ordner Temp", 
{ branchname="C:\\Temp", 
state="COLLAPSED",
},
},
{ branchname="Ordner Tree", 
 "C:\\Tree",
{ branchname="Unterordner", 
{ branchname="C:\\Tree\\reflexiveDocTree", 
 "E:\\Tree\\reflexiveDocTree",}}}}}--lua_tree_output





----[====[This programm has webpages within the Lua script which can contain a tree in html


--1. basic data


--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs


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
		a:lower():match("^move ") or
		a:lower():match("^copy ") or
		a:lower():match("^color ") or
		a:lower():match("^start ") or
		a:lower():match("^cls") 
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


--2. path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)

--3. functions
--3.1 simplified version of table.move for Lua 5.1 and Lua 5.2 that is enough for using of table.move here
if _VERSION=='Lua 5.1' or _VERSION=='Lua 5.2' then
	function table.move(a,f,e,t)
	for i=f,e do
		local j=i-f
		a[t+j]=a[i]
	end --for i=f,e do
	return a 
	end --function table.move(a,f,e,t)
end --if _VERSION=='Lua 5.1' then

--3.2 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--3.3 function which saves the current iup tree as a Lua table
function save_reflexive_tree_to_lua(outputfile_path)
	--read the programm of the file itself, commentSymbol is used to have another pattern here as searched
	inputfile=io.open(path .. "\\" .. thisfilename,"r")
	commentSymbol,inputTextProgramm=inputfile:read("*a"):match("lua_tree_output={.*}(%-%-)lua_tree_output(.*)")
	inputfile:close()
	--save the tree
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
	outputfile:write(output_tree_text .. "--lua_tree_output") --write everything into the outputfile
	--write the programm for the data in itself
	outputfile:write(inputTextProgramm)
	outputfile:close()
end --function save_reflexive_tree_to_lua(outputfile_path)

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
	--unmark all nodes end
	--mark all nodes
	for i=0, tree.count - 1 do
		if tree["title" .. i]:upper():match(searchtext.value:upper())~= nil then
			iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
		end --if tree["title" .. i]:upper():match(searchtext.value:upper())~= nil then
	end --for i=0, tree.count - 1 do
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
end --function searchmark:flat_action()

--unmark without leaving the search-window
unmark    = iup.flatbutton{title = "Entmarkieren",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function unmark:flat_action()
--unmark all nodes
for i=0, tree.count - 1 do
	tree["color" .. i]="0 0 0"
end --for i=0, tree.count - 1 do
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
end --function searchup:flat_action()

checkboxforcasesensitive = iup.toggle{title="Groß-/Kleinschreibung", value="OFF"} --checkbox for casesensitiv search
checkboxforsearchinfiles = iup.toggle{title="Suche in den Textdateien", value="OFF"} --checkbox for searcg in text files
search_label=iup.label{title="Suchfeld:"} --label for textfield


--put above together in a search dialog
dlg_search =iup.dialog{
			iup.vbox{iup.hbox{search_label,searchtext,}, 

			iup.label{title="Sonderzeichen: %. für ., %- für -, %+ für +, %% für %, %[ für [, %] für ], %( für (, %) für ), %^ für ^, %$ für $, %? für ?",},
			iup.hbox{searchmark,unmark,checkboxforsearchinfiles,}, 
			iup.label{title="rot: übergeordnete Knoten",fgcolor = "255 0 0", },
			iup.label{title="blau: gleicher Knoten",fgcolor = "0 0 255", },
			iup.label{title="grün: untergeordnete Knoten",fgcolor = "90 195 0", },
			iup.hbox{searchdown, searchup,checkboxforcasesensitive,},

			}; 
		title="Suchen",
		size="420x100",
		startfocus=searchtext
		}

--4.2 search dialog end


--5. context menus (menus for right mouse click)

--5.1 menu of tree
--5.1.1 copy node of tree
startcopy = iup.item {title = "Knoten kopieren"}
function startcopy:action() --copy node
	 clipboard.text = tree['title']
end --function startcopy:action()

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

--5.1.3.1 add branch to tree by insertbranch
addbranchbottom = iup.item {title = "Ast darunter hinzufügen"}
function addbranchbottom:action()
	tree["insertbranch" .. tree.value] = ""
	for i=tree.value+1,tree.count-1 do
		if tree["depth" .. i]==tree["depth" .. tree.value] then
			tree.value=i
			renamenode:action()
			break
		end --if tree["depth" .. i]==tree["depth" .. tree.value] then
	end --for i=tree.value+1,tree.count-1 do
end --function addbranchbottom:action()

--5.1.3.2 add leaf to tree by insertleaf
addleafbottom = iup.item {title = "Blatt darunter hinzufügen"}
function addleafbottom:action()
	tree["insertleaf" .. tree.value] = ""
	for i=tree.value+1,tree.count-1 do
		if tree["depth" .. i]==tree["depth" .. tree.value] then
			tree.value=i
			renamenode:action()
			break
		end --if tree["depth" .. tree.value+1]==tree["depth" .. tree.value] then
	end --for i=tree.value+1,tree.count-1 do
end --function addleafbottom:action()

--5.1.4 add branch of tree from clipboard
addbranch_fromclipboard = iup.item {title = "Ast aus Zwischenablage"}
function addbranch_fromclipboard:action()
	tree.addbranch = clipboard.text
	tree.value=tree.value+1
end --function addbranch_fromclipboard:action()

--5.1.4.1 add branch to tree by insertbranch from clipboard
addbranch_fromclipboardbottom = iup.item {title = "Ast darunter aus Zwischenablage"}
function addbranch_fromclipboardbottom:action()
	tree["insertbranch" .. tree.value]= clipboard.text
	for i=tree.value+1,tree.count-1 do
		if tree["depth" .. i]==tree["depth" .. tree.value] then
			tree.value=i
			break
		end --if tree["depth" .. i]==tree["depth" .. tree.value] then
	end --for i=tree.value+1,tree.count-1 do
end --function addbranch_fromclipboardbottom:action()

--5.1.4.2 add leaf to tree by insertleaf from clipboard
addleaf_fromclipboardbottom = iup.item {title = "Blatt darunter aus Zwischenablage"}
function addleaf_fromclipboardbottom:action()
	tree["insertleaf" .. tree.value] = clipboard.text
	for i=tree.value+1,tree.count-1 do
	if tree["depth" .. i]==tree["depth" .. tree.value] then
		tree.value=i
		break
	end --if tree["depth" .. tree.value+1]==tree["depth" .. tree.value] then
	end --for i=tree.value+1,tree.count-1 do
end --function addleaf_fromclipboardbottom:action()

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
startversion = iup.item {title = "Version Archivieren"}
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

--5.1.8.1 menu for building tree from start directory without versions
menu_start_directory_without_versions = iup.item {title = "Ursprungsordner ohne Versionen laden"}
function menu_start_directory_without_versions:action()
	button_start_directory_without_versions:flat_action()
end --function menu_start_directory_without_versions:action()

--5.1.8.2 menu for building tree from new directory
menu_new_directory = iup.item {title = "Zielordner laden"}
function menu_new_directory:action()
	button_new_directory:flat_action()
end --function menu_new_directory:action()

--5.1.8.3 menu for building tree from new directory without versions
menu_new_directory_without_versions = iup.item {title = "Zielordner ohne Versionen laden"}
function menu_new_directory_without_versions:action()
	button_new_directory_without_versions:flat_action()
end --function menu_new_directory_without_versions:action()

--5.1.9 menu for making new directory from selected node
make_directory = iup.item {title = "Ordner anlegen"}
function make_directory:action()
	if tree['title']:match("^.:\\") then
		os.execute('md "' .. tree['title'] .. '"')
	end --if tree['title']:match("^.:\\") then
end --function make_directory:action()

--5.1.10 start the file or repository of the node of tree
startnode = iup.item {title = "Starten"}
function startnode:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then os.execute('start "D" "' .. tree['title'] .. '"') end
end --function startnode:action()

--5.1.11 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,
		renamenode, 
		addbranch, 
		addbranchbottom, 
		addbranch_fromclipboard, 
		addbranch_fromclipboardbottom, 
		addleaf,
		addleafbottom,
		addleaf_fromclipboard,
		addleaf_fromclipboardbottom,
		startversion,
		menu_start_directory_without_versions, 
		menu_new_directory, 
		menu_new_directory_without_versions, 
		make_directory, 
		startnode, 
		}
--5.1 menu of tree end

--5.2 menu of tree1

--5.2.1 copy node of tree1
startcopy1 = iup.item {title = "Knoten kopieren"}
function startcopy1:action() --copy node
	local repositoryName=""
	for i=0,tree1.count-1 do
		if tree1["title" .. i]:match(".:\\.*") then
			repositoryName=tree1["title" .. i]:match(".:\\.*")
		end --if tree1["title" .. i]:match(".:\\.*") then
	end --for i=0,tree1.count-1 do
	if tree1['title']:match("%d%d.%d%d.%d%d%d%d.*") then
		clipboard.text=(repositoryName .. "\\" .. tree1['title']:match("%d%d.%d%d.%d%d%d%d.*"):sub(37)):gsub("\\\\","\\")
	else
		clipboard.text=(repositoryName .. "\\" .. tree1['title']:sub(37)):gsub("\\\\","\\")
	end --if tree1['title']:match("%d%d.%d%d.%d%d%d%d.*") then
end --function startcopy1:action() 

--5.2.2 move a version of the file selected in the tree1 and give it the next version number
startversionmove = iup.item {title = "Version umbenennen und archivieren"}
function startversionmove:action()
	--get the version of the file
	if tree1['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+") and tree1['title']:match("<DIR>")==nil then
		Version=0
		p=io.popen('dir "' .. textbox1.value .. "\\" .. tree1['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+"):sub(37):gsub("(%.+)","_Version*%1") .. '" /b/o')
		for Datei in p:lines() do 
			--test with: iup.Message("Version",Datei) 
			if Datei:match("_Version(%d+)") then Version_alt=Version Version=tonumber(Datei:match("_Version(%d+)")) if Version<Version_alt then Version=Version_alt end end
			--test with: iup.Message("Version",Version) 
		end --for Datei in p:lines() do 
		--test with: iup.Message(Version,Version+1)
		Version=Version+1
		iup.Message("Archivieren und Umbenennen der Version:",tree1['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+"):sub(37):gsub("(%.+)","_Version" .. Version .. "%1"))
		os.execute('move "' .. textbox1.value .. "\\" .. tree1['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+"):sub(37) .. '" "' .. textbox1.value .. "\\" .. tree1['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+"):sub(37):gsub("(%.+)","_Version" .. Version .. "%1") .. '"')
		--test with: print('move "' .. textbox1.value .. "\\" .. tree1['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+"):sub(37) .. '" "' .. textbox1.value .. "\\" .. tree1['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+"):sub(37):gsub("(%.+)","_Version" .. Version .. "%1") .. '"')
	end --if tree1['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+") and tree1['title']:match("<DIR>")==nil then
end --function startversionmove:action()

--5.2.3 start the file or repository of the node of tree
startnode1 = iup.item {title = "Starten"}
function startnode1:action() 
	if tree1['title']:match("%.[^\\ ]+$") then 
		os.execute('start "D" "' .. textbox1.value .. "\\" .. tree1['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+"):sub(37) .. '"') 
	end --if tree1['title']:match("%.[^\\ ]+$") then 
end --function startnode1:action()

--5.2.4 put the menu items together in the menu for tree
menu1 = iup.menu{
		startcopy1, 
		startversionmove, 
		startnode1, 
		}
--5.2 menu of tree1 end

--5.3 menu of tree2

--5.3.1 copy node of tree2
startcopy2 = iup.item {title = "Knoten kopieren"}
function startcopy2:action() --copy node
	local repositoryName=""
	for i=0,tree2.count-1 do
		if tree2["title" .. i]:match(".:\\.*") then
			repositoryName=tree2["title" .. i]:match(".:\\.*")
		end --if tree2["title" .. i]:match(".:\\.*") then
	end --for i=0,tree2.count-1 do
	if tree2['title']:match("%d%d.%d%d.%d%d%d%d.*") then
		clipboard.text=(repositoryName .. "\\" .. tree2['title']:match("%d%d.%d%d.%d%d%d%d.*"):sub(37)):gsub("\\\\","\\")
	else
		clipboard.text=(repositoryName .. "\\" .. tree2['title']:sub(37)):gsub("\\\\","\\")
	end --if tree2['title']:match("%d%d.%d%d.%d%d%d%d.*") then
end --function startcopy2:action() 

--5.3.2 pick file selected in the tree2
startpickfile = iup.item {title = "Datei auswählen"}
function startpickfile:action()
	if tree2['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+") and tree2['title']:match("<DIR>")==nil then
		pickedFileName=tree2['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+"):sub(37)
		--test with: iup.Message("Datei ausgewählt",pickedFile)
	end --if tree1['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+") and tree1['title']:match("<DIR>")==nil then
end --function startpickfile:action()

--5.3.3 pick file selected in the tree2 and copy it in goal directory with versioning
startpickfile_and_copy_to_goal = iup.item {title = "Datei mit Versionskopie in Zielordner einfügen"}
function startpickfile_and_copy_to_goal:action()
	if tree2['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+") and tree2['title']:match("<DIR>")==nil then
		pickedFileName=tree2['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+"):sub(37)
		--test with: iup.Message("Datei ausgewählt",pickedFile)
	end --if tree1['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+") and tree1['title']:match("<DIR>")==nil then
	button_version_move_copy_and_paste:flat_action()
	button_compare:flat_action()
end --function startpickfile_and_copy_to_goal:action()

--5.3.4 start the file or repository of the node of tree
startnode2 = iup.item {title = "Starten"}
function startnode2:action() 
	if tree2['title']:match("%.[^\\ ]+$") then 
		os.execute('start "D" "' .. textbox2.value .. "\\" .. tree2['title']:match("%d%d.%d%d.%d%d%d%d.+%.[^ ]+"):sub(37) .. '"') 
	end --if tree2['title']:match("%.[^\\ ]+$") then 
end --function startnode2:action()

--5.3.5 put the menu items together in the menu for tree
menu2 = iup.menu{
		startcopy2, 
		startpickfile_and_copy_to_goal, 
		startpickfile, 
		startnode2, 
		}
--5.3 menu of tree1 end



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
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,1,3,1,3,1,3,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,3,3,1,3,1,3,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,4,4,4,4,4,4,4,1,1,3,3,1,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,4,4,4,4,4,3,3,4,4,4,4,1,3,3,1,1,1,1,1,1,1,4,4,4,4 },
  { 4,1,1,1,1,1,1,1,4,4,4,4,3,3,3,3,3,3,4,4,4,3,1,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,4,4,4,4,4,3,3,3,3,3,3,3,3,3,4,3,4,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,1,1,1,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,1,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,3,3,1,4,4,4 }, 
  { 4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4 }, 
  { 4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4 },  
  { 4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,3 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,3,4 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,4,4 },  
  { 3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,4,4,4,4,4 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4 }  
  ; colors = { "255 255 255", color_light_color_grey, color_blue, "255 255 255" }
}
button_logo=iup.button{image=img_logo,title="", size="23x20"}
function button_logo:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de")
end --function button_logo:flat_action()

--6.2 button for saving tree reflexive with the programm
button_save_lua_table=iup.flatbutton{title="Datei speichern", size="70x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	save_reflexive_tree_to_lua(path .. "\\" .. thisfilename)
end --function button_save_lua_table:flat_action()


--6.3 button for search in tree
button_search=iup.flatbutton{title="Suchen\n(Strg+F)", size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
	searchtext.value=tree.title
	searchtext.SELECTION="ALL"
	dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_search:flat_action(

--6.4 button for building tree with new directory
button_new_directory = iup.flatbutton{title = "Zielordner \nladen",size="50x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_new_directory:flat_action()
	tree1.delnode0 = "CHILDREN"
	tree1.title=''
	p=io.popen('dir "' .. tree['title'] .. '"')
	explorerTree={branchname="Ordnerinhalt"}
	local fileTable={}
	local directoryTable={}
	local directoryInformationTable={}
	for line in p:lines() do 
		if line:match("^%d%d.%d%d.%d%d%d%d") and line:match("<DIR>")==nil then
			fileTable[#fileTable+1]=line:gsub("„","ä"):gsub("ÿ"," ")
		elseif line:match("^%d%d.%d%d.%d%d%d%d") and line:match("<DIR>") then
			directoryTable[#directoryTable+1]=line:gsub("„","ä"):gsub("ÿ"," ")
		elseif line:match("%(") or line:match(":\\") then
			directoryInformationTable[#directoryInformationTable+1]=line:gsub("„","ä"):gsub("ÿ"," ")
		end --if line:match("^%d%d.%d%d.%d%d%d%d") and line:match("<DIR>")==nil then
	end --for line in p:lines() do 
	for k,v in pairs(directoryInformationTable) do
		explorerTree[#explorerTree+1]={branchname=v}
	end --for k,v in pairs(fileTable) do
	table.sort(fileTable,function(a,b) local aSort=a:sub(37):lower() bSort=b:sub(37):lower() return aSort<bSort end) 
	for k,v in pairs(fileTable) do
		explorerTree[#explorerTree+1]=k .. ": " .. string.rep(" ",math.max(4-#tostring(k),0)) .. v
	end --for k,v in pairs(fileTable) do
	for k,v in pairs(directoryTable) do
		explorerTree[#explorerTree+1]={branchname=k .. ": " .. string.rep(" ",math.max(4-#tostring(k),0)) .. v}
	end --for k,v in pairs(directoryTable) do
	iup.TreeAddNodes(tree1, explorerTree)
	--for search of file use only directory name
	if tree['title']:match(".*\\[^\\]+%.[^\\]+$") then 
		textbox1.value=tree['title']:match("(.*)\\[^\\]+%.[^\\]+$")
	else
		textbox1.value=tree['title']
	end --if textbox1.value==tree['title']:match(".*\\[^\\]+%.[^\\]+$") then
end --function button_new_directory:action()


--6.4.1 button for building tree with new directory without versions
button_new_directory_without_versions = iup.flatbutton{title = "Zielordner ohne \nVersionen laden",size="70x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_new_directory_without_versions:flat_action()
	tree1.delnode0 = "CHILDREN"
	tree1.title=''
	p=io.popen('dir "' .. tree['title'] .. '"')
	explorerTree={branchname="Ordnerinhalt"}
	local fileTable={}
	local directoryTable={}
	local directoryInformationTable={}
	for line in p:lines() do 
		if line:match("^%d%d.%d%d.%d%d%d%d") and line:match("<DIR>")==nil and line:match("_Version%d+")==nil and line:sub(37,37)~="." then
			fileTable[#fileTable+1]=line:gsub("„","ä"):gsub("ÿ"," ")
		elseif line:match("^%d%d.%d%d.%d%d%d%d") and line:match("<DIR>") then
			directoryTable[#directoryTable+1]=line:gsub("„","ä"):gsub("ÿ"," ")
		elseif line:match("%(") or line:match(":\\") then
			directoryInformationTable[#directoryInformationTable+1]=line:gsub("„","ä"):gsub("ÿ"," ")
		end --if line:match("^%d%d.%d%d.%d%d%d%d") and line:match("<DIR>")==nil and line:match("_Version%d+")==nil and line:sub(37,37)~="." then
	end --for line in p:lines() do 
	for k,v in pairs(directoryInformationTable) do
		explorerTree[#explorerTree+1]={branchname=v}
	end --for k,v in pairs(fileTable) do
	table.sort(fileTable,function(a,b) local aSort=a:sub(37):lower() bSort=b:sub(37):lower() return aSort<bSort end) 
	for k,v in pairs(fileTable) do
		explorerTree[#explorerTree+1]=k .. ": " .. string.rep(" ",math.max(4-#tostring(k),0)) .. v
	end --for k,v in pairs(fileTable) do
	for k,v in pairs(directoryTable) do
		explorerTree[#explorerTree+1]={branchname=k .. ": " .. string.rep(" ",math.max(4-#tostring(k),0)) .. v}
	end --for k,v in pairs(directoryTable) do
	iup.TreeAddNodes(tree1, explorerTree)
	--for search of file use only directory name
	if tree['title']:match(".*\\[^\\]+%.[^\\]+$") then
		textbox1.value=tree['title']:match("(.*)\\[^\\]+%.[^\\]+$")
	else
		textbox1.value=tree['title']
	end --if textbox1.value==tree['title']:match(".*\\[^\\]+%.[^\\]+$") then
end --function button_new_directory_without_versions:action()

--6.4.2 button for building tree with start directory without versions
button_start_directory_without_versions = iup.flatbutton{title = "Ursprungsordner ohne \nVersionen laden",size="90x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_start_directory_without_versions:flat_action()
	tree2.delnode0 = "CHILDREN"
	tree2.title=''
	p=io.popen('dir "' .. tree['title'] .. '"')
	explorerTree={branchname="Ordnerinhalt"}
	local fileTable={}
	local directoryTable={}
	local directoryInformationTable={}
	for line in p:lines() do 
		if line:match("^%d%d.%d%d.%d%d%d%d") and line:match("<DIR>")==nil and line:match("_Version%d+")==nil and line:sub(37,37)~="." then
			fileTable[#fileTable+1]=line:gsub("„","ä"):gsub("ÿ"," ")
		elseif line:match("^%d%d.%d%d.%d%d%d%d") and line:match("<DIR>") then
			directoryTable[#directoryTable+1]=line:gsub("„","ä"):gsub("ÿ"," ")
		elseif line:match("%(") or line:match(":\\") then
			directoryInformationTable[#directoryInformationTable+1]=line:gsub("„","ä"):gsub("ÿ"," ")
		end --if line:match("^%d%d.%d%d.%d%d%d%d") and line:match("<DIR>")==nil and line:match("_Version%d+")==nil and line:sub(37,37)~="." then
	end --for line in p:lines() do 
	for k,v in pairs(directoryInformationTable) do
		explorerTree[#explorerTree+1]={branchname=v}
	end --for k,v in pairs(fileTable) do
	table.sort(fileTable,function(a,b) local aSort=a:sub(37):lower() bSort=b:sub(37):lower() return aSort<bSort end) 
	for k,v in pairs(fileTable) do
		explorerTree[#explorerTree+1]=k .. ": " .. string.rep(" ",math.max(4-#tostring(k),0)) .. v
	end --for k,v in pairs(fileTable) do
	for k,v in pairs(directoryTable) do
		explorerTree[#explorerTree+1]={branchname=k .. ": " .. string.rep(" ",math.max(4-#tostring(k),0)) .. v}
	end --for k,v in pairs(directoryTable) do
	iup.TreeAddNodes(tree2, explorerTree)
	--for search of file use only directory name
	if tree['title']:match(".*\\[^\\]+%.[^\\]+$") then
		textbox2.value=tree['title']:match("(.*)\\[^\\]+%.[^\\]+$")
	else
		textbox2.value=tree['title']
	end --if textbox2.value==tree['title']:match(".*\\[^\\]+%.[^\\]+$") then
end --function button_start_directory_without_versions:action()

--6.5 button paste file picked
button_version_move_copy_and_paste = iup.flatbutton{title = "Datei in Ziel-\nordner einfügen",size="70x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_version_move_copy_and_paste:flat_action()
	local new_directory=textbox1.value 
	if pickedFileName and textbox2.value~=textbox1.value and textbox2.value:match("^.:\\") and textbox1.value:match("^.:\\") then
		Version=0
		p=io.popen('dir "' .. textbox1.value .. "\\" .. pickedFileName:gsub("(%.+)","_Version*%1") .. '" /b/o')
		for Datei in p:lines() do 
			--test with: iup.Message("Version",Datei) 
			if Datei:match("_Version(%d+)") then Version_alt=Version Version=tonumber(Datei:match("_Version(%d+)")) if Version<Version_alt then Version=Version_alt end end
			--test with: iup.Message("Version",Version) 
		end --for Datei in p:lines() do 
		--test with: iup.Message(Version,Version+1)
		Version=Version+1
		iup.Message("Archivieren und Umbenennen der Version:",pickedFileName:gsub("(%.+)","_Version" .. Version .. "%1"))
		os.execute('move "' .. textbox1.value .. "\\" .. pickedFileName .. '" "' .. textbox1.value .. "\\" .. pickedFileName:gsub("(%.+)","_Version" .. Version .. "%1") .. '"')
		os.execute('copy "' .. textbox2.value .. "\\" .. pickedFileName .. '" "' .. textbox1.value .. "\\" .. pickedFileName .. '"')
		--test with: print('copy "' .. textbox2.value .. "\\" .. pickedFileName .. '" "' .. textbox1.value .. "\\" .. pickedFileName .. '"')
	else
		iup.Message("Keine Datei ausgewählt","oder Verzeichnisse gleich.")
	end --if pickedFileName then
	textbox1.value=new_directory
	for i=1, tree.count-1 do
		if tree['title' .. i]==textbox1.value then
			tree.value=i
		end --if tree['title' .. i]==textbox1.value then
	end --for i=numberOfNode, tree.count-1 do
	button_new_directory_without_versions:flat_action()
end --function button_version_move_copy_and_paste:action()

--6.6 button for copy and paste all missing files in goal directory
button_missing_copy_and_paste = iup.flatbutton{title = "Fehlende Dateien im \nZielordner ergänzen",size="90x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_missing_copy_and_paste:flat_action()
	local new_directory=textbox1.value 
	local files1Table={}
	p=io.popen('dir "' .. textbox1.value .. '\\*.*" /b/o')
	for Datei in p:lines() do 
		if Datei:match("_Version(%d+)")==nil then 
			files1Table[Datei]=true
		end --if Datei:match("_Version(%d+)")==nil then 
	end --for Datei in p:lines() do 
	p=io.popen('dir "' .. textbox2.value .. '\\*.*" /b/o')
	for Datei in p:lines() do 
		if Datei:match("%.[^%.]+") and Datei:match("_Version(%d+)")==nil and files1Table[Datei]==nil and textbox2.value~=textbox1.value and textbox2.value:match("^.:\\") and textbox1.value:match("^.:\\") then 
			os.execute('copy "' .. textbox2.value .. "\\" .. Datei .. '" "' .. textbox1.value .. "\\" .. Datei .. '"')
			--test with: print('copy "' .. textbox2.value .. "\\" .. Datei .. '" "' .. textbox1.value .. "\\" .. Datei .. '"')
		end --if Datei:match("_Version(%d+)")==nil then 
	end --for Datei in p:lines() do 
	textbox1.value=new_directory
	for i=1, tree.count-1 do
		if tree['title' .. i]==textbox1.value then
			tree.value=i
		end --if tree['title' .. i]==textbox1.value then
	end --for i=numberOfNode, tree.count-1 do
	button_new_directory_without_versions:flat_action()
end --function button_missing_copy_and_paste:action()

--6.7 button exchange start and new directory
button_exchange_start_and_new_directory = iup.flatbutton{title = "Start- und \nZielordner tauschen",size="90x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_exchange_start_and_new_directory:flat_action()
	local new_directory=textbox2.value 
	local start_directory=textbox1.value 
	textbox1.value=new_directory
	for i=1, tree.count-1 do
		if tree['title' .. i]==textbox1.value then
			tree.value=i
		end --if tree['title' .. i]==textbox1.value then
	end --for i=numberOfNode, tree.count-1 do
	button_new_directory_without_versions:flat_action()
	textbox2.value=start_directory
	for i=1, tree.count-1 do
		if tree['title' .. i]==textbox2.value then
			tree.value=i
		end --if tree['title' .. i]==textbox2.value then
	end --for i=numberOfNode, tree.count-1 do
	button_start_directory_without_versions:flat_action()
end --function button_exchange_start_and_new_directory:action()

--6.8 button for comparing text file of tree and text file of tree2
button_compare=iup.flatbutton{title="Ordner vergleichen", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_compare:flat_action()
	--make the comparison
	--go through tree 1
	local file1existsTable={}
	for i=0,tree1.totalchildcount0 do 
		local line=tree1['TITLE' .. i]:match("%d%d.%d%d.%d%d%d%d.*") or tree1['TITLE' .. i]
		file1existsTable[line]=true
		iup.TreeSetNodeAttributes(tree1,i,{color="0 0 0",})
	end --for i=0,tree1.totalchildcount0 do 
	--go through tree 2
	local file2existsTable={}
	for i=0,tree2.totalchildcount0 do 
		local line=tree2['TITLE' .. i]:match("%d%d.%d%d.%d%d%d%d.*") or tree2['TITLE' .. i]
		file2existsTable[line]=true
		iup.TreeSetNodeAttributes(tree2,i,{color="0 0 0",})
	end --for i=0,tree2.totalchildcount0 do 

	--go again through tree 1
	for i=0,tree1.totalchildcount0 do 
		local line=tree1['TITLE' .. i]:match("%d%d.%d%d.%d%d%d%d.*") or tree1['TITLE' .. i]
		if file2existsTable[line]==nil then iup.TreeSetNodeAttributes(tree1,i,{color="228 27 0",}) end
	end --for i=0,tree1.totalchildcount0 do 
	--go again through tree 2
	for i=0,tree2.totalchildcount0 do 
		local line=tree2['TITLE' .. i]:match("%d%d.%d%d.%d%d%d%d.*") or tree2['TITLE' .. i]
		if file1existsTable[line]==nil then iup.TreeSetNodeAttributes(tree2,i,{color="228 27 0",}) end
	end --for i=0,tree2.totalchildcount0 do 

end --function button_compare:flat_action()

--6.9 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de")
end --function button_logo:flat_action()

--7 Main Dialog

--7.1 textboxes
textbox1 = iup.multiline{value="",size="160x20",WORDWRAP="YES"}
textbox2 = iup.multiline{value="",size="160x20",WORDWRAP="YES"}

--7.2 load tree from self file
actualtree=lua_tree_output
--build tree
tree=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree)
end, --function(self)
SIZE="10x200",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}
--set colors of tree
tree.BGCOLOR=color_background_tree --set the background color of the tree
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
	elseif c == iup.K_cF then
		searchtext.value=tree.title
		searchtext.SELECTION="ALL"
		dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_Menu then
		menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function tree:k_any(c)

--7.3 load tree1 from directory
p=io.popen('dir "C:\\"')
explorerTree={branchname="Ordnerinhalt"}
for line in p:lines() do explorerTree[#explorerTree+1]=line:gsub("„","ä"):gsub("ÿ"," ") end
textbox1.value="C:\\"
--build tree for explorer
tree1=iup.tree{
map_cb=function(self)
self:AddNodes(explorerTree)
end, --function(self)
SIZE="250x200",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
font="Courier New, 8",--"Courier New, Italic Underline -30",
}
-- Callback of the right mouse button click
function tree1:rightclick_cb(id)
	tree1.value = id
	menu1:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function tree:rightclick_cb(id)

--7.4 load tree2 from directory
p=io.popen('dir "C:\\"')
explorerTree2={branchname="Ordnerinhalt des Ursprungsordners"}
for line in p:lines() do explorerTree2[#explorerTree2+1]=line:gsub("„","ä"):gsub("ÿ"," ") end
textbox2.value="C:\\"
--build tree for explorer
tree2=iup.tree{
map_cb=function(self)
self:AddNodes(explorerTree)
end, --function(self)
SIZE="150x200",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
font="Courier New, 8",--"Courier New, Italic Underline -30",
}
-- Callback of the right mouse button click
function tree2:rightclick_cb(id)
	tree2.value = id
	menu2:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function tree:rightclick_cb(id)

--7.5 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog {

	iup.vbox{

		iup.hbox{
			button_logo,
			button_save_lua_table,
			button_search,
			textbox2,
			textbox1,
			button_start_directory_without_versions,
			iup.label{size="3x"},
			button_exchange_start_and_new_directory,
			button_compare,
			iup.fill{},
			button_missing_copy_and_paste,
			button_version_move_copy_and_paste,
			iup.label{size="3x"},
			button_new_directory,
			button_new_directory_without_versions,
			button_logo2,
		}, --iup.hbox{
		iup.hbox{iup.frame{title="Manuelle Zuordnung als Baum",tree,},iup.frame{title="Ursprungsordner als Baum",tree2},iup.frame{title="Zielordner als Baum",tree1,},},
	}, --iup.vbox{
	icon = img_logo,
	title = path .. " Documentation Tree",
	size="FULLxFULL" ;
	gap="3",
	alignment="ARIGHT",
	margin="5x5" 
}--maindlg = iup.dialog {

--7.6 show the dialog
maindlg:showxy(iup.CENTER,iup.CENTER) 

--7.7 Main Loop
if (iup.MainLoopLevel()==0) then iup.MainLoop() end



--]====]
