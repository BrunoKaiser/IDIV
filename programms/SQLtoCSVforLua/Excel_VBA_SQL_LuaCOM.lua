--This script executes a SQL statement with ADODB.Connection with LuaCOM and writes the SQL statement in a text file

--1. library
require("luacom")

--
--[[optional with excel file
file0 = "C:\\Temp\\test_result.xlsx" 
excel=luacom.CreateObject("Excel.Application")
excel.Visible=true
src0 = excel.Workbooks:Open(file0)
src0.Worksheets("Results").UsedRange:Clear()
--]]

--2. set connection with LuaCOM
cn = luacom.CreateObject("ADODB.Connection")
cn.Provider = "Microsoft.ACE.OLEDB.12.0"
cn.ConnectionString = "Data Source=C:\\Temp\\test2.xlsx;Extended Properties=\"Excel 12.0 Xml; HDR=YES\""
cn:Open()

--3. merge data with SQL
sqlText = "SELECT [TestSheet2$].*,[TestSheet$].* FROM [TestSheet2$] INNER JOIN (SELECT * FROM [Excel 12.0 Xml;HDR=Yes;Database=C:\\Temp\\test.xlsx].[Tabelle1$]) [TestSheet$] ON [TestSheet2$].[KONTO-NR] = [TestSheet$].KONTONR ;"
outputfile2=io.open("C:\\Temp\\SQLStatements.txt","w")
outputfile2:write("Name: query1\n\n")
outputfile2:write(sqlText)
outputfile2:close()

rs = cn:Execute(sqlText)

--4. write result of SQL statement execution in a text file

--4.1 count fields of SQL
iColumnNumber = rs.Fields.Count
rowNumber = 0

--4.2 write the headers
outputfile1=io.open("C:\\Temp\\test_Result.csv","w")
--print headers
for counter = 0,iColumnNumber - 1 do
    --src0.Worksheets("Results").Cells(1, counter + 1).Value2 = rs(counter).Name
    outputfile1:write(rs(counter).Name .. ";")
    --test with: print rs(counter)
end --for counter = 0,iColumnNumber - 1 do
outputfile1:write("\n")

--4.3 produce results
--with excel optional: src0.Worksheets("Results"):Range("A2"):CopyFromRecordset(rs)
----[[
while not rs.EOF do
    rowNumber = rowNumber + 1
    for counter = 0,iColumnNumber - 1 do
        --src0.Worksheets("Results").Cells(rowNumber + 1, counter + 1).Value2 = rs(counter)
        outputfile1:write(tostring(rs(counter).Value) .. ";")
        --test with: Debug.Print rs(counter)
    end --for counter = 0,iColumnNumber - 1 do
    outputfile1:write("\n")
    rs:Movenext()
end --while not rs.EOF do
--]]

--5. close the connection and outputfile
rs:Close()
cn:Close()
cn = nil
rs = nil
outputfile1:close()
