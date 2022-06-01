
--1. library for LuaCOM
require("luacom")           --require treatment of office files

--1.1 open Word with LuaCOM
word=luacom.CreateObject("Word.Application")
word.Visible=true

--1.2 build a new Word document
docNew=word.Documents:Add()
--or open old document: word.Documents:Open("C:\\Temp\\test.docx")

--1.3 path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)

--2.1 tree as Lua table
Tree={branchname="Baum erstellt am: Thu Oct 21 20:08:36 2021",
"C:\\Tree\\simpleDocTree\\example_HTML_table_for_webbrowser.lua",
"C:\\Tree\\simpleDocTree\\example_tree_for_webbrowser.lua",
{branchname="Erkl�rungen",
"F�r das Verfassen von Texten in Word ist dieses Skript Tree_word_build_luacom.lua eine M�glichkeit, ohne gro�en Aufwand die Ebenen zu definieren. Das ist ein eigener Text, der hier dargestellt werden kann. Dieser Text ist nicht in einem Ast, sondern in einem Blatt.",
},
{branchname="Weiteres Kapitel",
"Das ist ein weiteres Kapitel in dem Documentation Tree.",
},
}




--3. function to build recursively the tree
function readTreetohtmlRecursive(TreeTable,levelStart)
	level = levelStart or 0
	numberOfParagraph = (numberOfParagraph or 0) + 1
	AusgabeTabelle[TreeTable.branchname]=true
	docNew.Paragraphs:Add()
	docNew.Paragraphs(numberOfParagraph).Style="Überschrift " .. math.min(level+1,9)
	docNew.Paragraphs(numberOfParagraph).Range.Text= --test with: level .. ": " ..
						tostring(TreeTable.branchname)
						:gsub("�","\u{00E4}")
						:gsub("�","\u{00F6}")
						:gsub("�","\u{00FC}")
						:gsub("�","\u{00C4}")
						:gsub("�","\u{00D6}")
						:gsub("�","\u{00DC}")
						:gsub("�","\u{00DF}")
	--test with: print(docNew.Paragraphs(numberOfParagraph).Style())
	for k,v in ipairs(TreeTable) do
		if type(v)=="table" then
			level = level +1
			readTreetohtmlRecursive(v,level)
		else
			numberOfParagraph = numberOfParagraph + 1
			AusgabeTabelle[v]=true
			docNew.Paragraphs:Add()
			docNew.Paragraphs(numberOfParagraph).Style="Standard"
			docNew.Paragraphs(numberOfParagraph).Range.Text=
									tostring(v)
									:gsub("�","\u{00E4}")
									:gsub("�","\u{00F6}")
									:gsub("�","\u{00FC}")
									:gsub("�","\u{00C4}")
									:gsub("�","\u{00D6}")
									:gsub("�","\u{00DC}")
									:gsub("�","\u{00DF}")
			docNew.Paragraphs(numberOfParagraph).Range.ParagraphFormat.Alignment = 3 -- wdAlignParagraphJustify
		end --if type(v)=="table" then
	end --for k, v in ipairs(TreeTable) do
	level = level - 1
end --readTreetohtmlRecursive(TreeTable)

--4. collection of tree data by applying the recursive function
AusgabeTabelle={}
readTreetohtmlRecursive(Tree)

--5. save Word document
docNew:SaveAs2(path .. "\\" .. "Text.rtf",6)
