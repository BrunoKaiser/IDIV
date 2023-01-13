rsubmit grid;
rsubmit session;
option mprint symbolgen;
endrsubmit;
endrsubmit;

option mprint symbolgen;

%let monat=2212;
rsubmit grid;
%let monat=2212;
rsubmit session;
%let monat=2212;
endrsubmit;
endrsubmit;



Proc Lua;submit;
--This Lua script collects the macro variables as needed for Lua replacement
function MacroLua(inputfile,outputfile)
macroTable={}
outputfile1=io.open(outputfile,"w")
for line in io.lines(inputfile) do
	if line:match('&[^ %."]+%.?') then
		for field in line:gmatch('&[^ %."]+%.?') do
			print(field:match('(&[^ %."]+)%.?'))
			macroTable[field:match('(&[^ %."]+)%.?')]=sas.symget(field:match('&([^ %."]+)%.?')) 
			print(macroTable[field:match('(&[^ %."]+)%.?')])
		end --for field in line:gmatch('&[^ %."]+%.?') do
	end --if line:match('&[^ "]+%.?') then
	for k,v in pairs(macroTable) do
		if line:match("&&") then
			--substitute twice for inner macro variables
			line=line:gsub(k .. "%.",v):gsub(k,v)
			line=line:gsub("&" .. k .. "%.",v):gsub(k,v)
		else
			line=line:gsub(k .. "%.",v):gsub(k,v)
		end --if line:match("&&") then
	end --for k,v in pairs(macroTable) do
	--for inner macro variables build them with Lua
	if line:lower():match("%%let [^ ]+ *=[^;&]+;") then
	--test with: print("TEST" .. line, line:lower():match("%%let ([^ ]+) *=[^;]+;"))
		macroTable["&&" .. line:lower():match("%%let ([^ ]+) *=[^;]+;")]=line:match("%%let [^ ]+ *=([^;]+);"):gsub("^ +",""):gsub(" +$","")
	end --if line:lower():match("%%let [^ ]+ =[^;]+;") then
	outputfile1:write(line .. "\n")
end --for line in io.lines(inputfile) do
outputfile1:close()
end --function MacroLua(inputfile,outputfile)

--test with: for k,v in pairs(macroTable) do print(k,v) end
endsubmit;
run;

/*use the Proc Lua function*/
Proc Lua;submit;
MacroLua("\\\\client\\C$:\\Temp\\test.sas","\\\\client\\C$:\\Temp\\test_macro_resolved.sas")
endsubmit;
run;
%include "\\client\C$:\Temp\test_macro_resolved.sas";
