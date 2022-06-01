--1. collect data with curl as an example
os.execute("curl -o c:\\Temp\\html_text_file.html https://m.focus.de/schlagzeilen/")

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
		.. tostring(Block:match('>([^<]*)</a>')):gsub("ä","�")
							:gsub("Ä","�")
							:gsub("ö","�")
							:gsub("Ö","�")
							:gsub("ü","�")
							:gsub("Ü","�")
							:gsub("ß","�")
							:gsub("–","-")
							:gsub("„","'")
							:gsub("“","'")
							:gsub("‚","'")
							:gsub("‘","'")
							:gsub(" "," ")
							:gsub("é","�")
							:gsub("×","�")
							:gsub("÷","�")
							:gsub("ç","�")
							:gsub("ô","�")
							:gsub("à","�")
							:gsub("è","�")
							 .. '", state="COLLAPSED",'
		.. '"' .. os.date("%d.%m.%Y %H:%M:%S",tostring(Block:match('psDate%-(%d+)000">'))) .. '",'
		.. '"' .. tostring(Block:match('<a href="([^"]*)"') .. '",'
		.. "},\n")
	)
end --for Block in inputText:gmatch("<li .-></li>") do
outputfile2:write('}')
outputfile2:close()
