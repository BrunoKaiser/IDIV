--This script is a simple documentation of a tree in a Lua table on the right side which is build from content of web side on the left side. The content of the web site with wiki TeX formulas can be transforned in pure html-code



--1. basic data

--1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iupluaweb")        --require iupluaweb for webbrowser



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



path_documentation_tree=path .. "\\documentation_tree_webpage_search_output.lua"
path_documentation_text=path .. "\\documentation_tree_webpage_search_output.txt"


--3. functions

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
	filedlg2=iup.filedlg{dialogtype="SAVE",title="Ziel auswählen",filter="*.txt",filterinfo="Text Files", directory="c:\\temp"}
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

--4. dialogs


--4.1 search dialog
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

--4.1 search dialog end

--4.2 expand and collapse dialog

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

--4.2 expand and collapse dialog end



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

--5.1.4 add branch of tree from clipboard
addbranch_fromclipboard = iup.item {title = "Ast aus Zwischenablage"}
function addbranch_fromclipboard:action()
	tree.addbranch = clipboard.text
	tree.value=tree.value+1
end --function addbranch_fromclipboard:action()



--5.1.2 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,
		addbranch_fromclipboard, 
		}
--5.1 menu of tree end



--5.2 menu of tree2
--5.2.1 copy node of tree2
startcopy2 = iup.item {title = "Knoten kopieren"}
function startcopy2:action() --copy node
	 clipboard.text = tree2['title']
end --function startcopy2:action()

--5.2.2 start the file or repository of the node of tree2
startnode2 = iup.item {title = "Starten"}
function startnode2:action() 
	if tree2['title']:match("^.:\\.*%.[^\\ ]+$") or tree2['title']:match("^.:\\.*[^\\]+$") or tree2['title']:match("^.:\\$") or tree2['title']:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "D" "' .. tree2['title'] .. '"') 
	elseif tree2['title']:match("sftp .*") then 
		os.execute(tree2['title']) 
	end --if tree2['title']:match("^.:\\.*%.[^\\ ]+$") or tree2['title']:match("^.:\\.*[^\\]+$") or tree2['title']:match("^.:\\$") or tree2['title']:match("^[^ ]*//[^ ]+$") then 
end --function startnode2:action()



--5.2.2 put the menu items together in the menu for tree
menu2 = iup.menu{
		startcopy2,
		startnode2,
		}
--5.2 menu of tree end


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

--6.2 button for saving tree
button_save_lua_table=iup.flatbutton{title="Baum als Lua-Tabelle \nspeichern (Strg+P)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	--printtree()
	save_tree_to_lua(tree, path_documentation_tree)
end --function button_save_lua_table:flat_action()

--6.2.1 button for loading text from text file or loading standard text file
button_load_text=iup.flatbutton{title="Text \nladen", size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_load_text:flat_action()
	local inputfile_text
	if tree2['TITLE']:match(path .. ".*%.txt$") and file_exists(tree2['TITLE']) then
		inputfile_text=io.open(tree2['TITLE'],"r")
		textbox2.value=tree2['TITLE']
	else
		inputfile_text=io.open(path_documentation_text,"r")
		textbox2.value=path_documentation_text
	end --if tree2['TITLE']:match(path .. ".*%.txt$") then
	textbox1.value=inputfile_text:read("*all")
	inputfile_text:close()
end --function button_load_text:flat_action()

--6.2.2 button for saving text in text file
button_save_text=iup.flatbutton{title="Text \nspeichern", size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_text:flat_action()
	local outputfile_text
	if tree2['TITLE']:match(path .. ".*%.txt$") then
		outputfile_text=io.open(tree2['TITLE'],"w")
	else
		outputfile_text=io.open(path_documentation_text,"w")
	end --if tree2['TITLE']:match(path .. ".*%.txt$") then
	outputfile_text:write(textbox1.value)
	outputfile_text:close()
end --function button_save_text:flat_action()

--6.3 button for search in tree, tree2 and tree3
button_search=iup.flatbutton{title="Suchen\n(Strg+F)", size="35x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
	searchtext.value=tree.title
	searchtext.SELECTION="ALL"
	dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_search:flat_action()

--6.4 button for expand and collapse
button_expand_collapse_dialog=iup.flatbutton{title="Ein-/Ausklappen\n(Strg+R)", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_expand_collapse_dialog:flat_action()
	text_expand_collapse.value=tree.title
	dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_expand_collapse_dialog:flat_action()

--6.4.1 button for replacing in tree
button_replace=iup.flatbutton{title="Suchen und Ersetzen\n(Strg+H)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_replace:flat_action()
	searchtext_replace.value=tree.title
	replacetext_replace.SELECTION="ALL"
	dlg_search_replace:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_replace:flat_action()

--6.5 button for alphabetic sort of the tree
button_alphabetic_sort=iup.flatbutton{title="Alphabetisch sortieren\n(Strg+T)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_alphabetic_sort:flat_action()
	alphabetic_tree_sort(tree)
end --function button_alphabetic_sort:flat_action()

--6.6 button for going to first page
button_first_page=iup.flatbutton{title="Seite \nladen", size="35x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_first_page:flat_action()
	textbox0.value=tree.title:match('href="([^"]*)"')
	webbrowser1.HTML=[[

<a href="]] .. textbox0.value .. [[">]] .. textbox0.value .. [[</a>

]]
end --function button_first_page:flat_action()

--6.7 button for going to the next page
button_next_page=iup.flatbutton{title="Nächste \nSeite", size="35x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_next_page:flat_action()
	tree.value=tree.value+1
	textbox0.value=tree.title:match('href="([^"]*)"')
	webbrowser1.HTML=[[

<a href="]] .. textbox0.value .. [[">]] .. textbox0.value .. [[</a>

]]
end --function button_next_page:flat_action()

--6.8 button for going to the previous page
button_previous_page=iup.flatbutton{title="Vorige \nSeite", size="35x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_previous_page:flat_action()
	tree.value=tree.value-1
	textbox0.value=tree.title:match('href="([^"]*)"')
	webbrowser1.HTML=[[

<a href="]] .. textbox0.value .. [[">]] .. textbox0.value .. [[</a>

]]
end --function button_previous_page:flat_action()

--6.9 button for going to the page
button_page_hyperlinks_in_tree=iup.flatbutton{title="Hyperlinks im Baum \nübernehmen", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_page_hyperlinks_in_tree:flat_action()
	nodeInTreeTable={}
	for i=0,tree.count-1 do
		nodeInTreeTable[tree['TITLE' .. i]]=true
	end --for i=0,tree.count-1 do
	--test with: for k,v in pairs(nodeInTreeTable) do print(k,v) end
	--tree.value=0
	tree.addbranch = '<a href="' .. textbox0.value .. '">'
	tree.value=tree.value+1
	numberOfHyperlinks=0
	for line in (textbox1.value .. "\n"):gmatch("([^\n]*)\n") do
		line=line:gsub("A HREF","a href"):gsub("</A>","</a>")
		local lineFound=""
		if line:match("<a .*href") then
			lineFound=line:gsub('title="[^"]*"',''):gsub('<a .-href="','<a href="'):gsub("<img[^>]*/>",""):match("<a .-href.-</a>"):gsub("\t","")
			if nodeInTreeTable[lineFound]==nil then
				--test with: print(tostring(nodeInTreeTable[lineFound]) .. ": " .. lineFound)
				nodeInTreeTable[lineFound]=true
				--test with: print(line)
				numberOfHyperlinks=numberOfHyperlinks+1
				if numberOfHyperlinks==1 then
					tree.addbranch = lineFound
				else
					tree.insertbranch = lineFound
				end --if numberOfHyperlinks==1 then
				tree.value=tree.value+1
			end --if nodeInTreeTable[lineFound]==nil then
			--test with: print("----> " .. line:match("<a .*href.-</a>"):gsub("\t",""):gsub("<img[^>]>",""))
		end --if line:match("href") then
	end --for line in (textbox1 .. "\n"):gmatch("([^\n*])\n") do
end --function button_page_hyperlinks_in_tree:flat_action()



--6.10 button for transformation of the webpage with mathematical expressions
button_transform_page=iup.flatbutton{title="Seite mit Formeln\numwandeln", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_transform_page:flat_action()
	textInput=textbox1.value
	--1. transform basic code from wikipedia, aspecially with linebreaks
	outputfile_txt=io.open("C:\\Temp\\test_first.txt","w")
	textInput=textInput:gsub('.*<body[^>]*>(.*)</body>',"%1")
			:gsub('%[[^%]]*%]',"")
			:gsub('|%-\n!',"<tr><td>")
			:gsub("|%-\n| '''","<tr><td>")
			:gsub('<span class="mwe%-math%-element">.-</span><img.-alt="{\\displaystyle (.-)}"/></span>',"$\\it{%1}$")
			:gsub(":<math>(.-)</math>",":<mathE>%1</mathE>")
			:gsub("&nbsp;"," ")
			:gsub("&#160;"," ")
	outputfile_txt:write(textInput)
	outputfile_txt:close()
	--
	--2. write a tex file
	outputfile_tex=io.open("C:\\Temp\\test.tex","w")
	outputfile_tex:write([[
	\documentclass{article}

	\begin{document}

	]])
	for line in io.lines("C:\\Temp\\test_first.txt") do
		line=line:gsub(":<mathE>","\\begin{equation}\\it{\n")
			:gsub("</mathE>%.",".\n}\\end{equation}")
			:gsub("</mathE>,",",\n}\\end{equation}")
			:gsub("</mathE>","\n}\\end{equation}")
			:gsub("<math>","$\\it{")
			:gsub("</math>","}$")
			:gsub("^{\\displaystyle(.*)}.$","\\begin{equation}\\it{\n%1.\n}\\end{equation}")
			:gsub("^{\\displaystyle(.*)},$","\\begin{equation}\\it{\n%1,\n}\\end{equation}")
			:gsub("^{\\displaystyle(.*)}$","\\begin{equation}\\it{\n%1\n}\\end{equation}")
			:gsub("{\\displaystyle(.-)}","$\\it{%1}$")
			:gsub("%%","\\%%")
			:gsub('{| class="wikitable"',"<table border=1>")
			:gsub('!!',"</td><td>")
			:gsub('||',"</td><td>")
			:gsub('|}',"</table>")
			:gsub("'''","")
			:gsub("^=[^=]","<h1>"):gsub("[^=]=$","</h1>")
			:gsub("^==[^=]","<h2>"):gsub("[^=]==$","</h2>")
			:gsub("^===[^=]","<h3>"):gsub("[^=]===$","</h3>")
			:gsub("^====[^=]","<h4>"):gsub("[^=]====$","</h4>")
			:gsub("^=====[^=]","<h4>"):gsub("[^=]=====$","</h5>")
		outputfile_tex:write(line .. "\n")
	end --for line in io.lines("C:\\Temp\\test_first.txt") do
	outputfile_tex:write([[

	\end{document}

	]])
	outputfile_tex:close()
	--
	--3. transform tex file in html with tth from http://hutchinson.belmont.ma.us/tth/tth-noncom/download.html
	os.execute('C:\\tth_exe\\tth.exe <c:\\Temp\\test.tex >c:\\Temp\\test_roh.html')
	--
	--4. produce final html file
	outputfile_html=io.open("C:\\Temp\\test.html","w")
	for line in io.lines("C:\\Temp\\test_roh.html") do
		line=line:gsub("&lt;ref&#62;"," (")
			:gsub("&lt;/ref&#62;",") ")
			:gsub("&lt;","<")
			:gsub("&#62;",">")
			:gsub("&#187;",'">')
			:gsub("#! ?",'')
			:gsub('<table class="wikitable">','<table class="wikitable" border=1>')
		outputfile_html:write(line .. "\n")
	end --for line in io.lines("C:\\Temp\\test_roh.html") do
	outputfile_html:close()
	--5. write in GUI
	inputfile_html=io.open("C:\\Temp\\test.html","r")
	inputTextHtml=inputfile_html:read("*all")
	webbrowser2.HTML=inputTextHtml
	inputfile_html:close()
end --function button_transform_page:flat_action()


--6.11 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nidiv.kaiser@t-online.de")
end --function button_logo:flat_action()

--6. buttons end


--7. Main Dialog

--7.1 textboxes
textbox0=iup.multiline{value="https://www.lua.org",size="240x20",wordwrap="YES"}
textbox1=iup.multiline{value="",size="250x150"}
textbox2=iup.multiline{value="Textdatei s.u.",size="190x20",wordwrap="YES"}
textbox2.value=path_documentation_text

--7.2 webbrowser
webbrowser1=iup.webbrowser{HTML=[[

<a href="]] .. textbox0.value .. [[">]] .. textbox0.value .. [[</a>

]],MAXSIZE="500x730"}
actualPage=1
webbrowser2=iup.webbrowser{HTML=[[

Ergebnis

]],MAXSIZE="370x730"}

--7.2.1 load tree from file
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
else
	actualtree={branchname="Internetinhalte als Baum"}
end --if file_exists(path_documentation_tree) then
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
	elseif c == iup.K_cR then -- expand collapse dialog
		text_expand_collapse.value=tree.title
		dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_cT then -- alphabetic tree sort
		alphabetic_tree_sort(tree)
	elseif c == iup.K_cF then
			searchtext.value=tree.title
			searchtext.SELECTION="ALL"
			dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_Menu then
		menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function tree:k_any(c)

--7.2.2 load standard text file
if file_exists(path_documentation_text) then
	local inputfile_text=io.open(path_documentation_text,"r")
	textbox1.value=inputfile_text:read("*all")
	inputfile_text:close()
end --if file_exists(path_documentation_text) then

--7.2.3 load tree2 from file
Tree2={branchname="Öffnen der Internetseite",
{branchname="Ast im manuellen Baum markieren",
{branchname="Schaltfläche Seite laden",
{branchname="Auf den Hyperlink klicken",
{branchname="rechte Maustaste",
{branchname="Aus dem Kontextmenü Quellcode anzeigen",
{branchname="Aus dem Notepad-Editor alles markieren und kopieren",
{branchname="Einfügen in Inhalte als Text",
"Schaltfläche Hyperlinks im Baum übernehmen",
{branchname="Schaltfläche Seite mit Formeln umwandeln",
"Ergebnis kopieren oder als PDF abspeichern",
},
},
},
},
},
},
},
},
{branchname="Formelsammlungen herstellen",
{branchname=path .. "\\Formelsammlung_1.txt",path .. "\\Formelsammlung_1.pdf",},
{branchname=path .. "\\Formelsammlung_2.txt",path .. "\\Formelsammlung_2.pdf",},
{branchname=path .. "\\Formelsammlung_3.txt",path .. "\\Formelsammlung_3.pdf",},
},
}
--build tree2
tree2=iup.tree{
map_cb=function(self)
self:AddNodes(Tree2)
end, --function(self)
SIZE="10x100",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}
-- Callback of the right mouse button click
function tree2:rightclick_cb(id)
	tree2.value = id
	menu2:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function tree:rightclick_cb(id)
-- Callback for pressed keys
function tree2:k_any(c)
	if c == iup.K_Menu then
		menu2:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function tree:k_any(c)

--7.3 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	--simply show a box with buttons
	iup.vbox{
		--first row of buttons
		iup.hbox{
			button_logo,
			button_save_lua_table,
			button_load_text,
			textbox2,
			button_save_text,
			button_search,
			button_replace,
			button_expand_collapse_dialog,
			button_alphabetic_sort,
			textbox0,
			iup.label{size="10x",},
			button_first_page,
			button_previous_page,
			button_next_page,
			button_page_hyperlinks_in_tree,
			button_transform_page,
			iup.label{size="10x",},
			iup.fill{},
			button_logo2,
		},
		
		iup.hbox{
			iup.frame{title="Webbrowser Inhalte",iup.vbox{webbrowser1,iup.frame{title="Webbrowser Hilfe",tree2,},}},
			iup.frame{title="Inhalte als Text",iup.vbox{textbox1,webbrowser2,}},
			iup.frame{title="Manuelle Zuordnung als Baum",tree,},
			},

	},

	icon = img_logo,
	title = path .. " Documentation Tree",
	SIZE = 'FULLxFULL',
	BACKGROUND=color_background
}

--7.3.1 show the dialog
maindlg:show()

--7.4 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then

