require( "iuplua" )
require( "iupluacontrols" )
--require( "iupluamatrixex" )

lua_tree_output={ branchname="Clients et leurs comptes",
 
"sonstige", 
 
{ branchname="xy xyxy", 
 "DE1321341230123123",
},
{ branchname="xy",  "DE1234567890123123", },

{ branchname="Neuerer Kunde",  "DE1321341230923123", },

{ branchname="xy xyy", 
"Limitausgleich: 1000000", 

{ branchname="comptes",
"Limit: -1000000", 
"DE1321341230120145", 
"DE1321341230120147", 

},
},


 
{ branchname="xy xy", 
"DE1321341230123124",
{ branchname="Filiale xyz", 
"Limit: -12000",
"DE1321341230123125",
"DE1321341230123126",
"DE1321341230123136",
},
},




}

testCompte=[[
DE1234567890123123;12324.60;12.03.2004;0.001
DE1321341230923123;12324.60;12.03.2004;0.001
DE1321341230123123;12324;12.03.2004;0.0023
DE1321341230123124;1.5;23.03.2004;0.0021
DE1321341230123125;34541.43;12.04.2004;0.0022
DE1321341230123126;341.43;12.03.2014;0.0021
DE1321341230123136;1341.43;12.12.2014;0.0021
DE1321341230120145;14913.57;06.10.1971;0.0025
]]
outputfile1=io.open("C:\\Temp\\comptes_test.csv","w")
outputfile1:write(testCompte)
outputfile1:close()

ZeilenTable={}
Zeile=0
for line in io.lines("C:\\Temp\\comptes_test.csv") do
	Zeile=Zeile+1
	ZeilenTable[Zeile]={}
	for Feld in (line .. ";"):gmatch("([^;]*);") do
		ZeilenTable[Zeile][#ZeilenTable[Zeile]+1]=Feld
	end --for Feld in (line .. ";"):gmatch("([^;]*);") do
end --for line in io.lines("C:\\Temp\\comptes_test.csv") do


mat = iup.matrixex {numcol=#ZeilenTable[1], numlin=#ZeilenTable, width1=100, width2=45, 
  cellnames = "Excel", edithideonfocus = "NO", editfitvalue = "yes", resizematrix = "YES",
  numericquantity1 = "None", numericquantity2 = "None", --numericquantity3 = "None", --shows numbers with two digits after the point
  numericquantity5 = "None",
  MARKMULTIPLE="YES", MARKAREA="CONTINOUS", MARKMODE="CELL",}

--mat.resizematrix = "YES"
mat:setcell(0,0,"        ")
for i=1,mat.numlin do
	mat:setcell(i,0,tostring(i))
end --for i=1,45 do
titleTable={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
for j=1,mat.numcol do
	mat:setcell(0,j,titleTable[j])
end --for j=1,8 do


--function mat:Spalte1(a,b)
--	mat:setcell(a,1,b)
--end --function mat:Spalte1(a,b)
--mat:Spalte1(1,"5.6")

for i,v in ipairs(ZeilenTable) do
	for i1,v1 in ipairs(v) do
		mat:setcell(i,i1,v1)
	end --for i1,v1 in ipairs(v) do
end --for i,v in ipairs(ZeilenTable) do


cellTable={}
for i=1,mat.numlin do
	cellTable[mat:getcell(i,1)]=mat:getcell(i,2)
end --for i=1,mat.numlin do

--iup.MatrixSetFormula(mat, 3, "cos(pi*lin/4)")
--iup.MatrixSetFormula(mat, 3, "cell(\"x\", 1)") -- error
--iup.MatrixSetFormula(mat, 3, "cell(lin, 1) < 3")
--mat.redraw = "Yes"

--iup.MatrixSetFormula(mat, 3, "cell(lin, 1) + cell(lin, 2)")
--mat:SetFormula(, 3, "cell(lin, 1) + cell(lin, 2)")

--mat.cellnames = "Excel"
--mat.cellnames = "Matrix"
--mat.edithideonfocus = "NO"
--mat.editfitvalue = "yes"

--[[
mat:setcell(1,3,"=A1+3+3")
mat:setcell(2,2,"=1.3 + cell(2,3)")
--mat:setcell(3,2,"=1.3 + L2C3")
mat:setcell(3,2,"=1.3 + C2")
mat:setcell(2,3,"=sin(pi/4)")
--]]
actualtree=lua_tree_output
--build tree
tree=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree)
end, --function(self)
SIZE="800x200",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
showdragdrop="YES",
}



--6.9 button for deleting one node leaving all other nodes but changing the order and reload tree calculations
button_delete_in_tree=iup.flatbutton{title="Limite als Ebene herauslöschen und neu laden", size="205x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_delete_in_tree:flat_action()
	searchText=textbox1.value -- "limit"
	for i=tree.count-1,1,-1 do
		tree.value=i
		if tree["TITLE" .. i]:lower():match(searchText:lower()) then
			if tree.totalchildcount=="0" then
				tree.delnode = "SELECTED"
			else
				selectedNode=tree.value
				 --insert at same depth a temporary leaf
				tree['insertleaf' .. selectedNode]="temporary"
				for i=selectedNode,selectedNode+tree['childcount' .. selectedNode] do
					--search for temporary node number
					local temporaryNode=0
					for i1=selectedNode,tree.totalchildcount0 do
						temporaryNode=i1
						if tree['title' .. i1]=="temporary" then break end
					end --for i1=selectedNode,tree.totalchildcount0 do
					--last node on depth + 1 from selectedNode
					local lastNode=0
					for i1=selectedNode+tree['totalchildcount' .. selectedNode],selectedNode+1,-1 do
						lastNode=i1
						if tree['depth' .. i1]==tostring(tree['depth' .. selectedNode]+1) then break end
					end --for i1=selectedNode,tree.totalchildcount0 do
					tree['movenode' .. lastNode] = temporaryNode --lastNode in normal order
					--tree['movenode' .. selectedNode+1] = temporaryNode --selectedNode+1 in reversed order
				end --for i=selectedNode,tree['totalchildcount' .. selectedNode] do
				--delete selected node and temporary nodes
				tree.delnode = "SELECTED"
				tree.delnode = "SELECTED"
			end --if tree.totalchildcount==0 then
		end --if tree["TITLE" .. i]:match("limit") then
	end --for i=1,tree.count-1 do
	--neu laden
	for i=tree.count-1,0,-1 do
		tree["TITLE" .. i]=tree["TITLE" .. i]:gsub(" +Auslastung:.*",""):gsub(" +#:.*","")
		if tree["KIND" .. i]=="BRANCH" and tree["depth" .. i]>="0" and tree["TITLE" .. i]:match(":")==nil then
			if tree["depth" .. i]>"0" then tree["state" .. i]="COLLAPSED" end
			local totalSaldo=0
			local totalChildWithData=0
			local maxSaldo=-99999999999
			local minSaldo=99999999999
			for i1=i+1, i+tree["totalchildcount" .. i] do
				if tree["parent" .. i1]==tostring(i) then
				--if tree["title" .. i1]:match("#")==nil then --only for sum of Saldo, but not suitful for limit
					totalChildWithData=totalChildWithData+1
					--test with: print(tree["title" .. i],i,tree["title" .. i1],tree["parent" .. i1])
					local saldoNumber=tonumber(tree["TITLE" .. i1]:match(": +([^:]*)$"))
					--test with: print(saldoNumber)
					totalSaldo=totalSaldo+(saldoNumber or 0)
					maxSaldo=math.max(maxSaldo,(saldoNumber or 0))
					minSaldo=math.min(minSaldo,(saldoNumber or 0))
				end --if tree["title" .. i1]:match("#")==nil then
			end --for i1=i+1, i+tree["childcount" .. i] do
			--alternatively limit without consideration of negativ Saldo: totalSaldo=math.max(totalSaldo,0)
			tree["TITLE" .. i]=tree["TITLE" .. i] .. string.rep(" ",math.max(0,45-#tree["TITLE" .. i])) .. 
					" #: " .. string.rep(" ",math.max(0,3-#tostring(totalChildWithData))) .. totalChildWithData ..
					" Min: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",minSaldo))) .. string.format("%.2f",minSaldo) .. 
					" Max: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",maxSaldo))) .. string.format("%.2f",maxSaldo) .. 
					" D: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",totalSaldo/tree["childcount" .. i]))) .. string.format("%.2f",totalSaldo/tree["childcount" .. i]) .. 
					" S: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",totalSaldo))) .. string.format("%.2f",totalSaldo) .. 
					""
			tree["titlefont" .. i] = "Courier, 10"
		end --if tree["KIND" .. i]=="BRANCH" and tree["depth" .. i]>="1" then
	end --for i=tree.count-1,0,-1 do
end --function button_delete_in_tree:flat_action()


--6.3 button for loading tree
button_loading_lua_table=iup.flatbutton{title="Daten neu laden", size="115x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_loading_lua_table:flat_action()
	tree.delnode0 = "CHILDREN"
	tree.title=''
	iup.TreeAddNodes(tree,actualtree)
	--IBAN anreichern
	for i=0, tree.count-1 do
		if cellTable[tree["TITLE" .. i]] then
			usedTable[tree["TITLE" .. i]]=true
			tree["TITLE" .. i]=tree["TITLE" .. i] .. ": " .. string.rep(" ",math.max(0,12-#string.format("%.2f",cellTable[tree["TITLE" .. i]]))) .. string.format("%.2f",cellTable[tree["TITLE" .. i]])
			tree["titlefont" .. i] = "Courier, 8"
		end --if tree["TITLE" .. i]:match(searchtext_replace.value)~=nil then
	end --for i=0, tree.count-1 do

	--sonstige ausrechnen
	sonstigeSaldo=0
	for k,v in pairs(cellTable) do
		if usedTable[k]==nil then sonstigeSaldo=sonstigeSaldo+v end
	end --for i,v in ipairs(ZeilenTable) do
	for i=0, tree.count-1 do
		if tree["TITLE" .. i]=="sonstige" then
			tree["TITLE" .. i]=tree["TITLE" .. i] .. ": " .. string.rep(" ",math.max(0,12-#string.format("%.2f",sonstigeSaldo))) .. string.format("%.2f",sonstigeSaldo)
			tree["titlefont" .. i] = "Courier, 8"
		end --if tree["TITLE" .. i]:match(searchtext_replace.value)~=nil then
	end --for i=0, tree.count-1 do


	for i=tree.count-1,0,-1 do
		if tree["KIND" .. i]=="BRANCH" and tree["depth" .. i]>="0" and tree["TITLE" .. i]:match(":")==nil then
			if tree["depth" .. i]>"0" then tree["state" .. i]="COLLAPSED" end
			local totalSaldo=0
			local totalChildWithData=0
			local maxSaldo=-99999999999
			local minSaldo=99999999999
			for i1=i+1, i+tree["totalchildcount" .. i] do
				if tree["parent" .. i1]==tostring(i) then
				--if tree["title" .. i1]:match("#")==nil then --only for sum of Saldo, but not suitful for limit
					totalChildWithData=totalChildWithData+1
					--test with: print(tree["title" .. i],i,tree["title" .. i1],tree["parent" .. i1])
					local saldoNumber=tonumber(tree["TITLE" .. i1]:match(": +([^:]*)$"))
					--test with: print(saldoNumber)
					totalSaldo=totalSaldo+(saldoNumber or 0)
					maxSaldo=math.max(maxSaldo,(saldoNumber or 0))
					minSaldo=math.min(minSaldo,(saldoNumber or 0))
				end --if tree["title" .. i1]:match("#")==nil then
			end --for i1=i+1, i+tree["childcount" .. i] do
			--alternatively limit without consideration of negativ Saldo: totalSaldo=math.max(totalSaldo,0)
			tree["TITLE" .. i]=tree["TITLE" .. i] .. string.rep(" ",math.max(0,45-#tree["TITLE" .. i])) .. 
					" #: " .. string.rep(" ",math.max(0,3-#tostring(totalChildWithData))) .. totalChildWithData ..
					" Min: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",minSaldo))) .. string.format("%.2f",minSaldo) .. 
					" Max: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",maxSaldo))) .. string.format("%.2f",maxSaldo) .. 
					" D: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",totalSaldo/tree["childcount" .. i]))) .. string.format("%.2f",totalSaldo/tree["childcount" .. i]) .. 
					" S: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",totalSaldo))) .. string.format("%.2f",totalSaldo) .. 
					""
			tree["titlefont" .. i] = "Courier, 10"
		end --if tree["KIND" .. i]=="BRANCH" and tree["depth" .. i]>="1" then
	end --for i=tree.count-1,0,-1 do

end --function button_loading_lua_table:flat_action()

textbox1=iup.text{value="limit",size="30x20"}

dlg = iup.dialog{size="1200x300",
iup.vbox{
	iup.hbox{
	button_delete_in_tree,
	textbox1,
	button_loading_lua_table,
	},
	iup.hbox{mat, tree; margin="10x10"}
},
}

--iup.MatrixSetDynamic(mat)
mat:SetDynamic()

dlg:showxy(iup.LEFT, iup.CENTER)

--gefundene IBAN sammeln
usedTable={}

--IBAN anreichern
for i=0, tree.count-1 do
	if cellTable[tree["TITLE" .. i]] then
		usedTable[tree["TITLE" .. i]]=true
		tree["TITLE" .. i]=tree["TITLE" .. i] .. ": " .. string.rep(" ",math.max(0,12-#string.format("%.2f",cellTable[tree["TITLE" .. i]]))) .. string.format("%.2f",cellTable[tree["TITLE" .. i]])
		tree["titlefont" .. i] = "Courier, 8"
	end --if tree["TITLE" .. i]:match(searchtext_replace.value)~=nil then
end --for i=0, tree.count-1 do

--sonstige ausrechnen
sonstigeSaldo=0
for k,v in pairs(cellTable) do
	if usedTable[k]==nil then sonstigeSaldo=sonstigeSaldo+v end
end --for i,v in ipairs(ZeilenTable) do
for i=0, tree.count-1 do
	if tree["TITLE" .. i]=="sonstige" then
		tree["TITLE" .. i]=tree["TITLE" .. i] .. ": " .. string.rep(" ",math.max(0,12-#string.format("%.2f",sonstigeSaldo))) .. string.format("%.2f",sonstigeSaldo)
		tree["titlefont" .. i] = "Courier, 8"
	end --if tree["TITLE" .. i]:match(searchtext_replace.value)~=nil then
end --for i=0, tree.count-1 do


for i=tree.count-1,0,-1 do
	if tree["KIND" .. i]=="BRANCH" and tree["depth" .. i]>="0" and tree["TITLE" .. i]:match(":")==nil then
		if tree["depth" .. i]>"0" then tree["state" .. i]="COLLAPSED" end
		local totalSaldo=0
		local totalChildWithData=0
		local maxSaldo=-99999999999
		local minSaldo=99999999999
		for i1=i+1, i+tree["totalchildcount" .. i] do
			if tree["parent" .. i1]==tostring(i) then
			--if tree["title" .. i1]:match("#")==nil then --only for sum of Saldo, but not suitful for limit
				totalChildWithData=totalChildWithData+1
				--test with: print(tree["title" .. i],i,tree["title" .. i1],tree["parent" .. i1])
				local saldoNumber=tonumber(tree["TITLE" .. i1]:match(": +([^:]*)$"))
				--test with: print(saldoNumber)
				totalSaldo=totalSaldo+(saldoNumber or 0)
				maxSaldo=math.max(maxSaldo,(saldoNumber or 0))
				minSaldo=math.min(minSaldo,(saldoNumber or 0))
			end --if tree["title" .. i1]:match("#")==nil then
		end --for i1=i+1, i+tree["childcount" .. i] do
		--alternatively limit without consideration of negativ Saldo: totalSaldo=math.max(totalSaldo,0)
		tree["TITLE" .. i]=tree["TITLE" .. i] .. string.rep(" ",math.max(0,45-#tree["TITLE" .. i])) .. 
		--		" #: " .. string.rep(" ",math.max(0,3-#tostring(totalChildWithData))) .. totalChildWithData ..
		--		" Min: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",minSaldo))) .. string.format("%.2f",minSaldo) .. 
		--		" Max: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",maxSaldo))) .. string.format("%.2f",maxSaldo) .. 
		--		" D: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",totalSaldo/tree["childcount" .. i]))) .. string.format("%.2f",totalSaldo/tree["childcount" .. i]) .. 
				" Auslastung: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",totalSaldo))) .. string.format("%.2f",totalSaldo) .. 
				""
		tree["titlefont" .. i] = "Courier, 10"
	end --if tree["KIND" .. i]=="BRANCH" and tree["depth" .. i]>="1" then
end --for i=tree.count-1,0,-1 do

--[[Aggregation für die erste Ebene aus den untergeordneten Knoten der zweiten Ebene
for i=0, tree.count-1 do
	if tree["KIND" .. i]=="BRANCH" and tree["depth" .. i]=="1" then
		tree["state" .. i]="COLLAPSED"
		local totalSaldo=0
		local maxSaldo=-99999999999
		local minSaldo=99999999999
		for i1=i+1, i+tree["childcount" .. i] do
			local saldoNumber=tonumber(tree["TITLE" .. i1]:match(": (.*)$"))
			totalSaldo=totalSaldo+(saldoNumber or 0)
			maxSaldo=math.max(maxSaldo,(saldoNumber or 0))
			minSaldo=math.min(minSaldo,(saldoNumber or 0))
		end --for i1=i, i+tree.totalchildcount do
		tree["TITLE" .. i]=tree["TITLE" .. i] .. string.rep(" ",math.max(0,45-#tree["TITLE" .. i])) .. 
				" #: " .. string.rep(" ",math.max(0,3-#tostring(tree["childcount" .. i]))) .. tree["childcount" .. i] ..
				" S: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",totalSaldo))) .. string.format("%.2f",totalSaldo) .. 
				" D: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",totalSaldo/tree["childcount" .. i]))) .. string.format("%.2f",totalSaldo/tree["childcount" .. i]) .. 
				" Max: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",maxSaldo))) .. string.format("%.2f",maxSaldo) .. 
				" Min: " .. string.rep(" ",math.max(0,12-#string.format("%.2f",minSaldo))) .. string.format("%.2f",minSaldo) .. 
				" "
		tree["titlefont" .. i] = "Courier, 10"
	end --if tree["KIND" .. i]=="BRANCH" then
end --for i=0, tree.count-1 do
--]]


if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
end
