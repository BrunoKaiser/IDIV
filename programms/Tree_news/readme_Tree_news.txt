This repository contains scripts for treating news as a tree and categorizing them in a manual tree

1. Tree_news_categorisation.lua

This script is a graphical user interface to read news, as an example WELT and DOMRADIO news, and beeing able to categorize them in a manual tree.

This script needs PDF files in the directory C:\Tree\Tree_News\PDF_news_inputs, text files output in C:\Tree\Tree_news\Text_news_outputs and lua files output in C:\Tree\Tree_news\Lua_news_outputs.

The directories can be changed as needed.

2. documentation_tree_news.lua

This script contains the lua table for the manual tree and the lua table for the texts corresponding to the titles in the manual tree. It is used in the GUI Tree_news_categorisation.lua.

3. html_Tree_news.lua

This script converts a text file with titles into a tree for news of the days and omits the known news that are known from the convertion done before.

© 2022 GitHub, Inc.
