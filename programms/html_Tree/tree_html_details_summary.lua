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

--2.1 function to show results or put them in a file
printOut=print
function printOut(a)
	outputFile:write(a .. "\n")
end --function printOut(a)
outputFile=io.open("C:\\Temp\\SQLtoCSVforLua_List.html","w")

--2.2 recursive function to read the Lua tree and printOut SQL statements
function recursiveReadTree(TreeTable)
    nodeNumber=nodeNumber+1
    levelNumber=levelNumber+1
    --printOut(nodeNumber,levelNumber,TreeTable.branchname)
    levelTable[nodeNumber]=levelNumber
    --write html tags
    if levelNumber==0 then
        printOut("<h1>" .. TreeTable.branchname .. "</h1>")
    elseif levelNumber==1 then
        printOut("<h2>" .. TreeTable.branchname .. "</h2>")
    elseif levelNumber==2 then
        printOut("<h3>" .. TreeTable.branchname .. "</h3>")
    elseif levelNumber>2 then
        local x
        if #TreeTable>0 and TreeTable.state=="COLLAPSED" then
            x='<details><summary style="margin-left: ' .. (levelNumber-2)*2 .. 'em">'
        elseif #TreeTable>0 then
            x='<details open><summary style="margin-left: ' .. (levelNumber-2)*2 .. 'em">'
        else
            x='<summary style="margin-left: ' .. (levelNumber-2)*2+1 .. 'em">'
        end --if #TreeTable>0 then
        printOut( x .. TreeTable.branchname .. "</summary>")
    else
        printOut(TreeTable.branchname)
    end --if levelNumber==0 then
    --read table indices
    for i,v in ipairs(TreeTable) do
        if type(v)=="table" then
            recursiveReadTree(v)
        else
            nodeNumber=nodeNumber+1
            levelNumber=levelNumber+1
            levelTable[nodeNumber]=levelNumber
            --printOut(nodeNumber,levelNumber,v)
            if levelNumber>2 then
                printOut('<p style="margin-left: ' .. (levelNumber-2)*2 .. 'em">' .. v .. "</p>")
            else
                printOut('<p>' .. v .. "</p>")
            end --if levelNumber>2 then
        end --if type(v)=="table" then
        levelNumber=levelNumber-1
        --test with: printOut(levelNumber)
    end --for i,v in ipairs(TreeTable) do
    if levelNumber>2 and #TreeTable>0 then
        printOut("</details><!-- " .. TreeTable.branchname .. "-->")
        printOut("")
    end --if levelNumber>2 and #TreeTable>0 then
    printOut("")
end --function recursiveReadTree()

--3. apply the recursive function
recursiveReadTree(Tree)

--4. close output file
outputFile:close()
