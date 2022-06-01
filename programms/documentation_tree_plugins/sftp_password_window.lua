
--5.1.11 start the file or repository of the node of tree
--change in the start of the window for sftp connection with password
function startnode:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "D" "' .. tree['title'] .. '"') 
	elseif tree['title']:match("sftp .*") then 
		io.output("C:\\Tree\\GUI_Dokumentation_Verzeichnis\\GUI_sftp.bat")
		io.write("@echo off & title Passworteingabe bei SFTP-Verbindung & color f0 & mode CON: COLS=80 LINES=8 & " .. tree['title'] .. " & exit")
		io.close()
		os.execute('start "Passworteingabe bei SFTP-Verbindung" C:\\Tree\\GUI_Dokumentation_Verzeichnis\\GUI_sftp.bat')
	end --if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
end --function startnode:action()
