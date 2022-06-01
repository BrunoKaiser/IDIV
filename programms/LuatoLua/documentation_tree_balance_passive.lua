




--Wertebaum auf der untersten Stufe mit Werten
WerteTree={branchname="Bilanzausschnitt Passiva ohne Eigenkapital", 
{branchname="Passiva Rückstellungen und Rücklagen",
{branchname="Rückstellungen",2000,},
{branchname="Rücklagen",32345,},
},
{branchname="Passiva Kredite",
{branchname="Kredite an Banken",600000,},
{branchname="Kredite an private Gläubiger",1112345,},
},
}



--2.1 function to build recursively the tree
function readTreeRecursive(TreeTable,GoalTreeTable)
	if TreeTable.branchname=="Bilanzausschnitt Passiva ohne Eigenkapital" then
		GoalTreeTable.branchname="ASF"
	elseif TreeTable.branchname=="Kredite an Banken" then
		GoalTreeTable.branchname=TreeTable.branchname .. " 30%"
	else
		GoalTreeTable.branchname=TreeTable.branchname .. " 80%"
	end --if TreeTable.branchname=="Aktiva" then
	for k,v in ipairs(TreeTable) do
		if type(v)=="table" then
			GoalTreeTable[k]={}
			readTreeRecursive(v,GoalTreeTable[k])
		else
			if GoalTreeTable.branchname:match("^Kredite an Banken %d") then
				GoalTreeTable[#GoalTreeTable+1]=v *0.3
			else
				GoalTreeTable[#GoalTreeTable+1]=v *0.8
			end --if GoalTreeTable.branchname=="Fertigprodukte" then
		end --if type(v)=="table" then
	end --for k, v in ipairs(TreeTable) do
end --readTreeRecursive(TreeTable)

--2.2 apply the recursive function and build html file
ASFTreeTable={}
readTreeRecursive(WerteTree,ASFTreeTable)



--Aggregation
Tiefe=0
print(Tiefe)
TiefeRecursion(WerteTree) AnwendungTiefeRecursion(WerteTree) WerteTreeAnsicht={} AnsichtRecursion(WerteTree,WerteTreeAnsicht) RemoveRecursion(WerteTreeAnsicht)
--Für den NSFR die Passivseite ASF berechnen
TiefeRecursion(ASFTreeTable) AnwendungTiefeRecursion(ASFTreeTable) ASFWerteTreeAnsicht={} AnsichtRecursion(ASFTreeTable,ASFWerteTreeAnsicht) RemoveRecursion(ASFWerteTreeAnsicht) 

WerteTreeAnteile={} AnteilRecursion(WerteTree,WerteTree,WerteTreeAnteile) RemoveRecursion(WerteTreeAnteile)
WerteTreeAnteile.branchname="Passivseitenübersicht mit Anteilen"

--Fertiger Wertebaum
tree_script={branchname="Passivseite ohne Eigenkapital" ,
--WerteTree,
WerteTreeAnsicht,
--
ASFWerteTreeAnsicht,
WerteTreeAnteile,
}






