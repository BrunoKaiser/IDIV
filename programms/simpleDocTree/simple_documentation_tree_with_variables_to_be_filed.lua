
known_variable="known_variable wird gebraucht"


variable2=
{branchname="variable2",
	known_variable ,
	unknown_variable ,
}

variable1=
{branchname="variable1",
	variable2 ,
}



--Programm
--This script contains a Lua tree with variables that can be filled by determining unknown variables.

print("__________________________________")

VariablendefiniertTabelle={}
VariablenNoetigTabelle={}
lineRead="yes"
for line in io.lines("C:\\Tree\\simpleDocTree\\simple_documentation_tree_with_variables_to_be_filed.lua") do
	if line:match("^%-%-Programm") then
		lineRead="no"
	elseif lineRead=="yes" and line:match("=") then
		VariablendefiniertTabelle[line:match("(.*)="):gsub(" ","")]="defined"
	elseif lineRead=="yes" and line:match('"')==nil then
		if VariablendefiniertTabelle[line:gsub("\t",""):gsub("}",""):gsub(",",""):gsub(" ","")]==nil 
			and line:gsub("\t",""):gsub("}",""):gsub(",",""):gsub(" ","")~="" then
			print(line:gsub("\t",""):gsub("}",""):gsub(",",""):gsub(" ","") .. "\n    fehlt")
		end --if VariablendefiniertTabelle[k]==nil then
		VariablenNoetigTabelle[line:gsub("\t",""):gsub("}",""):gsub(",",""):gsub(" ","")]="needed"
	end --if line:match("^%-%-Programm") then
end --for line in io.lines("P:\DIS-WS\CrisDa - Phase 3\07 SAS\Programm_Analyse\SAS_Seiteneffektketten.lua") do

--[[test with:
for k,v in pairs(VariablenNoetigTabelle) do
	if VariablendefiniertTabelle[k]==nil and k~="" then
		print(k .. "\n fehlt")
	end --if VariablendefiniertTabelle[k]==nil then
end --for k,v in pairs(VariablenNoetigTabelle) do
--]]

