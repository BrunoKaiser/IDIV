--1. collect data with curl as an example
os.execute("curl -o c:\\Temp\\html_text_file.html https://m.focus.de/schlagzeilen/")

--1.1 build from previous data a previous file
inputfile1=io.open("C:\\Temp\\html_text_file_tree.lua","r")
inputText1=inputfile1:read("*all"):gsub("Tree=","Tree_previous=")
inputfile1:close()

outputfile1=io.open("C:\\Temp\\html_text_file_tree_previous.lua","w")
outputfile1:write(inputText1)
outputfile1:close()

--2. read html text file
inputfile2=io.open("C:\\Temp\\html_text_file.html","r")
inputText2=inputfile2:read("*all")
inputfile2:close()

--3. build tree from html text file
outputfile2=io.open("C:\\Temp\\html_text_file_tree.lua","w")
outputfile2:write('Tree={branchname="Schlagzeilen",\n')
for Block in inputText2:gmatch("<li .-></li>") do
	--test with: print(Block:match("ps%-oid%-(%d+) news%-item"),Block:match('<span.*/span>'),os.date("%d.%m.%Y %H:%M:%S",Block:match('psDate%-(%d+)000">')))
	outputfile2:write('{branchname="'
		.. tostring(Block:match('>([^<]*)</a>')):gsub("Ã¤","ä")
							:gsub("Ã„","Ä")
							:gsub("Ã¶","ö")
							:gsub("Ã–","Ö")
							:gsub("Ã¼","ü")
							:gsub("Ãœ","Ü")
							:gsub("ÃŸ","ß")
							:gsub("â€“","-")
							:gsub("â€ž","'")
							:gsub("â€œ","'")
							:gsub("â€š","'")
							:gsub("â€˜","'")
							:gsub("Â "," ")
							:gsub("Ã©","é")
							:gsub("Ã—","×")
							:gsub("Ã·","÷")
							:gsub("Ã§","ç")
							:gsub("Ã´","ô")
							:gsub("Ã ","à")
							:gsub("Ã¨","è")
							 .. '", state="COLLAPSED",'
		.. '"' .. os.date("%d.%m.%Y %H:%M:%S",tostring(Block:match('psDate%-(%d+)000">'))) .. '",'
		.. '"' .. tostring(Block:match('<a href="([^"]*)"') .. '",'
		.. "},\n")
	)
end --for Block in inputText:gmatch("<li .-></li>") do
outputfile2:write('}')
outputfile2:close()

--3.1 read previous tree and current tree
dofile("C:\\Temp\\html_text_file_tree_previous.lua")
previous_existsTable={}
for i,v in ipairs(Tree_previous) do
	previous_existsTable[v.branchname]=true
end --for i,v in ipairs(Tree) do
dofile("C:\\Temp\\html_text_file_tree.lua")

--3.2 build new titles in tree compared to previous tree
outputfile3=io.open("C:\\Temp\\html_text_file_tree_new.lua","w")
outputfile3:write('Tree_new={branchname="Neue Schlagzeilen",\n')

--3.3 general function for distance between texts
function string.levenshtein(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost = 0
        -- quick cut-offs to save time
	if (len1 == 0) then
		return len2
	elseif (len2 == 0) then
		return len1
	elseif (str1 == str2) then
		return 0
	end --if (len1 == 0) then
	-- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end --for i = 0, len1, 1 do
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end --for j = 0, len2, 1 do
	-- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if (str1:byte(i) == str2:byte(j)) then
				cost = 0
			else
				cost = 1
			end --if (str1:byte(i) == str2:byte(j)) then
			matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
		end --for j = 1, len2, 1 do
	end --for i = 1, len1, 1 do
	-- return the last value - this is the Levenshtein distance
	return matrix[len1][len2]
end --function string.levenshtein(str1, str2)

--4. collect new titles with the distance to all the previous titles if not in previous tree
for i,v in ipairs(Tree) do
	if previous_existsTable[v.branchname]==nil then
		local distance=9999999
		--use distance of Levenshtein to calculate the minimum difference
		for k1,v1 in pairs(previous_existsTable) do
			if string.levenshtein(v.branchname,k1)<distance then
				distance=string.levenshtein(v.branchname,k1)
			end --if distance<string.levenshtein(v.branchname,k1) then
		end --for k1,v1 in pairs(previous_existsTable) do
		if math.floor(distance/#v.branchname*10000)/100 <30 then
			outputfile3:write('{branchname="Levenshtein-Distanz: ' .. distance .. " (" .. math.floor(distance/#v.branchname*10000)/100 .. '%): ",state="COLLAPSED",{branchname="' .. v.branchname .. '", state="' .. v.state .. '", "' .. v[1] .. '", "' .. v[2] .. '",},},\n')
		else
			outputfile3:write('{branchname="Levenshtein-Distanz: ' .. distance .. " (" .. math.floor(distance/#v.branchname*10000)/100 .. '%): ",{branchname="' .. v.branchname .. '", state="' .. v.state .. '", "' .. v[1] .. '", "' .. v[2] .. '",},},\n')
		end --if math.floor(distance/#v.branchname*10000)/100 <30 then
	end --if previous_existsTable[v.branchname]==nil then
	io.write(".")
end --for i,v in ipairs(Tree) do
outputfile3:write('}\n')
outputfile3:close()

--5. optional: show it in a simple documentation tree
--os.execute('start "D" "C:\\Tree\\simpleDocTree\\simple_documentation_tree.lua"')
