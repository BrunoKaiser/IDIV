--This script builds and prints SQL statements for a data base from a Lua tree

--1. tree as Lua table
Tree={branchname="Datenbank",
    "Diese Datenbank ist ein Beispiel",
    {branchname="Build tables",
        {branchname="Personen",
            {branchname="Id","INT PRIMARY KEY NOT NULL", 1,2, },
            {branchname="Vorname","TEXT", "Ralf","Zita", },
            {branchname="Nachname","TEXT", "Günther","Günther-Farago", },
            {branchname="AdressenId","INT", 1,2, },
        },
    },
    {branchname="Adressen werden separat eingepflegt",
        {branchname="Build tables",
            {branchname="Adressen",
                {branchname="AdressenId","INT PRIMARY KEY NOT NULL", 1,2, },
                {branchname="PLZ","TEXT", "12233","23335", },
                {branchname="Ort","TEXT", "Bad Vilbel","Bad Wilböl", },
                {branchname="StrasseHausnummer","TEXT", "Sesamstr. 43","Lindenstraße 2i", },
            },
        },
    },
    {branchname="Abfragen",
        {branchname="Views",
            {branchname="Adressenzeigen",
                {branchname="Personen INNER JOIN ",
                    "Id",
                    "Vorname",
                    "Nachname",
                },
                {branchname="Adressen ON Adressen.AdressenId=Personen.AdressenId",
                    "AdressenId AS Nummer",
                    "PLZ || Ort AS PLZOrt",
                    "StrasseHausnummer",
                },
            },
            {branchname="Ortstatistik",

                {branchname="Adressen",

                    "PLZ || Ort AS PLZOrt",
                    "count(*) AS AnzahlAdressen",
                },
            },
        },
    },
}

--2. recursive function to read the Lua tree and print SQL statements
function recursiveReadTree(TreeTable)
    if TreeTable.branchname=="Build tables" then
        for i,v in ipairs(TreeTable) do
            --build tables
            print("CREATE TABLE IF NOT EXISTS " .. v.branchname .. " (")
            for i1,v1 in ipairs(TreeTable[i]) do
                if i1<#v then
                    print(v[i1].branchname .. " " .. v[i1][1] .. ", ")
                else
                    print(v[i1].branchname .. " " .. v[i1][1] .. "); ")
                end --if i1<#v then
            end --for i,v in ipairs(TreeTable) do
            --insert SQL
            for k=2,#v[1] do
                print("INSERT INTO " .. v.branchname .. " ")
                local valueText=" VALUES ("
                local fieldText="("
                for j=1,#v do
                    if j<#v then
                        fieldText=fieldText .. " " ..  v[j].branchname .. ", "
                        if type(v[j][k])=="number" then
                            valueText=valueText .. " " .. v[j][k] .. ", \n"
                        else
                            valueText=valueText .. ' "' .. v[j][k] .. '", \n'
                        end --if type(v[j][k])=="number" then
                    else
                        fieldText=fieldText .. " " .. v[j].branchname .. ")"
                        if type(v[j][k])=="number" then
                            valueText=valueText .. " " .. v[j][k] .. "); "
                        else
                            valueText=valueText .. ' "' .. v[j][k] .. '"); '
                        end --if type(v[j][k])=="number" then
                    end --if j<#v then
                end --for k=2,#v[j] do
                print(fieldText)
                print(valueText)
            end --for j=2,#v do
        end --for i,v in ipairs(TreeTable) do
    elseif TreeTable.branchname=="Views" then
        for i,v in ipairs(TreeTable) do
            --build views
            print("CREATE VIEW IF NOT EXISTS " .. v.branchname .. " AS SELECT ")
            local selectText=""
            for j=1,#v do
                for k=1,#v[j] do
                    if v[j][k].branchname then
                        selectText=selectText .. v[j][k].branchname
                    else
                        selectText=selectText .. v[j][k]
                    end --if v[j][k].branchname then

                    if not (j==#v and k==#v[j]) then
                        selectText=selectText .. ",\n"
                    end --if not (j==#v and k==#v[j]) then
                end --for k=1,#v[j] do
            end --for j=1,#v do
            print(selectText)
            print("FROM ")
            for j=1,#v do
                print(v[j].branchname)
            end --for j=1,#v do
            print("; ")
        end --for i,v in ipairs(TreeTable) do
    else
        for i,v in ipairs(TreeTable) do
            if type(v)=="table" then
                recursiveReadTree(v)
            end --if type(v)=="table" then
        end --for i,v in ipairs(TreeTable) do
    end --if TreeTable=="Create Table" then
end --function recursiveReadTree()

--3. apply the recursive function
recursiveReadTree(Tree)

