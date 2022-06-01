lua_tree_output={ branchname="Title\\n\\n", 
{ branchname="Subtitle\\n\\n", 
 "This is a text with a paragraph end.\\n\\n", "This is a text without line break ", 
 "that is finished in the next node.\\n\\n", 
},
{ branchname="Next subtitle\\n\\n", 
 "This is a ", "next text.\\n\\n", 
}}--lua_tree_output



TextHTMLtable={
[====[<!DOCTYPE html> <head></head><html> <body>  <body leftmargin="50">

<br><br><br>
<h1><big>Title of Html </big></h1>


</body></html> ]====],
}--TextHTMLtable<!--



----[====[This programm has webpages within the Lua script which can contain a tree in html

--1. basic data

--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iupluaweb")        --require iupluaweb for webbrowser
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


--1.3 path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)

--2. global data definition
aktuelleSeite=1


--3. functions
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

--3.2 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--3.3 function which saves the current iup htmlTexts as a Lua table
function save_html_to_lua(htmlTexts, outputfile_path)
	--read the programm of the file itself, commentSymbol is used to have another pattern here as searched
	inputfile=io.open(path .. "\\" .. thisfilename,"r")
	commentSymbol,inputTextProgramm=inputfile:read("*a"):match("lua_tree_output={.*}%-%-lua_tree_output.*TextHTMLtable={.*}(%-%-)TextHTMLtable<!%-%-(.*)")
	inputfile:close()
	--build the new htmlTexts
	local output_htmlTexts_text="TextHTMLtable={" --the output string
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
	outputfile:write(output_tree_text .. "--lua_tree_output\n\n\n\n") --write everything into the outputfile
	--save the html pages
	for k,v in pairs(TextHTMLtable) do 
		if type(k)=="number" then
		output_htmlTexts_text=output_htmlTexts_text .. "\n[====[" .. v .. "]====],"
		else
		output_htmlTexts_text=output_htmlTexts_text .. '\n["' .. k .. '"]=[====[' .. v .. "]====],"
		end --if type(k)=="number" then
	end --for k,v in pairs(TextHTMLtable) do 

	output_htmlTexts_text=output_htmlTexts_text .. "\n}"
	outputfile:write(output_htmlTexts_text .. "--TextHTMLtable<!--") --write everything into the outputfile
	--write the programm for the data in itself
	outputfile:write(inputTextProgramm)
	outputfile:close()
end --function save_html_to_lua(htmlTexts, outputfile_path)



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

--4.2 change page dialog
--ok_change_page button
ok_change_page = iup.flatbutton{title = "Seite verändern",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function ok_change_page:flat_action()
	webbrowser1.HTML= text1.value
	if tonumber(textbox1.value) then
		TextHTMLtable[aktuelleSeite]= text1.value
	else
		TextHTMLtable[textbox1.value]= text1.value
	end --if tonumber(textbox1.value) then
	return iup.CLOSE
end --function ok_change_page:flat_action()

--cancel_change_page button
cancel_change_page = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function cancel_change_page:flat_action()
	return iup.CLOSE
end --function cancel_change_page:flat_action()

--search searchtext.value in textfield1
search_in_text = iup.flatbutton{title = "Suche in der Seite",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
searchPosition=1
function search_in_text:flat_action()
	from,to=text1.value:find(textbox2.value,searchPosition)
	searchPosition=to
	if from==nil then 
		searchPosition=1 
		iup.Message("Suchtext in der Seite nicht gefunden","Suchtext in der Seite nicht gefunden")
	else
		text1.SELECTIONPOS=from-1 .. ":" .. to
	end --if from==nil then 
end --function search_in_text:flat_action()

text1 = iup.multiline{size="120x50",border="YES",expand="YES",wordwrap="YES"} --textfield
label1 = iup.label{title="Blattinhalt:"}--label for textfield

--open the dialog for renaming page
dlg_change_page = iup.dialog{
	iup.vbox{label1, text1, iup.hbox{ok_change_page,search_in_text,cancel_change_page}}; 
	title="Seite bearbeiten",
	size="400x350",
	startfocus=text1,
	}

--4.2 change page dialog end



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

--5.1.8 menu for building new page
menu_new_page = iup.item {title = "Neue Seite"}
function menu_new_page:action()
local newText=[====[<!DOCTYPE html> <head></head><html> <body>
<h1>]====] .. tree['title'] .. [====[</h1>

</body></html> ]====]
	if TextHTMLtable[tree['title']]==nil then
		webbrowser1.HTML=newText
		TextHTMLtable[tree['title']]= newText
	end --if TextHTMLtable[tree['title']]==nil then
	if tonumber(tree['title']) then 
		actualPage=math.tointeger(tonumber(tree['title'])) 
		webbrowser1.HTML=TextHTMLtable[actualPage]
		textbox1.value=tree['title']
		actualPage=tonumber(tree['title'])
	else
		webbrowser1.HTML=TextHTMLtable[tree['title']]
		textbox1.value=tree['title']
	end --if tonumber(tree['title']) then 
end --function menu_new_page:action()


--5.1.9 menu for going to webbrowser page
menu_goto_page=iup.item {title="Gehe zu Seite vom Knoten", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function menu_goto_page:action()
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
			webbrowser1.HTML=tree['title'] .. " hat keine Webpage"
		end --if TextHTMLtable[tree['title']] then
	end --if tonumber(tree['title']) then 
end --function menu_goto_page:flat_action()

--5.1.10 start the file or repository of the node of tree
startnode = iup.item {title = "Starten"}
function startnode:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then os.execute('start "D" "' .. tree['title'] .. '"') end
end --function startnode:action()

--5.1.11 start the url in webbrowser
startnode_url = iup.item {title = "Starten URL"}
function startnode_url:action() 
	if tree['title']:match("http") then
		webbrowser1.value=tree['title'] --for instance: "https://www.lua.org"
	end --if tree['title']:match("http") then
end --function startnode_url:action()

--5.1.12 put the menu items together in the menu for tree
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
		menu_new_page, 
		menu_goto_page, 
		startnode_url, 
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

--6.2 button for saving TextHTMLtable and the programm of the graphical user interface
button_save_lua_table=iup.flatbutton{title="Datei speichern", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	save_html_to_lua(TextHTMLtable, path .. "\\" .. thisfilename)
end --function button_save_lua_table:flat_action()

--6.3.1 button for search in tree
button_search=iup.flatbutton{title="Suchen\n(Strg+F)", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
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

--6.3.3 button for going to first page
button_go_to_first_page = iup.flatbutton{title = "Startseite",size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_to_first_page:flat_action()
	webbrowser1.HTML=TextHTMLtable[1]
	aktuelleSeite=1
	textbox1.value=aktuelleSeite
end --function button_go_to_first_page:action()

--6.5 button for going to the page and edit the page
button_edit_page = iup.flatbutton{title = "Editieren der Seite:",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_page:flat_action()
	if tonumber(textbox1.value) then
		aktuelleSeite=math.tointeger(tonumber(textbox1.value))
		TextErsatz=TextHTMLtable[aktuelleSeite]
		webbrowser1.HTML=TextErsatz
	else
		TextErsatz=TextHTMLtable[textbox1.value]
		webbrowser1.HTML=TextErsatz
	end --if tonumber(textbox1.value) then
	text1.value=TextErsatz
	dlg_change_page:popup(iup.CENTER, iup.CENTER) --popup rename dialog
end --function button_edit_page:action()

--6.6 button for going to the page
button_load_tree_to_html = iup.flatbutton{title = "Baum als html laden",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_load_tree_to_html:flat_action()
	webbrowserText='<font size="5"> '
	AusgabeTabelle={}
	for i=0,tree.count - 1 do --loop for all nodes
		if i==0 then
			AusgabeTabelle[tree['TITLE' .. i]]=true
			webbrowserText=webbrowserText .. "<ul><li>" .. "<b>" .. 
			tostring(tree['TITLE' .. i])
			:gsub("Ã¤","&auml;")
			:gsub("ä","&auml;")
			:gsub("Ã","&Auml;")
			:gsub("Ä","&Auml;")
			:gsub("Ã¶","&ouml;")
			:gsub("ö","&ouml;")
			:gsub("Ã","&Ouml;")
			:gsub("Ö","&Ouml;")
			:gsub("Ã¼","&uuml;")
			:gsub("ü","&uuml;")
			:gsub("Ã","&Uuml;")
			:gsub("Ü","&Uuml;")
			:gsub("Ã","&szlig;")
			:gsub("ß","&szlig;")
			:gsub("\\n","<br>") .. "</b>" .. "\n"
		elseif i>0 and tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) and tree["KIND" .. i ] == "BRANCH" then
			AusgabeTabelle[tree['TITLE' .. i]]=true
			webbrowserText=webbrowserText .. "<ul><li>" .. "<b>" .. 
			tostring(tree['TITLE' .. i])
			:gsub("Ã¤","&auml;")
			:gsub("ä","&auml;")
			:gsub("Ã","&Auml;")
			:gsub("Ä","&Auml;")
			:gsub("Ã¶","&ouml;")
			:gsub("ö","&ouml;")
			:gsub("Ã","&Ouml;")
			:gsub("Ö","&Ouml;")
			:gsub("Ã¼","&uuml;")
			:gsub("ü","&uuml;")
			:gsub("Ã","&Uuml;")
			:gsub("Ü","&Uuml;")
			:gsub("Ã","&szlig;")
			:gsub("ß","&szlig;")
			:gsub("\\n","<br>") .. "</b>" .. "\n"
		elseif i>0 and tonumber(tree["DEPTH" .. i ]) <= tonumber(tree["DEPTH" .. i-1 ]) and tree["KIND" .. i ] == "BRANCH" then
			if tree["KIND" .. i ] == "BRANCH" and tree["KIND" .. i-1 ] == "BRANCH" then
				webbrowserText=webbrowserText .. "</li></ul>" .. "\n"
			end --if tree["KIND" .. i ] == "BRANCH" and tree["KIND" .. i-1 ] == "BRANCH" then
			for j=1,math.max(math.tointeger(tonumber(tree["DEPTH" .. i-1 ])-tonumber(tree["DEPTH" .. i])),0) do
				webbrowserText=webbrowserText .. "</li></ul>" .. "\n"
			end --for j=1,math.max(math.tointeger(tonumber(tree["DEPTH" .. i-1 ])-tonumber(tree["DEPTH" .. i])),0)+1 do
			AusgabeTabelle[tree['TITLE' .. i]]=true
			webbrowserText=webbrowserText .. "<ul><li>" .. "<b>" .. 
			tostring(tree['TITLE' .. i])
			:gsub("Ã¤","&auml;")
			:gsub("ä","&auml;")
			:gsub("Ã","&Auml;")
			:gsub("Ä","&Auml;")
			:gsub("Ã¶","&ouml;")
			:gsub("ö","&ouml;")
			:gsub("Ã","&Ouml;")
			:gsub("Ö","&Ouml;")
			:gsub("Ã¼","&uuml;")
			:gsub("ü","&uuml;")
			:gsub("Ã","&Uuml;")
			:gsub("Ü","&Uuml;")
			:gsub("Ã","&szlig;")
			:gsub("ß","&szlig;")
			:gsub("\\n","<br>") .. "</b>" .. "\n"
			--test with: print(tree['TITLE' .. i])
		elseif i>0 and tonumber(tree["DEPTH" .. i ]) < tonumber(tree["DEPTH" .. i-1 ]) and tree["KIND" .. i ] == "LEAF" then
			if tree["KIND" .. i ] == "LEAF" and tree["KIND" .. i-1 ] == "LEAF" then
				webbrowserText=webbrowserText .. "</li></ul>" .. "\n"
			end --if tree["KIND" .. i ] == "BRANCH" and tree["KIND" .. i-1 ] == "BRANCH" then
			for j=1,math.max(math.tointeger(tonumber(tree["DEPTH" .. i-1 ])-tonumber(tree["DEPTH" .. i])),0) do
				webbrowserText=webbrowserText .. "</li></ul>" .. "\n"
			end --for j=1,math.max(math.tointeger(tonumber(tree["DEPTH" .. i-1 ])-tonumber(tree["DEPTH" .. i])),0)+1 do
			AusgabeTabelle[tree['TITLE' .. i]]=true
			webbrowserText=webbrowserText .. "<ul><li>" .. 
			tostring(tree['TITLE' .. i])
			:gsub("Ã¤","&auml;")
			:gsub("ä","&auml;")
			:gsub("Ã","&Auml;")
			:gsub("Ä","&Auml;")
			:gsub("Ã¶","&ouml;")
			:gsub("ö","&ouml;")
			:gsub("Ã","&Ouml;")
			:gsub("Ö","&Ouml;")
			:gsub("Ã¼","&uuml;")
			:gsub("ü","&uuml;")
			:gsub("Ã","&Uuml;")
			:gsub("Ü","&Uuml;")
			:gsub("Ã","&szlig;")
			:gsub("ß","&szlig;")
			:gsub("\\n","<br>") .. "\n"
			--test with: print(tree['TITLE' .. i])
		else
			AusgabeTabelle[tree['TITLE' .. i]]=true
			webbrowserText=webbrowserText .. 
			tostring(tree['TITLE' .. i])
			:gsub("Ã¤","&auml;")
			:gsub("ä","&auml;")
			:gsub("Ã","&Auml;")
			:gsub("Ä","&Auml;")
			:gsub("Ã¶","&ouml;")
			:gsub("ö","&ouml;")
			:gsub("Ã","&Ouml;")
			:gsub("Ö","&Ouml;")
			:gsub("Ã¼","&uuml;")
			:gsub("ü","&uuml;")
			:gsub("Ã","&Uuml;")
			:gsub("Ü","&Uuml;")
			:gsub("Ã","&szlig;")
			:gsub("ß","&szlig;")
			:gsub("\\n","<br>") .. "\n"
		end --if i>0 and tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) then
	end --for i=0,tree.count - 1 do --loop for all nodes
	webbrowserText=webbrowserText .. "</font>"
	webbrowser1.HTML=webbrowserText
end --function button_load_tree_to_html:action()


--6.8 button for saving TextHTMLtable as html file
button_save_as_html=iup.flatbutton{title="Als html speichern", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_as_html:flat_action()
	local outputfile1=io.open(path .. "\\" .. thisfilename:gsub("%.lua$",".html"),"w")
	for k,v in pairs(TextHTMLtable) do
		outputfile1:write(v:gsub("Ã¤","&auml;")
				:gsub("ä","&auml;")
				:gsub("Ã","&Auml;")
				:gsub("Ä","&Auml;")
				:gsub("Ã¶","&ouml;")
				:gsub("ö","&ouml;")
				:gsub("Ã","&Ouml;")
				:gsub("Ö","&Ouml;")
				:gsub("Ã¼","&uuml;")
				:gsub("ü","&uuml;")
				:gsub("Ã","&Uuml;")
				:gsub("Ü","&Uuml;")
				:gsub("Ã","&szlig;")
				:gsub("ß","&szlig;")
				.. "\n")
	end --for k,v in pairs(TextHTMLtable) do
	outputfile1:write(webbrowser1.HTML:gsub("Ã¤","&auml;")
				:gsub("ä","&auml;")
				:gsub("Ã","&Auml;")
				:gsub("Ä","&Auml;")
				:gsub("Ã¶","&ouml;")
				:gsub("ö","&ouml;")
				:gsub("Ã","&Ouml;")
				:gsub("Ö","&Ouml;")
				:gsub("Ã¼","&uuml;")
				:gsub("ü","&uuml;")
				:gsub("Ã","&Uuml;")
				:gsub("Ü","&Uuml;")
				:gsub("Ã","&szlig;")
				:gsub("ß","&szlig;")
				.. "\n")
	outputfile1:close()
end --function button_save_as_html:flat_action()

--6.9 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de)
end --function button_logo:flat_action()

--7 Main Dialog

--7.1 textboxes
textbox1 = iup.text{value="1",size="20x20",WORDWRAP="NO",alignment="ACENTER"}
textbox2 = iup.multiline{value="",size="90x20",WORDWRAP="YES"}

--7.2 webbrowser
webbrowser1=iup.webbrowser{HTML=TextHTMLtable[1],MAXSIZE="1150x950"}
function webbrowser1:navigate_cb(url)
	--test with: iup.Message("",url)
	if url:match("file///") then --only url with https:// or http// ar loaded
		os.execute('start "D" "' .. url:match("file///(.*)") .. '"')
	end --if url:match("file///") then
end --function webbrowser1:navigate_cb(url)

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
	elseif c == iup.K_cF then
		searchtext.value=tree.title
		searchtext.SELECTION="ALL"
		dlg_search:popup(iup.ANYWHERE, iup.ANYWHERE)
	elseif c == iup.K_cR then
		button_expand_collapse_dialog:flat_action()
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
			button_go_to_first_page,
			button_go_back,
			button_edit_page,
			button_load_tree_to_html,
			textbox1,
			iup.fill{},
			button_save_as_html,
			button_search_in_pages,
			textbox2,
			button_go_forward,
			button_new_page,
			button_logo2,
		}, --iup.hbox{
		iup.split{iup.frame{title="Manuelle Zuordnung als Baum",tree,},webbrowser1,},
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

--7.6 load tree in webbrowser
webbrowserText='<font size="5"> '
function readTreetohtmlRecursive(TreeTable)
	AusgabeTabelle[TreeTable.branchname]=true
	webbrowserText=webbrowserText .. "<ul><li>" .. "<b>" .. 
	tostring(TreeTable.branchname)
	:gsub("Ã¤","&auml;")
	:gsub("ä","&auml;")
	:gsub("Ã","&Auml;")
	:gsub("Ä","&Auml;")
	:gsub("Ã¶","&ouml;")
	:gsub("ö","&ouml;")
	:gsub("Ã","&Ouml;")
	:gsub("Ö","&Ouml;")
	:gsub("Ã¼","&uuml;")
	:gsub("ü","&uuml;")
	:gsub("Ã","&Uuml;")
	:gsub("Ü","&Uuml;")
	:gsub("Ã","&szlig;")
	:gsub("ß","&szlig;")
	:gsub("\\n","<br>") .. "</b>" .. "\n"
	for k,v in ipairs(TreeTable) do
		if type(v)=="table" then
			readTreetohtmlRecursive(v)
		else
			AusgabeTabelle[v]=true
			webbrowserText=webbrowserText .. v:gsub("Ã¤","&auml;")
							:gsub("ä","&auml;")
							:gsub("Ã","&Auml;")
							:gsub("Ä","&Auml;")
							:gsub("Ã¶","&ouml;")
							:gsub("ö","&ouml;")
							:gsub("Ã","&Ouml;")
							:gsub("Ö","&Ouml;")
							:gsub("Ã¼","&uuml;")
							:gsub("ü","&uuml;")
							:gsub("Ã","&Uuml;")
							:gsub("Ü","&Uuml;")
							:gsub("Ã","&szlig;")
							:gsub("ß","&szlig;")
							:gsub("\\n","<br>")
							.. "\n"
		end --if type(v)=="table" then
	end --for k, v in ipairs(TreeTable) do
	webbrowserText=webbrowserText .. "</li></ul>" .. "\n"
end --function readTreetohtmlRecursive(TreeTable)
AusgabeTabelle={}
readTreetohtmlRecursive(lua_tree_output)
webbrowserText=webbrowserText .. "</font>"
webbrowser1.HTML=webbrowserText


--7.7 Main Loop
if (iup.MainLoopLevel()==0) then iup.MainLoop() end

--]====]
