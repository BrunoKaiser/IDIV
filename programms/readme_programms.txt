This repository contains programms to execute IUP Lua scripts

1. IUP_Lua_for_Raspberry_Pi4_executable_3.30.zip

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

Furthermore to execute Lua with require("iuplua") in an interactive mode or with Lua scripts the libraries must be in the 
path LD_LIBRARY_PATH assumed mylibs is extracted on /home/pi/Pi4:

lua51_start.sh

#!/bin/bash
echo chmod u+x lua51
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/Pi4/mylibs/iup/lib/Linux510_arm/Lua51
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/Pi4/mylibs/iup/lib/Linux510_arm

cd /home/pi/Pi4/mylibs/lua5.1/bin
# ls 
# zeigt, dass das Verzeichnis gewechselt wurde, aber nicht permanent, was sehr gut ist.
./lua51

2. IUP Lua in Ubuntu and Debian in Windows

After installing Ubuntu, for instance in C:\Program Files\WindowsApps\CanonicalGroupLimited.UbuntuonWindows_2004.2022.1.0_x64__79rhkp1fndgsc\ubuntu.exe and 
Debian in C:\Program Files\WindowsApps\TheDebianProject.DebianGNULinux_1.12.2.0_x64__76v4gfsz19hv4\debian.exe, they have to be upgraded with:
sudo apt update
apt list --upgradable
sudo apt upgrade

After that IUP Lua can be downloaded for Linux54_64 	 Ubuntu 20.04 (x64) / Kernel 5.4 / gcc 9.3 (GTK 3.24) 
https://sourceforge.net/projects/iup/files/3.30/Linux%20Libraries/Lua54/ 

The compressed file C:\Users\..\Downloads\iup-3.30-Lua54_Linux54_64_bin.tar.gz is extracted in a directory for instance 
C:\IUP_Linux, that is mounted into linux directory cd /mnt/c/IUP_Linux

If programms are missing they must be installed, for instance 
https://zoomadmin.com/HowToInstall/UbuntuPackage/libgtk-3-0 with sudo apt install libgtk-3-0

It is necessary to make libraries available with 
export LD_LIBRARY_PATH=/mnt/c/IUP_Linux:$LD_LIBRARY_PATH 

cd /mnt/c/IUP_Linux
and after this
./lua54 
should work or another Lua version, but require("iuplua") is not possible (Unable to init server: Could not connect: Connection refused) 
as described below:

When using a IUP Lua script with graphical user interface components with require("iuplua") in a Linux system on Windows 
a Xserver is needed to show the graphical user interfaces. Otherwise there is an error message as described in 
https://stackoverflow.com/questions/60284542/wsl-gedit-unable-to-init-server-could-not-connect-connection-refused
You need an X server to run graphical applications like gedit. I use VcXsrv or Xming on my Windows desktops, 
both are very small and easy to install, but there exist other servers like Cygwin/X.

The use of https://sourceforge.net/projects/xming/ is recommended because also webbrowsers are displaied properly.

To display graphical user interfaces download https://sourceforge.net/projects/xming/files/latest/download 
Xming-6-9-0-31-setup.exe for instance and launch the Xserver with C:\Program Files (x86)\Xming\XLaunch.exe

After this execute export DISPLAY=0:0 in the Linux terminal.

./iuplua54
./iupluascripter54

and ./lua54 with require("iuplua") can now be used.


As a summary:
cd /mnt/c/IUP_Linux
export LD_LIBRARY_PATH=/mnt/c/IUP_Linux:$LD_LIBRARY_PATH 
C:\Program Files (x86)\Xming\XLaunch.exe
export DISPLAY=0:0
./lua54 
./iuplua54
./iupluascripter54
