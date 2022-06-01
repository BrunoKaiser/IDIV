--This script converts a text with brackets, for instance with SQL-statements, into a Lua tree with an example text variable.

--1. example text variable
text="SELECT * FROM (SELECT * FROM (SELECT * FROM TABLE1), (SELECT * FROM TABLE)); \n\nSELECT * FROM (SELECT * FROM (SELECT * FROM TABLE1), (SELECT * FROM TABLE)); \n \n  "

--1.1 treat multiple SQL statements with semicolon at the end
text=text:gsub(";",";)(")
	:gsub(" +$","")
	:gsub(" +\n","\n")
	:gsub("\n+","")
	:gsub(";%)%($",";")


--1.2 read opening and closing brackets and count them and add missing ones
numberBracketOpen=0
for bracketOpen in ("(" .. text .. ")"):gmatch("%(") do
	numberBracketOpen= numberBracketOpen+1
end --for bracketOpen in ("(" .. text .. ")"):gmatch("%(") do
numberBracketClose=0
for bracketClose in ("(" .. text .. ")"):gmatch("%)") do
	numberBracketClose = numberBracketClose +1
end --for bracketClose in ("(" .. text .. ")"):gmatch("%)") do
if numberBracketOpen>numberBracketClose then
	text=text .. string.rep("~missing~)",numberBracketOpen-numberBracketClose)
elseif numberBracketOpen<numberBracketClose then
	text=string.rep("(~missing~",numberBracketClose-numberBracketOpen) .. text
end --if numberBracketOpen>numberBracketClose then

--2. show all parts of brackets
pos=1
while true do 
	findText,pos=("(" .. text .. ")"):find("%(",pos) 
	if pos then 
		pos=pos+1 
		print(("(" .. text .. ")"):sub(pos-1):match("%b()")) 
	else 
		break 
	end --if pos then
end --while true do 

--3. build the outputstring for the tree
outputfile1=io.open("C:\\Temp\\bracketsTree.lua","w") 
outputText=("Tree={branchname=[====[brackets tree" .. ("(" .. text .. ")"):gsub("%(",']====],\n{branchname=[====[(')
									:gsub("%)",')]====],\n},\n[====[') .. "]====],}")
									:gsub("%[====%[%]====%],","")
outputfile1:write(outputText)
outputfile1:close()

