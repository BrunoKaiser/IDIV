--This script converts complex brackets into a dependencies csv, for instance DAX formulae

--1. input text of complex brackets
text=[[Tabelle2 = VAR T = SFGR(5) VAR B = 5 RETURN SELECTCOLUMNS(FILTER('Table1','Table1'[Value]="122"),"1",[1])]]

--1.1 root text
rootText="Test"

--2. show the table name
pos=0
print( text:match("^[^=]+=")  .. ";" .. rootText  )

--2.1 treatment of text to handle key words in upper cases before brackets
text=text:gsub("(%u+)(%()","%2%1~")
:gsub("VAR ([^=]+=.*)RETURN","(VAR %1) RETURN")
:gsub("([^=]) VAR","%1) (VAR")
--test with: print(text)

--2.2 define dependency towards the predecessor
oldText=text:match("^[^=]+=")

--2.3 loop through the brackets and show the denpendencies
while true do
    pos_new=text:find("%b()",pos)
    if pos_new==nil then break end
    text_out=text:sub(pos_new)
    :match("%b()")
    :gsub("^%(",":"):gsub("%b()",""):gsub("^:","(")
    :gsub("(%()(%u+)~","%2%1")
    --show dependency
    print(text_out .. ";" ..    oldText )
    pos=pos_new+1
    --test with: print(pos)
    oldText=text_out
end
