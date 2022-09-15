This repository contains Lua scripts to build a Lua table from a text file with tabulators

The tabulators must be regular, i.e. the number of tabulators in a line must be equal or one more than in the line before.

All the scripts have at the end a return command. It may be necessary to omit it.

As an example the scripts them selfs are treated by the scripts. The result is a description of the code in a tree.

1. TXTtoLua_Linux.lua

Script for Linux system.

2. TXTtoLua_Windows.lua

Script forWindows system.

3. text_to_lua_tree.lua

This script converts a text file with titles and text into a tree in a Lua table.

3.1 example.txt

This text file is an example for the input text file of the script text_to_lua_tree.lua.

4.1 bracketstoLua.lua

This script converts a text with brackets, especially for SQL statements, in a Lua tree.

4.2 file brackets_and_semicolontoLua.lua

This script converts a text with brackets and semicolons, especially for excel formulas, in a Lua tree.

5. TXTTabulatorToLuaWithLeafs.lua

This script converts a tabulator tree in a text file in a Lua tree with leafs.

