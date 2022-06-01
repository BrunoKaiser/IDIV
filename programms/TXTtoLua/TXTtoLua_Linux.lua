--automatically build tree from file with regular tabulators, i.e. only one new tabulator more in next line

inputTextFile='/home/pi/Tree/TXTtoLua_build/TXTtoLua_Linux.lua'
outputLuaScript='/home/pi/Tree/TXTtoLua_build/TXTtoLua_Tree.lua'

--1. function string:split() for splittings strings
function string:split( inSplitPattern )
	local outResults = {}
	local theStart = 1
	local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	--loop throuch string
	while theSplitStart do
		table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
		theStart = theSplitEnd + 1
		theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	end --while theSplitStart do
	--write results in table
	table.insert( outResults, string.sub( self, theStart ) )
	return outResults
end --function string:split( inSplitPattern )

--2. read data from textfile
io.output(outputLuaScript)
io.write('treefromtabtext=\n')
io.write('{branchname=[====[Tree: ' .. inputTextFile .. ' (' .. os.date("%d.%m.%Y %H:%M:%S") .. ')]====]')
pos_prevline=0
pos_curline=0
for line in io.lines(inputTextFile) do
	if line:match('%S')~=nil then
		pos_prevline=pos_curline --update position
		pos_curline=0
		local helpstring='\t' .. line
		while helpstring:match('^\t')~=nil do -- get position of current line
			pos_curline=pos_curline+1
			helpstring=helpstring:gsub('^\t','')
		end --while helpstring:match('^\t')~=nil do
		-- modify helpstring in order to get desired results
		while helpstring:match('^ ')~=nil do
			helpstring=helpstring:gsub('^ ', '')
		end --while helpstring:match('^ ')~=nil do
		while helpstring:match('^ ')~=nil do
			helpstring=helpstring:gsub('^ ', '')
		end --while helpstring:match('^ ')~=nil do
		helpstring=helpstring:gsub('\\', '\\\\'):gsub('\"', '\\\"'):gsub("\'", "\\\'")
		--print(pos_curline, pos_prevline)
		if pos_curline<pos_prevline then
			for i=1, pos_prevline-pos_curline +1 do
				io.write('},')
			end --for i=1, pos_prevline-pos_curline +1 do
		elseif pos_curline==pos_prevline and pos_curline~=0 then
			io.write('},')
		elseif pos_curline>pos_prevline then
			io.write(',')
		end --if pos_curline<pos_prevline then
		io.write('\n{branchname="' .. helpstring .. '"')
		--io.write('\n')
	end --if line:match('%S')~=nil then
end --for line in io.lines(inputTextFile) do

--3. write end curly brackets
for i=1, pos_curline+1 do
	io.write('}')
end --for i=1, pos_curline+1 do

--4. write end of file with return
io.write('\n\nreturn treefromtabtext')
io.close()