--This script builds a html file with titels, subtitles and subsubtitles being always open, but all text under them ist organized in tree view with details summary and can be opened or closed

--1. tree as Lua table
Tree={branchname="Tipps und Tricks",
    "Diese Datenbank ist ein Beispiel",
    {branchname="Drittanwendungen",
        {branchname="Einleitung", state="COLLAPSED",
            {branchname="Erkärungen", state="COLLAPSED","1","2", },
        },
        {branchname="Tipps nach Werkzeug",
            {branchname="Excel", state="COLLAPSED",

            "1","2", },
            {branchname="Access", state="COLLAPSED",
                {branchname="Accesstabelle",
                    "soso 1","2",
                },
            },
            {branchname="Notepad++", state="COLLAPSED","1","2", },
        },
        {branchname="Tipps nach Problem",
            {branchname="1", state="COLLAPSED","Excel","2", },
            {branchname="2", state="COLLAPSED","Access","2", },
            {branchname="3", state="COLLAPSED","Notepad++","2", },
        },
        {branchname="Tipps nach Drittanwendung",
            {branchname="1afhvj", },

            {branchname="2tzjjk", state="COLLAPSED","Access","2", },

            {branchname="3hjijnl", state="COLLAPSED","Notepad++","2", },
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
        local x
        if #TreeTable>0 and TreeTable.state=="COLLAPSED" then
            x='<details><summary style="margin-left: ' .. (levelNumber-2)*2 .. 'em">'
        elseif #TreeTable>0 then
            x='<details open><summary style="margin-left: ' .. (levelNumber-2)*2 .. 'em">'
        else
            x='<summary style="margin-left: ' .. (levelNumber-2)*2+1 .. 'em">'
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
            if levelNumber>2 then
                print('<p style="margin-left: ' .. (levelNumber-2)*2 .. 'em">' .. v .. "</p>")
            else
                print('<p>' .. v .. "</p>")
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


