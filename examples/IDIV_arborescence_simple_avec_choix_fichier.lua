--This script is a simple documentation of a tree in a Lua table with a file dialog

actualtree={branchname="Standard-Baumansicht",
arg[0]}
--dofile("filename_with_actualtree_also_possible.lua")

--1. basic data

--1.1 libraries
require("iuplua")           --require iuplua for GUIs


--1.2 initalize clipboard
clipboard=iup.clipboard{}

--2.1 color section
--2.1.1 color of the console associated with the graphical user interface if started with lua54.exe and not wlua54.exe
os.execute('color 71')

--2.1.2 colors
color_red="135 131 28"
color_light_color_grey="96 197 199"
color_grey="162 163 165"
color_blue="18 132 86"

--2.1.3 color definitions
color_background=color_light_color_grey
color_buttons=color_blue -- works only for flat buttons
color_button_text="255 255 255"
color_background_tree="246 246 246"


--2.2 path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)


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





--3.2 functions for writing text files

--3.2.1 function for writing tree in a text file (function for printing tree)
function printtree()
	--open a filedialog
	filedlg2=iup.filedlg{dialogtype="SAVE",title="Ziel auswählen",filter="*.txt",filterinfo="Text Files", directory=path}
	filedlg2:popup(iup.ANYWHERE,iup.ANYWHERE)
	if filedlg2.status=="1" or filedlg2.status=="0" then
		local outputfile=io.output(filedlg2.value) --setting the outputfile
		for i=0,tree.totalchildcount0 do
			local helper=tree['title' .. i]
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

--3.2.4 function which saves the current iup tree as a Lua table
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



--3.3 function to change expand/collapse relying on depth
--This function is needed in the expand/collapsed dialog. This function relies on the depth of the given level.
function change_state_level(new_state,level,descendants_also)
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
end --function change_state_level(new_state,level,descendants_also)


--3.4 function to change expand/collapse relying on keyword
--This function is needed in the expand/collapsed dialog. This function changes the state for all nodes, which match a keyword. Otherwise it works like change_stat_level.
function change_state_keyword(new_state,keyword,descendants_also)
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
end --function change_state_keyword(new_state,level,descendants_also)


--3.5 function for sorting the tree alphabetically
--3.5.1 first a recursive function for the performed insertion sort
function insertion_sort_recursive(tree,node_value)
	tree.value=node_value
	change_state_level("COLLAPSED",tree.depth,"YES") --collapse all nodes below current one
	if tree.NEXT~=nil then --check if the node exists
		if tree.title:lower() > tree["title" .. tree.NEXT]:lower() then --next brother is smaller, so swap needed
			tree.MOVENODE=tree.NEXT --swaps current node with brother, but does not change tree.value
			if tree.PREVIOUS~=nil then
				insertion_sort_recursive(tree,tree.PREVIOUS)
			end --if tree.PREVIOUS~=nil then
		end --if tree.title:lower() > tree["title" .. tree.NEXT]:lower() then 
	end --if tree.NEXT~=nil then
end --function insertion_sort_recursive(tree,node_value)

--3.5.2 function that sorts effectively
function alphabetic_tree_sort(tree)
	local total_depth_of_tree="0" --determine total depth of tree, as this sorting has to be iterated for this depth in order to reach all levels.
	for i=1,tree.count-1 do
		if tree["depth" .. i]>total_depth_of_tree then
			total_depth_of_tree=tree["depth" .. i]
		end --if tree["depth" .. i]>total_depth_of_tree then
	end --for i=1,tree.count-1 do
	for j=1,total_depth_of_tree do
		for i=1,tree.count-1 do --sort beginning from every node, except for position 0
			tree.value=i --set to current value
			change_state_level("COLLAPSED",tree.depth,"YES") --collapse all nodes below current one
			insertion_sort_recursive(tree,i)
		end --for i=1,tree.count-1 do
	end --for j=1,total_depth_of_tree do
	change_state_level("EXPANDED","0","YES") --expand all branches again
end --function alphabetic_tree_sort(tree)

--3.5.3 function that sorts ascending whole Lua table with tree but not the tree in IUP
function sortascendingTableRecursive(aTable)
	table.sort(aTable,function(a,b) if type(a)=="table" then aT=tostring(a.branchname) else aT=tostring(a) end if type(b)=="table" then bT=tostring(b.branchname) else bT=tostring(b) end aTl=aT:lower() bTl=bT:lower() return aTl<bTl end)
	for i,v in ipairs(aTable) do
		if type(v)=="table" then
			sortascendingTableRecursive(v)
		end --if type(v)=="table" then
	end --for i,v in ipairs(aTable)
end --function sortascendingTableRecursive(aTable)

--3.5.4 function that sorts descending whole Lua table with tree but not the tree in IUP
function sortdescendingTableRecursive(aTable)
	table.sort(aTable,function(a,b) if type(a)=="table" then aT=tostring(a.branchname) else aT=tostring(a) end if type(b)=="table" then bT=tostring(b.branchname) else bT=tostring(b) end aTl=aT:lower() bTl=bT:lower() return aTl>bTl end)
	for i,v in ipairs(aTable) do
		if type(v)=="table" then
			sortdescendingTableRecursive(v)
		end --if type(v)=="table" then
	end --for i,v in ipairs(aTable)
end --function sortdescendingTableRecursive(aTable)


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
			iup.hbox{searchmark,unmark,checkboxforsearchinfiles,
			}, 
			iup.label{title="rot: übergeordnete Knoten",fgcolor = "255 0 0", },
			iup.label{title="blau: gleicher Knoten",fgcolor = "0 0 255", },
			iup.label{title="grün: untergeordnete Knoten",fgcolor = "90 195 0", },

			iup.hbox{searchdown, searchup, 

			iup.vbox{
			checkboxforcasesensitive,},
			},

			}; 
		title="Suchen",
		size="420x100",
		startfocus=searchtext
		}

--4.2 search dialog end

--4.3 expand and collapse dialog

--function needed for the expand and collapse dialog
function button_expand_collapse(new_state)
	if toggle_level.value=="ON" then
		if checkbox_descendants_collapse.value=="ON" then
			change_state_level(new_state,tree.depth,"YES")
		else
			change_state_level(new_state,tree.depth)
		end --if checkbox_descendants_collapse.value="ON" then
	elseif toggle_keyword.value=="ON" then
		if checkbox_descendants_collapse.value=="ON" then
			change_state_keyword(new_state,text_expand_collapse.value,"YES")
		else
			change_state_keyword(new_state,text_expand_collapse.value)
		end --if checkbos_descendants_collapse.value=="ON" then
	end --if toggle_level.value="ON" then
end --function button_expand_collapse(new_state)

--button for expanding branches
expand_button=iup.flatbutton{title="Ausklappen",size="EIGHTH",BGCOLOR=color_buttons,FGCOLOR=color_button_text}
function expand_button:flat_action()
	button_expand_collapse("EXPANDED") --call above function with expand as new state
end --function expand_button:flat_action()

--button for collapsing branches
collapse_button=iup.flatbutton{title="Einklappen",size="EIGHTH",BGCOLOR=color_buttons,FGCOLOR=color_button_text}
function collapse_button:flat_action()
	button_expand_collapse("COLLAPSED") --call above function with collapsed as new state
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

--4.3 expand and collapse dialog end


--4.4 replace dialog

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
--4.4 replace dialog end

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

--5.1.3.1 add branch to tree by insertbranch
addbranchbottom = iup.item {title = "Ast darunter hinzufügen"}
function addbranchbottom:action()
	tree["insertbranch" .. tree.value] = ""
	for i=tree.value+1,tree.count-1 do
		if tree["depth" .. i]==tree["depth" .. tree.value] then
			tree.value=i
			renamenode:action()
			break
		end --if tree["depth" .. tree.value+1]==tree["depth" .. tree.value] then
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
	tree["insertbranch" .. tree.value] = clipboard.text
	for i=tree.value+1,tree.count-1 do
	if tree["depth" .. i]==tree["depth" .. tree.value] then
		tree.value=i
		break
	end --if tree["depth" .. tree.value+1]==tree["depth" .. tree.value] then
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


--5.1.7.1 cut of all leafs of a node
cut_leafs_of_node = iup.item {title = "Alle Blätter darunter ausschneiden"}
function cut_leafs_of_node:action()
	local startNodeNumber=tree.value
	local endNodeNumber=tree.value+tree.totalchildcount
	local levelStartNode=tree['depth']
	leafTable={}
	for i=endNodeNumber,startNodeNumber+1,-1 do
		tree.value=i
		if tree['KIND']=="LEAF" and tree['depth']==tostring(levelStartNode+1) then
			leafTable[#leafTable+1]=tree['title']
			tree.delnode = "SELECTED"
		end --if tree['KIND']=="LEAF" then
	end --for i=endNodeNumber,startNodeNumber,-1 do
end --function cut_leafs_of_node:action()

--5.1.7.2 cut of all nodes of a node
cut_nodes_of_node = iup.item {title = "Alle Knoten darunter ausschneiden"}
function cut_nodes_of_node:action()
	local startNodeNumber=tree.value
	local endNodeNumber=tree.value+tree.totalchildcount
	local levelStartNode=tree['depth']
	local levelOldNode=tree['depth']
	nodeText='tree_nodes={branchname="' .. string.escape_forbidden_char(tree['title']) .. '",\n'
	for i=startNodeNumber+1,endNodeNumber do
		tree.value=i
		--test with: nodeText=nodeText .. '\n von: ' .. tonumber(levelOldNode) .. " zu: " .. tonumber(tree['depth']) .. '\n'
		--end curly brakets
		if tonumber(levelOldNode)>tonumber(tree['depth']) then 
			for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(tree['depth'])) do 
				nodeText=nodeText .. '},\n' 
			end --for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(tree['depth'])) do 
 		end --if tonumber(levelOldNode)>tonumber(tree['depth']) then 
		levelOldNode=tree['depth']
		--take branch or leaf
		if tree['KIND']=="BRANCH" and tonumber(tree['depth'])>=levelStartNode+1 then
			nodeText=nodeText .. '{branchname="' .. string.escape_forbidden_char(tree['title']) .. '",\n' 
		elseif tree['KIND']=="LEAF" and tonumber(tree['depth'])>=levelStartNode+1 then
			nodeText=nodeText .. '"' .. string.escape_forbidden_char(tree['title']) .. '",\n' 
		end --if tree['KIND']=="LEAF" then
	end --for i=endNodeNumber,startNodeNumber,-1 do
	--test with: nodeText=nodeText .. '\n von: ' .. tonumber(levelOldNode) .. " zu: " .. tonumber(levelStartNode) .. '\n'
	--end curly brakets
	if tonumber(levelOldNode)>tonumber(levelStartNode) then 
		for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(levelStartNode)) do 
			nodeText=nodeText .. '}'
			if i<math.tointeger(tonumber(levelOldNode)-tonumber(levelStartNode)) then 
				nodeText=nodeText .. ',\n'
			end --if i<math.tointeger(tonumber(levelOldNode)-tonumber(levelStartNode)) then 
		end --for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(tree['depth'])) do 
	end --if tonumber(levelOldNode)>tonumber(tree['depth']) then 
	--delete nodes
	for i=endNodeNumber,startNodeNumber+1,-1 do
		tree.value=i
		if tree['KIND']=="BRANCH" and tree['depth']>=tostring(levelStartNode+1) then
			tree.delnode = "SELECTED"
		elseif tree['KIND']=="LEAF" and tree['depth']>=tostring(levelStartNode+1) then
			tree.delnode = "SELECTED"
		end --if tree['KIND']=="LEAF" then
	end --for i=endNodeNumber,startNodeNumber,-1 do
	--test with: print(nodeText)
	--load tree_nodes Lua table
	load(nodeText)()
	--test with: for k,v in pairs(tree_nodes) do print(k,v) if type(v)=="table" then for k1,v1 in pairs(v) do print(k1,v1) end end end
	--test add tree_nodes to node: tree:AddNodes(tree_nodes,startNodeNumber)
end --function cut_nodes_of_node:action()

--5.1.7.3 copy of all leafs of a node
copy_leafs_of_node = iup.item {title = "Alle Blätter darunter kopieren"}
function copy_leafs_of_node:action()
	local startNodeNumber=tree.value
	local endNodeNumber=tree.value+tree.totalchildcount
	local levelStartNode=tree['depth']
	leafTable={}
	for i=endNodeNumber,startNodeNumber+1,-1 do
		tree.value=i
		if tree['KIND']=="LEAF" and tree['depth']==tostring(levelStartNode+1) then
			leafTable[#leafTable+1]=tree['title']
		end --if tree['KIND']=="LEAF" then
	end --for i=endNodeNumber,startNodeNumber,-1 do
end --function copy_leafs_of_node:action()

--5.1.7.4 copy of all nodes of a node
copy_nodes_of_node = iup.item {title = "Alle Knoten darunter kopieren"}
function copy_nodes_of_node:action()
	local startNodeNumber=tree.value
	local endNodeNumber=tree.value+tree.totalchildcount
	local levelStartNode=tree['depth']
	local levelOldNode=tree['depth']
	nodeText='tree_nodes={branchname="' .. string.escape_forbidden_char(tree['title']) .. '",\n'
	for i=startNodeNumber+1,endNodeNumber do
		tree.value=i
		--test with: nodeText=nodeText .. '\n von: ' .. tonumber(levelOldNode) .. " zu: " .. tonumber(tree['depth']) .. '\n'
		--end curly brakets
		if tonumber(levelOldNode)>tonumber(tree['depth']) then 
			for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(tree['depth'])) do 
				nodeText=nodeText .. '},\n' 
			end --for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(tree['depth'])) do 
 		end --if tonumber(levelOldNode)>tonumber(tree['depth']) then 
		levelOldNode=tree['depth']
		--take branch or leaf
		if tree['KIND']=="BRANCH" and tonumber(tree['depth'])>=levelStartNode+1 then
			nodeText=nodeText .. '{branchname="' .. string.escape_forbidden_char(tree['title']) .. '",\n' 
		elseif tree['KIND']=="LEAF" and tonumber(tree['depth'])>=levelStartNode+1 then
			nodeText=nodeText .. '"' .. string.escape_forbidden_char(tree['title']) .. '",\n' 
		end --if tree['KIND']=="LEAF" then
	end --for i=endNodeNumber,startNodeNumber,-1 do
	--test with: nodeText=nodeText .. '\n von: ' .. tonumber(levelOldNode) .. " zu: " .. tonumber(levelStartNode) .. '\n'
	--end curly brakets
	if tonumber(levelOldNode)>tonumber(levelStartNode) then 
		for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(levelStartNode)) do 
			nodeText=nodeText .. '}'
			if i<math.tointeger(tonumber(levelOldNode)-tonumber(levelStartNode)) then 
				nodeText=nodeText .. ',\n'
			end --if i<math.tointeger(tonumber(levelOldNode)-tonumber(levelStartNode)) then 
		end --for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(tree['depth'])) do 
	end --if tonumber(levelOldNode)>tonumber(tree['depth']) then 
	--test with: print(nodeText)
	--load tree_nodes Lua table
	load(nodeText)()
	--test with: for k,v in pairs(tree_nodes) do print(k,v) if type(v)=="table" then for k1,v1 in pairs(v) do print(k1,v1) end end end
	--test add tree_nodes to node: tree:AddNodes(tree_nodes,startNodeNumber)
end --function copy_nodes_of_node:action()

--5.1.7.5 paste of all leafs of a node
paste_leafs_of_node = iup.item {title = "Alle Blätter darunter einfügen"}
function paste_leafs_of_node:action()
	if leafTable then
		for i=#leafTable,1,-1 do
			tree.addleaf = leafTable[i]
			tree.value=tree.value+1
		end --for i=#leafTable,1,-1 do
	end --if leafTable then
end --function paste_leafs_of_node:action()

--5.1.7.6 paste of all nodes of a node
paste_nodes_of_node = iup.item {title = "Alle Knoten darunter einfügen"}
function paste_nodes_of_node:action()
	if tree_nodes then
		tree:AddNodes(tree_nodes,tree.value)
	end --if tree_nodes then
end --function paste_nodes_of_node:action()

--5.1.7.7 paste of all nodes of a node in an ascending order
paste_nodes_of_node_sorted_ascending = iup.item {title = "Alle Knoten darunter aufsteigend sortiert einfügen"}
function paste_nodes_of_node_sorted_ascending:action()
	sortascendingTableRecursive(tree_nodes)
	if tree_nodes then
		tree:AddNodes(tree_nodes,tree.value)
	end --if tree_nodes then
end --function paste_nodes_of_node_sorted_ascending:action()

--5.1.7.8 paste of all nodes of a node in a descending order
paste_nodes_of_node_sorted_descending = iup.item {title = "Alle Knoten darunter absteigend sortiert einfügen"}
function paste_nodes_of_node_sorted_descending:action()
	sortdescendingTableRecursive(tree_nodes)
	if tree_nodes then
		tree:AddNodes(tree_nodes,tree.value)
	end --if tree_nodes then
end --function paste_nodes_of_node_sorted_descending:action()


--5.1.7.9 alphabetic sort of leafs ascending case sensitive
alphabetic_sort_leafs_of_node_ascending_case_sensitive = iup.item {title = "Alle Blätter darunter alphabetisch nach Klein- und Großbuchstaben aufsteigend sortieren"}
function alphabetic_sort_leafs_of_node_ascending_case_sensitive:action()
	local startNodeNumber=tree.value
	local endNodeNumber=tree.value+tree.totalchildcount
	local levelStartNode=tree['depth']
	local leafTable={}
	for i=endNodeNumber,startNodeNumber+1,-1 do
		tree.value=i
		if tree['KIND']=="LEAF" and tree['depth']==tostring(levelStartNode+1) then
			leafTable[#leafTable+1]=tree['title']
			tree.delnode = "SELECTED"
		end --if tree['KIND']=="LEAF" then
	end --for i=endNodeNumber,startNodeNumber,-1 do
	table.sort(leafTable,function(a,b) return a<b end)
	--test with: for i,v in ipairs(leafTable) do print(i,v) end
	tree.value=startNodeNumber
	for i,v in ipairs(leafTable) do
		tree.addleaf = v
		tree.value=tree.value+1
	end --for i,v in ipairs(leafTable) do
end --function alphabetic_sort_leafs_of_node_ascending_case_sensitive:action()

--5.1.7.10 alphabetic sort of leafs ascending case insensitive
alphabetic_sort_leafs_of_node_ascending_case_insensitive = iup.item {title = "Alle Blätter darunter alphabetisch aufsteigend sortieren"}
function alphabetic_sort_leafs_of_node_ascending_case_insensitive:action()
	local startNodeNumber=tree.value
	local endNodeNumber=tree.value+tree.totalchildcount
	local levelStartNode=tree['depth']
	local leafTable={}
	for i=endNodeNumber,startNodeNumber+1,-1 do
		tree.value=i
		if tree['KIND']=="LEAF" and tree['depth']==tostring(levelStartNode+1) then
			leafTable[#leafTable+1]=tree['title']
			tree.delnode = "SELECTED"
		end --if tree['KIND']=="LEAF" then
	end --for i=endNodeNumber,startNodeNumber,-1 do
	table.sort(leafTable,function(a,b) local al=a:lower() local bl=b:lower() return al<bl end)
	--test with: for i,v in ipairs(leafTable) do print(i,v) end
	tree.value=startNodeNumber
	for i,v in ipairs(leafTable) do
		tree.addleaf = v
		tree.value=tree.value+1
	end --for i,v in ipairs(leafTable) do
end --function alphabetic_sort_leafs_of_node_ascending_case_insensitive:action()


--5.1.7.11 alphabetic sort of leafs ascending case sensitive
alphabetic_sort_leafs_of_node_descending_case_sensitive = iup.item {title = "Alle Blätter darunter alphabetisch nach Klein- und Großbuchstaben absteigend sortieren"}
function alphabetic_sort_leafs_of_node_descending_case_sensitive:action()
	local startNodeNumber=tree.value
	local endNodeNumber=tree.value+tree.totalchildcount
	local levelStartNode=tree['depth']
	local leafTable={}
	for i=endNodeNumber,startNodeNumber+1,-1 do
		tree.value=i
		if tree['KIND']=="LEAF" and tree['depth']==tostring(levelStartNode+1) then
			leafTable[#leafTable+1]=tree['title']
			tree.delnode = "SELECTED"
		end --if tree['KIND']=="LEAF" then
	end --for i=endNodeNumber,startNodeNumber,-1 do
	table.sort(leafTable,function(a,b) return a>b end)
	--test with: for i,v in ipairs(leafTable) do print(i,v) end
	tree.value=startNodeNumber
	for i,v in ipairs(leafTable) do
		tree.addleaf = v
		tree.value=tree.value+1
	end --for i,v in ipairs(leafTable) do
end --function alphabetic_sort_leafs_of_node_descending_case_sensitive:action()

--5.1.7.12 alphabetic sort of leafs ascending case insensitive
alphabetic_sort_leafs_of_node_descending_case_insensitive = iup.item {title = "Alle Blätter darunter alphabetisch absteigend sortieren"}
function alphabetic_sort_leafs_of_node_descending_case_insensitive:action()
	local startNodeNumber=tree.value
	local endNodeNumber=tree.value+tree.totalchildcount
	local levelStartNode=tree['depth']
	local leafTable={}
	for i=endNodeNumber,startNodeNumber+1,-1 do
		tree.value=i
		if tree['KIND']=="LEAF" and tree['depth']==tostring(levelStartNode+1) then
			leafTable[#leafTable+1]=tree['title']
			tree.delnode = "SELECTED"
		end --if tree['KIND']=="LEAF" then
	end --for i=endNodeNumber,startNodeNumber,-1 do
	table.sort(leafTable,function(a,b) local al=a:lower() local bl=b:lower() return al>bl end)
	--test with: for i,v in ipairs(leafTable) do print(i,v) end
	tree.value=startNodeNumber
	for i,v in ipairs(leafTable) do
		tree.addleaf = v
		tree.value=tree.value+1
	end --for i,v in ipairs(leafTable) do
end --function alphabetic_sort_leafs_of_node_descending_case_insensitive:action()

--5.1.13 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,
		startcopy_doubling,
		renamenode, 
		addbranch,
		addbranch_fromclipboard, 
		addbranchbottom,  
		addbranch_fromclipboardbottom, 
		addleaf,
		addleaf_fromclipboard,
		addleafbottom,
		addleaf_fromclipboardbottom,
		copy_leafs_of_node,
		copy_nodes_of_node,
		cut_leafs_of_node,
		cut_nodes_of_node,
		paste_leafs_of_node,
		paste_nodes_of_node,
		paste_nodes_of_node_sorted_ascending,
		paste_nodes_of_node_sorted_descending,
		alphabetic_sort_leafs_of_node_ascending_case_sensitive,
		alphabetic_sort_leafs_of_node_ascending_case_insensitive,
		alphabetic_sort_leafs_of_node_descending_case_sensitive,
		alphabetic_sort_leafs_of_node_descending_case_insensitive,
		}
--5.1 menu of tree end


--5. context menus (menus for right mouse click) end


--6. buttons
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
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nidiv.kaiser@t-online.de")
end --function button_logo:flat_action()

--6.2 button for loading tree
button_loading_lua_table=iup.flatbutton{title="Baum aus Lua Tabelle laden\n(Strg+O)", size="115x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_loading_lua_table:flat_action()
	--build file dialog for reading Lua file
	local filedlg=iup.filedlg{dialogtype="OPEN",title="Datei öffnen",filter="*.lua",filterinfo="Lua Files",directory=path}
	filedlg:popup(iup.ANYWHERE,iup.ANYWHERE) --show the file dialog
	if filedlg.status=="1" then
		iup.Message("Neue Datei",filedlg.value)
	elseif filedlg.status=="0" then --this is the usual case, when a file was choosen
	--load tree from file 
		inputfile1=io.open(filedlg.value,"r")
		treeTable=inputfile1:read("*all"):match("[^=]+=(%b{})")
		inputfile1:close()
		--save table in the variable actualtree
		--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
		if _VERSION=='Lua 5.1' then
			loadstring('actualtree='..treeTable)()	
		else
			load('actualtree='..treeTable)() --now actualtree is the table.
		end --if _VERSION=='Lua 5.1' then
		iup.TreeAddNodes(tree,actualtree)
	else
		iup.Message("Die Baumansicht wird nicht aktualisiert","Es wurde keine Datei ausgewählt")
		iup.NextField(maindlg)
	end --if filedlg.status=="1" then

end --function button_loading_lua_table:flat_action()

--6.3.1 button for saving tree
button_save_lua_table=iup.flatbutton{title="Baum als Lua-Tabelle speichern \n(Strg+L)", size="125x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	--open a filedialog
	filedlg2=iup.filedlg{dialogtype="SAVE",title="Ziel auswählen",filter="*.lua",filterinfo="Lua Files", directory=path}
	filedlg2:popup(iup.ANYWHERE,iup.ANYWHERE)
	if filedlg2.status=="1" or filedlg2.status=="0" then
			save_tree_to_lua(tree, filedlg2.value)
	else --no outputfile was choosen
		iup.Message("Schließen","Keine Datei ausgewählt")
		iup.NextField(maindlg)
	end --if filedlg2.status=="1" or filedlg2.status=="0" then
end --function button_save_lua_table:flat_action()

--6.3.2 button for saving tree
button_save_lua_table_as_text=iup.flatbutton{title="Baum als Text speichern \n(Strg+P)", size="95x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table_as_text:flat_action()
	printtree()
end --function button_save_lua_table_as_text:flat_action()

--6.4 button for search in tree, tree2 and tree3
button_search=iup.flatbutton{title="Suchen\n(Strg+F)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
	searchtext.value=tree.title
	searchtext.SELECTION="ALL"
	dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_search:flat_action()

--6.5 button for expand and collapse
button_expand_collapse_dialog=iup.flatbutton{title="Ein-/Ausklappen\n(Strg+R)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_expand_collapse_dialog:flat_action()
	text_expand_collapse.value=tree.title
	dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_expand_collapse_dialog:flat_action()

--6.6 button for alphabetic sort of the tree
button_alphabetic_sort=iup.flatbutton{title="Alphabetisch sortieren\n(Strg+T)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_alphabetic_sort:flat_action()
	alphabetic_tree_sort(tree)
end --function button_alphabetic_sort:flat_action()

--6.7 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nidiv.kaiser@t-online.de")
end --function button_logo:flat_action()

--6. buttons end


--7. Main Dialog

--7.1 build tree
tree=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree)
end, --function(self)
SIZE="400x200",
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
	elseif c == iup.K_cP then -- added output of current table to a text file
		printtree()
	elseif c == iup.K_cL then -- added output of current table to a Lua file
		button_save_lua_table:flat_action()
	elseif c == iup.K_cR then -- expand collapse dialog
		text_expand_collapse.value=tree.title
		dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_cT then -- alphabetic tree sort
		alphabetic_tree_sort(tree)
	elseif c == iup.K_cO then -- alphabetic tree sort
		button_loading_lua_table:flat_action()
	elseif c == iup.K_cF then
			searchtext.value=tree.title
			searchtext.SELECTION="ALL"
			dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_Menu then
		menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function tree:k_any(c)


--7.2 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	--simply show a box with buttons
	iup.vbox{
		--first row of buttons
		iup.hbox{
			button_logo,
			button_loading_lua_table,
			button_save_lua_table,
			button_save_lua_table_as_text,
			button_search,
			button_expand_collapse_dialog,
			button_alphabetic_sort,
			iup.label{size="10x",},
			iup.fill{},
			button_logo2,
		},
		
		iup.hbox{
			iup.frame{title="Manuelle Zuordnung als Baum",tree,},
			},

	},

	icon = img_logo,
	title = path .. " Documentation Tree",
	SIZE = 'FULLxFULL',
	BACKGROUND=color_background
}

--7.2.1 show the dialog
maindlg:show()

--7.3 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then

