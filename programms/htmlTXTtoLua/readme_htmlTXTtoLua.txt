This repository is for scripts which convert html text files in tree as Lua tables

1. html_text_file_to_lua_tree.lua

This script use curl to download an example site. This is stored as a html text file. Afterwards this file is read and converted in a Lua tree table.

2. html_text_file_to_lua_tree_compare_with_previous.lua

This script use curl to download an example site. This is stored as a html text file.

The previous tree is stored in a previous file.

Afterwards this file is read and converted in a Lua tree table.

At last only the new nodes compared with the previous tree are shown.

3. htmlListTreeTXTtoLua.lua

This auxiliary script converts a html tree as a list with <ul><li> tags into a Lua tree.
