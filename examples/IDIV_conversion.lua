--This script runs a graphical user interface (GUI) in order to convert text into a tree. SQL statements, excel formulas and text with tabulator can be treated.


--1. basic data

--1.1 libraries and clipboard
--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iuplua_scintilla") --for Scintilla-editor

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

--3.1.1 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--3.1.2 function string:split() for splittings strings
function string:split( inSplitPattern )
	local outResults = {}
	local theStart = 1
	local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	--loop throuch string
	while theSplitStart do
		table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
		theStart = theSplitEnd + 1
		theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	end --while theSplitStart do
	--write results in table
	table.insert( outResults, string.sub( self, theStart ) )
	return outResults
end --function string:split( inSplitPattern )

--4. no dialogs

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

--6.2 button for building tree with text with tabulator
button_numbering_as_tabs=iup.flatbutton{title="Kommentar-Nummerierungen (--Zahl) \nmit Tabulatoren", size="145x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_numbering_as_tabs:flat_action()
	text=textfield1.value:gsub("%-%-%d+%.%d+%.%d+%.%d+.%d+ ","\t\t\t\t\t%1")
				:gsub("%-%-%d+%.%d+%.%d+%.%d+ ","\t\t\t\t%1")
				:gsub("%-%-%d+%.%d+%.%d+ ","\t\t\t%1")
				:gsub("%-%-%d+%.%d+ ","\t\t%1")
				:gsub("%-%-%d+%. ","\t%1")
				:gsub("%-%-%d+ ","\t%1")
	local tabsBeforeText=""
	local textExchange=""
	for line in (text .. "\n"):gmatch("([^\n]*)\n") do
		if line:match("\t%-%-%d") then
			local numberTabs=0
			for tabs in line:gmatch("\t") do
				numberTabs=numberTabs+1 
			end --for tabs in line:gmatch("\t") do
			tabsBeforeText=string.rep("\t",numberTabs+1)
			textExchange=textExchange .. "\n" .. line
		else
			textExchange=textExchange .. "\n" .. tabsBeforeText .. line
		end --if line:match("\t") then
	end --for (text .. "\n"):gmatch("([^\n]*)\n") do
	textfield1.value=textExchange
end --function button_numbering_as_tabs:flat_action()

--6.3 button for building tree with SQL
button_show_sql_as_tree=iup.flatbutton{title="Das SQL als Baum zeigen", size="115x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_show_sql_as_tree:flat_action()
	tree.delnode0 = "CHILDREN"
	tree.title='brackets tree'
	--example text variable
	text=textfield1.value
	--treat multiple SQL statements with semicolon at the end
	text=text:gsub(";",";)(")
		:gsub(" +$","")
		:gsub(" +\n","\n")
		:gsub("\n+","")
		:gsub(";%)%($",";")
	--read opening and closing brackets and count them and add missing ones
	numberBracketOpen=0
	for bracketOpen in ("(" .. text .. ")"):gmatch("%(") do
		numberBracketOpen= numberBracketOpen+1
	end --for bracketOpen in ("(" .. text .. ")"):gmatch("%(") do
	numberBracketClose=0
	for bracketClose in ("(" .. text .. ")"):gmatch("%)") do
		numberBracketClose = numberBracketClose +1
	end --for bracketClose in ("(" .. text .. ")"):gmatch("%)") do
	if numberBracketOpen>numberBracketClose then
		text=text .. string.rep("~missing~)",numberBracketOpen-numberBracketClose)
	elseif numberBracketOpen<numberBracketClose then
		text=string.rep("(~missing~",numberBracketClose-numberBracketOpen) .. text
	end --if numberBracketOpen>numberBracketClose then
	--build the outputstring for the tree
	outputText=("tree_sql_script={branchname=[====[brackets tree" .. ("(" .. text .. ")"):gsub("%(",']====],\n{branchname=[====[(')
											:gsub("%)",')]====],\n},\n[====[') .. "]====],}")
											:gsub("%[====%[%]====%],","")
	--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
	if _VERSION=='Lua 5.1' then
		loadstring(outputText)()
	else
		load(outputText)() --now actualtree is the table.
	end --if _VERSION=='Lua 5.1' then
	iup.TreeAddNodes(tree,tree_sql_script)
	textfield2.value=outputText
end --function button_show_sql_as_tree:flat_action()

--6.4 button for building tree with Excel formula
button_show_excel_formula_as_tree=iup.flatbutton{title="Die Excel-Formel als Baum zeigen", size="145x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_show_excel_formula_as_tree:flat_action()
	tree.delnode0 = "CHILDREN"
	tree.title='brackets tree'
	--example text variable
	text=textfield1.value
	text=text:gsub("(%u+)%(","(%1~~~") --exchange function words in upper cases and brackets
	--read opening and closing brackets and count them and add missing ones
	numberBracketOpen=0
	for bracketOpen in ("(" .. text .. ")"):gmatch("%(") do
		numberBracketOpen= numberBracketOpen+1
	end --for bracketOpen in ("(" .. text .. ")"):gmatch("%(") do
	numberBracketClose=0
	for bracketClose in ("(" .. text .. ")"):gmatch("%)") do
		numberBracketClose = numberBracketClose +1
	end --for bracketClose in ("(" .. text .. ")"):gmatch("%)") do
	if numberBracketOpen>numberBracketClose then
		text=text .. string.rep("~missing~)",numberBracketOpen-numberBracketClose)
	elseif numberBracketOpen<numberBracketClose then
		text=string.rep("(~missing~",numberBracketClose-numberBracketOpen) .. text
	end --if numberBracketOpen>numberBracketClose then
	--build the outputstring for the tree
	outputText=("tree_excelformula_script={branchname=[====[brackets tree" .. ("(" .. text .. ")"):gsub("%(",']====],\n{branchname=[====[(')
											:gsub("%)",')]====],\n},\n[====[') .. "]====],}")
											:gsub(";",";]====],[====[") --for Excel formulas
											:gsub("%[====%[%]====%],","")
											:gsub("%((%u+)~~~","%1(")
	--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
	if _VERSION=='Lua 5.1' then
		loadstring(outputText)()
	else
		load(outputText)() --now actualtree is the table.
	end --if _VERSION=='Lua 5.1' then
	iup.TreeAddNodes(tree,tree_excelformula_script)
	textfield2.value=outputText
end --function button_show_excel_formula_as_tree:flat_action()

--6.5 button for building tree with text with tabulator
button_show_tabtext_as_tree=iup.flatbutton{title="Text mit Tabulatoren \nals Baum zeigen", size="145x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_show_tabtext_as_tree:flat_action()
	tree.delnode0 = "CHILDREN"
	tree.title='tabulator tree'
	--example text variable
	text=textfield1.value
	--read data from textfield
	outputText='tree_tabtext_script={branchname="tabulator tree"'
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
			local maxLength=59 --must be lower than 259 for a IUP tree
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
	end --for line in io.lines(inputTextFile) do
	--write end curly brackets
	for i=1, pos_curline+1 do
		outputText=outputText .. '\n}'
	end --for i=1, pos_curline+1 do
	outputText=outputText:gsub(",,",",") --correction for '\n{branchname="missing",' when to or more missings
	--test with: print(outputText:match("%b{}"))
	--test with: print(outputText)
	--Lua 5.1 has the function loadstring() - in later versions, this is replaced by load(), hence we detect this here
	if _VERSION=='Lua 5.1' then
		loadstring(outputText)()
	else
		load(outputText)() --now actualtree is the table.
	end --if _VERSION=='Lua 5.1' then
	iup.TreeAddNodes(tree,tree_tabtext_script)
	textfield2.value=outputText
end --function button_show_tabtext_as_tree:flat_action()

--6.6 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nb.kaiser@beckmann-partner.de")
end --function button_logo:flat_action()

--7. Main Dialog

--7.1 input field as scintilla editor
textfield1=iup.scintilla{}
textfield1.SIZE="340x560" --I think this is not optimal! (since the size is so appears to be fixed)
--textfield1.wordwrap="WORD" --enable wordwarp
textfield1.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
textfield1.FONT="Courier New, 8" --font of shown code
textfield1.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
textfield1.KEYWORDS0="SELECT select FROM from ORDER BY order by SORT sort INSERT INTO insert into DELETE delete WENN SUMMEWENN ISTFEHLER" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
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
--example for a SQL statement
textfield1.value="SELECT * FROM (SELECT * FROM (SELECT * FROM TABLE1), (SELECT * FROM TABLE)); \n\nSELECT * FROM (SELECT * FROM (SELECT * FROM TABLE1), (SELECT * FROM TABLE));"
--example for an excel formula
textfield1.value='=WENN(1=1;WENN(2<2;"nie";"immer");WENN(3>2;"immer";"nie"))'
--example for a text with tabulators
textfield1.value='Title\n\tAst\n\t\tBlattTitle\n\tAst\n\t\tBlattTitle\n\tAst\n\t\tBlatt'
--example for a text with comments with numberings
textfield1.value="print('Hallo world')\n-" .. "-1. Title\nprint('Hallo world')\n-" .. "-2.1 Ast\nprint('Hallo world')\n-" .. "-2.1.1 BlattTitle\n-" .. "-2.2 Ast\n-" .. "-2.2.1 BlattTitle\n-" .. "-3. Ast\n-" .. "-3.1 Blatt\n" .. "4 Blatt"

--7.2 output field as scintilla editor
textfield2=iup.scintilla{}
textfield2.SIZE="340x560" --I think this is not optimal! (since the size is so appears to be fixed)
--textfield2.wordwrap="WORD" --enable wordwarp
textfield2.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
textfield2.FONT="Courier New, 8" --font of shown code
textfield2.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
textfield2.KEYWORDS0="SELECT select FROM from ORDER BY order by SORT sort INSERT INTO insert into DELETE delete WENN SUMMEWENN ISTFEHLER" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
textfield2.STYLEFGCOLOR0="0 0 0"      -- 0-Default
textfield2.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
textfield2.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
textfield2.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
textfield2.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
textfield2.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
textfield2.STYLEFGCOLOR6="160 20 180"  -- 6-String 
textfield2.STYLEFGCOLOR7="128 0 0"    -- 7-Character
textfield2.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
textfield2.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
textfield2.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--textfield2.STYLEBOLD10="YES"
--textfield2.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--textfield2.STYLEITALIC10="YES"
textfield2.MARGINWIDTH0="40"

--7.3 display empty SQL tree
actualtree={branchname="SQL"}
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


--7.4 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	--simply show a box with buttons
	iup.vbox{
		--first row of buttons
		iup.hbox{
			button_logo,
			button_numbering_as_tabs,
			iup.label{size="3x"},
			button_show_sql_as_tree,
			button_show_excel_formula_as_tree,
			button_show_tabtext_as_tree,
			iup.fill{},
			button_logo2,
		},
		iup.hbox{
			iup.frame{title="Inputtext",textfield1,},
			iup.frame{title="Text als Baum",tree,},
			iup.frame{title="Outputtext",textfield2,},
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

