--1. read XML File
inputfile1=io.open("C:\\Tree\\XMLtoLua\\example_XML.txt","r")
inputText=inputfile1:read("*a")
inputfile1:close()

--2. convert XML to Lua table
inputText=inputText
:gsub("<%?(xml[^>]*)>",'Tree_XML={branchname=[====[%1]====],') --take xml definition as root branch
:gsub("<([^/]*)/>","[====[%1]====],")                          --simple tags as leafs
:gsub("<!%-%-([^>]*)%-%->","")                                 --delete comments
:gsub("</[^>]*>","}")                                          --no comma here so that leafs can be converted to strings
:gsub("<([^>]*)>","{branchname=[====[%1]====],")               --Tags-Anfang als Branchname
:gsub(",([^,}]*)}",",[====[%1]====]}")                         --simple texts as leafs
:gsub("}","},")                                                --set comma after curly bracket
--translate XML special caracters
:gsub("&lt;","<"):gsub("&#60;","<"):gsub("&#x3C;","<")
:gsub("&gt;",">"):gsub("&#62;",">"):gsub("&#x3E;",">")
:gsub("&amp;","&"):gsub("&#38;","&"):gsub("&#x26;","&")
:gsub("&quot;",'"'):gsub("&#34;",'"'):gsub("&#x22;",'"')
:gsub("&apos;","'"):gsub("&#39;","'"):gsub("&#x27;","'")

--3. write Lua script
outputfile1=io.open("C:\\Tree\\XMLtoLua\\example_XML_UTF8.lua","w")
outputfile1:write(inputText ..  "\n}")
outputfile1:close()

--test with: print(inputText .. "\n}")
