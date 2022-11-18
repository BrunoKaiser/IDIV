--This script is a simple documentation of a tree in a Lua table

path_documentation_tree=arg[1] or "C:\\Tree\\SQLtoCSVforLua\\SQLtoCSVforLua_dependencies_tree.lua"
print(arg[0],arg[1])

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
search_found_number = iup.multiline{border="YES",expand="YES",} --textfield for search found number
searchtext_with = iup.multiline{border="YES",expand="YES", SELECTION="ALL",wordwrap="YES"} --textfield for search with additional criterion
searchtext_with2 = iup.multiline{border="YES",expand="YES", SELECTION="ALL",wordwrap="YES"} --textfield for search with additional criterion

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
	local numberFound=0
	--unmark all nodes
	for i=0, tree.count - 1 do
			tree["color" .. i]="0 0 0"
	end --for i=0, tree.count - 1 do
	--unmark all nodes end
	--mark all nodes
	for i=0, tree.count - 1 do
		if tree["title" .. i]:upper():match(searchtext.value:upper())~= nil then
			numberFound=numberFound+1
			iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
		end --if tree["title" .. i]:upper():match(searchtext.value:upper())~= nil then
	end --for i=0, tree2.count - 1 do
	--mark all nodes end
	search_found_number.value="Anzahl Fundstellen: " .. tostring(numberFound)
end --function searchmark:flat_action()

--search to mark without going to the any node
searchmark_with    = iup.flatbutton{title = "Markieren mit Zusatzkriterium",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function searchmark_with:flat_action()
	local numberFound_withCriterion=0
	local numberFound_withoutCriterion=0
	--unmark all nodes
	for i=0, tree.count - 1 do
			tree["color" .. i]="0 0 0"
	end --for i=0, tree.count - 1 do
	--unmark all nodes end
	--mark all nodes
	for i=0, tree.count - 1 do
		if tree["title" .. i]:upper():match(searchtext.value:upper())~= nil then
			--find tree parent under root
			iParentRoot=0
			for i1=i,1,-1 do
				if tree["parent" .. i1]=="0" then
					iParentRoot=i1
					--test with: searchtext_with.value=searchtext_with.value .. "/" .. tree['title' .. iParentRoot] 
					break 
				end --if tree["parent" .. i1]=="0" then
			end --for i1=i,1,-1 do
			--set criterion search
			if checkbox_criterion_with.value=="ON" then criteriumFound="OFF" else criteriumFound="ON" end --for OFF it is ON normally, but with search found it turns to OFF
			--test with: print("iParentRoot" .. iParentRoot)
			--test with: print(tree['totalchildcount' .. iParentRoot])
			for i2=iParentRoot,iParentRoot+tree['totalchildcount' .. iParentRoot] do
			if tree["title" .. i2]:upper():match(searchtext_with.value:upper()) then
				--test with: search_found_number.value=search_found_number.value .. tree["title" .. i2]
				criteriumFound=checkbox_criterion_with.value --"ON" for criteriumFound="OFF" otherwise the contrary
				break
			end --if tree["title" .. i2]:upper():match(searchtext_with.value:upper())==nil then
			end --for i2=iParentRoot,tree['totalchildcount' .. iParentRoot] do
			--mark with criterion
			if criteriumFound=="ON" then
				numberFound_withCriterion=numberFound_withCriterion+1
				iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})   --red
				iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})        --blue
				iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"}) --green
			else
				numberFound_withoutCriterion=numberFound_withoutCriterion+1
				iup.TreeSetAncestorsAttributes(tree,i,{color="243 0 243",})   --lila
				iup.TreeSetNodeAttributes(tree,i,{color="0 243 243",})        --turquoise
				iup.TreeSetDescendantsAttributes(tree,i,{color="243 243 0"})  --yellow
			end --if criteriumFound=="OFF" then
		end --if tree["title" .. i]:upper():match(searchtext.value:upper())~= nil then
	end --for i=0, tree2.count - 1 do
	--mark all nodes end
	search_found_number.value="Anzahl Fundstellen mit Kriterium: " .. tostring(numberFound_withCriterion) .. "\n" ..
				"Anzahl restliche Fundstellen ohne Kriterium: " .. tostring(numberFound_withoutCriterion)
end --function searchmark_with:flat_action()

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
checkbox_criterion_with = iup.toggle{title="Zusatzkriterium trifft zu", value="ON"} --checkbox for casesensitiv search
checkboxforsearchinfiles = iup.toggle{title="Suche in den Textdateien", value="OFF"} --checkbox for searcg in text files
search_label=iup.label{title="Suchfeld:"} --label for textfield
search_with_label=iup.label{title="Zusatzkriterium:"} --label for textfield

--put above together in a search dialog
dlg_search =iup.dialog{
			iup.vbox{iup.hbox{search_label,searchtext,}, 

			iup.label{title="Sonderzeichen: %. für ., %- für -, %+ für +, %% für %, %[ für [, %] für ], %( für (, %) für ), %^ für ^, %$ für $, %? für ?",},
			iup.hbox{searchmark,unmark,checkboxforsearchinfiles,
			}, 
			iup.hbox{search_with_label,searchtext_with,},
			iup.hbox{searchmark_with,checkbox_criterion_with},
			iup.label{title="rot: übergeordnete Knoten",fgcolor = "255 0 0", },
			iup.label{title="blau: gleicher Knoten",fgcolor = "0 0 255", },
			iup.label{title="grün: untergeordnete Knoten",fgcolor = "90 195 0", },

			iup.hbox{searchdown, searchup, 

			iup.vbox{
			checkboxforcasesensitive,},
			},
			iup.hbox{search_found_number,},
			}; 
		title="Suchen",
		size="420x170",
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

--4. dialogs end


--5. context menus (menus for right mouse click)

--5.1 menu of tree
--5.1.1 copy node of tree
startcopy = iup.item {title = "Knoten kopieren"}
function startcopy:action() --copy node
	 clipboard.text = tree['title']
end --function startcopy:action()

--5.1.2 copy node of tree
startexport_level = iup.item {title = "Export der Ebene als Liste nach Farben"}
function startexport_level:action()
	local exportTable={}
	exportTable["found"]={} --"0 0 250" --blue
	exportTable["ancestor"]={} --"255 0 0" --red
	exportTable["descendant"]={} --"90 195 0" --green
	exportTable["ancestor_rest"]={} --"243 0 243" --lila
	exportTable["found_rest"]={} --"0 243 243" --turquoise
	exportTable["descendant_rest"]={} --"243 243 0" --yellow
	exportTable["not found"]={} --"0 0 0" --black
	exportTable["rest"]={} --else
	levelNode=tree['depth' .. tree.value]
	--test with: print(levelNode)
	for i=1,tree.count-1 do 
		--test with: print(tree['color' .. i])
		if tree["depth" .. i]==levelNode then
		--test with: print(tree['title' .. i] .. ": " .. tree['color' .. i])
			if tree['color' .. i]=="255 0 0" then --red
				exportTable["ancestor"][#exportTable["ancestor"]+1]=tree['title' .. i]
			elseif tree['color' .. i]=="243 0 243" then --lila
				exportTable["ancestor_rest"][#exportTable["ancestor_rest"]+1]=tree['title' .. i]
			elseif tree['color' .. i]=="0 0 250" then --blue
				exportTable["found"][#exportTable["found"]+1]=tree['title' .. i]
			elseif tree['color' .. i]=="0 243 243" then --turquoise
				exportTable["found_rest"][#exportTable["found_rest"]+1]=tree['title' .. i]
			elseif tree['color' .. i]=="90 195 0" then --green
				exportTable["descendant"][#exportTable["descendant"]+1]=tree['title' .. i]
			elseif tree['color' .. i]=="243 243 0" then --yellow
				exportTable["descendant_rest"][#exportTable["descendant_rest"]+1]=tree['title' .. i]
			elseif tree['color' .. i]=="0 0 0" then --black
				exportTable["not found"][#exportTable["not found"]+1]=tree['title' .. i]
			else
				exportTable["rest"][#exportTable["rest"]+1]=tree['title' .. i]
			end --if tree['color' .. i]=="255 0 0" then
		end --if tree["depth" .. tree.value]==levelNode then
	end --for i=1,tree.count-1 do 
	table.sort(exportTable["ancestor"],function (a,b) return a<b end)
	table.sort(exportTable["ancestor_rest"],function (a,b) return a<b end)
	table.sort(exportTable["found"],function (a,b) return a<b end)
	table.sort(exportTable["found_rest"],function (a,b) return a<b end)
	table.sort(exportTable["descendant"],function (a,b) return a<b end)
	table.sort(exportTable["descendant_rest"],function (a,b) return a<b end)
	table.sort(exportTable["not found"],function (a,b) return a<b end)
	table.sort(exportTable["rest"],function (a,b) return a<b end)
	--test with: for k,v in pairs(exportTable["ancestor"]) do print(k,v) end
	local outputfile1=io.open(path .. "\\" .. thisfilename:gsub("%.lua","") .. "_search.html","w")
	outputfile1:write("<h1>Suchergebnisse der markierten Ebene </h1>\n")
	outputfile1:write("<h2> von " .. path .. "\\" .. thisfilename .. " </h2>\n")
	outputfile1:write("<h3> Ebene " .. levelNode .. "  </h3>\n")
	--https://www.w3schools.com/colors/colors_names.asp
	if #exportTable["found"]>0 then      outputfile1:write('<details><summary style="margin-left: 2em; color:blue">' .. #exportTable["found"] .. ' Treffer</summary>\n')        for k,v in pairs(exportTable["found"]) do      outputfile1:write('<p style="margin-left: 4em;margin-top: 0em;margin-bottom: 0em; color:blue">' .. v .. "</p>\n") end outputfile1:write('</details>\n') end
	if #exportTable["found_rest"]>0 then outputfile1:write('<details><summary style="margin-left: 2em; color:turquoise">' .. #exportTable["found_rest"] .. ' Restliche Treffer ohne Kriterium</summary>\n')        for k,v in pairs(exportTable["found_rest"]) do      outputfile1:write('<p style="margin-left: 4em;margin-top: 0em;margin-bottom: 0em; color:turquoise">' .. v .. "</p>\n") end outputfile1:write('</details>\n') end
	if #exportTable["ancestor"]>0 then  outputfile1:write('<details><summary style="margin-left: 2em; color:red">' .. #exportTable["ancestor"] .. ' Oberknoten</summary>\n')     for k,v in pairs(exportTable["ancestor"]) do  outputfile1:write('<p style="margin-left: 4em;margin-top: 0em;margin-bottom: 0em; color:red">' .. v .. "</p>\n") end outputfile1:write('</details>\n') end
	if #exportTable["ancestor_rest"]>0 then  outputfile1:write('<details><summary style="margin-left: 2em; color:fuchsia">' .. #exportTable["ancestor_rest"] .. ' Restliche Oberknoten ohne Kriterium</summary>\n')     for k,v in pairs(exportTable["ancestor_rest"]) do  outputfile1:write('<p style="margin-left: 4em;margin-top: 0em;margin-bottom: 0em; color:fuchsia">' .. v .. "</p>\n") end outputfile1:write('</details>\n') end
	if #exportTable["descendant"]>0 then outputfile1:write('<details><summary style="margin-left: 2em; color:greenyellow">' .. #exportTable["descendant"] .. ' Unterknoten</summary>\n')    for k,v in pairs(exportTable["descendant"]) do outputfile1:write('<p style="margin-left: 4em;margin-top: 0em;margin-bottom: 0em; color:greenyellow">' .. v .. "</p>\n") end outputfile1:write('</details>\n') end
	if #exportTable["descendant_rest"]>0 then outputfile1:write('<details><summary style="margin-left: 2em; color:yellow">' .. #exportTable["descendant_rest"] .. ' Restliche Unterknoten ohne Kriterium</summary>\n')    for k,v in pairs(exportTable["descendant_rest"]) do outputfile1:write('<p style="margin-left: 4em;margin-top: 0em;margin-bottom: 0em; color:yellow">' .. v .. "</p>\n") end outputfile1:write('</details>\n') end
	if #exportTable["not found"]>0 then  outputfile1:write('<details><summary style="margin-left: 2em">' .. #exportTable["not found"] .. ' Nicht gefunden</summary>\n') for k,v in pairs(exportTable["not found"]) do  outputfile1:write('<p style="margin-left: 4em;margin-top: 0em;margin-bottom: 0em">' .. v .. "</p>\n") end outputfile1:write('</details>\n') end
	if #exportTable["rest"]>0 then       outputfile1:write('<details><summary style="margin-left: 2em">' .. #exportTable["rest"] .. ' Rest</summary>\n')           for k,v in pairs(exportTable["rest"]) do       outputfile1:write('<p style="margin-left: 4em;margin-top: 0em;margin-bottom: 0em">' .. v .. "</p>\n") end outputfile1:write('</details>\n') end
	outputfile1:close()
end --function startexport_level:action()


--5.1.3 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,
		startexport_level,
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

--6.2.1 button for saving tree
button_save_lua_table=iup.flatbutton{title="Baum als Text speichern \n(Strg+P)", size="95x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
		printtree()
end --function button_save_lua_table:flat_action()

--6.2.2 button for exporting tree to csv
button_export_tree_to_csv=iup.flatbutton{title="Baum als CSV speichern", size="95x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_export_tree_to_csv:flat_action()
	numberColumnsTotal=0
	local pathTable={}
	for i=1,tree.count-1 do
		iParent=tree["PARENT" .. i]
		--print(iParent)
		pathTable[i]=tree['title' .. iParent] .. ";" .. tree['title' .. i]
		numberColumns=2
		while true do
			if tree['PARENT' .. iParent]==nil then break end
			numberColumns=numberColumns+1
			iParent=tree["PARENT" .. iParent]
			--test with: print(iParent)
			pathTable[i]=tree['title' .. iParent] .. ";" .. pathTable[i]
		end --while true do
		if numberColumns>numberColumnsTotal then numberColumnsTotal=numberColumns end
	end --for i=1,tree.count-1 do
	--open a filedialog
	filedlg2=iup.filedlg{dialogtype="SAVE",title="Ziel auswählen",filter="*.txt",filterinfo="Text Files", directory="c:\\temp"}
	filedlg2:popup(iup.ANYWHERE,iup.ANYWHERE)
	if filedlg2.status=="1" or filedlg2.status=="0" then
		local outputfile=io.output(filedlg2.value) --setting the outputfile
			for i=1,numberColumnsTotal-1 do outputfile:write("Field" .. i .. ";") end
			outputfile:write("Field" .. numberColumnsTotal .. "\n")
			for k,v in pairs(pathTable) do
				outputfile:write(v .. "\n")
			end --for k,v in pairs(pathTable) do
		outputfile:close() --close the outputfile
	else --no outputfile was choosen
		iup.Message("Schließen","Keine Datei ausgewählt")
		iup.NextField(maindlg)
	end --if filedlg2.status=="1" or filedlg2.status=="0" then
end --function button_export_tree_to_csv:flat_action()

--6.3 button for search in tree, tree2 and tree3
button_search=iup.flatbutton{title="Suchen\n(Strg+F)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
	searchtext.value=tree.title
	searchtext.SELECTION="ALL"
	dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_search:flat_action()

--6.4 button for expand and collapse
button_expand_collapse_dialog=iup.flatbutton{title="Ein-/Ausklappen\n(Strg+R)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_expand_collapse_dialog:flat_action()
	text_expand_collapse.value=tree.title
	dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_expand_collapse_dialog:flat_action()

--6.5 button for alphabetic sort of the tree
button_alphabetic_sort=iup.flatbutton{title="Alphabetisch sortieren\n(Strg+T)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_alphabetic_sort:flat_action()
	alphabetic_tree_sort(tree)
end --function button_alphabetic_sort:flat_action()

--6.6 button with second logo
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

--7.1.1 make leafs when branches to long
maxLength=259 --must be lower than 259 for a IUP tree
outputTextLeaf='Tree='
function makeLeafsLinebreakRecursive(TreeTable,outputTreeTable)
	outputTreeTable.branchname=TreeTable.branchname
	--whole line: outputTextLeaf=outputTextLeaf .. '{branchname="' .. TreeTable.branchname .. '",\n'
	--line with word wrap
	if #TreeTable.branchname>maxLength then
		--test with: print(#TreeTable.branchname)
		--collect words from textTable
		local wordTable={}
		for textWord in (TreeTable.branchname .. " "):gmatch(".- ") do 
			wordTable[#wordTable+1]=textWord 
		end --for textWord in (helpstring .. " "):gmatch(".- ") do 
		--put word in lines together with up to 259 characters until maxLength
		local lineTable={}
		local lineNumber=1
		lineTable[lineNumber]=""
		for i2,k2 in ipairs(wordTable) do 
			if #(lineTable[lineNumber] .. k2) > maxLength then 
				lineNumber=lineNumber+1
				lineTable[lineNumber]=k2
			else
				lineTable[lineNumber]=lineTable[lineNumber] .. k2
			end --if #(lineTable[lineNumber] .. k2) > maxLength then --259
		end --for i2,k2 in ipairs(wordTable) do 
		--put lines to the tree
		outputTextLeaf=outputTextLeaf .. '\n{branchname="' .. string.escape_forbidden_char(lineTable[1]:gsub(" $","")) .. '",'
		if TreeTable.state then outputTextLeaf=outputTextLeaf .. ' state="' .. TreeTable.state .. '",' end
		--test with: print(#lineTable)
		for i=2,#lineTable-1 do
			outputTextLeaf=outputTextLeaf .. '\n"' .. string.escape_forbidden_char(lineTable[i]:gsub(" $","")) .. '",'
		end --for i=2,#lineTable do
		outputTextLeaf=outputTextLeaf .. '\n"' .. string.escape_forbidden_char(lineTable[#lineTable]:gsub(" $","")) .. '",'
	else
		outputTextLeaf=outputTextLeaf .. '\n{branchname="' .. string.escape_forbidden_char(TreeTable.branchname:gsub(" $","")) .. '",'
		if TreeTable.state then outputTextLeaf=outputTextLeaf .. ' state="' .. TreeTable.state .. '",' end
	end --if #helpstring>maxLength then
	--test with: print("B " .. outputTreeTable.branchname)
	for i,v in ipairs(TreeTable) do
		if type(v)=="table" then
			--test with: print(v.branchname)
			outputTreeTable[i]={}
			makeLeafsLinebreakRecursive(v,outputTreeTable[i])
		else
			outputTreeTable[i]=v
			outputTextLeaf=outputTextLeaf .. '"' .. string.escape_forbidden_char(v) .. '",\n'
		end --if #TreeTable > 0 then
	end --for i,v in ipairs(TreeTable) do
	outputTextLeaf=outputTextLeaf .. '},\n'
end --function makeLeafsLinebreakRecursive(TreeTable,outputTreeTable)
outputtree_tabtext_script={}
makeLeafsLinebreakRecursive(actualtree,outputtree_tabtext_script)
outputTextLeaf=outputTextLeaf:gsub("},\n$","}\n")
--test with: print(outputTextLeaf)
if _VERSION=='Lua 5.1' then
	loadstring(outputTextLeaf)()
else
	load(outputTextLeaf)() --now Tree is the table.
end --if _VERSION=='Lua 5.1' then
--7.1.1 make leafs when branches to long end

--7.1.2 build tree
tree=iup.tree{
map_cb=function(self)
self:AddNodes(Tree) --without leaf making: (actualtree)
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


--7.2 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	--simply show a box with buttons
	iup.vbox{
		--first row of buttons
		iup.hbox{
			button_logo,
			button_save_lua_table,
			button_export_tree_to_csv,
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

--7.3 show the dialog
maindlg:show()

--7.4 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then

