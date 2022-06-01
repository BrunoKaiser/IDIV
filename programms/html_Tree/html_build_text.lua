--This script converts in a tree driven manner a tree into a html site. It is an example for tree driven format.

--1. read input tree
dofile("C:\\Tree\\html_Tree\\Tree_Baum_Text.lua")
--test with: print(Tree[1][1][2])
outputfile1=io.open("C:\\Tree\\html_Tree\\Tree_Baum_Text.html","w")
outputfile1:write('<font size="5"> ')

--2.1 function to build recursively the tree
function readTreetohtmlRecursive(TreeTable)
	AusgabeTabelle[TreeTable.branchname]=true
	outputfile1:write("<ul><li>" .. "<b>" .. 
	tostring(TreeTable.branchname)
			:gsub("ä","&auml;")
			:gsub("Ä","&Auml;")
			:gsub("ö","&ouml;")
			:gsub("Ö","&Ouml;")
			:gsub("ü","&uuml;")
			:gsub("Ü","&Uuml;")
			:gsub("ß","&szlig;")
			:gsub("\\n","<br>") 
			.. "</b>" .. "\n")
	for k,v in ipairs(TreeTable) do
		if type(v)=="table" then
			readTreetohtmlRecursive(v)
		else
			AusgabeTabelle[v]=true
			outputfile1:write(v
					:gsub("ä","&auml;")
					:gsub("Ä","&Auml;")
					:gsub("ö","&ouml;")
					:gsub("Ö","&Ouml;")
					:gsub("ü","&uuml;")
					:gsub("Ü","&Uuml;")
					:gsub("ß","&szlig;")
					:gsub("\\n","<br>") .. "\n")
		end --if type(v)=="table" then
	end --for k, v in ipairs(TreeTable) do
	outputfile1:write("</li></ul>" .. "\n")
end --readTreetohtmlRecursive(TreeTable)

--2.2 apply the recursive function and build html file
AusgabeTabelle={}
readTreetohtmlRecursive(Tree)
outputfile1:write("</font>")
outputfile1:close()
