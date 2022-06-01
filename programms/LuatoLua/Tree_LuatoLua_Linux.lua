--java -classpath /Tree/luaj-jse-3.0.1.jar lua /Tree/Tree_LuatoLua.lua

--1. Tree example
Tree={branchname="Test Tree",
{branchname="Node 1",
{branchname="Branch 1",
{branchname="Branch node",
"Leaf 1",
"Leaf 2",} --Branch node
,
{branchname="Node 2",
"Node Test",} --Node 2
,} --Branch 1
,} --Node 1
,} --Test Tree


--2. write tree recursively
outputfile1=io.open("/Tree/Tree_LuatoLua_Tree.lua","w")

--2.1 define recursive function
function writeTreeRecursive(TreeTable,StartText)
	--write StartText Tree= or , before {branchname=
	--branch:
	outputfile1:write(StartText .. '{branchname="' .. TreeTable.branchname:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n") .. '"')
	for i,v in ipairs(TreeTable) do
		if type(v)=="table" then
			writeTreeRecursive(v,",\n")
		else
			--leafs:
			outputfile1:write(',\n"' .. v:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n") .. '"')
		end --if type(v)=="table" then
	end --for i,v in ipairs(TreeTable) do
	--after all leafs:
	outputfile1:write(',} --' .. TreeTable.branchname .. '\n')
end --function writeTreeRecursive(TreeTable,StartText)

--2.2 use recursive function
writeTreeRecursive(Tree,"Tree=")

--2.3 close file
outputfile1:close()

