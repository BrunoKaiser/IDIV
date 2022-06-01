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

--1.2.2 Beckmann und Partner colors
color_red_bpc="135 31 28"
color_light_color_grey_bpc="196 197 199"
color_grey_bpc="162 163 165"
color_blue_bpc="18 32 86"

--1.2.3 color definitions
color_background=color_light_color_grey_bpc
color_buttons=color_blue_bpc -- works only for flat buttons, "18 32 86" is the blue of BPC
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
  ; colors = { color_grey_bpc, color_light_color_grey_bpc, color_blue_bpc, "255 255 255" }
}
button_logo=iup.button{image=img_logo,title="", size="23x20"}
function button_logo:action()
	iup.Message("Beckmann & Partner CONSULT","BERATUNGSMANUFAKTUR\nMeisenstraße 79\n33607 Bielefeld\nDr. Bruno Kaiser\nLizenz Open Source")
end --function button_logo:flat_action()

--6.2 button for loading text file 1
button_loading_first_text_file=iup.flatbutton{title="Erste Textdatei laden", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_loading_first_text_file:flat_action()
	local inputfile1
	if file_exists(textbox1.value) then
		inputfile1=io.open(textbox1.value,"r")
		textfield1.value=inputfile1:read("*all")
		inputfile1:close()
	else
		--build file dialog for reading text file
		local filedlg=iup.filedlg{dialogtype="OPEN",title="Datei öffnen",filter="*.*",filterinfo="Text Files",directory=path}
		filedlg:popup(iup.ANYWHERE,iup.ANYWHERE) --show the file dialog
		if filedlg.status=="1" then
			iup.Message("Neue Datei",filedlg.value)
		elseif filedlg.status=="0" then --this is the usual case, when a file was choosen
			textbox1.value=filedlg.value
			inputfile1=io.open(filedlg.value,"r")
			textfield1.value=inputfile1:read("*all")
			inputfile1:close()
		else
			iup.Message("Die Baumansicht wird nicht aktualisiert","Es wurde keine Datei ausgewählt")
			iup.NextField(maindlg)
		end --if filedlg.status=="1" then
	end --if file_exists(textbox1.value) then
end --function button_loading_first_text_file:flat_action()

--6.2.1 button for loading text file 1
button_scripter_first_text_file=iup.flatbutton{title="Skripter mit erster \nTextdatei starten", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_scripter_first_text_file:flat_action()
	--read first line of file. If it is empty then scripter cannot open it. So open file with notepad.exe
	if file_exists(textbox1.value) then inputfile=io.open(textbox1.value,"r") ErsteZeile=inputfile:read() inputfile:close() end
	if file_exists(textbox1.value) and ErsteZeile then
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. textbox1.value .. '"')
	elseif file_exists(textbox1.value) then
		os.execute('start "d" notepad.exe "' .. textbox1.value .. '"')
	else
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe ')
	end --if file_exists(textbox1.value) and ErsteZeile then
end --function button_scripter_first_text_file:flat_action()

--6.3 button for loading text file 2
button_loading_second_text_file=iup.flatbutton{title="Zweite Textdatei laden", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_loading_second_text_file:flat_action()
	local inputfile2
	if file_exists(textbox2.value) then
		inputfile1=io.open(textbox2.value,"r")
		textfield2.value=inputfile1:read("*all")
		inputfile1:close()
	else
		--build file dialog for reading text file
		local filedlg=iup.filedlg{dialogtype="OPEN",title="Datei öffnen",filter="*.*",filterinfo="Text Files",directory=path}
		filedlg:popup(iup.ANYWHERE,iup.ANYWHERE) --show the file dialog
		if filedlg.status=="1" then
			iup.Message("Neue Datei",filedlg.value)
		elseif filedlg.status=="0" then --this is the usual case, when a file was choosen
			textbox2.value=filedlg.value
			inputfile2=io.open(filedlg.value,"r")
			textfield2.value=inputfile2:read("*all")
			inputfile2:close()
		else
			iup.Message("Die Baumansicht wird nicht aktualisiert","Es wurde keine Datei ausgewählt")
			iup.NextField(maindlg)
		end --if filedlg.status=="1" then
	end --if file_exists(textbox2.value) then
end --function button_loading_second_text_file:flat_action()

--6.3.1 button for loading text file 2
button_scripter_second_text_file=iup.flatbutton{title="Skripter mit zweiter \nTextdatei starten", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_scripter_second_text_file:flat_action()
	--read first line of file. If it is empty then scripter cannot open it. So open file with notepad.exe
	if file_exists(textbox2.value) then inputfile=io.open(textbox2.value,"r") ErsteZeile=inputfile:read() inputfile:close() end
	if file_exists(textbox2.value) and ErsteZeile then
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. textbox2.value .. '"')
	elseif file_exists(textbox2.value) then
		os.execute('start "d" notepad.exe "' .. textbox2.value .. '"')
	else
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe ')
	end --if file_exists(textbox2.value) and ErsteZeile then
end --function button_scripter_second_text_file:flat_action()

--6.3.2 button for loading all text files without versions in IUP Lua scripter found in first directory and subdirectories containing the search text
button_scripter_loading_text_files_with_search=iup.flatbutton{title="Skripter mit maximal x Textdateien im \nersten Ordner mit Suchergebnissen laden", size="150x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_scripter_loading_text_files_with_search:flat_action()
	local directoryText
	clipboard.text=textbox3.value
	if textbox1.value:match("^.:\\") and textbox1.value:match("%.")==nil and textbox1.value:match("\\$")==nil then --directory without dot and without backslash at the end
		directoryText=textbox1.value:match("(.*)")
	elseif textbox1.value:match("^.:\\.*\\") then
		directoryText=textbox1.value:match("(.*)\\")
	end --if textbox1.value:match("^.:\\") then
	if directoryText~=nil and textbox3.value~="" then
		searchAlarm=iup.Alarm("Wollen Sie die Suche der Dateien in folgendem Verzeichnis?",tostring(directoryText),"        Ja, bitte Suchen        ","        Nicht Suchen        ")
		if searchAlarm==1 then
			local fileFound=""
			local numberFileFound=0
			p=io.popen('dir ' .. directoryText .. ' /b/o/s ')
			for fileText in p:lines() do
				 --do not scan versions and archived files, lnk, js, sh, bat, office files and files with blanks
				if fileText:match("%.js")==nil
				and fileText:match(" ")==nil
				and fileText:match("%.lnk")==nil
				and fileText:match("%.bat")==nil
				and fileText:match("%.sh")==nil
				and fileText:match("%.html")==nil
				and fileText:match("%.doc")==nil
				and fileText:match("%.xls")==nil
				and fileText:match("%.ppt")==nil
				and fileText:match("%.accdb")==nil
				and fileText:match("_Version(%d+)")==nil
				and fileText:match("%d%d%d%d%d%d%d%d")==nil
				and fileText:match("%(")==nil
				and fileText:match("%)")==nil
				then
					local inputfile2=io.open(fileText,"r")
					if inputfile2 then --open if it is a file, for directory inputfile2 is nil
						inputText2=inputfile2:read("*all")
						inputfile2:close()
						if checkboxforcasesensitive.value=="OFF"  then
							if inputText2:lower():match(textbox3.value:lower()) and numberFileFound <math.tointeger(tonumber(textbox4.value)) then
								fileFound=fileFound .. " " .. fileText
								numberFileFound=numberFileFound+1
							elseif inputText2:lower():match(textbox3.value:lower()) and numberFileFound >=math.tointeger(tonumber(textbox4.value)) then
								numberFileFound=numberFileFound+1
							end --if inputText2:lower():match(textbox3.value:lower()) then
						else
							if inputText2:match(textbox3.value) and numberFileFound <math.tointeger(tonumber(textbox4.value)) then
								fileFound=fileFound .. " " .. fileText
								numberFileFound=numberFileFound+1
							elseif inputText2:match(textbox3.value) and numberFileFound >=math.tointeger(tonumber(textbox4.value)) then
								numberFileFound=numberFileFound+1
							end --if inputText2:lower():match(textbox3.value:lower()) then
						end --if checkboxforcasesensitive.value=="ON"  then
					end --if inputfile2 then
				end --if fileText:match("_Version(%d+)")==nil then
			end --for fileText in p:lines() do
			iup.Message("Fundstellen in " .. numberFileFound .. " Dateien mit den ersten " .. math.tointeger(tonumber(textbox4.value)) .. " Dateien:",fileFound:gsub(" ","\n"))
			if numberFileFound>0 then
				os.execute('start "d" C:\\Lua\\iupluascripter54.exe ' .. fileFound .. " ")
			end --if numberFileFound>0 then
		else
			iup.Message("Keine Suche","Es wird nicht gesucht.")
		end --if searchAlarm==1 then
	end --if directoryText~=nil then
end --function button_scripter_loading_text_files_with_search:flat_action()

--6.4 button for expand and collapse
button_expand_collapse_dialog=iup.flatbutton{title="Ein-/\nAusklappen", size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_expand_collapse_dialog:flat_action()
	text_expand_collapse.value=tree.title
	dlg_expand_collapse:popup(iup.ANYWHERE, iup.ANYWHERE)
end --function button_expand_collapse_dialog:flat_action()

--6.5.1 button for filtering the two texts to be compared on filtered lines
button_filter=iup.flatbutton{title="Texte \nfiltern", size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_filter:flat_action()
	local textSubsitute=""
	for line in (textfield1.value .. "\n"):gmatch("([^\n]*)\n") do
		if line:match(textbox3.value) then
			textSubsitute=textSubsitute .. line .. "\n"
		end --if line:match(textbox3.value) then
	end --for line in (textbox3.value .. "\n"):gmatch("([^\n]*)\n") do
	textfield1.value=textSubsitute
	textSubsitute=""
	for line in (textfield2.value .. "\n"):gmatch("([^\n]*)\n") do
		if line:match(textbox3.value) then
			textSubsitute=textSubsitute .. line .. "\n"
		end --if line:match(textbox3.value) then
	end --for line in (textbox3.value .. "\n"):gmatch("([^\n]*)\n") do
	textfield2.value=textSubsitute
end --function button_filter:flat_action()

--6.5.2 button for filtering negatively the two texts to be compared on filtered lines
button_filter_negatively=iup.flatbutton{title="Texte negativ\nfiltern", size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_filter_negatively:flat_action()
	local textSubsitute=""
	for line in (textfield1.value .. "\n"):gmatch("([^\n]*)\n") do
		if line:match(textbox3.value)==nil then
			textSubsitute=textSubsitute .. line .. "\n"
		end --if line:match(textbox3.value)==nil then
	end --for line in (textbox3.value .. "\n"):gmatch("([^\n]*)\n") do
	textfield1.value=textSubsitute
	textSubsitute=""
	for line in (textfield2.value .. "\n"):gmatch("([^\n]*)\n") do
		if line:match(textbox3.value)==nil then
			textSubsitute=textSubsitute .. line .. "\n"
		end --if line:match(textbox3.value)==nil then
	end --for line in (textbox3.value .. "\n"):gmatch("([^\n]*)\n") do
	textfield2.value=textSubsitute
end --function button_filter_negatively:flat_action()


--6.6 button for comparing text file of tree and text file of tree2
button_compare=iup.flatbutton{title="Textdateien \nvergleichen", size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_compare:flat_action()
	tree.delnode0 = "CHILDREN"
	tree.title='compare'
	--make the comparison
	--go through text file 2
	tree_script={branchname="compare",{branchname="Vergleich von " .. tostring(textbox1.value) .. " mit " .. tostring(textbox2.value)}}
	local file2existsTable={}
	local file2numberTable={}
	for line in (textfield2.value .. "\n"):gmatch("([^\n]*)\n") do
		file2numberTable[#file2numberTable+1]=line
		file2existsTable[line]=#file2numberTable
	end --for line in (textfield2.value .. "\n"):gmatch("([^\n]*)\n") do
	--go through text file 1
	local lineNumber=0
	local file1existsTable={}
	for line in (textfield1.value .. "\n"):gmatch("([^\n]*)\n") do
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
	end --for line in (textfield1.value .. "\n"):gmatch("([^\n]*)\n") do
	--go through text file 1 to search for missing lines in text file 2
	local line1Number=0
	for line in (textfield1.value .. "\n"):gmatch("([^\n]*)\n") do
		line1Number=line1Number+1
		if file2existsTable[line]==nil then
			if tree_script[#tree_script].branchname=="nur in erster Datei" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line1Number .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="nur in erster Datei"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line1Number .. ": " .. line
			end --if tree_script[#tree_script].branchname=="nur in erster Datei" then
		end --if file2existsTable[line] then
	end --for line in (textfield1.value .. "\n"):gmatch("([^\n]*)\n") do
	--go through text file 2 to search for missing lines in text file 1
	local line2Number=0
	for line in (textfield2.value .. "\n"):gmatch("([^\n]*)\n") do
		line2Number=line2Number+1
		if file1existsTable[line]==nil then
			if tree_script[#tree_script].branchname=="nur in zweiter Datei" then
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line2Number .. ": " .. line
			else
				tree_script[#tree_script+1]={branchname="nur in zweiter Datei"}
				tree_script[#tree_script][#tree_script[#tree_script]+1]=line2Number .. ": " .. line
			end --if tree_script[#tree_script].branchname=="nur in zweiter Datei" then
		end --if file1existsTable[line] then
	end --for line in (textfield2.value .. "\n"):gmatch("([^\n]*)\n") do
	--build the compare tree
	iup.TreeAddNodes(tree,tree_script)
end --function button_compare:flat_action()

--6.7 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Beckmann & Partner CONSULT","BERATUNGSMANUFAKTUR\nMeisenstraße 79\n33607 Bielefeld\nDr. Bruno Kaiser\nLizenz Open Source")
end --function button_logo:flat_action()

--6 buttons end


--7 Main Dialog
--7.1 textboxes
textbox1 = iup.multiline{value="",size="320x20",WORDWRAP="YES"}
textbox2 = iup.multiline{value="",size="320x20",WORDWRAP="YES"}
textbox3 = iup.multiline{value="",size="220x20",WORDWRAP="YES"}
textbox4 = iup.text{value="12",size="30x20"}

--7.1.1 checkboxes
checkboxforcasesensitive = iup.toggle{title="Groß-/\nKleinschreibung", value="OFF"} --checkbox for casesensitiv search

--7.2 display empty compare tree
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

--7.3.1 text file field as scintilla editor 1
textfield1=iup.scintilla{}
textfield1.SIZE="280x530" --I think this is not optimal! (since the size is so appears to be fixed)
--textfield1.wordwrap="WORD" --enable wordwarp
textfield1.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
textfield1.FONT="Courier New, 8" --font of shown code
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

--7.3.2 text file field as scintilla editor 2
textfield2=iup.scintilla{}
textfield2.SIZE="280x530" --I think this is not optimal! (since the size is so appears to be fixed)
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


--7.4 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog{
	--simply show a box with buttons
	iup.vbox{
		--first row of buttons
		iup.hbox{
			button_logo,
			button_loading_first_text_file,
			button_scripter_first_text_file,
			iup.label{size="5x",},
			button_loading_second_text_file,
			button_scripter_second_text_file,
			iup.label{size="5x",},
			button_scripter_loading_text_files_with_search,
			textbox3,
			checkboxforcasesensitive,
			iup.label{title="x: "},
			textbox4,
			iup.fill{},
			button_filter,
			button_filter_negatively,
			button_compare,
			iup.label{size="5x",},
			button_expand_collapse_dialog,
			iup.label{size="5x",},
			button_logo2,
		},
		
		iup.hbox{
			iup.frame{title="Erste Textdatei",iup.vbox{textbox1,textfield1,},},
			iup.frame{title="Zweite Textdatei",iup.vbox{textbox2,textfield2,},},
			iup.frame{title="Manuelle Zuordnung als Baum",tree,},
			},

	},

	icon = img_logo,
	title = path .. " Documentation Tree",
	SIZE = 'FULLxFULL',
	BACKGROUND=color_background
}


--7.5 show the dialog
maindlg:show()

--7.6 Main Loop
if (iup.MainLoopLevel()==0) then
	iup.MainLoop()
end --if (iup.MainLoopLevel()==0) then
