

--1. tree as Lua table
Tree={branchname="Tipps und Tricks",
    "Diese Datenbank ist ein Beispiel",
    {branchname="Drittanwendungen",
        {branchname="Einleitung",
            {branchname="Erkärungen","1","2", },
        },
        {branchname="Tipps nach Werkzeug",
            {branchname="Excel","1","2", },
            {branchname="Access",
                {branchname="Accesstabelle",
                    "soso 1","2",
                },
            },
            {branchname="Notepad++","1","2", },
        },
        {branchname="Tipps nach Problem",
            {branchname="1","Excel","2", },
            {branchname="2","Access","2", },
            {branchname="3","Notepad++","2", },
        },
        {branchname="Tipps nach Drittanwendung",
            {branchname="1afhvj", },

            {branchname="2tzjjk","Access","2", },

            {branchname="3hjijnl","Notepad++","2", },
        },
    },
}


--1.1 global data
nodeNumber=-1
levelTable={}
levelNumber=-1

--2. recursive function to read the Lua tree and print SQL statements
function recursiveReadTree(TreeTable)
    nodeNumber=nodeNumber+1
    levelNumber=levelNumber+1
    --print(nodeNumber,levelNumber,TreeTable.branchname)
    levelTable[nodeNumber]=levelNumber
    --write html tags
    if levelNumber==0 then
        print("<h1>" .. TreeTable.branchname .. "</h1>")
    elseif levelNumber==1 then
        print("<h2>" .. TreeTable.branchname .. "</h2>")
    elseif levelNumber==2 then
        print("<h3>" .. TreeTable.branchname .. "</h3>")
    elseif levelNumber>2 then
        local y=""
        if TreeTable.branchname=="Excel" then
            y =";background-color:LimeGreen"
        elseif TreeTable.branchname=="Access" then
            y =";background-color:IndianRed"
        elseif TreeTable.branchname=="Notepad++" then
            y =";background-color:GreenYellow"
        end --if TreeTable=="Excel" then
        local x
        if #TreeTable>0 then
            x='<details><summary style="margin-left: ' .. (levelNumber-2)*2 .. 'em' .. y .. '">'
        else
            x='<summary style="margin-left: ' .. (levelNumber-2)*2+1 .. 'em' .. y .. '">'
        end --if #TreeTable>0 then
        print( x .. TreeTable.branchname .. "</summary>")
    else
        print(TreeTable.branchname)
    end --if levelNumber==0 then
    --read table indices
    for i,v in ipairs(TreeTable) do
        if type(v)=="table" then
            recursiveReadTree(v)
        else
            nodeNumber=nodeNumber+1
            levelNumber=levelNumber+1
            levelTable[nodeNumber]=levelNumber
            --print(nodeNumber,levelNumber,v)
            local y=""
            if v=="Excel" then
                y =";background-color:LimeGreen"
            elseif v=="Access" then
                y =";background-color:IndianRed"
            elseif v=="Notepad++" then
                y =";background-color:GreenYellow"
            end --if TreeTable=="Excel" then
            if levelNumber>2 then
                print('<p style="margin-left: ' .. (levelNumber-2)*2 .. 'em' .. y .. '">' .. v .. "</p>")
            else
                print('<p style="margin-left: 0em' .. y .. '">' .. v .. "</p>")
            end --if levelNumber>2 then
        end --if type(v)=="table" then
        levelNumber=levelNumber-1
        --test with: print(levelNumber)
    end --for i,v in ipairs(TreeTable) do
    print("</details><!-- " .. TreeTable.branchname .. "-->")
    print("")
end --function recursiveReadTree()

--3. apply the recursive function
recursiveReadTree(Tree)


