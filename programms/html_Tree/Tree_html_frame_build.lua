
--1. tree as Lua table
--It can also be extern file with dofile.
Tree={branchname="\"Tree_html_frame_home.html\">IDIV",
{branchname="\"Tree_html_frame_home.html\">Html mit den drei Feldern (frames)",
{branchname="\"Tree_html_frame.html\">Tree_html_frame.html", state="COLLAPSED",
{branchname="\"Tree_html_frame_home.html\">Startbildschirm rechts", state="COLLAPSED",
"\"Tree_html_frame_home.html\">Tree_html_frame_home.html",
},
{branchname="\"Tree_html_frame_wb_tree.html\">Baumansicht links", state="COLLAPSED",
"\"Tree_html_frame_wb_tree.html\">Tree_html_frame_wb_tree.html",
},
{branchname="Lua im Internet", state="COLLAPSED",
"http://www.lua.org",
},
},
{branchname="\"\">Ordner des IDIV-Arbeitsplatzes", state="COLLAPSED",
"\"C:\\Tree\\html_Tree\">C:\\Tree\\html_Tree",
{branchname="\"wb_img\">Ordner f�r die Bilder", state="COLLAPSED",
"\"wb_img\">wb_img",
{branchname="\"wb_img\">Einzelbilder", state="COLLAPSED",
"\"wb_img\\hideall.png\">wb_img\\hideall.png",
"\"wb_img\\hideall_over.png\">wb_img\\hideall_over.png",
"\"wb_img\\showall.png\">wb_img\\showall.png",
"\"wb_img\\showall_over.png\">wb_img\\showall_over.png",
"\"wb_img\\minusnode.png\">wb_img\\minusnode.png",
"\"wb_img\\plusnode.png\">wb_img\\plusnode.png",
},
},
},
},
}

--1.1 path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)

--1.2 text written in html to build a tree in html with textboxes, buttons and functions
textBeginHTML=[[
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Strict//EN">
<html>
<head>
  <title>Tree</title>
  <base target="wb_cont">
  <style type="text/css">
  .tree { font-family: helvetica, sans-serif; font-size: 10pt; }
  .tree p { margin: 0px; white-space: nowrap; }
  .tree div { display: none; margin: 0px; }
  .tree img { vertical-align: middle; }
  .tree a:hover { text-decoration: none; background-color: #e0e0ff }
  </style>
  <script type="text/javascript">
  lastLink = null;

  function hideFolder(folder, id) {
    var imageNode = document.images["img" + id];
    if (imageNode != null) {
      var len = imageNode.src.length;
      if (imageNode.src.substring(len-8,len-4) == "last")
        imageNode.src = "wb_img/plusnodelast.png";
      else if (imageNode.src.substring(len-8,len-4) == "node")
        {imageNode.src = "wb_img/plusnode.png";
        imageNode.alt = "+";}
    } //if (imageNode != null) {
    folder.style.display = "none";
  } //function hideFolder(folder, id) {

  function showFolder(folder, id) {
    var imageNode = document.images["img" + id];
    if (imageNode != null) {
      var len = imageNode.src.length;
      if (imageNode.src.substring(len-8,len-4) == "last")
        imageNode.src = "wb_img/minusnodelast.png";
      else if (imageNode.src.substring(len-8,len-4) == "node")
        {imageNode.src = "wb_img/minusnode.png";
        imageNode.alt = "-";}
		} //if (imageNode.src.substring(len-8,len-4) == "last")
    folder.style.display = "block";
  } //function showFolder(folder, id) {

  function toggleFolder(id) {
    var folder = document.getElementById(id);
    if (folder.style.display == "block")
      hideFolder(folder, id);
    else
      showFolder(folder, id);
  } //function toggleFolder(id) {

  function setFoldersAtLevel(level, show) {
    var i = 1;
    do {
      var folder_id = level + "." + i;
      var id = "folder" + folder_id;
      var folder = document.getElementById(id);
      if (folder != null) {
        setFoldersAtLevel(folder_id, show);
        if (show)
          showFolder(folder, id);
        else
          hideFolder(folder, id);
      } //if (folder != null) {
      i++;
    } while(folder != null);
  } //function setFoldersAtLevel(level, show) {

  function showAllFolders() {setFoldersAtLevel("", true); }
  function hideAllFolders() {setFoldersAtLevel("", false);}

  function searchInTree() {
  var getFolderNameText="";
  var GRfoundText="";
  document.G.NR.value=0;
  document.G.AR.value=document.links.length + 1;
  for (var i = 0; i < document.links.length; i++) {
      var link = document.links[i];
		if (link.text.toLowerCase().search(document.G.Q.value.toLowerCase())>=0) //e.g. "Tree_Baum.html"
		{ document.G.R.value=getFolderId(link.name);
			link.style.color = "#00ff00";
			//return;
			//search for all node above with a folder included in text of the founded node, e.g. folder.1 and folder.1.3 as texts are in text folder.1.3.4
			for (var k = 0; k < document.links.length; k++) {   
				GRfoundText=document.G.R.value.toLowerCase().replaceAll(".","~");
				getFolderNameText=getFolderId(document.links[k].name).toLowerCase().replaceAll(".","~") + "~";
				if (GRfoundText.search(getFolderNameText)>=0 && k < i) {
					document.links[k].style.color = "#ff0000";  
					//test with: document.G.PR.value=document.G.R.value.toLowerCase() +" mit " + getFolderNameText + "-" + document.G.PR.value;
				} //if (GRfoundText.search(getFolderNameText)>=0 && k < i) {
			  } //  for (var k = 0; k < document.links.length; k++) {      
			}
		else
		{  //document.G.Q.value=link.name;
			link.style.color = "#0000ff";
			//return;
		} //if (link.name==document.G.Q.value)
    } //for (var i = 0; i < document.links.length; i++) {
  showAllFolders()
} //function searchInTree()

  function searchInTreeNext() {
  var getFolderNameText="";
  var GRfoundText="";
  var searchI=0;
  //search begin up to number of node found
  for (var i = document.G.NR.value; i < document.links.length; i++) {
      var link = document.links[i];
		if (link.text.toLowerCase().search(document.G.Q.value.toLowerCase())>=0) //e.g. "Tree_Baum.html"
		{  document.G.R.value=getFolderId(link.name);
			searchI=i;
			document.G.NR.value=(Number(i)+1).toString(); //should be add with 1 to find the next node
			//test with: document.G.R.value = document.G.R.value + "nr: " + searchI
			  for (var i = 0; i < document.links.length; i++) {
			//test with: document.G.R.value=document.G.R.value+"-"+getFolderId(document.links[i].name);
			GRfoundText=document.G.R.value.toLowerCase().replaceAll(".","~");
			getFolderNameText=getFolderId(document.links[i].name).toLowerCase().replaceAll(".","~") + "~";
			//search for all node above with a folder included in text of the founded node, e.g. folder.1 and folder.1.3 as texts are in text folder.1.3.4
				if (GRfoundText.search(getFolderNameText)>=0 && i < searchI) {
					document.links[i].style.color = "#ff0000";
				} //if (GRfoundText.search(getFolderNameText)>=0 && i < searchI) {
			  } //  for (var i = 0; i < document.links.length; i++) {
			link.style.color = "#00ff00";
			//return;
			goToLink(link)
			parent.wb_cont.location.href = link.href;
			}
		else
		{  //document.G.Q.value=link.name;
			link.style.color = "#0000ff";
			//return;
		} //if (link.name==document.G.Q.value)
    } //for (var i = 0; i < document.links.length; i++) {
} //function searchInTreeNext()


  function goToLink(link) { //because of the systematic for the folder names in the link.name it is not possible to go to link together with correct mark of tree
    var id = getFolderId(link.name);
    document.G.Q.value=document.G.Q.value; // + "->" + link.text    text of a href 
    showFolderRec(id);
    location.hash = "#" + link.name;
    link.style.color = "#00ff00";
    //clear link
    clearLastLink();
    lastLink = link;
  } //function goToLink(link) {

 function getFolderId(name) {return name.substring(name.indexOf("folder"), name.length); }

 function showFolderRec(id) {
    var folder = document.getElementById(id);
    if (folder != null) {
      showFolder(folder, id);
      var parent_id = id.substring(0, id.lastIndexOf("."))
      if (parent_id != null && parent_id != "folder") {
         showFolderRec(parent_id)
      } //if (parent_id != null && parent_id != "folder") {
    } //if (folder != null) {
  } //function showFolderRec(id) {

  function clearLastLink() {
    if (lastLink != null) {
      lastLink.style.color = ""
      lastLink = null;
    } //if (lastLink != null) {
  } //function clearLastLink() {


  </script>
</head>

<body style="margin: 2px; background-color: #F1F1F1"  onload="showStartPage()">

<form name="G">
<img alt="Expand All Nodes" src="wb_img/showall.png" onclick="showAllFolders()" onmouseover="this.src='wb_img/showall_over.png'" onmouseout="this.src='wb_img/showall.png'">

<img alt="Contract All Nodes" src="wb_img/hideall.png" onclick="hideAllFolders()" onmouseover="this.src='wb_img/hideall_over.png'" onmouseout="this.src='wb_img/hideall.png'">

<br>
Suche von:
<br>
<input value="" name="Q" size="54" type="text">
<br>
<input value="Markieren aller Fundstellen und Ausklappen" onclick="searchInTree()" type="button">
<br>
<input value="Markieren der weiteren Fundstelle" onclick="searchInTreeNext()" type="button">
<br>
Bei Bedarf auf IDIV klicken.
<br>
Ergebnis:
<br>
<input value="" name="R" size="54" type="text">
<br>
Fundstellennummer:
<br>
<input value="0" name="NR" size="54" type="text">
<br>
Anzahl Knoten:
<br>
<input value="0" name="AR" size="54" type="text">
<br>

<!--test with: input value="0" name="PR" size="54" type="text"-->
</form>



]]

--1.3 function to build recursively the tree
function readTreetohtmlRecursive(TreeTable,levelStart,levelFolderStart,iStart,linkNumberStart)
	linkNumber=linkNumberStart or 1
	iNumber= iStart or 1
	levelFolder = (levelFolderStart or "") .. "." .. iNumber --string.rep(".x",level+1)
	--test with: print(" >" .. levelFolder)
	level = levelStart or 0
	if TreeTable.branchname:match('"([^"]*)">') then
		AusgabeTabelle[TreeTable.branchname:match('"([^"]*)">')]=true
	else
		AusgabeTabelle[TreeTable.branchname]=true
	end --if TreeTable.branchname:match('"([^"]*)">') then
	--build the branches
	textforHTML = textforHTML .. string.rep("\t",level) .. '<p style="margin: 0px 0px 5px ' .. level*30  .. 'px">'
	if TreeTable.state=="COLLAPSED" then
		textforHTML = textforHTML ..
		[[<img name="imgfolder]] .. levelFolder .. [[" src="wb_img/plusnode.png" alt="+" onclick="toggleFolder('folder]] .. levelFolder .. [[')">]]
	else
		textforHTML = textforHTML ..
		[[<img name="imgfolder]] .. levelFolder .. [[" src="wb_img/minusnode.png" alt="-" onclick="toggleFolder('folder]] .. levelFolder .. [[')">]]
	end --if state=="COLLAPSED" then
	if TreeTable.branchname:match('"([^"]*)">')==nil and tostring(TreeTable.branchname):match("http") then
		LinkText='"' .. tostring(TreeTable.branchname) .. '">'
	elseif TreeTable.branchname:match('"([^"]*)">')==nil then
		LinkText='"Tree_html_frame_home.html">'
	else
		LinkText=""
	end --if TreeTable.branchname:match('"([^"]*)">')==nil and tostring(TreeTable.branchname):match("http") then
	textforHTML = textforHTML ..
	'<a name="link' .. linkNumber .. 'folder' .. levelFolder .. '" href=' ..
	LinkText .. tostring(TreeTable.branchname)
	:gsub("ä","&auml;")
	:gsub("Ä","&Auml;")
	:gsub("ö","&ouml;")
	:gsub("Ö","&Ouml;")
	:gsub("ü","&uuml;")
	:gsub("Ü","&Uuml;")
	:gsub("ß","&szlig;")
	.. "</a>" .. "</p>\n"
	if TreeTable.state=="COLLAPSED" then
		textforHTML = textforHTML .. string.rep("\t",level) .. '<div id="folder' .. levelFolder .. '">\n'
	else
		textforHTML = textforHTML .. string.rep("\t",level) .. '<div id="folder' .. levelFolder .. '" style="display:block">\n'
	end --if state=="COLLAPSED" then
	for i,v in ipairs(TreeTable) do
		linkNumber=linkNumber+1
		if type(v)=="table" then
			level = level +1
			readTreetohtmlRecursive(v,level,levelFolder,i,linkNumber)
		else
			if v:match('"([^"]*)">') then
				AusgabeTabelle[v:match('"([^"]*)">')]=true
			else
				AusgabeTabelle[v]=true
			end --if v:match('"([^"]*)">') then
			if v:match('"([^"]*)">')==nil and tostring(v):match("http") then
				LinkText='"' .. tostring(v) .. '">'
			elseif v:match('"([^"]*)">')==nil then
				LinkText='"Tree_html_frame_home.html">'
			else
				LinkText=""
			end --if TreeTable.branchname:match('"([^"]*)">')==nil and tostring(TreeTable.branchname):match("http") then
			textforHTML = textforHTML .. string.rep("\t",level+1) .. '<p style="margin: 0px 0px 5px ' .. (level+1)*30  .. 'px">' .. '<a name="link' .. linkNumber .. 'folder' .. levelFolder .. "." .. i .. '" href=' .. 
			LinkText .. v
			:gsub("ä","&auml;")
			:gsub("Ä","&Auml;")
			:gsub("ö","&ouml;")
			:gsub("Ö","&Ouml;")
			:gsub("ü","&uuml;")
			:gsub("Ü","&Uuml;")
			:gsub("ß","&szlig;")
			.. "</a>" .. "</p>\n"
		end --if type(v)=="table" then
	end --for i, v in ipairs(TreeTable) do
	--test with: print("  " .. levelFolder)
	levelFolder=levelFolder:match("(.*)%.%d+$")
	--test with: print("->" .. levelFolder)
	textforHTML = textforHTML .. string.rep("\t",level) .. "</div>\n"
	level = level - 1
end --readTreetohtmlRecursive(TreeTable)

--1.4.1 apply the recursive function and build html file
textforHTML=""
AusgabeTabelle={}
readTreetohtmlRecursive(Tree)

--1.4.2 write tree in html in the tree frame
outputfile1=io.open(path .. "\\" .. "Tree_html_frame_wb_tree.html","w")
outputfile1:write(textBeginHTML)
--word wrap without this:
outputfile1:write('<div class="tree">' .. "\n")
outputfile1:write(textforHTML)
--word wrap without this:
outputfile1:write("</div>")
outputfile1:write("\n</body>\n</html>")
outputfile1:close()

--2. write home html in the home frame
outputfile2=io.open(path .. "\\" .. "Tree_html_frame_home.html","w")
outputfile2:write('<p>This frame html contains a tree in the left frame. The mark functionality is limited because of the denomination of the link names. Go to link is not possible if mark functions correctly and vice versa.</p><pre>\n')
p=io.popen('dir C:\\Temp\\* /b/o/s ')
--write lines only when not in manual tree
--test with: for k,v in pairs(AusgabeTabelle) do print(k,v) end
for line in p:lines() do
	--test with: print(line:gsub(path .. "\\",""))
	if AusgabeTabelle[line:gsub(path .. "\\","")]==nil then
		outputfile2:write(line .. '\n')
	end --if AusgabeTabelle[line]==nil then
end --for line in p:lines() do
outputfile2:write('</pre>\n')
outputfile2:write([[

<textarea name="textArea1" id="textArea1" rows="14" cols="90">
Parts of this files taken from Webbook https://www.tecgraf.puc-rio.br/webbook/

Copyright 1994-2010 Tecgraf / PUC-Rio.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
</textarea>

]])
outputfile2:close()

--3. build whole frame with tree and home frame
outputfile3=io.open(path .. "\\" .. "Tree_html_frame.html","w")
outputfile3:write([[
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Strict//EN"><html><head>
<title>IDIV-Arbeitsplatz</title></head>

  <frameset cols="380,*" frameborder="1" framespacing="4" bordercolor="#0B6DCE" border="4">
    <frame name="wb_tree" src="Tree_html_frame_wb_tree.html" frameborder="1" target="wb_cont">
    <frame name="wb_cont" src="Tree_html_frame_home.html" frameborder="1">
  <noframes>
  <body>
  <p>This page uses frames, but your browser does not support them.</p>
  </body>
  </noframes>
  </frameset>



</html>
]])
outputfile3:close()

--4. build the path wb_img for the images
os.execute('md "' .. path .. '\\wb_img"')

--4.1 libraries for images
require("cdlua") --for images
require("cdluapdf") --for pdf and powerpoint
require("imlua") --for images
require("cdluaim") --for screen capture
require("iuplua")           --require iuplua for GUIs
require("iupluacd") --for iup canvas

--4.2 optional section for pdf or powerpoint and screen capture
--
--[[PDF
canvas=cd.CreateCanvas(cd.PDF,"html_frame.pdf") --8 is PS-Adobe, 9 ist XML, 10 is powerpoint, 13 is PDF
canvas:Foreground(cd.RED)
canvas:Box(100,550,100,550)
canvas:Foreground(cd.EncodeColor(255,32,140))
canvas:Line(0,0,3000,1000)
canvas:Activate()
canvas:Kill()
--]]
--
--[[part of screen capture: canvas=cd.CreateCanvas(cd.NATIVEWINDOW,nil)
canvas=cd.CreateCanvas(cd.NATIVEWINDOW,nil)
canvas:Activate()
w,h=canvas:GetSize()
image=im.ImageCreate(w,h,im.RGB,im.BYTE)
image:cdCanvasGetImage(canvas,0,0)
image:Save("html_frame_image_screen.png","PNG") --.jpg, "JPG" --.png, "PNG" --.bmp,"BMP"
canvas:Kill()
--]]

--4.3 build the needed images for the frames
----[[draw image for needed purpose --https://www.tecgraf.puc-rio.br/cd/ Screeshots Lua Source Code
--CD > Guide > Samples > Lua Samples > To draw in a RGB image in CDLua for Lua 5:
w=16
h=20
bitmap = cd.CreateBitmap(w,h,cd.RGB)
canvas = cd.CreateCanvas(cd.IMAGERGB, bitmap)
canvas:Foreground(cd.GRAY)
canvas:Box(0,15,0,19)
canvas:Foreground(cd.WHITE)
canvas:Box(3,11,7,15)
canvas:Foreground(cd.BLACK)
canvas:LineWidth(1)
canvas:LineStyle(cd.CONTINUOUS)
canvas:Line(5, 11, 9, 11)
canvas:Foreground(cd.BLUE)
canvas:Line(3, 7, 11, 7)
canvas:Line(3, 7, 3, 15)
canvas:Line(3, 15, 11, 15)
canvas:Line(11, 15, 11, 7)
canvas:Activate()
w,h=canvas:GetSize()
image=im.ImageCreate(w,h,im.RGB,im.BYTE)
image:cdCanvasGetImage(canvas,0,0)
image:Save(path .. "\\" .. "wb_img\\minusnode.png","PNG") --.jpg, "JPG" --.png, "PNG" --.bmp,"BMP"
canvas:Kill()
--]]


----[[draw image for needed purpose --https://www.tecgraf.puc-rio.br/cd/ Screeshots Lua Source Code
--CD > Guide > Samples > Lua Samples > To draw in a RGB image in CDLua for Lua 5:
w=16
h=20
bitmap = cd.CreateBitmap(w,h,cd.RGB)
canvas = cd.CreateCanvas(cd.IMAGERGB, bitmap)
canvas:Foreground(cd.GRAY)
canvas:Box(0,15,0,19)
canvas:Foreground(cd.WHITE)
canvas:Box(3,11,7,15)
canvas:Foreground(cd.BLACK)
canvas:LineWidth(1)
canvas:LineStyle(cd.CONTINUOUS)
canvas:Line(5, 11, 9, 11)
canvas:Line(7, 9, 7, 13)
canvas:Foreground(cd.BLUE)
canvas:Line(3, 7, 11, 7)
canvas:Line(3, 7, 3, 15)
canvas:Line(3, 15, 11, 15)
canvas:Line(11, 15, 11, 7)
canvas:Activate()
w,h=canvas:GetSize()
image=im.ImageCreate(w,h,im.RGB,im.BYTE)
image:cdCanvasGetImage(canvas,0,0)
image:Save(path .. "\\" .. "wb_img\\plusnode.png","PNG") --.jpg, "JPG" --.png, "PNG" --.bmp,"BMP"
canvas:Kill()
--]]

----[[draw image for needed purpose --https://www.tecgraf.puc-rio.br/cd/ Screeshots Lua Source Code
--CD > Guide > Samples > Lua Samples > To draw in a RGB image in CDLua for Lua 5:
w=21
h=19
bitmap = cd.CreateBitmap(w,h,cd.RGB)
canvas = cd.CreateCanvas(cd.IMAGERGB, bitmap)
canvas:Foreground(cd.BLUE)
canvas:Box(3,10,11,10)
canvas:Box(10,17,7,6)
canvas:Activate()
w,h=canvas:GetSize()
image=im.ImageCreate(w,h,im.RGB,im.BYTE)
image:cdCanvasGetImage(canvas,0,0)
image:Save(path .. "\\" .. "wb_img\\hideall.png","PNG") --.jpg, "JPG" --.png, "PNG" --.bmp,"BMP"
canvas:Kill()
--]]

----[[draw image for needed purpose --https://www.tecgraf.puc-rio.br/cd/ Screeshots Lua Source Code
--CD > Guide > Samples > Lua Samples > To draw in a RGB image in CDLua for Lua 5:
w=21
h=19
bitmap = cd.CreateBitmap(w,h,cd.RGB)
canvas = cd.CreateCanvas(cd.IMAGERGB, bitmap)
canvas:Foreground(cd.BLACK)
canvas:Box(0,20,0,18)
canvas:Foreground(cd.GRAY)
canvas:Box(1,19,1,17)
canvas:Foreground(cd.BLUE)
canvas:Box(3,10,11,10)
canvas:Box(10,17,7,6)
canvas:Activate()
w,h=canvas:GetSize()
image=im.ImageCreate(w,h,im.RGB,im.BYTE)
image:cdCanvasGetImage(canvas,0,0)
image:Save(path .. "\\" .. "wb_img\\hideall_over.png","PNG") --.jpg, "JPG" --.png, "PNG" --.bmp,"BMP"
canvas:Kill()
--]]

----[[draw image for needed purpose --https://www.tecgraf.puc-rio.br/cd/ Screeshots Lua Source Code
--CD > Guide > Samples > Lua Samples > To draw in a RGB image in CDLua for Lua 5:
w=21
h=19
bitmap = cd.CreateBitmap(w,h,cd.RGB)
canvas = cd.CreateCanvas(cd.IMAGERGB, bitmap)
canvas:Foreground(cd.BLACK)
canvas:Box(0,20,0,18)
canvas:Foreground(cd.GRAY)
canvas:Box(1,19,1,17)
canvas:Foreground(cd.BLUE)
canvas:Box(3,10,11,10)
canvas:Box(6,7,14,7)
canvas:Box(10,17,7,6)
canvas:Box(13,14,10,3)
canvas:Activate()
w,h=canvas:GetSize()
image=im.ImageCreate(w,h,im.RGB,im.BYTE)
image:cdCanvasGetImage(canvas,0,0)
image:Save(path .. "\\" .. "wb_img\\showall_over.png","PNG") --.jpg, "JPG" --.png, "PNG" --.bmp,"BMP"
canvas:Kill()
--]]

----[[draw image for needed purpose --https://www.tecgraf.puc-rio.br/cd/ Screeshots Lua Source Code
--CD > Guide > Samples > Lua Samples > To draw in a RGB image in CDLua for Lua 5:
w=21
h=19
bitmap = cd.CreateBitmap(w,h,cd.RGB)
canvas = cd.CreateCanvas(cd.IMAGERGB, bitmap)
canvas:Foreground(cd.BLUE)
canvas:Box(3,10,11,10)
canvas:Box(6,7,14,7)
canvas:Box(10,17,7,6)
canvas:Box(13,14,10,3)
canvas:Activate()
w,h=canvas:GetSize()
image=im.ImageCreate(w,h,im.RGB,im.BYTE)
image:cdCanvasGetImage(canvas,0,0)
image:Save(path .. "\\" .. "wb_img\\showall.png","PNG") --.jpg, "JPG" --.png, "PNG" --.bmp,"BMP"
canvas:Kill()
--]]


