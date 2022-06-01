--3.3.1 function for writing tree in a text file (function for printing tree)
function printtree()
	--open a filedialog
	filedlg2=iup.filedlg{dialogtype="SAVE",title="Ziel ausw‰hlen",filter="*.txt",filterinfo="Text Files", directory="c:\\temp"}
	filedlg2:popup(iup.ANYWHERE,iup.ANYWHERE)
	if filedlg2.status=="1" or filedlg2.status=="0" then
		local outputfile=io.output(filedlg2.value) --setting the outputfile
		for i=0,tree.totalchildcount0 do
			local helper=tree['title' .. i]:gsub("\n","\\n")
			for j=1,tree['depth' .. i] do
				helper='\t' ..  helper
			end --for j=1,tree['depth' .. i] do
			outputfile:write(helper, '\n')
		end --for i=0,tree.totalchildcount0 do
		outputfile:close() --close the outputfile
	else --no outputfile was choosen
		iup.Message("Schlieﬂen","Keine Datei ausgew‰hlt")
		iup.NextField(maindlg)
	end --if filedlg2.status=="1" or filedlg2.status=="0" then
	
	filedlg4=iup.filedlg{dialogtype="SAVE",title="Ziel ausw‰hlen",filter="*.txt",filterinfo="Text Files", directory=path}
	filedlg4:popup(iup.ANYWHERE,iup.ANYWHERE)
	if filedlg4.status=="1" or filedlg4.status=="0" then
		local outputfile=io.output(filedlg4.value) --setting the outputfile
			outputfile:write(textfield1.value, '\n')
		outputfile:close() --close the outputfile
	else --no outputfile was choosen
		iup.Message("Schlieﬂen","Keine Datei ausgew‰hlt")
		iup.NextField(maindlg)
	end --if filedlg4.status=="1" or filedlg4.status=="0" then

end --function printtree()
