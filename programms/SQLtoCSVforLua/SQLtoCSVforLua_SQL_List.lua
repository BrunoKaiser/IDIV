--This script reads the query-SQL statements of an SQL liste and their query name resp. view name and build dependencies from query to table and table to view and from query to the parts of the SQL statements

--1. input text file
SQLList="C:\\Tree\\SQLtoCSVforLua\\SQLtoCSVforLua_SQL_List.txt"

--2. output CSV file
outputFile="C:\\Tree\\SQLtoCSVforLua\\SQLtoCSVforLua_List_dependencies.csv"
print("Treate SQL list") 


--3. get standardised sections in SQL-statements by reserved words
--With ~ the reserved words can be analysed by the gmatch-command in Lua. 
--AS is an exception because it is part of a definition
NameText="" 
SQLText=""
SQLrawtable={}
for line in io.lines(SQLList) do  
	if line:match("^Name: ") then 
		SQLrawtable[NameText]=SQLText 
		SQLText="" 
		NameText=line:match("^Name: (.*)") 
	end --if line:match("^Name: ") then 
	if line:match("^Name: ")==nil then 
		SQLText=SQLText .. line 
	end --if line:match("^Name: ")==nil then 
end --for line in io.lines(SQLList) do  
SQLrawtable[NameText]=SQLText

SQLtable={}
for k,v in pairs(SQLrawtable) do
	--test with: print(k,v)
	SQLtable[k]=v
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
end --for k,v in pairs(SQLrawtable) do

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
io.close()

