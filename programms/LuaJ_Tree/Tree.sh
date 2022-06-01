#!/bin/bash
echo chmod u+x Tree.sh
cd /home/pi/Tree/LuaJ_Tree
# ls 
# zeigt, dass das Verzeichnis gewechselt wurde, aber nicht permanent, was sehr gut ist.
#java -classpath ".:/home/pi/Tree/LuaJ_Tree/luaj-jse-3.0.1.jar" Tree
#java -classpath Tree.jar lua
java -classpath Tree.jar Tree
