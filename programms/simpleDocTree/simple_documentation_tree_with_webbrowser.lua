--This script is a simple documentation of a tree in a Lua table on the left side with a webbrowser on the right side

path_documentation_tree="C:\\Tree\\simpleDocTree\\example_tree_for_webbrowser.lua"
textHTML_file="C:\\Tree\\simpleDocTree\\example_HTML_table_for_webbrowser.lua"


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

--4. dialogs end


--5. context menus (menus for right mouse click)

--5.1 menu of tree
--5.1.1 copy node of tree
startcopy = iup.item {title = "Knoten kopieren"}
function startcopy:action() --copy node
	 clipboard.text = tree['title']
end --function startcopy:action()



--5.1.2 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,
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
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de")
end --function button_logo:flat_action()

--6.2 button for saving tree
button_save_lua_table=iup.flatbutton{title="Baum als Text speichern \n(Strg+P)", size="95x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
		printtree()
end --function button_save_lua_table:flat_action()

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

--6.6 button for going to first page
button_first_page=iup.flatbutton{title="Startseite", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_first_page:flat_action()
	webbrowser1.HTML=TextHTMLtable[1]
end --function button_first_page:flat_action()

--6.7 button for going to the next page
button_next_page=iup.flatbutton{title="Nächste Seite", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_next_page:flat_action()
	if actualPage<#TextHTMLtable then actualPage=actualPage+1 end
	webbrowser1.HTML=TextHTMLtable[actualPage]
	textbox1.value=actualPage
end --function button_next_page:flat_action()

--6.8 button for going to the previous page
button_previous_page=iup.flatbutton{title="Vorige Seite", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_previous_page:flat_action()
	if actualPage>1 then actualPage=actualPage-1 end
	webbrowser1.HTML=TextHTMLtable[actualPage]
	textbox1.value=actualPage
end --function button_previous_page:flat_action()

--6.9 button for going to the page
button_goto_page=iup.flatbutton{title="Gehe zu Seite\nvom Knoten", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_goto_page:flat_action()
	if tonumber(tree['title']) then 
		actualPage=math.tointeger(tonumber(tree['title'])) 
		webbrowser1.HTML=TextHTMLtable[actualPage]
		textbox1.value=tree['title']
		actualPage=tonumber(tree['title'])
	else
		--test with: iup.Message("Text",tostring(TextHTMLtable[textbox1.value]))
		if TextHTMLtable[tree['title']] then
			webbrowser1.HTML=TextHTMLtable[tree['title']]
			textbox1.value=tree['title']
		else
			textbox1.value=tree['title'] .. " hat keine Webpage"
		end --if TextHTMLtable[tree['title']] then
	end --if tonumber(textbox1.value) then 
end --function button_goto_page:flat_action()


--6.10 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de")
end --function button_logo:flat_action()

--6. buttons end


--7. Main Dialog

--7.1 textboxes
textbox1=iup.text{value="1",size="90x20",alignment="ACENTER"}

--7.2 webbrowser
dofile(textHTML_file)
webbrowser1=iup.webbrowser{HTML=TextHTMLtable[1],MAXSIZE="630x730"}
actualPage=1

--7.3 load tree from file
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
--build tree
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

--7.4 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	--simply show a box with buttons
	iup.vbox{
		--first row of buttons
		iup.hbox{
			button_logo,
			button_save_lua_table,
			button_search,
			button_expand_collapse_dialog,
			button_alphabetic_sort,
			iup.label{size="40x",},
			button_first_page,
			button_previous_page,
			button_next_page,
			button_goto_page,
			textbox1,
			iup.label{size="30x",},
			iup.fill{},
			button_logo2,
		},
		
		iup.hbox{
			iup.frame{title="Manuelle Zuordnung als Baum",tree,},
			iup.frame{title="Webbrowser Inhalte",iup.vbox{webbrowser1,}},
			},

	},

	icon = img_logo,
	title = path .. " Documentation Tree",
	SIZE = 'FULLxFULL',
	BACKGROUND=color_background
}

--7.4.1 show the dialog
maindlg:show()

--7.5 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then

