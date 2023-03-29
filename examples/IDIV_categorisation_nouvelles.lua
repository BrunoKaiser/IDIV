--This script is a news tree at the right side, at the left a tree with chosen titles and texts, in webbrowser the text corresponding to the titles is shown


--1. basic data

--1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iupluaweb")        --require iupluaweb for webbrowser
require("luacom")           --require treatment of office files, especially for converting PDF to text file with Word

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

--2.3 script for manual tree
path_documentation_tree= path .. "\\documentation_tree_News.lua"

--2.4 initialise the data needed
TextHTMLtable={}
NewsTree={branchname="Neue Nachrichten am " .. os.date("%d.%m.%Y") .. " auf C:\\Tree\\Tree_News\\PDF_News_inputs",}

--2.4.1 example 1: load Welt Nachrichten
p=io.popen('dir "C:\\tree\\Tree_News\\Lua_News_outputs\\Welt_*.lua" /b/o-N')
FileNewNews=p:read()
print(FileNewNews)
timeStamp_Welt_aktuell=FileNewNews:lower():match("(%d%d%d%d%d%d%d%d).lua")
NewsTree[1]={branchname="Welt-Nachrichten vom " .. timeStamp_Welt_aktuell,state="COLLAPSED",}
FileOldNews=p:read()
if FileNewNews and FileOldNews then
	dofile("C:\\tree\\Tree_News\\Lua_News_outputs\\" .. FileOldNews)
	oldNewsTable=TitleTextTable
	oldTree=tree2
	dofile("C:\\tree\\Tree_News\\Lua_News_outputs\\" .. FileNewNews)
	for k,v in pairs(TitleTextTable) do
		if oldNewsTable[k]==nil and k:match(" ") then
			TextHTMLtable[k]=v
			NewsTree[1][#NewsTree[1]+1]=k
		end --if oldNewsTable[k]==nil then
	end --for k,v in pairs(TitleTextTable) do
	table.sort(NewsTree[1],function(a,b) local alower=a:gsub('"',""):lower() local blower=b:gsub('"',""):lower() return alower<blower end)
end --if FileNewNews and FileOldNews then

--2.4.2 example 2: Domradio Nachrichten
p=io.popen('dir "C:\\tree\\Tree_News\\Lua_News_outputs\\Domradio_*.lua" /b/o-N')
FileNewNews=p:read()
print(FileNewNews)
timeStamp_Domradio_aktuell=FileNewNews:lower():match("(%d%d%d%d%d%d%d%d).lua")
NewsTree[2]={branchname="Domradio-Nachrichten vom " .. timeStamp_Domradio_aktuell,state="COLLAPSED",}
FileOldNews=p:read()
if FileNewNews and FileOldNews then
	dofile("C:\\tree\\Tree_News\\Lua_News_outputs\\" .. FileOldNews)
	oldNewsTable=TitleTextTable
	oldTree=tree2
	dofile("C:\\tree\\Tree_News\\Lua_News_outputs\\" .. FileNewNews)
	for k,v in pairs(TitleTextTable) do
		if oldNewsTable[k]==nil and k:match(" ") then
			TextHTMLtable[k]=v
			NewsTree[2][#NewsTree[2]+1]=k
		end --if oldNewsTable[k]==nil then
	end --for k,v in pairs(TitleTextTable) do
	table.sort(NewsTree[2],function(a,b) local alower=a:gsub('"',""):lower() local blower=b:gsub('"',""):lower() return alower<blower end)
end --if FileNewNews and FileOldNews then




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

--3.2.1 function for writing tree2 in a text file (function for printing tree2)
function printtree()
	--open a filedialog
	filedlg2=iup.filedlg{dialogtype="SAVE",title="Ziel auswählen",filter="*.txt",filterinfo="Text Files", directory="c:\\temp"}
	filedlg2:popup(iup.ANYWHERE,iup.ANYWHERE)
	if filedlg2.status=="1" or filedlg2.status=="0" then
		local outputfile=io.output(filedlg2.value) --setting the outputfile
		for i=0,tree2.totalchildcount0 do
			local helper=tree2['title' .. i]
			for j=1,tree2['depth' .. i] do
				helper='\t' ..  helper
			end --for j=1,tree2['depth' .. i] do
			outputfile:write(helper, '\n')
		end --for i=0,tree2.totalchildcount0 do
		outputfile:close() --close the outputfile
	else --no outputfile was choosen
		iup.Message("Schließen","Keine Datei ausgewählt")
		iup.NextField(maindlg)
	end --if filedlg2.status=="1" or filedlg2.status=="0" then
end --function printtree()

--3.2.2 function which saves the current iup tree as a Lua table
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
end --function save_tree_to_lua(tree, outputfile_path)

--3.3 function to change expand/collapse relying on depth
--This function is needed in the expand/collapsed dialog. This function relies on the depth of the given level.
function change_state_level(new_state,level,descendants_also)
	if descendants_also=="YES" then
		for i=0,tree2.count-1 do
			if tree2["depth" .. i]==level then
				iup.TreeSetNodeAttributes(tree2,i,{state=new_state}) --changing the state of current node
				iup.TreeSetDescendantsAttributes(tree2,i,{state=new_state})
			end --if tree2["depth" .. i]==level then
		end --for i=0,tree2.count-1 do
	else
		for i=0,tree2.count-1 do
			if tree2["depth" .. i]==level then
				iup.TreeSetNodeAttributes(tree2,i,{state=new_state})
			end --if tree2["depth" .. i]==level then
		end --for i=0,tree2.count-1 do
	end --if descendants_also=="YES" then
end --function change_state_level(new_state,level,descendants_also)


--3.4 function to change expand/collapse relying on keyword
--This function is needed in the expand/collapsed dialog. This function changes the state for all nodes, which match a keyword. Otherwise it works like change_stat_level.
function change_state_keyword(new_state,keyword,descendants_also)
	if descendants_also=="YES" then
		for i=0,tree2.count-1 do
			if tree2["title" .. i]:match(keyword)~=nil then
				iup.TreeSetNodeAttributes(tree2,i,{state=new_state})
				iup.TreeSetDescendantsAttributes(tree2,i,{state=new_state})
			end --if tree2["title" .. i]:match(keyword)~=nil then
		end --for i=0,tree2.count-1 do
	else
		for i=0,tree2.count-1 do
			if tree2["title" .. i]:match(keyword)~=nil then
				iup.TreeSetNodeAttributes(tree2,i,{state=new_state})
			end --if tree2["title" .. i]:match(keyword)~=nil then 
		end --for i=0,tree2.count-1 do
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
	for i=0, tree2.count - 1 do
			tree2["color" .. i]="0 0 0"
	end --for i=0, tree2.count - 1 do
	--unmark all nodes end
	--mark all nodes
	for i=0, tree.count - 1 do
		if tree["title" .. i]:upper():match(searchtext.value:upper())~= nil then
			iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
		end --if tree["title" .. i]:upper():match(searchtext.value:upper())~= nil then
	end --for i=0, tree2.count - 1 do
	for i=0, tree2.count - 1 do
		if tree2["title" .. i]:upper():match(searchtext.value:upper())~= nil then
			iup.TreeSetAncestorsAttributes(tree2,i,{color="255 0 0",})
			iup.TreeSetNodeAttributes(tree2,i,{color="0 0 250",})
			iup.TreeSetDescendantsAttributes(tree2,i,{color="90 195 0"})
		end --if tree2["title" .. i]:upper():match(searchtext.value:upper())~= nil then
	end --for i=0, tree2.count - 1 do
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

	for i=0, tree2.count - 1 do
		--search in text files if checkbox on
		if checkboxforsearchinfiles.value=="ON"  and file_exists(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) 
		and ((tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.txt$")
		or (tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.sas$") 
		 or (tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.csv$") 
		 or (tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.lua%d*$")
		 or (tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.iup%d*lua%d*$")
		 or (tree2.title0:match(".:\\.*") .. tree2["title" .. i]):lower():match("^.:\\.*%.wlua$")
		)
		then
			DateiFundstelle=""
			for textLine in io.lines(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) do if textLine:lower():match(searchtext.value:lower()) then DateiFundstelle=DateiFundstelle .. textLine .. "\n"  end end
			if DateiFundstelle~="" then
					iup.TreeSetAncestorsAttributes(tree2,i,{color="255 0 0",})
					iup.TreeSetNodeAttributes(tree2,i,{color="0 0 250",})
					iup.TreeSetDescendantsAttributes(tree2,i,{color="90 195 0"})
			end --if DateiFundstelle~="" then
		end --if checkboxforsearchinfiles.value=="ON"  and file_exists(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i])
		--search in text files if checkbox on end
	end --for i=0, tree2.count - 1 do
end --function searchmark:flat_action()

--unmark without leaving the search-window
unmark    = iup.flatbutton{title = "Entmarkieren",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function unmark:flat_action()
	--unmark all nodes
	for i=0, tree.count - 1 do
		tree["color" .. i]="0 0 0"
	end --for i=0, tree.count - 1 do
	for i=0, tree2.count - 1 do
		tree2["color" .. i]="0 0 0"
	end --for i=0, tree2.count - 1 do
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


--search searchtext.value in textfield1
search_in_texts   = iup.flatbutton{title = "Suche in den Texten",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function search_in_texts:flat_action()
	for k,v in pairs(manualTreeNewsTable) do
		if v:match(searchtext.value) then 
			--test with: iup.Message(k,v) 
			for i=0,tree.count-1 do if tree['title' .. i]==k then
							iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
							iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
							iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
						end --if tree['title' .. i]==k then
			end --for i=0,tree.count-1 do if tree['title' .. i]==k then
		end --if v:match(searchtext.value) then 
	end --for k,v in pairs(manualTreeNewsTable) do
	for k,v in pairs(TextHTMLtable) do
		if v:match(searchtext.value) then 
			--test with: iup.Message(k,v) 
			for i=0,tree2.count-1 do 
				if tree2['title' .. i]==k then
					iup.TreeSetAncestorsAttributes(tree2,i,{color="255 0 0",})
					iup.TreeSetNodeAttributes(tree2,i,{color="0 0 250",})
					iup.TreeSetDescendantsAttributes(tree2,i,{color="90 195 0"})
				end --if tree2['title' .. i]==k then
			end --for i=0,tree2.count-1 do if tree2['title' .. i]==k then
		end --if v:match(searchtext.value) then 
	end --for k,v in pairs(TextHTMLtable) do
end --function search_in_texts:flat_action()


--put above together in a search dialog
dlg_search =iup.dialog{
			iup.vbox{iup.hbox{search_label,searchtext,}, 

			iup.label{title="Sonderzeichen: %. für ., %- für -, %+ für +, %% für %, %[ für [, %] für ], %( für (, %) für ), %^ für ^, %$ für $, %? für ?",},
			iup.hbox{searchmark,unmark,checkboxforsearchinfiles,}, 

			iup.label{title="rot: übergeordnete Knoten",fgcolor = "255 0 0", },
			iup.label{title="blau: gleicher Knoten",fgcolor = "0 0 255", },
			iup.label{title="grün: untergeordnete Knoten",fgcolor = "90 195 0", },

			iup.hbox{searchdown, searchup,checkboxforcasesensitive,},

			iup.hbox{search_in_texts,},



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
			change_state_level(new_state,tree2.depth,"YES")
		else
			change_state_level(new_state,tree2.depth)
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
		--test with: 	for k,v in pairs(tree_temp) do print(k,v) end
		tree_temp={branchname=tree["title0"],tree_temp}
		iup.TreeAddNodes(tree,tree_temp)
	elseif numberCurlyBraketsBegin==numberCurlyBraketsEnd then
		load('tree_temp='..TreeText)() --now tree_temp is filled
		--test with: 	for k,v in pairs(tree_temp) do print(k,v) end
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

--5.1.7 copy a version of the file selected in the tree and give it the next version number
startversion = iup.item {title = "Version archivieren"}
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

--5.1.8 start file of node of tree in IUP Lua scripter or start empty file in notepad or start empty scripter
startnodescripter = iup.item {title = "Skripter starten"}
function startnodescripter:action()
	--read first line of file. If it is empty then scripter cannot open it. So open file with notepad.exe
	if file_exists(tree['title']) then inputfile=io.open(tree['title'],"r") ErsteZeile=inputfile:read() inputfile:close() end
	if file_exists(tree['title']) and ErsteZeile then 
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. tree['title'] .. '"')
	elseif file_exists(tree['title']) then 
		os.execute('start "d" notepad.exe "' .. tree['title'] .. '"')
	else
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe ')
	end --if file_exists(tree['title']) and ErsteZeile then 
end --function startnodescripter:action()

--5.1.9 start the file or repository of the node of tree
startnode = iup.item {title = "Starten"}
function startnode:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "D" "' .. tree['title'] .. '"') 
	elseif tree['title']:match("sftp .*") then 
		os.execute(tree['title']) 
	end --if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
end --function startnode:action()

--5.1.10 put the menu items together in the menu for tree
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
		startversion,
		startnodescripter, 
		startnode, 
		}
--5.1 menu of tree end


--5.2 menu of tree2
--5.2.1 copy node of tree2
startcopy = iup.item {title = "Knoten kopieren"}
function startcopy:action() --copy node
	clipboard.text = tree2['title']
	--take the corresponding text
	if tonumber(tree2['title']) then 
		actualPage=math.tointeger(tonumber(tree2['title'])) 
		actualPage=tonumber(tree2['title'])
	else
		--test with: iup.Message("Text",tostring(TextHTMLtable[textbox1.value]))
		if TextHTMLtable[tree2['title']] then
			manualTreeNewsTable[tree2['title']]=TextHTMLtable[tree2['title']]
		else
			textbox1.value=tree2['title'] .. " hat keine Webpage"
		end --if TextHTMLtable[tree2['title']] then
	end --if tonumber(textbox1.value) then 
end --function startcopy:action()

--5.1.2 copy node of tree2 with all children and add to the root of the tree
startcopy_withchilds2 = iup.item {title = "An Zuordnung senden"}
function startcopy_withchilds2:action() --copy first node with same text as selected node with all its child nodes
	local TreeText=""
	local takeNode="yes"
	local actualDepth=1
	local numberOfNode=math.tointeger(tonumber(tree2.value))
	local depthOfNode=tree2["DEPTH" .. numberOfNode]
	for i=numberOfNode, tree2.count-1 do
		if tree2["KIND" .. numberOfNode ]=="LEAF" then
			--test with: print(tree2["KIND" .. i],tree2["MARKED" .. i])
			if tree2["KIND" .. i]=="LEAF" and tree2["MARKED" .. i]=="YES" then
				if tree2["TITLE" .. i]:match("^\\.*") then
					tree.addleaf = (tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]):gsub("\\\\","\\")
				else
					tree.addleaf = tree2["TITLE" .. i]
				end --if tree2["TITLE" .. i]:match("^\\.*") then
					tree.value=tree.value+1
			elseif tree2["KIND" .. i]=="BRANCH" and tree2["MARKED" .. i]=="YES" then
				if tree2["TITLE" .. i]:match("^\\.*") then
					tree.addbranch = (tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]):gsub("\\\\","\\")
				else
					tree.addbranch = tree2["TITLE" .. i]
				end --if tree2["TITLE" .. i]:match("^\\.*") then
				tree.value=tree.value+1
			end --if tree2["KIND" .. i]=="LEAF" and tree2["MARKED" .. i] then
		else
			if i==numberOfNode then
				--test with: print(tree2["DEPTH" .. i],tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i])
				if tree2["TITLE" .. i]:match("^\\.*") then
					TreeText='{branchname="' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
				else
					TreeText='{branchname="' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
				end --if tree2["TITLE" .. i]:match("^\\.*") then
			elseif i>numberOfNode and tonumber(tree2["DEPTH" .. i])>tonumber(depthOfNode) and takeNode=="yes" and tonumber(tree2["DEPTH" .. i])>actualDepth then
				actualDepth=tonumber(tree2["DEPTH" .. i])
				if tree2["KIND" .. i ]=="LEAF" then
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				else
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				end --if tree2["KIND" .. i ]=="LEAF" then
			elseif i>numberOfNode and tonumber(tree2["DEPTH" .. i])>tonumber(depthOfNode) and takeNode=="yes" and tonumber(tree2["DEPTH" .. i])<actualDepth then
				local numberOfcurlybrakets=math.tointeger(actualDepth-tonumber(tree2["DEPTH" .. i]))
				actualDepth=tonumber(tree2["DEPTH" .. i])
				for i=1,numberOfcurlybrakets do
					TreeText=TreeText .. '},\n'
				end --for i=1,numberOfcurlybrakets do
				if tree2["KIND" .. i ]=="LEAF" then
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				else
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				end --if tree2["KIND" .. i ]=="LEAF" then
			elseif i>numberOfNode and tonumber(tree2["DEPTH" .. i])>tonumber(depthOfNode) and takeNode=="yes" then
				--test with: print(tree2["DEPTH" .. i],tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i])
				if tree2["KIND" .. i ]=="LEAF" then
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n"' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				else
					if tree2["TITLE" .. i]:match("^\\.*") then
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2.title0:match(".:\\.*") .. tree2["TITLE" .. i]) .. '",'
					else
						TreeText=TreeText .. '\n{branchname="' .. string.escape_forbidden_char(tree2["TITLE" .. i]) .. '",'
					end --if tree2["TITLE" .. i]:match("^\\.*") then
				end --if tree2["KIND" .. i ]=="LEAF" then
			elseif i>numberOfNode then
				takeNode="no"
			end --if i==numberOfNode then
		end --if tree2["KIND" .. numberOfNode ]=="LEAF" then
	end --for i=0, tree2.count-1 do
	endnumberOfcurlybrakets=math.max(math.tointeger(actualDepth-depthOfNode-1),0)
	for i=1,endnumberOfcurlybrakets do
	TreeText=TreeText .. '},'
	end --for i=1,endnumberOfcurlybrakets do
	TreeText=TreeText .. '}'
	TreeText=TreeText:gsub("\\\\\\\\","\\\\")
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
	elseif tree2["KIND" .. numberOfNode ]=="LEAF" then
		--do nothing because marked leafs sent
	else
		iup.Message("Der Knoten kann nicht gesendet werden.","Der Knoten kann nicht gesendet werden.")
	end --if numberCurlyBraketsBegin==numberCurlyBraketsEnd and _VERSION=='Lua 5.1' then
	--take the corresponding text
	if tonumber(tree2['title']) then 
		actualPage=math.tointeger(tonumber(tree2['title'])) 
		actualPage=tonumber(tree2['title'])
	else
		--test with: iup.Message("Text",tostring(TextHTMLtable[textbox1.value]))
		if TextHTMLtable[tree2['title']] then
			manualTreeNewsTable[tree2['title']]=TextHTMLtable[tree2['title']]
		else
			textbox1.value=tree2['title'] .. " hat keine Webpage"
		end --if TextHTMLtable[tree2['title']] then
	end --if tonumber(textbox1.value) then 
end --function startcopy_withchilds2:action() 


--5.2.3 put the menu items together in the menu for tree2
menu2 = iup.menu{
		startcopy,
		startcopy_withchilds2,
		}
--5.2 menu of tree2 end


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
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nidiv.kaiser@t-online.de")
end --function button_logo:flat_action()

--6.2 button for saving tree
button_save_lua_table=iup.flatbutton{title="Baum speichern \n(als Text Strg+P)", size="95x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	save_tree_to_lua(tree, path .. "\\documentation_tree_News.lua")
	outputfile1=io.open( path .. "\\documentation_tree_News.lua","a")
	--collect titles of tree to excluded texts without title
	local titleTable={}
	for i=0,tree.count-1 do
		titleTable[tree['title' .. i]]=true
	end --for i=0,tree.count-1 do
	outputfile1:write("\n\nmanualTreeNewsTable={}\n")
	for k,v in pairs(manualTreeNewsTable) do
		if titleTable[k] then
			outputfile1:write('manualTreeNewsTable["' .. string.escape_forbidden_char(k) .. '"]="' .. string.escape_forbidden_char(v) .. '"\n')
		end --if titleTable[k] then
	end --for k,v in pairs(manualTreeNewsTable) do
	outputfile1:close()
end --function button_save_lua_table:flat_action()


--6.3 button for search in tree and tree2
button_search=iup.flatbutton{title="Suchen\n(Strg+F)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
	searchtext.value=tree.title
	searchtext.SELECTION="ALL"
	dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_search:flat_action()

--6.4 button for converting PDF to text file with Word
button_convert_PDF_to_text_via_word=iup.flatbutton{title="Nachrichten vom Tag\nladen", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_convert_PDF_to_text_via_word:flat_action()
	--example 1: treat Welt news
	p=io.popen('dir "C:\\tree\\Tree_News\\PDF_News_inputs\\Welt_*.pdf" /b/o-N')
	local FileNewNewsPDF_Welt=p:read()
	local timeStamp_Welt=FileNewNewsPDF_Welt:lower():match("(%d%d%d%d%d%d%d%d).pdf")
	print("Verarbeitung der Nachrichten der Welt vom " .. timeStamp_Welt)
	word=luacom.CreateObject("Word.Application")
	word.Documents:Open("C:\\Tree\\Tree_News\\PDF_News_inputs\\Welt_" .. timeStamp_Welt .. ".PDF")
	word.ActiveDocument:SaveAs2("C:\\Tree\\Tree_News\\Text_News_outputs\\Welt_" .. timeStamp_Welt .. ".txt",2)
	word:Quit()
	--example 2: treat Domradio news
	p=io.popen('dir "C:\\tree\\Tree_News\\PDF_News_inputs\\Welt_*.pdf" /b/o-N')
	local FileNewNewsPDF_Domradio=p:read()
	local timeStamp_Domradio=FileNewNewsPDF_Domradio:lower():match("(%d%d%d%d%d%d%d%d).pdf")
	print("Verarbeitung der Nachrichten von Domradio vom " .. timeStamp_Domradio)
	word=luacom.CreateObject("Word.Application")
	word.Documents:Open("C:\\Tree\\Tree_News\\PDF_News_inputs\\Domradio_" .. timeStamp_Domradio .. ".PDF")
	word.ActiveDocument:SaveAs2("C:\\Tree\\Tree_News\\Text_News_outputs\\Domradio_" .. timeStamp_Domradio .. ".txt",2)
	word:Quit()
	--example 1: convert Welt news in Lua table 
	--Write news as Title and Text in a Lua table
	Title=""
	Text=""
	TitleTextTable={}
	for line in io.lines("C:\\Tree\\Tree_News\\Text_News_outputs\\Welt_" .. timeStamp_Welt .. ".txt") do
		if line:upper()==line then line="" end
		if line~="" and Title=="" then
			Title=line
		elseif line ~="" and Title~="" then
			if Text=="" then
				Text=line
			else
				Text=Text .. " " .. line
			end --if Text=="" then
		elseif line=="" and Text~="" and Text:match("%.") then
			TitleTextTable[Title]=Text
			Title=""
			Text=""
		elseif line=="" then
			Title=""
			Text=""
		end --if line~="" and Title=="" then
	end --for line in io.lines("C:\\Tree\\Tree_News\\Text_News_outputs\\Welt_" .. timeStamp_Welt .. ".txt") do
	--write the Title Text combinations in a file and a Title Lua table
	TitleTable={}
	outputfile1=io.open("C:\\Tree\\Tree_News\\Lua_News_outputs\\Welt_" .. timeStamp_Welt .. ".lua","w")
	outputfile1:write('TitleTextTable={\n')
	for k,v in pairs(TitleTextTable) do
	outputfile1:write('["' .. string.escape_forbidden_char(k) .. '"]="' .. string.escape_forbidden_char(v) .. '",\n')
	TitleTable[#TitleTable+1]=k
	end --for k,v in pairs(TitleTextTable) do
	outputfile1:write('} --TitleTextTable={\n\n\n')
	--sort the news title
	table.sort(TitleTable,function(a,b) local alower=a:gsub('"',""):lower() local blower=b:gsub('"',""):lower() return alower<blower end)
	--write result in file
	outputfile1:write('Tree={branchname="Nachrichten",\n')
	for k,v in pairs(TitleTable) do
	outputfile1:write('"' .. string.escape_forbidden_char(v) .. '",\n')
	end --for k,v in pairs(TitleTextTable) do
	outputfile1:write('} --Tree={branchname="Nachrichten",\n')
	outputfile1:close()
	--example 1: convert Welt news in Lua table end
	--
	--example 2: convert Domradio News in Lua table
	--Write news as Title and Text in a Lua table
	Title=""
	Text=""
	TitleTextTable={}
	i=0
	inputfile1=io.open("C:\\Tree\\Tree_News\\Text_News_outputs\\Domradio_" .. timeStamp_Domradio .. ".txt","r")
	inputText=inputfile1:read("*a"):gsub("?\r"," ")
				       :gsub("\r","\n")
				       :gsub(' +',' ')
				       :gsub(' "\n','\n')
				       :gsub(' %?','?')
				       :gsub('\t%?','')
				       :gsub('%?+','?')
				       :gsub('\n ','\n')                 
				       :gsub('%? *\n','\n')
	inputfile1:close()
	outputfile2=io.open("C:\\Tree\\Tree_News\\Domradio_aktuell.txt","w")
	outputfile2:write(inputText)
	outputfile2:close()
	for line in io.lines("C:\\Tree\\Tree_News\\Domradio_aktuell.txt") do
		line=line:gsub('(%(c%)[^%(]*%([^%)]*%))(.*)','%2 %1')
			 :gsub('^ ','')
		if  line:upper()==line      then line=""
		elseif line:match(" ")==nil then line=""
		elseif line:match("\t")     then line=""
		end
		if     line~="" and Title=="" then
			Title=line
		elseif line~="" and Title:match("^%(c%)[^%(]*%([^%)]*%)$") then
			Title=line .. " " .. Title
		elseif line ~="" and Title~="" then
			if Text=="" then
				Text=line
			else
				Text=Text .. " " .. line
			end --if Text=="" then
		elseif line=="" and Text~="" and Text:match("%.") 
				and (Title:match("^%d") or Title:match("^\"%u") or Title:match("^%u")) 
				and #Text>#Title then
			TitleTextTable[Title]=Text
			Title=""
			Text=""
		elseif line=="" then
			Title=""
			Text=""
		end --if line~="" and Title=="" then
	end --for line in io.lines("C:\\Tree\\Tree_News\\Text_News_outputs\\Domradio_" .. timeStamp_Domradio .. ".txt") do
	--write the Title Text combinations in a file and a Title Lua table
	TitleTable={}
	outputfile1=io.open("C:\\Tree\\Tree_News\\Lua_News_outputs\\Domradio_" .. timeStamp_Domradio .. ".lua","w")
	outputfile1:write('TitleTextTable={\n')
	for k,v in pairs(TitleTextTable) do
		outputfile1:write('["' .. string.escape_forbidden_char(k) .. '"]="' .. string.escape_forbidden_char(v) .. '",\n')
		TitleTable[#TitleTable+1]=k
	end --for k,v in pairs(TitleTextTable) do
	outputfile1:write('} --TitleTextTable={\n\n\n')
	--sort the news title
	table.sort(TitleTable,function(a,b) local alower=a:gsub('"',""):lower() local blower=b:gsub('"',""):lower() return alower<blower end)
	outputfile1:write('Tree={branchname="Nachrichten",\n')
	for k,v in pairs(TitleTable) do
		outputfile1:write('"' .. string.escape_forbidden_char(v) .. '",\n')
	end --for k,v in pairs(TitleTextTable) do
	outputfile1:write('} --Tree={branchname="Nachrichten",\n')
	outputfile1:close()
	--example 2: convert Domradio News in Lua table end
	os.execute('start "Neu" "' .. path .. "\\" .. thisfilename .. '"')
	return iup.CLOSE
end --function button_convert_PDF_to_text_via_word:flat_action()

--6.5 button for expand and collapse
button_expand_collapse_dialog=iup.flatbutton{title="Ein-/Ausklappen\n(Strg+R)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_expand_collapse_dialog:flat_action()
	text_expand_collapse.value=tree2.title
	dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_expand_collapse_dialog:flat_action()

--6.6 button for going to webbrowser page
button_goto_page=iup.flatbutton{title="Gehe zu Seite\nvom Knoten", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_goto_page:flat_action()
	if tonumber(tree2['title']) then 
		actualPage=math.tointeger(tonumber(tree2['title'])) 
		webbrowser1.HTML=TextHTMLtable[actualPage]
		textbox1.value=tree2['title']
		actualPage=tonumber(tree2['title'])
	else
		--test with: iup.Message("Text",tostring(TextHTMLtable[textbox1.value]))
		if TextHTMLtable[tree2['title']] then
			webbrowser1.HTML=TextHTMLtable[tree2['title']]
			textbox1.value=tree2['title']
		else
			textbox1.value=tree2['title'] .. " hat keine Webpage"
		end --if TextHTMLtable[tree2['title']] then
	end --if tonumber(textbox1.value) then 
end --function button_goto_page:flat_action()


--6.7 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nidiv.kaiser@t-online.de")
end --function button_logo:flat_action()

--6 buttons end


--7 Main Dialog

--7.1 textboxes
textbox1=iup.text{value="1",size="340x20",alignment="ACENTER"}

--7.2 webbrowser
webbrowser1=iup.webbrowser{HTML="Nachrichten aus Welt und Domradio",MAXSIZE="930x230"}
webbrowser2=iup.webbrowser{HTML="gespeicherte Texte zum manuellen Baum",MAXSIZE="930x230"}
actualPage=1

--7.3.1 load tree from file
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
	actualtree={branchname="Die Datei " .. path_documentation_tree .. " existiert nicht",}
end --if file_exists(path_documentation_tree) then
--test with: for k,v in pairs(manualTreeNewsTable) do print(k) end
tree=iup.tree{
	map_cb=function(self)
	self:AddNodes(actualtree)
	end, --function(self)
	SIZE="400x150",
	showrename="YES",--F2 key active
	markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
	showdragdrop="YES",
	}
--set the background color of the tree
tree.BGCOLOR=color_background_tree
-- Callback of the right mouse button click
function tree:rightclick_cb(id)
	tree.value = id
	menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function tree:rightclick_cb(id)
-- Callback called when a node will be doubleclicked
function tree:executeleaf_cb(id)
	if tree['title' .. id]:match("^.:\\.*%.[^\\ ]+$") or tree['title' .. id]:match("^.:\\.*[^\\]+$") or tree['title' .. id]:match("^.:\\$") or tree['title' .. id]:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "d" "' .. tree['title' .. id] .. '"') 
	elseif tonumber(tree['title']) then 
		actualPage=math.tointeger(tonumber(tree['title'])) 
		webbrowser2.HTML=manualTreeNewsTable[actualPage]
		textbox1.value=tree['title']
		actualPage=tonumber(tree['title'])
	else
		--test with: iup.Message("Text",tostring(manualTreeNewsTable[textbox1.value]))
		if manualTreeNewsTable[tree['title']] then
			webbrowser2.HTML=manualTreeNewsTable[tree['title']]
			textbox1.value=tree['title']
		else
			textbox1.value=tree['title'] .. " hat keine Webpage"
		end --if manualTreeNewsTable[tree2['title']] then
	end --if tree['title' .. id]:match("^.:\\.*%.[^\\ ]+$") or tree['title' .. id]:match("^.:\\.*[^\\]+$") or tree['title' .. id]:match("^.:\\$") or tree['title' .. id]:match("^[^ ]*//[^ ]+$") then
end --function tree:executeleaf_cb(id)
-- Callback for pressed keys
function tree:k_any(c)
	if c == iup.K_DEL then
		-- do a totalchildcount of marked node. Then pop the table entries, which correspond to them.
		for j=0,tree.totalchildcount do
			--table.remove(attributes, tree.value+1)
		end --for j=0,tree.totalchildcount do
		tree.delnode = "MARKED"
	elseif c == iup.K_cC then
		--copy node of tree
		clipboard.text = tree['title']
	elseif c == iup.K_cP then -- added output of current table to a text file and dependencies to a csv file
		printtree()
		printdependencies()
	elseif c == iup.K_cT then -- compare text files of tree and tree2
		compareText=""
		if tree.TITLE:match(".:\\.*%.[^\\]+") and (tree2.title0:match(".:\\.*") .. tree2.TITLE):match(".:\\.*%.[^\\]+") then
			compare_files(tree.TITLE , tree2.title0:match(".:\\.*") .. tree2.TITLE)
			textfield1.value=compareText
		else
			textfield1.value="Kein Vergleich von " .. tree.TITLE .. " \nmit " .. tree2.title0:match(".:\\.*") .. tree2.TITLE
		end --if tree.TITLE:match(".:\\.*%.[^\\]+") and (tree2.title0:match(".:\\.*") .. tree2.TITLE):match(".:\\.*%.[^\\]+") then
	elseif c == iup.K_cF then
			searchtext.value=tree.title
			searchtext.SELECTION="ALL"
			dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_cH then
			searchtext_replace.value=tree.title
			replacetext_replace.SELECTION="ALL"
			dlg_search_replace:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_cD then
			printdependencies()
	elseif c == iup.K_Menu then
		menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function tree:k_any(c)

--7.3.2 load tree2 from file
actualtree2=NewsTree
--build tree2
tree2=iup.tree{
	map_cb=function(self)
	self:AddNodes(actualtree2)
	end, --function(self)
	SIZE="400x200",
	showrename="YES",--F2 key active
	markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
	showdragdrop="YES",
	}
--set colors of tree2
tree2.BGCOLOR=color_background_tree --set the background color of the tree2
-- Callback of the right mouse button click
function tree2:rightclick_cb(id)
	tree2.value = id
	menu2:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
end --function tree2:rightclick_cb(id)
-- Callback called when a node will be doubleclicked
function tree2:executeleaf_cb(id)
	if tree2['title' .. id]:match("^.:\\.*%.[^\\ ]+$") or tree2['title' .. id]:match("^.:\\.*[^\\]+$") or tree2['title' .. id]:match("^.:\\$") or tree2['title' .. id]:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "d" "' .. tree2['title' .. id] .. '"') 
	elseif tonumber(tree2['title']) then 
		actualPage=math.tointeger(tonumber(tree2['title'])) 
		webbrowser1.HTML=TextHTMLtable[actualPage]
		textbox1.value=tree2['title']
		actualPage=tonumber(tree2['title'])
	else
		--test with: iup.Message("Text",tostring(TextHTMLtable[textbox1.value]))
		if TextHTMLtable[tree2['title']] then
			webbrowser1.HTML=TextHTMLtable[tree2['title']]
			textbox1.value=tree2['title']
		else
			textbox1.value=tree2['title'] .. " hat keine Webpage"
		end --if TextHTMLtable[tree2['title']] then
	end --if tree2['title' .. id]:match("^.:\\.*%.[^\\ ]+$") or tree2['title' .. id]:match("^.:\\.*[^\\]+$") or tree2['title' .. id]:match("^.:\\$") or tree2['title' .. id]:match("^[^ ]*//[^ ]+$") then 
end --function tree2:executeleaf_cb(id)
-- Callback for pressed keys
function tree2:k_any(c)
	if c == iup.K_DEL then
		-- do a totalchildcount of marked node. Then pop the table entries, which correspond to them.
		for j=0,tree2.totalchildcount do
			--table.remove(attributes, tree2.value+1)
		end --for j=0,tree2.totalchildcount do
		tree2.delnode = "MARKED"
	elseif c == iup.K_cP then -- added output of current table to a text file
		printtree()
	elseif c == iup.K_cR then -- expand collapse dialog
		text_expand_collapse.value=tree2.title
		dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_cF then
			searchtext.value=tree2.title
			searchtext.SELECTION="ALL"
			dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_Menu then
		menu2:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function tree2:k_any(c)

--7.4 building the dialog and put buttons, trees and other elements together
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
			button_goto_page,
			textbox1,
			iup.label{size="30x",},
			iup.fill{},
			button_convert_PDF_to_text_via_word,
			button_logo2,
		},
		
		iup.hbox{
			iup.frame{title="Manuelle Zuordnung als Baum",iup.vbox{tree,webbrowser2,}},
			iup.frame{title="Webbrowser Inhalte",iup.vbox{webbrowser1,tree2,}},
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

