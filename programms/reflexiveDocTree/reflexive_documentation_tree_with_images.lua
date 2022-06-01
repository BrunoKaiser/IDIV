lua_tree_output={ branchname="example of a reflexive tree", 
{ branchname="Ergebnisse", 
{ branchname="Tägliche Neuinfektionen", 
{ branchname="C:\\Tree\\reflexiveDocTree\\results\\2021\\Beispiel_NI2.png", 
state="COLLAPSED",
},
{ branchname="C:\\Tree\\reflexiveDocTree\\results\\2022\\Beispiel_NI2.png", 
state="COLLAPSED",
},
},
{ branchname="Kumulierte Historie", 
{ branchname="C:\\Tree\\reflexiveDocTree\\results\\2021\\Beispiel_NI1.png", 
state="COLLAPSED",
 "C:\\Tree\\reflexiveDocTree\\results\\2021\\Beispiel_NI1_Version1.png",},
{ branchname="C:\\Tree\\reflexiveDocTree\\results\\2022\\Beispiel_NI1.png", 
state="COLLAPSED",
},
},
{ branchname="Schätzung", 
{ branchname="C:\\Tree\\reflexiveDocTree\\results\\2021\\Beispiel_NI3.png", 
state="COLLAPSED",
},
{ branchname="C:\\Tree\\reflexiveDocTree\\results\\2022\\Beispiel_NI3.png", 
state="COLLAPSED",
}}}}--lua_tree_output


----[====[This programm has webpages within the Lua script which can contain a tree in html


--1. basic data


--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs
--for images:
require("imlua") --for images
require("cdlua") --for images
require("cdluaim") --for images
require("iupluacd") --for iup canvas
require("imlua_process") --require for rotation

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
end --	function searchup:flat_action()

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

--5.1.8 menu for building new page
menu_new_page = iup.item {title = "Bild laden"}
function menu_new_page:action()
	if tonumber(textbox_zoom.value) then
		zoomFactor=textbox_zoom.value
	end --if tonumber(textbox_zoom.value) then
	if tonumber(textbox_place.value) then
		placementFactor=textbox_place.value
	end --if tonumber(textbox_place.value) then
	textbox1.value=tree['title']
	if textbox1.value:upper():match("JPG") or textbox1.value:upper():match("PNG") then 
		cnv3.canvas:Clear()
		cnv3.canvas:Activate()
		cnv3.image=im.FileImageLoad(textbox1.value)
		if cnv3.image:Width()<=xWidth and cnv3.image:Height()<=yHeight then
			cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*cnv3.image:Width()),math.floor(zoomFactor*cnv3.image:Height()),0,0,0,0)
		elseif math.floor(xWidth*cnv3.image:Height()/cnv3.image:Width())<=yHeight then
			cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*xWidth),math.floor(zoomFactor*xWidth*cnv3.image:Height()/cnv3.image:Width()),0,0,0,0)
		else
			cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*yHeight*cnv3.image:Width()/cnv3.image:Height()),math.floor(zoomFactor*yHeight),0,0,0,0)
		end --if math.floor(xWidth*cnv3.image:Height()/cnv3.image:Width())<=340 then
	end --if textbox1.value:upper():match("JPG") or textbox1.value:upper():match("PNG") then 
end --function menu_new_page:action()

--5.1.9 start the file or repository of the node of tree
startnode = iup.item {title = "Starten"}
function startnode:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then os.execute('start "D" "' .. tree['title'] .. '"') end
end --function startnode:action()

--5.1.10 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,
		renamenode, 
		addbranch, 
		addbranch_fromclipboard, 
		addbranchbottom, 
		addbranch_fromclipboardbottom, 
		addleaf,
		addleaf_fromclipboard,
		addleafbottom,
		addleaf_fromclipboardbottom,
		startversion,
		menu_new_page, 
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
  ; colors = { color_grey_bpc, color_light_color_grey_bpc, color_blue_bpc, "255 255 255" }
}
button_logo=iup.button{image=img_logo,title="", size="23x20"}
function button_logo:action()
	iup.Message("Beckmann & Partner CONSULT","BERATUNGSMANUFAKTUR\nMeisenstraße 79\n33607 Bielefeld\nDr. Bruno Kaiser\nLizenz Open Source")
end --function button_logo:flat_action()

--6.2 button for saving tree reflexive with the programm
button_save_lua_table=iup.flatbutton{title="Datei \nspeichern", size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	save_reflexive_tree_to_lua(path .. "\\" .. thisfilename)
end --function button_save_lua_table:flat_action()

--6.3 button for building new page
button_new_page = iup.flatbutton{title = "Bild laden",size="60x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_new_page:flat_action()
	if tonumber(textbox_zoom.value) then
		zoomFactor=textbox_zoom.value
	end --if tonumber(textbox_zoom.value) then
	if tonumber(textbox_place.value) then
		placementFactor=textbox_place.value
	end --if tonumber(textbox_place.value) then
	textbox1.value=tree['title']
	if textbox1.value:upper():match("JPG") or textbox1.value:upper():match("PNG") then 
		cnv3.canvas:Clear()
		cnv3.canvas:Activate()
		cnv3.image=im.FileImageLoad(textbox1.value)
		if cnv3.image:Width()<=xWidth and cnv3.image:Height()<=yHeight then
			cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*cnv3.image:Width()),math.floor(zoomFactor*cnv3.image:Height()),0,0,0,0)
		elseif math.floor(xWidth*cnv3.image:Height()/cnv3.image:Width())<=yHeight then
			cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*xWidth),math.floor(zoomFactor*xWidth*cnv3.image:Height()/cnv3.image:Width()),0,0,0,0)
		else
			cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*yHeight*cnv3.image:Width()/cnv3.image:Height()),math.floor(zoomFactor*yHeight),0,0,0,0)
		end --if math.floor(xWidth*cnv3.image:Height()/cnv3.image:Width())<=340 then
	end --if textbox1.value:upper():match("JPG") or textbox1.value:upper():match("PNG") then 
end --function button_new_page:action()

--6.4 button to show previous image
button_show_previous_image=iup.flatbutton{title="Voheriges Bild \nzeigen",size="60x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_show_previous_image:flat_action()
	if tonumber(textbox_zoom.value) then
		zoomFactor=textbox_zoom.value
	end --if tonumber(textbox_zoom.value) then
	if tonumber(textbox_place.value) then
		placementFactor=textbox_place.value
	end --if tonumber(textbox_place.value) then
	p=io.popen('dir "' .. textbox1.value:match("(.*)\\[^\\]*") .. '\\*.' .. textbox1.value:match("%.([^%.]*)$") .. '" /b /o-N /s')
	local fileToTake="no"
	for fileText in p:lines() do
print("A: " .. fileText,textbox1.value,fileText==textbox1.value,fileToTake)
		if fileText==textbox1.value then fileToTake="yes"  
		elseif fileToTake=="yes" then textbox1.value=fileText fileToTake="no" end
print("  C: " .. fileText,textbox1.value,fileToTake)
	end --for fileText in p:lines() do
	cnv3.canvas:Clear()
	cnv3.canvas:Activate()
	cnv3.image=im.FileImageLoad(textbox1.value)
	if cnv3.image:Width()<=xWidth and cnv3.image:Height()<=yHeight then
		cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*cnv3.image:Width()),math.floor(zoomFactor*cnv3.image:Height()),0,0,0,0)
	elseif math.floor(xWidth*cnv3.image:Height()/cnv3.image:Width())<=yHeight then
		cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*xWidth),math.floor(zoomFactor*xWidth*cnv3.image:Height()/cnv3.image:Width()),0,0,0,0)
	else
		cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*yHeight*cnv3.image:Width()/cnv3.image:Height()),math.floor(zoomFactor*yHeight),0,0,0,0)
	end --if math.floor(xWidth*cnv3.image:Height()/cnv3.image:Width())<=340 then
	--mark the node if next image in tree
	for i=1, tree.count-1 do
		if tree['title' .. i]==textbox1.value then
		tree.value=i
		end --if tree['title' .. i]==textbox1.value then
	end --for i=numberOfNode, tree2.count-1 do
end --function button_show_previous_image:flat_action()


--6.4.1 button for search in tree
button_search=iup.flatbutton{title="Suchen\n(Strg+F)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
	searchtext.value=tree.title
	searchtext.SELECTION="ALL"
	dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_search:flat_action(


--6.5 button for adding branch of tree from filename of image
button_addbranch_image=iup.flatbutton{title="Ast aus \nBilddateinamen",size="60x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_addbranch_image:flat_action()
	tree.addbranch = textbox1.value
	tree.value=tree.value+1
end --function button_addbranch_image:flat_action()

--6.6 button for adding leaf of tree from filename of image
button_addleaf_image=iup.flatbutton{title="Blatt aus \nBilddateinamen",size="60x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_addleaf_image:flat_action()
	tree.addleaf = textbox1.value
	tree.value=tree.value+1
end --function button_addleaf_image:flat_action()


--6.7 button to copy filename in clipboard
button_copy_title=iup.flatbutton{title="Dateipfad in \nZwischenablage", size="60x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_copy_title:flat_action()
	clipboard.text=textbox1.value
end --function button_copy_title:flat_action()


--6.8 button to show next image
button_show_next_image=iup.flatbutton{title="Nächstes Bild \nzeigen",size="60x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_show_next_image:flat_action()
	if tonumber(textbox_zoom.value) then
		zoomFactor=textbox_zoom.value
	end --if tonumber(textbox_zoom.value) then
	if tonumber(textbox_place.value) then
		placementFactor=textbox_place.value
	end --if tonumber(textbox_place.value) then
	p=io.popen('dir "' .. textbox1.value:match("(.*)\\[^\\]*") .. '\\*.' .. textbox1.value:match("%.([^%.]*)$") .. '" /b /o /s')
	local fileToTake="no"
	for fileText in p:lines() do
		--test with: print("A: " .. fileText,textbox1.value,fileText==textbox1.value,fileToTake)
		if fileText==textbox1.value then fileToTake="yes"  
		elseif fileToTake=="yes"    then textbox1.value=fileText fileToTake="no" 
		end --if fileText==textbox1.value then
		--test with: print("  C: " .. fileText,textbox1.value,fileToTake)
	end --for fileText in p:lines() do
	cnv3.canvas:Clear()
	cnv3.canvas:Activate()
	cnv3.image=im.FileImageLoad(textbox1.value)
	if cnv3.image:Width()<=xWidth and cnv3.image:Height()<=yHeight then
		cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*cnv3.image:Width()),math.floor(zoomFactor*cnv3.image:Height()),0,0,0,0)
	elseif math.floor(xWidth*cnv3.image:Height()/cnv3.image:Width())<=yHeight then
		cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*xWidth),math.floor(zoomFactor*xWidth*cnv3.image:Height()/cnv3.image:Width()),0,0,0,0)
	else
		cnv3.image:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-cnv3.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-cnv3.image:Height())/2),0),math.floor(zoomFactor*yHeight*cnv3.image:Width()/cnv3.image:Height()),math.floor(zoomFactor*yHeight),0,0,0,0)
	end --if math.floor(xWidth*cnv3.image:Height()/cnv3.image:Width())<=340 then
	--mark the node if next image in tree
	for i=1, tree.count-1 do
		if tree['title' .. i]==textbox1.value then
		tree.value=i
		end --if tree['title' .. i]==textbox1.value then
	end --for i=numberOfNode, tree2.count-1 do
end --function button_show_next_image:flat_action()

--6.9 button to rotate image
button_rotate=iup.flatbutton{title="Bild drehen",size="60x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_rotate:flat_action()
	if tonumber(textbox_zoom.value) then
		zoomFactor=textbox_zoom.value
	end --if tonumber(textbox_zoom.value) then
	if tonumber(textbox_place.value) then
		placementFactor=textbox_place.value
	end --if tonumber(textbox_place.value) then
	--Rotation Test image1->cnv3.image
	cnv3.image:AddAlpha() -- option 1: to avoid a black background
	cnv3.image:SetAlpha(255)
	local w,h=im.ProcessCalcRotateSize(cnv3.image:Width(),cnv3.image:Height(),math.cos(math.pi/2),math.sin(math.pi/2))
	image2=im.ImageCreateBased(cnv3.image,w,h)
	im.ProcessRotate(cnv3.image,image2,math.cos(math.pi/2),math.sin(math.pi/2),1)
	cnv3.canvas:Activate()
	cnv3.canvas:Clear()
	--processed:
	if image2:Width()<=xWidth and image2:Height()<=yHeight then
		image2:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-image2:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-image2:Height())/2),0),math.floor(zoomFactor*image2:Width()),math.floor(zoomFactor*image2:Height()),0,0,0,0)
	elseif math.floor(xWidth*image2:Height()/image2:Width())<=yHeight then
		image2:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-image2:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-image2:Height())/2),0),math.floor(zoomFactor*xWidth),math.floor(zoomFactor*xWidth*image2:Height()/image2:Width()),0,0,0,0)
	else
		image2:cdCanvasPutImageRect(cnv3.canvas,math.max(math.floor(placementFactor*(xWidth-image2:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-image2:Height())/2),0),math.floor(zoomFactor*yHeight*image2:Width()/image2:Height()),math.floor(zoomFactor*yHeight),0,0,0,0)
	end --if math.floor(xWidth*cnv3.image:Height()/cnv3.image:Width())<=340 then
end --function button_rotate:flat_action()

--6.10 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Beckmann & Partner CONSULT","BERATUNGSMANUFAKTUR\nMeisenstraße 79\n33607 Bielefeld\nDr. Bruno Kaiser\nLizenz Open Source")
end --function button_logo:flat_action()

--7 Main Dialog

--7.1 textboxes
textbox1 = iup.multiline{value="",size="250x20",WORDWRAP="YES"}
textbox_zoom_text = iup.text{value="Zoom",size="30x10",readonly="YES",BGCOLOR=color_buttons, FGCOLOR=color_button_text}
textbox_zoom = iup.text{value="1.0",size="30x10"}
textbox_place_text = iup.text{value="Lage",size="30x10",readonly="YES",BGCOLOR=color_buttons, FGCOLOR=color_button_text}
textbox_place = iup.text{value="1.0",size="30x10"}

--7.2 canvas for images
image1 = im.FileImageLoad(path .. "\\" .. thisfilename:gsub("%.lua",".png"))
textbox1.value=path .. "\\" .. thisfilename:gsub("%.lua",".png")
xWidth=700 --width of the canvas
yHeight=700 --height of the canvas
cnv3 = iup.canvas{image =  image1 , rastersize = xWidth .. "xWidth" .. yHeight,
--scrollbar="YES",
} 
function cnv3:action()          -- called everytime the IUP canvas needs to be repainted
	if tonumber(textbox_zoom.value) then
		zoomFactor=textbox_zoom.value
	end --if tonumber(textbox_zoom.value) then
	if tonumber(textbox_place.value) then
		placementFactor=textbox_place.value
	end --if tonumber(textbox_place.value) then
	self.canvas:Activate()
	--0= use default values
	if self.image:Width()<=xWidth and self.image:Height()<=yHeight then
		self.image:cdCanvasPutImageRect(self.canvas,math.max(math.floor(placementFactor*(xWidth-self.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-self.image:Height())/2),0),math.floor(zoomFactor*self.image:Width()),math.floor(zoomFactor*self.image:Height()),0,0,0,0)
	elseif math.floor(xWidth*self.image:Height()/self.image:Width())<=yHeight then
		self.image:cdCanvasPutImageRect(self.canvas,math.max(math.floor(placementFactor*(xWidth-self.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-self.image:Height())/2),0),math.floor(zoomFactor*xWidth),math.floor(zoomFactor*xWidth*self.image:Height()/self.image:Width()),0,0,0,0)
	else
		self.image:cdCanvasPutImageRect(self.canvas,math.max(math.floor(placementFactor*(xWidth-self.image:Width())/2),0),math.max(math.floor(placementFactor*(yHeight-self.image:Height())/2),0),math.floor(zoomFactor*yHeight*self.image:Width()/self.image:Height()),math.floor(zoomFactor*yHeight),0,0,0,0)
	end --if math.floor(xWidth*self.image:Height()/self.image:Width())<=340 then
end --function cnv:action()          -- called everytime the IUP canvas needs to be repainted
function cnv3:map_cb()       -- the CD canvas can only be created when the IUP canvas is mapped
	self.canvas = cd.CreateCanvas(cd.IUP, self)
end --function cnv:map_cb()       -- the CD canvas can only be created when the IUP canvas is mapped

--7.3 load tree from self file
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


--7.4 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog {

	iup.vbox{

		iup.hbox{
			button_logo,
			button_save_lua_table,
			button_show_previous_image,
			button_search,
			iup.fill{},
			iup.vbox{textbox_zoom_text,textbox_zoom,},
			iup.vbox{textbox_place_text,textbox_place,},
			button_addbranch_image,
			button_addleaf_image,
			button_copy_title,
			textbox1,
			button_show_next_image,
			button_new_page,
			button_rotate,
			button_logo2,
		}, --iup.hbox{
		iup.hbox{iup.frame{title="Manuelle Zuordnung als Baum",tree,},cnv3,},
	}, --iup.vbox{
	icon = img_logo,
	title = path .. " Documentation Tree",
	size="FULLxFULL" ;
	gap="3",
	alignment="ARIGHT",
	--margin="5x5" 
}--maindlg = iup.dialog {

--7.5 show the dialog
maindlg:showxy(iup.CENTER,iup.CENTER) 

--7.6 Main Loop
if (iup.MainLoopLevel()==0) then iup.MainLoop() end



--]====]
