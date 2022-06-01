




--Wertebaum auf der untersten Stufe mit Werten
WerteTree={branchname="Aktiva",
{branchname="Aktiva Waren",
{branchname="Fertigprodukte",7000000,},
{branchname="Halbfertigprodukte",1232345,},
},
{branchname="Aktiva flüssige Mittel",
{branchname="Guthaben bei Banken",100000,},
{branchname="Kasse",2345,},
},
}


--2.1 function to build recursively the tree
function readTreeRecursive(TreeTable,GoalTreeTable)
	if TreeTable.branchname=="Aktiva" then
		GoalTreeTable.branchname="RSF"
	elseif TreeTable.branchname=="Fertigprodukte" then
		GoalTreeTable.branchname=TreeTable.branchname .. " 40%"
	else
		GoalTreeTable.branchname=TreeTable.branchname .. " 30%"
	end --if TreeTable.branchname=="Aktiva" then
	for k,v in ipairs(TreeTable) do
		if type(v)=="table" then
			GoalTreeTable[k]={}
			readTreeRecursive(v,GoalTreeTable[k])
		else
			if GoalTreeTable.branchname:match("^Fertigprodukte %d") then
				GoalTreeTable[#GoalTreeTable+1]=v *0.4
			else
				GoalTreeTable[#GoalTreeTable+1]=v *0.3
			end --if GoalTreeTable.branchname=="Fertigprodukte" then
		end --if type(v)=="table" then
	end --for k, v in ipairs(TreeTable) do
end --readTreeRecursive(TreeTable)

--2.2 apply the recursive function and build html file
RSFTreeTable={}
readTreeRecursive(WerteTree,RSFTreeTable)



--Aggregation
Tiefe=0
print(Tiefe)
TiefeRecursion(WerteTree) AnwendungTiefeRecursion(WerteTree) WerteTreeAnsicht={} AnsichtRecursion(WerteTree,WerteTreeAnsicht) RemoveRecursion(WerteTreeAnsicht) 
--Für den NSFR die Aktivseite RSF berechnen
TiefeRecursion(RSFTreeTable) AnwendungTiefeRecursion(RSFTreeTable) RSFWerteTreeAnsicht={} AnsichtRecursion(RSFTreeTable,RSFWerteTreeAnsicht) RemoveRecursion(RSFWerteTreeAnsicht) 


WerteTreeAnteile={} AnteilRecursion(WerteTree,WerteTree,WerteTreeAnteile) RemoveRecursion(WerteTreeAnteile)
WerteTreeAnteile.branchname="Aktivseitenübersicht mit Anteilen"



--Fertiger Wertebaum
tree_statistics={branchname="Aktivseite" ,
--WerteTree,
WerteTreeAnsicht,
--
RSFWerteTreeAnsicht,
WerteTreeAnteile,
}





