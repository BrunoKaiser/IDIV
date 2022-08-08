--This script runs a graphical user interface (GUI) to edit a checklist as a tree and set ticks and priorities

--1. basic data

--
Datei="C:\\Tree\\html_Tree\\html_fengari\\reflexive_fengari_tree_functional_checklists_persistent_prio.html"
--Datei="C:\\Temp\\reflexive_fengari_tree_functional_checklists_Ehrenkodex.html"

--1.1 libraries and clipboard
--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iuplua_scintilla") --for Scintilla-editor

--1.1.2 initalize clipboard
clipboard=iup.clipboard{}

--1.1.3 math.integer for Lua 5.1 and Lua 5.2
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


--1.3 path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)

--3 functions

--3.1 general Lua functions

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

--3.1.1 function checking if file exits
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end --function file_exists(name)

--3.1.2 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--3.2 function which saves the current iup tree as a Lua table
function save_tree_to_lua_text(tree)
	local output_tree_text="Tree=" --the output string
	for i=0,tree.count - 1 do --loop for all nodes
		if tree["KIND" .. i ]=="BRANCH" then --consider cases, if actual node is a branch
			if (i > 0 and (tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) ) ) or i==0 then --consider cases if depth increases
				output_tree_text = output_tree_text .. '{branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",' -- we open a new branch
				--save state
				if tree["STATE" .. i ]=="COLLAPSED" then
					output_tree_text = output_tree_text .. 'state="COLLAPSED",'
				end --if tree["STATE" .. i ]=="COLLAPSED" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) < tonumber(tree["DEPTH" .. i-1 ]) then --if depth decreases
				if tree["KIND" .. i-1 ] == "BRANCH" then --depending if the predecessor node was a branch we need to close one bracket more
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
						output_tree_text = output_tree_text .. '},'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
					output_tree_text = output_tree_text .. '{branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",' --and we open the new branch
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				else
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do -- or if the predecessor node was a leaf
						output_tree_text = output_tree_text .. '},'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
					output_tree_text = output_tree_text .. '{branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",' --and we open the new branch
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				end --if tree["KIND" .. i-1 ] == "BRANCH" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) == tonumber(tree["DEPTH" .. i-1 ]) then --or if depth stays the same
				if tree["KIND" .. i-1 ] == "BRANCH" then --again consider if the predecessor node was a branch
					output_tree_text = output_tree_text .. '},{branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",'
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				else --or a leaf
					output_tree_text = output_tree_text .. '{branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",'
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				end --if tree["KIND" .. i-1 ] == "BRANCH" then
			end --if (i > 0 and (tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) ) ) or i==0 then
		elseif tree["KIND" .. i ]=="LEAF" then --or if actual node is a leaf
			if (i > 0 and tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) )  or i==0 then
				output_tree_text = output_tree_text .. '"' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",' --we add the leaf
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) < tonumber(tree["DEPTH" .. i-1 ]) then
				if tree["KIND" .. i-1 ] == "LEAF" then --in the same manner as above, depending if the predecessor node was a leaf or branch, we have to close a different number of brackets
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
						output_tree_text = output_tree_text .. '},'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
					output_tree_text = output_tree_text .. '"' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",' --and in each case we add the new leaf
				else
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
						output_tree_text = output_tree_text .. '},'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
					output_tree_text = output_tree_text .. '"' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",'
				end --if tree["KIND" .. i-1 ] == "LEAF" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) == tonumber(tree["DEPTH" .. i-1 ]) then
				if tree["KIND" .. i-1 ] == "LEAF" then
					output_tree_text = output_tree_text .. '"' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",'
				else
					output_tree_text = output_tree_text .. '}, "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",'
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
	return output_tree_text
end --function save_tree_to_lua_text(tree)

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
	end --for i=0, tree2.count - 1 do
	--mark all nodes end
end --function searchmark:flat_action()

--search to mark open nodes without going to the any node
searchmark_open    = iup.flatbutton{title = "Markieren der offenen Punkte",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function searchmark_open:flat_action()
	--unmark all nodes
	for i=0, tree.count - 1 do
			tree["color" .. i]="0 0 0"
	end --for i=0, tree.count - 1 do
	--unmark all nodes end
	--mark all nodes
	for i=0, tree.count - 1 do
		if TickTable[tree['title' ..i]:gsub("&[^&]*;","")] and TickTable[tree['title' ..i]:gsub("&[^&]*;","")]:match("tick")==nil then
			iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
		elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]==nil then
			iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
		end --if TickTable[tree['title' ..i]:gsub("&[^&]*;","")]==nil then
	end --for i=0, tree.count - 1 do
	--mark all nodes end
end --function searchmark_open:flat_action()

--search to mark prio1 nodes without going to the any node
searchmark_prio1    = iup.flatbutton{title = "Markieren der Prio 1 Punkte",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function searchmark_prio1:flat_action()
	--unmark all nodes
	for i=0, tree.count - 1 do
			tree["color" .. i]="0 0 0"
	end --for i=0, tree.count - 1 do
	--unmark all nodes end
	--mark all nodes
	for i=0, tree.count - 1 do
		if TickTable[tree['title' ..i]:gsub("&[^&]*;","")] and TickTable[tree['title' ..i]:gsub("&[^&]*;","")]:match("prio1") then
			iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
		end --if TickTable[tree['title' ..i]:gsub("&[^&]*;","")]==nil then
	end --for i=0, tree.count - 1 do
	--mark all nodes end
end --function searchmark_prio1:flat_action()

--search to mark prio2 nodes without going to the any node
searchmark_prio2    = iup.flatbutton{title = "Markieren der Prio 2 Punkte",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function searchmark_prio2:flat_action()
	--unmark all nodes
	for i=0, tree.count - 1 do
			tree["color" .. i]="0 0 0"
	end --for i=0, tree.count - 1 do
	--unmark all nodes end
	--mark all nodes
	for i=0, tree.count - 1 do
		if TickTable[tree['title' ..i]:gsub("&[^&]*;","")] and TickTable[tree['title' ..i]:gsub("&[^&]*;","")]:match("prio2") then
			iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
		end --if TickTable[tree['title' ..i]:gsub("&[^&]*;","")]==nil then
	end --for i=0, tree.count - 1 do
	--mark all nodes end
end --function searchmark_prio2:flat_action()

--search to mark prio3 nodes without going to the any node
searchmark_prio3    = iup.flatbutton{title = "Markieren der Prio 3 Punkte",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function searchmark_prio3:flat_action()
	--unmark all nodes
	for i=0, tree.count - 1 do
			tree["color" .. i]="0 0 0"
	end --for i=0, tree.count - 1 do
	--unmark all nodes end
	--mark all nodes
	for i=0, tree.count - 1 do
		if TickTable[tree['title' ..i]:gsub("&[^&]*;","")] and TickTable[tree['title' ..i]:gsub("&[^&]*;","")]:match("prio3") then
			iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
		end --if TickTable[tree['title' ..i]:gsub("&[^&]*;","")]==nil then
	end --for i=0, tree.count - 1 do
	--mark all nodes end
end --function searchmark_prio3:flat_action()

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
search_label=iup.label{title="Suchfeld:"} --label for textfield

--put above together in a search dialog
dlg_search =iup.dialog{
			iup.vbox{iup.hbox{search_label,searchtext,}, 

			iup.label{title="Sonderzeichen: %. für ., %- für -, %+ für +, %% für %, %[ für [, %] für ], %( für (, %) für ), %^ für ^, %$ für $, %? für ?",},
			iup.hbox{searchmark,unmark,}, 
			iup.hbox{searchmark_open,}, 
			iup.hbox{searchmark_prio1,}, 
			iup.hbox{searchmark_prio2,}, 
			iup.hbox{searchmark_prio3,}, 
			iup.label{title="rot: übergeordnete Knoten",fgcolor = "255 0 0", },
			iup.label{title="blau: gleicher Knoten",fgcolor = "0 0 255", },
			iup.label{title="grün: untergeordnete Knoten",fgcolor = "90 195 0", },
			iup.hbox{searchdown, searchup,checkboxforcasesensitive,},

			}; 
		title="Suchen",
		size="420x150",
		startfocus=searchtext
		}

--4.2 search dialog end



--4.3 replace dialog

--cancel button for replace dialog
cancel_replace = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function cancel_replace:flat_action()
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

--5.1.12 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,
		renamenode, 
		addbranch, 
		addbranch_fromclipboard, 
		addleaf,
		addleaf_fromclipboard,
		}
--5.1 menu of tree end


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

--6.2.1 button for saving tree
button_save_code_with_datapart=iup.flatbutton{title="Code speichern", size="95x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_code_with_datapart:flat_action()
	outputfile1=io.open(textbox1.value,"w")
	outputfile1:write(codeBeforeText)
	outputfile1:write("DBTable={\n")
	for i,v in ipairs(DBTable) do
		print(i)
		if i==math.tointeger(tonumber(textbox0.value)) then
			outputfile1:write("'" .. save_tree_to_lua_text(tree) .. "'," .. "\n")
		else
			outputfile1:write("'" .. v .. "'," .. "\n")
		end --if i==math.tointeger(tonumber(textbox0.value)) then
	end --for i,v in ipairs(DBTable) do
	outputfile1:write("} --DBTable={")
	outputfile1:write("\n" .. codeAfterText)
	outputfile1:close()
	--update datapart after saving code takes the new tree in the graphical user interface
	--take only datapart in tree but save code text before and after it in variables
	codeFlag="codeBeforeText"
	codeBeforeText=""
	dataPartText=""
	codeAfterText=""
	for line in io.lines(textbox1.value) do
		if line:match("^DBTable=") then
			codeFlag="dataPartText"
		end --if line:match("^DBTable=") then
		if codeFlag=="codeBeforeText" then
			codeBeforeText=codeBeforeText .. line .. "\n"
		elseif codeFlag=="dataPartText" then
			dataPartText=dataPartText .. line .. "\n"
		elseif codeFlag=="codeAfterText" then
			codeAfterText=codeAfterText .. line .. "\n"
		end --if codeBeforeFlag=="yes" then
		if line:match("} %-%-DBTable=") then
			codeFlag="codeAfterText"
		end --if line:match("} %-%-DBTable=") then
	end --for line in io.lines(textbox1.value) do
	--load tree from file
	if _VERSION=='Lua 5.1' then
		loadstring(dataPartText)()
	else
		load(dataPartText)() --now DBTable is the table.
	end --if _VERSION=='Lua 5.1' then
end --function button_save_code_with_datapart:flat_action()

--6.2.2 button for saving tree
button_save_ticks=iup.flatbutton{title="Häkchen \nspeichern", size="95x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_ticks:flat_action()
	outputfile1=io.open(textbox1.value,"w")
	outputfile1:write(codeBeforeText_Tick)
	outputfile1:write("TickTable={}\n")
	for k,v in pairs(TickTable) do
		outputfile1:write("tickText=[[" .. k .. ']] TickTable[tickText]="' .. v .. '"\n') --"tick"
	end --for k,v in pairs(TickTable) do
	outputfile1:write("--TickTable={}\n")
	outputfile1:write(codeAfterText_Tick)
	outputfile1:close()
end --function button_save_ticks:flat_action()

--6.3 button for search in tree, tree2 and tree3
button_search=iup.flatbutton{title="Suchen", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
	searchtext.value=tree.title
	searchtext.SELECTION="ALL"
	dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_search:flat_action()

--6.4 button for replacing in tree
button_replace=iup.flatbutton{title="Suchen und Ersetzen", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_replace:flat_action()
	searchtext_replace.value=tree.title
	replacetext_replace.SELECTION="ALL"
	dlg_search_replace:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_replace:flat_action()

--6.5 button for replacing in tree
button_load_tree=iup.flatbutton{title="Baum laden", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_load_tree:flat_action()
	print("#DBTable" .. #DBTable)
	if math.tointeger(tonumber(textbox0.value))<=#DBTable then
		tree['delnode0']= "CHILDREN"
		if _VERSION=='Lua 5.1' then
			loadstring(DBTable[math.tointeger(tonumber(textbox0.value))])()
		else
			load(DBTable[math.tointeger(tonumber(textbox0.value))])() --now DBTable is the table.
		end --if _VERSION=='Lua 5.1' then
		tree:AddNodes(Tree)
	end --if math.tointeger(tonumber(textbox0.value))<=DBTable then
	--tick the nodes
	for i=0,tree.count-1 do --loop for all nodes
		if TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="tick" then
			tree['image' .. i]=img_tick_leaf
			tree['imageexpanded' .. i]=img_tick_leaf
		elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio1" then
			tree['image' .. i]=img_prio1_leaf
			tree['imageexpanded' .. i]=img_prio1_leaf
		elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio2" then
			tree['image' .. i]=img_prio2_leaf
			tree['imageexpanded' .. i]=img_prio2_leaf
		elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio3" then
			tree['image' .. i]=img_prio3_leaf
			tree['imageexpanded' .. i]=img_prio3_leaf
		elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio1_tick" then
			tree['image' .. i]=img_tick_prio1_leaf
			tree['imageexpanded' .. i]=img_tick_prio1_leaf
		elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio2_tick" then
			tree['image' .. i]=img_tick_prio2_leaf
			tree['imageexpanded' .. i]=img_tick_prio2_leaf
		elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio3_tick" then
			tree['image' .. i]=img_tick_prio3_leaf
			tree['imageexpanded' .. i]=img_tick_prio3_leaf
		end --if TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="tick" then
	end --for i=0,tree.count-1 do --loop for all nodes
end --function button_load_tree:flat_action()

--6.6 button for replacing in tree
button_new_tree=iup.flatbutton{title="Neuen Baum \nanlegen", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_new_tree:flat_action()
	textbox0.value=#DBTable+1
	DBTable[#DBTable+1]='Tree={branchname="new"}'
	tree['delnode0']= "CHILDREN"
	Tree={branchname="new"}
	tree:AddNodes(Tree)
end --function button_new_tree:flat_action()

--6.7 button for organising ticks in tree
button_ticks_organise=iup.flatbutton{title="Häkchen \nverwalten", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_ticks_organise:flat_action()
	i=tree.value
	prioTable={}
	toggleTable={}
	prioTable[1]=iup.text{value="",size="50x10"}
	toggleTable[1]=iup.toggle{title=tree['title' .. i],value="OFF"}
	--test with: print(TickTable[tree['title' ..i]:gsub("&[^&]*;","")])
	if TickTable[tree['title' ..i]:gsub("&[^&]*;","")] and TickTable[tree['title' ..i]:gsub("&[^&]*;","")]:match("prio") then
	--test with: print(TickTable[tree['title' ..i]:gsub("&[^&]*;","")]:match("prio1"))
		prioTable[1].value=TickTable[tree['title' ..i]:gsub("&[^&]*;","")]:match("%d") --take the number from prio1, prio2 or prio3
	end --if TickTable[tree['title' ..i]:gsub("&[^&]*;","")] then
	if TickTable[tree['title' ..i]:gsub("&[^&]*;","")] and TickTable[tree['title' ..i]:gsub("&[^&]*;","")]:match("tick") then
		toggleTable[1].value="ON"
	end --if TickTable[tree['title' ..i]:gsub("&[^&]*;","")] then
	while true do
		if tree['parent' .. i]==nil then break end
		toggleTable[#toggleTable+1]=iup.toggle{title=tree['title' .. tree['parent' .. i]],value="OFF"}
		prioTable[#toggleTable]=iup.text{value="",size="50x10"}
		--test with: print(TickTable[tree['title' ..tree['parent' .. i]]:gsub("&[^&]*;","")])
		if TickTable[tree['title' ..tree['parent' .. i]]:gsub("&[^&]*;","")] and TickTable[tree['title' ..tree['parent' .. i]]:gsub("&[^&]*;","")]:match("prio") then
			prioTable[#toggleTable].value=TickTable[tree['title' ..tree['parent' .. i]]:gsub("&[^&]*;","")]:match("%d") --take the number from prio1, prio2 or prio3
		end --if TickTable[tree['title' ..tree['parent' .. i]]:gsub("&[^&]*;","")] and TickTable[tree['title' ..tree['parent' .. i]]:gsub("&[^&]*;","")]:match("prio") then
		if TickTable[tree['title' ..tree['parent' .. i]]:gsub("&[^&]*;","")] and TickTable[tree['title' ..tree['parent' .. i]]:gsub("&[^&]*;","")]:match("tick") then 
			toggleTable[#toggleTable].value="ON"
		end --if TickTable[tree['title' ..tree['parent' .. i]]:gsub("&[^&]*;","")] and TickTable[tree['title' ..tree['parent' .. i]]:gsub("&[^&]*;","")]:match("tick") then
		i=tree['parent' .. i]
	end --while true do
	--4.4 ticks dialog
	cancel_ticks = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
	function cancel_ticks:flat_action()
		return iup.CLOSE
	end --function cancel_ticks:flat_action()
	--search in upward direction
	ticks_set   = iup.flatbutton{title = "Häkchen setzen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
	function ticks_set:flat_action()
		for i,v in ipairs(toggleTable) do
			if toggleTable[i].value=="OFF" and prioTable[i].value=="" then
				TickTable[toggleTable[i].title:gsub("&[^&]*;","")]=nil
			elseif toggleTable[i].value=="OFF" and prioTable[i].value~="" then
				TickTable[toggleTable[i].title:gsub("&[^&]*;","")]="prio" .. prioTable[i].value
			elseif toggleTable[i].value=="ON" and prioTable[i].value~="" then
				TickTable[toggleTable[i].title:gsub("&[^&]*;","")]="prio" .. prioTable[i].value .. "_tick"
			elseif toggleTable[i].value=="ON" and prioTable[i].value=="" then
				TickTable[toggleTable[i].title:gsub("&[^&]*;","")]="tick"
			end --if toggleTable[i].value=="OFF" then
		end --for i,v in ipairs(toggleTable) do
		--go through the whole tree to set the right images
		for i=0,tree.count-1 do --loop for all nodes
			if TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="tick" then
				tree['image' .. i]=img_tick_leaf
				tree['imageexpanded' .. i]=img_tick_leaf
			elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio1" then
				tree['image' .. i]=img_prio1_leaf
				tree['imageexpanded' .. i]=img_prio1_leaf
			elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio2" then
				tree['image' .. i]=img_prio2_leaf
				tree['imageexpanded' .. i]=img_prio2_leaf
			elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio3" then
				tree['image' .. i]=img_prio3_leaf
				tree['imageexpanded' .. i]=img_prio3_leaf
			elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio1_tick" then
				tree['image' .. i]=img_tick_prio1_leaf
				tree['imageexpanded' .. i]=img_tick_prio1_leaf
			elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio2_tick" then
				tree['image' .. i]=img_tick_prio2_leaf
				tree['imageexpanded' .. i]=img_tick_prio2_leaf
			elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio3_tick" then
				tree['image' .. i]=img_tick_prio3_leaf
				tree['imageexpanded' .. i]=img_tick_prio3_leaf
			else
				tree['image' .. i]=0
				tree['imageexpanded' .. i]=0
			end --if TickTable[tree['title' ..i]:gsub("&[^&]*;","")] then
		end --for i=0,tree.count-1 do --loop for all nodes
	end --function ticks_set:flat_action()
	ticks_label=iup.label{title= "Priorität:          Häkchen bis zur 12. Ebene verwalten:    "} --label for textfield
	--put above together in a search dialog
	dlg_ticks =iup.dialog{
					iup.vbox{
						iup.hbox{ticks_label},
						iup.hbox{prioTable[12],toggleTable[12]},
						iup.hbox{prioTable[11],toggleTable[11]},
						iup.hbox{prioTable[10],toggleTable[10]},
						iup.hbox{prioTable[9],toggleTable[9]},
						iup.hbox{prioTable[8],toggleTable[8]},
						iup.hbox{prioTable[7],toggleTable[7]},
						iup.hbox{prioTable[6],toggleTable[6]},
						iup.hbox{prioTable[5],toggleTable[5]},
						iup.hbox{prioTable[4],toggleTable[4]},
						iup.hbox{prioTable[3],toggleTable[3]},
						iup.hbox{prioTable[2],toggleTable[2]},
						iup.hbox{prioTable[1],toggleTable[1]},
						iup.hbox{ticks_set, cancel_ticks,},
					}; 
					title="Häkchen verwalten",
					size="920x100",
					}
	--4.4 ticks dialog end
	dlg_ticks:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_ticks_organise:flat_action()

--6.8 button for deleting tree
button_delete_tree=iup.flatbutton{title="Baum \nlöschen", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_delete_tree:flat_action()
	LoeschAlarm=iup.Alarm("Soll der Baum " .. tonumber(textbox0.value) .. " wirklich gelöscht werden?","Soll der Baum " .. tonumber(textbox0.value) .. " wirklich gelöscht werden?","Löschen","Nicht Löschen")
	if LoeschAlarm==1 then
		print("Loeschen von " .. math.tointeger(tonumber(textbox0.value)))
		table.move(DBTable,math.tointeger(tonumber(textbox0.value))+1,#DBTable,math.tointeger(tonumber(textbox0.value)))
		DBTable[#DBTable]=nil --delete last element
		print("#DBTable" .. #DBTable)
		if tonumber(textbox0.value)>#DBTable then
			textbox0.value=#DBTable
		end --if textbox0.value>#DBTable then
		tree['delnode0']= "CHILDREN"
		if _VERSION=='Lua 5.1' then
			loadstring(DBTable[math.tointeger(tonumber(textbox0.value))])()
		else
			load(DBTable[math.tointeger(tonumber(textbox0.value))])() --now DBTable is the table.
		end --if _VERSION=='Lua 5.1' then
		tree:AddNodes(Tree)
	end --if LoeschAlarm==1 then 
end --function button_delete_tree:flat_action()

--6.9 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Beckmann & Partner CONSULT","BERATUNGSMANUFAKTUR\nMeisenstraße 79\n33607 Bielefeld\nDr. Bruno Kaiser\nLizenz Open Source")
end --function button_logo:flat_action()

--6 buttons end


--7 Main Dialog
--7.1 icon definitions
img_tick_leaf= iup.image{
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2 },  
  { 2,2,1,1,1,1,1,1,1,1,2,2,2,1,1,1 },
  { 1,2,2,1,1,1,1,1,2,2,2,2,1,1,1,1 }, 
  { 1,2,2,1,1,1,1,2,2,2,1,1,1,1,1,1 }, 
  { 1,2,2,2,1,1,2,2,2,2,1,1,1,1,1,1 },  
  { 1,1,2,2,1,2,2,2,1,1,1,1,1,1,1,1 },
  { 1,1,2,2,1,2,2,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,2,2,2,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
   
  -- Sets "X" image colors
  ; colors = { color_background_tree, color_red_bpc}
}
img_prio1_leaf= iup.image{
  { 1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,2,2,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,2,2,1,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,2,1,1,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 },
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 },
  { 1,1,1,1,1,1,2,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,2,2,2,2,2,2,2,2,1,1,1,1 }, 
  { 1,1,1,2,2,2,2,2,2,2,2,2,2,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
   
  -- Sets "X" image colors
  ; colors = { color_background_tree, color_red_bpc}
}
img_tick_prio1_leaf= iup.image{
  { 1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,2,2,2,1,1,1,1,1,1,1,1 },  
  { 1,1,1,2,2,1,2,2,1,1,1,1,1,1,1,1 }, 
  { 1,1,2,1,1,1,2,2,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,2,2,2,2,2,2,1,1,2,2,2,2 },  
  { 2,2,1,1,1,1,1,1,1,1,2,2,2,1,1,1 },
  { 1,2,2,1,1,1,1,1,2,2,2,2,1,1,1,1 }, 
  { 1,2,2,1,1,1,1,2,2,2,1,1,1,1,1,1 }, 
  { 1,2,2,2,1,1,2,2,2,2,1,1,1,1,1,1 },  
  { 1,1,2,2,1,2,2,2,1,1,1,1,1,1,1,1 },
  { 1,1,2,2,1,2,2,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,2,2,2,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
   
  -- Sets "X" image colors
  ; colors = { color_background_tree, color_red_bpc}
}
img_prio2_leaf= iup.image{
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,2,2,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,2,2,1,1,1,2,2,1,1,1,1,1 }, 
  { 1,1,1,2,2,1,1,1,1,1,2,2,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,2,2,2,1,1,1,1 },
  { 1,1,1,1,1,1,1,1,1,2,2,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1 },
  { 1,1,1,1,1,2,2,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,2,2,2,2,2,2,2,2,1,1,1,1 }, 
  { 1,1,1,2,2,2,2,2,2,2,2,2,2,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
   
  -- Sets "X" image colors
  ; colors = { color_background_tree, color_red_bpc}
}
img_tick_prio2_leaf= iup.image{
  { 1,1,1,1,1,2,2,2,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,2,2,1,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,1,1,1,2,2,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,2,2,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,2,2,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,2,2,2,2,2,2,1,1,2,2,2,2 },  
  { 2,2,1,1,1,1,1,1,1,1,2,2,2,1,1,1 },
  { 1,2,2,1,1,1,1,1,2,2,2,2,1,1,1,1 }, 
  { 1,2,2,1,1,1,1,2,2,2,1,1,1,1,1,1 }, 
  { 1,2,2,2,1,1,2,2,2,2,1,1,1,1,1,1 },  
  { 1,1,2,2,1,2,2,2,1,1,1,1,1,1,1,1 },
  { 1,1,2,2,1,2,2,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,2,2,2,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
   
  -- Sets "X" image colors
  ; colors = { color_background_tree, color_red_bpc}
}
img_prio3_leaf= iup.image{
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,2,2,2,2,2,2,2,2,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,2,2,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,2,2,1,1,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1 },
  { 1,1,1,1,1,1,1,1,1,2,2,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,2,2,2,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,2,2,2,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,2,2,2,1,1,1,1 },
  { 1,1,1,2,2,1,1,1,2,2,2,1,1,1,1,1 }, 
  { 1,1,1,1,2,2,2,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,2,2,2,2,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
   
  -- Sets "X" image colors
  ; colors = { color_background_tree, color_red_bpc}
}
img_tick_prio3_leaf= iup.image{
  { 1,1,1,1,2,2,2,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 },  
  { 1,1,1,1,2,2,2,2,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,2,2,2,2,2,1,1,1,2,2,2,2 },  
  { 2,2,1,1,1,2,2,2,1,1,2,2,2,1,1,1 },
  { 1,2,2,1,1,1,1,1,2,2,2,2,1,1,1,1 }, 
  { 1,2,2,1,1,1,1,2,2,2,1,1,1,1,1,1 }, 
  { 1,2,2,2,1,1,2,2,2,2,1,1,1,1,1,1 },  
  { 1,1,2,2,1,2,2,2,1,1,1,1,1,1,1,1 },
  { 1,1,2,2,1,2,2,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,2,2,2,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
   
  -- Sets "X" image colors
  ; colors = { color_background_tree, color_red_bpc}
}

--7.2 textboxes
textbox0 = iup.text{value="1",size="50x20"}
textbox1 = iup.multiline{value=Datei,size="350x20",WORDWRAP="YES",READONLY="YES"}

--take only datapart in tree but save code text before and after it in variables
codeFlag="codeBeforeText"
codeBeforeText=""
dataPartText=""
codeAfterText=""
for line in io.lines(textbox1.value) do
	if line:match("^DBTable=") then
		codeFlag="dataPartText"
	end --if line:match("^DBTable=") then
	if codeFlag=="codeBeforeText" then
		codeBeforeText=codeBeforeText .. line .. "\n"
	elseif codeFlag=="dataPartText" then
		dataPartText=dataPartText .. line .. "\n"
	elseif codeFlag=="codeAfterText" then
		codeAfterText=codeAfterText .. line .. "\n"
	end --if codeBeforeFlag=="yes" then
	if line:match("} %-%-DBTable=") then
		codeFlag="codeAfterText"
	end --if line:match("} %-%-DBTable=") then
end --for line in io.lines(textbox1.value) do

--7.3 load tree from file
if _VERSION=='Lua 5.1' then
	loadstring(dataPartText)()
	loadstring(DBTable[1])()
else
	load(dataPartText)() --now DBTable is the table.
	load(DBTable[1])() --now DBTable is the table.
end --if _VERSION=='Lua 5.1' then

actualtree=Tree

--build tree
tree=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree)
end, --function(self)
SIZE="600x200",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}
-- Callback of the right mouse button click
function tree:rightclick_cb(id)
	tree.value = id
	menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function tree:rightclick_cb(id)
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
	elseif c == iup.K_cH then
			searchtext_replace.value=tree.title
			replacetext_replace.SELECTION="ALL"
			dlg_search_replace:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_Menu then
		menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function tree:k_any(c)

treeContent={branchname="Checklisenübersicht"}
for i,v in ipairs(DBTable) do
	treeContent[#treeContent+1]=i .. ": " .. tostring(v:match('^Tree={branchname="([^"]*)"'))
end --for i,v in ipairs(DBTable) do

--build tree
tree1=iup.tree{
map_cb=function(self)
self:AddNodes(treeContent)
end, --function(self)
SIZE="10x200",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="NO",
}
-- Callback of the left mouse button click
function tree1:executeleaf_cb(id)
	textbox0.value=id
end --function tree1:executeleaf_cb(id)


--7.4 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	--simply show a box with buttons
	iup.vbox{
		--first row of buttons
		iup.hbox{
			button_logo,
			button_save_code_with_datapart,
			button_search,
			button_replace,
			iup.label{size="5x",},
			button_new_tree,
			textbox0,
			button_load_tree,
			iup.fill{},
			textbox1,
			button_ticks_organise,
			button_save_ticks,
			iup.label{size="5x",},
			button_delete_tree,
			button_logo2,
		},
		
		iup.hbox{
			iup.frame{title="Checklistenübersicht",tree1,},
			iup.frame{title="Datenbereich im Skript",tree,},
			},

	},

	icon = img_logo,
	title = path .. " Documentation Tree",
	SIZE = 'FULLxFULL',
	BACKGROUND=color_background
}

--7.5 show the dialog
maindlg:show()


--7.5.1 take only datapart for ticks but save code text before and after it in variables
codeFlag_Tick="codeBeforeText"
codeBeforeText_Tick=""
dataPartText_Tick=""
codeAfterText_Tick=""
for line in io.lines(textbox1.value) do
	--if line:match("^DBTable=") then
	if line:match("^TickTable=") then
		codeFlag_Tick="dataPartText"
	end --if line:match("^DBTable=") then
	if codeFlag_Tick=="codeBeforeText" then
		codeBeforeText_Tick=codeBeforeText_Tick .. line .. "\n"
	elseif codeFlag_Tick=="dataPartText" then
		dataPartText_Tick=dataPartText_Tick .. line .. "\n"
	elseif codeFlag_Tick=="codeAfterText" then
		codeAfterText_Tick=codeAfterText_Tick .. line .. "\n"
	end --if codeBeforeFlag_Tick=="yes" then
	--if line:match("} %-%-DBTable=") then
	if line:match("%-%-TickTable=") then
		codeFlag_Tick="codeAfterText"
	end --if line:match("} %-%-DBTable=") then
end --for line in io.lines(textbox1.value) do


--7.5.2 load tree from file
if _VERSION=='Lua 5.1' then
	loadstring(dataPartText_Tick)()
else
	load(dataPartText_Tick)() --now TickTable is the table.
end --if _VERSION=='Lua 5.1' then

--7.5.3 add nodes with no html tags
TickTableAddTable={}
for k,v in pairs(TickTable) do
	if k:match(">([^>]*)") then
		TickTableAddTable[k:match(">([^>]*)")]=v --"tick"
	end --if k:match(">([^>]*)") then
end --for k,v in pairs(TickTable) do
for k,v in pairs(TickTableAddTable) do
	TickTable[k]=v --"tick"
end --for k,v in pairs(TickTableAddTable) do

--7.5.4 tick the nodes
for i=0,tree.count-1 do --loop for all nodes
	if TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="tick" then
		tree['image' .. i]=img_tick_leaf
		tree['imageexpanded' .. i]=img_tick_leaf
	elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio1" then
		tree['image' .. i]=img_prio1_leaf
		tree['imageexpanded' .. i]=img_prio1_leaf
	elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio2" then
		tree['image' .. i]=img_prio2_leaf
		tree['imageexpanded' .. i]=img_prio2_leaf
	elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio3" then
		tree['image' .. i]=img_prio3_leaf
		tree['imageexpanded' .. i]=img_prio3_leaf
	elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio1_tick" then
		tree['image' .. i]=img_tick_prio1_leaf
		tree['imageexpanded' .. i]=img_tick_prio1_leaf
	elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio2_tick" then
		tree['image' .. i]=img_tick_prio2_leaf
		tree['imageexpanded' .. i]=img_tick_prio2_leaf
	elseif TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="prio3_tick" then
		tree['image' .. i]=img_tick_prio3_leaf
		tree['imageexpanded' .. i]=img_tick_prio3_leaf
	end --if TickTable[tree['title' ..i]:gsub("&[^&]*;","")]=="tick" then
end --for i=0,tree.count-1 do --loop for all nodes


--7.6 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then
