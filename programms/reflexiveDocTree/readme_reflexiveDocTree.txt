This repository has a script in IUP-Lua with with a reflexive Documentation Tree

A reflexive Documentation Tree means that the script itself is able to save itself with new tree content changed by the user.

1.1 reflexive_documentation_tree.lua

This script shows only a simple tree.

1.2 reflexive_documentation_tree_Linux.lua

This script shows only a simple tree in Linux, tested on Ubuntu, Debian and Raspberry Pi.

1.2.1 start_IDIV_Tree_on_RaspberryPi.lua

This script can be used to start a standard IDIV-window setting with pcmanfm, IUP-Lua scripter and Tree.

2. reflexive_html_with_tree.lua

This script shows html-webbrowser pages stored in a lua table within can be formatted a tree.

3. reflexive_htmlbook_with_tree.lua

This script shows two html-webbrowser pages on each screen stored in a lua table within can be formatted a tree. It has the look of a book.

The first page is an automatically generated tree as a table of contents of the book.

4. reflexive_documentation_tree_with_webbrowser.lua

This script has a tree and a lua table with pages with html format. It can display pages corresponding to the nodes of the tree.

5. reflexive_documentation_tree_with_directory.lua

This script contains a tree on the left side. The tree can have nodes with Windows-Directories. These are displayed in the tree on the right side with the command dir.

6. reflexive_documentation_tree_with_images.lua

This script contains a tree with images with extensions .png that are shown in the canvas on the right side of the graphical user interface.

6.1 reflexive_documentation_tree_with_images.png

This image file is needed to load the first image of reflexive_documentation_tree_with_images.lua.

7.1.1 reflexive_html_with_tree_do_comments.lua

This script contains the business concept for the Lua scripts for interactive dynamic tables of contents and auxiliary programms.

7.1.2 reflexive_html_with_tree_do_comments.html

This html file contains the business concept for the Lua scripts for interactive dynamic tables of contents and auxiliary programms.


7. reflexive_documentation_tree_search.lua

This script contains a graphical user interface with a text field for copy and paste out of internet sites like duckduckgo.com. The found webpage adresses are sorted in a tree driven by a text in the tree as child node of Suche.

The resulting sorts can be manually reorganised to be efficient in finding webpages.

8 reflexive_documentation_tree_with_html.lua

This script converts in a tree driven manner a tree into a html site. It is an example for tree driven format. Both, the tree and the html are shown in a graphical user interface.

9.1 reflexive_documentation_tree_of_Lua.lua

This script is a graphical user interface for the description of the Lua syntax with examples. The source of the texts is from official Lua documentation, reference manual and the book programming in Lua.

9.2 reflexive_documentation_tree_of_Lua.html

This file is an html site for the description of the Lua syntax with examples build from the script reflexive_documentation_tree_of_Lua.lua. The source of the texts is from official Lua documentation, reference manual and the book programming in Lua.

10.1 reflexive_documentation_tree_write_html.lua

This script is a graphical user interface for Windows with a textfield containing the raw text of an article which can contain format html-tags. The graphical user interface converts this text in a html site with titles defined by the numbering of the titles and shows the current table of contents as a tree.

10.2 reflexive_documentation_tree_write_html_Linux.lua

This script is a graphical user interface for Linux, tested on a Raspberry Pi, with a textfield containing the raw text of an article which can contain format html-tags. The graphical user interface converts this text in a html site with titles defined by the numbering of the titles and shows the current table of contents as a tree.

11 reflexive_documentation_tree_with_dataform.lua

This script contains a tree and a data form. In this data form data corresponding to the tree are stored and shown.

12.1 reflexive_documentation_tree_with_statistics_Linux.lua

This script shows only a simple tree in Linux, tested on Raspberry Pi. With this tree it is possible to operate downloads from the statistic page of the Bundesbank as an example for download driven by tree.

Start this script for instance with: cd /home/pi/mylibs/lua5.1/bin && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/mylibs/iup/lib/Linux510 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/mylibs/iup/lib/Linux510/Lua51 && ./lua51 /home/pi/IUP/reflexive_documentation_tree_with_statistics_Linux.lua &

12.2 Statistik_EUR_Fremdwaehrung_verarbeiten.lua

This script shows the time series in the tree as a diagramm. This script is used in reflexive_documentation_tree_with_statistics_Linux.lua.


