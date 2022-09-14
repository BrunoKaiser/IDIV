--This script converts Excel formulae also with complex brackets into a dependencies csv

--0. extract formulae from excel for instance with vba
vbaCode=[[
Sub vba^used_range()
Dim iCell As Range
Dim iRange As Range
Dim ws As Worksheet

For Each ws in Worksheets
    ws.Activate
    Set iRange = ws.UsedRange
    Debug.Print "Worksheet:" & ws.Name
    For Each iCell in iRange
        If Not IsEmpty(iCell) Them
            Debug.Print Replace(Replace(iCell.AddressLocal,"$","") & "=" & iCell.FormulaLocal,"==","=")
        End If 'If Not IsEmpty(iCell) Them
    Next iCell
Next ws
End Sub 'Sub vba^used_range()


]]

--1. input text of complex brackets
text=[[
Worksheet:Tabelle1
A1=B5
f=WERT(A2)
adf=(2*(34+A2))
B1=WENN(A1=23;"OK";"KO")
A2=B27
B2=WERT(A2)
Worksheet:Tabelle2
A1=B5
f=WERT(A1)
adf=(2*(34+A2))
B1=WENN(A1=23;WENN(adf=5;"so";"ach so");WENN(A2>6;"A";"B"))
A2=B27
B2=WERT(A2)
]]

--1.1 root text
rootText0="Excel file"
rootText="Test"

--2. show dependencies
lineTable={}
for line in (text .. "\n"):gmatch("([^\n]*)\n") do
    if line:match("Worksheet:") then
        rootText=line:match("Worksheet:(.*)")
    end --if line:match("Worksheet:") then
    if line:match("^[^=]*(%d+)[^=]*=") and lineTable["Zeile" .. line:match("^[^=]*(%d+)[^=]*=")]==nil then
        print("Zeile" .. line:match("^[^=]*(%d+)[^=]*=") .. ";" .. rootText)
        lineTable["Zeile" .. line:match("^[^=]*(%d+)[^=]*=")]=true
    end --if lineTable["Zeile" .. line:match("^[^=]*(%d+)[^=]*=")]==nil then
    --show cell definition and line
    pos=0
    if line:match("%b()") and line:match("^[^=]*(%d+)[^=]*=") then
        print( line:match("^[^=]+=") .. ";Zeile" .. line:match("^[^=]*(%d+)[^=]*=") )
    elseif line:match("^[^=]*(%d+)[^=]*=") then
        print( line .. ";Zeile" .. tostring(line:match("^[^=]*(%d+)[^=]*="))  )
    elseif line:match("%b()") then
        print( line:match("^[^=]+=") .. ";" .. rootText )
    elseif line:match("Worksheet:") then
        print( line .. ";" .. rootText0 )
    elseif line~="" then
        print( line .. ";" .. rootText )
    end --if line:match("%b()") then

    --treatment of text to handle key words in upper cases before brackets
    line=line:gsub("(%u+)(%()","%2%1~")
    :gsub("VAR ([^=]+=.*)RETURN","(VAR %1) RETURN")
    :gsub("([^=]) VAR","%1) (VAR")
    --test with: print(text)

    --define dependency towards the predecessor
    oldText=line:match("^[^=]+=")

    --loop through the brackets and show the denpendencies
    while true do
        pos_new=line:find("%b()",pos)
        if pos_new==nil then break end
        text_out=line:sub(pos_new)
        :match("%b()")
        :gsub("^%(",":"):gsub("%b()",""):gsub("^:","(")
        :gsub("(%()(%u+)~","%2%1")
        --show dependency
        print(text_out .. ";" ..    oldText )
        pos=pos_new+1
        --test with: print(pos)
        oldText=text_out
    end --while true do
end --for line in (text .. "\n"):gmatch("([^\n]*)\n") do
