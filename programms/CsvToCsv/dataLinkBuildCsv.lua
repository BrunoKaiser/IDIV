
--1. csv input file
inputText=[[
Feld1;Feld2;Feld3
Tupfingen;Hauptstr. 5;Schmidt
Hinterobertal;Dorfweg 2;Mustermann
]]

--1.1 first line of csv file as titles
firstLine="No"
textTitles=inputText:match("([^\n]*)\n")
FieldTable={} --{"Field1","Field2","Field3"}
fieldNumber=0
for field in (textTitles .. ";"):gmatch("([^;]*);") do
    fieldNumber=fieldNumber+1
    if firstLine=="YES" then
        FieldTable[#FieldTable+1]=field
    else
        FieldTable[#FieldTable+1]="Field" .. fieldNumber
    end --if firstLine=="YES" then
end --for field in (textTitles .. ";"):gmatch("([^;]*);") do

--2. goal and link definition
--2.1 goal definition
GoalTable={"Name","Vorname","OE_Schluessel","Test"}

--2.2 link definition
LinkTable={}
LinkTable["Field1"]=tostring(GoalTable[2]) --Ort
--LinkTable["Feld2"]=tostring(GoalTable[3]) --"Strasse"
LinkTable["Field2"]="Strasse"
LinkTable["Field3"]=tostring(GoalTable[1]) --"Name"

--3. function for treatment of nil values
function tostringNil(aText)
    if tostring(aText)=="nil" then
        return "" --can be "NULL"
    else
        return tostring(aText)
    end --if tostring(aText)=="nil" then
end --function tostringNil(aText)

--4. treat csv file
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
        if firstLine=="YES" then
            --print titles
            for i=1,#GoalTable-1 do
                outputText=outputText .. tostringNil(GoalTable[i]) .. ";"
            end --for i=1,#GoalTable-1 do
            outputText=outputText .. tostringNil(GoalTable[#GoalTable]) -- .. ";"
            print(outputText)
        elseif ColTable[GoalTable[1]] then
            --print titles
            for i=1,#GoalTable-1 do
                outputText=outputText .. tostringNil(GoalTable[i]) .. ";"
            end --for i=1,#GoalTable-1 do
            outputText=outputText .. tostringNil(GoalTable[#GoalTable]) -- .. ";"
            print(outputText)
            --print first row data
            outputText=""
            for i=1,#GoalTable-1 do
                outputText=outputText .. tostringNil(ColTable[GoalTable[i]]) .. ";"
            end --for i=1,#GoalTable-1 do
            outputText=outputText .. tostringNil(ColTable[GoalTable[#GoalTable]]) -- .. ";"
            print(outputText)
        end --if firstLine=="YES" then
    elseif ColTable[GoalTable[1]] then
        --print data
        for i=1,#GoalTable-1 do
            outputText=outputText .. tostringNil(ColTable[GoalTable[i]]) .. ";"
        end --for i=1,#GoalTable-1 do
        outputText=outputText .. tostringNil(ColTable[GoalTable[#GoalTable]]) -- .. ";"
        print(outputText)
    end --if ColTable["Name"] then
end --for line in (inputText.."\n"):gmatch("([^\n]*)\n") do
