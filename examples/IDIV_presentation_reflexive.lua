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
}--TextHTMLtable<!--

----[====[This programm has webpages within the Lua script which can contain a tree in html

--1. basic data

--1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iupluaweb")        --require iupluaweb for webbrowser
--iup.SetGlobal("UTF8MODE","NO")

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

--3.2 function which saves the current iup htmlTexts as a Lua table
function save_html_to_lua(htmlTexts, outputfile_path)
	--read the programm of the file itself, commentSymbol is used to have another pattern here as searched
	inputfile=io.open(path .. "\\" .. thisfilename,"r")
	commentSymbol,inputTextProgramm=inputfile:read("*a"):match("TextHTMLtable={.*}(%-%-)TextHTMLtable<!%-%-(.*)")
	inputfile:close()
	--build the new htmlTexts
	local output_htmlTexts_text="TextHTMLtable={" --the output string
	local outputfile=io.output(outputfile_path) --a output file

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


--4. dialogs
--4.1 rename dialog
--ok button
ok = iup.flatbutton{title = "OK",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function ok:flat_action()
	webbrowser1.HTML= text1.value
	TextHTMLtable[aktuelleSeite]= text1.value
	return iup.CLOSE
end --function ok:flat_action()

--cancel button
cancel = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function cancel:flat_action()
	return iup.CLOSE
end --function cancel:flat_action()

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
end --	function search_in_text:flat_action()

text1 = iup.multiline{size="120x50",border="YES",expand="YES",wordwrap="YES"} --textfield
label1 = iup.label{title="Blattinhalt:"}--label for textfield

--open the dialog for renaming page
dlg_rename = iup.dialog{
	iup.vbox{label1, text1, iup.hbox{ok,search_in_text,cancel}}; 
	title="Seite bearbeiten",
	size="400x350",
	startfocus=text1,
	}

--4.1 rename dialog end

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
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nidiv.kaiser@t-online.de")
end --function button_logo:flat_action()

--6.2 button for saving TextHTMLtable and the programm of the graphical user interface
button_save_lua_table=iup.flatbutton{title="Datei speichern", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	save_html_to_lua(TextHTMLtable, path .. "\\" .. thisfilename)
end --function button_save_lua_table:flat_action()

--6.3 button for going to first page
button_go_to_first_page = iup.flatbutton{title = "Startseite",size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_to_first_page:flat_action()
	webbrowser1.HTML=TextHTMLtable[1]
	aktuelleSeite=1
	textbox1.value=aktuelleSeite
end --function button_go_to_first_page:action()

--6.4 button for going one page back
button_go_back = iup.flatbutton{title = "Eine Seite zurück",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_back:flat_action()
	if aktuelleSeite>1 then aktuelleSeite=aktuelleSeite-1 end
	webbrowser1.HTML=TextHTMLtable[aktuelleSeite]
	textbox1.value=aktuelleSeite
end --function button_go_back:action()

--6.5 button for going to the page and edit the page
button_edit_page = iup.flatbutton{title = "Editieren der Seite:",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_page:flat_action()
	if tonumber(textbox1.value) then
		aktuelleSeite=math.tointeger(tonumber(textbox1.value))
		TextErsatz=TextHTMLtable[aktuelleSeite]
		webbrowser1.HTML=TextErsatz
	else
		TextErsatz=TextHTMLtable[aktuelleSeite]
		webbrowser1.HTML=TextErsatz
	end --if tonumber(textbox1.value) then
	text1.value=TextErsatz
	dlg_rename:popup(iup.CENTER, iup.CENTER) --popup rename dialog
end --function button_edit_page:action()

--6.6 button for going to the page
button_go_to_page = iup.flatbutton{title = "Gehe zu Seite:",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_to_page:flat_action()
	if tonumber(textbox1.value) then
		aktuelleSeite=math.tointeger(tonumber(textbox1.value))
		TextErsatz=TextHTMLtable[aktuelleSeite]
		webbrowser1.HTML=TextErsatz
	else
		aktuelleSeite=textbox1.value
		TextErsatz=TextHTMLtable[aktuelleSeite]
		webbrowser1.HTML=TextErsatz
	end --if tonumber(textbox1.value) then
end --function button_go_to_page:action()

--6.7 button for deleting the page
button_delete = iup.flatbutton{title = "Löschen der Seite",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
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
button_save_as_html=iup.flatbutton{title="Als html speichern", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_as_html:flat_action()
	local outputfile1=io.open(path .. "\\" .. thisfilename:gsub("%.lua$",".html"),"w")
	for k,v in pairs(TextHTMLtable) do
		outputfile1:write(v .. "\n")
	end --for k,v in pairs(TextHTMLtable) do
	outputfile1:close()
end --function button_save_as_html:flat_action()

--6.9 button for search in TextHTMLtable
button_search=iup.flatbutton{title="Suche in Seiten", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
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
end --function button_search:flat_action()


--6.10 button for going to the next page
button_go_forward = iup.flatbutton{title = "Eine Seite vor",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_forward:flat_action()
	if aktuelleSeite<#TextHTMLtable then aktuelleSeite=aktuelleSeite+1 end
	webbrowser1.HTML=TextHTMLtable[aktuelleSeite]
	textbox1.value=aktuelleSeite
end --function button_go_forward:action()

--6.11 button for building new page
button_new_page = iup.flatbutton{title = "Neue Seite",size="45x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_new_page:flat_action()
	aktuelleSeite=#TextHTMLtable+1
	textbox1.value=aktuelleSeite
local newText=[====[<!DOCTYPE html> <head></head><html> <body>
<h1>Neue Seite </h1>

</body></html> ]====]
	webbrowser1.HTML=newText
	TextHTMLtable[aktuelleSeite]= newText
end --function button_new_page:action()

--6.12 button for fullscreen
button_fullscreen_yes = iup.flatbutton{title = "Vollbildschirm",size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_fullscreen_yes:flat_action()
	maindlg.fullscreen="YES"
	maindlg.background="255 255 255"
	button_fullscreen_yes.BGCOLOR="255 255 255"
	button_save_lua_table.BGCOLOR="255 255 255"
	button_go_to_first_page.BGCOLOR="255 255 255"
	button_go_back.BGCOLOR="255 255 255"
	button_edit_page.BGCOLOR="255 255 255"
	button_go_to_page.BGCOLOR="255 255 255"
	button_delete.BGCOLOR="255 255 255"
	button_no_button.BGCOLOR="255 255 255"
	textbox1.FGCOLOR="255 255 255"
	textbox2.FGCOLOR="255 255 255"
	button_fullscreen_no.BGCOLOR="255 255 255"
	button_save_as_html.BGCOLOR="255 255 255"
	button_search.BGCOLOR="255 255 255"
	button_go_forward.BGCOLOR="255 255 255"
	button_new_page.BGCOLOR="255 255 255"
	button_fullscreen_yes.BGCOLOR="255 255 255"
	webbrowser1.zoom="105"
end --function button_fullscreen_yes:action()

--6.13 button for fullscreen
button_no_button = iup.flatbutton{title = "Ohne Schaltflächen",size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_no_button:flat_action()
	maindlg.fullscreen="NO"
	maindlg.background="255 255 255"
	button_fullscreen_yes.BGCOLOR="255 255 255"
	button_save_lua_table.BGCOLOR="255 255 255"
	button_go_to_first_page.BGCOLOR="255 255 255"
	button_go_back.BGCOLOR="255 255 255"
	button_edit_page.BGCOLOR="255 255 255"
	button_go_to_page.BGCOLOR="255 255 255"
	button_delete.BGCOLOR="255 255 255"
	button_no_button.BGCOLOR="255 255 255"
	textbox1.FGCOLOR="255 255 255"
	textbox2.FGCOLOR="255 255 255"
	button_fullscreen_no.BGCOLOR="255 255 255"
	button_save_as_html.BGCOLOR="255 255 255"
	button_search.BGCOLOR="255 255 255"
	button_go_forward.BGCOLOR="255 255 255"
	button_new_page.BGCOLOR="255 255 255"
	button_fullscreen_yes.BGCOLOR="255 255 255"
	webbrowser1.zoom="105"
end --function button_no_button:action()

--6.14 button for normal screen
button_fullscreen_no = iup.flatbutton{title = "Normalbildschirm",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_fullscreen_no:flat_action()
	maindlg.fullscreen="NO"
	maindlg.background="240 240 240"
	maindlg.title = path .. " Documentation Tree"
	button_fullscreen_yes.BGCOLOR=color_buttons
	button_save_lua_table.BGCOLOR=color_buttons
	button_go_to_first_page.BGCOLOR=color_buttons
	button_go_back.BGCOLOR=color_buttons
	button_edit_page.BGCOLOR=color_buttons
	button_go_to_page.BGCOLOR=color_buttons
	button_delete.BGCOLOR=color_buttons
	button_no_button.BGCOLOR=color_buttons
	textbox1.FGCOLOR=color_buttons
	textbox2.FGCOLOR=color_buttons
	button_fullscreen_no.BGCOLOR=color_buttons
	button_save_as_html.BGCOLOR=color_buttons
	button_search.BGCOLOR=color_buttons
	button_go_forward.BGCOLOR=color_buttons
	button_new_page.BGCOLOR=color_buttons
	button_fullscreen_yes.BGCOLOR=color_buttons
	webbrowser1.zoom="80"
end --function button_fullscreen_no:flat_action()

--6.15 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nidiv.kaiser@t-online.de")
end --function button_logo:flat_action()

--7 Main Dialog

--7.1 textboxes
textbox1 = iup.text{value="1",size="20x20",WORDWRAP="NO",alignment="ACENTER",border="NO",}
textbox2 = iup.text{value="",size="90x20",WORDWRAP="NO",border="NO",}

--7.2 webbrowser
webbrowser1=iup.webbrowser{HTML=TextHTMLtable[1]}
function webbrowser1:navigate_cb(url)
	--test with: iup.Message("",url) 
	if url:match("file///") then --only url with https:// or http// ar loaded
		os.execute('start "D" "' .. url:match("file///(.*)") .. '"')
	end --if url:match("file///") then
end --function webbrowser1:navigate_cb()

--7.3 building the dialog and put buttons, trees and other elements together
maindlg = iup.dialog {
	iup.vbox{
		iup.hbox{
			button_logo,
			button_save_lua_table,
			button_go_to_first_page,
			button_go_back,
			button_edit_page,
			button_go_to_page,
			textbox1,
			button_delete,
			button_fullscreen_no,
			button_no_button,
			iup.fill{},
			button_save_as_html,
			button_search,
			textbox2,
			button_go_forward,
			button_new_page,
			button_fullscreen_yes,
			button_logo2,
		}, --iup.hbox{
		iup.hbox{webbrowser1,},
	}, --iup.vbox{
	icon = img_logo,
	title = path .. " Documentation Tree",
	size="FULLxFULL" ;
	gap="3",
	alignment="ARIGHT",
	margin="5x5" 
}--maindlg = iup.dialog {

--7.1 show the dialog
maindlg:showxy(iup.CENTER,iup.CENTER) 

--7.1.1 zoom the webbrowser
webbrowser1.zoom="80"

--7.1.2 optional show properties of element
--iup.Show(iup.ElementPropertiesDialog(textbox1,textbox1))

--7.2 Main Loop
if (iup.MainLoopLevel()==0) then iup.MainLoop() end

--]====]
