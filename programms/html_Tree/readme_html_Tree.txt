This repository contains mobil version of documentation tree coded directly in html

1. Tree_calculator_with_interests.html

This html-file contains a tree with calculations in javascript. The first one is general, the second one gives the information of leap year or not and the third one gives results for various interests calculations. 

2. with_frames_3

This repository contains a html for Tree with three frames. Parts are taken from Webbook of Tecgraf https://www.tecgraf.puc-rio.br/webbook/.

3. with_frames_2

This repository contains a html for Tree with two frames. Parts are taken from Webbook of Tecgraf https://www.tecgraf.puc-rio.br/webbook/.

4. html_fengari

This repository contains a html for Tree with Lua realized by Fengari https://fengari.io/ https://github.com/fengari-lua/fengari.io. The file fengari-web.js is needed to be imported as a modul to execute Lua in the Html file.

5. Tree_html_frame_build.lua

This script builds a tree within 2 frames as in chapter 3. Therefore it is not necessary to build the html manually.

6.1 html_build_text.lua

This script converts in a tree driven manner a tree into a html site. It is an example for tree driven format.

6.2 Tree_Baum_Text.lua

Example tree for the script html_build_text.lua.

6.3 html_build.lua

This skript converts a Lua tree in a html page with tree. This is especially helpful on mobile devices but here for Windows.

Start of the Lua script with the right informations for path of input and output data.

6.4 html_build_Linux.lua

This skript converts a Lua tree in a html page with tree. This is especially helpful on mobile devices.

Start of the Lua script with the right informations for path of input and output data.

7.1 html_build_node_content.lua

This script produces a tree in html with the nodes having the content of their children nodes in parenthesis.

7.2 Tree_Baum_node_content.lua

Example tree for the script html_build_node_content.lua.


8. html_Tree_relative.lua

This skript converts a Lua tree in a html page with tree with relative paths. This is especially helpful on mobile devices as the iPhone where such apps as Touch Lua cannot save directly on the target path. The result is stored in a file with extension .lua which can be transfered by copy and paste in a html file on the target path.

9. Tree_DB_localStorage.html

This Html file contains a localStorage data base in which trees are stored to be shown in the browser. It is possible to search for trees containing a search text or having a root beginning with the search text.

10. fengari scripts

These Html files contain a tree that has functionalities from javascript. It is dynamically build from a Lua script execute via fengari. Fengari is a modul that can be downloaded on the internet sites https://github.com/fengari-lua/fengari.io. The file fengari-web.js is needed to be imported as a modul to execute Lua in the Html file.


10.1 simple_fengari_tree.html

This file contains a simple tree with mark functionalities with nodes as Hyperlinks.

10.2 simple_fengari_DB_tree_link.html

This file contains a simple NoSQL data base as a Lua table of trees with mark functionalities with nodes as Hyperlinks.

10.3 simple_fengari_DB_tree_text.html

This file contains a simple NoSQL data base as a Lua table of trees with mark functionalities with nodes as texts. The texts can contain hyperlink or other html tags. Therefore this file has flexibility.

10.4.1 reflexive_fengari_tree_checklists.html

This file contains in addition to simple_fengari_DB_tree_text.html the possibility to tick nodes that are done. This is done for each tree in the file. So, these are  hierarchical todo lists or checklists within the nodes can be added by a tick. This tick is stored in a localStorage and is valid for all nodes having the same definition, for leafs all leafs are ticked in each tree, but all branches are treated indivdually. The ticks can all be cleared or deletede for individual nodes.

Caveat: this file does not function in every browser. Only in Firefox it is functioning.

10.4.2 reflexive_fengari_tree_functional_checklists.html

This file contains the same programm as reflexive_fengari_tree_checklists.html but with functional definitions of buttons as in pure Javascript. Therefore it is possible to execute it also in other browser than Firefox.

10.4.3 reflexive_fengari_tree_functional_checklists_persistent.html

Due to the fact that localStorage can be deleted by the user (delete the cache or the histors in the browser) this Html side contains different checklists as trees where there can be ticked nodes of these trees.

By using a simple_datapart_tree.lua the Html content of the trees can be modified.

By using a scintilla_datapart.lua with 	if line:match("^DBTable=") then changed to 	if line:match("^TickTable=") then and 	if line:match("} %-%-DBTable=") then
changed to 	if line:match("%-%-TickTable=") then
the ticks can be made persistent. The restriction is that nodes does not have german Umlaute.

10.4.4 reflexive_fengari_tree_functional_checklists_persistent_prio.html

In this checklists the priority of a node can also be set in addition to the other functionalities of reflexive_fengari_tree_functional_checklists_persistent.html.

11. simple_pure_Javascript_DB_tree.html

This html file contains a programm with little differences in the functionality compared with simple_fengari_DB_tree_text.html, but written in pure Javascript.

12. simple_fengari_tree_converter.html

This html-file converts trees written with tabulators in trees as a Lua table. The input and output is in text areas.

13. tree_html_details_summary.lua

This script produces an output html with details and summary tags to build a tree.
