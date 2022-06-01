This repository contains scripts and used files for documentation trees written in Lua with Luajava, i.e. the use of Java objects with the LuaJ interface in a Lua script

1.1 Tree_Luajava_Windows.lua

This script builds a tree with the input file Tree_Luajava_output_Tree.lua, which is also the output file for saving of a changed tree. Therefore it is called output_Tree. This script is only for Windows.

1.2 Tree_Luajava_Linux.lua

This script builds a tree with the input file Tree_Luajava_output_Tree.lua, which is also the output file for saving of a changed tree. Therefore it is called output_Tree. This script is for Linux, Unix.

1.3 Tree_Luajava_Linux_Mac.lua

This script builds a tree with the input file Tree_Luajava_output_Tree.lua, which is also the output file for saving of a changed tree. Therefore it is called output_Tree. This script is for Linux, Unix.

2. Tree_Luajava_output_Tree.lua

Input and output file for Tree_Luajava_Windows.lua and Tree_Luajava_Linux.lua.

3. Tree_Luajava_output.txt

This is the output file for the paths of the tree of Tree_Luajava_Windows.lua and Tree_Luajava_Linux.lua. It is written at the load of the tree and after changes of it.

4.1 Tree_Luajava_start.bat

This batch file is the launcher for the Lua script Tree_Luajava_Windows.lua.

5.1 Tree_Luajava_start.sh

This shell file is the launcher for the Lua script Tree_Luajava_Linux.lua.

5.2 Tree_Luajava_start_Mac.sh

This shell file is the launcher for the Lua script Tree_Luajava_Linux_Mac.lua.

6. Tree_Luajava_Linux_RaspberryPi.lua

This script is especially written for a Raspberry Pi. The launcher Tree_Luajava_start.sh can be adapted with the file name Tree_Luajava_Linux_RaspberryPi.lua.

7. Tree_Luajava_Linux_directory.lua

This script is used to open a graphical user interface with two directories and the comparison of both.

8. Tree_Luajava_start_directory.sh

This shell file is the launcher for the Lua script Tree_Luajava_Linux_directory.lua.

9. Tree_Luajava_LuatoLua.lua

This Lua script writes the Lua tree contained in this script as a file with a Lua tree in Linux.
