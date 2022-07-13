lua_tree_output={ branchname="example of a reflexive tree", 
{ branchname="Node 1", 
{ branchname="Neuer Ast", 
{ branchname="1", 
state="COLLAPSED",
},
{ branchname="string.escape_forbidden_char", 
 "Daten aus CSV-Datei 2",},
},
{ branchname="Node 2", 
{ branchname="save_html_to_lua", 
state="COLLAPSED",
},
{ branchname="Test", 
state="COLLAPSED",
},
{ branchname="TextHTMLtable", 
state="COLLAPSED",
},
{ branchname="Test", 
 "Neuer Ast", "2", 
 "3", 
},
 "Leaf",}}}--lua_tree_output



DataTable={
["Daten aus CSV-Datei 2"]={"C:\\Temp\\testDaten.csv","","Nr_","","Br_","2","T_","3","4","5",},
["Daten aus CSV-Datei 1"]={"C:\\Temp\\testDaten.csv","Nr_","1","Br_","2","T_","3","4","5",},
["string.escape_forbidden_char"]={"C:\\Temp\\test.txt","Soso","2",},
}--DataTable<!--



----[====[This programm has a dataform within the Lua script which can contain data corresponding to the tree

--1. basic data

--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs
--iup.SetGlobal("UTF8MODE","NO")

--1.1.2 initalize clipboard
clipboard=iup.clipboard{}

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


--2. path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)

--3. functions

--3.1 general Lua functions

if math.tointeger==nil then function math.tointeger(a) return a end end

--3.1.1 simplified version of table.move for Lua 5.1 and Lua 5.2 that is enough for using of table.move here
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

--3.3 function which saves the current iup htmlTexts as a Lua table
function save_dataform_to_lua(htmlTexts, outputfile_path)
	--read the programm of the file itself, commentSymbol is used to have another pattern here as searched
	inputfile=io.open(path .. "\\" .. thisfilename,"r")
	commentSymbol,inputTextProgramm=inputfile:read("*a"):match("lua_tree_output={.*}%-%-lua_tree_output.*DataTable={.*}(%-%-)DataTable<!%-%-(.*)")
	inputfile:close()
	--build the new htmlTexts
	local output_dataformTexts_text="DataTable={" --the output string
	local outputfile=io.output(outputfile_path) --a output file
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
	outputfile:write(output_tree_text .. "--lua_tree_output\n\n\n\n") --write everything into the outputfile
	--save the dataforms
	for k,v in pairs(DataTable) do 
		if type(k)=="number" then
		output_dataformTexts_text=output_dataformTexts_text .. "\n[====[" .. v .. "]====],"
		elseif type(v)=="table" then
			output_dataformTexts_text=output_dataformTexts_text .. '\n["' .. string.escape_forbidden_char(k) .. '"]={'
			for i1,v1 in pairs(v) do
				output_dataformTexts_text=output_dataformTexts_text .. '"' .. string.escape_forbidden_char(v1) .. '",'
			end --for k1,v1 in pairs(v) do
			output_dataformTexts_text=output_dataformTexts_text .. "},"
		else
		output_dataformTexts_text=output_dataformTexts_text .. '\n["' .. string.escape_forbidden_char(k) .. '"]=[====[' .. v .. "]====],"
		end --if type(k)=="number" then
	end --for k,v in pairs(DataTable) do 

	output_dataformTexts_text=output_dataformTexts_text .. "\n}"
	outputfile:write(output_dataformTexts_text .. "--DataTable<!--") --write everything into the outputfile
	--write the programm for the data in itself
	outputfile:write(inputTextProgramm)
	outputfile:close()
end --function save_dataform_to_lua(htmlTexts, outputfile_path)



--3.4 function to change expand/collapse relying on depth
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


--3.5 function to change expand/collapse relying on keyword
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


--4.3 search dialog
searchtext = iup.multiline{border="YES",expand="YES", SELECTION="ALL",wordwrap="YES"} --textfield for search
searchtext2 = iup.multiline{border="YES",expand="YES",wordwrap="YES"} --textfield for search
search_found_number = iup.text{border="YES",expand="YES",} --textfield for search found number

--search in downward direction
searchdown    = iup.flatbutton{title = "Abwärts",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function searchdown:flat_action()
	--for search for substantives in german questions
	searchtext2.value=""
	local wordTable={}
	local searchtextValue
	if searchtext.value:match("[%uÄÖÜ][^%s%p]+.*%?") then --take words except space characters %s and punctuation characters %p
		searchtextValue=searchtext.value:match("[%uÄÖÜ][^%s%p]+ (.*)%?"):gsub("%? [%uÄÖÜ]+"," "):gsub("%. [%uÄÖÜ]+"," "):gsub(": [%uÄÖÜ]+"," ")
	else
		searchtextValue=searchtext.value
	end --if searchtext.value:match("[%uÄÖÜ][^%s%p]+.*%?") then
	for word in searchtextValue:gmatch("[%uÄÖÜ][^%s%p]+") do 
		wordTable[#wordTable+1]=word 
		searchtext2.value=searchtext2.value .. "/" .. word
	end --for word in searchtextValue:gmatch("[%uÄÖÜ][^%s%p]+") do 
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
			local searchFound=0
			for k,v in pairs(wordTable) do	
				--test with: print(k,v)
				if tree["title" .. i]:upper():match(v:upper())~= nil then
					searchFound=searchFound+1
				end --if tree["title" .. i]:upper():match(v:upper())~= nil then
			end --for k,v in pairs(wordTable) do	
			if #wordTable>0 and searchFound==#wordTable then
				tree.value= i
				help=true
				break
			end --if searchFound==#wordTable then
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
	local numberFoundWord=0
	--for search for substantives in german questions
	searchtext2.value=""
	local wordTable={}
	local searchtextValue
	if searchtext.value:match("[%uÄÖÜ][^%s%p]+.*%?") then --take words except space characters %s and punctuation characters %p
		searchtextValue=searchtext.value:match("[%uÄÖÜ][^%s%p]+ (.*)%?"):gsub("%? [%uÄÖÜ]+"," "):gsub("%. [%uÄÖÜ]+"," "):gsub(": [%uÄÖÜ]+"," ")
	else
		searchtextValue=searchtext.value
	end --if searchtext.value:match("[%uÄÖÜ][^%s%p]+.*%?") then
	for word in searchtextValue:gmatch("[%uÄÖÜ][^%s%p]+") do 
		wordTable[#wordTable+1]=word 
		searchtext2.value=searchtext2.value .. "/" .. word
	end --for word in searchtextValue:gmatch("[%uÄÖÜ][^%s%p]+") do 
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
		local searchFound=0
		for k,v in pairs(wordTable) do	
			--test with: print(k,v)
			if tree["title" .. i]:upper():match(v:upper())~= nil then
				searchFound=searchFound+1
			end --if tree["title" .. i]:upper():match(v:upper())~= nil then
		end --for k,v in pairs(wordTable) do	
		if #wordTable>0 and searchFound==#wordTable then
				numberFoundWord=numberFoundWord+1
				iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
				iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
				iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
		end --if searchFound==#wordTable then
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
				numberFound=numberFound+1
				iup.TreeSetAncestorsAttributes(tree,i,{color="255 0 0",})
				iup.TreeSetNodeAttributes(tree,i,{color="0 0 250",})
				iup.TreeSetDescendantsAttributes(tree,i,{color="90 195 0"})
			end --if DateiFundstelle~="" then
		end --if checkboxforsearchinfiles.value=="ON"  and file_exists(tree["title" .. i])
		--search in text files if checkbox on end
	end --for i=0, tree.count - 1 do
	search_found_number.value="Anzahl Fundstellen: " .. tostring(numberFound) .. " direkt bzw. " .. tostring(numberFoundWord) .. " indirekt " .. tostring(searchtext.value) .. " gefunden."
end --function searchmark:flat_action()

--unmark without leaving the search-window
unmark    = iup.flatbutton{title = "Entmarkieren",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function unmark:flat_action()
	--unmark all nodes
	for i=0, tree.count - 1 do
		tree["color" .. i]="0 0 0"
	end --for i=0, tree.count - 1 do
	--unmark all nodes end
	search_found_number.value=""
end --function unmark:flat_action()

--search in upward direction
searchup   = iup.flatbutton{title = "Aufwärts",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
function searchup:flat_action()
	--for search for substantives in german questions
	searchtext2.value=""
	local wordTable={}
	local searchtextValue
	if searchtext.value:match("[%uÄÖÜ][^%s%p]+.*%?") then --take words except space characters %s and punctuation characters %p
		searchtextValue=searchtext.value:match("[%uÄÖÜ][^%s%p]+ (.*)%?"):gsub("%? [%uÄÖÜ]+"," "):gsub("%. [%uÄÖÜ]+"," "):gsub(": [%uÄÖÜ]+"," ")
	else
		searchtextValue=searchtext.value
	end --if searchtext.value:match("[%uÄÖÜ][^%s%p]+.*%?") then
	for word in searchtextValue:gmatch("[%uÄÖÜ][^%s%p]+") do 
		wordTable[#wordTable+1]=word 
		searchtext2.value=searchtext2.value .. "/" .. word
	end --for word in searchtextValue:gmatch("[%uÄÖÜ][^%s%p]+") do 
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
			local searchFound=0
			for k,v in pairs(wordTable) do	
				--test with: print(k,v)
				if tree["title" .. i]:upper():match(v:upper())~= nil then
					searchFound=searchFound+1
				end --if tree["title" .. i]:upper():match(v:upper())~= nil then
			end --for k,v in pairs(wordTable) do	
			if #wordTable>0 and searchFound==#wordTable then
				tree.value= i
				help=true
				break
			end --if searchFound==#wordTable then
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
			iup.vbox{iup.hbox{search_label,iup.vbox{searchtext,iup.label{title="Suchworte aus Fragen und Texten:"},searchtext2,}}, 

			iup.label{title="Sonderzeichen: %. für ., %- für -, %+ für +, %% für %, %[ für [, %] für ], %( für (, %) für ), %^ für ^, %$ für $, %? für ?",},
			iup.hbox{searchmark,unmark,checkboxforsearchinfiles,}, 
			iup.label{title="rot: übergeordnete Knoten",fgcolor = "255 0 0", },
			iup.label{title="blau: gleicher Knoten",fgcolor = "0 0 255", },
			iup.label{title="grün: untergeordnete Knoten",fgcolor = "90 195 0", },
			iup.hbox{searchdown, searchup,checkboxforcasesensitive,},
			iup.hbox{search_found_number,},
			}; 
		title="Suchen",
		size="420x140",
		startfocus=searchtext
		}

--4.3 search dialog end


--4.4 expand and collapse dialog

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

--4.4 expand and collapse dialog end


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

--5.1.8 menu for going to dataform page
menu_goto_dataform=iup.item {title="Daten des Knotens laden", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function menu_goto_dataform:action()
	i=tree.value
	textbox1.value=DataTable[tree['title' .. i]][1]
	textbox2.value=DataTable[tree['title' .. i]][2]
	textbox3.value=DataTable[tree['title' .. i]][3]
	textbox4.value=DataTable[tree['title' .. i]][4]
	textbox5.value=DataTable[tree['title' .. i]][5]
	textbox6.value=DataTable[tree['title' .. i]][6]
	textbox7.value=DataTable[tree['title' .. i]][7]
	textbox8.value=DataTable[tree['title' .. i]][8]
	textbox9.value=DataTable[tree['title' .. i]][9]
	textbox10.value=DataTable[tree['title' .. i]][10]
end --function menu_goto_dataform:flat_action()

--5.1.9 start the file or repository of the node of tree
startnode = iup.item {title = "Starten"}
function startnode:action() 
	--test with: print(tree['title'])
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then os.execute('start "D" "' .. tree['title'] .. '"') end
end --function startnode:action()

--5.1.10 delete tree data from data base
startnode_delete_database_trees = iup.item {title = "Tree-Daten aus der Datenbank löschen"}
function startnode_delete_database_trees:action() 
	os.execute('c:\\sqlite3\\sqlite3.exe c:\\Temp\\test.sqlite "DELETE FROM treeTable;"')
	iup.Message("Die Tree-Daten","wurden aus der Datenbank gelöscht")
end --function startnode_delete_database_trees:action()

--5.1.11 start import into the data base
start_import = iup.item {title = "Starten des Datenimports"}
function start_import:action() 
	i=tree.value
	if DataTable[tree['title' .. i]] 
		and textbox1.value~="" 
		--can be empty: and textbox2.value~="" 
		--can be empty: and textbox3.value~="" 
		and textbox4.value~="" 
		--can be empty: and textbox5.value~="" 
		and textbox6.value~="" 
		--can be empty: and textbox7.value~="" 
		and textbox8.value~="" 
		and textbox9.value~="" 
		and textbox10.value~="" 
		then
		Level_0_Table={}
		Level_0_1_Table={}
		LevelExists_0_1_Table={}
		outputfile1=io.open("C:\\Temp\\testDaten.txt","w")
		i=0
		for line in io.lines(textbox1.value) do --"C:\\Temp\\testDaten.csv") do
			i=i+1
			if i>1 then
				local fieldTable={}
				for field in (line .. ";"):gmatch("([^;]*);") do
					fieldTable[#fieldTable+1]=field
				end --for field in (line .. ";"):gmatch("([^;]*);") do
				local Level_0_Text=textbox3.value .. fieldTable[math.tointeger(tonumber(textbox4.value))] --"Nr" .. fieldTable[6]
				local Level_1_Text=textbox5.value .. fieldTable[math.tointeger(tonumber(textbox6.value))] --"Br" .. fieldTable[3]
				--test with: print(Level_1_Text)
				local DataKeyText=textbox7.value .. fieldTable[math.tointeger(tonumber(textbox8.value))] --"T" .. fieldTable[1]
				local DataValueText=fieldTable[math.tointeger(tonumber(textbox9.value))]:gsub(",",".") --fieldTable[4]:gsub(",",".")
				local DataValue_compareText=fieldTable[math.tointeger(tonumber(textbox10.value))]:gsub(",",".") --fieldTable[7]:gsub(",",".")
				outputfile1:write(DataKeyText .. ";" .. DataValueText .. ";" .. DataValue_compareText .. "\n")
				--build the levels
				if Level_0_Table[Level_0_Text] and not LevelExists_0_1_Table[Level_0_Text .. "|" .. Level_1_Text] then
				Level_0_Table[Level_0_Text] = Level_0_Table[Level_0_Text] .. Level_0_Text .. "|" .. Level_1_Text .. ","
				LevelExists_0_1_Table[Level_0_Text .. "|" .. Level_1_Text]="Vorhanden"
				elseif Level_0_Table[Level_0_Text] then
				else
				Level_0_Table[Level_0_Text]=Level_0_Text .. "|" .. Level_1_Text .. ","
				LevelExists_0_1_Table[Level_0_Text .. "|" .. Level_1_Text]="Vorhanden"
				end --if Not Level_0_Table(Level_0_Text) Then
				if Level_0_1_Table[Level_0_Text .. "|" .. Level_1_Text] then
				Level_0_1_Table[Level_0_Text .. "|" .. Level_1_Text] = Level_0_1_Table[Level_0_Text .. "|" .. Level_1_Text] .. '{branchname="' .. DataKeyText .. '"},'
				else
				Level_0_1_Table[Level_0_Text .. "|" .. Level_1_Text]='{branchname="' .. DataKeyText .. '"},'
				end --if Not Level_0_Table(Level_0_Text) Then
			end --if i>1 then
			--test with: if i>3 then break end
		end --for line in io.lines("C:\\Temp\\testDaten.csv") do
		outputfile1:close()

		--Schnelles Importieren:
		outputfile2=io.open("c:\\temp\\testDatenSQLite_Import.txt","w+")
outputfile2:write([[
DELETE FROM DataForTrees;
.mode csv
.separator ";"
.import c:/temp/testDaten.txt DataForTrees
]])
		outputfile2:close()
		--In die SQLite-Datenbank Importieren
		os.execute('c:\\sqlite3\\sqlite3.exe c:\\Temp\\test.sqlite ".read c:/temp/testDatenSQLite_Import.txt"')


		outputfile3=io.open("C:\\Temp\\Testdaten_Trees.txt","w")

		PrintText = ""

		treeMax=0
		p=io.popen('C:\\sqlite3\\sqlite3.exe c:\\Temp\\test.sqlite "select Max(Tree_ID) AS Tree_Max from treeTable"')
		for line in p:lines() do treeMax=line end
		print(treeMax)
		Tree_ID=math.tointeger(tonumber(treeMax)) or 0
		for k,v in pairs(Level_0_Table) do
			Tree_ID=Tree_ID+1
			PrintText = Tree_ID .. ';Tree={branchname="' .. k .. '",'

			for arrayField in (Level_0_Table[k] ):gmatch("([^,]*),") do
				--test with: print(Level_0_Table[k])
				--test with: print(arrayField)
				arrayDouble = arrayField:match("[^|]*|([^|]*)")
				--print(arrayDouble)
				if arrayField ~= "" then
				PrintText = PrintText .. '{branchname="' .. arrayDouble .. '",' --only second part after | to take
				--test with: print(PrintText)
				PrintText = PrintText .. "" .. Level_0_1_Table[arrayField] .. "},"
				end --if not arrayField == "" then
				
			end --for arrayField in (Level_0_Table[Key] .. ","):gmatch("([^,]*),") do
			outputfile3:write(PrintText .. "};\n")


		end --for k,v in pairs(Level_0_Table) do
		outputfile3:close()

		--Schnelles Importieren:
outputfile4=io.open("c:\\temp\\testDatenSQLite_Import_Tree.txt","w+")
outputfile4:write([[
.mode csv
.separator ";"
.import c:/temp/Testdaten_Trees.txt treeTable
]])
outputfile4:close()
		--In die SQLite-Datenbank Importieren
		os.execute('c:\\sqlite3\\sqlite3.exe c:\\Temp\\test.sqlite ".read c:/temp/testDatenSQLite_Import_Tree.txt"')

		iup.Message("Die Daten wurden mit den folgenden Werten importiert",
				textbox1.value .. "/" ..
				textbox2.value .. "/" ..
				textbox3.value .. "/" ..
				textbox4.value .. "/" ..
				textbox5.value .. "/" ..
				textbox6.value .. "/" ..
				textbox7.value .. "/" ..
				textbox8.value .. "/" ..
				textbox9.value .. "/" ..
				textbox10.value )
	elseif DataTable[tree['title' .. i]] 
		and textbox1.value~="" 
		and textbox2.value=="" 
		and textbox3.value=="" 
		and textbox4.value=="" 
		and textbox5.value=="" 
		and textbox6.value=="" 
		and textbox7.value=="" 
		and textbox8.value=="" 
		and textbox9.value=="" 
		and textbox10.value=="" 
		then
outputfile4=io.open("c:\\temp\\testDatenSQLite_Import_Tree.txt","w+")
outputfile4:write([[
.mode csv
.separator ";"
.import ]] .. textbox1.value:gsub("\\","/") .. [[ treeTable
]])
outputfile4:close()
		--In die SQLite-Datenbank Importieren
		os.execute('c:\\sqlite3\\sqlite3.exe c:\\Temp\\test.sqlite ".read c:/temp/testDatenSQLite_Import_Tree.txt"')
		iup.Message("Die Daten wurden mit den folgenden Werten importiert",
				textbox1.value .. "/" ..
				textbox2.value .. "/" ..
				textbox3.value .. "/" ..
				textbox4.value .. "/" ..
				textbox5.value .. "/" ..
				textbox6.value .. "/" ..
				textbox7.value .. "/" ..
				textbox8.value .. "/" ..
				textbox9.value .. "/" ..
				textbox10.value )
	end --if DataTable[tree['title' .. i]] then
end --function start_import:action()

--5.1.12 start export from the data base
start_export = iup.item {title = "Starten des Datenexports"}
function start_export:action() 
	i=tree.value
	if DataTable[tree['title' .. i]] 
		and textbox1.value~="" 
		and textbox2.value=="" 
		and textbox3.value=="" 
		and textbox4.value=="" 
		and textbox5.value=="" 
		and textbox6.value=="" 
		and textbox7.value=="" 
		and textbox8.value=="" 
		and textbox9.value=="" 
		and textbox10.value=="" 
		then
outputfile4=io.open("c:\\temp\\testDatenSQLite_Export_Tree.txt","w+")
outputfile4:write([[
.headers off
.mode csv
.separator ";"
.output ]] .. textbox1.value:gsub("\\","/"):gsub("(.*)%.([^%.]+)$","%1_roh.%2") .. [[

SELECT Tree_ID, Tree from TreeTable;
.quit
]])
outputfile4:close()
		--In die SQLite-Datenbank Importieren
		os.execute('c:\\sqlite3\\sqlite3.exe c:\\Temp\\test.sqlite ".read c:/temp/testDatenSQLite_Export_Tree.txt"')
		iup.Message("Die Daten wurden mit den folgenden Werten exportiert",
				textbox1.value .. "/" ..
				textbox2.value .. "/" ..
				textbox3.value .. "/" ..
				textbox4.value .. "/" ..
				textbox5.value .. "/" ..
				textbox6.value .. "/" ..
				textbox7.value .. "/" ..
				textbox8.value .. "/" ..
				textbox9.value .. "/" ..
				textbox10.value )
	end --if DataTable[tree['title' .. i]] then
	outputfile5=io.open(textbox1.value,"w")
	local inputfile_Text=textbox1.value:gsub("(.*)%.([^%.]+)$","%1_roh.%2")
	for line in io.lines(inputfile_Text) do
		outputfile5:write(line:gsub('""','~~'):gsub('"',''):gsub('~~','"') .. "\n")
	end --for line in io.lines(inputfile_Text) do
	outputfile5:close()
end --function start_export:action()

--5.1.13 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,
		renamenode, 
		addbranch, 
		addbranch_fromclipboard, 
		addbranchbottom, 
		addbranch_fromclipboardbottom, 
		addleaf,
		addleaf_fromclipboard,
		startversion,
		menu_new_data_in_dataform, 
		iup.separator{},
		startnode_delete_database_trees, 
		iup.separator{},
		menu_goto_dataform, 
		start_import, 
		start_export, 
		iup.separator{},
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

--6.2 button for saving DataTable and the programm of the graphical user interface
button_save_lua_table=iup.flatbutton{title="Datei \nspeichern", size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	save_dataform_to_lua(DataTable, path .. "\\" .. thisfilename)
end --function button_save_lua_table:flat_action()

--6.3.1 button for search in tree
button_search=iup.flatbutton{title="Suchen\n(Strg+F)", size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
	searchtext.value=tree.title
	searchtext.SELECTION="ALL"
	dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_search:flat_action()

--6.3.2 button for expand and collapse
button_expand_collapse_dialog=iup.flatbutton{title="Ein-/Ausklappen\n(Strg+R)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_expand_collapse_dialog:flat_action()
	text_expand_collapse.value=tree.title
	dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_expand_collapse_dialog:flat_action()

--6.4 button for expand and collapse
button_save_dataform=iup.flatbutton{title="Datenformular \nspeichern", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_dataform:flat_action()
	i=tree.value
	if DataTable[tree['title' .. i]]==nil then DataTable[tree['title' .. i]]={} end
	DataTable[tree['title' .. i]][1]=textbox1.value
	DataTable[tree['title' .. i]][2]=textbox2.value
	DataTable[tree['title' .. i]][3]=textbox3.value
	DataTable[tree['title' .. i]][4]=textbox4.value
	DataTable[tree['title' .. i]][5]=textbox5.value
	DataTable[tree['title' .. i]][6]=textbox6.value
	DataTable[tree['title' .. i]][7]=textbox7.value
	DataTable[tree['title' .. i]][8]=textbox8.value
	DataTable[tree['title' .. i]][9]=textbox9.value
	DataTable[tree['title' .. i]][10]=textbox10.value
end --function button_save_dataform:flat_action()

--6.5 button for opening the trees of the data base
button_open_tree_from_database=iup.flatbutton{title="Baumansichten zur \nDatenbank öffnen", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_open_tree_from_database:flat_action()
	os.execute('start "GUI" "C:\\Tree\\simpleDocTree\\simple_documentation_tree_sqlite_with_import_data.lua"')
end --function button_open_tree_from_database:flat_action()

--6.6 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de")
end --function button_logo:flat_action()

--7 Main Dialog

--7.1 textboxes
textbox1 = iup.text{value="",size="120x20"}
textbox2 = iup.text{value="",size="120x20"}
textbox3 = iup.text{value="",size="120x20"}
textbox4 = iup.text{value="",size="120x20"}
textbox5 = iup.text{value="",size="120x20"}
textbox6 = iup.text{value="",size="120x20"}
textbox7 = iup.text{value="",size="120x20"}
textbox8 = iup.text{value="",size="120x20"}
textbox9 = iup.text{value="",size="120x20"}
textbox10 = iup.text{value="",size="120x20"}


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
	elseif c == iup.K_cR then
		button_expand_collapse_dialog:flat_action()
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
			button_search,
			button_expand_collapse_dialog,
			iup.fill{},
			button_open_tree_from_database,
			iup.label{size="10x",},
			button_save_dataform,
			button_logo2,
		}, --iup.hbox{
		iup.hbox{iup.frame{title="Manuelle Zuordnung als Baum",tree,},
			iup.frame{title="Datenformular zum ausgewählten Knoten im Baum",iup.vbox{
				iup.label{title="Datei",},
				textbox1,
				iup.label{title="Tabelle bei Excel",},
				textbox2,
				iup.label{title="Präfix oberste Ebene",},
				textbox3,
				iup.label{title="Spalte oberste Ebene",},
				textbox4,
				iup.label{title="Präfix mittlere Ebene",},
				textbox5,
				iup.label{title="Spalte mittlere Ebene",},
				textbox6,
				iup.label{title="Präfix Detailebene",},
				textbox7,
				iup.label{title="Spalte Detailebene",},
				textbox8,
				iup.label{title="Spalte Wert",},
				textbox9,
				iup.label{title="Spalte Wertvergleich",},
				textbox10,
				},
				size="400x"},
			},
	}, --iup.vbox{
	icon = img_logo,
	title = path .. " Documentation Tree",
	size="FULLxFULL" ;
	gap="3",
	alignment="ARIGHT",
	margin="5x5" 
}--maindlg = iup.dialog {

--7.5 show the dialog
maindlg:showxy(iup.CENTER,iup.CENTER) 

--7.6 Main Loop
if (iup.MainLoopLevel()==0) then iup.MainLoop() end

--]====]

