--This script converts a html file in a text file (TXT) by using curl, LuaCOM and Word

--1. library
require("luacom")           --require treatment of office files

--2. collect internet site names from tree
URLTable={}
dofile("C:\\Tree\\documentation_tree.lua")
function treeCollectFileNamesRecursive(TreeTable)
	collectFileNamesTable[TreeTable.branchname]=true
	for k,v in pairs(TreeTable) do
		if type(v)=="table" then
			treeCollectFileNamesRecursive(v)
		else
			collectFileNamesTable[v]=true
		end --if type(v)=="table" then
	end --for k,v in pairs(TreeTable) do
end --function treeCollectFileNamesRecursive(TreeTable)
collectFileNamesTable={}
treeCollectFileNamesRecursive(lua_tree_output)
for k,v in pairs(collectFileNamesTable) do
	if k:match("https://") and k:match(" ")==nil then
				URLTable[k]=k:gsub("https:","")
						:gsub("%.","")
						:gsub("/","~")
						:gsub("\\","")
						:gsub(":","")
						:gsub("%*","")
						:gsub("%?","")
						:gsub('"',"")
						:gsub("<","")
						:gsub(">","")
						:gsub("|","")
						:gsub("=","")
	end --if k:match("https://") then
end --for k,v in pairs(collectFileNamesTable) do
--test with: for k,v in pairs(URLTable) do print(k, v) end

--3. export internet files to text if there is no export
--If the html-format is not readable for word, for instance because frames are not supported by curl, then nothing happens.
fileTable={}
numberOfLines=0
for k,v in pairs(URLTable) do
	local fileFound=""
	--test with: print(v)
	p=io.popen('dir C:\\Temp\\Archiv\\' .. v .. '_html2.txt /b/o/s')
	for line in p:lines() do
		--test with: print(line)
		fileFound=line
	end --for line in p:lines() do
	if fileFound=="" then
		numberOfLines=numberOfLines+1
		fileTable[k]=v
	end --if fileFound~="" then
end --for k,v in pairs(URLTable) do
print("Number of sites to be exported to text file: " .. numberOfLines)
for k,v in pairs(fileTable) do
local URLText=k
print(v)
--curl SysWOW64 kann mit System32 ersetzt werden, wohl für eine 32-bit-Version
os.execute('C:\\Windows\\SysWOW64\\curl.exe ' .. URLText .. ' --output C:\\temp\\test.html')
word=luacom.CreateObject("Word.Application")
openResult=pcall(function() word.Documents:Open("C:\\temp\\test.html") end)
if openResult then
word.ActiveDocument:SaveAs2("C:\\Temp\\Archiv\\" .. v .. "_html2.txt",2)
end --if openResult then
word:Quit()
end --for k,v in pairs(fileTable) do

