--This script converts a text with brackets, for instance with SQL-statements, into a Lua tree with an example text variable

--1. example text variable
--C:\Temp\EBA Validation Rules 2021-12-10_1_Gido.xlsx: text='=WENN(TEIL(M4;1;1)="";"-"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(M4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(M4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(N4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(N4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(N4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(O4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(O4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(O4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(P4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(P4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(P4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(Q4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(Q4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(Q4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(R4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(R4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(R4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(S4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(S4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(S4;$Vorgehensweise_neu.$AH$21)>0;"FF"));"nM"))))))))))))))'
--C:\Temp\EBA Validation Rules 2021-12-10_2.xlsx:
text='=WENN(TEIL(M4;1;1)="";"-"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(M4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(M4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(N4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(N4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(N4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(O4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(O4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(O4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(P4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(P4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(P4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(Q4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(Q4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(Q4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(R4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(R4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(R4;$Vorgehensweise_neu.$AH$21)>0;"FF"));WENN(TEIL(S4;1;1)="F"; WENNFEHLER(WENNFEHLER(WENN(SUCHEN(S4;$Vorgehensweise_neu.$AE$21)>0;"SO");WENN(SUCHEN(S4;$Vorgehensweise_neu.$AH$21)>0;"FF"));"nM");"nM"));"nM"));"nM"));"nM"));"nM"));"nM")))'

--1.1 exchange words in upper cases and brackets
text=text:gsub("(%u+)%(","(%1~~~") 

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
	findText,pos=("(" .. text:gsub("%((%u+)~~~","%1(") .. ")"):find("%(",pos) 
	if pos then 
		pos=pos+1 
		print(("(" .. text:gsub("%((%u+)~~~","%1(") .. ")"):sub(pos-1):match("%b()")) 
	else 
		break 
	end --if pos then
end --while true do 

--3. build the outputstring for the tree
outputfile1=io.open("C:\\Temp\\bracketsTree.lua","w") 
outputText=("Tree={branchname=[====[brackets tree" .. ("(" .. text .. ")"):gsub("%(",']====],\n{branchname=[====[(')
									:gsub("%)",')]====],\n},\n[====[') .. "]====],}")
									:gsub(";",";]====],[====[") --for Excel formulas
									:gsub("%[====%[%]====%],","")
									:gsub("%((%u+)~~~","%1(") --for Excel formulas words before brackets

outputfile1:write(outputText)
outputfile1:close()

