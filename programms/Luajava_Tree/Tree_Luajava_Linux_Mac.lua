--java -classpath /Tree/luaj-jse-3.0.1.jar lua /Tree/Luajava_Tree/Tree_Luajava_Linux.lua &

--1. tree as a Lua table
--[[
Tree={branchname="Oberster Knoten",
{branchname="java -classpath /Tree/luaj-jse-3.0.1.jar lua /Tree/dir_rename.lua",
"/Volumes/Untitled/Transfer",
},
{branchname="java -classpath /Tree/luaj-jse-3.0.1.jar lua /Users/kaiser/Documents/Bruno/luaStartSkript.txt",
"/Tree/Tree_Baum.html",
"/Tree/Tree_Baum.lua",
},

{branchname='java -classpath /Tree/luaj-jse-3.0.1.jar lua /Tree/Tree_Baum_html_Kategorien.lua',
'/Tree/Tree_Baum_Kategorien.html',
"/Tree/Tree_Baum_html_Kategorien.lua",
},

{branchname="Externe Speicher","/Volumes/Untitled/Transfer",},
"/Tree/Tree.java",
"WEITER Erstellen der Datei /Tree/Luajava_Tree/Tree_Luajava_output.txt, dann suche man in dieser nach dem Suchtext und gebe das Ergebnis in den textArea1.",

}
--]]
--1. take tree from file
dofile("/Tree/Luajava_Tree/Tree_Luajava_output_Tree.lua")

--2. border Layout
borderLayout=luajava.bindClass("java.awt.BorderLayout")

--3. class for the frame
jframe=luajava.bindClass("javax.swing.JFrame")

--3.1 build the frame and get content
frame=luajava.newInstance("javax.swing.JFrame","Neue Oberflaeche")
content=frame:getContentPane()

--3.2 constants
scrollpaneconstants=luajava.bindClass("javax.swing.ScrollPaneConstants")
v = scrollpaneconstants.VERTICAL_SCROLLBAR_AS_NEEDED
h = scrollpaneconstants.HORIZONTAL_SCROLLBAR_AS_NEEDED

--3.3 functions in functionTable
functionTable={
["Berechnen"]=function()
model= tree1:getModel()
--test with: print(model)
load("ErgebnisText=" .. tostring(javaTree[7][1]))()
--test with: ErgebnisText= javaTree[7][1]
newNode = luajava.newInstance("javax.swing.tree.DefaultMutableTreeNode",tostring(ErgebnisText))
nodeKnoten=javaTree[7][2].branchname
model:insertNodeInto(newNode, nodeKnoten, 0)
textArea1:setText(tostring(ErgebnisText))
print("Ergebnis: " .. tostring(ErgebnisText))
textArea2:setText([[
Tree[7]={branchname="Formel","]] .. tostring(javaTree[7][1]) .. [[",
{branchname="Berechnen","]] .. tostring(ErgebnisText) .. [[",}}
]])
end,
["Baumprogramme"]=function() ErgebnisText ="" p=io.popen('ls /Tree') for line in p:lines() do print(line) if ErgebnisText=="" then ErgebnisText= "/Tree/" .. tostring(line) else ErgebnisText= ErgebnisText .. "\n/Tree/" .. tostring(line) end end 
textArea1:setText("p=io.popen('ls /Tree')")
textArea2:setText(ErgebnisText) 
end,
["Oberster Knoten"]=function()
textArea1:setText('Tree[#Tree+1]={branchname="","",}')
textArea2:setText('Tree[#Tree+1]={branchname="","",}\nTree[][]=""\nTree[]=nil\nfor i=3,#Tree do Tree[i-1]=Tree[i] end Tree[#Tree]=nil\ntable.insert(Tree,3,{branchname="Neu","neues Blatt"})')
end,
} --functionTable={


--4. text areas
--4.1 text area for search text and to change the tree with
textArea1=luajava.newInstance("javax.swing.JTextArea",'Tree[#Tree+1]={branchname="","",}',10,12)
textArea1:setLineWrap(true);
textArea1:setWrapStyleWord(true);
jsp2 = luajava.newInstance("javax.swing.JScrollPane", textArea1,v,h)
content:add(jsp2,borderLayout.EAST)

--4.2 text area for search results and examples for changing the tree
textArea2=luajava.newInstance("javax.swing.JTextArea",'Tree[#Tree+1]={branchname="","",}\nTree[][]=""\nTree[]=nil\nfor i=3,#Tree do Tree[i-1]=Tree[i] end Tree[#Tree]=nil\ntable.insert(Tree,3,{branchname="Neu","neues Blatt"})',10,84)
textArea2:setLineWrap(false);
textArea2:setWrapStyleWord(false);
jsp3 = luajava.newInstance("javax.swing.JScrollPane", textArea2,v,h)
content:add(jsp3,borderLayout.SOUTH)

--5. buttons
--5.1 button for changing the tree
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
			outputfile1=io.open("/Tree/Luajava_Tree/Tree_Luajava_output.txt","w")
			outputfile_tree=io.open("/Tree/Luajava_Tree/Tree_Luajava_output_Tree.lua","w")
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
			os.execute("java -classpath /Tree/luaj-jse-3.0.1.jar lua /Tree/Luajava_Tree/Tree_Luajava_Linux.lua") 
			os.exit()
		end --if changeText=="yes" then
	end, --mousePressed=function(e) 
	--mouseClicked=function(e) print("Clicked") end,
})) --addMouseListener(luajava.createProxy("java.awt.event.MouseListener"
content:add(button1,borderLayout.NORTH)

--5.2 button for search in tree with paths as result
button2=luajava.newInstance("javax.swing.JButton","Suche der Pfade")
button2:addMouseListener(luajava.createProxy("java.awt.event.MouseListener",{
	mousePressed=function(e) 
		searchText=textArea1:getText()
		resultText=""
		--for k,v in pairs(TreeContentTable) do if v:match(searchText) then print(k,v) end end
		for line in io.lines("/Tree/Luajava_Tree/Tree_Luajava_output.txt") do
			if line:match(searchText) then
				resultText=resultText .. line .. "\n"
			end --if line:match(searchText) then
		end --for line in io.lines("/Tree/Luajava_Tree/Tree_Luajava_output.txt") do
		textArea2:setText(resultText)
	end, --mousePressed=function(e) 
--mouseClicked=function(e) print("Clicked") end,
})) --addMouseListener(luajava.createProxy("java.awt.event.MouseListener"
content:add(button2,borderLayout.WEST)


--6. build recursively the tree
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

--6.1 Mouse listener for the tree to start programms
tree1:addMouseListener(luajava.createProxy("java.awt.event.MouseListener",{
	mousePressed=function(e) 
		if e:getClickCount()==2 then 
			if tree1:getLastSelectedPathComponent() and tostring(tree1:getLastSelectedPathComponent()):match("^/") then
				os.execute('open ' .. tostring(tree1:getLastSelectedPathComponent()))
				textArea1:setText('open ' .. tostring(tree1:getLastSelectedPathComponent()))
			elseif tree1:getLastSelectedPathComponent() and tostring(tree1:getLastSelectedPathComponent()):match("^java %-classpath /Tree/luaj%-jse%-3.0.1.jar lua ") then
				os.execute(tostring(tree1:getLastSelectedPathComponent()))
				textArea1:setText(tostring(tree1:getLastSelectedPathComponent()))
			elseif tree1:getLastSelectedPathComponent() and functionTable[tostring(tree1:getLastSelectedPathComponent())] then
				textArea1:setText('execute function ' .. tostring(tree1:getLastSelectedPathComponent()))
				--execute stored function
				functionTable[tostring(tree1:getLastSelectedPathComponent())]() 
				--test with: functionTable["Externe Speicher"]()
			elseif tree1:getLastSelectedPathComponent() then
				textArea1:setText('do not open ' .. tostring(tree1:getLastSelectedPathComponent()))
			end --if tree1:getLastSelectedPathComponent() then
		end --if e:getClickCount()==2 then 
	end, --mousePressed=function(e) 
})) --addMouseListener(luajava.createProxy("java.awt.event.MouseListener"

--6.2 write out the paths in file
outputfile1=io.open("/Tree/Luajava_Tree/Tree_Luajava_output.txt","w")
pathTable={}
function searchTreeRecursive(TreeTable)
	pathTable[#pathTable+1]=TreeTable.branchname
	for i,v in ipairs(pathTable) do 
		--test with: print(i,v) 
		outputfile1:write(v .. "->")
	end --for i,v in ipairs(pathTable) do 
	outputfile1:write("\n")
	for i,v in ipairs(TreeTable) do 
		if type(v)=="table" then
			searchTreeRecursive(v)
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
end --function searchTreeRecursive(TreeTable)
searchTreeRecursive(Tree)
outputfile1:close()

--7. tree in scrollpane added to content
jsp1 = luajava.newInstance("javax.swing.JScrollPane",tree1,v,h)
content:add(jsp1,borderLayout.CENTER);



--8. show the frame
frame:setDefaultCloseOperation(jframe.EXIT_ON_CLOSE)
frame:setSize(900,400)
frame:setVisible(true)
