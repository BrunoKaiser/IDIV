--This script converts a dependencies file in csv format with two columns in a Lua-Table.

csvdata="/home/pi/Tree/CSVtoLua_build/example_dependemcies.csv"
outputLuaTable="/home/pi/Tree/CSVtoLua_build/dependencies_to_tree_Linux.lua"

--this script takes dependencies and builds a tree out of them.

--the definition of the columns is as follows:
--first column: child, for database query or insert table or build table
--second clumn: parent, for database table or query


--1. function string:split() for splittings strings
--function for splittings strings, the first argument is the string, which should be splitted and the second argument is the pattern, were the string is split/separated.
--the return value is a table, containg all the substrings without the splitting pattern
function string:split( inSplitPattern )
	local outResults = {}
	local theStart = 1
	local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	while theSplitStart do
		table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
		theStart = theSplitEnd + 1
		theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	end --while theSplitStart do
	table.insert( outResults, string.sub( self, theStart ) )
	return outResults
end --function string:split( inSplitPattern )


--2. read CSV input file
--read csv data

--READING THE INPUTFILE

maintable={}--build a maintable, where we save the data.

--read the lines from the inputfile
for line in io.lines(csvdata) do
	--for each line build a new entry of the maintable, which is again a table, containing the values written in the line of the inputfile
	--skip empty lines
	if line~='' then
		table.insert(maintable,line:gsub("\r",""):split(";"))
	end --if line~='' then
end --for line in io.lines(csvdata) do


-- sort the table in alphabetic order of sources, otherwise the following script does not work
table.sort(maintable,function(x,y) return x[2]<y[2] end)

--END OF READING THE INPUTFILE

--3. build the outputstring for the tree
outputstring=''

--BUILDING THE OUTPUTSTRING

--3.1 recursive function to build the tree with stopp of circles

--BEGINNING OF THE RECURSIVE FUNCTION
looptest={}-- a table which we want to use in order to detect cyclic dependencies of our tree. There we need to break out of the recursion of the function

--now we need a recursive function, which takes the dependencies and goes every path in the resulting tree.
function searchfortable (starttable)-- the function takes a starttable, which is the position, where the recursion searches in the substree
	for k=1, #maintable do --outer loop for number of dependencies
		if maintable[k][2]==starttable then --if the current position in the tree is detected as the source of an dependency
			outputstring=outputstring .. '\n{branchname="' .. maintable[k][1] .. '",'
			--check in the global variable looptest, if the current table has occured already, i. e. is a parent of the actual node.
			if looptest[maintable[k][1]]==nil then --added looptest for the queries, not only for the tables
				--check if there is another query depending on the current one
				looptest[maintable[k][1]]=true
				searchfortable(maintable[k][1])
				looptest[maintable[k][1]]=nil
			else
				outputstring=outputstring .. '"CYCLE",'
			end --if looptest[maintable[k][1]]==nil then
			outputstring=outputstring .. '},\n'	--closing branch of query
		end --if maintable[k][2]==starttable then
	end --for k=1, #maintable do
end --function searchfortable (starttable)

--END OF THE RECURSIVE FUNCTION


--4. storage for checking if a name is the name of a query
QueryNameTable={}
for k=1,#maintable do QueryNameTable[maintable[k][1]]=true end


--5. write the Lua table for the tree
--BEGINNING OF THE COMPOSITION PROCESS

outputstring=outputstring .. 'tree_from_csv='
outputstring=outputstring .. '{branchname="Baum erstellt am: ' .. os.date() .. '",\n'


-- loop for writing down all tables in 1st place
for j=1,#maintable do
	if (j==1 or (j~= 1 and maintable[j][2] ~= maintable[j-1][2] ))--detection of really a sourcetable starts
		and QueryNameTable[maintable[j][2]]==nil --detection that it is no query
		and maintable[j][2]~=""
	then
		--add branchname for node
		outputstring=outputstring .. '{branchname="' .. maintable[j][2] .. '",' --adding the node
		--starting the recursion
		looptest[maintable[j][2]]=true
		searchfortable(maintable[j][2])
		looptest[maintable[j][2]]=nil
		--write curly brackets at the end of branchname
		outputstring=outputstring .. '},\n'
	end --if (j==1 or (j~= 1 and maintable[j][2] ~= maintable[j-1][2] ))
end --for j=1,#maintable do

outputstring=outputstring .. '}\n'	--closure of the whole tree

--END OF THE COMPOSITION PROCESS

--END OF BUILDING THE OUTPUTSTRING

--6. write the output file
io.output(outputLuaTable)
io.write(outputstring)
io.close()
