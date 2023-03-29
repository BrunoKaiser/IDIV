
--1. basic data

--1.1 libraries and clipboard
--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iuplua_scintilla") --for Scintilla-editor


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


--3. functions
--3.1 function checking if file exits
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end --function file_exists(name)


--3.2 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)


--6 buttons
--6.1 logo image definition and button wiht logo 
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
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,1,3,1,3,1,3,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,3,3,1,3,1,3,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,1,1,4,4,4,4,4,4,4,1,1,3,3,1,3,1,1,1,1,1,1,1,4,4,4 }, 
  { 4,1,1,1,1,1,1,1,1,4,4,4,4,4,3,3,4,4,4,4,1,3,3,1,1,1,1,1,1,1,4,4,4,4 },
  { 4,1,1,1,1,1,1,1,4,4,4,4,3,3,3,3,3,3,4,4,4,3,1,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,4,4,4,4,4,3,3,3,3,3,3,3,3,3,4,3,4,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,1,1,1,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,1,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,1,1,4,4,4 }, 
  { 4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,3,3,1,4,4,4 }, 
  { 4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4 }, 
  { 4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4 },  
  { 4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,3 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,3,4 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,4,4 },  
  { 3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,4,4,4,4,4 },  
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4 }  
  ; colors = { color_grey, color_light_color_grey, color_blue, "255 255 255" }
}
button_logo=iup.button{image=img_logo,title="", size="23x20"}
function button_logo:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nidiv.kaiser@t-online.de")
end --function button_logo:flat_action()

--6.2 button to produce power bi info tree
button_powerbiinfo_tree=iup.flatbutton{title="Power BI\nInfo", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_powerbiinfo_tree:flat_action()
	if textfield1.value:match("_PBI_Info.txt$") then
		--This script builds a tree from the infos of a power BI file
		--2. read input file and put lines together to standardize it 
		inputText=textfield2.value
		inputText=inputText:gsub(",[ \t]*\n",", ")
					:gsub("let *\n","let ")
					:gsub("%( *\n","( ")
					:gsub("%) *\n",") ")
					:gsub("{ *\n","{ ")
					:gsub("\n *}"," }")
					:gsub("} *\n","} ")
					:gsub("= *\n","= ")
					:gsub(" +"," ")
					:gsub("\n ","\n")
					:gsub(" \n","\n")
					:gsub("\n *else"," else")
					:gsub("shared ","shared\n")

		--test with: outputFile=io.open("C:\\Temp\\logic.txt","w") outputFile:write(inputText) outputFile:close()

		--2.1 open output file for the tree
		outputFile=io.open("C:\\Temp\\test.lua","w")

		--3. put informations about input data and tables in power bi in a Lua table
		InputTable={}
		for line in inputText:gmatch("([^\n]*)\n") do
			line=line:gsub(", %[CreateNavigationProperties=true%]","")
			if line:match(" *= *.*Pdf.Tables%(File.Contents") then
				if InputTable[string.escape_forbidden_char(line:match('Pdf.Tables%(File.Contents%("([^%)]*)"%)'))] then
					table.insert(InputTable[string.escape_forbidden_char(line:match('Pdf.Tables%(File.Contents%("([^%)]*)"%)'))], line:match('Id="([^"]*)"'))
				else
					InputTable[string.escape_forbidden_char(line:match('Pdf.Tables%(File.Contents%("([^%)]*)"%)'))]={line:match('Id="([^"]*)"')}
				end --if InputTable[string.escape_forbidden_char(line:match('Pdf.Tables%(File.Contents%("([^%)]*)"%)'))] then
			elseif line:match(" *= *.*File.Contents") then
				--test with: print(line)
				--test with: print(line:match("[^=]*="))
				if line:match('Item="([^"]*)"') then infoTable=line:match('Item="([^"]*)"') else infoTable="" end
				if line:match("Table.Combine%(([^%)]*)%)") then
					--test with: print(line:match("Table.Combine%(([^%)]*)%)"):gsub('{[^,]*,','{branchname="' .. line:match("([^=]*)=") .. ',' ):gsub(', *','", "'):gsub('}','",},'))
					addTables=line:match("Table.Combine%(([^%)]*)%)"):gsub('{[^,]*,',' mit: ' ):gsub(',','~' )
				else
					addTables=""
				end --if line:match("Table.Combine%([^%)]*%)") then
				--test with: print('{branchname="' .. string.escape_forbidden_char(line:match('File.Contents%("([^%)]*)"%)')) .. '",')
				--test with: print(line:match('Item="([^"]*)"'))
				if InputTable[string.escape_forbidden_char(line:match('File.Contents%("([^%)]*)"%)'))] then
					table.insert(InputTable[string.escape_forbidden_char(line:match('File.Contents%("([^%)]*)"%)'))], line:match("[^=]*=") .. infoTable .. addTables)
				else
					InputTable[string.escape_forbidden_char(line:match('File.Contents%("([^%)]*)"%)'))]={ line:match("[^=]*=") .. infoTable .. addTables}
				end --if InputTable[string.escape_forbidden_char(line:match('File.Contents%("([^%)]*)"%)'))] then
			elseif line:match(" *= *.*Web.Contents") then
				if InputTable[string.escape_forbidden_char(line:match('Web.Contents%("([^%)]*)"%)'))] then
					table.insert(InputTable[string.escape_forbidden_char(line:match('Web.Contents%("([^%)]*)"%)'))], line:match('Item="([^"]*)"'))
				else
					InputTable[string.escape_forbidden_char(line:match('Web.Contents%("([^%)]*)"%)'))]={line:match('Item="([^"]*)"')}
				end --if InputTable[string.escape_forbidden_char(line:match('Web.Contents%("([^%)]*)"%)'))] then
			elseif line:match(" *= *.*Web.BrowserContents") then
				if InputTable[string.escape_forbidden_char(line:match('Web.BrowserContents%("([^%)]*)"%)'))] then
					table.insert(InputTable[string.escape_forbidden_char(line:match('Web.BrowserContents%("([^%)]*)"%)'))], line:match('Item="([^"]*)"'))
				else
					InputTable[string.escape_forbidden_char(line:match('Web.BrowserContents%("([^%)]*)"%)'))]={line:match('Item="([^"]*)"')}
				end --if InputTable[string.escape_forbidden_char(line:match('File.BrowserContents%("([^%)]*)"%)'))] then
			elseif line:match("let") then
				local textContent=string.escape_forbidden_char(line:match("let(.*)")):gsub("^ ",""):gsub(" $",""):gsub(" in$","")
				if InputTable[string.escape_forbidden_char(line:match("(.*) *= *let")):gsub(" $","")] then
					table.insert(InputTable[string.escape_forbidden_char(line:match("(.*) *= *let")):gsub(" $","")], textContent)
				else
					InputTable[string.escape_forbidden_char(line:match("(.*) *= *let")):gsub(" $","")]={textContent}
				end --if InputTable[string.escape_forbidden_char(line:match("(.*) *= *let")):gsub(" $","")] then
			end --if line:match(" *= *.*File.Contents") then
		end --for line in inputText:gmatch("([^\n]*)\n") do

		--3.1 sort the Lua table
		InputsortedTable={}
		for k,v in pairs(InputTable) do
			table.insert(InputsortedTable,k)
		end --for k,v in pairs(InputTable) do
		table.sort(InputsortedTable, function(a,b) return a<b end)

		--4. write the tree text file
		outputFile:write('Tree_PowerBI={branchname="' .. string.escape_forbidden_char(textfield1.value:gsub("_PBI_Info.txt",".pbix")) .. '",\n')
		for k,v in pairs(InputsortedTable) do
			outputFile:write('{branchname="' .. v .. '",\n')
			table.sort(InputTable[v], function(a,b) return tostring(a)<tostring(b) end)
			for k1,v1 in pairs(InputTable[v]) do
				v1 = string.escape_forbidden_char(v1):gsub("mit:",'",{branchname="mit:", "'):gsub('}', '"},"'):gsub('~', '","')
				outputFile:write('"' .. v1 .. '",\n') 
			end --for k1,v1 in pairs(InputTable) do
			outputFile:write('},\n')
		end --for k,v in pairs(InputTable) do 
		outputFile:write('}\n')
		outputFile:close()
		--add tree after deleting
		tree.delnode = "CHILDREN"
		dofile("C:\\Temp\\test.lua")
		iup.TreeAddNodes(tree,Tree_PowerBI)
	end --if textfield1.value:match("_PBI_Info.txt$") then
end --function button_powerbiinfo_tree:flat_action()


--6.3 button to produce power bi dax formulae tree
button_powerbidaxformulae_tree=iup.flatbutton{title="Power BI\nDAX-Formeln", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_powerbidaxformulae_tree:flat_action()
	if textfield1.value:match("_PBI_DAX_Formeln.txt$") then
		--This script writes the informations of new tables, new columns and measures in DAX in power bi in a tree.
		inputText=textfield2.value
		--
		--2.1 open output file for the tree
		outputFile=io.open("C:\\Temp\\test.lua","w")
		--
		outputFile:write('tree_DAX={branchname="' .. string.escape_forbidden_char(textfield1.value:gsub("_PBI_DAX_Formeln.txt",".pbix")) .. '",\n{branchname="DAX-Formeln",')
		variableLineNumber=0
		for line in inputText:gmatch("([^\n]*)\n") do
			if line:match("^[^ =%[]* *=") and line:match("^VAR ")== nil then
				variableLineNumber=variableLineNumber+1
				if variableLineNumber==1 then
					outputFile:write('\n')
				else
					outputFile:write('},\n')
				end --if variableLineNumber>1 then 
				outputFile:write('{branchname="' .. line:match("^([^ =%[]*) *=") .. '",\n')
				if line:match("^[^ =%[]* *=(.*)"):gsub(" *","")~="" then
					outputFile:write('"' .. string.escape_forbidden_char(line:match("^[^ =%[]* *=(.*)")) .. '",')
				end --if line:match("^[^ =%[]* *=(.*)"):gsub(" *","")~="" then
			else
				if line:gsub(" *","")~="" then
					outputFile:write('"' .. string.escape_forbidden_char(line) .. '",\n')
				end --if line:gsub(" *","")~="" then
			end --if line:match("^[^ =%[]* *=") and line:match("^VAR ")== nil then
		end --for line in inputText:gmatch("([^\n]*)\n") do
		outputFile:write('},\n')
		outputFile:write('},\n')
		outputFile:write('}\n')
		outputFile:close()

		--4. execute the tree in a Lua table
		dofile("C:\\Temp\\test.lua")

		--5. read recursive the tree as Lua table and build dependencies of formulae to dataset
		outputFile=io.open("C:\\Temp\\test.lua","a")
		outputFile:write('tree_DAX_datasets_measures={branchname="Datasets und abhängige berechnete Spalten und Measures",\n')

		formulaeTable={}
		function searchDAXTableRecursive(TreeTable)
			for i,v in ipairs(TreeTable) do
				if type(v)=="table" then
					searchDAXTableRecursive(v)
				else
					if v:match("'[^']*'") then
						--test with: print(i,v:match("'([^']*)'"))
						if formulaeTable[v:match("'([^']*)'")] then
							formulaeTable[v:match("'([^']*)'")][TreeTable.branchname]=true
						else
							formulaeTable[v:match("'([^']*)'")] = {[TreeTable.branchname]=true}
						end --if formulaeTable[v:match("'([^']*)'")] then
						--test with: print(TreeTable.branchname)
					end --if v:match("'[^']*'") then
				end --if type(v)=="table" then
			end --for i,v in ipairs(TreeTable) do
		end --function searchDAXTableRecursive(TreeTable)
		searchDAXTableRecursive(tree_DAX)

		--6. build sorted table of formulae
		formulaeSortedTable={}
		for k,v in pairs(formulaeTable) do
			--test with: print(k,v)
			formulaeSortedTable[k]={}
			for k1,v1 in pairs(v) do
				--test with: print(k1,v1)
				table.insert(formulaeSortedTable[k],k1)
				table.sort(formulaeSortedTable[k],function (a,b) return a<b end)
			end --for k1,v1 in pairs(v) do
		end --for k,v in pairs(formulaeTable) do

		--7. build tree for dependencies of formulae from datasets
		for k,v in pairs(formulaeSortedTable) do
			--test with: print(k,v)
			outputFile:write('{branchname="' .. k .. '",\n')
			for k1,v1 in pairs(v) do
				--test with: print(k1,v1)
				outputFile:write('"' .. v1 .. '",\n')
			end --for k1,v1 in pairs(v) do
			outputFile:write('},\n')
		end --for k,v in pairs(formulaeTable) do

		--8. close output file
		outputFile:write('}\n')
		outputFile:close()

		--add tree after deleting
		tree.delnode = "CHILDREN"
		dofile("C:\\Temp\\test.lua")
		tree_DAX_formulae={branchname="DAX Formeln",tree_DAX,tree_DAX_datasets_measures}
		iup.TreeAddNodes(tree,tree_DAX_formulae)
	end --if textfield1.value:match("_PBI_DAX_Formeln.txt$") then
end --function button_powerbidaxformulae_tree:flat_action()


--7 Main Dialog
--7.1 load tree from file (this ensures that tree and tree2 are compared contentwise)
actualtree={branchname="Output"}
tree=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree)
end, --function(self)
SIZE="400x200",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}
--set the background color of the tree
tree.BGCOLOR=color_background_tree


--7.2 drag & drop text area branch
textfield1 = iup.text{value="",size="245x20", dragdrop = "Yes"}
textfield1.tip = "Drop files here to build a branch"
--callback to add branch with drag & drop         
function textfield1:dropfiles_cb(filename)
	textfield1.value=tostring(filename)
	if file_exists(textfield1.value) then
	print(textfield1.value)
		inputfile1=io.open(textfield1.value,"r")
		textfield2.value=inputfile1:read("*a")
		inputfile1:close()
	end --if file_exists(textfield1.value) then
end --function textfield1:dropfiles_cb(filename)

--7.3 preview field as scintilla editor
textfield2=iup.scintilla{}
textfield2.SIZE="245x520" --I think this is not optimal! (since the size is so appears to be fixed)
--textfield2.wordwrap="WORD" --enable wordwarp
textfield2.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
textfield2.FONT="Courier New, 8" --font of shown code
textfield2.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
textfield2.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
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



--7.5 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	iup.hbox{
		iup.vbox{
			iup.hbox{button_logo, button_powerbiinfo_tree,button_powerbidaxformulae_tree,},
			iup.frame{title = "Vorschau:",
				iup.vbox{ -- use it to inherit margins
					textfield1,
					textfield2,
					}, --iup.hbox{
			}, --iup.frame{title = "Command:",
		}, --iup.vbox{
		iup.vbox{
			iup.frame{title = "Output:",
				iup.hbox{ -- use it to inherit margins
					--output,
					tree,
				}, --iup.hbox{
			}, --iup.frame{title = "Input:",
		}, --iup.vbox{
	}, --iup.vbox{
	title="Lua Console", 
	size="800xFULL", -- initial size
	icon=img_logo, -- 0 use the Lua icon from the executable in Windows
} --iup.maindlg{

--7.4 show the dialog
maindlg:showxy(iup.RIGHT,iup.CENTER)
iup.SetFocus(textfield1)

--7.7 Main Loop
if (iup.MainLoopLevel() == 0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel() == 0) then
