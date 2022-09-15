--This script extract from an excel file the informations of the cells in the worksheets and builds an tabulator text tree with complex brackets formulae

--1. definition of extraction
onlyFormulae="YES" --YES or other texts
withValues="YES"   --YES or other texts
maximumNumberOfCells=50 --reduce number of cells read to avoid long treatment

--2. function to show results or put them in a file
printOut=print
function printOut(a)
	outputFile:write(a .. "\n")
end --function printOut(a)
outputFile=io.open("C:\\Temp\\text_xlsx_worksheetscontent.txt","w")

--3. input excel file
ExcelFile="C:\\Temp\\test.xlsx"

--4. library for excel
require("luacom")

--5. open excel file with LuaCOM
excel=luacom.CreateObject("Excel.Application")
excel.Visible=true
excel.Workbooks:Open(ExcelFile)

--6. output the result in a file
printOut(ExcelFile) 
for i,ws in luacom.pairs(excel.Worksheets) do 
lineTable={}
	numberOfCells=0
	printOut("\tWorksheet:" .. ws.Name) 
	ws:Activate() 
	iRange = ws.UsedRange 
	--test with: print(iRange) 
	for i1,iCell in luacom.pairs(iRange) do 
		if numberOfCells>maximumNumberOfCells then break end
		if iCell.Value2~=nil then
			numberOfCells=numberOfCells+1
			local cellOmit
			if onlyFormulae=="YES" then
				if iCell.FormulaLocal:match("^=")==nil then
					cellOmit="YES"
				end --if iCell.FormulaLocal:match("^=")==nil then
			end --if onlyFormulae=="YES" then
			if cellOmit==nil then
				local text_out=("\t\t\t" .. iCell:AddressLocal():gsub("%$","") .. "=" .. iCell.FormulaLocal ):gsub("==","=")
				if text_out:match("^[^=%d]*(%d+)[^=]*=") and lineTable["Zeile" .. text_out:match("^[^=%d]*(%d+)[^=]*=")]==nil then
					printOut("\t\t" .. "Zeile" .. text_out:match("^[^=%d]*(%d+)[^=]*="))
					lineTable["Zeile" .. text_out:match("^[^=%d]*(%d+)[^=]*=")]=true
				end --if text_out:match("^[^=]*(%d+)[^=]*=") and lineTable["Zeile" .. text_out:match("^[^=]*(%d+)[^=]*=")]==nil then
				printOut(text_out) 
				--treatment of text to handle key words in upper cases before brackets
				text_out=text_out:gsub("(%u+)(%()","%2%1~")
				if withValues=="YES" then
					printOut("\t\t\t\t" .. iCell:AddressLocal():gsub("%$","") .. "=" .. tostring(iCell.Value2))
				end --if withValues=="YES" then
				--treat brackets
				pos=0
				--loop through the brackets and show them
				if text_out:match("%b()") then
					while true do
						pos_new=text_out:find("%b()",pos)
						if pos_new==nil then break end
						line_out=text_out:sub(pos_new)
								:match("%b()")
								:gsub("^%(",":"):gsub("%b()","(...)"):gsub("^:","(") --delete inner brackets
								:gsub("(%()(%u+)~","%2%1")
						printOut("\t\t\t\t" .. line_out)
						pos=pos_new+1
					end --while true do
				end --if text_out:match("%b()") then
			end --if cellOmit==nil then
		end --if iCell~=nil then
	end --for i1,iCell in luacom.pairs(iRange) do
end --for i,v in luacom.pairs(excel.Worksheets) do
outputFile:close()