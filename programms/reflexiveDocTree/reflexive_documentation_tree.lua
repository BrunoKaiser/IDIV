lua_tree_output={ branchname="example of a reflexive tree", 
{ branchname="Node 1", 
state="COLLAPSED",
{ branchname="Node 2", 
state="COLLAPSED",
 "Leaf",}}}--lua_tree_output

----[====[This script is a documentation of itself. The tree is in the first part, the programm separated from it in the second part, but they are both saved as one script, documenting itself by this effect

--1. basic data

--1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iuplua_scintilla") --for Scintilla-editor

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



--3.2 functions for GUI

--3.2.1 function which saves the current iup tree as a Lua table
function save_tree_to_lua(tree, outputfile_path)
	--read the programm of the file itself, commentSymbol is used to have another pattern here as searched
	inputfile=io.open(path .. "\\" .. thisfilename,"r")
	commentSymbol,inputTextProgramm=inputfile:read("*a"):match("lua_tree_output={.*}(--)lua_tree_output(.*)")
	inputfile:close()
	--build the new tree
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
end --function save_tree_to_lua(tree, outputfile_path)


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


--3.3.2 function to change expand/collapse relying on depth
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

--4.1.1 change dialog
--ok button
ok_with_children = iup.flatbutton{title = "Vorschau",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function ok_with_children:flat_action()
	tree_with_children.delnode0 = "CHILDREN"
	tree_with_children.title=tree['title']
	--example text variable
	text=text_with_children.value
	--read data from textfield
	outputText='tree_tabtext_script={branchname="Neuer Baum"' --is omitted by get only the new tree without title
	pos_prevline=0
	pos_curline=0
	for line in (text .. "\n"):gmatch("([^\n]*)\n") do
		if line~="" and line:match('%S')~=nil then
			pos_prevline=pos_curline --update position
			pos_curline=0
			local helpstring='\t' .. line
			while helpstring:match('^\t')~=nil do -- get position of current line
				pos_curline=pos_curline+1
				helpstring=helpstring:gsub('^\t','')
			end --while helpstring:match('^\t')~=nil do
			-- modify helpstring in order to get desired results
			while helpstring:match('^ ')~=nil do
				helpstring=helpstring:gsub('^ ', '')
			end --while helpstring:match('^ ')~=nil do
			while helpstring:match('^ ')~=nil do
				helpstring=helpstring:gsub('^ ', '')
			end --while helpstring:match('^ ')~=nil do
			helpstring=string.escape_forbidden_char(helpstring)
			--print(pos_curline, pos_prevline)
			if pos_curline<pos_prevline then
				for i=1, pos_prevline-pos_curline +1 do
					outputText=outputText .. '\n},' 
				end --for i=1, pos_prevline-pos_curline +1 do
			elseif pos_curline==pos_prevline and pos_curline~=0 then
				outputText=outputText .. '\n},' 
			elseif pos_curline==pos_prevline+1 then
				outputText=outputText .. ','
			elseif pos_curline>pos_prevline then
				for i=1, pos_curline-pos_prevline-1 do
					outputText=outputText .. ','
					outputText=outputText .. '\n{branchname="missing",'
				end --for i=1, pos_prevline-pos_curline-1 do
			end --if pos_curline<pos_prevline then
			--if lines are to long then build leafs with the rest of the lines up to a maximum length beeing lower than 259 for IUP tree
			local maxLength=259 --must be lower than 259 for a IUP tree
			if #helpstring>maxLength then
				--collect words from textTable
				local wordTable={}
				for textWord in (helpstring .. " "):gmatch(".- ") do 
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
				outputText=outputText .. '\n{branchname="' .. lineTable[1]:gsub(" $","") .. '",'
				for i=2,#lineTable-1 do
					outputText=outputText .. '\n"' .. lineTable[i]:gsub(" $","") .. '",'
				end --for i=2,#lineTable do
				outputText=outputText .. '\n"' .. lineTable[#lineTable]:gsub(" $","") .. '"'
			else
				outputText=outputText .. '\n{branchname="' .. helpstring:gsub(" $","") .. '"'
			end --if #helpstring>maxLength then
		end --if line~="" and line:match('%S')~=nil then
	end --for line in (text .. "\n"):gmatch("([^\n]*)\n") do
	--write end curly brackets
	for i=1, pos_curline+1 do
		outputText=outputText .. '\n}'
	end --for i=1, pos_curline+1 do
	outputText=outputText:gsub(",,",",") --correction for '\n{branchname="missing",' when to or more missings
	--test with: print(outputText:match("%b{}"))
	--test with: print(outputText)
	--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
	--get only the new tree without title
	outputText=outputText:gsub('{branchname="Neuer Baum",',''):gsub('}$','')
	if _VERSION=='Lua 5.1' then
		loadstring(outputText)()
	else
		load(outputText)() --now actualtree is the table.
	end --if _VERSION=='Lua 5.1' then
	outputTextLeaf="Tree="
	--recursiv build leafs if there is no table as child
	local function makeLeafsRecursive(TreeTable,outputTreeTable)
		outputTreeTable.branchname=TreeTable.branchname
		outputTextLeaf=outputTextLeaf .. '{branchname="' .. TreeTable.branchname .. '",\n'
		--test with: print("B " .. outputTreeTable.branchname)
		for i,v in ipairs(TreeTable) do
			if type(v)=="table" and #v > 0 then
				--test with: print(v.branchname)
				outputTreeTable[i]={}
				makeLeafsRecursive(v,outputTreeTable[i])
			elseif type(v)=="table" then
				outputTreeTable[i]=v.branchname
				--test with: print("Leaf: " .. v.branchname)
				--test with: print("Leaf: " .. type(outputTreeTable[i]))
				outputTextLeaf=outputTextLeaf .. '"' .. v.branchname .. '",\n'
			else
				outputTreeTable[i]=v
				outputTextLeaf=outputTextLeaf .. '"' .. v .. '",\n'
			end --if #TreeTable > 0 then
		end --for i,v in ipairs(TreeTable) do
		outputTextLeaf=outputTextLeaf .. '},\n'
	end --function makeLeafsRecursive(TreeTable,outputTreeTable)
	outputtree_tabtext_script={}
	makeLeafsRecursive(tree_tabtext_script,outputtree_tabtext_script)
	iup.TreeAddNodes(tree_with_children,outputtree_tabtext_script)
	--omit the last commma
	outputTextLeaf=outputTextLeaf:gsub("},\n$","}\n")
	outputtext_with_children.value=outputTextLeaf
	--test with: iup.TreeAddNodes(tree_with_children,{branchname="Test","Test"})
	--return iup.CLOSE
end --function ok_with_children:flat_action()

--change button
change_tree_with_children = iup.flatbutton{title = "Baum ändern",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function change_tree_with_children:flat_action()
	if outputtree_tabtext_script then
		tree['delnode' .. tree.value] = "CHILDREN"
		iup.TreeAddNodes(tree,outputtree_tabtext_script,tree.value)
	end --if outputtree_tabtext_script then
end --function change_tree_with_children:flat_action()

--csv to tree button
csv_to_tree = iup.flatbutton{title = "CSV-Abschnitte in den Baum integrieren",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function csv_to_tree:flat_action()
	textCsv=text_with_children.value
	outputtextCsv=""
	numberTabs=0
	for line_raw in (textCsv .. "\n"):gmatch("([^\n]*)\n") do
		--delete double ;; or more as option
		--line_raw=line_raw:gsub(";+",";")
		if line_raw:match("^\t+[^\t]+$") then
			outputtextCsv=outputtextCsv .. line_raw .. "\n"
			_,numberTabs=line_raw:gsub("\t","")
			--test with: print(numberTabs)
		elseif line_raw:match(";")==nil then
			outputtextCsv=outputtextCsv .. line_raw .. "\n"
			numberTabs=0
		else
			--test with: print(line_raw)
			line=line_raw
			--build table with nodes
			TabTable={}
			for i=#line_raw,1,-1 do
				if line:sub(i,i)==";" then
					--test with: print(line:sub(1,i):gsub("[^;]",""):gsub(";","\t") .. line:sub(i+1)
					TabTable[#TabTable+1]=string.rep("\t",numberTabs+1) .. line:sub(1,i):gsub("[^;]",""):gsub(";","\t") .. line:sub(i+1)
					line=line:sub(1,i-1)
				end --if line:sub(i,i)==";" then
			end --for i=#line_raw,1,-1 do
			--integrate the csv part in the tree
			outputtextCsv=outputtextCsv .. string.rep("\t",numberTabs+1) .. line .. "\n"
			for k=#TabTable,1,-1 do
				outputtextCsv=outputtextCsv .. TabTable[k] .. "\n"
			end --for k=#TabTable,1,-1 do
		end --if line_raw:match("^\t+[^\t]+$") then
	end --for line_raw in (textCsv .. "\n"):gmatch("([^\n]*)\n") do
	text_with_children.value=outputtextCsv
end --function csv_to_tree:flat_action()

--csv to tree button
tabs_to_tree = iup.flatbutton{title = "Tabulator-Tabellen-Abschnitte in den Baum integrieren",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function tabs_to_tree:flat_action()
	textCsv=text_with_children.value
	outputtextCsv=""
	numberTabs=0
	for line_raw in (textCsv .. "\n"):gmatch("([^\n]*)\n") do
		--delete double ;; or more as option
		--line_raw=line_raw:gsub(";+",";")
		if line_raw:match("^\t+[^\t]+$") then
			outputtextCsv=outputtextCsv .. line_raw .. "\n"
			_,numberTabs=line_raw:gsub("\t","")
			--test with: print(numberTabs)
		elseif line_raw:match("\t")==nil then
			outputtextCsv=outputtextCsv .. line_raw .. "\n"
			numberTabs=0
		else
			--test with: print(line_raw)
			line=line_raw
			--build table with nodes
			TabTable={}
			for i=#line_raw,1,-1 do
				if line:sub(i,i)=="\t" then
					--test with: print(line:sub(1,i):gsub("[^\t]","") .. line:sub(i+1)
					TabTable[#TabTable+1]=string.rep("\t",numberTabs+1) .. line:sub(1,i):gsub("[^\t]","") .. line:sub(i+1)
					line=line:sub(1,i-1)
				end --if line:sub(i,i)=="\t" then
			end --for i=#line_raw,1,-1 do
			--integrate the csv part in the tree
			outputtextCsv=outputtextCsv .. string.rep("\t",numberTabs+1) .. line .. "\n"
			for k=#TabTable,1,-1 do
				outputtextCsv=outputtextCsv .. TabTable[k] .. "\n"
			end --for k=#TabTable,1,-1 do
		end --if line_raw:match("^\t+[^\t]+$") then
	end --for line_raw in (textCsv .. "\n"):gmatch("([^\n]*)\n") do
	text_with_children.value=outputtextCsv
end --function tabs_to_tree:flat_action()

--cancel button
cancel_with_children = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function cancel_with_children:flat_action()
	return iup.CLOSE
end --function cancel_with_children:flat_action()

--preview field as scintilla editor
text_with_children=iup.scintilla{value=""}
text_with_children.SIZE="290x200" --I think this is not optimal! (since the size is so appears to be fixed)
text_with_children.wordwrap="WORD" --enable wordwarp
text_with_children.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
text_with_children.FONT="Courier New, 12" --font of shown code
text_with_children.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
text_with_children.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
text_with_children.STYLEFGCOLOR0="0 0 0"      -- 0-Default
text_with_children.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
text_with_children.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
text_with_children.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
text_with_children.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
text_with_children.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
text_with_children.STYLEFGCOLOR6="160 20 180"  -- 6-String 
text_with_children.STYLEFGCOLOR7="128 0 0"    -- 7-Character
text_with_children.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
text_with_children.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
text_with_children.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--text_with_children.STYLEBOLD10="YES"
--text_with_children.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--text_with_children.STYLEITALIC10="YES"
text_with_children.MARGINWIDTH0="40"

--preview field as scintilla editor
outputtext_with_children=iup.scintilla{value=""}
outputtext_with_children.SIZE="190x200" --I think this is not optimal! (since the size is so appears to be fixed)
outputtext_with_children.wordwrap="WORD" --enable wordwarp
outputtext_with_children.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
outputtext_with_children.FONT="Courier New, 12" --font of shown code
outputtext_with_children.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
outputtext_with_children.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
outputtext_with_children.STYLEFGCOLOR0="0 0 0"      -- 0-Default
outputtext_with_children.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
outputtext_with_children.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
outputtext_with_children.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
outputtext_with_children.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
outputtext_with_children.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
outputtext_with_children.STYLEFGCOLOR6="160 20 180"  -- 6-String 
outputtext_with_children.STYLEFGCOLOR7="128 0 0"    -- 7-Character
outputtext_with_children.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
outputtext_with_children.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
outputtext_with_children.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--outputtext_with_children.STYLEBOLD10="YES"
--outputtext_with_children.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--outputtext_with_children.STYLEITALIC10="YES"
outputtext_with_children.MARGINWIDTH0="40"



label1_with_children = iup.label{title="Tabulator-Baum:"}--label for textfield

actualtree_with_children={branchname="Knoten"}

tree_with_children=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree_with_children)
end, --function(self)
SIZE="400x170",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}

--open the dialog for renaming branch/leaf
dlg_rename_with_children = iup.dialog{
	iup.vbox{label1_with_children, iup.hbox{text_with_children,tree_with_children,outputtext_with_children}, iup.hbox{ok_with_children,change_tree_with_children,csv_to_tree,tabs_to_tree,cancel_with_children}}; 
	title="Knoten mit Unterknoten bearbeiten",
	size="FULLxHALF",
	startfocus=text,
	}

--4.1.1 change dialog end


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
end --function searchup:flat_action()

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

--5.1.2 rename node and rename action for other needs of tree
renamenode = iup.item {title = "Knoten bearbeiten"}
function renamenode:action()
	text.value = tree['title']
	dlg_rename:popup(iup.CENTER, iup.CENTER) --popup rename dialog
	iup.SetFocus(tree)
end --function renamenode:action()

--5.1.2.1 rename node and children and rename action for other needs of tree
renamenode_with_children = iup.item {title = "Knoten mit Unterknoten bearbeiten"}
function renamenode_with_children:action()
	local textReplace = ""
	--test with: print(tree['totalchildcount' .. tree.value])
	for i=tree.value,tree.value+tree['totalchildcount' .. tree.value] do
		textReplace = textReplace .. string.rep("\t",tree['depth' .. i]-tree['depth' .. tree.value]) .. tree['title' .. i] .. "\n"
	end --for i=tree.value,tree['childcount'] do
	text_with_children.value=textReplace
	dlg_rename_with_children:popup(iup.CENTER, iup.CENTER) --popup rename dialog
end --function renamenode_with_children:action()

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

--5.1.6.1 add branch to tree by insertbranch
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

--5.1.6.2 add leaf to tree by insertleaf
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

--5.1.6.3 add branch to tree by insertbranch from clipboard
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

--5.1.6.4 add leaf to tree by insertleaf from clipboard
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

--5.1.7.1 copy a version of the file selected in the tree and give it the next version number
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

--5.1.7.2 show length of the node text
show_length = iup.item {title = "Länge anzeigen"}
function show_length:action()
	iup.Message("Die Länge von " .. tree['title'],"ist: " .. #tostring(tree['title']))
end --function show_length:action()

--5.1.8 start the file or repository of the node of tree
startnode = iup.item {title = "Starten"}
function startnode:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then os.execute('start "D" "' .. tree['title'] .. '"') end
end --function startnode:action()

--5.1.9 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,
		renamenode, 
		renamenode_with_children, 
		addbranch, 
		addbranch_fromclipboard, 
		addbranchbottom,  
		addbranch_fromclipboardbottom, 
		addleaf,
		addleaf_fromclipboard,
		addleafbottom,
		addleaf_fromclipboardbottom,
		show_length,
		startversion,
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
	save_tree_to_lua(tree, path .. "\\" .. thisfilename)
end --function button_save_lua_table:flat_action()


--6.2.1 button for exporting tree to csv
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
	end --for i=0,tree.count-1 do
	--open a filedialog
	--filedlg2=iup.filedlg{dialogtype="SAVE",title="Ziel auswählen",filter="*.txt",filterinfo="Text Files", directory="c:\\temp"}
	--filedlg2:popup(iup.ANYWHERE,iup.ANYWHERE)
	--if filedlg2.status=="1" or filedlg2.status=="0" then
		local outputfile=io.output("C:\\Temp\\CSV_Tree.txt") --setting the outputfile
			for i=1,numberColumnsTotal-1 do outputfile:write("Field" .. i .. ";") end
			outputfile:write("Field" .. numberColumnsTotal .. "\n")
			for k,v in pairs(pathTable) do
				outputfile:write(v .. "\n")
			end --for k,v in pairs(pathTable) do
		outputfile:close() --close the outputfile
	--else --no outputfile was choosen
	--	iup.Message("Schließen","Keine Datei ausgewählt")
	--	iup.NextField(maindlg)
	--end --if filedlg2.status=="1" or filedlg2.status=="0" then
end --function button_export_tree_to_csv:flat_action()


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

--6.6 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de")
end --function button_logo:flat_action()

--6 buttons end


--7 Main Dialog
--7.1 load tree from self file
actualtree=lua_tree_output
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

--7.2.1 write locking file if it does not exist
if file_exists(path .. "\\" .. thisfilename:gsub("%.lua$",".lualock")) then
	fileLocked="YES"
else
	fileLocked="NO"
	outputfile_lock=io.open( path .. "\\" .. thisfilename:gsub("%.lua$",".lualock") , "w")
	outputfile_lock:write(os.getenv("USERNAME") .. "\n")
	outputfile_lock:close()
end --if file_exists(path .. "\\" .. thisfilename:gsub("%.lua$",".lualock")) then


--7.2.2 building the dialog and put buttons and tree together depending on locking file
if fileLocked=="YES" then
	maindlg = iup.dialog{
		--simply show a box with buttons
		iup.vbox{
			--first row of buttons
			iup.hbox{
				button_logo,
				button_search,
				button_expand_collapse_dialog,
				button_replace,
				iup.label{size="10x",},
				button_compare,
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
else
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
				button_replace,
				iup.label{size="10x",},
				button_compare,
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
end --if fileLocked=="YES" then

--7.2.1 show the dialog
maindlg:show()

--7.3 callback on close of the main dialog for saving and unlocking
function maindlg:close_cb()
	if fileLocked=="YES" then
		--locked file is closed without asking
	else
		os.execute('del ' .. path .. "\\" .. thisfilename:gsub("%.lua$",".lualock"))
		EndeAlarm=iup.Alarm("Alarm","Wollen Sie den Baum speichern?","Speichern","Nein")
		if EndeAlarm==1 then 
			save_tree_to_lua(tree, path .. "\\" .. thisfilename)
			iup.ExitLoop()
			maindlg:destroy()
			return iup.IGNORE
		end --if EndeAlarm==1 then 
	end --if fileLocked=="YES" then
end --function maindlg:close_cb()

--7.4 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then

--]====]
