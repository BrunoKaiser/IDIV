--This script converts a powerpoint file in a pdf file by using luacom

--1. library
require("luacom")           --require treatment of office files

--2.1 read powerpoint file names of the directory in a Lua table
powerpointFileTable={}
p=io.popen('dir C:\\Temp\\*pptx /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		powerpointFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do

--2.2 read names of powerpoint file exports as pdf in a Lua table
secureFileTable={}
p=io.popen('dir C:\\Temp\\Archiv\\*pptx2.pdf /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do
--test with: for k,v in pairs(powerpointFileTable) do print(secureFileTable[k:gsub(".pptx","_pptx2") .. ".pdf"], v) end

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
	if k:match("\\.*%.pptx$") then 
		--test with: print(k,v) 
		p=io.popen('dir "' .. k .. '" /o')
		for file in p:lines() do
			local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
			if DayText then
				powerpointFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
			end --if DayText then
		end --for file in p:lines() do
		--test with: print(k:gsub("\\([^\\]+)%.pptx","\\%1_pptx2.pdf"))
		p=io.popen('dir "' .. k:gsub("\\([^\\]+)%.pptx","\\%1_pptx2.pdf") .. '" /o')
		for file in p:lines() do
			local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
			if DayText then
				secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
			end --if DayText then
		end --for file in p:lines() do
	end --if k:match("\\.*%.pptx$") then 
end --for k,v in pairs(collectFileNamesTable) do 
--test with: for k,v in pairs(powerpointFileTable) do print(secureFileTable[k:gsub(".pptx","_pptx2") .. ".txt"], v) end

--3. export powerpoint files to pdf if there is no export or if the date of the export to pdf is older than the date of the powerpoint file
fileTable={}
p=io.popen('dir C:\\Temp\\*.pptx /b/o/s')
for powerpointFile in p:lines() do 
	fileTable[powerpointFile]=true
end --for powerpointFile in p:lines() do 
for k,v in pairs(collectFileNamesTable) do 
	if k:match("\\.*%.pptx$") then 
		fileTable[k]=true
	end --if k:match("\\.*%.pptx$") then 
end --for k,v in pairs(collectFileNamesTable) do 
for k,v in pairs(fileTable) do 
local powerpointFile=k
filePath=powerpointFile:match("(.*)\\([^\\]+)$")
ActiveDocumentText=powerpointFile:match("\\([^\\]+)$")
if secureFileTable[ActiveDocumentText:gsub(".pptx","_pptx2") .. ".pdf"]==nil or
powerpointFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText:gsub(".pptx","_pptx2") .. ".pdf"] then
print("securisation of " .. filePath .. "\\" .. ActiveDocumentText)
powerpoint=luacom.CreateObject("Powerpoint.Application")
powerpoint.Presentations:Open(powerpointFile)
powerpoint.ActivePresentation:SaveAs(filePath .. "\\" .. ActiveDocumentText:gsub(".pptx","_pptx2") .. ".pdf",32)
powerpoint:Quit()
end --if powerpointFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText .. ".pdf"] then
end --for k,v in pairs(fileTable) do 

