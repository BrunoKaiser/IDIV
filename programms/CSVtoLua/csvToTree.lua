--This script converts csv parts in a text to tree with tabs

--1.1 text with csv parts
textCsv=[[
Titelzeile der Csv-Datei
Daten1;Ort1;Straße1;Name1
Daten2;Ort2;Straße2;Name2
]] ..
"\tschon ein Knoten\n" ..

[[
Daten1a;Ort1;Straße1;Name1
Daten2a;Ort2;Straße2;Name2
]] ..

"\t\tSchon ein Unterknoten\n" ..
"\t\t\tSchon ein Blatt\n" .. [[
Daten3;Ort3;Straße3;Name3
]]

--1.2 global data
numberTabs=0

--2. print text as tree
for line_raw in (textCsv .. "\n"):gmatch("([^\n]*)\n") do
    --delete double ;; or more
    --line_raw=line_raw:gsub(";+",";")
    if line_raw:match("^\t+[^\t]+$") then
        print(line_raw)
        _,numberTabs=line_raw:gsub("\t","")
        --test with: print(numberTabs)
    elseif line_raw:match(";")==nil then
        print(line_raw)
        numberTabs=0
    else
        --test with: print(line_raw)
        line=line_raw
        --build table with nodes
        TabTable={}
        for i=#line_raw,1,-1 do
            --test with: print(line:sub(i,i))
            if line:sub(i,i)==';' then
                --test with: print(line:sub(1,i):gsub("[^;]",""):gsub(";","\t") .. line:sub(i+1))
                TabTable[#TabTable+1]=string.rep("\t",numberTabs+1) .. line:sub(1,i):gsub("[^;]",""):gsub(";","\t") .. line:sub(i+1)
                line=line:sub(1,i-1)
            end --if line:sub(i,i)=='"' then
        end --for i=#line_raw,1,-1 do
        --show the csv or tab-separated data as tree
        print(string.rep("\t",numberTabs+1) .. line)
        for k=#TabTable,1,-1 do
            print(TabTable[k])
        end --for k=#TabTable,1,-1 do
    end --if line_raw:match(";")==nil then
end --for (textCsv .. "\n"):gmatch("([^\n]*)\n") do
