--This auxiliary script is designed for copying html page as a Lua tree

treeTitle="auxiliary script"

htmlText=[[

<!DOCTYPE html> <head></head><html> <body>
<h1>Documentation Tree </h1>

<ul><li>Inhaltsverzeichnis

<ul><li>IUP-Lua-Installation

</li></ul>

<ul><li>Herunterladen der Oberfläche
<ul><li>ansicht_documentation_tree.lua</li></ul>
<ul><li>simple_webbrowser.lua</li></ul>
</li></ul>

<ul><li>Verwendungen im Büroalltag
</li></ul>

</li></ul>



</body></html>

]]

--put line break out of comments
exchangeText= htmlText:gsub("<h(%d)>(.-)\n(.-)</h(%d)>","<h%1>%2 %3</h%4>")
while exchangeText:match("<h%d>.-\n.-</h%d>") do
	exchangeText= exchangeText:gsub("<h(%d)>(.-)\n(.-)</h(%d)>","<h%1>%2 %3</h%4>")
end --while exchangeText:match("<h%d>.-\n.-</h%d>") do
exchangeText= exchangeText:gsub("<p>(.-)\n(.-)</p>","<p>%1 %2</p>")
while exchangeText:match("<p>.-\n.-</p>") do
	exchangeText= exchangeText:gsub("<p>(.-)\n(.-)</p>","<p>%1 %2</p>")
end --while exchangeText:match("<p>.-\n.-</p>") do
exchangeText= exchangeText:gsub("<ul><li>(.-)\n(.-)</li></ul>","<ul><li>%1 %2</li></ul>")
while exchangeText:match("<ul><li>.-\n.-</li></ul>") do
	exchangeText= exchangeText:gsub("<ul><li>(.-)\n(.-)</li></ul>","<ul><li>%1 %2</li></ul>")
end --while exchangeText:match("<ul><li>.-\n.-</li></ul>") do
--take <ul><li> tags as a Lua tree
exchangeText=exchangeText:gsub("<ul><li>",'\n{branchname="')
exchangeText=exchangeText:gsub("</li></ul>",'\n},')
exchangeText=exchangeText:gsub('{branchname="(.-) *\n','{branchname="%1",\n')
exchangeText=exchangeText:gsub("<h.-/h%d>","") --do not take titles
				:gsub("<p.-/p>","") --do not take paragraphs
				:gsub("<br>","") --do not take line breaks
exchangeText=exchangeText:gsub("\n([^{}\n]+)\n","\n--%1\n") --add comments to all lines not in tree first replacement
exchangeText=exchangeText:gsub("\n([^%-{}\n]+)\n","\n--%1\n") --add comments to all lines not in tree second replacement
exchangeText='Tree={branchname="' .. treeTitle .. '",\n' .. exchangeText .. "\n}"
exchangeText = exchangeText:gsub("<.->","") --add comments to all lines not in tree

print(exchangeText)

