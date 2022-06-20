--This script runs a graphical user interface (GUI) in order to built up a documentation tree of the current repository and a documentation of related files and repositories. It displays the tree saved in documentation_tree.lua
--1. basic data

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


--1.1.4 securisation by allowing only necessary os.execute commands
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


--2.1 path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)


--test with (status before installment): for k,v in pairs(installTable) do print(k,v) end



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

--3.1.3 general function for distance between texts
function string.levenshtein(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost = 0
        -- quick cut-offs to save time
	if (len1 == 0) then
		return len2
	elseif (len2 == 0) then
		return len1
	elseif (str1 == str2) then
		return 0
	end --if (len1 == 0) then
	-- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end --for i = 0, len1, 1 do
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end --for j = 0, len2, 1 do
	-- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if (str1:byte(i) == str2:byte(j)) then
				cost = 0
			else
				cost = 1
			end --if (str1:byte(i) == str2:byte(j)) then
			matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
		end --for j = 1, len2, 1 do
	end --for i = 1, len1, 1 do
	-- return the last value - this is the Levenshtein distance
	return matrix[len1][len2]
end --function string.levenshtein(str1, str2)

--3.2 function to change expand/collapse relying on depth
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

--3.2.1 function which saves the current iup tree as a Lua table
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

--3.3 function to change expand/collapse relying on keyword
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

--3 functions end


--4. dialogs

--4.1 expand and collapse dialog

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

--4.1 expand and collapse dialog end

--4. dialogs end

--5. no context menus

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

--6.2 button for loading tree 1
button_loading_lua_table_1=iup.flatbutton{title="Ersten Baum aus Lua \nTabelle laden", size="115x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_loading_lua_table_1:flat_action()
	tree1.delnode0 = "CHILDREN"
	tree1.title=''
	if file_exists(textbox1.value) then
		--load tree from file 
		inputfile1=io.open(textbox1.value,"r")
		inputText=inputfile1:read("*all")
		inputfile1:close()
		treeTable=inputText:match("[^=]+=(%b{})")
		if treeTable:match('{ *branchname *= *"')==nil then firstEqualPosition=inputText:find("=") treeTable=inputText:sub(firstEqualPosition+1) end
		--save table in the variable actualtree
		--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
		if _VERSION=='Lua 5.1' then
			loadstring('actualtree='..treeTable)()	
		else
			load('actualtree='..treeTable)() --now actualtree is the table.
		end --if _VERSION=='Lua 5.1' then
		iup.TreeAddNodes(tree1,actualtree)
	else
		--build file dialog for reading Lua file
		local filedlg=iup.filedlg{dialogtype="OPEN",title="Datei öffnen",filter="*.lua",filterinfo="Lua Files",directory=path}
		filedlg:popup(iup.ANYWHERE,iup.ANYWHERE) --show the file dialog
		if filedlg.status=="1" then
			iup.Message("Neue Datei",filedlg.value)
		elseif filedlg.status=="0" then --this is the usual case, when a file was choosen
			--load tree from file 
			textbox1.value=filedlg.value
			inputfile1=io.open(filedlg.value,"r")
			inputText=inputfile1:read("*all")
			inputfile1:close()
			treeTable=inputText:match("[^=]+=(%b{})")
			if treeTable:match('{ *branchname *= *"')==nil then firstEqualPosition=inputText:find("=") treeTable=inputText:sub(firstEqualPosition+1) end
			--save table in the variable actualtree
			--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
			if _VERSION=='Lua 5.1' then
				loadstring('actualtree='..treeTable)()	
			else
				load('actualtree='..treeTable)() --now actualtree is the table.
			end --if _VERSION=='Lua 5.1' then
			iup.TreeAddNodes(tree1,actualtree)
		else
			iup.Message("Die Baumansicht wird nicht aktualisiert","Es wurde keine Datei ausgewählt")
			iup.NextField(maindlg)
		end --if filedlg.status=="1" then
	end --if file_exists(textbox1.value) then
	textbox1_2.value="Anzahl Knoten: " .. tree1.totalchildcount0
end --function button_loading_lua_table_1:flat_action()

--6.3 button for loading tree 2
button_loading_lua_table_2=iup.flatbutton{title="Zweiten Baum aus Lua \nTabelle laden", size="115x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_loading_lua_table_2:flat_action()
	tree2.delnode0 = "CHILDREN"
	tree2.title=''
	if file_exists(textbox2.value) then
		--load tree2 from file
		inputfile2=io.open(textbox2.value,"r")
		inputText=inputfile2:read("*all")
		inputfile2:close()
		treeTable=inputText:match("[^=]+=(%b{})")
		if treeTable:match('{ *branchname *= *"')==nil then firstEqualPosition=inputText:find("=") treeTable=inputText:sub(firstEqualPosition+1) end
		--save table in the variable actualtree
		--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
		if _VERSION=='Lua 5.1' then
			loadstring('actualtree='..treeTable)()	
		else
			load('actualtree='..treeTable)() --now actualtree is the table.
		end --if _VERSION=='Lua 5.1' then
		iup.TreeAddNodes(tree2,actualtree)
	else
		--build file dialog for reading Lua file
		local filedlg=iup.filedlg{dialogtype="OPEN",title="Datei öffnen",filter="*.lua",filterinfo="Lua Files",directory=path}
		filedlg:popup(iup.ANYWHERE,iup.ANYWHERE) --show the file dialog
		if filedlg.status=="1" then
			iup.Message("Neue Datei",filedlg.value)
		elseif filedlg.status=="0" then --this is the usual case, when a file was choosen
			--load tree2 from file
			textbox2.value=filedlg.value
			inputfile2=io.open(filedlg.value,"r")
			inputText=inputfile2:read("*all")
			inputfile2:close()
			treeTable=inputText:match("[^=]+=(%b{})")
			if treeTable:match('{ *branchname *= *"')==nil then firstEqualPosition=inputText:find("=") treeTable=inputText:sub(firstEqualPosition+1) end
			--save table in the variable actualtree
			--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
			if _VERSION=='Lua 5.1' then
				loadstring('actualtree='..treeTable)()	
			else
				load('actualtree='..treeTable)() --now actualtree is the table.
			end --if _VERSION=='Lua 5.1' then
			iup.TreeAddNodes(tree2,actualtree)
		else
			iup.Message("Die Baumansicht wird nicht aktualisiert","Es wurde keine Datei ausgewählt")
			iup.NextField(maindlg)
		end --if filedlg.status=="1" then
	end --if file_exists(textbox2.value) then
	textbox2_2.value="Anzahl Knoten: " .. tree2.totalchildcount0
end --function button_loading_lua_table_2:flat_action()

--6.4 button for expand and collapse
button_expand_collapse_dialog=iup.flatbutton{title="Ein-/Ausklappen", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_expand_collapse_dialog:flat_action()
	text_expand_collapse.value=tree.title
	dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_expand_collapse_dialog:flat_action()


--6.5 button for comparing text file of tree and text file of tree2
button_compare=iup.flatbutton{title="Baumstrukturen \nvergleichen", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_compare:flat_action()
	tree.delnode0 = "CHILDREN"
	tree.title='compare'
	--make the comparison
	--go through tree 2
	local tree_script={branchname="compare",{branchname="Vergleich von " .. tostring(textbox1.value) .. " mit " .. tostring(textbox2.value)}}
	local file2existsTable={}
	local file2numberTable={}
	for i=0,tree2.totalchildcount0 do
		local line=tree2['TITLE' .. i]
		file2numberTable[#file2numberTable+1]=line
		file2existsTable[line]=#file2numberTable
	end --for i=0,tree1.totalchildcount0 do
	--go through tree 1
	local lineNumber=0
	local file1existsTable={}
	for i=0,tree1.totalchildcount0 do
		local line=tree1['TITLE' .. i]
		file1existsTable[line]=true
		lineNumber=lineNumber+1
		if line==file2numberTable[lineNumber] then
			if tree_script[#tree_script].branchname=="gleich" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="gleich"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			end --if tree_script[#tree_script].branchname=="gleich" then
		elseif file2existsTable[line] and lineNumber>file2existsTable[line] then
			if tree_script[#tree_script].branchname=="gleich siehe oben" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="gleich siehe oben"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			end --if tree_script[#tree_script].branchname=="gleich siehe oben" then
		elseif file2existsTable[line] and lineNumber<file2existsTable[line] then
			if tree_script[#tree_script].branchname=="gleich siehe unten" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="gleich siehe unten"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=lineNumber .. ": " .. line
			end --if tree_script[#tree_script].branchname=="gleich siehe unten" then
		else
			--without Levenshtein distance: tree_script[#tree_script+1]={branchname="unterschiedlich",{branchname=lineNumber .. ": " .. line,lineNumber .. ": " .. tostring(file2numberTable[lineNumber])}}
			tree_script[#tree_script+1]={branchname="unterschiedlich",{branchname=lineNumber .. ": " .. line,{branchname=lineNumber .. ": " .. tostring(file2numberTable[lineNumber]) ,"Levenshtein-Distanz: " .. string.levenshtein(line, tostring(file2numberTable[lineNumber]))}}}
		end --if file2Table[line] then
	end --for i=0,tree1.totalchildcount0 do
	--go through tree 1 to search for missing lines in tree 2
	local line1Number=0
	for i=0,tree1.totalchildcount0 do
		local line=tree1['TITLE' .. i]
		line1Number=line1Number+1
		if file2existsTable[line]==nil then
			if tree_script[#tree_script].branchname=="nur in erster Datei" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line1Number .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="nur in erster Datei"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line1Number .. ": " .. line
			end --if tree_script[#tree_script].branchname=="nur in erster Datei" then
		end --if file2existsTable[line] then
	end --for i=0,tree1.totalchildcount0 do
	--go through tree 2 to search for missing lines in tree 1
	local line2Number=0
	for i=0,tree2.totalchildcount0 do
		local line=tree2['TITLE' .. i]
		line2Number=line2Number+1
		if file1existsTable[line]==nil then
			if tree_script[#tree_script].branchname=="nur in zweiter Datei" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line2Number .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="nur in zweiter Datei"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line2Number .. ": " .. line
			end --if tree_script[#tree_script].branchname=="nur in zweiter Datei" then
		end --if file1existsTable[line] then
	end --for i=0,tree2.totalchildcount0 do
	--build the compare tree
	iup.TreeAddNodes(tree,tree_script)
end --function button_compare:flat_action()

--6.6 button for sorting text file of tree with text file of tree2 to a tree with parent child
button_sort_with_tree=iup.flatbutton{title="Gemeinsame Kategorien \nbilden", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_sort_with_tree:flat_action()
	tree.delnode0 = "CHILDREN"
	tree.title='categories'
	--make the sort
	local titleTable={}
	--go through tree 2
	local tree_script={branchname="categories",{branchname="Kategorien von " .. tostring(textbox1.value) .. " in " .. tostring(textbox2.value)}}
	titleTable["categories"]=true
	titleTable["Kategorien von " .. tostring(textbox1.value) .. " in " .. tostring(textbox2.value)]=true
	local file2ParentTable={}
	file2ParentTable[tree2['TITLE' .. 0]]="root"
	for i=1,tree2.totalchildcount0 do 
		file2ParentTable[tree2['TITLE' .. i]]=tree2['TITLE' .. tree2['PARENT' .. i]]
	end --for i=0,tree1.totalchildcount0 do
	--go through tree 1 to search for missing lines in tree 2
	local line1Number=0
	local treeSortedTable={}
	for i=0,tree1.totalchildcount0 do
		local line=tree1['TITLE' .. i]
		line1Number=line1Number+1
		if file2ParentTable[line]==nil then
			if treeSortedTable["nur im ersten Baum"] then
				treeSortedTable["nur im ersten Baum"][#treeSortedTable["nur im ersten Baum"]+1]=line
			else
				treeSortedTable["nur im ersten Baum"]={line}
			end --if treeSortedTable["nur im ersten Baum"] then
		else
			if treeSortedTable[file2ParentTable[line]] then
				treeSortedTable[file2ParentTable[line]][#treeSortedTable[file2ParentTable[line]]+1]=line
			else
				treeSortedTable[file2ParentTable[line]]={line}
			end --if treeSortedTable[file2ParentTable[line]] then
		end --if file2existsTable[line] then
	end --for i=0,tree1.totalchildcount0 do
	tree_script[#tree_script][#tree_script[#tree_script]+1]={branchname=tree2['TITLE' .. 0],tree1['TITLE' .. 0]}
	for i=0,tree2.totalchildcount0 do
		if treeSortedTable[tree2['TITLE' .. i]] then
			for i1,v1 in ipairs(treeSortedTable[tree2['TITLE' .. i]]) do
				if tree_script[#tree_script].branchname==tree2['TITLE' .. i] then
					tree_script[#tree_script][#tree_script[#tree_script]+1]=v1
				else
					tree_script[#tree_script+1]={branchname=tree2['TITLE' .. i]}
					tree_script[#tree_script][#tree_script[#tree_script]+1]=v1
				end --if tree_script[#tree_script].branchname==tree2['TITLE' .. i] then
			end --for i1,v1 in ipairs(treeSortedTable[tree2['TITLE' .. i]]) do
		end --if treeSortedTable[tree2['TITLE' .. i]] then
	end --for i=0,tree2.totalchildcount0 do
	titleTable["nur im ersten Baum"]=true
	if treeSortedTable["nur im ersten Baum"] then
		for i1,v1 in ipairs(treeSortedTable["nur im ersten Baum"]) do
			if tree_script[#tree_script].branchname=="nur im ersten Baum" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=v1
			else
				tree_script[#tree_script+1]={branchname="nur im ersten Baum"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=v1
			end --if tree_script[#tree_script].branchname=="nur im ersten Baum" then
		end --for i1,v1 in ipairs(treeSortedTable["nur im ersten Baum"]) do
	end --if treeSortedTable["nur im ersten Baum"] then
	--build the sorted tree
	iup.TreeAddNodes(tree,tree_script)
	--go through tree 1
	local file1existsTable={}
	for i=0,tree1.totalchildcount0 do
		file1existsTable[tree1['TITLE' .. i]]=true
	end --for i=0,tree1.totalchildcount0 do
	--mark the tree in blue for nodes from tree 1
	for i=0,tree.totalchildcount0 do
		if titleTable[tree['TITLE' .. i]] then
			tree["color" .. i]="250 0 0"
		elseif file1existsTable[tree['TITLE' .. i]] then
			tree["color" .. i]="0 0 250"
		else
			tree["color" .. i]=color_grey
		end --if file1existsTable[tree2['TITLE' .. i]]==nil and tree2['totalchildcount' .. i]=="0" then
	end --for i=tree.totalchildcount0,0,-1 do
end --function button_sort_with_tree:flat_action()

--6.7 button for sorting text file of tree in text file of tree2 to tree deleting not needed nodes
button_sort_in_tree=iup.flatbutton{title="Übereinstimmungen \nfinden", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_sort_in_tree:flat_action()
	if file_exists(textbox1.value) and file_exists(textbox2.value) then
		tree.delnode0 = "CHILDREN"
		tree.title=''
		--load tree2 from file in compare tree
		inputfile2=io.open(textbox2.value,"r")
		inputText=inputfile2:read("*all")
		inputfile2:close()
		treeTable=inputText:match("[^=]+=(%b{})")
		if treeTable:match('{ *branchname *= *"')==nil then firstEqualPosition=inputText:find("=") treeTable=inputText:sub(firstEqualPosition+1) end
		--save table in the variable actualtree
		--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
		if _VERSION=='Lua 5.1' then
			loadstring('actualtree='..treeTable)()	
		else
			load('actualtree='..treeTable)() --now actualtree is the table.
		end --if _VERSION=='Lua 5.1' then
		iup.TreeAddNodes(tree,actualtree)
		--go through tree 1
		local file1existsTable={}
		for i=0,tree1.totalchildcount0 do
			file1existsTable[tree1['TITLE' .. i]]=true
		end --for i=0,tree1.totalchildcount0 do
		for i=tree.totalchildcount0,1,-1 do
			if file1existsTable[tree['TITLE' .. i]]==nil and tree['totalchildcount' .. i]=="0" then
				tree["delnode" .. i] = "SELECTED"
			end --if file1existsTable[tree2['TITLE' .. i]]==nil and tree2['totalchildcount' .. i]=="0" then
		end --for i=tree.totalchildcount0,0,-1 do
		--go through tree 2
		local file2existsTable={}
		local file2numberTable={}
		for i=0,tree2.totalchildcount0 do
			local line=tree2['TITLE' .. i]
			file2numberTable[#file2numberTable+1]=line
			file2existsTable[line]=#file2numberTable
		end --for i=0,tree1.totalchildcount0 do
		--go through tree 1 to search for missing lines in tree 2
		local titleTable={}
		local tree_script={branchname="rest",{branchname="Übereinstimmungen von " .. tostring(textbox1.value) .. " in " .. tostring(textbox2.value)}}
		titleTable["nur in erster Datei"]=true
		titleTable["Übereinstimmungen von " .. tostring(textbox1.value) .. " in " .. tostring(textbox2.value)]=true
		local line1Number=0
		for i=0,tree1.totalchildcount0 do
			local line=tree1['TITLE' .. i]
			line1Number=line1Number+1
			if file2existsTable[line]==nil then
				if tree_script[#tree_script].branchname=="nur in erster Datei" then
					tree_script[#tree_script][#tree_script[#tree_script]+1]=line
				else
					tree_script[#tree_script+1]={branchname="nur in erster Datei"}
					tree_script[#tree_script][#tree_script[#tree_script]+1]=line
				end --if tree_script[#tree_script].branchname=="nur in erster Datei" then
			end --if file2existsTable[line] then
		end --for i=0,tree1.totalchildcount0 do
		--add results which tree is sorted by which and
		local searchDiff3=0
		for i1=tree.totalchildcount0,0,-1 do
			if tree['depth' .. i1]=="1" then break end
			searchDiff3=searchDiff3+1
			--test with: print(searchDiff3)
		end --for i1=i,0,-1 do
		--test with: print(tree.totalchildcount0,searchDiff3)
		tree['insertbranch' .. math.tointeger(math.max(tree.totalchildcount0-searchDiff3,0))]="Ergebnisse"
		titleTable["Ergebnisse"]=true
		--build the tree of not sorted nodes
		iup.TreeAddNodes(tree,tree_script,tree.totalchildcount0)
		--mark the tree in blue for nodes from tree 1
		for i=0,tree.totalchildcount0 do
			if titleTable[tree['TITLE' .. i]] then
				tree["color" .. i]="250 0 0"
			elseif file1existsTable[tree['TITLE' .. i]] then
				tree["color" .. i]="0 0 250"
			else
				tree["color" .. i]=color_grey
			end --if file1existsTable[tree2['TITLE' .. i]]==nil and tree2['totalchildcount' .. i]=="0" then
		end --for i=tree.totalchildcount0,0,-1 do
	end --if file_exists(textbox1.value) and file_exists(textbox2.value) then
end --function button_sort_in_tree:flat_action()

--6.8 button for building tree with text file of tree1 deleting nodes being in tree2
button_tree1_not_in_tree=iup.flatbutton{title="Neueinträge \nfinden", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_tree1_not_in_tree:flat_action()
	if file_exists(textbox1.value) then
		tree.delnode0 = "CHILDREN"
		tree.title=''
		--load tree1 from file in compare tree
		inputfile1=io.open(textbox1.value,"r")
		inputText=inputfile1:read("*all")
		inputfile1:close()
		treeTable=inputText:match("[^=]+=(%b{})")
		if treeTable:match('{ *branchname *= *"')==nil then firstEqualPosition=inputText:find("=") treeTable=inputText:sub(firstEqualPosition+1) end
		--save table in the variable actualtree
		--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
		if _VERSION=='Lua 5.1' then
			loadstring('actualtree='..treeTable)()	
		else
			load('actualtree='..treeTable)() --now actualtree is the table.
		end --if _VERSION=='Lua 5.1' then
		iup.TreeAddNodes(tree,actualtree)
		--go through tree 2
		local file2existsTable={}
		for i=0,tree2.totalchildcount0 do
			file2existsTable[tree2['TITLE' .. i]]=true
		end --for i=0,tree2.totalchildcount0 do
		for i=tree.totalchildcount0,0,-1 do
			if file2existsTable[tree['TITLE' .. i]] and tree['totalchildcount' .. i]=="0" then
				tree["delnode" .. i] = "SELECTED"
			end --if file1existsTable[tree2['TITLE' .. i]]==nil and tree2['totalchildcount' .. i]=="0" then
		end --for i=tree.totalchildcount0,0,-1 do
		--mark the tree in blue for nodes from tree 1
		for i=0,tree.totalchildcount0 do
			if file2existsTable[tree['TITLE' .. i]] then
				tree["color" .. i]=color_grey
			else
				tree["color" .. i]="0 0 250"
			end --if file1existsTable[tree2['TITLE' .. i]]==nil and tree2['totalchildcount' .. i]=="0" then
		end --for i=tree.totalchildcount0,0,-1 do
	end --if file_exists(textbox2.value) then
end --function button_tree1_not_in_tree:flat_action()

--6.9 copy of all nodes of a node put them in a Lua table and put them into the compare tree
button_put_in_compare_tree=iup.flatbutton{title="Baum in Vergleichsbaum\neinbauen", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_put_in_compare_tree:flat_action()
	if file_exists(textbox2.value) then
		tree.delnode0 = "CHILDREN"
		tree.title=''
		--load tree2 from file in compare tree
		inputfile2=io.open(textbox2.value,"r")
		inputText=inputfile2:read("*all")
		inputfile2:close()
		treeTable=inputText:match("[^=]+=(%b{})")
		if treeTable:match('{ *branchname *= *"')==nil then firstEqualPosition=inputText:find("=") treeTable=inputText:sub(firstEqualPosition+1) end
		--save table in the variable actualtree
		--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
		if _VERSION=='Lua 5.1' then
			loadstring('actualtree='..treeTable)()	
		else
			load('actualtree='..treeTable)() --now actualtree is the table.
		end --if _VERSION=='Lua 5.1' then
		iup.TreeAddNodes(tree,actualtree)
		--collect subtrees
		nodeTreeTable={}
		for startNodeNumber=1,tree1.count-1 do
			--collect subtree of node
			--dynamise this: local startNodeNumber=tree1.value
			local endNodeNumber=startNodeNumber+tree1['totalchildcount' .. startNodeNumber]
			local levelStartNode=tree1['depth' .. startNodeNumber]
			local levelOldNode=tree1['depth' .. startNodeNumber]
			nodeText='tree_nodes={branchname="' .. string.escape_forbidden_char(tree1['title' .. startNodeNumber]) .. '",\n'
			for i=startNodeNumber+1,endNodeNumber do
				tree1.value=i
				--test with: nodeText=nodeText .. '\n von: ' .. tonumber(levelOldNode) .. " zu: " .. tonumber(tree1['depth']) .. '\n'
				--test with: print('von: ' .. tonumber(levelOldNode) .. " zu: " .. tonumber(tree1['depth']) )
				--end curly brakets
				if tonumber(levelOldNode)>tonumber(tree1['depth']) then 
					for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(tree1['depth'])) do 
						nodeText=nodeText .. '},\n' 
					end --for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(tree1['depth'])) do 
				end --if tonumber(levelOldNode)>tonumber(tree1['depth']) then 
				--take branch or leaf
				if tree1['KIND']=="BRANCH" and tonumber(tree1['depth'])>=levelStartNode+1 and levelOldNode>=tree1['depth'] and tree1['KIND' .. i-1]=="BRANCH" then
					nodeText=nodeText .. '},\n{branchname="' .. string.escape_forbidden_char(tree1['title']) .. '",\n' 
				elseif tree1['KIND']=="LEAF" and tonumber(tree1['depth'])>=levelStartNode+1 and levelOldNode>=tree1['depth'] and tree1['KIND' .. i-1]=="BRANCH" then
					nodeText=nodeText .. '},\n"' .. string.escape_forbidden_char(tree1['title']) .. '",\n' 
				elseif tree1['KIND']=="BRANCH" and tonumber(tree1['depth'])>=levelStartNode+1 then
					nodeText=nodeText .. '{branchname="' .. string.escape_forbidden_char(tree1['title']) .. '",\n' 
				elseif tree1['KIND']=="LEAF" and tonumber(tree1['depth'])>=levelStartNode+1 then
					nodeText=nodeText .. '"' .. string.escape_forbidden_char(tree1['title']) .. '",\n' 
				end --if tree1['KIND']=="BRANCH" and tonumber(tree1['depth'])>=levelStartNode+1 and levelOldNode>=tree1['depth'] and tree1['KIND' .. i-1]=="BRANCH" then
				levelOldNode=tree1['depth']
			end --for i=endNodeNumber,startNodeNumber,-1 do
			if tree1['KIND' .. endNodeNumber]=="BRANCH" and tonumber(tree1['depth' .. endNodeNumber])>=levelStartNode+1 then
				for iLevel=1,tonumber(tree1['depth' .. endNodeNumber])-levelStartNode do
					nodeText=nodeText .. '},\n'
				end --for iLevel=tonumber(tree1['depth' .. endNodeNumber])-levelStartNode do
			end --if tree1['KIND' .. endNodeNumber]=="BRANCH" and tonumber(tree1['depth' .. endNodeNumber])>=levelStartNode+1 then
			--test with: nodeText=nodeText .. '\n von: ' .. tonumber(levelOldNode) .. " zu: " .. tonumber(levelStartNode) .. '\n'
			--end curly brakets
			if tonumber(levelOldNode)>tonumber(levelStartNode) then 
				for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(levelStartNode))-1 do 
					nodeText=nodeText .. '}'
					if i<math.tointeger(tonumber(levelOldNode)-tonumber(levelStartNode)) then 
						nodeText=nodeText .. ',\n'
					end --if i<math.tointeger(tonumber(levelOldNode)-tonumber(levelStartNode)) then 
				end --for i=1,math.tointeger(tonumber(levelOldNode)-tonumber(levelStartNode))-1 do 
			end --if tonumber(levelOldNode)>tonumber(levelStartNode) then 
			nodeText=nodeText .. '}\n'
			--test with: print(math.tointeger(tonumber(levelOldNode)-tonumber(levelStartNode)))
			--test with: print(nodeText)
			--load tree_nodes Lua table
			load(nodeText)()
			--test with: for k,v in pairs(tree_nodes) do print(k,v) if type(v)=="table" then for k1,v1 in pairs(v) do print(k1,v1) end end end
			--test add tree_nodes to node: tree:AddNodes(tree_nodes,startNodeNumber)
			--put subtrees in nodeTreeTable
			nodeTreeTable[tree1['title' .. startNodeNumber]]=tree_nodes
		end --for startNodeNumber=1,tree1.count-1 do
		--put the new nodes in the tree
		for i=tree.count-1,1,-1 do
			if nodeTreeTable[tree['title' .. i]] then
				tree:AddNodes(nodeTreeTable[tree['title' .. i]],i)
			end --if tree_nodes then
		end --for i=1,tree2.count-1 do
	end --if file_exists(textbox2.value) then
end --function button_put_in_compare_tree:flat_action()

--6.10 button for deleting one node leaving all other nodes but changing the order
button_delete_in_tree=iup.flatbutton{title="Ebene herauslöschen", size="105x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_delete_in_tree:flat_action()
	if tree.totalchildcount=="0" then
		tree.delnode = "SELECTED"
	else
		selectedNode=tree.value
		 --insert at same depth a temporary leaf
		tree['insertleaf' .. selectedNode]="temporary"
		for i=selectedNode,selectedNode+tree['childcount' .. selectedNode] do
			--search for temporary node number
			local temporaryNode=0
			for i1=selectedNode,tree.totalchildcount0 do
				temporaryNode=i1
				if tree['title' .. i1]=="temporary" then break end
			end --for i1=selectedNode,tree.totalchildcount0 do
			--last node on depth + 1 from selectedNode
			local lastNode=0
			for i1=selectedNode+tree['totalchildcount' .. selectedNode],selectedNode+1,-1 do
				lastNode=i1
				if tree['depth' .. i1]==tostring(tree['depth' .. selectedNode]+1) then break end
			end --for i1=selectedNode,tree.totalchildcount0 do
			tree['movenode' .. lastNode] = temporaryNode --lastNode in normal order
			--tree['movenode' .. selectedNode+1] = temporaryNode --selectedNode+1 in reversed order
		end --for i=selectedNode,tree['totalchildcount' .. selectedNode] do
		--delete selected node and temporary nodes
		tree.delnode = "SELECTED"
		tree.delnode = "SELECTED"
	end --if tree.totalchildcount==0 then
end --function button_delete_in_tree:flat_action()

--6.11 button for saving tree
button_save_lua_table=iup.flatbutton{title="Baum als Lua-Tabelle speichern", size="125x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
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

--6.12 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de")
end --function button_logo:flat_action()

--6 buttons end


--7 Main Dialog
--7.1 textboxes
textbox1 = iup.multiline{value="",size="320x20",WORDWRAP="YES"}
textbox2 = iup.multiline{value="",size="320x20",WORDWRAP="YES"}
textbox1_2 = iup.multiline{value="",size="85x20",WORDWRAP="YES"}
textbox2_2 = iup.multiline{value="",size="85x20",WORDWRAP="YES"}

--7.2.1 display empty compare tree
actualtree={branchname="compare"}
tree=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree)
end, --function(self)
SIZE="400x320",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}
--set the background color of the tree
tree.BGCOLOR=color_background_tree
-- Callback for pressed keys
function tree:k_any(c)
	if c == iup.K_DEL then
		tree.delnode = "MARKED"
	end --if c == iup.K_DEL then
end --function tree:k_any(c)

--7.2.2 display empty first tree
actualtree1={branchname="first tree"}
tree1=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree1)
end, --function(self)
SIZE="400x320",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}

--7.2.3 display empty second tree
actualtree2={branchname="second tree"}
tree2=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree2)
end, --function(self)
SIZE="400x320",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}

--7.3 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	--simply show a box with buttons
	iup.vbox{
		--first row of buttons
		iup.hbox{
			button_logo,
			button_loading_lua_table_1,
			button_loading_lua_table_2,
			iup.fill{},
			button_compare,
			button_sort_with_tree,
			button_sort_in_tree,
			button_tree1_not_in_tree,
			button_put_in_compare_tree,
			iup.label{size="5x",},
			button_delete_in_tree,
			button_expand_collapse_dialog,
			iup.label{size="5x",},
			button_save_lua_table,
			button_logo2,
		},
		
		iup.hbox{
			iup.frame{title="Erste Textdatei",iup.vbox{iup.hbox{textbox1,textbox1_2},tree1,},},
			iup.frame{title="Zweite Textdatei",iup.vbox{iup.hbox{textbox2,textbox2_2},tree2,},},
			iup.frame{title="Manuelle Zuordnung als Baum",iup.vbox{iup.label{title="Legende: blau = aus dem ersten Baum, grau = aus dem zweiten Baum und rot = Titel"},tree,},},
			},

	},

	icon = img_logo,
	title = path .. " Documentation Tree",
	SIZE = 'FULLxFULL',
	BACKGROUND=color_background
}


--7.4 show the dialog
maindlg:show()

--7.5 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then
