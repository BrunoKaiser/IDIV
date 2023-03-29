--This script is a console with an output as a tree, because each command is a branch and each output a set of leafs

--1.1 libraries and clipboard
--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iuplua_scintilla") --for Scintilla-editor

--1.1.2 initalize clipboard
clipboard=iup.clipboard{}

--1.1.3 loadstring for Lua 5.3 and higher Lua versions
if (not loadstring) then
  loadstring = load
end --if (not loadstring) then

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

--1.3 path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)

--2. console objects
console = {}

--2.1 prompt text area
console.prompt = iup.text{expand="Horizontal", dragdrop = "Yes"}
--
--[[
--alternatively as scintilla without dropfiles_cb
console.prompt=iup.scintilla{dragdrop = "Yes"}
console.prompt.SIZE="200x120" --I think this is not optimal! (since the size is so appears to be fixed)
--
console.prompt.wordwrap="WORD" --enable wordwarp
console.prompt.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
console.prompt.FONT="Courier New, 8" --font of shown code
console.prompt.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
console.prompt.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false function true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
console.prompt.STYLEFGCOLOR0="0 0 0"      -- 0-Default
console.prompt.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
console.prompt.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
console.prompt.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
console.prompt.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
console.prompt.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
console.prompt.STYLEFGCOLOR6="160 20 180"  -- 6-String 
console.prompt.STYLEFGCOLOR7="128 0 0"    -- 7-Character
console.prompt.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
console.prompt.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
console.prompt.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--console.prompt.STYLEBOLD10="YES"
--console.prompt.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--console.prompt.STYLEITALIC10="YES"
console.prompt.MARGINWIDTH0="40"
--]]
console.prompt.tip = "Filter leaf with pattern: Alle Blätter darunter filtern\n"..
                     "Result of os.execute and luacom.DumpTypeInfo in console, not in GUI\n"..
                     "Enter - executes a Lua command\n"..
                     "Esc - clears the command\n"..
                     "Ctrl+Del - clears the output\n"..
                     "Ctrl+O - selects a file and execute it\n"..
                     "Ctrl+X - exits the console\n"..
                     "Up Arrow - shows the previous command in history\n"..
                     "Down Arrow - shows the next command in history\n"..
                     "Drop files here to execute them"
--dropfiles callback function
function console.prompt:dropfiles_cb(filename)
	-- will execute all dropped files, can drop more than one at once
	-- works in Windows and in Linux
	--test with: print(filename)
	console.do_file(filename)
end --function console.prompt:dropfiles_cb(filename)
--key pressed function
function console.prompt:k_any(key)
	if (key == iup.K_CR) then  -- Enter executes the string
		console.do_string(self.value)
		self.value = ""
	elseif (key == iup.K_ESC) then  -- Esc clears console.prompt
		self.value = ""
	elseif (key == iup.K_cO) then  -- Ctrl+O selects a file and execute it
		console.open_file()
	elseif (key == iup.K_cX) then  -- Ctrl+X exits the console
		console.dialog:close_cb()
	elseif (key == iup.K_cDEL) then  -- Ctrl+Del clears console.output
		console.output.value = ""
	elseif (key == iup.K_UP) then  -- Up Arrow - shows the previous command in history
		console.prev_command()
	elseif (key == iup.K_DOWN) then  -- Down Arrow - shows the next command in history
		console.next_command()
	end --if (key == iup.K_CR) then  
end --function console.prompt:k_any(key)

--2.2 output in a standard way as text area replaced by tree
console.output = iup.text{expand="Yes", 
                  readonly="Yes", 
                  bgcolor="232 232 232", 
                  font = "Courier, 11",
                  appendnewline = "No",
                  multiline = "Yes"}

--2.3.1 drag & drop text area branch
console.textbox_branch = iup.text{value="Ast bilden",size="45x10", readonly="YES", dragdrop = "Yes",BGCOLOR=color_buttons, FGCOLOR=color_button_text}
console.textbox_branch.tip = "Drop files here to build a branch"
--callback to add branch with drag & drop         
function console.textbox_branch:dropfiles_cb(filename)
	console.commandTree['addbranch']=tostring(filename)
end --function console.textbox_branch:dropfiles_cb(filename)

--2.3.2 drag & drop text area leaf
console.textbox_leaf = iup.text{value="Blatt bilden",size="45x10", readonly="YES", dragdrop = "Yes",BGCOLOR=color_buttons, FGCOLOR=color_button_text}
console.textbox_leaf.tip = "Drop files here to build a leaf"
--callback to add leaf with drag & drop 
function console.textbox_leaf:dropfiles_cb(filename)
	console.commandTree['addleaf']=tostring(filename)
end --function console.textbox_leaf:dropfiles_cb(filename)




--3. functions

--3.1 put original functions in variables
console.orig_output = io.output
console.orig_write = io.write
console.orig_print = print

--3.2 output function
function io.output(filename)
	console.orig_output(filename)
	if (filename) then
		io.write = console.orig_write
	else
		io.write = console.new_write
	end --if (filename) then
end --function io.output(filename)

--3.3 write function
function console.new_write(...)
	-- Try to simulate the same behavior of the standard io.write
	local arg = {...}
	local str -- allow to print a nil value
	for i,v in ipairs(arg) do
		if (str) then
			str = str .. tostring(v) 
		else
			str = tostring(v)
		end --if (str) then
	end --for i,v in ipairs(arg) do
	console.print2output(str, true)
end --function console.new_write(...)
io.write = console.new_write

--3.4 print function
function print(...)
	-- Try to simulate the same behavior of the standard print
	local arg = {...}
	local str -- allow to print a nil value
	for i,v in ipairs(arg) do
		if (i > 1) then
			str = str .. "\t"  -- only add Tab for more than 1 parameters
		end --if (i > 1) then
		if (str) then
			str = str .. tostring(v) 
		else
			str = tostring(v)
		end --if (str) then
	end --for i,v in ipairs(arg) do
	console.print2output(str)
end --function print(...)

--3.5 print to output function
function console.print2output(s, no_newline)
	if tostring(s):match("^>") then
		--find last branch at depth 1
		for i=0,console.outputTree.count-1 do
			if console.outputTree["depth" .. i]=="1" then
				console.outputTree.value=i
			end --if tree["depth" .. console.outputTree.value+1]==console.outputTree["depth" .. console.outputTree.value] then
		end --for i=console.outputTree.value+1,console.outputTree.count-1 do
		--alternatively: console.outputTree.value=0 --0 and addbranch to have the newest on the top after first leafs
		--test with: iup.Message(console.outputTree.value,console.outputTree["depth" .. console.outputTree.value])
		console.outputTree['insertbranch']=tostring(s):match("^> (.*)") -- console.outputTree.value=console.outputTree.value+1
		for i=console.outputTree.value+1,console.outputTree.count-1 do
			if console.outputTree["depth" .. i]==console.outputTree["depth" .. console.outputTree.value] then
				console.outputTree.value=i
				break
			end --if tree["depth" .. console.outputTree.value+1]==console.outputTree["depth" .. console.outputTree.value] then
		end --for i=console.outputTree.value+1,console.outputTree.count-1 do
	else
	console.outputTree['addleaf']=tostring(s) console.outputTree.value=console.outputTree.value+1
	end --if tostring(s):match("^>") then
	--output in text area
	if (no_newline) then
		console.output.append = tostring(s)
		console.no_newline = no_newline
	else
		if (console.no_newline) then
			-- if io.write was called, then a print is called, must add a new line before
			console.output.append = "\n" .. tostring(s) .. "\n"
			console.no_newline = nil
		else  
			console.output.append = tostring(s) .. "\n"
		end --if (console.no_newline) then
	end --if (no_newline) then
end --function console.print2output(s, no_newline)

--3.6 print command function
function console.print_command(cmd)
	console.add_command(cmd)
	console.print2output("> " .. cmd)
end --function console.print_command(cmd)

--3.7 add command function
function  console.add_command(cmd)
	console.cmd_index = nil
	if (not console.cmd_list) then
		console.cmd_list = {}
	end --if (not console.cmd_list) then
	local n = #(console.cmd_list)
	console.cmd_list[n+1] = cmd
end --function  console.add_command(cmd)

--3.8 previous command function
function  console.prev_command()
	if (not console.cmd_list) then
		return
	end --if (not console.cmd_list) then
	if (not console.cmd_index) then
		console.cmd_index = #(console.cmd_list)
	else
		console.cmd_index = console.cmd_index - 1
		if (console.cmd_index == 0) then
			console.cmd_index = 1
		end --if (console.cmd_index == 0) then
	end --if (not console.cmd_index) then
	console.prompt.value = console.cmd_list[console.cmd_index]
end --function  console.prev_command()

--3.9 next command function
function  console.next_command()
	if (not console.cmd_list) then
		return
	end --if (not console.cmd_list) then
	if (not console.cmd_index) then
		return
	else
		console.cmd_index = console.cmd_index + 1
		local n = #(console.cmd_list)
		if (console.cmd_index == n+1) then
			console.cmd_index = n
		end
	end --if (not console.cmd_index) then
	console.prompt.value = console.cmd_list[console.cmd_index]
end --function  console.next_command()

--3.10 do_file auxiliary function
function console.do_file(filename)
	local cmd = 'dofile(' .. string.format('%q', filename) .. ')'
	console.print_command(cmd)
	dofile(filename)
end --function console.do_file(filename)

--3.11 do_string function
function console.do_string(cmd)
	console.print_command(cmd)
	assert(loadstring(cmd))()
end --function console.do_string(cmd)

--3.12 open_file function
function console.open_file()
	local fd=iup.filedlg{dialogtype="OPEN", title="Load File", 
				nochangedir="NO", directory=console.last_directory,
				filter="*.*", filterinfo="All Files", allownew="NO"}
	fd:popup(iup.CENTER, iup.CENTER)
	local status = fd.status
	local filename = fd.value
	console.last_directory = fd.directory -- save the previous directory
	fd:destroy()
	--load file or not
	if (status == "-1") or (status == "1") then
		if (status == "1") then
			error ("Cannot load file: "..filename)
		end --if (status == "1") then
	else
		console.do_file(filename)
	end --if (status == "-1") or (status == "1") then
end --function console.open_file()


--3.13 function checking if file exits
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end --function file_exists(name)

--3.14 function which saves the current iup tree as a Lua table
function save_tree_to_lua(tree, outputfile_path,outputname_tree)
	local output_tree_text=outputname_tree .. "=" --"lua_tree_input=" --the output string
	local outputfile=io.open(outputfile_path,"w") --a output file
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
				output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n' --we add the leaf
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) < tonumber(tree["DEPTH" .. i-1 ]) then
				if tree["KIND" .. i-1 ] == "LEAF" then --in the same manner as above, depending if the predecessor node was a leaf or branch, we have to close a different number of brackets
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
					output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n' --and in each case we add the new leaf
				else
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
					output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '", \n'
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
end --function save_tree_to_lua(tree, outputfile_path,outputname_tree)

--3.15 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--3.16 function for version informations
function console.version_info()
  print(_VERSION, _COPYRIGHT) -- _COPYRIGHT does not exists by default, but it could...
  print("IUP " .. iup._VERSION .. "  " .. iup._COPYRIGHT)
  print("  System: " .. iup.GetGlobal("SYSTEM"))
  print("  System Version: " .. iup.GetGlobal("SYSTEMVERSION"))
  local mot = iup.GetGlobal("MOTIFVERSION")
  if (mot) then print("  Motif Version: ", mot) end
  local gtk = iup.GetGlobal("GTKVERSION")
  if (gtk) then print("  GTK Version: ", gtk) end
end

--3.17 recursive function to build variable inputs from tree as Lua variables
function readVariablesInTreeRecursive(TreeTable)
	if TreeTable.branchname:match("=") then
		loadstring(TreeTable.branchname)()
	end --if TreeTable.branchname:match("=") then
	for i,v in ipairs(TreeTable) do
		if type(v)=="table" and TreeTable.branchname:match("(.*)={")==nil then
			readVariablesInTreeRecursive(v,"")
		elseif type(v)=="table" and v.branchname:match("(.*)={")==nil then
			loadstring(TreeTable.branchname:match("(.*)={") .. '["' .. v.branchname .. '"]="' .. v[1] .. '"')()
		elseif type(v)=="table" and v.branchname:match("(.*)={") then
			readVariablesInTreeRecursive(v,"")
		else
			if TreeTable.branchname:match("(.*)={") then
				loadstring(TreeTable.branchname:match("(.*)={") .. "[" .. i .. ']="' .. v .. '"')()
			end --if TreeTable.branchname:match("(.*)={") then
		end --if type(v)=="table" and TreeTable.branchname:match("(.*)={")==nil then
	end --for i,v in ipairs(TreeTable) do
end --function readVariablesInTreeRecursive(TreeTable)


--3. functions end


--4. dialogs

--4.1 rename dialog
--ok button
ok = iup.flatbutton{title = "OK",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function ok:flat_action()
	console.inputTree.title = text.value
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

--4.2 command rename dialog
--command ok button
command_ok = iup.flatbutton{title = "OK",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function command_ok:flat_action()
	console.commandTree.title = command_text.value
	return iup.CLOSE
end --function command_ok:flat_action()

--command cancel button
command_cancel = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function command_cancel:flat_action()
	return iup.CLOSE
end --function command_cancel:flat_action()

command_text=iup.scintilla{}
command_text.SIZE="200x120" --I think this is not optimal! (since the size is so appears to be fixed)
--
command_text.wordwrap="WORD" --enable wordwarp
command_text.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
command_text.FONT="Courier New, 8" --font of shown code
command_text.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
command_text.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false function true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
command_text.STYLEFGCOLOR0="0 0 0"      -- 0-Default
command_text.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
command_text.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
command_text.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
command_text.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
command_text.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
command_text.STYLEFGCOLOR6="160 20 180"  -- 6-String 
command_text.STYLEFGCOLOR7="128 0 0"    -- 7-Character
command_text.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
command_text.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
command_text.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--command_text.STYLEBOLD10="YES"
--command_text.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--command_text.STYLEITALIC10="YES"
command_text.MARGINWIDTH0="40"

command_label1 = iup.label{title="Name:"}--label for textfield

--open the dialog for renaming branch/leaf
command_dlg_rename = iup.dialog{
	iup.vbox{command_label1, command_text, iup.hbox{command_ok,command_cancel}}; 
	title="Knoten bearbeiten",
	size="250x150",
	startfocus=command_text,
	}

--4.2 command rename dialog end

--4.3 output rename dialog
--output ok button
output_ok = iup.flatbutton{title = "OK",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function output_ok:flat_action()
	console.outputTree.title = output_text.value
	return iup.CLOSE
end --function output_ok:flat_action()

--output cancel button
output_cancel = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function output_cancel:flat_action()
	return iup.CLOSE
end --function output_cancel:flat_action()

output_text = iup.multiline{size="120x50",border="YES",expand="YES",wordwrap="YES"} --textfield
output_label1 = iup.label{title="Name:"}--label for textfield

--open the dialog for renaming branch/leaf
output_dlg_rename = iup.dialog{
	iup.vbox{output_label1, output_text, iup.hbox{output_ok,output_cancel}}; 
	title="Knoten bearbeiten",
	size="QUARTER",
	startfocus=output_text,
	}

--4.3 output rename dialog end


--5. context menus (menus for right mouse click)

--5.1 menu of console.inputTree
--5.1.1 copy node of console.inputTree
startcopy = iup.item {title = "Knoten kopieren"}
function startcopy:action() --copy node
	 clipboard.text = console.inputTree['title']
end --function startcopy:action()

--5.1.2 rename node and rename action for other needs of console.inputTree
renamenode = iup.item {title = "Knoten bearbeiten"}
function renamenode:action()
	text.value = console.inputTree['title']
	dlg_rename:popup(iup.CENTER, iup.CENTER) --popup rename dialog
	iup.SetFocus(console.inputTree)
end --function renamenode:action()

--5.1.3 add branch to console.inputTree
addbranch = iup.item {title = "Ast hinzufügen"}
function addbranch:action()
	console.inputTree.addbranch = ""
	console.inputTree.value=console.inputTree.value+1
	renamenode:action()
end --function addbranch:action()

--5.1.3.1 add branch to console.inputTree by insertbranch
addbranchbottom = iup.item {title = "Ast darunter hinzufügen"}
function addbranchbottom:action()
	console.inputTree["insertbranch" .. console.inputTree.value] = ""
	for i=console.inputTree.value+1,console.inputTree.count-1 do
		if console.inputTree["depth" .. i]==console.inputTree["depth" .. console.inputTree.value] then
			console.inputTree.value=i
			renamenode:action()
			break
		end --if console.inputTree["depth" .. console.inputTree.value+1]==console.inputTree["depth" .. console.inputTree.value] then
	end --for i=console.inputTree.value+1,console.inputTree.count-1 do
end --function addbranchbottom:action()

--5.1.3.2 add leaf to console.inputTree by insertleaf
addleafbottom = iup.item {title = "Blatt darunter hinzufügen"}
function addleafbottom:action()
	console.inputTree["insertleaf" .. console.inputTree.value] = ""
	for i=console.inputTree.value+1,console.inputTree.count-1 do
		if console.inputTree["depth" .. i]==console.inputTree["depth" .. console.inputTree.value] then
			console.inputTree.value=i
			renamenode:action()
			break
		end --if console.inputTree["depth" .. console.inputTree.value+1]==console.inputTree["depth" .. console.inputTree.value] then
	end --for i=console.inputTree.value+1,console.inputTree.count-1 do
end --function addleafbottom:action()

--5.1.3.3 add leaf to console.inputTree by insertleaf after the last leaf of the branch chosen
addleafbottomlevel = iup.item {title = "Blatt unter letztem Blatt hinzufügen"}
function addleafbottomlevel:action()
	if console.inputTree["KIND"]=="BRANCH" then
		console.inputTree["insertleaf" .. console.inputTree.value+console.inputTree.totalchildcount] = ""
				console.inputTree.value=console.inputTree.value+console.inputTree.totalchildcount
				renamenode:action()
	else
		console.inputTree["insertleaf" .. console.inputTree.value] = ""
		for i=console.inputTree.value+1,console.inputTree.count-1 do
			if console.inputTree["depth" .. i]==console.inputTree["depth" .. console.inputTree.value] then
				console.inputTree.value=i
				renamenode:action()
				break
			end --if console.inputTree["depth" .. console.inputTree.value+1]==console.inputTree["depth" .. console.inputTree.value] then
		end --for i=console.inputTree.value+1,console.inputTree.count-1 do
	end --if console.inputTree["KIND"]=="BRANCH" then
end --function addleafbottomlevel:action()

--5.1.4 add branch of console.inputTree from clipboard
addbranch_fromclipboard = iup.item {title = "Ast aus Zwischenablage"}
function addbranch_fromclipboard:action()
	console.inputTree.addbranch = clipboard.text
	console.inputTree.value=console.inputTree.value+1
end --function addbranch_fromclipboard:action()

--5.1.4.1 add branch to console.inputTree by insertbranch from clipboard
addbranch_fromclipboardbottom = iup.item {title = "Ast darunter aus Zwischenablage"}
function addbranch_fromclipboardbottom:action()
	console.inputTree["insertbranch" .. console.inputTree.value] = clipboard.text
	for i=console.inputTree.value+1,console.inputTree.count-1 do
	if console.inputTree["depth" .. i]==console.inputTree["depth" .. console.inputTree.value] then
		console.inputTree.value=i
		break
	end --if console.inputTree["depth" .. console.inputTree.value+1]==console.inputTree["depth" .. console.inputTree.value] then
	end --for i=console.inputTree.value+1,console.inputTree.count-1 do
end --function addbranch_fromclipboardbottom:action()

--5.1.4.2 add leaf to console.inputTree by insertleaf from clipboard
addleaf_fromclipboardbottom = iup.item {title = "Blatt darunter aus Zwischenablage"}
function addleaf_fromclipboardbottom:action()
	console.inputTree["insertleaf" .. console.inputTree.value] = clipboard.text
	for i=console.inputTree.value+1,console.inputTree.count-1 do
	if console.inputTree["depth" .. i]==console.inputTree["depth" .. console.inputTree.value] then
		console.inputTree.value=i
		break
	end --if console.inputTree["depth" .. console.inputTree.value+1]==console.inputTree["depth" .. console.inputTree.value] then
	end --for i=console.inputTree.value+1,console.inputTree.count-1 do
end --function addleaf_fromclipboardbottom:action()

--5.1.4.3 add leaf to console.inputTree by insertleaf after the last leaf of the branch chosen from clipboard
addleaf_fromclipboardbottom = iup.item {title = "Blatt unter letztem Blatt aus Zwischenablage"}
function addleaf_fromclipboardbottom:action()
	console.inputTree["insertleaf" .. console.inputTree.value+console.inputTree.totalchildcount] = clipboard.text
		console.inputTree.value=console.inputTree.value+console.inputTree.totalchildcount
end --function addleaf_fromclipboardbottom:action()

--5.1.5 add leaf of console.inputTree
addleaf = iup.item {title = "Blatt hinzufügen"}
function addleaf:action()
	console.inputTree.addleaf = ""
	console.inputTree.value=console.inputTree.value+1
	renamenode:action()
end --function addleaf:action()

--5.1.6 add leaf of console.inputTree from clipboard
addleaf_fromclipboard = iup.item {title = "Blatt aus Zwischenablage"}
function addleaf_fromclipboard:action()
	console.inputTree.addleaf = clipboard.text
	console.inputTree.value=console.inputTree.value+1
end --function addleaf_fromclipboard:action()

--5.1.7 copy a version of the file selected in the console.inputTree and give it the next version number
startversion = iup.item {title = "Version archivieren"}
function startversion:action()
	--get the version of the file
	if console.inputTree['title']:match("^.:\\.*%.[^\\]+") then
		Version=0
		p=io.popen('dir "' .. console.inputTree['title']:gsub("(%.+)","_Version*%1") .. '" /b/o')
		for Datei in p:lines() do 
			--test with: iup.Message("Version",Datei) 
			if Datei:match("_Version(%d+)") then Version_alt=Version Version=tonumber(Datei:match("_Version(%d+)")) if Version<Version_alt then Version=Version_alt end end
			--test with: iup.Message("Version",Version) 
		end --for Datei in p:lines() do 
		--test with: iup.Message(Version,Version+1)
		Version=Version+1
		iup.Message("Archivieren der Version:",console.inputTree['title']:gsub("(%.+)","_Version" .. Version .. "%1"))
		os.execute('copy "' .. console.inputTree['title'] .. '" "' .. console.inputTree['title']:gsub("(%.+)","_Version" .. Version .. "%1") .. '"')
	end --if console.inputTree['title']:match(".:\\.*%.[^\\]+") then
end --function startversion:action()

--5.1.8 start file of node of console.inputTree in IUP Lua scripter or start empty file in notepad or start empty scripter
startnodescripter = iup.item {title = "Skripter starten"}
function startnodescripter:action()
	--read first line of file. If it is empty then scripter cannot open it. So open file with notepad.exe
	if file_exists(console.inputTree['title']) then inputfile=io.open(console.inputTree['title'],"r") ErsteZeile=inputfile:read() inputfile:close() end
	if file_exists(console.inputTree['title']) and ErsteZeile then 
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. console.inputTree['title'] .. '"')
	elseif file_exists(console.inputTree['title']) then 
		os.execute('start "d" notepad.exe "' .. console.inputTree['title'] .. '"')
	else
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe ')
	end --if file_exists(console.inputTree['title']) and ErsteZeile then 
end --function startnodescripter:action()

--5.1.9 start the file or repository of the node of console.inputTree
startnode = iup.item {title = "Starten"}
function startnode:action() 
	if console.inputTree['title']:match("^.:\\.*%.[^\\ ]+$") or console.inputTree['title']:match("^.:\\.*[^\\]+$") or console.inputTree['title']:match("^.:\\$") or console.inputTree['title']:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "D" "' .. console.inputTree['title'] .. '"') 
	elseif console.inputTree['title']:match("sftp .*") then 
		os.execute(console.inputTree['title']) 
	end --if console.inputTree['title']:match("^.:\\.*%.[^\\ ]+$") or console.inputTree['title']:match("^.:\\.*[^\\]+$") or console.inputTree['title']:match("^.:\\$") or console.inputTree['title']:match("^[^ ]*//[^ ]+$") then 
end --function startnode:action()


--5.1.10 put the menu items together in the menu for console.inputTree
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
		addleafbottomlevel,
		addleaf_fromclipboardbottom,
		startversion, 
		startnodescripter,
		startnode, 
		}
--5.1 menu of console.inputTree end

--5.2 menu of console.commandTree
--5.2.1 copy node of console.commandTree
command_startcopy = iup.item {title = "Knoten kopieren"}
function command_startcopy:action() --copy node
	 clipboard.text = console.commandTree['title']
end --function command_startcopy:action()

--5.2.2 rename node and rename action for other needs of console.commandTree
command_renamenode = iup.item {title = "Knoten bearbeiten"}
function command_renamenode:action()
	command_text.value = console.commandTree['title']
	command_dlg_rename:popup(iup.CENTER, iup.CENTER) --popup rename dialog
	iup.SetFocus(console.commandTree)
end --function command_renamenode:action()

--5.2.3 add branch to console.commandTree
command_addbranch = iup.item {title = "Ast hinzufügen"}
function command_addbranch:action()
	console.commandTree.addbranch = ""
	console.commandTree.value=console.commandTree.value+1
	command_renamenode:action()
end --function command_addbranch:action()

--5.2.3.1 add branch to console.commandTree by insertbranch
command_addbranchbottom = iup.item {title = "Ast darunter hinzufügen"}
function command_addbranchbottom:action()
	console.commandTree["insertbranch" .. console.commandTree.value] = ""
	for i=console.commandTree.value+1,console.commandTree.count-1 do
		if console.commandTree["depth" .. i]==console.commandTree["depth" .. console.commandTree.value] then
			console.commandTree.value=i
			command_renamenode:action()
			break
		end --if console.commandTree["depth" .. console.commandTree.value+1]==console.commandTree["depth" .. console.commandTree.value] then
	end --for i=console.commandTree.value+1,console.commandTree.count-1 do
end --function command_addbranchbottom:action()

--5.2.3.2 add leaf to console.commandTree by insertleaf
command_addleafbottom = iup.item {title = "Blatt darunter hinzufügen"}
function command_addleafbottom:action()
	console.commandTree["insertleaf" .. console.commandTree.value] = ""
	for i=console.commandTree.value+1,console.commandTree.count-1 do
		if console.commandTree["depth" .. i]==console.commandTree["depth" .. console.commandTree.value] then
			console.commandTree.value=i
			command_renamenode:action()
			break
		end --if console.commandTree["depth" .. console.commandTree.value+1]==console.commandTree["depth" .. console.commandTree.value] then
	end --for i=console.commandTree.value+1,console.commandTree.count-1 do
end --function command_addleafbottom:action()

--5.2.4 add branch of console.commandTree from clipboard
command_addbranch_fromclipboard = iup.item {title = "Ast aus Zwischenablage"}
function command_addbranch_fromclipboard:action()
	console.commandTree.addbranch = clipboard.text
	console.commandTree.value=console.commandTree.value+1
end --function command_addbranch_fromclipboard:action()

--5.2.4.1 add branch to console.commandTree by insertbranch from clipboard
command_addbranch_fromclipboardbottom = iup.item {title = "Ast darunter aus Zwischenablage"}
function command_addbranch_fromclipboardbottom:action()
	console.commandTree["insertbranch" .. console.commandTree.value] = clipboard.text
	for i=console.commandTree.value+1,console.commandTree.count-1 do
	if console.commandTree["depth" .. i]==console.commandTree["depth" .. console.commandTree.value] then
		console.commandTree.value=i
		break
	end --if console.commandTree["depth" .. console.commandTree.value+1]==console.commandTree["depth" .. console.commandTree.value] then
	end --for i=console.commandTree.value+1,console.commandTree.count-1 do
end --function command_addbranch_fromclipboardbottom:action()

--5.2.4.2 add leaf to console.commandTree by insertleaf from clipboard
command_addleaf_fromclipboardbottom = iup.item {title = "Blatt darunter aus Zwischenablage"}
function command_addleaf_fromclipboardbottom:action()
	console.commandTree["insertleaf" .. console.commandTree.value] = clipboard.text
	for i=console.commandTree.value+1,console.commandTree.count-1 do
	if console.commandTree["depth" .. i]==console.commandTree["depth" .. console.commandTree.value] then
		console.commandTree.value=i
		break
	end --if console.commandTree["depth" .. console.commandTree.value+1]==console.commandTree["depth" .. console.commandTree.value] then
	end --for i=console.commandTree.value+1,console.commandTree.count-1 do
end --function command_addleaf_fromclipboardbottom:action()

--5.2.5 add leaf of console.commandTree
command_addleaf = iup.item {title = "Blatt hinzufügen"}
function command_addleaf:action()
	console.commandTree.addleaf = ""
	console.commandTree.value=console.commandTree.value+1
	command_renamenode:action()
end --function command_addleaf:action()

--5.2.6 add leaf of console.commandTree from clipboard
command_addleaf_fromclipboard = iup.item {title = "Blatt aus Zwischenablage"}
function command_addleaf_fromclipboard:action()
	console.commandTree.addleaf = clipboard.text
	console.commandTree.value=console.commandTree.value+1
end --function command_addleaf_fromclipboard:action()

--5.2.7 copy a version of the file selected in the console.commandTree and give it the next version number
command_startversion = iup.item {title = "Version archivieren"}
function command_startversion:action()
	--get the version of the file
	if console.commandTree['title']:match("^.:\\.*%.[^\\]+") then
		Version=0
		p=io.popen('dir "' .. console.commandTree['title']:gsub("(%.+)","_Version*%1") .. '" /b/o')
		for Datei in p:lines() do 
			--test with: iup.Message("Version",Datei) 
			if Datei:match("_Version(%d+)") then Version_alt=Version Version=tonumber(Datei:match("_Version(%d+)")) if Version<Version_alt then Version=Version_alt end end
			--test with: iup.Message("Version",Version) 
		end --for Datei in p:lines() do 
		--test with: iup.Message(Version,Version+1)
		Version=Version+1
		iup.Message("Archivieren der Version:",console.commandTree['title']:gsub("(%.+)","_Version" .. Version .. "%1"))
		os.execute('copy "' .. console.commandTree['title'] .. '" "' .. console.commandTree['title']:gsub("(%.+)","_Version" .. Version .. "%1") .. '"')
	end --if console.commandTree['title']:match(".:\\.*%.[^\\]+") then
end --function command_startversion:action()

--5.2.8 start file of node of console.commandTree in IUP Lua scripter or start empty file in notepad or start empty scripter
command_startnodescripter = iup.item {title = "Skripter starten"}
function command_startnodescripter:action()
	--read first line of file. If it is empty then scripter cannot open it. So open file with notepad.exe
	if file_exists(console.commandTree['title']) then inputfile=io.open(console.commandTree['title'],"r") ErsteZeile=inputfile:read() inputfile:close() end
	if file_exists(console.commandTree['title']) and ErsteZeile then 
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. console.commandTree['title'] .. '"')
	elseif file_exists(console.commandTree['title']) then 
		os.execute('start "d" notepad.exe "' .. console.commandTree['title'] .. '"')
	else
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe ')
	end --if file_exists(console.commandTree['title']) and ErsteZeile then 
end --function command_startnodescripter:action()

--5.2.9 start the file or repository of the node of console.commandTree
command_startnode = iup.item {title = "Starten"}
function command_startnode:action() 
	if console.commandTree['title']:match("^.:\\.*%.[^\\ ]+$") or console.commandTree['title']:match("^.:\\.*[^\\]+$") or console.commandTree['title']:match("^.:\\$") or console.commandTree['title']:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "D" "' .. console.commandTree['title'] .. '"') 
	elseif console.commandTree['title']:match("sftp .*") then 
		os.execute(console.commandTree['title']) 
	end --if console.commandTree['title']:match("^.:\\.*%.[^\\ ]+$") or console.commandTree['title']:match("^.:\\.*[^\\]+$") or console.commandTree['title']:match("^.:\\$") or console.commandTree['title']:match("^[^ ]*//[^ ]+$") then 
end --function command_startnode:action()

--5.2.10 execute Lua script with Lua chunk of the node of console.commandTree and write result under the node of tree console.outputTree
command_startnode_script = iup.item {title = "Knoten ausführen"}
function command_startnode_script:action()
	if console.commandTree["KIND"]=="BRANCH" then 
		if console.commandTree['title']:match("^.:\\.*%.[^\\ ]+$") or console.commandTree['title']:match("^.:\\.*[^\\]+$") or console.commandTree['title']:match("^.:\\$") or console.commandTree['title']:match("^[^ ]*//[^ ]+$") then 
			dofile(console.commandTree['title']) 
		elseif console.commandTree['title']:match("%(") or console.commandTree['title']:match("=") then
			loadstring(console.commandTree['title'])()
		end --if console.commandTree['title']:match("^.:\\.*%.[^\\ ]+$") or console.commandTree['title']:match("^.:\\.*[^\\]+$") or console.commandTree['title']:match("^.:\\$") or console.commandTree['title']:match("^[^ ]*//[^ ]+$") then 
	end --if console.commandTree["KIND"]=="BRANCH" then 
end --function command_startnode_script:action()

--5.2.11 execute Lua script with Lua chunk of the node and all child nodes of console.commandTree and write result under the node of tree console.outputTree
command_startnode_script_update_with_children = iup.item {title = "Knoten mit Unterknoten aktualisieren"}
function command_startnode_script_update_with_children:action() 
	if console.commandTree["KIND"]=="BRANCH" then 
		local startNode=console.commandTree.value
		for i=startNode,startNode+console.commandTree['TOTALCHILDCOUNT' .. startNode] do
			console.commandTree.value=i
			if console.commandTree['KIND' .. i]=="BRANCH" and console.commandTree['KIND' .. i+1]=="LEAF" then 
				console.commandTree['delnode' .. i+1]="SELECTED"
			end --if console.commandTree['KIND' .. i+1]=="LEAF" then 
			if console.commandTree['title' .. i]:match("^.:\\.*%.lua$") then 
				dofile(console.commandTree['title' .. i])
			elseif console.commandTree['title' .. i]:match("%(") or console.commandTree['title' .. i]:match("=") then
				loadstring(console.commandTree['title' .. i])() 
			end --if console.commandTree['title' .. i]:match("^.:\\.*%.lua$") then 
		end --for i=console.commandTree.value+1,console.commandTree.value+console.commandTree['TOTALCHILDCOUNT'] do
	end --if console.commandTree["KIND"]=="BRANCH" then 
end --function command_startnode_script_update_with_children:action()

--5.2.12 execute Lua script with Lua chunk of the node of console.commandTree and rewrite result under the node in console.outputTree
command_startnode_script_update = iup.item {title = "Knoten aktualisieren"}
function command_startnode_script_update:action() 
	if console.commandTree["KIND"]=="BRANCH" then 
		local startNode=console.outputTree.value
		if console.outputTree["KIND" .. startNode+1]=="LEAF" then
			console.outputTree['delnode' .. startNode+1] = "SELECTED" --TOTALCHILDCOUNT
		end --if console.outputTree["KIND" .. startNode+1]=="LEAF" then
		if console.commandTree['title']:match("^.:\\.*%.lua$") then 
			dofile(console.commandTree['title']) 
		elseif console.commandTree['title']:match("%(") or console.commandTree['title']:match("=") then
			loadstring(console.commandTree['title'])()
		end --if console.commandTree['title']:match("^.:\\.*%.lua$") then 
	end --if console.commandTree["KIND"]=="BRANCH" then 
end --function command_startnode_script_update:action()

--5.2.13 put the menu items together in the menu for console.commandTree
command_menu = iup.menu{
		command_startcopy,
		command_renamenode, 
		command_addbranch,
		command_addbranch_fromclipboard, 
		command_addbranchbottom,  
		command_addbranch_fromclipboardbottom, 
		command_addleaf,
		command_addleaf_fromclipboard,
		command_addleafbottom,
		command_addleaf_fromclipboardbottom,
		command_startversion, 
		command_startnodescripter,
		command_startnode_script, 
		command_startnode_script_update_with_children, 
		command_startnode_script_update, 
		command_startnode, 
		}
--5.2 menu of console.commandTree end

--5.3 menu of console.outputTree
--5.3.1 copy node of console.outputTree
output_startcopy = iup.item {title = "Knoten kopieren"}
function output_startcopy:action() --copy node
	 clipboard.text = console.outputTree['title']
end --function output_startcopy:action()

--5.3.2 rename node and rename action for other needs of console.outputTree
output_renamenode = iup.item {title = "Knoten bearbeiten"}
function output_renamenode:action()
	output_text.value = console.outputTree['title']
	output_dlg_rename:popup(iup.CENTER, iup.CENTER) --popup rename dialog
	iup.SetFocus(console.outputTree)
end --function output_renamenode:action()

--5.3.3 add branch to console.outputTree
output_addbranch = iup.item {title = "Ast hinzufügen"}
function output_addbranch:action()
	console.outputTree.addbranch = ""
	console.outputTree.value=console.outputTree.value+1
	output_renamenode:action()
end --function output_addbranch:action()

--5.3.3.1 add branch to console.outputTree by insertbranch
output_addbranchbottom = iup.item {title = "Ast darunter hinzufügen"}
function output_addbranchbottom:action()
	console.outputTree["insertbranch" .. console.outputTree.value] = ""
	for i=console.outputTree.value+1,console.outputTree.count-1 do
		if console.outputTree["depth" .. i]==console.outputTree["depth" .. console.outputTree.value] then
			console.outputTree.value=i
			output_renamenode:action()
			break
		end --if console.outputTree["depth" .. console.outputTree.value+1]==console.outputTree["depth" .. console.outputTree.value] then
	end --for i=console.outputTree.value+1,console.outputTree.count-1 do
end --function output_addbranchbottom:action()

--5.3.3.2 add leaf to console.outputTree by insertleaf
output_addleafbottom = iup.item {title = "Blatt darunter hinzufügen"}
function output_addleafbottom:action()
	console.outputTree["insertleaf" .. console.outputTree.value] = ""
	for i=console.outputTree.value+1,console.outputTree.count-1 do
		if console.outputTree["depth" .. i]==console.outputTree["depth" .. console.outputTree.value] then
			console.outputTree.value=i
			output_renamenode:action()
			break
		end --if console.outputTree["depth" .. console.outputTree.value+1]==console.outputTree["depth" .. console.outputTree.value] then
	end --for i=console.outputTree.value+1,console.outputTree.count-1 do
end --function output_addleafbottom:action()

--5.3.3.3 add leaf to console.outputTree by insertleaf after the last leaf of the branch chosen
output_addleafbottomlevel = iup.item {title = "Blatt unter letztem Blatt hinzufügen"}
function output_addleafbottomlevel:action()
	if console.outputTree["KIND"]=="BRANCH" then
		console.outputTree["insertleaf" .. console.outputTree.value+console.outputTree.totalchildcount] = ""
				console.outputTree.value=console.outputTree.value+console.outputTree.totalchildcount
				output_renamenode:action()
	else
		console.outputTree["insertleaf" .. console.outputTree.value] = ""
		for i=console.outputTree.value+1,console.outputTree.count-1 do
			if console.outputTree["depth" .. i]==console.outputTree["depth" .. console.outputTree.value] then
				console.outputTree.value=i
				output_renamenode:action()
				break
			end --if console.outputTree["depth" .. console.outputTree.value+1]==console.outputTree["depth" .. console.outputTree.value] then
		end --for i=console.outputTree.value+1,console.outputTree.count-1 do
	end --if console.outputTree["KIND"]=="BRANCH" then
end --function output_addleafbottomlevel:action()

--5.3.4 add branch of console.outputTree from clipboard
output_addbranch_fromclipboard = iup.item {title = "Ast aus Zwischenablage"}
function output_addbranch_fromclipboard:action()
	console.outputTree.addbranch = clipboard.text
	console.outputTree.value=console.outputTree.value+1
end --function output_addbranch_fromclipboard:action()

--5.3.4.1 add branch to console.outputTree by insertbranch from clipboard
output_addbranch_fromclipboardbottom = iup.item {title = "Ast darunter aus Zwischenablage"}
function output_addbranch_fromclipboardbottom:action()
	console.outputTree["insertbranch" .. console.outputTree.value] = clipboard.text
	for i=console.outputTree.value+1,console.outputTree.count-1 do
	if console.outputTree["depth" .. i]==console.outputTree["depth" .. console.outputTree.value] then
		console.outputTree.value=i
		break
	end --if console.outputTree["depth" .. console.outputTree.value+1]==console.outputTree["depth" .. console.outputTree.value] then
	end --for i=console.outputTree.value+1,console.outputTree.count-1 do
end --function output_addbranch_fromclipboardbottom:action()

--5.3.4.2 add leaf to console.outputTree by insertleaf from clipboard
output_addleaf_fromclipboardbottom = iup.item {title = "Blatt darunter aus Zwischenablage"}
function output_addleaf_fromclipboardbottom:action()
	console.outputTree["insertleaf" .. console.outputTree.value] = clipboard.text
	for i=console.outputTree.value+1,console.outputTree.count-1 do
	if console.outputTree["depth" .. i]==console.outputTree["depth" .. console.outputTree.value] then
		console.outputTree.value=i
		break
	end --if console.outputTree["depth" .. console.outputTree.value+1]==console.outputTree["depth" .. console.outputTree.value] then
	end --for i=console.outputTree.value+1,console.outputTree.count-1 do
end --function output_addleaf_fromclipboardbottom:action()

--5.3.4.3 add leaf to console.outputTree by insertleaf after the last leaf of the branch chosen from clipboard
output_addleaf_fromclipboardbottom = iup.item {title = "Blatt unter letztem Blatt aus Zwischenablage"}
function output_addleaf_fromclipboardbottom:action()
	console.outputTree["insertleaf" .. console.outputTree.value+console.outputTree.totalchildcount] = clipboard.text
		console.outputTree.value=console.outputTree.value+console.outputTree.totalchildcount
end --function output_addleaf_fromclipboardbottom:action()

--5.3.5 add leaf of console.outputTree
output_addleaf = iup.item {title = "Blatt hinzufügen"}
function output_addleaf:action()
	console.outputTree.addleaf = ""
	console.outputTree.value=console.outputTree.value+1
	output_renamenode:action()
end --function output_addleaf:action()

--5.3.6 add leaf of console.outputTree from clipboard
output_addleaf_fromclipboard = iup.item {title = "Blatt aus Zwischenablage"}
function output_addleaf_fromclipboard:action()
	console.outputTree.addleaf = clipboard.text
	console.outputTree.value=console.outputTree.value+1
end --function output_addleaf_fromclipboard:action()

--5.3.7 copy a version of the file selected in the console.outputTree and give it the next version number
output_startversion = iup.item {title = "Version archivieren"}
function output_startversion:action()
	--get the version of the file
	if console.outputTree['title']:match("^.:\\.*%.[^\\]+") then
		Version=0
		p=io.popen('dir "' .. console.outputTree['title']:gsub("(%.+)","_Version*%1") .. '" /b/o')
		for Datei in p:lines() do 
			--test with: iup.Message("Version",Datei) 
			if Datei:match("_Version(%d+)") then Version_alt=Version Version=tonumber(Datei:match("_Version(%d+)")) if Version<Version_alt then Version=Version_alt end end
			--test with: iup.Message("Version",Version) 
		end --for Datei in p:lines() do 
		--test with: iup.Message(Version,Version+1)
		Version=Version+1
		iup.Message("Archivieren der Version:",console.outputTree['title']:gsub("(%.+)","_Version" .. Version .. "%1"))
		os.execute('copy "' .. console.outputTree['title'] .. '" "' .. console.outputTree['title']:gsub("(%.+)","_Version" .. Version .. "%1") .. '"')
	end --if console.outputTree['title']:match(".:\\.*%.[^\\]+") then
end --function output_startversion:action()


--5.3.7.1 delete all children nodes
output_delnode_children = iup.item {title = "Alle Knoten darunter löschen"}
function output_delnode_children:action()
	console.outputTree.delnode = "CHILDREN"
end --function output_delnode_children:action()

--5.3.7.2 delete all leafs under the branch
output_delnode_children_leafs = iup.item {title = "Alle Blätter darunter löschen"}
function output_delnode_children_leafs:action()
	local startNodeNumber=console.outputTree.value
	local endNodeNumber=console.outputTree.value+console.outputTree.totalchildcount
	local levelStartNode=console.outputTree['depth']
	for i=endNodeNumber,startNodeNumber+1,-1 do
		console.outputTree.value=i
		if console.outputTree['KIND']=="LEAF" and console.outputTree['depth']==tostring(levelStartNode+1) then
			console.outputTree.delnode = "SELECTED"
		end --if console.outputTree['KIND']=="LEAF" then
	end --for i=endNodeNumber,startNodeNumber,-1 do
end --function output_delnode_children_leafs:action()

--5.3.7.3 filter all leafs under the branch for pattern in console prompt
output_delnode_children_leafs_filter = iup.item {title = "Alle Blätter darunter filtern"}
function output_delnode_children_leafs_filter:action()
	local startNodeNumber=console.outputTree.value
	local endNodeNumber=console.outputTree.value+console.outputTree.totalchildcount
	local levelStartNode=console.outputTree['depth']
	for i=endNodeNumber,startNodeNumber+1,-1 do
		console.outputTree.value=i
		if console.outputTree['title']:match(console.prompt.value)==nil and console.outputTree['KIND']=="LEAF" and console.outputTree['depth']==tostring(levelStartNode+1) then
			console.outputTree.delnode = "SELECTED"
		end --if console.outputTree['KIND']=="LEAF" then
	end --for i=endNodeNumber,startNodeNumber,-1 do
end --function output_delnode_children_leafs_filter:action()

--5.3.8 start file of node of console.outputTree in IUP Lua scripter or start empty file in notepad or start empty scripter
output_startnodescripter = iup.item {title = "Skripter starten"}
function output_startnodescripter:action()
	--read first line of file. If it is empty then scripter cannot open it. So open file with notepad.exe
	if file_exists(console.outputTree['title']) then inputfile=io.open(console.outputTree['title'],"r") ErsteZeile=inputfile:read() inputfile:close() end
	if file_exists(console.outputTree['title']) and ErsteZeile then 
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. console.outputTree['title'] .. '"')
	elseif file_exists(console.outputTree['title']) then 
		os.execute('start "d" notepad.exe "' .. console.outputTree['title'] .. '"')
	else
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe ')
	end --if file_exists(console.outputTree['title']) and ErsteZeile then 
end --function output_startnodescripter:action()

--5.3.9 start the file or repository of the node of console.outputTree
output_startnode = iup.item {title = "Starten"}
function output_startnode:action() 
	if console.outputTree['title']:match("^.:\\.*%.[^\\ ]+$") or console.outputTree['title']:match("^.:\\.*[^\\]+$") or console.outputTree['title']:match("^.:\\$") or console.outputTree['title']:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "D" "' .. console.outputTree['title'] .. '"') 
	elseif console.outputTree['title']:match("sftp .*") then 
		os.execute(console.outputTree['title']) 
	end --if console.outputTree['title']:match("^.:\\.*%.[^\\ ]+$") or console.outputTree['title']:match("^.:\\.*[^\\]+$") or console.outputTree['title']:match("^.:\\$") or console.outputTree['title']:match("^[^ ]*//[^ ]+$") then 
end --function output_startnode:action()

--5.3.10 put the menu items together in the menu for console.outputTree
output_menu = iup.menu{
		output_startcopy,
		output_renamenode, 
		output_addbranch,
		output_addbranch_fromclipboard, 
		output_addbranchbottom,  
		output_addbranch_fromclipboardbottom, 
		output_addleaf,
		output_addleaf_fromclipboard,
		output_addleafbottom,
		output_addleafbottomlevel,
		output_addleaf_fromclipboardbottom,
		output_delnode_children, 
		output_delnode_children_leafs,
		output_delnode_children_leafs_filter,
		output_startversion, 
		output_startnodescripter, 
		output_startnode, 
		}
--5.3 menu of console.outputTree end


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
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nidiv.kaiser@t-online.de")
end --function button_logo:flat_action()

--6.2 button for saving tree
button_save_lua_table_input=iup.flatbutton{title="Eingabe-Baum\nspeichern", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table_input:flat_action()
	save_tree_to_lua(console.inputTree, path .. "\\" .. thisfilename:gsub("%.lua","_input.lua"),"lua_tree_input")
end --function button_save_lua_table_input:flat_action()

--6.2.1 button for loading tree
button_load_lua_table_input=iup.flatbutton{title="Eingabe-Baum\nneu laden", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_load_lua_table_input:flat_action()
	if file_exists(path .. "\\" .. thisfilename:gsub("%.lua","_input.lua")) then
		dofile(path .. "\\" .. thisfilename:gsub("%.lua","_input.lua"))
	end --if file_exists(path .. "\\" .. thisfilename:gsub("%.lua","_input.lua")) then
	--use recursive function to build variable inputs from tree as Lua variables
	readVariablesInTreeRecursive(lua_tree_input)
end --function button_load_lua_table_input:flat_action()

--6.3 button for saving tree
button_save_lua_table_command=iup.flatbutton{title="Command-Baum\nspeichern", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table_command:flat_action()
	save_tree_to_lua(console.commandTree, path .. "\\" .. thisfilename:gsub("%.lua","_command.lua"),"lua_tree_command")
end --function button_save_lua_table_command:flat_action()

--6.4 button for saving tree
button_save_lua_table_output=iup.flatbutton{title="Ausgabe-Baum\nspeichern", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table_output:flat_action()
	save_tree_to_lua(console.outputTree, path .. "\\" .. thisfilename:gsub("%.lua","_output.lua"),"lua_tree_output")
end --function button_save_lua_table_output:flat_action()

--7. Main Dialog
--7.1.1 load input tree from file
if file_exists(path .. "\\" .. thisfilename:gsub("%.lua","_input.lua")) then
	dofile(path .. "\\" .. thisfilename:gsub("%.lua","_input.lua"))
end --if file_exists(path .. "\\" .. thisfilename:gsub("%.lua","_input.lua")) then
console.inputTree = iup.tree{
	map_cb=function(self)
		if lua_tree_input then
			self:AddNodes(lua_tree_input)
		else
			self:AddNodes({branchname="input"})
		end --if lua_tree_input then
	end, --function(self)
	SIZE="150x200",
	showrename="YES",--F2 key active
	markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
	showdragdrop="YES",
}--console.inputTree = iup.tree{
-- Callback of the right mouse button click
function console.inputTree:rightclick_cb(id)
	console.inputTree.value = id
	menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function console.inputTree:rightclick_cb(id)
-- Callback for pressed keys
function console.inputTree:k_any(c)
	if c == iup.K_DEL then
		console.inputTree.delnode = "MARKED"
	elseif c == iup.K_cDEL then
		console.inputTree.delnode0 = "CHILDREN"
		console.inputTree.title='input'
		console.version_info()
	elseif c == iup.K_cC then
		--copy node of console.inputTree
		clipboard.text = console.inputTree['title']
	elseif c == iup.K_Menu then
		menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function console.inputTree:k_any(c)

--7.1.2 load command tree from file
if file_exists(path .. "\\" .. thisfilename:gsub("%.lua","_command.lua")) then
	dofile(path .. "\\" .. thisfilename:gsub("%.lua","_command.lua"))
end --if file_exists(path .. "\\" .. thisfilename:gsub("%.lua","_command.lua")) then
console.commandTree = iup.tree{
	map_cb=function(self)
		if lua_tree_command then
			self:AddNodes(lua_tree_command)
		else
			self:AddNodes({branchname="command"})
		end --if lua_tree_command then
	end, --function(self)
	SIZE="150x200",
	showrename="YES",--F2 key active
	markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
	showdragdrop="YES",
}--console.commandTree = iup.tree{
-- Callback of the right mouse button click
function console.commandTree:rightclick_cb(id)
	console.commandTree.value = id
	command_menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function console.commandTree:rightclick_cb(id)
-- Callback for pressed keys
function console.commandTree:k_any(c)
	if c == iup.K_DEL then
		console.commandTree.delnode = "MARKED"
	elseif c == iup.K_cDEL then
		console.commandTree.delnode0 = "CHILDREN"
		console.commandTree.title='command'
		console.version_info()
	elseif c == iup.K_cC then
		--copy node of console.commandTree
		clipboard.text = console.commandTree['title']
	elseif c == iup.K_Menu then
		command_menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function console.commandTree:k_any(c)

--7.1.3 load output tree from file
if file_exists(path .. "\\" .. thisfilename:gsub("%.lua","_output.lua")) then
	dofile(path .. "\\" .. thisfilename:gsub("%.lua","_output.lua"))
end --if file_exists(path .. "\\" .. thisfilename:gsub("%.lua","_output.lua")) then
console.outputTree = iup.tree{
	map_cb=function(self)
		if lua_tree_output then
			self:AddNodes(lua_tree_output)
		else
			self:AddNodes({branchname="output"})
		end --if lua_tree_command then
	end, --function(self)
	SIZE="150x200",
	showrename="YES",--F2 key active
	markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
	showdragdrop="YES",
}--console.outputTree = iup.tree{
-- Callback of the right mouse button click
function console.outputTree:rightclick_cb(id)
	console.outputTree.value = id
	output_menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function console.outputTree:rightclick_cb(id)
-- Callback for pressed keys
function console.outputTree:k_any(c)
	if c == iup.K_DEL then
		console.outputTree.delnode = "MARKED"
	elseif c == iup.K_cDEL then
		console.outputTree.delnode0 = "CHILDREN"
		console.outputTree.title='output'
	elseif c == iup.K_Menu then
		output_menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function console.outputTree:k_any(c)

--7.2 Main Dialog
console.dialog = iup.dialog{
	iup.hbox{
		iup.vbox{
			iup.frame{title = "Input:",
				iup.hbox{ -- use it to inherit margins
					--console.output,
					console.inputTree,
				}, --iup.hbox{
			}, --iup.frame{title = "Input:",
		}, --iup.vbox{
		iup.vbox{
			iup.hbox{button_logo, button_save_lua_table_input,button_load_lua_table_input,button_save_lua_table_command,button_save_lua_table_output,
				iup.vbox{console.textbox_branch,console.textbox_leaf},
			}, --iup.hbox{
			iup.frame{title = "Command:",
				iup.hbox{ -- use it to inherit margins
					console.prompt,
					}, --iup.hbox{
			}, --iup.frame{title = "Command:",
			iup.frame{title = "Command Tree:",
				iup.hbox{ -- use it to inherit margins
					--console.output,
					console.commandTree,
				}, --iup.hbox{
			}, --iup.frame{title = "Input:",
			--margin = "5x5",
			--gap = "5",
		}, --iup.vbox{
		iup.vbox{
			iup.frame{title = "Output:",
				iup.hbox{ -- use it to inherit margins
					--console.output,
					console.outputTree,
				}, --iup.hbox{
			}, --iup.frame{title = "Input:",
		}, --iup.vbox{
	}, --iup.vbox{
	title="Lua Console", 
	size="FULLxFULL", -- initial size
	icon=img_logo, -- 0 use the Lua icon from the executable in Windows
} --iup.dialog{

--7.3 close Main Dialog
function console.dialog:close_cb()
	print = console.orig_print  -- restore print and io.write
	io.write = console.orig_write
	iup.ExitLoop()  -- should be removed if used inside a bigger application
	console.dialog:destroy()
	return iup.IGNORE
end

--7.4 show the dialog
console.dialog:showxy(iup.LEFT,iup.CENTER)
console.dialog.size = nil -- reset initial size, allow resize to smaller values
iup.SetFocus(console.prompt)

--7.5 fill the tree with version informations if tree not build by file
if lua_tree_output==nil then
	console.version_info()
end --if lua_tree_input then

--7.6 load the data use recursive function to build variable inputs from tree as Lua variables
if lua_tree_input then
	readVariablesInTreeRecursive(lua_tree_input)
end --if lua_tree_input then

--7.7 Main Loop
if (iup.MainLoopLevel() == 0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel() == 0) then
