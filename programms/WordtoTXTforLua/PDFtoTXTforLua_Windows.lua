--This script converts a PDF file in a text file (TXT) by using LuaCOM and Word

--1. library
require("luacom")           --require treatment of office files

--2.1 read pdf file names of the directory in a Lua table
PDFFileTable={}
p=io.popen('dir C:\\Temp\\*pdf /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		PDFFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do

--2.2 read text file names of the securisations in a Lua table
secureFileTable={}
p=io.popen('dir C:\\Temp\\Archiv\\*pdf2.txt /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do
--test with: for k,v in pairs(PDFFileTable) do print(secureFileTable[k:gsub(".pdf","_pdf2") .. ".txt"], v) end

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
	if k:match("\\.*%.pdf$") then 
		--test with: print(k,v) 
		p=io.popen('dir "' .. k .. '" /o')
		for file in p:lines() do
			local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
			if DayText then
				PDFFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
			end --if DayText then
		end --for file in p:lines() do
		--test with: print(k:gsub("\\([^\\]+)%.pdf","\\Archiv\\%1_pdf2.txt"))
		p=io.popen('dir "' .. k:gsub("\\([^\\]+)%.pdf","\\Archiv\\%1_pdf2.txt") .. '" /o')
		for file in p:lines() do
			local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
			if DayText then
				secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
			end --if DayText then
		end --for file in p:lines() do
	end --if k:match("\\.*%.pdf$") then 
end --for k,v in pairs(collectFileNamesTable) do 
--test with: for k,v in pairs(PDFFileTable) do print(secureFileTable[k:gsub(".pdf","_pdf2") .. ".txt"], v) end

--3. export pdf files to text if there is no export or if the date of the export to text is older than the date of the pdf file
--and make a copy of the previous version of the text file
fileTable={}
p=io.popen('dir C:\\Temp\\*.pdf /b/o/s')
for PDFFile in p:lines() do 
	fileTable[PDFFile]=true
end --for PDFFile in p:lines() do
for k,v in pairs(collectFileNamesTable) do 
	if k:match("\\.*%.pdf$") then 
		fileTable[k]=true
	end --if k:match("\\.*%.pdf$") then 
end --for k,v in pairs(collectFileNamesTable) do 
for k,v in pairs(fileTable) do  
local PDFFile=k
filePath=PDFFile:match("(.*)\\([^\\]+)$")
ActiveDocumentText=PDFFile:match("\\([^\\]+)$")
if secureFileTable[ActiveDocumentText:gsub(".pdf","_pdf2") .. ".txt"]==nil or
PDFFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText:gsub(".pdf","_pdf2") .. ".txt"] then
print("securisation of " .. filePath .. "\\" .. ActiveDocumentText)
os.execute('copy "' .. filePath .. '\\Archiv\\' .. ActiveDocumentText:gsub(".pdf","_pdf2") .. '.txt" "' .. filePath .. '\\Archiv\\' .. ActiveDocumentText:gsub(".pdf","_pdf1") .. '.txt"')
word=luacom.CreateObject("Word.Application")
word.Documents:Open(PDFFile)
word.ActiveDocument:SaveAs2(filePath .. "\\Archiv\\" .. ActiveDocumentText:gsub(".pdf","_pdf2") .. ".txt",2)
word:Quit()
end --if PDFFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText .. ".txt"] then
end --for k,v in pairs(fileTable) do 


