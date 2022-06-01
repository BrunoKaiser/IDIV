--java -classpath /Tree/luaj-jse-3.0.1.jar lua /Tree/Luajava_Tree/Tree_Luajava_Linux_directory.lua &

--1. read input tree
dofile("/Tree/Luajava_Tree/Tree_Luajava_output_Tree.lua")

--1.1 original repository
originalRepository="/Tree/Luajava_Tree"

--1.2 goal repository
goalRepository="/Volumes/NO_NAME/Tree/Luajava_Tree"

--2. border Layout
borderLayout=luajava.bindClass("java.awt.BorderLayout")

--3. class for the frame
jframe=luajava.bindClass("javax.swing.JFrame")

--3.1 build the frame and get content
frame=luajava.newInstance("javax.swing.JFrame","IDIV-Ordnervergleich")
content=frame:getContentPane()

--4. constants for the GUI
scrollpaneconstants=luajava.bindClass("javax.swing.ScrollPaneConstants")
v = scrollpaneconstants.VERTICAL_SCROLLBAR_AS_NEEDED
h = scrollpaneconstants.HORIZONTAL_SCROLLBAR_AS_NEEDED


--5. text areas
--5.1 text area for search text and to change the tree with
textArea1=luajava.newInstance("javax.swing.JTextArea",'',2,2)
textArea1:setLineWrap(true);
textArea1:setWrapStyleWord(true);
jsp2 = luajava.newInstance("javax.swing.JScrollPane", textArea1,v,h)
content:add(jsp2,borderLayout.NORTH)

--5.2 text area for search results and examples for changing the tree
--get the difference of both repositories
textArea2Text=""
p=io.popen('diff ' .. originalRepository .. ' ' .. goalRepository)
lineTable={}
for line in p:lines() do
lineTable[#lineTable+1]=line
end --for line in p:lines() do
Tree={branchname="Differenzen"}
Tree[#Tree+1]={branchname="Only in " .. originalRepository}
for i,v in ipairs(lineTable) do
	if v:match("^Only in " .. originalRepository) and v:match("_Version")==nil and v:match("^Only in.*: %.")==nil then 
		textArea2Text= textArea2Text .. "\n" .. v
		Tree[#Tree][#Tree[#Tree]+1]=v:match("Only in " .. originalRepository .. ": (.*)") 
	end --if v:match("^Only in " .. originalRepository) and v:match("_Version")==nil and v:match("^Only in.*: %.")==nil then 
end --for i,v in ipairs(lineTable) do
textArea2Text= textArea2Text .. "\n"
Tree[#Tree+1]={branchname="Only in " .. goalRepository}
for i,v in ipairs(lineTable) do
	if v:match("^Only in " .. goalRepository) and v:match("_Version")==nil and v:match("^Only in.*: %.")==nil then 
		textArea2Text= textArea2Text .. "\n" .. v
		Tree[#Tree][#Tree[#Tree]+1]=v:match("Only in " .. goalRepository .. ": (.*)") 
	end --if v:match("^Only in " .. goalRepository) and v:match("_Version")==nil and v:match("^Only in.*: %.")==nil then 
end --for i,v in ipairs(lineTable) do
textArea2Text= textArea2Text .. "\n"
Tree[#Tree+1]={branchname="Differences in files"}
for i,v in ipairs(lineTable) do
	if v:match("^Only in")==nil and v:match("^diff /.* /.*") and v:match("_Version")==nil and v:match("^Binary files.*/%.")==nil then 
		textArea2Text= textArea2Text .. "\n"
		textArea2Text= textArea2Text .. "\n" .. v
		Tree[#Tree][#Tree[#Tree]+1]={branchname=v}
	elseif v:match("^Only in")==nil and v:match("^diff /.* /.*")==nil and v:match("_Version")==nil and v:match("^Binary files.*/%.")==nil then 
		textArea2Text= textArea2Text .. "\n" .. v
		Tree[#Tree][#Tree[#Tree]][#Tree[#Tree][#Tree[#Tree]]+1]=v
	end --if v:match("^Only in")==nil and v:match("^diff /.* /.*") and v:match("_Version")==nil and v:match("^Binary files.*/%.")==nil then 
end --for i,v in ipairs(lineTable) do
if textArea2Text=="" then textArea2Text="Keine Differenzen festzustellen" end
textArea2=luajava.newInstance("javax.swing.JTextArea", textArea2Text,10,84)
textArea2:setLineWrap(false);
textArea2:setWrapStyleWord(false);

jsp4 = luajava.newInstance("javax.swing.JScrollPane", textArea2,v,h)
content:add(jsp4,borderLayout.SOUTH)

--6. no buttons

--7.1 build recursively the tree
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



--7.2 load tree1 from directory
javaTree2={}
javaTree2.branchname=luajava.newInstance("javax.swing.tree.DefaultMutableTreeNode","Ursprungsordnerinhalt als Baum: " .. originalRepository)
tree2=luajava.newInstance("javax.swing.JTree",javaTree2.branchname)
tree2:setEditable(true)
p=io.popen('ls -l -T -R ' .. originalRepository) --ls -R nur rekursiv, ls -l -T -R rekursiv mit Zeiten im Standardformat
for line in p:lines() do
	if line:match("%..*:") then
		line=line:gsub("%./","." .. originalRepository)
	end --if line:match("%..*:") then
	if line:match("_Version")==nil then
		javaTree2[#javaTree2+1]=luajava.newInstance("javax.swing.tree.DefaultMutableTreeNode",line)
		javaTree2.branchname:add(javaTree2[#javaTree2])
	end --if line:match("_Version")==nil then
end --for line in p:lines() do

--7.3 load tree2 from directory
javaTree3={}
javaTree3.branchname=luajava.newInstance("javax.swing.tree.DefaultMutableTreeNode","Zielordnerinhalt als Baum: " .. goalRepository)
tree3=luajava.newInstance("javax.swing.JTree",javaTree3.branchname)
tree3:setEditable(true)
p=io.popen('ls -l -T -R ' .. goalRepository) --ls -R nur rekursiv, ls -l -T -R rekursiv mit Zeiten im Standardformat
for line in p:lines() do
	if line:match("%..*:") then
		line=line:gsub("%./","." .. goalRepository)
	end --if line:match("%..*:") then
	if line:match("_Version")==nil then
		javaTree3[#javaTree3+1]=luajava.newInstance("javax.swing.tree.DefaultMutableTreeNode",line)
		javaTree3.branchname:add(javaTree3[#javaTree3])
	end --if line:match("_Version")==nil then
end --for line in p:lines() do


--7.4.1 Mouse listener for the tree to start programms
tree2:addMouseListener(luajava.createProxy("java.awt.event.MouseListener",{
	mousePressed=function(e) 
		if e:getClickCount()==2 then 
			if tree2:getLastSelectedPathComponent() and tostring(tree2:getLastSelectedPathComponent()):match("/") then
				os.execute('open ' .. tostring(tree2:getLastSelectedPathComponent()):match("/.*"))
				textArea1:setText('open ' .. tostring(tree2:getLastSelectedPathComponent()):match("/.*"))
			elseif tree2:getLastSelectedPathComponent() then
				textArea1:setText('do not open ' .. tostring(tree1:getLastSelectedPathComponent()))
			end --if tree2:getLastSelectedPathComponent() and tostring(tree2:getLastSelectedPathComponent()):match("/") then
		end --if e:getClickCount()==2 then 
	end, --mousePressed=function(e) 
})) --addMouseListener(luajava.createProxy("java.awt.event.MouseListener"


--7.4.2 Mouse listener for the tree to start programms
tree3:addMouseListener(luajava.createProxy("java.awt.event.MouseListener",{
	mousePressed=function(e) 
		if e:getClickCount()==2 then 
			if tree3:getLastSelectedPathComponent() and tostring(tree3:getLastSelectedPathComponent()):match("/") then
				os.execute('open ' .. tostring(tree3:getLastSelectedPathComponent()):match("/.*"))
				textArea1:setText('open ' .. tostring(tree3:getLastSelectedPathComponent()):match("/.*"))
			elseif tree3:getLastSelectedPathComponent() then
				textArea1:setText('do not open ' .. tostring(tree1:getLastSelectedPathComponent()))
			end --if tree3:getLastSelectedPathComponent() and tostring(tree3:getLastSelectedPathComponent()):match("/") then
		end --if e:getClickCount()==2 then 
	end, --mousePressed=function(e) 
})) --addMouseListener(luajava.createProxy("java.awt.event.MouseListener"



--7.5 tree in scrollpane added to content
jsp1 = luajava.newInstance("javax.swing.JScrollPane",tree1,v,h)
content:add(jsp1,borderLayout.WEST);

jsp2 = luajava.newInstance("javax.swing.JScrollPane",tree2,v,h)
content:add(jsp2,borderLayout.CENTER);

jsp3 = luajava.newInstance("javax.swing.JScrollPane",tree3,v,h)
content:add(jsp3,borderLayout.EAST);


--7.6 show the frame
frame:setDefaultCloseOperation(jframe.EXIT_ON_CLOSE)
frame:setSize(900,400)
frame:setVisible(true)
