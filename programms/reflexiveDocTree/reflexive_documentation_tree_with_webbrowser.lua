lua_tree_output={ branchname="example of a reflexive tree", 
{ branchname="Node 1", 
{ branchname="Neuer Ast", 
{ branchname="1", 
state="COLLAPSED",
},
},
{ branchname="Node 2", 
{ branchname="Test", 
 "Neuer Ast", "2", 
 "3", 
},
 "Leaf",}}}--lua_tree_output



TextHTMLtable={
[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Documentation Tree </h1>

<ul><li>Inhaltsverzeichnis

<ul><li>IUP-Lua-Installation

</li></ul>

<ul><li>Herunterladen der Oberfläche
<ul><li>ansicht_documentation_tree.lua</li></ul>
<ul><li>simple_webbrowser.lua</li></ul>
</li></ul>

<ul><li>Verwendungen im Büroalltag
</li></ul>

</li></ul>



</body></html> ]====],
[====[<!DOCTYPE html> <head></head><html> <body leftmargin="150">
<br><h1><font size="32">Präsentation </font></h1>

<font size="25">

<ul><li>Einleitung</li></ul>

<ul><li>Kompatibilität mit Office-Produkten
<ul><li>Word</li></ul>
<ul><li>Excel</li></ul>
<ul><li>Powerpoint</li></ul>
</li></ul>

<ul><li>Ausblick</li></ul>

</font>

</body></html> ]====],
[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Neue Seite </h1>

</body></html> ]====],
["Node 2"]=[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Neue Seite </h1>

</body></html> ]====],
["Test"]=[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Test Seite </h1>

</body></html> ]====],
["Neuer Ast"]=[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Neue Seite </h1>

Diese wird jetzt verändert.

</body></html> ]====],
}--TextHTMLtable<!--



----[====[This programm has webpages within the Lua script which can contain a tree in html

--1. basic data

--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iupluaweb")        --require iupluaweb for webbrowser
require("iuplua_scintilla") --for Scintilla-editor
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
	--save the html pages
	for k,v in pairs(TextHTMLtable) do 
		if type(k)=="number" then
		output_htmlTexts_text=output_htmlTexts_text .. "\n[====[" .. v .. "]====],"
		else
		output_htmlTexts_text=output_htmlTexts_text .. '\n["' .. string.escape_forbidden_char(k) .. '"]=[====[' .. v .. "]====],"
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
	webbrowser1.HTML= textfield1.value
	if tonumber(textbox1.value) then
		TextHTMLtable[aktuelleSeite]= textfield1.value
	else
		TextHTMLtable[textbox1.value]= textfield1.value
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
	from,to=textfield1.value:find(textbox2.value,searchPosition)
	searchPosition=to
	if from==nil then 
		searchPosition=1 
		iup.Message("Suchtext in der Seite nicht gefunden","Suchtext in der Seite nicht gefunden")
	else
		textfield1.SELECTIONPOS=from-1 .. ":" .. to
	end --if from==nil then 
end --function search_in_text:flat_action()

--textfield
textfield1=iup.scintilla{}
textfield1.SIZE="320x320" --I think this is not optimal! (since the size is so appears to be fixed)
textfield1.EXPAND="YES"
--textfield1.wordwrap="WORD" --enable wordwarp
textfield1.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
textfield1.FONT="Courier New, 12" --font of shown code
textfield1.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
textfield1.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
textfield1.STYLEFGCOLOR0="0 0 0"      -- 0-Default
textfield1.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
textfield1.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
textfield1.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
textfield1.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
textfield1.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
textfield1.STYLEFGCOLOR6="160 20 180"  -- 6-String 
textfield1.STYLEFGCOLOR7="128 0 0"    -- 7-Character
textfield1.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
textfield1.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
textfield1.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--textfield1.STYLEBOLD10="YES"
--textfield1.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--textfield1.STYLEITALIC10="YES"
textfield1.MARGINWIDTH0="40"

--label
label1 = iup.label{title="Blattinhalt:"}--label for textfield

--open the dialog for renaming page
dlg_change_page = iup.dialog{
	iup.vbox{label1, textfield1, iup.hbox{ok_change_page,search_in_text,cancel_change_page}}; 
	title="Seite bearbeiten",
	size="560x450",
	startfocus=textfield1,
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
	webbrowser1.EDITABLE="NO"
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
	webbrowser1.EDITABLE="NO"
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
button_save_lua_table=iup.flatbutton{title="Datei \nspeichern", size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	save_html_to_lua(TextHTMLtable, path .. "\\" .. thisfilename)
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

--6.3.3 button for going to first page
button_go_to_first_page = iup.flatbutton{title = "Startseite",size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_to_first_page:flat_action()
	webbrowser1.EDITABLE="NO"
	webbrowser1.HTML=TextHTMLtable[1]
	aktuelleSeite=1
	textbox1.value=aktuelleSeite
end --function button_go_to_first_page:flat_action()

--6.4 button for going one page back
button_go_back = iup.flatbutton{title = "Eine Seite \nzurück",size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_back:flat_action()
	webbrowser1.EDITABLE="NO"
	if aktuelleSeite>1 then aktuelleSeite=aktuelleSeite-1 end
	webbrowser1.HTML=TextHTMLtable[aktuelleSeite]
	textbox1.value=aktuelleSeite
end --function button_go_back:flat_action()

--6.5 button for going to the page and edit the page
button_edit_page = iup.flatbutton{title = "Editieren der \nSeite:",size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_page:flat_action()
	webbrowser1.EDITABLE="NO"
	if tonumber(textbox1.value) then
		aktuelleSeite=math.tointeger(tonumber(textbox1.value))
		TextErsatz=TextHTMLtable[aktuelleSeite]
		webbrowser1.HTML=TextErsatz
	else
		TextErsatz=TextHTMLtable[textbox1.value]
		webbrowser1.HTML=TextErsatz
	end --if tonumber(textbox1.value) then
	textfield1.value=TextErsatz
	dlg_change_page:popup(iup.LEFT, iup.TOP) --popup rename dialog
end --function button_edit_page:flat_action()

--6.6.1 button for going to the page
button_go_to_page = iup.flatbutton{title = "Gehe \nzu Seite:",size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_to_page:flat_action()
	webbrowser1.EDITABLE="NO"
	if tonumber(textbox1.value) then
		aktuelleSeite=math.tointeger(tonumber(textbox1.value))
		TextErsatz=TextHTMLtable[aktuelleSeite]
		webbrowser1.HTML=TextErsatz
	else
		aktuelleSeite=textbox1.value
		TextErsatz=TextHTMLtable[aktuelleSeite]
		webbrowser1.HTML=TextErsatz
	end --if tonumber(textbox1.value) then
end --function button_go_to_page:flat_action()

--6.6.2 button for going to the page
button_go_to_page_of_node = iup.flatbutton{title = "Gehe zu Seite \nvom Knoten:",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_to_page_of_node:flat_action()
	webbrowser1.EDITABLE="NO"
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
end --function button_go_to_page_of_node:flat_action()

--6.7 button for deleting the page
button_delete = iup.flatbutton{title = "Löschen \nder Seite",size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_delete:flat_action()
	LoeschAlarm=iup.Alarm("Soll die Seite " .. tonumber(textbox1.value) .. " wirklich gelöscht werden?","Soll die Seite " .. tonumber(textbox1.value) .. " wirklich gelöscht werden?","Löschen","Nicht Löschen")
	if LoeschAlarm==1 then 
		if tonumber(textbox1.value) and tonumber(textbox1.value)<=#TextHTMLtable then
			aktuelleSeite=math.tointeger(tonumber(textbox1.value))
			table.move(TextHTMLtable,aktuelleSeite+1,#TextHTMLtable,aktuelleSeite)--move following elements to begin with index from aktuelleSeite
			TextHTMLtable[#TextHTMLtable]=nil --delete last element
			--test with: iup.Message(aktuelleSeite, tostring(math.floor(aktuelleSeite/2)*2==aktuelleSeite))
			webbrowser1.HTML="Seite gelöscht"
		else
			iup.Message("Keine Seite zum Löschen","Keine Seite zum Löschen")
		end --if tonumber(textbox1.value) and tonumber(textbox1.value)<=#TextHTMLtable then
	end --if LoeschAlarm==1 then 
end --function button_delete:flat_action()

--6.8 button for saving TextHTMLtable as html file
button_save_as_html=iup.flatbutton{title="Als html \nspeichern", size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_as_html:flat_action()
	local outputfile1=io.open(path .. "\\" .. thisfilename:gsub("%.lua$",".html"),"w")
	for k,v in pairs(TextHTMLtable) do
		outputfile1:write(v .. "\n")
	end --for k,v in pairs(TextHTMLtable) do
	outputfile1:close()
end --function button_save_as_html:flat_action()

--6.9 button for search in TextHTMLtable
button_search_in_pages=iup.flatbutton{title="Suche in \nSeiten", size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search_in_pages:flat_action()
	aktuelleSeite=math.tointeger(tonumber(textbox1.value))
	if aktuelleSeite<=#TextHTMLtable then
		for i=aktuelleSeite+1,#TextHTMLtable do
			if TextHTMLtable[i]:gsub("<[^>]+>",""):lower():match(textbox2.value:lower()) then
				textbox1.value=i
				aktuelleSeite=math.tointeger(tonumber(textbox1.value))
				webbrowser1.HTML=TextHTMLtable[aktuelleSeite]
				break 
			end --if TextHTMLtable[i]:gsub("<[^>]+>",""):lower():match(textbox2.value:lower()) then
		end --for i=aktuelleSeite,#TextHTMLtable do
	end --if aktuelleSeite<=#TextHTMLtable then
end --function button_search_in_pages:flat_action()


--6.10 button for going to the next page
button_go_forward = iup.flatbutton{title = "Eine \nSeite vor",size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_forward:flat_action()
	webbrowser1.EDITABLE="NO"
	if aktuelleSeite<#TextHTMLtable then aktuelleSeite=aktuelleSeite+1 end
	webbrowser1.HTML=TextHTMLtable[aktuelleSeite]
	textbox1.value=aktuelleSeite
end --function button_go_forward:flat_action()

--6.11 button for building new page
button_new_page = iup.flatbutton{title = "Neue \nSeite",size="35x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_new_page:flat_action()
	webbrowser1.EDITABLE="NO"
	aktuelleSeite=#TextHTMLtable+1
	textbox1.value=aktuelleSeite
local newText=[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Neue Seite </h1>

</body></html> ]====]
	webbrowser1.HTML=newText
	TextHTMLtable[aktuelleSeite]= newText
end --function button_new_page:flat_action()

--6.12.1.1 button for editing page with potential code
button_edit_programm = iup.flatbutton{title = "Programm \neditieren",size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_programm:flat_action()
	exchangeText=webbrowser1.HTML:gsub("<h.-/h%d>","") --do not take titles
					:gsub("<p.-/p>","") --do not take paragraphs
					:gsub("\n"," ") --do not take line breaks
					:gsub("<br>","\n") --html line breaks special treatment
					:gsub("<.->","") --do not take all other tags
					:gsub("\n","<br>") --restore html line breaks in code
	webbrowser1.EDITABLE="YES"
	webbrowser1.HTML=exchangeText
end --function button_edit_programm:flat_action()

--6.12.1.2 button for not editing and go back to page
button_no_edit_and_back_to_page = iup.flatbutton{title = "Zur Seite \nzurück",size="40x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_no_edit_and_back_to_page:flat_action()
	button_go_to_page_of_node:flat_action()
end --function button_no_edit_and_back_to_page:flat_action()

--6.12.2 button for copying page as a pure programm
button_copy_programm = iup.flatbutton{title = "Reines Programm \nkopieren",size="70x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_copy_programm:flat_action()
	clipboard.text = webbrowser1.HTML:gsub("<h.-/h%d>","") --do not take titles
					:gsub("<p.-/p>","") --do not take paragraphs
					:gsub("\r","\n") --take carriage return as line break
					:gsub(" \n"," ") --do not take line breaks
					:gsub("\n"," ") --do not take line breaks
					:gsub("<br>","\n") --html line breaks special treatment
					:gsub("<BR>","\n") --html line breaks special treatment
					:gsub("<.->","") --do not take all other tags
					:gsub("&nbsp;"," ") --do not take space as special code
end --function button_copy_programm:flat_action()

--6.12.3 button for copying page as a programm with comments
button_copy_programm_with_comments = iup.flatbutton{title = "Programm mit \nKommentaren kopieren",size="95x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_copy_programm_with_comments:flat_action()
	--put line break out of comments
	exchangeText= webbrowser1.HTML:gsub("<h(%d)>(.-)\n(.-)</h(%d)>","<h%1>%2 %3</h%4>")
	while exchangeText:match("<h%d>.-\n.-</h%d>") do
		exchangeText= exchangeText:gsub("<h(%d)>(.-)\n(.-)</h(%d)>","<h%1>%2 %3</h%4>")
	end --while exchangeText:match("<h%d>.-\n.-</h%d>") do
	exchangeText= exchangeText:gsub("<p>(.-)\n(.-)</p>","<p>%1 %2</p>")
	while exchangeText:match("<p>.-\n.-</p>") do
		exchangeText= exchangeText:gsub("<p>(.-)\n(.-)</p>","<p>%1 %2</p>")
	end --while exchangeText:match("<p>.-\n.-</p>") do
	exchangeText= exchangeText:gsub("<pre>(.-)\n(.-)</pre>","<pre>%1<br>%2</pre>")
	while exchangeText:match("<pre>.-\n.-</pre>") do
		exchangeText= exchangeText:gsub("<pre>(.-)\n(.-)</pre>","<pre>%1<br>%2</pre>")
	end --while exchangeText:match("<pre>.-\n.-</pre>") do
	exchangeText= exchangeText:gsub("<ul><li>(.-)\n(.-)</li></ul>","<ul><li>%1 %2</li></ul>")
	while exchangeText:match("<ul><li>.-\n.-</li></ul>") do
		exchangeText= exchangeText:gsub("<ul><li>(.-)\n(.-)</li></ul>","<ul><li>%1 %2</li></ul>")
	end --while exchangeText:match("<ul><li>.-\n.-</li></ul>") do
	clipboard.text = exchangeText:gsub("\r","\n") --take carriage return as line break
					:gsub(" \n"," ") --do not take line breaks
					:gsub("\n"," ") --do not take line breaks
					:gsub("<h%d>(.-)</h%d>","\n" .. textbox3.value .. " %1") --take titles as comments
					:gsub("<p>(.-)</p>","\n" .. textbox3.value .. " %1") --take paragraphs as comments
					:gsub("<ul><li>","\n" .. textbox3.value .. "\t") --take line tree as comments with only one tabulator independently of the tree hierarchy
					:gsub("<br>","\n") --html line breaks special treatment
					:gsub("<BR>","\n") --html line breaks special treatment
					:gsub("<.->","") --do not take all other tags
					:gsub("&lt;","<") --convert html tag for programm
					:gsub("&gt;","<") --convert html tag for programm
					:gsub("&nbsp;"," ") --do not take space as special code
end --function button_copy_programm_with_comments:flat_action()

--6.12.4 button for copying page as a Lua tree
button_copy_programm_with_comments_and_tree = iup.flatbutton{title = "Baum \nkopieren",size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_copy_programm_with_comments_and_tree:flat_action()
	if webbrowser1.EDITABLE=="NO" then
		--put line break out of comments
		exchangeText= webbrowser1.HTML:gsub("<h(%d)>(.-)\n(.-)</h(%d)>","<h%1>%2 %3</h%4>")
		while exchangeText:match("<h%d>.-\n.-</h%d>") do
			exchangeText= exchangeText:gsub("<h(%d)>(.-)\n(.-)</h(%d)>","<h%1>%2 %3</h%4>")
		end --while exchangeText:match("<h%d>.-\n.-</h%d>") do
		exchangeText= exchangeText:gsub("<p>(.-)\n(.-)</p>","<p>%1 %2</p>")
		while exchangeText:match("<p>.-\n.-</p>") do
			exchangeText= exchangeText:gsub("<p>(.-)\n(.-)</p>","<p>%1 %2</p>")
		end --while exchangeText:match("<p>.-\n.-</p>") do
		exchangeText= exchangeText:gsub("<ul><li>(.-)\n(.-)</li></ul>","<ul><li>%1 %2</li></ul>")
		while exchangeText:match("<ul><li>.-\n.-</li></ul>") do
			exchangeText= exchangeText:gsub("<ul><li>(.-)\n(.-)</li></ul>","<ul><li>%1 %2</li></ul>")
		end --while exchangeText:match("<ul><li>.-\n.-</li></ul>") do
		--take <ul><li> tags as a Lua tree
		exchangeText=exchangeText:gsub("<ul><li>",'\n{branchname="')
		exchangeText=exchangeText:gsub("</li></ul>",'\n},')
		exchangeText=exchangeText:gsub('{branchname="(.-) *\n','{branchname="%1",\n')
		exchangeText=exchangeText:gsub("<h.-/h%d>","") --do not take titles
						:gsub("<p.-/p>","") --do not take paragraphs
						:gsub("<br>","") --do not take line breaks
		exchangeText=exchangeText:gsub("\n([^{}\n]+)\n","\n--%1\n") --add comments to all lines not in tree first replacement
		exchangeText=exchangeText:gsub("\n([^%-{}\n]+)\n","\n--%1\n") --add comments to all lines not in tree second replacement
		exchangeText='Tree={branchname="' .. textbox1.value .. '",\n' .. exchangeText .. "\n}"
		clipboard.text = exchangeText:gsub("<.->","") --add comments to all lines not in tree
	else
		exchangeText=""
		for line in (webbrowser1.HTML .. "\n"):gmatch("([^\n]*)\n") do
			exchangeText = exchangeText .. '[====[' .. line .. ']====],\n'
		end --for line in webbrowser1.HTML:gmatch("[\n]*\n") do
		clipboard.text = 'Tree={branchname="' .. textbox1.value .. '",\n' .. exchangeText .. '}'
	end --if webbrowser1.EDITABLE=="NO" then
end --function button_copy_programm_with_comments_and_tree:flat_action()

--6.13 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de")
end --function button_logo:flat_action()

--7 Main Dialog

--7.1 textboxes
textbox1 = iup.text{value="1",size="40x20",WORDWRAP="NO",alignment="ACENTER"}
textbox2 = iup.multiline{value="",size="90x20",WORDWRAP="YES"}
textbox3 = iup.text{value="--",size="20x20"}

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
			button_go_to_first_page,
			button_go_back,
			button_edit_page,
			button_go_to_page,
			button_go_to_page_of_node,
			textbox1,
			button_delete,
			button_copy_programm,
			button_copy_programm_with_comments,
			button_copy_programm_with_comments_and_tree,
			textbox3,
			button_edit_programm,
			button_no_edit_and_back_to_page,
			iup.fill{},
			button_save_as_html,
			button_search_in_pages,
			textbox2,
			button_go_forward,
			button_new_page,
			button_logo2,
		}, --iup.hbox{
		iup.hbox{iup.frame{title="Manuelle Zuordnung als Baum",tree,},webbrowser1,},
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
