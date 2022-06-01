--This script builds a tree from a Lua table and puts the child nodes in parenthesis to the node if child nodes are not http site adresses

--1. read input tree
dofile("C:\\Tree\\html_Tree\\Tree_Baum_node_content.lua")
--test with: print(Tree[1][1][2])
outputfile1=io.open("C:\\Tree\\html_Tree\\Tree_Baum_node_content.html","w")
outputfile1:write('<font size="5"> ')

--2.1 function to build recursively the tree
function readTreetohtmlRecursive(TreeTable)
	if TreeTable.branchname:match("^http")==nil then
		AusgabeTabelle[TreeTable.branchname]=TreeTable.branchname .. " ("
	end --if TreeTable.branchname:match("^http")==nil then
	for k,v in ipairs(TreeTable) do
		if type(v)=="table" then
			if TreeTable.branchname:match("^http")==nil and v.branchname:match("^http")==nil then
				AusgabeTabelle[TreeTable.branchname]=AusgabeTabelle[TreeTable.branchname] .. v.branchname .. ", "
			end --if TreeTable.branchname:match("^http")==nil then
		else
			if TreeTable.branchname:match("^http")==nil and v:match("^http")==nil then
				AusgabeTabelle[TreeTable.branchname]=AusgabeTabelle[TreeTable.branchname] .. v .. ", "
			end --if TreeTable.branchname:match("^http")==nil then
		end --if type(v)=="table" then
	end --for k, v in ipairs(TreeTable) do
	--write modified or unmodified branchname
	if AusgabeTabelle[TreeTable.branchname] and AusgabeTabelle[TreeTable.branchname]:match("%($")==nil then
		outputfile1:write("<ul><li>" ..
		tostring(AusgabeTabelle[TreeTable.branchname]:gsub(", $",")"):gsub("([^%(]*)(%(.*%))","<b>%1</b><i>%2</i>"))
							:gsub("�","&auml;")
							:gsub("ä","&auml;")
							:gsub("�","&Auml;")
							:gsub("Ä","&Auml;")
							:gsub("�","&ouml;")
							:gsub("ö","&ouml;")
							:gsub("�","&Ouml;")
							:gsub("Ö","&Ouml;")
							:gsub("�","&uuml;")
							:gsub("ü","&uuml;")
							:gsub("�","&Uuml;")
							:gsub("Ü","&Uuml;")
							:gsub("�","&szlig;")
							:gsub("ß","&szlig;")
							.. "\n")
	else
		local TreeTable_branchname_link=TreeTable.branchname
		if TreeTable.branchname:match("^http") then TreeTable_branchname_link='<a href="' .. TreeTable.branchname .. '">' .. TreeTable.branchname .. '</a>' end
		outputfile1:write("<ul><li>" ..
		tostring(TreeTable_branchname_link)
					:gsub("�","&auml;")
					:gsub("ä","&auml;")
					:gsub("�","&Auml;")
					:gsub("Ä","&Auml;")
					:gsub("�","&ouml;")
					:gsub("ö","&ouml;")
					:gsub("�","&Ouml;")
					:gsub("Ö","&Ouml;")
					:gsub("�","&uuml;")
					:gsub("ü","&uuml;")
					:gsub("�","&Uuml;")
					:gsub("Ü","&Uuml;")
					:gsub("�","&szlig;")
					:gsub("ß","&szlig;")
					.. "\n")
	end --if AusgabeTabelle[TreeTable.branchname]:match("%($")==nil then
	--go to the recursion
	for k,v in ipairs(TreeTable) do
		if type(v)=="table" then
			readTreetohtmlRecursive(v)
		else
			local v_link=v
			if v:match("^http") then v_link='<a href="' .. v .. '">' .. v .. '</a>' end
			outputfile1:write("<ul><li>" .. v_link
					:gsub("�","&auml;")
					:gsub("ä","&auml;")
					:gsub("�","&Auml;")
					:gsub("Ä","&Auml;")
					:gsub("�","&ouml;")
					:gsub("ö","&ouml;")
					:gsub("�","&Ouml;")
					:gsub("Ö","&Ouml;")
					:gsub("�","&uuml;")
					:gsub("ü","&uuml;")
					:gsub("�","&Uuml;")
					:gsub("Ü","&Uuml;")
					:gsub("�","&szlig;")
					:gsub("ß","&szlig;")
					.. "</li></ul>" .. "\n")
		end --if type(v)=="table" then
	end --for k, v in ipairs(TreeTable) do
	outputfile1:write("</li></ul>" .. "\n")
end --readTreetohtmlRecursive(TreeTable)

--2.2 apply the recursive function and build html file
AusgabeTabelle={}
readTreetohtmlRecursive(Tree)
outputfile1:close()
