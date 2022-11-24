--1. general comments to use IUP-Lua on Raspberry Pi
print("Lua-Start mit IUP-Lua Geany Strg+Hoch+F: In Dateien suchen")
print('sudo date --set="' .. string.upper(os.date("%d %b %Y")) .. ' ' .. os.date("%H:%M") .. ':00"')
print("export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/mylibs/iup/lib/Linux510")
print("cd /home/pi/mylibs/lua5.1/bin")
print("./lua51 /home/pi/IUP/simple_documentation_tree_with_file_dialog_Linux.lua")

--2. start of pcmanfm as file manager
os.execute('pcmanfm /home/pi &')

--3. securisation on repository: /home/pi/IUP/Archiv
os.execute("cp /home/pi/IUP/reflexive_documentation_tree_Linux.lua /home/pi/IUP/Archiv/reflexive_documentation_tree_Linux.lua")
os.execute("cp /home/pi/IUP/reflexive_documentation_tree_Linux.lua /home/pi/IUP/Archiv/reflexive_documentation_tree_Linux_" .. os.date("%Y%m%d") .. ".lua")

--4. open Tree
os.execute("cd /home/pi/mylibs/lua5.1/bin && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/mylibs/iup/lib/Linux510 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/mylibs/iup/lib/Linux510/Lua51 && ./lua51 /home/pi/IUP/reflexive_documentation_tree_Linux.lua &")

--5. open IUP-Lua scripter
os.execute("cd /home/pi/mylibs/iup/bin/Linux510_arm/Lua54 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/mylibs/iup/lib/Linux510 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/mylibs/iup/lib/Linux510_arm/Lua54 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/mylibs/cd/lib/Linux510_arm/Lua54 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/mylibs/cd/lib/Linux510_arm && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/mylibs/im/lib/Linux510_arm/Lua54 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/pi/mylibs/im/lib/Linux510_arm && ./iupluascripter54 &")

