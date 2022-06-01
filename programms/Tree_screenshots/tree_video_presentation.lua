--This script shows a tree with a video taken from the camera

--1. basic data
--1.1 tree as Lua table
lua_tree_output={ branchname="table of contents of the presentation", 
{ branchname="Video presentation", 
{ branchname="file of the presentation", 
state="COLLAPSED",
},
},
{ branchname="content",
"introduction",
"main part",
"final statements",


}}--lua_tree_output

--1.1.1 libraries for video and GUI
local im = require("imlua") --for images
require("imlua_capture") --library for video camera
local gl = require("luagl") --library for video camera
local iup = require("iuplua")           --require iuplua for GUIs
require("iupluagl") --library for video camera

--require("imlua_wmv") --format .WMV for saving video
require("imlua_avi") --format .AVI for saving video


--1.1.2 securisation by allowing only necessary os.execute commands
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
		a:lower():match("^start ") 
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

--2.1 build the video

--2.1.1 optional save video
--ifile = im.FileNew("C:\\Temp\\videocapture_makevideo.avi", "AVI") --"WMV")
--ifile:SetAttribute("FPS", im.FLOAT, {15}) -- Frames per second

--2.1.2 capture video and connect to camera
local vc = im.VideoCaptureCreate()
if (not vc) then
  error("ERROR: No capture device found!")
end --if (not vc) then
if (vc:Connect(0) == 0) then
  error("ERROR: Fail to connect to capture device")
end --if (vc:Connect(0) == 0) then

--2.1.3 get image from camera
local capw, caph = vc:GetImageSize()
local initimgsize = string.format("%ix%i", capw, caph)
local frbuf = im.ImageCreate(capw, caph, im.RGB, im.BYTE)
local gldata, glformat = frbuf:GetOpenGLData()

--2.1.4 set canvas with automatic size or manual size
--cnv = iup.glcanvas{buffer="DOUBLE", rastersize = initimgsize,}
--
cnv = iup.glcanvas{buffer="DOUBLE", rastersize = "1200x600",}

--3 functions

--3.1 general Lua functions

--3.1.1 function checking if file exits
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end --function file_exists(name)

--3.2 special video functions
--3.2.1 function to resize canvas
function cnv:resize_cb(width, height)
  iup.GLMakeCurrent(self)
  gl.Viewport(0, 0, width, height)
end

--3.2.2 function to build video in canvas
function cnv:action(x, y)
	iup.GLMakeCurrent(self)
	gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)
	gldata, glformat = frbuf:GetOpenGLData() --update the data
	gl.DrawPixelsRaw (capw, caph, glformat, gl.UNSIGNED_BYTE, gldata)
	--function got from example file glcanvas.lua und glcanvas2.lua
	-- gl.ClearColor(1.0, 1.0, 1.0, 1.0)
	-- gl.Clear(gl.COLOR_BUFFER_BIT)
	-- gl.Clear(gl.DEPTH_BUFFER_BIT)
	--[[projection:
	gl.MatrixMode( gl.PROJECTION )
	gl.Viewport(0, 0, 300, 300)
	gl.LoadIdentity()
	gl.Begin( gl.LINES )
	gl.Color(1.0, 0.0, 0.0)
	gl.Vertex(0.5, 0.5)
	gl.Vertex(2.0, 1.0)
	gl.End()
	--]]
	----[[ draw rectangle
	gl.Color(1.0, 0.8, 0.9)
	gl.Rect(-1,-1,1,-0.7) --bottom
	gl.Rect(-1,-1,-0.4,1) --left
	gl.Rect(-1,0.9,1,1) --top
	gl.Rect(0.4,-1,1,1) --right
	--]]
	iup.GLSwapBuffers(self)
end --function cnv:action(x, y)


--4. no dialogs

--4.1 set video live
vc:Live(1)


--5.1 menu of tree

--5.1.1 start file of node of tree in IUP Lua scripter or start empty file in notepad or start empty scripter
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

--5.1.2 start the file or repository of the node of tree
startnode = iup.item {title = "Starten"}
function startnode:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "D" "' .. tree['title'] .. '"') 
	elseif tree['title']:match("sftp .*") then 
		os.execute(tree['title']) 
	end --if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
end --function startnode:action()

--5.1.3 put the menu items together in the menu for tree
menu = iup.menu{
		startnodescripter,
		startnode, 
		}
--5.1 menu of tree end

--6. no buttons
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

--7. Main Dialog

--7.1 load tree from self file
actualtree=lua_tree_output
--build tree
tree=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree)
end, --function(self)
SIZE="200x70",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}
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
	if c == iup.K_Menu then
		menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function tree:k_any(c)

--7.2 building the dialog and put trees and video together
local maindlg = iup.dialog{title = "Video presentation", 
iup.vbox{
iup.hbox{tree,},
iup.scrollbox{cnv}},size="300xFULL",icon=img_logo}

--7.3 variable for loop
local in_loop = true

--7.4 close Main Dialog
function maindlg:close_cb()
  in_loop = false
end

--7.5 function for keys pressed in main dialog for full screen and closing
function maindlg:k_any(c)
	if c == iup.K_q or c == iup.K_ESC then
		return iup.CLOSE
	end --if c == iup.K_q or c == iup.K_ESC then
	if c == iup.K_F1 then
		if fullscreen then
			fullscreen = false
			maindlg.fullscreen = "No"
		else
			fullscreen = true
			maindlg.fullscreen = "Yes"
		end --if fullscreen then
	iup.SetFocus(cnv)
	end --if c == iup.K_F1 then
end --function maindlg:k_any(c)

--7.6 show the dialog
maindlg:showxy(iup.LEFT,iup.BOTTOM)
iup.SetFocus(cnv)

--7.7 Main Loop
while in_loop do
	vc:Frame(frbuf,-1)
	iup.Update(cnv)
	--optional: save video
	--ifile:SaveImage(frbuf)
	local result = iup.LoopStep()
	if result == iup.CLOSE then
		--optional: close saved video
		--ifile:Close()
		in_loop = false
	end --if result == iup.CLOSE then
end --while in_loop do

--7.8 close Main Dialog
vc:Live(0)
vc:Disconnect()
vc:Destroy()
