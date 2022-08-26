--This script reads the query-SQL statements of an Access database and their name (queries are views in access) and build dependencies from query to table and table to query and from query to the parts of the SQL statements

--The script ist written for Access, but the part 3. and 4. can be used for the treatment of other databases with appropriate textfile with names of views and SQL statements
--The script reads also the forms and reports. It puts them in dependency to the record source.

--1.1 input access database file
accessDatabase="C:\\Tree\\SQLtoCSVforLua\\test.accdb"

--1.2 output CSV file
outputFile="C:\\Tree\\SQLtoCSVforLua\\SQLtoCSVforLua_dependencies.csv"
print("Analyse Access Database " .. accessDatabase .. " with Luacom") 

--2. library
require("luacom")--require treatment of office files, especially for opening Access
--2.1 open Access
access=luacom.CreateObject("Access.Application") 
access.Visible=true 
--2.2 open Access database
access:OpenCurrentDatabase(accessDatabase) 
--2.3 get SQL with Names of queries, i.e. views in Access
rs1=access:CurrentDB().QueryDefs 

--3. get standardised sections in SQL-statements by reserved words
--With ~ the reserved words can be analysed by the gmatch-command in Lua. 
--AS is an exception because it is part of a definition
--temporary tables named with beginning ~ are not analysed
SQLtable={} 
for i=0,rs1.Count-1 do 
	if rs1(i).Name:match("^~")==nil then
		SQLtable[rs1(i).Name]=rs1(i).SQL
			:gsub("\r\n","")
			:gsub("\n","")
			:gsub("\r","")
			:gsub(";$","~;")
			:gsub('"',"'")
			:gsub("%(SELECT","~SUBLECT")
			:gsub("SELECT","~SELECT")
			:gsub("~SUBLECT","~SUB_SELECT")
			:gsub("INSERT INTO ([^%(]+)%(([^%)]+)%)","~INSERT_INTO %1~INSERT_FIELD(%2)")
			:gsub("INSERT INTO","~INSERT_INTO")
			:gsub(" INTO"," ~INTO")
			:gsub("UNION","~UNION")
			:gsub("UPDATE","~UPDATE")
			:gsub("DELETE","~DELETE")
			:gsub("SET","~SET")
			:gsub("FROM %(","~FROM ")
			:gsub("FROM","~FROM")
			:gsub("INNER JOIN","~INNER JOIN")
			:gsub("RIGHT JOIN","~RIGHT JOIN")
			:gsub("LEFT JOIN","~LEFT JOIN")
			:gsub(" ON"," ~ON")
			:gsub("WHERE","~WHERE")
			:gsub("HAVING","~HAVING")
			:gsub("GROUP BY","~GROUP_BY")
			:gsub("ORDER BY","~ORDER_BY")
			:gsub("TRANSFORM","~TRANSFORM")
			:gsub("PIVOT","~PIVOT")
	end --if rs1(i).Name:match("^~")==nil then
end --for i=0,rs1.Count-1 do

--4. build dependencies in a csv file
--the different Name-SQL relations must be written with child in first column and parent in second column
io.output(outputFile)
uniqueTable={}
for k,v in pairs(SQLtable) do 
	for field in (v .. "~"):gmatch("([^~]+)~") do 
		if field:match("FROM")       then
			field=field:gsub("FROM ",""):gsub(", ",",") .. ","
			for subfield in field:gmatch("([^,]+),") do
				local outputText=tostring(k .. ";" .. subfield .. ";"):gsub(" ;",";"):gsub(";$","")     if uniqueTable[outputText]==nil then io.write(outputText .. "\n") uniqueTable[outputText]=true end
			end --for subfield in field:gmatch("[^,]+,") do
		elseif field:match("JOIN")   then local outputText=tostring(k .. ";" .. field:gsub(".*JOIN ","") .. ";"):gsub(" ;",";"):gsub(";$","")   if uniqueTable[outputText]==nil then io.write(outputText .. "\n") uniqueTable[outputText]=true end
		elseif field:match("UPDATE") then local outputText=tostring(k .. ";" .. field:gsub(".*UPDATE ","") .. ";"):gsub(" ;",";"):gsub(";$","") if uniqueTable[outputText]==nil then io.write(outputText .. "\n") uniqueTable[outputText]=true end
		elseif field:match("INTO")   then local outputText=tostring(field:gsub(".*INTO ","") .. ";" .. k .. ";"):gsub(" ;",";"):gsub(";$","")   if uniqueTable[outputText]==nil then io.write(outputText .. "\n") uniqueTable[outputText]=true end
		elseif field~=";"            then local outputText=tostring(field .. ";" .. k .. ";"):gsub(" ;",";"):gsub(";$","")                      if uniqueTable[outputText]==nil then io.write(outputText .. "\n") uniqueTable[outputText]=true end
		end --if field:match("FROM") then
	end --for field in (v .. "~"):gmatch("([^~]+)~") do 
end --for k,v in pairs(SQLtable) do 
--open all forms and read the record source
rs2=access.Application.CurrentProject.AllForms
for i=0,rs2.Count-1 do  
	--test with: print("Form: " .. rs2(i).Name)
	access.DoCmd:OpenForm(rs2(i).Name)
	local outputText=tostring("Form: " .. access.Forms(i).Name .. ";" .. access.Forms(i).RecordSource) io.write(outputText .. "\n") 
	access.DoCmd:Close(1,rs2(i).Name)
end --for i=0,rs2.Count-1 do 
--open all reports and read the record source
rs3=access.Application.CurrentProject.AllReports
for i=0,rs3.Count-1 do  
	--test with: print("Report: " .. rs3(i).Name)
	access.DoCmd:OpenReport(rs3(i).Name,1)
	local outputText=tostring("Report: " .. access.Reports(i).Name .. ";" .. access.Reports(i).RecordSource) io.write(outputText .. "\n") 
	access.DoCmd:Close(1,rs3(i).Name)
end --for i=0,rs2.Count-1 do 
--collect linked table names
rs4=access:CurrentDB().TableDefs
for i=0,rs4.Count-1 do 
	if rs4:Item(i).Connect~="" then
		--test with: print(rs4:Item(i).Name,rs4:Item(i).Connect .. "\\" .. rs4:Item(i).SourceTableName)
		local outputText=tostring(rs4:Item(i).Name .. ";" .. "Link: " .. rs4:Item(i).Connect:gsub(";",","):gsub("\\","\\\\") .. "\\\\" .. rs4:Item(i).SourceTableName) io.write(outputText .. "\n") 
	end --if rs4:Item(i).Connect~="" then 
end --for i=0,rs4.Count-1 do 
io.close()

--5. shut all access processes to be able to reopen the database
access:Quit() 
os.execute('taskkill /IM MSACCESS.EXE /F')
