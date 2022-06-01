--This script converts an excel file in a txt file by using LuaCOM

--1 previously delete temporary test data
os.execute('del "C:\\Temp\\test_*.txt"')

--1.1 library
require("luacom")           --require treatment of office files

--2.1 read excel file names of the directory in a Lua table
excelFileTable={}
p=io.popen('dir C:\\Temp\\*xlsx /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		excelFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do

--2.2 read names of excel file exports as txt in a Lua table
secureFileTable={}
p=io.popen('dir C:\\Temp\\Archiv\\*xlsx2.txt /o')
for file in p:lines() do
	local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
	if DayText then
		secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
	end --if DayText then
end --for file in p:lines() do
--test with: for k,v in pairs(excelFileTable) do print(secureFileTable[k:gsub(".xlsx","_xlsx2") .. ".txt"], v) end

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
	if k:match("\\.*%.xlsx$") then 
		--test with: print(k,v) 
		p=io.popen('dir "' .. k .. '" /o')
		for file in p:lines() do
			local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
			if DayText then
				excelFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
			end --if DayText then
		end --for file in p:lines() do
		--test with: print(k:gsub("\\([^\\]+)%.xlsx","\\Archiv\\%1_xlsx2.txt"))
		p=io.popen('dir "' .. k:gsub("\\([^\\]+)%.xlsx","\\Archiv\\%1_xlsx2.txt") .. '" /o')
		for file in p:lines() do
			local DayText,MonthText,YearText,HourText,MinuteText,FileText=file:match("(%d%d).(%d%d).(%d%d%d%d).*(%d%d):(%d%d).*%d+ (.*)")
			if DayText then
				secureFileTable[FileText]=YearText .. MonthText .. DayText .. HourText .. MinuteText
			end --if DayText then
		end --for file in p:lines() do
	end --if k:match("\\.*%.xlsx$") then 
end --for k,v in pairs(collectFileNamesTable) do 
--test with: for k,v in pairs(excelFileTable) do print(secureFileTable[k:gsub(".xlsx","_xlsx2") .. ".txt"], v) end

--3. export excel files to txt if there is no export or if the date of the export to txt is older than the date of the excel file
--and make a copy of the previous version of the text file
fileTable={}
p=io.popen('dir C:\\Temp\\*.xlsx /b/o/s')
for ExcelFile in p:lines() do 
	fileTable[ExcelFile]=true
end --for ExcelFile in p:lines() do 
for k,v in pairs(collectFileNamesTable) do 
	if k:match("\\.*%.xlsx$") then 
		fileTable[k]=true
	end --if k:match("\\.*%.xlsx$") then 
end --for k,v in pairs(collectFileNamesTable) do 
for k,v in pairs(fileTable) do 
local ExcelFile=k
filePath=ExcelFile:match("(.*)\\([^\\]+)$")
ActiveDocumentText=ExcelFile:match("\\([^\\]+)$")
if secureFileTable[ActiveDocumentText:gsub(".xlsx","_xlsx2") .. ".txt"]==nil or
excelFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText:gsub(".xlsx","_xlsx2") .. ".txt"] then
print("Securisation of " .. filePath .. "\\" .. ActiveDocumentText)
os.execute('copy "' .. filePath .. '\\Archiv\\' .. ActiveDocumentText:gsub(".xlsx","_xlsx2") .. '.txt" "' .. filePath .. '\\Archiv\\' .. ActiveDocumentText:gsub(".xlsx","_xlsx1") .. '.txt"')
excel=luacom.CreateObject("Excel.Application")
excel.Workbooks:Open(ExcelFile)
outputfile1=io.output(filePath .. "\\Archiv\\" .. ActiveDocumentText:gsub(".xlsx","_xlsx2") .. ".txt")
for i = 1, excel.Worksheets.Count do 
local WorksheetName=excel.Worksheets(i).Name
excel.Worksheets(i):SaveAs("C:\\Temp\\test_" .. ActiveDocumentText .. "_" .. i .. ".txt", 20) 
inputfile1=io.open("C:\\Temp\\test_" .. ActiveDocumentText .. "_" .. i .. ".txt","r")
CTempText=inputfile1:read("*a")
inputfile1:close()
--test with: print(WorksheetName,excel.Worksheets(i).Name)
outputfile1:write("Tabelle " .. WorksheetName .. ":\n" .. CTempText)
end --for i = 1, excel.Worksheets.Count do
excel:Quit()
outputfile1:close()
end --if excelFileTable[ActiveDocumentText]>secureFileTable[ActiveDocumentText .. ".txt"] then
end --for k,v in pairs(fileTable) do 
