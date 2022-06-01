--This script converts a word file in a text file (TXT) by using LuaCOM

--1. library
require("luacom")           --require treatment of office files

--2.1 read word file names of the directory in a Lua table
wordFileTable={}
p=io.popen('dir C:\\Temp\\*docx /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		wordFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do

--2.2 read text file names of the securisations in a Lua table
secureFileTable={}
p=io.popen('dir C:\\Temp\\Archiv\\*docx2.txt /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if file:match("docx2.txt") then
end --for file in p:lines() do
--test with: for k,v in pairs(wordFileTable) do print(secureFileTable[k:gsub(".docx","_docx2") .. ".txt"], v) end

--2.3 collect file names from tree
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
	if k:match("\\.*%.docx$") then 
		--test with: print(k,v) 
		p=io.popen('dir "' .. k .. '" /o')
		for file in p:lines() do
			local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
			if DayText then
				wordFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
			end --if DayText then
		end --for file in p:lines() do
		--test with: print(k:gsub("\\([^\\]+)%.docx","\\Archiv\\%1_docx2.txt"))
		p=io.popen('dir "' .. k:gsub("\\([^\\]+)%.docx","\\Archiv\\%1_docx2.txt") .. '" /o')
		for file in p:lines() do
			local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
			if DayText then
				secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
			end --if DayText then
		end --for file in p:lines() do
	end --if k:match("\\.*%.docx$") then 
end --for k,v in pairs(collectFileNamesTable) do 
--test with: for k,v in pairs(wordFileTable) do print(secureFileTable[k:gsub(".docx","_docx2") .. ".txt"], v) end

--3. export word files to text if there is no export or if the date of the export to text is older than the date of the word file
--and make a copy of the previous version of the text file
fileTable={}
p=io.popen('dir C:\\Temp\\*.docx /b/o/s')
for WordFile in p:lines() do 
	fileTable[WordFile]=true
end --for WordFile in p:lines() do 
for k,v in pairs(collectFileNamesTable) do 
	if k:match("\\.*%.docx$") then 
		fileTable[k]=true
	end --if k:match("\\.*%.docx$") then 
end --for k,v in pairs(collectFileNamesTable) do 
for k,v in pairs(fileTable) do 
local WordFile=k
filePath=WordFile:match("(.*)\\([^\\]+)$")
ActiveDocumentText=WordFile:match("\\([^\\]+)$")
if secureFileTable[ActiveDocumentText:gsub(".docx","_docx2") .. ".txt"]==nil or
wordFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText:gsub(".docx","_docx2") .. ".txt"] then
print("securisation of " .. filePath .. "\\" .. ActiveDocumentText)
os.execute('copy "' .. filePath .. '\\Archiv\\' .. ActiveDocumentText:gsub(".docx","_docx2") .. '.txt" "' .. filePath .. '\\Archiv\\' .. ActiveDocumentText:gsub(".docx","_docx1") .. '.txt"')
word=luacom.CreateObject("Word.Application")
word.Documents:Open(WordFile)
word.ActiveDocument:SaveAs2(filePath .. "\\Archiv\\" .. ActiveDocumentText:gsub(".docx","_docx2") .. ".txt",2)
word:Quit()
end --if wordFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText .. ".txt"] then
end --for k,v in pairs(fileTable) do 
