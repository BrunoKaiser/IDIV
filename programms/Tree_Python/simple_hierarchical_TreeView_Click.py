#This script build a graphical user interface with data from a tree in a file as a Lua table. It uses the library slpp from Sir Anthony to convert Lua tables in python dictionaries.

#1. import libraries
from tkinter import *
from tkinter import ttk
import os
#https://github.com/SirAnthony/slpp: C:\Tree\Tree_Python\setup.py mit setup.cfg und slpp.py ausfuehren
from slpp import slpp as lua 
#import library for regex expressions for pattern matching
import re
#https://pypi.org/project/lupa/ pip install lupa
import lupa
from lupa import LuaRuntime
lua2 = LuaRuntime(unpack_returned_tuples=True)

#1.1 check if file exists
if os.path.exists('C:\\Tree\\Tree_Python\\Tree_Baum_script.lua')==False:
    file0 = open("C:\\Tree\\Tree_Python\\Tree_Baum_script.lua", "w")
    file0.write("p=io.popen('dir C:\\\\Tree\\\\Tree_Python /b/o/s')\nfor file in p:lines() do print(file) end")
    file0.close() #This close() is important

#1.2 execute Lua script
lua2_function2=lua2.eval('function() dofile("C:\\\\Tree\\\\Tree_Python\\\\Tree_Baum_script.lua") end ')
lua2_function2()

#2. read Lua tree file
file0 = open('C:\\Tree\\Tree_Python\\Tree_Baum.lua','r')
Text="--" + file0.read().replace("{","\n{")
#print(Text)
#example for tree: data = lua.decode('{ branchname = "Text", "Text2", }')

#2.1 decode Lua tree to be python dictionary: 
data = lua.decode(Text)
#print(data)
#print(data["branchname"])
#print(lua.encode(data))

#2.2 functionality to escape forbidden characters
def string_escape_forbidden_characters(stringInput):
    stringInput=stringInput.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n").replace("\r", "\\n")
    return stringInput

#3. build GUI
app=Tk()
app.geometry("800x800")
app.title('GUI')

#3.2 build the tree
ttk.Label(app, text ='Tree').pack(side=TOP)
treeview1=ttk.Treeview(app,height=30,column=("c1"))
treeview1.column('# 0',width=650)
treeview1.column('# 1',width=2)
treeview1.heading('# 0',text="IDIV-Basiskomponente.")

#3.2.1 put the tree in the GUI
treeview1.pack(side=TOP)

#3.2.2 define tags for marked nodes
treeview1.tag_configure('BLUE_TAG', foreground='blue', font=('arial', 12))
treeview1.tag_configure('RED_TAG', foreground='red', font=('arial', 12))
treeview1.tag_configure('BLACK_TAG', foreground='black', font=('arial', 12))

#3.3 dictionary to build nodes
folderDict={}

#3.3.1 build root node
folderDict["0"]=treeview1.insert('','0','item0',text='Stamm') # expand with: ,open=True,tag='BLACK_TAG')
#example manually: folderDict["0.1"]=treeview1.insert(folderDict["0"],'end','item_manual_1',text='C:\\Tree\\reflexiveDocTree\\results\\2021\\Beispiel_NI2.png')

#3.3.2 dictionary for the level information in key -1 and the parent node information in the key with the level as text
numberNodeDict={}
numberNodeDict["-1"]=0

#3.3.3 treat recursively the tree in the Lua script
#3.3.3.1 function to treat recursively the tree
def treeRecursive(tree,level,numberNode):
    for key in tree:
        if type(tree[key])==dict:
            treeRecursive(tree[key],level+1,folderDict[numberNodeDict[str(level)]]) #numberNodeDict[str(level)])
        else:
            numberNodeDict["-1"]=numberNodeDict["-1"]+1
            #test with: print(numberNodeDict["-1"],level,key,tree[key])
            if key=='branchname':
                folderDict[tree[key]]=treeview1.insert(numberNode,'end','item' + str(numberNodeDict["-1"]),text=tree[key].replace("\\\\","\\"))
                #test with: print(tree[key],folderDict[tree[key]])
                #for the level a node is chosen as node to put children by name of the node so it is item6 for instance.
                numberNodeDict[str(level)]=tree[key] #folderDict["Uebersicht ueber die Taetigkeiten"]
            else:
                folderDict[numberNodeDict["-1"]]=treeview1.insert(folderDict[numberNodeDict[str(level)]],'end','item' + str(numberNodeDict["-1"]),text=tree[key].replace("\\\\","\\"))
#test with: print(folderDict["0"])
#3.3.3.2 apply the recursive function
treeRecursive(data,0,folderDict["0"])


#4.1 expand all folders recursively
#4.1.1 recursive functionality
def open_children(parent):
    treeview1.item(parent,open=True)
    treeview1.item(parent,tag='BLACK_TAG')
    for child in treeview1.get_children(parent):
        open_children(child)
#apply recursive functionality
open_children('item0')



#5. define the mouse control
class MouseControl:
    def __init__(self,aw):
        self.double_click_flag=False
        self.aw=aw
        self.aw.bind('<Double-1>',self.double_click) #bind double click left
    def double_click(self, event):
        #test with: print("you double clicked on left")
        item = treeview1.selection()[0]
        #print(treeview1.item(item,"text"),treeview1.item(item,"text").find(":\\"))
        if treeview1.item(item,"text").find(":\\")>0:
            print("Open " + treeview1.item(item,"text"))
            os.system('start "D" "' + treeview1.item(item,"text") + '"')
        else:
            print("Do not open " + treeview1.item(item,"text"))

#5.1 apply the mouse control to the GUI
mouse=MouseControl(app)

#5.1.1 text area
textfield1 = ttk.Entry(app,text="",width="120")
textfield1.pack(side=TOP)


#5.2 buttons

#5.2.1 style for buttons
#https://docs.python.org/3/library/tkinter.ttk.html#ttk-styling
style = ttk.Style()
style.configure("BW.TLabel", background="blue", foreground="white")
ttk.Label(app, text ='   ').pack(side=LEFT)

#5.2.2 define button and action to write file with Lua table with recursive functionality
def button_write_lua_file_CallBack():
    file1 = open("C:\\Tree\\Tree_Python\\Tree_Baum.lua", "w")
    file1.write("Tree=\n")
    levelDict={}
    levelDict["-1"]=0
    def write_children(parent,level):
        file1.write("--" + str(levelDict["-1"]) + ": " + str(level) +'",\n')
        for i1 in range(0,levelDict["-1"]-level+1):
            if levelDict["-1"]>0 and level>0:
                file1.write('},\n')
        if levelDict["-1"]>0 or level>0:
            file1.write('{branchname="' + string_escape_forbidden_characters(treeview1.item(parent,"text")) + '",\n')
        levelDict["-1"]=level
        for child in treeview1.get_children(parent):
            write_children(child,level+1)
    write_children('item0',0)
    for i1 in range(0,levelDict["-1"]-1):
        file1.write('},\n')
    file1.write('}\n')
    file1.close() #This close() is important
    print("C:\\Tree\\Tree_Python\\Tree_Baum.lua wurde gespeichert.")
button_write_lua_file = ttk.Button(app, text ="Lua Tabelle als \nDatei speichern", command = button_write_lua_file_CallBack, style="BW.TLabel")
button_write_lua_file.pack(side=LEFT)
ttk.Label(app, text =' ').pack(side=LEFT)



#5.2.3 open file in notepad if possible
def button_open_notepad_CallBack():
    item = treeview1.selection()[0]
    if treeview1.item(item,"text").find(":\\")>0:
        print("Open in notepad: " + treeview1.item(item,"text"))
        os.system('start notepad.exe "' + treeview1.item(item,"text") + '" &')
    else:
        print("Do not open in notepad: " + treeview1.item(item,"text"))
button_open_notepad = ttk.Button(app, text ="Im Notepad \noeffnen", command = button_open_notepad_CallBack, style="BW.TLabel")
button_open_notepad.pack(side=LEFT)
ttk.Label(app, text =' ').pack(side=LEFT)


#5.2.4 mark searched nodes and unmark all nodes buttons

#5.2.4.1 define button and action to mark nodes with recursive functionality
def mark_node(parent1):
    #test with: print(treeview1.item(parent1,"text"))
    if treeview1.item(parent1,"text").find(textfield1.get())>=0:
        treeview1.item(parent1,tag='BLUE_TAG')
        parentDict={}
        parentDict["1"]=treeview1.parent(parent1)
        treeview1.item(parentDict["1"],tag='RED_TAG')
        i=1
        while i>0:
            parentDict[str(i+1)]=treeview1.parent(parentDict[str(i)])
            if parentDict[str(i+1)]:
                treeview1.item(parentDict[str(i+1)],tag='RED_TAG')
                i=i+1
            else:
                i=-1
    for child in treeview1.get_children(parent1):
        mark_node(child)
def button_mark_searched_nodes_CallBack():
    #apply recursive functionality
    mark_node('item0')
button_mark_searched_nodes = ttk.Button(app, text ="Suchergebnisse \nmarkieren", command = button_mark_searched_nodes_CallBack, style="BW.TLabel")
button_mark_searched_nodes.pack(side=LEFT)
ttk.Label(app, text =' ').pack(side=LEFT)

#5.2.4.2 define button and action to mark nodes with recursive functionality
def unmark_node(parent):
    treeview1.item(parent,tag='BLACK_TAG')
    for child in treeview1.get_children(parent):
        unmark_node(child)
def button_unmark_searched_nodes_CallBack():
    #apply recursive functionality
    unmark_node('item0')
button_unmark_searched_nodes = ttk.Button(app, text ="Markierung \naufheben", command = button_unmark_searched_nodes_CallBack, style="BW.TLabel")
button_unmark_searched_nodes.pack(side=LEFT)
ttk.Label(app, text =' ').pack(side=LEFT)

#5.2.5 define button to insert branch
countDict={}
countDict["-1"]=0
def count_node(parent):
    countDict["-1"]=countDict["-1"]+1
    for child in treeview1.get_children(parent):
        count_node(child)
def button_insert_nodes_CallBack():
    count_node('item0')
    item = treeview1.selection()[0]
    treeview1.insert(item ,'end','item'+str(countDict["-1"]),text='_')
button_insert_nodes = ttk.Button(app, text ="Knoten \nanhaengen", command = button_insert_nodes_CallBack, style="BW.TLabel")
button_insert_nodes.pack(side=LEFT)
ttk.Label(app, text =' ').pack(side=LEFT)

#5.2.6 define button to delete node
def button_delete_nodes_CallBack():
    item = treeview1.selection()[0]
    treeview1.delete(item)
button_delete_nodes = ttk.Button(app, text ="Knoten \nloeschen", command = button_delete_nodes_CallBack, style="BW.TLabel")
button_delete_nodes.pack(side=LEFT)
ttk.Label(app, text =' ').pack(side=LEFT)

#5.2.7 define button to change node
textDict={}
textDict["-1"]=""
def button_change_nodes_CallBack():
    item = treeview1.selection()[0]
    textDict["-1"]=treeview1.item(item,"text")
    treeview1.item(item,text=textfield1.get())
button_change_nodes = ttk.Button(app, text ="Knoten \naendern", command = button_change_nodes_CallBack, style="BW.TLabel")
button_change_nodes.pack(side=LEFT)
ttk.Label(app, text =' ').pack(side=LEFT)

#5.2.8 define button to delete branch
def button_change_nodes_CallBack():
    item = treeview1.selection()[0]
    treeview1.item(item,text=textDict["-1"])
button_change_nodes = ttk.Button(app, text ="Knoten \neinfuegen", command = button_change_nodes_CallBack, style="BW.TLabel")
button_change_nodes.pack(side=LEFT)
ttk.Label(app, text =' ').pack(side=LEFT)

#5.2.9 define button to delete branch
def button_change_nodes_CallBack():
    item = treeview1.selection()[0]
    textDict["-1"]=treeview1.item(item,"text")
    textfield1.insert(0,treeview1.item(item,"text"))
button_change_nodes = ttk.Button(app, text ="Knoten \nkopieren", command = button_change_nodes_CallBack, style="BW.TLabel")
button_change_nodes.pack(side=LEFT)
ttk.Label(app, text =' ').pack(side=LEFT)

#5.2.10 define button to update console with Lua script
def button_update_console_CallBack():
    lua2_function2()
button_update_console = ttk.Button(app, text ="Konsole \naktualisieren", command = button_update_console_CallBack, style="BW.TLabel")
button_update_console.pack(side=LEFT)
ttk.Label(app, text =' ').pack(side=LEFT)

#6. start the main loop for the GUI
app.mainloop()
