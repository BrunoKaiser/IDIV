--This script exports an Excel file with the data in independent columns in textfile csv with tabulators and write the content in a tree


--1. basic data

--1.1 library
require("luacom")           --require treatment of office files

--1.2.1 path of the file
path_excel="C:\\Temp"
excel_filename_full="test.xlsx" --test.xlsx
excel_filename=excel_filename_full:gsub("%.xlsx$","_xlsx")
print(excel_filename)

--1.2.2 delete text files from export before
os.execute('del "' .. path_excel .. '\\' .. excel_filename .. '_*.txt"') --test_xlsx_*.txt

--1.3 export excel file to txt
excel=luacom.CreateObject("Excel.Application")
excel.Workbooks:Open(path_excel .."\\" .. excel_filename_full)
excel.Visible=true
outputfile1=io.output(path_excel .."\\" .. excel_filename .. ".txt")
outputfile1:write('Tree_xlsx={branchname="Workbook",\n')
for i = 1, excel.Worksheets.Count do 
local WorksheetName=excel.Worksheets(i).Name 
excel.Worksheets(i):SaveAs(path_excel .."\\" .. excel_filename .. "_" .. i .. ".txt", 20) 
outputfile1:write('{branchname="' .. WorksheetName .. '","' .. i .. '",\n},\n') 
end --for i = 1, excel.Worksheets.Count do 
excel:Quit()
outputfile1:write('}\n')
outputfile1:close()

--1.4 read tree of worksheet names and numbers from excel file
dofile(path_excel .."\\" .. excel_filename .. ".txt")

--1.5 read tree of all worksheet datas and put them in the tree of worksheet names
for i=1,#Tree_xlsx do
	excelTable={}
	col=0
	row=0 
	for line in io.lines(path_excel .."\\" .. excel_filename .. "_" .. i .. ".txt") do
		row=row+1
		col=0
		for Feld in (line .. "\t"):gmatch("([^\t]*)\t") do 
			--print(Feld) 
			col=col+1 if excelTable[col]==nil then excelTable[col]={} end if row==1 then 
			rowTree="branchname" else rowTree=row-1 end 
			--if it is sure that after empty cell no content is
			if Feld~="" then
				excelTable[col][rowTree]=Feld 
			end --if Feld~="" then
		end --for Feld in (line .. "\t"):gmatch("([^\t]*)\t") do
	end --for line in io.lines(path_excel .."\\" .. excel_filename .. "_" .. i .. ".txt") do
	for i1,v1 in pairs(excelTable) do
		Tree_xlsx[i][#Tree_xlsx[i]+1]=v1
	end --or i1,v1 in pairs(excelTable) do
end --for i=1,#Tree_xlsx do

--2. write tree recursively
outputfile1=io.open(path_excel .."\\" .. excel_filename .. "_Tree.lua","w")

--2.1 define recursive function
function writeTreeRecursive(TreeTable,StartText)
	--write StartText Tree= or , before {branchname=
	--branch:
	outputfile1:write(StartText .. '{branchname="' .. TreeTable.branchname:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n") .. '", state="COLLAPSED"')
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
writeTreeRecursive(Tree_xlsx,"Tree_xlsx=")

--2.3 close file
outputfile1:close()

