--This script converts a Lua programm that has no indentation in classical indentation or analysable tree indentation

--1. example with identation
text=[[

if a==12 then
	b=2
	if a==112 then
		b=2
	end
elseif a==1122 then
	b=2342
else
	if c==2 then
		b=345
	else
		b=34
	end
	b=4
end

variable2=234

]]
--1.1 example without identation
text=text:gsub("\t","")

--2.1 classic programm identation
ifLevel=0
for line in (text .. "\n"):gmatch("([^\n]*)\n") do
	if line:match("^if") then
		print(string.rep("\t",ifLevel) .. line)
		ifLevel=ifLevel+1
	elseif line:match("^else") then
		print(string.rep("\t",ifLevel-1) .. line)
	elseif line:match("^end") then
		ifLevel=ifLevel-1
		print(string.rep("\t",ifLevel) .. line) --.. "\t" .. line)
	else
		print(string.rep("\t",ifLevel) .. line)
	end --if line:match("if") then
end --for line in (text .. "\n"):gmatch("([^\n]*)\n") do

--2.2 tree identation to be able to analyse programms
ifLevel=0
elseLevelTable={}
elseLevelTable[0]=0
for line in (text .. "\n"):gmatch("([^\n]*)\n") do
	local elseLevel=0 --calculate the sum of elseLevels in table elseLevelTable
	for i,v in ipairs(elseLevelTable) do
		--test with: print(i,v)
		elseLevel=elseLevel+v
	end --for i,v in ipairs(elseLevel) do
	--test with: print(ifLevel .. ": " .. elseLevel)
	--print the line
	print(string.rep("\t",ifLevel+elseLevel) .. line)
	--change the levels after printing the line
	if line:match("^if") then
		ifLevel=ifLevel+1
		elseLevelTable[ifLevel]=0
	elseif line:match("^elseif") then
		elseLevelTable[ifLevel]=elseLevelTable[ifLevel]+1
	elseif line:match("^else") then
		elseLevelTable[ifLevel]=elseLevelTable[ifLevel]+1
	elseif line:match("^end") then
		elseLevelTable[ifLevel]=0
		ifLevel=ifLevel-1
	end --if line:match("if") then
end --for line in (text .. "\n"):gmatch("([^\n]*)\n") do

