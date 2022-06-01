This repository contains programms with LuaJ

1.1 Lua.bat

This starts Lua with Tree.jar in Windows.

1.2 Lua.sh

This starts Lua with Tree.jar in Linux.

2.1 Tree.bat

This starts the graphical user interface with the tree with Tree.jar in Windows.

1.2 Tree.sh

This starts the graphical user interface with the tree with Tree.jar in Linux.

3.1 Tree.jar

Download and start the LuaJ version as a jar archive. The jar archive has to be downloaded and to be moved in a directory of the choice of the user.

The jar archive is started with a start file as a Tree or as a Lua console. Examples of bash files for Linux and Mac (.sh files) can be downloaded. The windows versions are batch files (.bat).

At the first start the needed Lua scripts are written in the start directory. The trees stay empty. At the second start the trees are filled and the use of them can begin.

3.2 Tree.java

This is the source code for Tree.jar. It needs luaj-jse-3.0.1.jar taken as a download from the site:
https://mvnrepository.com/artifact/org.luaj/luaj-jse/3.0.1

The source must be compiled with the LuaJ framework:
javac.exe -classpath luaj-jse-3.0.1.jar c:\Tree\LuaJ_Tree\Tree.java

The Jar archive luaj-jse-3.0.1.jar needs to be copied as Tree.jar. After this
jar.exe uvfM Tree.jar Tree.class Tree*.class MyTreeCellRenderer*.class GlobalClass.class

Use instead of javac.exe and jar.exe the version of Java, for instance
"C:\Program Files\Java\jdk1.8.0_25\bin\javac.exe" and "C:\Program Files\Java\jdk1.8.0_25\bin\jar.exe"
or Open JDK Java from https://jdk.java.net/18/
C:\jdk-18.0.1\bin\javac.exe and C:\jdk-18.0.1\bin\jar.exe

