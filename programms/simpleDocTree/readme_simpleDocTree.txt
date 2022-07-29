This repository has a simple version of a documentation tree with only one tree and other functionalities to be able to see documentation trees of databases or other trees

1. simple_documentation_tree.lua

The special functionalities are expand/collapse nodes and sort in alphabetic order.

2.  SQLtoCSVforLua_dependencies_tree.lua

The file SQLtoCSVforLua_dependencies_tree.lua is an example file as input for simple_documentation_tree.lua

3.1 simple_documentation_tree_with_file_dialog.lua

This documentation tree has also a button to load a new tree with a file dialog in the tree loaded at the beginning. To change the tree it must be deleted manually, so that the user can build individual trees by himself.

3.2 simple_documentation_tree_with_file_dialog_Linux.lua

This is the Linux version of the simple_documentation_tree_with_file_dialog.lua. There are minor changes: the path names must be in Linux manner and the tree.addbranch and tree.addleaf are substituted by tree['addbranch' .. tree.value] and tree['addleaf' .. tree.value].

This documentation tree has also a button to load a new tree with a file dialog in the tree loaded at the beginning. To change the tree it must be deleted manually, so that the user can build individual trees by himself.

4. simple_documentation_tree_with_webbrowser.lua

This script is a tree on the left side and a html-Webbrowser on the right side, where nodes of the tree can be associated to webpages shown by going to them.

5. example_tree_for_webbrowser.lua

This is an example as input tree for simple_documentation_tree_with_webbrowser.lua.

6. example_HTML_table_for_webbrowser.lua

This is an example as input HTML webpages in Lua table for simple_documentation_tree_with_webbrowser.lua. 

7. simple_documentation_tree_brackets.lua

This script runs a graphical user interface (GUI) in order to built up a documentation tree of SQL statements or of excel formulas.

8. simple_documentation_tree_with_analysis.lua

This script opens a tree and analysis of it can be done, especially the analysis of dublicate nodes.

9. graphical user interfaces with SQLite

These scripts needs SQLite. It must be installed with command line tools so that C:\sqlite3\sqlite3.exe can be executed. SQLite can be download from https://sqlite.org/index.html website under https://sqlite.org/download.html, for instance https://sqlite.org/2022/sqlite-tools-win32-x86-3390000.zip or further versions.

9.1 simple_documentation_tree_sqlite.lua

This script opens a graphical user interface acting as a front end of a SQLite database with the table treeTable with the fields Tree_ID and Tree.

9.2 simple_documentation_tree_sqlite_with_import_data.lua

This script opens a graphical user interface acting as a front end of a SQLite database with the table treeTable with the fields Tree_ID, Tree and Tree_result and combines the trees stored in the field Tree with the data stored in a table DataForTrees with the fields DataKey, DataValue and DataValue_compare. The aggregation of the data is done in the graphical user interface.

10 scintilla_datapart.lua

This script is a graphical user interface with which the data part of the code of a tree reflexive_fengari_tree_functional_checklists.html is taken into a scintilla editor textfield. The code before the data part and after it is taken into variables so that after changing the data part in the scintilla editor it can be saved with the changes.


