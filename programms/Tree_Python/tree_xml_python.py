#This script scontains a tree defined as xml shown in a graphical user interface and a file browser tree

#1. data of the tree
data= '''
<IDIV>
<Dateien>
<file>/Tree/Tree_Python/filebrowser.py</file>
<file>/Tree/Tree_Python/test.lua</file>
<file>/Tree/Tree_Python/test.txt</file>

</Dateien>

<Verzeichnisse>
<Ordner>/Tree/Tree_Python</Ordner>
<Ordner>/Tree</Ordner>


</Verzeichnisse>


<Tree-Programme>

<file>/Tree/Tree_Python/tree_xml_python.py</file>

</Tree-Programme>

</IDIV>

'''



#2. imports os, Tkinter, xml.dom.minidom and idlelib.Treewidget
import os #operating system
from Tkinter import Tk, Canvas, Text, LabelFrame, Button
from xml.dom.minidom import parseString
from idlelib.TreeWidget import ScrolledCanvas, TreeItem, FileTreeItem, TreeNode

#3. build a class for the xml tree
class DomTreeItem(TreeItem):
	def __init__(self, node):
		self.node = node
	def GetText(self):
		node = self.node
		if node.nodeType == node.ELEMENT_NODE:
			return node.nodeName
		elif node.nodeType == node.TEXT_NODE:
			return node.nodeValue
	def IsExpandable(self):
		node = self.node
		return node.hasChildNodes()
	def GetSubList(self):
		parent = self.node
		children = parent.childNodes
		prelist = [DomTreeItem(node) for node in children]
		itemlist = [item for item in prelist if item.GetText().strip()]
		return itemlist
	def OnDoubleClick(self):
		#print("Klicken auf " + str(dir(self)))
		print("Klicken auf " + self.GetText())
		#test with: os.popen('open "' + self.GetText() + '"')
		inputText2=text1.get(1.0,'end-1c')
		text1.delete('1.0', "end")
		text2.delete('1.0', "end")
		if self.GetText().endswith(".py"):
			inputfile=open(self.GetText(),"r")
			textInput=inputfile.read()
			inputfile.close()
			text1.insert('1.0', self.GetText())
			text2.insert('1.0', textInput)
		elif self.GetText().endswith(".lua"):
			inputfile=open(self.GetText(),"r")
			textInput=inputfile.read()
			inputfile.close()
			text1.insert('1.0', self.GetText())
			text2.insert('1.0', textInput)
		elif self.GetText().endswith(".txt"): 
			inputfile=open(self.GetText(),"r")
			textInput=inputfile.read()
			inputfile.close()
			text1.insert('1.0', self.GetText())
			text2.insert('1.0', textInput)
		else:
			inputText2= inputText2 + " > " + self.GetText()
			text1.insert('1.0', inputText2)
	def GetIconName(self):
		if not self.IsExpandable():
			return "openfolder"
	def IsEditable(self):
		return "yes"

#4. build the graphical user interface
root = Tk()
root.title("Interaktiv-dynamisches Inhaltsverzeichnis (IDIV) mit XML und Python")
root.geometry('900x700')

#4.1 build the xml tree
sc = ScrolledCanvas(root, bg="white", highlightthickness=0, takefocus=1)
sc.frame.pack(expand=1, fill="both", side="left")
dom=parseString(data)
#test with: print(dom)
item=DomTreeItem(dom.documentElement)
node=TreeNode(sc.canvas, None, item)
node.update()
node.expand()

#4.2 build the file browser tree
sc1 = ScrolledCanvas(root, bg="white", highlightthickness=0, takefocus=1)
sc1.frame.pack(expand=1, fill="both", side="left")
item1 = FileTreeItem(os.getcwd())
node1=TreeNode(sc1.canvas, None, item1)
node1.update()
node1.expand()

#4.3 frame
labelframe1=LabelFrame(root,text="Frame")
labelframe1.pack()

#4.3.1 text field
text1=Text(labelframe1,width=12,height=4)
text1.pack(anchor="w")

#4.3.2 button open file
def button1_click():
	inputText1=text1.get(1.0,'end-1c')
	print("Datei " + inputText1 + " starten")
	p=os.popen('open "' + inputText1 + '"')
	print("Datei ... " + str(p))
	
button1=Button(labelframe1)
button1["text"]="Datei oeffnen"
button1.pack(anchor="w")
button1["command"]=button1_click


#4.3.3 button execute file
def button2_click():
	inputText1=text1.get(1.0,'end-1c')
	if inputText1.endswith(".py"):
		print("Datei " + inputText1 + " ausfuehren")
		p=os.popen('python "' + inputText1 + '" &')
		print("Datei ... " + str(p))
	elif inputText1.endswith(".lua"):
		print("Datei " + inputText1 + " ausfuehren")
		os.system('lua "' + inputText1 + '" &')
	
button2=Button(labelframe1)
button2["text"]="Datei ausfuehren"
button2.pack(anchor="w")
button2["command"]=button2_click

#4.3.4 text field
text2=Text(labelframe1,width=12,height=50)
text2.pack(anchor="w")

#5. show the graphical user interface
root.mainloop()

