TextHTMLTabelle={
[====[<!DOCTYPE html> <head></head><html><body><table border="0">
<tr><td><b>Inhaltsverzeichnis&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td><td><p align="right">1</p></td></tr>
<tr><td>Reflexives Buchherstellungsprogramm mit Baumansicht-Inhaltsverzeichnis</td><td> <p align="right">2</p></td></tr>
<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;1. Einleitung </td><td> <p align="right">2</p></td></tr>
<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;2. Herstellung</td><td> <p align="right">2</p></td></tr>
<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;3. Das WYSIAWYG-Prinzip</td><td> <p align="right">3</p></td></tr>
<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;4. Fazit</td><td> <p align="right">4</p></td></tr>
</table></body></html>]====],
[====[<!DOCTYPE html> <head></head><html><body><h1>Reflexives Buchherstellungsprogramm mit Baumansicht-Inhaltsverzeichnis</h1>

<br>
<br><h2>1. Einleitung </h2>
Dieses Buch wird als Seiten hergestellt.
<br>
<br><h2>2. Herstellung</h2>
Die Seiten werden links uns rechts angeordnet und so mit einem WYSIAWYG-Prinzip gefüllt, das im nächsten Abschnitt definiert wird.</body></html>]====],
[====[<!DOCTYPE html> <head></head><html><body><h2>3. Das WYSIAWYG-Prinzip</h2>
WYSIAWYG bedeutet what you see is analogous to what you get.</body></html>]====],
[====[<!DOCTYPE html> <head></head><html><body><h2>4. Fazit</h2>
Das Inhaltsverzeichnis wird immer automatisch aktuell gehalten. Das ist sehr praktisch. Das Wiederfinden der Seiten ist dank der Suchfunktionalität etwas einfacher als ohne.
<br> </body></html>]====],
}--TextHTMLTabelle<!--

----[====[This programm has webpages within the Lua script which can contain a tree in html and there is a tree table of contents at the first page

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
--2.1 initialisation of the current page
aktuelleSeite=1

--2.2 table of contents as a tree on the first page
TextHTMLTabelle[1]=[[<!DOCTYPE html> <head></head><html><body><table border="0">
<tr><td><b>Inhaltsverzeichnis]]  .. string.rep("&nbsp;",115) .. [[</b></td><td><p align="right">1</p></td></tr>]]
for k,v in pairs(TextHTMLTabelle) do 
	print(k)
	for Feld in v:gmatch("<h(%d>[^<]*)</h%d>") do 
		local depthTitle,titleText=Feld:match("(%d)>([^<]*)")
		print(titleText,depthTitle) --string.rep("&nbsp;",tonumber(depthTitle)*5) ungenau
		TextHTMLTabelle[1]=TextHTMLTabelle[1] .. '\n<tr><td>' .. string.rep("&nbsp;",tonumber((depthTitle)-1)*4) .. titleText .. '</td><td> <p align="right">' .. k .. "</p></td></tr>"
	end --for Feld in v:gmatch("<h%d>[^<]*</h%d>") do 
end --for k,v in pairs(TextHTMLTabelle) do 
TextHTMLTabelle[1]=TextHTMLTabelle[1] .. "\n</table></body></html>"



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
	commentSymbol,inputTextProgramm=inputfile:read("*a"):match("TextHTMLTabelle={.*}(%-%-)TextHTMLTabelle<!%-%-(.*)")
	inputfile:close()
	--build the new htmlTexts
	local output_htmlTexts_text="TextHTMLTabelle={" --the output string
	local outputfile=io.output(outputfile_path) --a output file

	for k,v in pairs(TextHTMLTabelle) do 
		if type(k)=="number" then
		output_htmlTexts_text=output_htmlTexts_text .. "\n[====[" .. v .. "]====],"
		else
		output_htmlTexts_text=output_htmlTexts_text .. '\n["' .. k .. '"]=[====[' .. v .. "]====],"
		end --if type(k)=="number" then
	end --for k,v in pairs(TextHTMLTabelle) do 

	output_htmlTexts_text=output_htmlTexts_text .. "\n}"
	outputfile:write(output_htmlTexts_text .. "--TextHTMLTabelle<!--") --write everything into the outputfile
	--write the programm for the data in itself
	outputfile:write(inputTextProgramm)
	outputfile:close()
end --function save_html_to_lua(htmlTexts, outputfile_path)

--4.1 change page dialog
--ok button 1
ok_1 = iup.flatbutton{title = "OK",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function ok_1:flat_action()
	local writeTextBack
	if aktuelleSeite==1 then --Page 1 cannot be updated
		--do nothing
	else
		writeTextBack="<!DOCTYPE html> <head></head><html><body>" .. 
			text1_1.value:gsub("^(%d+%.%d+%.%d+ [^\n]*)\n","<h4>%1</h4>") 
				:gsub("^(%d+%.%d+ [^\n]*)\n","<h3>%1</h3>") 
				:gsub("^(%d+%. [^\n]*)\n","<h2>%1</h2>") 
				:gsub("\n(%d+%.%d+%.%d+ [^\n]*)\n","\n<h4>%1</h4>") 
				:gsub("\n(%d+%.%d+ [^\n]*)\n","\n<h3>%1</h3>") 
				:gsub("\n(%d+%. [^\n]*)\n","\n<h2>%1</h2>") 
				:gsub("\n","\n<br>") 
				:gsub("</h1>","</h1>\n") 
				:gsub("</h2>","</h2>\n") 
				:gsub("</h3>","</h3>\n") 
				:gsub("</h4>","</h4>\n") 
				.. "</body></html>"
	end --if aktuelleSeite==1 then 
	webbrowser1.HTML= writeTextBack
	TextHTMLTabelle[aktuelleSeite]= writeTextBack
end --function ok_1:flat_action()


--ok button 2
ok_2 = iup.flatbutton{title = "OK",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function ok_2:flat_action()
	local writeTextBack
	if aktuelleSeite+1==2 then --first Line in Page 2 is allways the main title
		writeTextBack="<!DOCTYPE html> <head></head><html><body>" .. 
			text1_2.value:gsub("^([^\n]*)\n","<h1>%1</h1>") 
				:gsub("^(%d+%.%d+%.%d+ [^\n]*)\n","<h4>%1</h4>") 
				:gsub("^(%d+%.%d+ [^\n]*)\n","<h3>%1</h3>") 
				:gsub("^(%d+%. [^\n]*)\n","<h2>%1</h2>") 
				:gsub("\n(%d+%.%d+%.%d+ [^\n]*)\n","\n<h4>%1</h4>") 
				:gsub("\n(%d+%.%d+ [^\n]*)\n","\n<h3>%1</h3>") 
				:gsub("\n(%d+%. [^\n]*)\n","\n<h2>%1</h2>") 
				:gsub("\n","\n<br>") 
				:gsub("</h1>","</h1>\n") 
				:gsub("</h2>","</h2>\n") 
				:gsub("</h3>","</h3>\n") 
				:gsub("</h4>","</h4>\n") 
				.. "</body></html>"
	else
		writeTextBack="<!DOCTYPE html> <head></head><html><body>" .. 
			text1_2.value:gsub("^(%d+%.%d+%.%d+ [^\n]*)\n","<h4>%1</h4>") 
				:gsub("^(%d+%.%d+ [^\n]*)\n","<h3>%1</h3>") 
				:gsub("^(%d+%. [^\n]*)\n","<h2>%1</h2>") 
				:gsub("\n(%d+%.%d+%.%d+ [^\n]*)\n","\n<h4>%1</h4>") 
				:gsub("\n(%d+%.%d+ [^\n]*)\n","\n<h3>%1</h3>") 
				:gsub("\n(%d+%. [^\n]*)\n","\n<h2>%1</h2>") 
				:gsub("\n","\n<br>") 
				:gsub("</h1>","</h1>\n") 
				:gsub("</h2>","</h2>\n") 
				:gsub("</h3>","</h3>\n") 
				:gsub("</h4>","</h4>\n") 
				.. "</body></html>"
	end --if aktuelleSeite+1==2 then 
	webbrowser2.HTML= writeTextBack
	TextHTMLTabelle[aktuelleSeite+1]= writeTextBack
end --function ok_2:flat_action()

--cancel button
cancel = iup.flatbutton{title = "Abbrechen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function cancel:flat_action()
	return iup.CLOSE
end --function cancel:flat_action()

--search searchtext.value in text field 1
search_in_text_1 = iup.flatbutton{title = "Suche in Blatt links",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
searchPosition_1=1
function search_in_text_1:flat_action()
	from,to=text1_1.value:find(textbox2.value,searchPosition_1)
	searchPosition_1=to
	if from==nil then 
		searchPosition_1=1 
		iup.Message("Suchtext in der Blatt links nicht gefunden","Suchtext in der Blatt links nicht gefunden")
	else
		text1_1.SELECTIONPOS=from-1 .. ":" .. to
	end --if from==nil then 
end --	function search_in_text_1:flat_action()

--search searchtext.value in text field 2
search_in_text_2 = iup.flatbutton{title = "Suche in Blatt rechts",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
searchPosition_2=1
function search_in_text_2:flat_action()
	from,to=text1_2.value:find(textbox2.value,searchPosition_2)
	searchPosition_2=to
	if from==nil then 
		searchPosition_2=1 
		iup.Message("Suchtext in der Blatt links nicht gefunden","Suchtext in der Blatt links nicht gefunden")
	else
		text1_2.SELECTIONPOS=from-1 .. ":" .. to
	end --if from==nil then 
end --	function search_in_text_2:flat_action()


text1_1 = iup.multiline{size="120x50",border="YES",expand="YES",wordwrap="YES"} --textfield
label1_1 = iup.label{title="Blattinhalt links:"}--label for textfield
text1_2 = iup.multiline{size="120x50",border="YES",expand="YES",wordwrap="YES"} --textfield
label1_2 = iup.label{title="Blattinhalt rechts:"}--label for textfield


--open the dialog for renaming branch/leaf
dlg_change_page = iup.dialog{
	iup.hbox{ 
	iup.vbox{label1_1, text1_1, iup.hbox{ok_1,search_in_text_1,}}; 
	iup.vbox{label1_2, text1_2, iup.hbox{ok_2,search_in_text_2,iup.fill{},cancel,}}; 
	};
	title="Blatt bearbeiten",
	size="800x300",
	startfocus=text1_1,
	}

--4.1 change page dialog end

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
button_save_lua_table=iup.flatbutton{title="Buch speichern", size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_lua_table:flat_action()
	save_html_to_lua(TextHTMLTabelle, path .. "\\" .. thisfilename)
end --function button_save_lua_table:flat_action()

--6.3 button for going to first page
button_go_to_first_page = iup.flatbutton{title = "Startseite",size="55x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_to_first_page:flat_action()
	webbrowser1.HTML=TextHTMLTabelle[1]
	webbrowser2.HTML=TextHTMLTabelle[2]
	aktuelleSeite=1
	textbox1.value=aktuelleSeite
end --function button_go_to_first_page:flat_action()

--6.4 button for going one page back
button_go_back = iup.flatbutton{title = "Eine Seite zurück",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_back:flat_action()
	aktuelleSeite=math.tointeger(tonumber(textbox1.value)) or aktuelleSeite
	if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
		aktuelleSeite=aktuelleSeite-1
	end --if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
	if aktuelleSeite>2 then aktuelleSeite=aktuelleSeite-2 end
		webbrowser1.HTML=TextHTMLTabelle[aktuelleSeite]
		webbrowser2.HTML=TextHTMLTabelle[aktuelleSeite+1]
		textbox1.value=aktuelleSeite
	end --function button_go_back:flat_action()

--6.5 button for editing the page
button_edit_page = iup.flatbutton{title = "Editieren der Seite:",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_page:flat_action()
	if tonumber(textbox1.value) then
		aktuelleSeite=math.tointeger(tonumber(textbox1.value))
		if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
			aktuelleSeite=aktuelleSeite-1
			textbox1.value=aktuelleSeite
		end --if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
		TextErsatz_1=TextHTMLTabelle[aktuelleSeite]
		TextErsatz_2=TextHTMLTabelle[aktuelleSeite+1]
		webbrowser1.HTML=TextErsatz_1
		if TextHTMLTabelle[aktuelleSeite+1]==nil then
			webbrowser2.HTML=""
		else
			webbrowser2.HTML=TextErsatz_2
		end --if TextHTMLTabelle[aktuelleSeite+1]==nil then
		text1_1.value=TextErsatz_1:gsub("<!DOCTYPE html> <head></head><html><body>(.*)</body></html>","%1")
					:gsub("<br>\n<br>","\n")
					:gsub("<br>","\n")
					:gsub("<h%d+>","")
					:gsub("</h%d+>[^\n]","\n")
					:gsub("</h%d+>\n","\n")
		text1_2.value=TextErsatz_2:gsub("<!DOCTYPE html> <head></head><html><body>(.*)</body></html>","%1")
					:gsub("<br>\n<br>","\n")
					:gsub("<br>","\n")
					:gsub("<h%d+>","")
					:gsub("</h%d+>[^\n]","\n")
					:gsub("</h%d+>\n","\n")
		dlg_change_page:popup(iup.CENTER, iup.CENTER) --popup rename dialog
	end --if tonumber(textbox1.value) then
end --function button_edit_page:flat_action()

--6.6 button for going to the page
button_go_to_page = iup.flatbutton{title = "Gehe zu Seite:",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_to_page:flat_action()
	if tonumber(textbox1.value) then
		aktuelleSeite=math.tointeger(tonumber(textbox1.value))
		if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
			aktuelleSeite=aktuelleSeite-1
			textbox1.value=aktuelleSeite
		end --if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
		webbrowser1.HTML=TextHTMLTabelle[aktuelleSeite]
		if TextHTMLTabelle[aktuelleSeite+1]==nil then
			webbrowser2.HTML=""
		else
			webbrowser2.HTML=TextHTMLTabelle[aktuelleSeite+1]
		end --if TextHTMLTabelle[aktuelleSeite+1]==nil then
	end --if tonumber(textbox1.value) then
end --function button_go_to_page:flat_action()

--6.7 button for deleting the page
button_delete = iup.flatbutton{title = "Löschen der Seite",size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_delete:flat_action()
	LoeschAlarm=iup.Alarm("Soll die Seite " .. tonumber(textbox1.value) .. " wirklich gelöscht werden?","Soll die Seite " .. tonumber(textbox1.value) .. " wirklich gelöscht werden?","Löschen","Nicht Löschen")
	if LoeschAlarm==1 then 
		if tonumber(textbox1.value) and tonumber(textbox1.value)<=#TextHTMLTabelle then
			aktuelleSeite=math.tointeger(tonumber(textbox1.value))
			table.move(TextHTMLTabelle,aktuelleSeite+1,#TextHTMLTabelle,aktuelleSeite)--move following elements to begin with index from aktuelleSeite
			TextHTMLTabelle[#TextHTMLTabelle]=nil --delete last element
			--test with: iup.Message(aktuelleSeite, tostring(math.floor(aktuelleSeite/2)*2==aktuelleSeite))
			if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
				webbrowser2.HTML="Seite gelöscht"
			else
				webbrowser1.HTML="Seite gelöscht"
			end --if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
		else
			iup.Message("Keine Seite zum Löschen","Keine Seite zum Löschen")
		end --if tonumber(textbox1.value) and tonumber(textbox1.value)<=#TextHTMLTabelle then
	end --if LoeschAlarm==1 then 
end --function button_delete:flat_action()

--6.8 button for saving TextHTMLtable as html file
button_save_as_html=iup.flatbutton{title="Als html speichern", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_as_html:flat_action()
	local outputfile1=io.open(path .. "\\" .. thisfilename:gsub("%.lua$",".html"),"w")
	outputfile1:write("<!DOCTYPE html> <head></head><html><body>")
	for k,v in pairs(TextHTMLTabelle) do
		outputfile1:write(v:gsub("<!DOCTYPE html> <head></head><html><body>(.*)</body></html>","%1") .. "\n")
	end --for k,v in pairs(TextHTMLTabelle) do
	outputfile1:write("</body></html>")
	outputfile1:close()
end --function button_save_as_html:flat_action()


--6.9 button for search in TextHTMLtable
button_search=iup.flatbutton{title="Suche im Buch", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_search:flat_action()
aktuelleSeite=math.tointeger(tonumber(textbox1.value))
if aktuelleSeite<=#TextHTMLTabelle then
	for i=aktuelleSeite+2,#TextHTMLTabelle do
		if TextHTMLTabelle[i]:gsub("<[^>]+>",""):lower():match(textbox2.value:lower()) then
			textbox1.value=i
			aktuelleSeite=math.tointeger(tonumber(textbox1.value))
			if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
				aktuelleSeite=aktuelleSeite-1
				textbox1.value=aktuelleSeite
			end --if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
			webbrowser1.HTML=TextHTMLTabelle[aktuelleSeite]
			if TextHTMLTabelle[aktuelleSeite+1]==nil then
				webbrowser2.HTML=""
			else
				webbrowser2.HTML=TextHTMLTabelle[aktuelleSeite+1]
			end --if TextHTMLTabelle[aktuelleSeite+1]==nil then
			break 
		end --if TextHTMLTabelle[i]:gsub("<[^>]+>",""):lower():match(textbox2.value:lower()) then
	end --for i=aktuelleSeite,#TextHTMLTabelle do
end --if aktuelleSeite<=#TextHTMLTabelle then
end --function button_search:flat_action()

--6.10 button for going one page forward
button_go_forward = iup.flatbutton{title = "Eine Seite vor",size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_go_forward:flat_action()
	aktuelleSeite=math.tointeger(tonumber(textbox1.value)) or aktuelleSeite
	if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
		aktuelleSeite=aktuelleSeite-1
	end --if math.floor(aktuelleSeite/2)*2==aktuelleSeite and aktuelleSeite>1 then
	if aktuelleSeite<#TextHTMLTabelle-1 then aktuelleSeite=aktuelleSeite+2 end
	webbrowser1.HTML=TextHTMLTabelle[aktuelleSeite]
	if TextHTMLTabelle[aktuelleSeite+1]==nil then
		webbrowser2.HTML=""
	else
		webbrowser2.HTML=TextHTMLTabelle[aktuelleSeite+1]
	end --if TextHTMLTabelle[aktuelleSeite+1]==nil then
	textbox1.value=aktuelleSeite
end --function button_go_forward:flat_action()

--6.11 button for building new page
button_new_page = iup.flatbutton{title = "Neue Seite",size="65x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_new_page:flat_action()
	aktuelleSeite=#TextHTMLTabelle+1
	textbox1.value=aktuelleSeite
local newText=[====[<!DOCTYPE html> <head></head><html><body>
<h1>Neue Seite </h1>

</body></html> ]====]
	if math.floor(aktuelleSeite/2)*2==aktuelleSeite then
		webbrowser2.HTML=newText
	else 
		webbrowser1.HTML=newText
	end -- if math.floor(aktuelleSeite/2)*2==aktuelleSeite then
	TextHTMLTabelle[aktuelleSeite]= newText
end --function button_new_page:flat_action()

--6.12 button with second logo
button_logo2=iup.button{image=img_logo,title="", size="23x20"}
function button_logo2:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nidiv.kaiser@t-online.de")
end --function button_logo:flat_action()

--7 Main Dialog

--7.1 textboxes
textbox1 = iup.text{value="1",size="20x20",WORDWRAP="NO",alignment="ACENTER"}
textbox2 = iup.multiline{value="",size="90x20",WORDWRAP="YES"}

--7.2 webbrowser
webbrowser1=iup.webbrowser{HTML=TextHTMLTabelle[1]}
webbrowser2=iup.webbrowser{HTML=TextHTMLTabelle[2]}

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
			button_save_as_html,
			button_search,
			textbox2,
			button_go_forward,
			button_new_page,
			button_logo2,
		},
		iup.hbox{webbrowser1,webbrowser2,},
	}, --iup.vbox{
	icon = img_logo,
	title = path .. " Documentation Tree",
	size="FULLxFULL" ;
	gap="3",
	alignment="ARIGHT",
	margin="5x5" 
}--maindlg = iup.dialog {

--7.4 show the dialog
maindlg:showxy(iup.CENTER,iup.CENTER) 

--7.5 Main Loop
if (iup.MainLoopLevel()==0) then iup.MainLoop() end

--]====]
