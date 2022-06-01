
--1. transform basic code from wikipedia, aspecially with linebreaks
outputfile_txt=io.open("C:\\Temp\\test_first.txt","w")
inputfile_txt=io.open("C:\\Tree\\TeXtoHtml\\wikitex_example.txt","r")
textInput=inputfile_txt:read("*a")
textInput=textInput:gsub('.*<body[^>]*>(.*)</body>',"%1")
		:gsub('%[[^%]]*%]',"")
		:gsub('|%-\n!',"<tr><td>")
		:gsub("|%-\n| '''","<tr><td>")
		:gsub('<span class="mwe%-math%-element">.-</span><img.-alt="{\\displaystyle (.-)}"/></span>',"$\\it{%1}$")
		:gsub(":<math>(.-)</math>",":<mathE>%1</mathE>")
		:gsub("&nbsp;"," ")
		:gsub("&#160;"," ")
outputfile_txt:write(textInput)
inputfile_txt:close()
outputfile_txt:close()

--2. write a tex file
outputfile_tex=io.open("C:\\Temp\\test.tex","w")
outputfile_tex:write([[
\documentclass{article}

\begin{document}

]])
for line in io.lines("C:\\Temp\\test_first.txt") do
	line=line:gsub(":<mathE>","\\begin{equation}\\it{\n")
		:gsub("</mathE>%.",".\n}\\end{equation}")
		:gsub("</mathE>,",",\n}\\end{equation}")
		:gsub("</mathE>","\n}\\end{equation}")
		:gsub("<math>","$\\it{")
		:gsub("</math>","}$")
		:gsub("^{\\displaystyle(.*)}.$","\\begin{equation}\\it{\n%1.\n}\\end{equation}")
		:gsub("^{\\displaystyle(.*)},$","\\begin{equation}\\it{\n%1,\n}\\end{equation}")
		:gsub("^{\\displaystyle(.*)}$","\\begin{equation}\\it{\n%1\n}\\end{equation}")
		:gsub("{\\displaystyle(.-)}","$\\it{%1}$")
		:gsub("%%","\\%%")
		:gsub('{| class="wikitable"',"<table border=1>")
		:gsub('!!',"</td><td>")
		:gsub('||',"</td><td>")
		:gsub('|}',"</table>")
		:gsub("'''","")
		:gsub("^=[^=]","<h1>"):gsub("[^=]=$","</h1>")
		:gsub("^==[^=]","<h2>"):gsub("[^=]==$","</h2>")
		:gsub("^===[^=]","<h3>"):gsub("[^=]===$","</h3>")
		:gsub("^====[^=]","<h4>"):gsub("[^=]====$","</h4>")
		:gsub("^=====[^=]","<h4>"):gsub("[^=]=====$","</h5>")
	outputfile_tex:write(line .. "\n")
end --for line in io.lines("C:\\Temp\\test.txt") do
outputfile_tex:write([[

\end{document}

]])
outputfile_tex:close()

--3. transform tex file in html with tth from http://hutchinson.belmont.ma.us/tth/tth-noncom/download.html
os.execute('C:\\tth_exe\\tth.exe <c:\\Temp\\test.tex >c:\\Temp\\test_roh.html')

--4. produce final html file
outputfile_html=io.open("C:\\Temp\\test.html","w")
for line in io.lines("C:\\Temp\\test_roh.html") do
	line=line:gsub("&lt;ref&#62;"," (")
		:gsub("&lt;/ref&#62;",") ")
		:gsub("&lt;","<")
		:gsub("&#62;",">")
		:gsub("&#187;",'">')
		:gsub("#! ?",'')
		:gsub('<table class="wikitable">','<table class="wikitable" border=1>')
	outputfile_html:write(line .. "\n")
end --for line in io.lines("C:\\Temp\\test.txt") do
outputfile_html:close()


