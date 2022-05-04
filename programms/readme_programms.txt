This repository contains programms to execute IUP Lua scripts

1. IUP_Lua_for_Raspberry_Pi4_executable_mylibs.zip

The source files for IUP Lua are on https://sourceforge.net/projects/iup/files/. 

The executables on https://sourceforge.net/projects/iup/files/3.30/Tools%20Executables/ cannot be used for a Raspberry Pi4. 

Therefore IUP Lua must be compiled by make from the sources. To avoid to compile it several times IUP Lua 3.30 is here in a zip file for Raspberry Pi4.

The executables must be executed after having made them executable by the command chmod u+x.

Therefore there are two examples for doing it assumed mylibs is extracted on /home/pi/Pi4:

iupluascripter51_start.sh

#!/bin/bash
echo chmod u+x iupluascripter51
cd /home/pi/Pi4/mylibs/iup/bin/Linux510_arm/Lua51
# ls 
# zeigt, dass das Verzeichnis gewechselt wurde, aber nicht permanent, was sehr gut ist.
./iupluascripter51

Furthermore to execute Lua with require("iuplua") in an interactive mode or with Lua scripts the libraries must be in the path LD_LIBRARY_PATH assumed mylibs is extracted on /home/pi/Pi4:

lua51_start.sh

#!/bin/bash
echo chmod u+x lua51
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/Pi4/mylibs/iup/lib/Linux510_arm/Lua51
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/Pi4/mylibs/iup/lib/Linux510_arm

cd /home/pi/Pi4/mylibs/lua5.1/bin
# ls 
# zeigt, dass das Verzeichnis gewechselt wurde, aber nicht permanent, was sehr gut ist.
./lua51

