# This script contains a tree defined as xml shown in a graphical user interface and a file browser tree

# 1. imports os, Tkinter, xml.dom.minidom and idlelib.tree
import os   # operating system
from tkinter import Tk, Text, LabelFrame, Button
from xml.dom.minidom import parseString
from idlelib.tree import ScrolledCanvas, TreeItem, FileTreeItem, TreeNode
import io   # input output utf8 etc.

# 2.1 data of the tree
import Tree_Testdaten
import config


#2.2 functionality to escape forbidden characters
def string_escape_forbidden_characters(stringInput):
    stringInput=stringInput.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n").replace("\r", "\\n")
    return stringInput


#2.3 output file or print
outputfile1 = "global variable"
def printOut(stringInput):
    outputfile1.write(str(stringInput) + "\n")


# 3.1 build a class for the xml tree Strg b auf TreeItem öffnet Definition
class DomTreeItem(TreeItem):
    def __init__(self, node):
        super().__init__()
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
        # print("Klicken auf " + str(dir(self)))
        print("Klicken auf " + self.GetText())
        # test with: os.popen('open "' + self.GetText() + '"')
        inputText2 = text1.get(1.0, 'end-1c')
        text1.delete('1.0', "end")
        text2.delete('1.0', "end")
        if self.GetText().endswith(".py"):
            inputfile = open(self.GetText(), "r")
            textInput = inputfile.read()
            inputfile.close()
            text1.insert('1.0', self.GetText())
            text2.insert('1.0', textInput)
        elif self.GetText().endswith(".lua"):
            inputfile = open(self.GetText(), "r")
            textInput = inputfile.read()
            inputfile.close()
            text1.insert('1.0', self.GetText())
            text2.insert('1.0', textInput)
        elif self.GetText().endswith(".txt"): 
            inputfile = open(self.GetText(), "r")
            textInput = inputfile.read()
            inputfile.close()
            text1.insert('1.0', self.GetText())
            text2.insert('1.0', textInput)
        else:
            inputText2 = inputText2 + " > " + self.GetText()
            text1.insert('1.0', inputText2)

    def GetIconName(self):
        if not self.IsExpandable():
            # return "openfolder"
            return "python"

    def IsEditable(self):
        return self.node != ""

    def SetText(self, text):
        # test with: print(text)
        node = self.node
        if node.nodeType == node.ELEMENT_NODE:
            # test with: print(node.nodeName)
            node.nodeName = text
        elif node.nodeType == node.TEXT_NODE:
            # test with: print(node.nodeValue)
            node.nodeValue = text


# 3.2 build a class for the os tree Strg b auf TreeItem öffnet Definition
class FileTreeItem1(TreeItem):

    """Example TreeItem subclass -- browse the file system."""

    def __init__(self, path):
        super().__init__()
        self.path = path
        # test with: print(self.path)

    def GetText(self):
        return os.path.basename(self.path) or self.path

    def IsEditable(self):
        return os.path.basename(self.path) != ""

    def SetText(self, text):
        # test with: print(self.path)
        newpath = os.path.dirname(self.path)
        newpath = os.path.join(newpath, text)
        if os.path.dirname(newpath) != os.path.dirname(self.path):
            return
        try:
            os.rename(self.path, newpath)
            self.path = newpath
        except OSError:
            pass

    def GetIconName(self):
        if not self.IsExpandable():
            # return "openfolder"
            return "python" # XXX wish there was a "file" icon

    def IsExpandable(self):
        return os.path.isdir(self.path)

    def GetSubList(self):
        try:
            names = os.listdir(self.path)
        except OSError:
            return []
        names.sort(key = os.path.normcase)
        sublist = []
        for name in names:
            item = FileTreeItem1(os.path.join(self.path, name))
            sublist.append(item)
        return sublist

    def OnDoubleClick(self):
        # print("Klicken auf " + str(dir(self)))
        print("Klicken auf " + self.path)
        text1.delete('1.0', "end")
        text1.insert('1.0', self.path)
        text2.delete('1.0', "end")
        inputfile = open(self.GetText(), "r")
        if inputfile:
            textInput = inputfile.read()
            inputfile.close()
            text2.insert('1.0', textInput)


# 4. build the graphical user interface
root = Tk()
root.title("Interaktiv-dynamisches Inhaltsverzeichnis (IDIV) mit XML und Python")
root.geometry('1200x700')


# 4.1 build the xml tree
sc = ScrolledCanvas(root, bg="white", highlightthickness=0, takefocus=1)
sc.frame.pack(expand=1, fill="both", side="left")
dom = parseString(Tree_Testdaten.data)
# test with: print(dom)
item = DomTreeItem(dom.documentElement)
node = TreeNode(sc.canvas, None, item)
node.update()
node.expand()

# 4.2 build the file browser tree
sc1 = ScrolledCanvas(root, bg="white", highlightthickness=0, takefocus=1)
sc1.frame.pack(expand=1, fill="both", side="left")
item1 = FileTreeItem1(os.getcwd())
node1 = TreeNode(sc1.canvas, None, item1)
node1.update()
node1.expand()

# 4.3 frame
labelframe1 = LabelFrame(root, text="Frame")
labelframe1.pack()

# 4.3.1 text field
text1 = Text(labelframe1, width=40, height=4)
text1.pack(anchor="w")


# 4.3.2 button open file
def button1_click():
    inputText1 = text1.get(1.0, 'end-1c')
    print("Datei " + inputText1 + " starten")
    p = os.popen(f'"{config.NotepadPath}" "{inputText1}"')
    # p = os.popen(r'"C:\notepad++npp.6.8.3.bin\notepad++.exe" "' + inputText1 + '"')
    # p = os.popen(r'"C:\Program Files\Notepad++\notepad++.exe" "' + inputText1 + '"')
    print("Datei ... " + str(p))


button1 = Button(labelframe1)
button1["text"] = "Datei oeffnen"
button1.pack(anchor="w")
button1["command"] = button1_click


# 4.3.3 button execute file
def button2_click():
    inputText1 = text1.get(1.0, 'end-1c')
    if inputText1.endswith(".py"):
        print("Datei " + inputText1 + " ausfuehren")
        p = os.popen('python "' + inputText1 + '" &')
        print("Datei ... " + str(p))
    elif inputText1.endswith(".lua"):
        print("Datei " + inputText1 + " ausfuehren")
        os.system('lua "' + inputText1 + '" &')


button2 = Button(labelframe1)
button2["text"] = "Datei ausfuehren"
button2.pack(anchor="w")
button2["command"] = button2_click


# 4.3.4 button read tree as text with tabulators

# 4.3.4.1 recursive function to read the tree
def recursiveNodeText(treeNode1,tabulator):
    for treeNode2 in treeNode1.children:
        treeNode2.expand()
        printOut(tabulator + "\t" + treeNode2.item.GetText())  # liefert nichts, wenn der Baum eingeklappt ist
        recursiveNodeText(treeNode2,tabulator + "\t")

# 4.3.4.2 button read tree as text with tabulators
def button3_click():
    global outputfile1
    outputfile1 = open("C:\\Temp\\test.txt", "w")
    printOut(node.item.GetText())
    for treeNode1 in node.children:
        treeNode1.expand()
        printOut("\t" + treeNode1.item.GetText())
        recursiveNodeText(treeNode1, "\t")
    outputfile1.close()

# 4.3.4.2a button read tree as text with tabulators
def button3_click_test_with():
    print(node.item.GetText())
    # print(node) <idlelib.tree.TreeNode object at 0x0000026159641B20>
    # print(node.children) [<idlelib.tree.TreeNode object at 0x000001C98C2B2CD0>, <idlelib.tree.TreeNode object at 0x000001C98C2B2D60>, <idlelib.tree.TreeNode object at 0x000001C98C2B2D90>]
    for treeNode1 in node.children:
        treeNode1.expand()
        # print(treeNode1) <idlelib.tree.TreeNode object at 0x000001AA2EE41D90>
        # <idlelib.tree.TreeNode object at 0x000001AA2EE41E20>
        # <idlelib.tree.TreeNode object at 0x000001AA2EE41E50>
        # print(dir(treeNode1)) ['__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', 'canvas', 'children', 'collapse', 'deselect', 'deselectall', 'deselecttree', 'destroy', 'draw', 'drawicon', 'drawtext', 'edit', 'edit_cancel', 'edit_finish', 'expand', 'flip', 'geticonimage', 'iconimages', 'image_id', 'item', 'label', 'lastvisiblechild', 'parent', 'select', 'select_or_edit', 'selected', 'state', 'text_id', 'update', 'view', 'x', 'y']
        # print(treeNode1.item) # <__main__.DomTreeItem object at 0x0000027DB4816160>
        # print(treeNode1.parent) # <idlelib.tree.TreeNode object at 0x0000027DB3BF0EE0>
        # print(treeNode1.children) # []
        print(treeNode1.item.GetText()) # Tree-Programme
        for treeNode2 in treeNode1.children:
            treeNode2.expand()
            print("\t" + treeNode2.item.GetText()) # liefert nichts, wenn der Baum eingeklappt ist
            for treeNode3 in treeNode2.children:
                treeNode3.expand()
                print("\t\t" + treeNode3.item.GetText()) # liefert nichts, wenn der Baum eingeklappt ist
                for treeNode4 in treeNode3.children:
                    treeNode4.expand()
                    print("\t\t" + treeNode4.item.GetText()) # liefert nichts, wenn der Baum eingeklappt ist


# 4.3.4.3 define button
button3 = Button(labelframe1)
button3["text"] = "Tree ausklappen und als Text mit Tabulatoren auslesen"
button3.pack(anchor="w")
button3["command"] = button3_click


# 4.3.5 button read tree as xml

# 4.3.5.1 recursive function to read the tree
def recursiveNodeXML(treeNode1,tabulator):
    for treeNode2 in treeNode1.children:
        treeNode2.expand()
        if treeNode2.children:
            outputfile1.write(tabulator + "<" + treeNode2.item.GetText() + ">")  # liefert nichts, wenn der Baum eingeklappt ist
        else:
            outputfile1.write(tabulator + treeNode2.item.GetText())
        recursiveNodeXML(treeNode2,tabulator )
        if treeNode2.children:
            printOut(tabulator + "</" + treeNode2.item.GetText() + ">")

# 4.3.5.2 button read tree as text with tabulators
def button4_click():
    global outputfile1
    outputfile1 = io.open("C:\\Tree\\Tree_Python\\Tree_Testdaten.py", "w", encoding="utf-8")
    outputfile1.write("# This script contains a tree defined as xml shown in a graphical user interface and a file browser tree\n")
    outputfile1.write("# 2. data of the tree\n")
    outputfile1.write("data = r'''\n")
    outputfile1.write("<" + node.item.GetText() + ">")
    for treeNode1 in node.children:
        treeNode1.expand()
        if treeNode1.children:
            outputfile1.write("<" + treeNode1.item.GetText() + ">")
        else:
            outputfile1.write(treeNode1.item.GetText())
        recursiveNodeXML(treeNode1, "")
        if treeNode1.children:
            printOut("</" + treeNode1.item.GetText() + ">")
    printOut("</" + node.item.GetText() + ">")
    outputfile1.write("'''\n")
    outputfile1.close()


# 4.3.5.3 define button
button4 = Button(labelframe1)
button4["text"] = "Tree ausklappen und als XML auslesen"
button4.pack(anchor="w")
button4["command"] = button4_click


# 4.3.6 button read tree as Lua tree

# 4.3.6.1 recursive function to read the tree
def recursiveNodeLua(treeNode1,tabulator):
    for treeNode2 in treeNode1.children:
        treeNode2.expand()
        if treeNode2.children:
            printOut(tabulator + "\t" + '{branchname="' + string_escape_forbidden_characters(treeNode2.item.GetText()) + '",')  # liefert nichts, wenn der Baum eingeklappt ist
        else:
            printOut(tabulator + "\t" + '"' + string_escape_forbidden_characters(treeNode2.item.GetText()) + '",')
        recursiveNodeLua(treeNode2,tabulator + "\t")
        if treeNode2.children:
            printOut(tabulator + "\t" + "} --" + string_escape_forbidden_characters(treeNode2.item.GetText()))

# 4.3.6.2 button read tree as text with tabulators
def button5_click():
    global outputfile1
    outputfile1 = open("C:\\Temp\\test.txt", "w")
    printOut('Tree={branchname="' + string_escape_forbidden_characters(node.item.GetText()) + '",')
    for treeNode1 in node.children:
        treeNode1.expand()
        if treeNode1.children:
            printOut("\t" + '{branchname="' + string_escape_forbidden_characters(treeNode1.item.GetText()) + '",')
        else:
            printOut('"' + string_escape_forbidden_characters(treeNode1.item.GetText()) + '",')
        recursiveNodeLua(treeNode1, "\t")
        if treeNode1.children:
            printOut("\t" + "} --" + string_escape_forbidden_characters(treeNode1.item.GetText()))
    printOut("} --" + string_escape_forbidden_characters(node.item.GetText()))
    outputfile1.close()


# 4.3.6.3 define button
button5 = Button(labelframe1)
button5["text"] = "Tree ausklappen und als Lua Tabelle auslesen"
button5.pack(anchor="w")
button5["command"] = button5_click


# 4.3.7 text field
text2 = Text(labelframe1, width=40, height=50)
text2.pack(anchor="w")


# 5. show the graphical user interface
root.mainloop()
