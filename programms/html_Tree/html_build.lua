--This programm builds a tree from /mnt/sdcard/Tree/Tree_Baum.lua and from the Linux-command ls -R recursiv of the files and directories on the device, which ar not in the Tree_Baum.lua

--1. read input tree
dofile("C:\\Tree\\html_Tree\\Tree_Baum.lua")
--test with: print(Tree[1][1][2])
outputfile1=io.open("C:\\Tree\\html_Tree\\Tree_Baum.html","w")
outputfile1:write('<font size="5"> ')

--2.1 function to build recursively the tree
function readTreetohtmlRecursive(TreeTable)
	AusgabeTabelle[TreeTable.branchname]=true
	outputfile1:write("<ul><li>" ..
	tostring(TreeTable.branchname)
	:gsub("ä","&auml;")
	:gsub("Ä","&Auml;")
	:gsub("ö","&ouml;")
	:gsub("Ö","&Ouml;")
	:gsub("ü","&uuml;")
	:gsub("Ü","&Uuml;")
	:gsub("ß","&szlig;")
	.. "\n")
	for k,v in ipairs(TreeTable) do
		if type(v)=="table" then
			readTreetohtmlRecursive(v)
		else
			AusgabeTabelle[v]=true
			outputfile1:write("<ul><li>" .. v
				:gsub("ä","&auml;")
				:gsub("Ä","&Auml;")
				:gsub("ö","&ouml;")
				:gsub("Ö","&Ouml;")
				:gsub("ü","&uuml;")
				:gsub("Ü","&Uuml;")
				:gsub("ß","&szlig;")
				.. "</li></ul>" .. "\n")
		end --if type(v)=="table" then
	end --for k, v in ipairs(TreeTable) do
	outputfile1:write("</li></ul>" .. "\n")
end --readTreetohtmlRecursive(TreeTable)
  
--2.2 apply the recursive function and build html file
AusgabeTabelle={}
readTreetohtmlRecursive(Tree)

--3. collect data about files and directories on the device
os.execute('dir C:\\Tree\\html_Tree\\* /b/o/s >C:\\Tree\\html_Tree\\dir_Temp.txt')
AnzahlDateien=0
outputfile1:write("<ul><li>" .. "Ordnerinhalte".. "\n")
for line in io.lines("C:\\Tree\\html_Tree\\dir_Temp.txt") do
	if AusgabeTabelle[line] == nil then
		outputfile1:write("<br>" .. line .. "\n")
		AnzahlDateien=AnzahlDateien+1
	end --if AusgabeTabelle[line] == nil then
end --for line in io.lines("/mnt/sdcard/Tree/dir_Temp.txt") do
outputfile1:write("</li></ul>".. "\n")
outputfile1:close()
print("Anzahl Dateien: " .. AnzahlDateien)