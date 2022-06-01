--echo this script opens a tree in Luajava
--cd\ & cd Tree & cd Luajava_Tree & C:\jdk-16.0.2\bin\java.exe -classpath C:\Tree\LuaJ_Tree\Tree.jar lua Tree_Luajava_Windows.lua

--1. read input tree
dofile("C:\\Tree\\Luajava_Tree\\Tree_Luajava_output_Tree.lua")

--1.1 dynamic collection of data for the tree
dynamischer_Tree={branchname="Dynamik"}
--[[simple collection:
p=io.popen('cmd /r dir C:\\Tree\\Luajava_Tree\\*.* /b/o/s')
for line in p:lines() do
	dynamischer_Tree[#dynamischer_Tree+1]=line
end --for line in p:lines() do
--]]

--1.1.1 function for collection without the files and directories being in manual tree
function readTreetohtmlRecursive(TreeTable)
	AusgabeTabelle[TreeTable.branchname]=true
	for k,v in ipairs(TreeTable) do
		if type(v)=="table" then
			readTreetohtmlRecursive(v)
		else
			AusgabeTabelle[v]=true
		end--if type(v)=="table" then
	end --for k,v in ipairs(TreeTable) do
end --readTreetohtmlRecursive(TreeTable)
  
--1.1.2 collection of tree data by applying the recursive function
AusgabeTabelle={}
readTreetohtmlRecursive(Tree)
--1.1.3 collect data about files and directories on the device not being in the manual tree
os.execute('cmd /r dir C:\\Tree\\Luajava_Tree\\* /b/o/s >C:\\Tree\\Luajava_Tree\\dir_Temp.txt')
AnzahlDateien=0
for line in io.lines("C:\\Tree\\Luajava_Tree\\dir_Temp.txt") do
	if AusgabeTabelle[line] == nil then
		dynamischer_Tree[#dynamischer_Tree+1]=line
		AnzahlDateien=AnzahlDateien+1
	end --if AusgabeTabelle[line] == nil then
end --for line in io.lines("/mnt/sdcard/Tree/dir_Temp.txt") do
print("Anzahl Dateien: " .. AnzahlDateien)

--1.2 put dynamic in the tree
Tree[#Tree+1]=dynamischer_Tree

--2. border Layout
borderLayout=luajava.bindClass("java.awt.BorderLayout")

--3. class for the frame
jframe=luajava.bindClass("javax.swing.JFrame")

--3.1 build the frame and get content
frame=luajava.newInstance("javax.swing.JFrame","Neue Oberflaeche")
content=frame:getContentPane()

--4. constants for the GUI
scrollpaneconstants=luajava.bindClass("javax.swing.ScrollPaneConstants")
v = scrollpaneconstants.VERTICAL_SCROLLBAR_AS_NEEDED
h = scrollpaneconstants.HORIZONTAL_SCROLLBAR_AS_NEEDED

--5. text areas
--5.1 text area for search text and to change the tree with
textArea1=luajava.newInstance("javax.swing.JTextArea",'Tree[#Tree+1]={branchname="","",}',10,12)
textArea1:setLineWrap(true);
textArea1:setWrapStyleWord(true);
jsp2 = luajava.newInstance("javax.swing.JScrollPane", textArea1,v,h)
content:add(jsp2,borderLayout.EAST)

--5.2 text area for search results and examples for changing the tree
textArea2=luajava.newInstance("javax.swing.JTextArea",'Tree[#Tree+1]={branchname="","",}\nTree[][]=""\nTree[]=nil\nfor i=3,#Tree do Tree[i-1]=Tree[i] end Tree[#Tree]=nil\ntable.insert(Tree,3,{branchname="Neu","neues Blatt"})',10,84)
textArea2:setLineWrap(false);
textArea2:setWrapStyleWord(false);
jsp3 = luajava.newInstance("javax.swing.JScrollPane", textArea2,v,h)
content:add(jsp3,borderLayout.SOUTH)

--6. buttons
--6.1 button for changing the tree
button1=luajava.newInstance("javax.swing.JButton","Baum gestalten")
button1:addMouseListener(luajava.createProxy("java.awt.event.MouseListener",{
	mousePressed=function(e) 
		local changeText="no"
		LoadText=textArea1:getText()
		LoadText=LoadText:gsub("\\", "\\\\")
		--test with: print(LoadText)
		if LoadText:match('^for i=%d,#Tree do Tree%[i%-1%]=Tree%[i%] end Tree.*=nil$') then 
			load(LoadText)() changeText="yes"
		elseif LoadText:match('^table.insert%(Tree,.*,.*%)$') then 
			load(LoadText)() changeText="yes"
		elseif LoadText:match('^Tree.*=nil$') then 
			load(LoadText)() changeText="yes"
		elseif LoadText:match('^Tree.*=".*"$') then 
			load(LoadText)() changeText="yes"
		elseif LoadText:match('^Tree.*={branchname=".*".*}$') then 
			load(LoadText)() changeText="yes"
		end --if LoadText:match("^Tree.*=") then
		if changeText=="yes" then
			--get paths with Lua technique
			outputfile1=io.open("C:\\Tree\\Luajava_Tree\\Tree_Luajava_output.txt","w")
			outputfile_tree=io.open("C:\\Tree\\Luajava_Tree\\Tree_Luajava_output_Tree.lua","w")
			outputfile_tree:write('Tree=')
			pathTable={}
			function searchTreeRecursive(TreeTable)
				pathTable[#pathTable+1]=TreeTable.branchname
				outputfile_tree:write('{branchname="' .. TreeTable.branchname:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n") .. '",\n')
				for i,v in ipairs(pathTable) do 
					--test with: print(i,v) 
					outputfile1:write(v:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n") .. "->")
				end --for i,v in ipairs(pathTable) do 
				outputfile1:write("\n")
				for i,v in ipairs(TreeTable) do 
					if type(v)=="table" then
						searchTreeRecursive(v)
					else
						for i1,v1 in ipairs(pathTable) do 
							--test with: print(i1,v1) 
							outputfile1:write(v1:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n") .. "->")
						end --for i1,v1 in ipairs(pathTable) do 
						--test with: print(v)
						outputfile1:write(v:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n") .. "\n")
						outputfile_tree:write('"' .. v:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n") .. '",\n')
					end --if type(v)=="table" then
				end --for i,v in ipairs(TreeTable) do  
				pathTable[#pathTable]=nil
				if #pathTable==0 then
					outputfile_tree:write('}\n')
				else
					outputfile_tree:write('},\n')
				end --if #pathTable==0 then
			end --function searchTreeRecursive(TreeTable)
			searchTreeRecursive(Tree)
			outputfile1:close()
			outputfile_tree:close()
			--restart the GUI 
			os.execute("C:\\Tree\\Luajava_Tree\\Tree_Luajava_start.bat") 
			os.exit()
		end --if changeText=="yes" then
	end, --mousePressed=function(e) 
	--mouseClicked=function(e) print("Clicked") end,
})) --addMouseListener(luajava.createProxy("java.awt.event.MouseListener"
content:add(button1,borderLayout.NORTH)

--6.2 button for search in tree with paths as result
button2=luajava.newInstance("javax.swing.JButton","Suche der Pfade")
button2:addMouseListener(luajava.createProxy("java.awt.event.MouseListener",{
	mousePressed=function(e) 
		searchText=textArea1:getText()
		resultText=""
		--for k,v in pairs(TreeContentTable) do if v:match(searchText) then print(k,v) end end
		for line in io.lines("C:\\Tree\\Luajava_Tree\\Tree_Luajava_output.txt") do
			if line:match(searchText) then
				resultText=resultText .. line .. "\n"
			end --if line:match(searchText) then
		end --for line in io.lines("C:\\Tree\\Luajava_Tree\\Tree_Luajava_output.txt") do
		textArea2:setText(resultText)
	end, --mousePressed=function(e) 
--mouseClicked=function(e) print("Clicked") end,
})) --addMouseListener(luajava.createProxy("java.awt.event.MouseListener"
content:add(button2,borderLayout.WEST)


--7. build recursively the tree
TreeContentTable={}
function readTreeRecursive(TreeTable,javaTreeTable)
	javaTreeTable.branchname=javaTreeTable.branchname or luajava.newInstance("javax.swing.tree.DefaultMutableTreeNode",TreeTable.branchname)
	TreeContentTable[#TreeContentTable+1]=TreeTable.branchname
	for i,v in ipairs(TreeTable) do 
		if type(v)=="table" then
			--new table
			javaTreeTable[i]={}
			javaTreeTable[i].branchname=luajava.newInstance("javax.swing.tree.DefaultMutableTreeNode",v.branchname)
			javaTreeTable.branchname:add(javaTreeTable[i].branchname)
			readTreeRecursive(v,javaTreeTable[i])
		else
			javaTreeTable[i]=luajava.newInstance("javax.swing.tree.DefaultMutableTreeNode",v)
			javaTreeTable.branchname:add(javaTreeTable[i])
			TreeContentTable[#TreeContentTable+1]=v
		end --if type(v)=="table" then
	end --for i,v in ipairs(TreeTable) do  
end --function readTreeRecursive(TreeTable)
javaTree={}
readTreeRecursive(Tree,javaTree)
tree1=luajava.newInstance("javax.swing.JTree",javaTree.branchname)
tree1:setEditable(true)

--7.1 Mouse listener for the tree to start programms
tree1:addMouseListener(luajava.createProxy("java.awt.event.MouseListener",{
	mousePressed=function(e) 
		if e:getClickCount()==2 then 
			if tree1:getLastSelectedPathComponent() and tostring(tree1:getLastSelectedPathComponent()):match("^.:\\.*%.lua") then
				os.execute('notepad.exe ' .. tostring(tree1:getLastSelectedPathComponent()))
				textArea1:setText('open ' .. tostring(tree1:getLastSelectedPathComponent()))
			elseif tree1:getLastSelectedPathComponent() and tostring(tree1:getLastSelectedPathComponent()):match("^.:\\.*") then
				os.execute('explorer.exe ' .. tostring(tree1:getLastSelectedPathComponent()))
				textArea1:setText('open ' .. tostring(tree1:getLastSelectedPathComponent()))
			elseif tree1:getLastSelectedPathComponent() then
				textArea1:setText('do not open ' .. tostring(tree1:getLastSelectedPathComponent()))
			end --if tree1:getLastSelectedPathComponent() then
		end --if e:getClickCount()==2 then 
	end, --mousePressed=function(e) 
})) --addMouseListener(luajava.createProxy("java.awt.event.MouseListener"

--7.2 write out the paths in file
outputfile1=io.open("C:\\Tree\\Luajava_Tree\\Tree_Luajava_output.txt","w")
pathTable={}
function searchTreeRecursivePath(TreeTable)
	pathTable[#pathTable+1]=TreeTable.branchname
	for i,v in ipairs(pathTable) do 
		--test with: print(i,v) 
		outputfile1:write(v .. "->")
	end --for i,v in ipairs(pathTable) do 
	outputfile1:write("\n")
	for i,v in ipairs(TreeTable) do 
		if type(v)=="table" then
			searchTreeRecursivePath(v)
		else
			for i1,v1 in ipairs(pathTable) do 
				--test with: print(i1,v1) 
				outputfile1:write(v1 .. "->")
			end --for i1,v1 in ipairs(pathTable) do 
			--test with: print(v)
			outputfile1:write(v .. "\n")
		end --if type(v)=="table" then
	end --for i,v in ipairs(TreeTable) do  
	pathTable[#pathTable]=nil
end --function searchTreeRecursivePath(TreeTable)
searchTreeRecursivePath(Tree)
outputfile1:close()

--7.3 tree in scrollpane added to content
jsp1 = luajava.newInstance("javax.swing.JScrollPane",tree1,v,h)
content:add(jsp1,borderLayout.CENTER);

--7.4 show the frame
frame:setDefaultCloseOperation(jframe.EXIT_ON_CLOSE)
frame:setSize(900,600)
frame:setVisible(true)
