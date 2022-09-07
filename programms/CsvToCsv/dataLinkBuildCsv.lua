
--1. csv input file
inputText=[[
Feld1;Feld2;Feld3
Tupfingen;Hauptstr. 5;Schmidt
Hinterobertal;Dorfweg 2;Mustermann
]]

--1.1 first line of csv file as titles
textTitles=inputText:match("([^\n]*)\n")
FieldTable={} --{"Field1","Field2","Field3"}
for field in (textTitles .. ";"):gmatch("([^;]*);") do
    FieldTable[#FieldTable+1]=field
end --for field in (textTitles .. ";"):gmatch("([^;]*);") do

--2. goal and link definition
--2.1 goal definition
GoalTable={"Name","Ort","Strasse","Test"}

--2.2 link definition
LinkTable={}
LinkTable["Feld1"]=tostring(GoalTable[2]) --Ort
--LinkTable["Feld2"]=tostring(GoalTable[3]) --"Strasse"
LinkTable["Feld2"]="Strasse"
LinkTable["Feld3"]=tostring(GoalTable[1]) --"Name"

--3. treat csv file
rowNumber=0
for line in (inputText.."\n"):gmatch("([^\n]*)\n") do
    rowNumber=rowNumber+1
    local ColTable={}
    i=0
    for field in (line .. ";"):gmatch("([^;]*);") do
        i=i+1
        ColTable[LinkTable[FieldTable[i]]]=field
    end --for field in (line .. ";"):gmatch("([^;]*);") do
    --print output
    local outputText=""
    if rowNumber==1 then
        for i=1,#GoalTable-1 do
            outputText=outputText .. tostring(GoalTable[i]) .. ";"
        end --for i=1,#GoalTable-1 do
        outputText=outputText .. tostring(GoalTable[#GoalTable]) -- .. ";"
        print(outputText)
    elseif ColTable[GoalTable[1]] then
        for i=1,#GoalTable-1 do
            outputText=outputText .. tostring(ColTable[GoalTable[i]]) .. ";"
        end --for i=1,#GoalTable-1 do
        outputText=outputText .. tostring(ColTable[GoalTable[#GoalTable]]) -- .. ";"
        print(outputText)
    end --if ColTable["Name"] then
end --for line in (inputText.."\n"):gmatch("([^\n]*)\n") do
