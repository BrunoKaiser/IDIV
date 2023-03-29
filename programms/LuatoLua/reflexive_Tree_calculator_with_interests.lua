actualtree={ branchname="Zinsrechner",  --tree['title0']
{ branchname="1. Allgemeiner Rechner",  --tree['title1']
state="COLLAPSED",
 "Geben Sie eine Rechenaufgabe ein, z.B. 5+7:",  --tree['title2']
 "10000*0.03",  --tree['title3']

{ branchname="Berechnen",  --tree['title4']
 "",  --tree['title5']
},
},
{ branchname="2. Schaltjahrberechnung",  --tree['title6']
state="COLLAPSED",
 "Geben Sie ein Jahr zwischen 1900 und 2999 ein:",  --tree['title7']
 "2021",  --tree['title8']

{ branchname="Ausgabe",  --tree['title9']
 "",  --tree['title10']
},
},
{ branchname="3. Zinsberechnung",  --tree['title11']
{ branchname="Geben Sie Kapital und Zinssatz ein:",  --tree['title12']
state="COLLAPSED",
 "10000",  --tree['title13']
 "0.3",  --tree['title14']
},
{ branchname="Startdatum:",  --tree['title15']
state="COLLAPSED",
 "01.02.2012",  --tree['title16']

{ branchname="Startdatum ist Last of day February",  --tree['title17']
 "nein",  --tree['title18']
},
},
{ branchname="Endedatum:",  --tree['title19']
state="COLLAPSED",
 "31.05.2013",  --tree['title20']

{ branchname="Endedatum ist Last day of February",  --tree['title21']
 "nein",  --tree['title22']
},
},
{ branchname="Schalttage im Zins-Intervall bestimmen",  --tree['title23']
 "",  --tree['title24']
},
{ branchname="Anzahl Tage im Zähler bestimmen und soweit schon möglich im Nenner, sonst weitere Knoten verwenden",  --tree['title25']
{ branchname="Tageskonventionen für 360 Tage mit der Formel",  --tree['title26']
state="COLLAPSED",
{ branchname="Tage = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)",  --tree['title27']
{ branchname="30/360 Bond Basis, 30A/360:",  --tree['title28']
state="COLLAPSED",
 "This convention is exactly as 30U/360 below, except for the first two rules. Note that the order of calculations is important:",  --tree['title29']
 "D1 = MIN (D1, 30).If D1 = 30 Then D2 = MIN (D2,30)",  --tree['title30']
 "Sources: ISDA 2006 Section 4.16(f), though the first two rules are not included. \'ISDA Definitions, Section 4.16\'. 2006. Retrieved2014-09-18.",  --tree['title31']
},
{ branchname="Anzahl Tage Zähler 30 und Nenner 360",  --tree['title32']
 "",  --tree['title33']
},
{ branchname="30/360 ISDA:",  --tree['title34']
state="COLLAPSED",
 "Regel 1: If D1 is 31, then change D1 to 30.",  --tree['title35']
 "Regel 2 If D1 = 30 after applying Regel 1 and D2 =31 then change D2 to 30.",  --tree['title36']
 "Sources: alternate names of day conventions.",  --tree['title37']
},
{ branchname="Anzahl Tage Zähler 30ISDA und Nenner 360",  --tree['title38']
 "",  --tree['title39']
},
{ branchname="30E/360, 30/360 ICMA, 30S/360, Eurobond basis (ISDA 2006), Special German (spezielle deutsche Zinsmethode):",  --tree['title40']
state="COLLAPSED",
 "Regel 1: If D1 is 31, then change D1 to 30.",  --tree['title41']
 "Regel 2 If D2 is 31, then change D2 to 30.",  --tree['title42']
 "Sources: \'ICMA Rule Book, Rule 251\'. Retrieved 2014-09-18. ICMA Rule 251.1(ii), 251.2. \'ISDA Definitions, Section 4.16\'. 2006. Retrieved 2014-09-18. ISDA 2006 Section 4.16(g).",  --tree['title43']
},
{ branchname="Anzahl Tage Zähler 30E und Nenner 360",  --tree['title44']
 "",  --tree['title45']
},
{ branchname="30E+/360:",  --tree['title46']
state="COLLAPSED",
 "Regel 1: If D1 is 31, then change D1 to 30.",  --tree['title47']
 "Regel 2 If D2 is 31, set D2.M2.Y2 to 1st day of the next month.",  --tree['title48']
 "Sources: alternate names of day conventions.",  --tree['title49']
},
{ branchname="Zum Endedatum 1. des Folgemonats für Regel 30E+:",  --tree['title50']
 "2013",  --tree['title51']
 "6",  --tree['title52']
 "1",  --tree['title53']
},
{ branchname="Anzahl Tage Zähler 30E+ und Nenner 360",  --tree['title54']
 "",  --tree['title55']
},
{ branchname="30/360 German (spezielle deutsche Zinsmethode siehe oben):",  --tree['title56']
state="COLLAPSED",
 "Regel 1: If D1 and/or D2 is 31, then change D1 to 30 and/or D2 to 30.",  --tree['title57']
 "Regel 2 If D1.M1.Y1 and/or D2.M2.Y2 = last day of february =1.3.-1 Tag then change D1 to 30 and/or D2 to 30.",  --tree['title58']
 "Sources: alternate names of day conventions.",  --tree['title59']
},
{ branchname="Anzahl Tage Zähler 30German und Nenner 360",  --tree['title60']
 "",  --tree['title61']
},
{ branchname="30/360 US:",  --tree['title62']
state="COLLAPSED",
 "Regel 1: If D2.M2.Y2 ist the last day of February (28 ohne Schaltjahr und 29 im Schaltjahr) and D1.M1.Y1 ist the last day of February then D2 = 30",  --tree['title63']
 "Regel 2: If D1.M1.Y1 ist the last day of February (28 ohne Schaltjahr und 29 im Schaltjahr) then D1 = 30",  --tree['title64']
 "Regel 3: If D2 is 31 and D1=30 or D1=31, then change D2 to 30.",  --tree['title65']
 "Regel 4: If D1 is 31, then change D1 to 30.",  --tree['title66']
 "Sources: alternate names of day conventions.",  --tree['title67']
},
{ branchname="Anzahl Tage Zähler 30US und Nenner 360",  --tree['title68']
 "",  --tree['title69']
},
},
},
{ branchname="Tageskonventionen actual mit der exakten Anzahl Tage im Zähler und Nenner für actual im Weiteren Knoten bestimmen",  --tree['title70']
state="COLLAPSED",
{ branchname="Anzahl Tage Zähler actual und Nenner für actual im Weiteren Knoten bestimmen",  --tree['title71']
 "",  --tree['title72']

{ branchname="Für die no leap year abgezogene Tage im Zähler bei der Methode NL/365",  --tree['title73']
 "0",  --tree['title74']
},
},
},
{ branchname="Für die Rechnung benutzte Tage im Zähler",  --tree['title75']
 "",  --tree['title76']

{ branchname="Nenner für Tageskonventionen actual mit der exakten Anzahl Tage bestimmen",  --tree['title77']
state="COLLAPSED",
{ branchname="actual 365.25 1/1:",  --tree['title78']
state="COLLAPSED",
 "This is used for inflation instruments and divides the overall 4 year period distributing the additional day across all 4 years i.e. giving 365.25 days to each year.",  --tree['title79']
 "Sources: \'ISDA Definitions, Section 4.16\'. 2006. Retrieved2014-09-18. ISDA 2006 Section 4.16(a). \'FBF Master Agreement for Financial Transactions, Supplement to the Derivatives Annex, Edition 2004\'. 2004. Retrieved 2014-09-18. FBF Master Agreement for Financi",  --tree['title80']
},
{ branchname="Nenner actual 365.25 1/1",  --tree['title81']
 "",  --tree['title82']
},
{ branchname="actual 366:",  --tree['title83']
state="COLLAPSED",
 "Für Schaltjahre oder Act/365A für gesamte Periode, falls Schalttag vorhanden oder Act/365L falls Endedatum im Schaltjahr",  --tree['title84']
},
{ branchname="Nenner actual 366",  --tree['title85']
 "",  --tree['title86']
},
{ branchname="actual 365, Act/365, FixedAct/365, FixedAct/365FEnglish:",  --tree['title87']
state="COLLAPSED",
 "Each month is treated normally and the year is assumed to be 365 days. For example, in a period from February 1, 2005 to April 1, 2005, the Factor is considered to be 59 days divided by 365.",  --tree['title88']
 "The CouponFactor uses the same formula, replacing Date2 by Date3. In general, coupon payments will vary from period to period, due to the differing number of days in the periods. The formula applies to both regular and irregular coupon periods.",  --tree['title89']
 "Sources: \'ISDA Definitions, Section 4.16\'. 2006. Retrieved2014-09-18. ISDA 2006 Section 4.16(d).",  --tree['title90']
},
{ branchname="Nenner actual 365",  --tree['title91']
 "",  --tree['title92']
},
{ branchname="actual 364:",  --tree['title93']
state="COLLAPSED",
 "Each month is treated normally and the year is assumed to be 364 days. For example, in a period from February 1, 2005 to April 1, 2005, the Factor is considered to be 59 days divided by 364.",  --tree['title94']
 "The CouponFactor uses the same formula, replacing Date2 by Date3. In general, coupon payments will vary from period to period, due to the differing number of days in the periods. The formula applies to both regular and irregular coupon periods.",  --tree['title95']
},
{ branchname="Nenner actual 364",  --tree['title96']
 "",  --tree['title97']
},
{ branchname="Actual 360, Act/360, A/360, French (französische Methode):",  --tree['title98']
state="COLLAPSED",
 "This convention is used in money markets for short-term lending of currencies, including the US dollar and Euro, and is applied in ESCBmonetary policy operations. It is the convention used withRepurchase agreements. Each month is treated normally and the year",  --tree['title99']
 "The CouponFactor uses the same formula, replacing Date2 by Date3. In general, coupon payments will vary from period to period, due to the differing number of days in the periods. The formula applies to both regular and irregular coupon periods.",  --tree['title100']
 "Sources: \'ICMA Rule Book, Rule 251\'. Retrieved 2014-09-18. ICMA Rule 251.1(i) (not sterling). \'ISDA Definitions, Section 4.16\'. 2006. Retrieved2014-09-18. ISDA 2006 Section 4.16(e). (Mayle 1993)",  --tree['title101']
},
{ branchname="Nenner actual 360",  --tree['title102']
 "",  --tree['title103']
},
},
{ branchname="Für die Rechnung benutzte Tage im Nenner",  --tree['title104']
 "",  --tree['title105']
},
{ branchname="Geben Sie die Anzahl Jahre mit Nachkommastellen manuell ein:",  --tree['title106']
state="COLLAPSED",
 "1",  --tree['title107']

{ branchname="Jahre manuell setzen",  --tree['title108']
state="COLLAPSED",
},
},
{ branchname="Für die Rechnung benutzte Jahre mit Nachkommastellen",  --tree['title109']
 "",  --tree['title110']
},
{ branchname="Für die Rechnung benutzte Zinsberechnungsmethode:",  --tree['title111']
 "",  --tree['title112']
},
{ branchname="Zinsberechnung",  --tree['title113']
{ branchname="Kapital und Zinssatz eintragen",  --tree['title114']
{ branchname="Alle Zinsen mit Titel ausgeben",  --tree['title115']
{ branchname="Titel",  --tree['title116']
 "",  --tree['title117']
},
{ branchname="Zinsen linear = Kapital * Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner",  --tree['title118']
 "",  --tree['title119']
},
{ branchname="Zinsen mit Zinseszinsen = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner)-1)",  --tree['title120']
 "",  --tree['title121']
},
{ branchname="Anzahl unterjähriger Zinsperioden",  --tree['title122']
{ branchname="1",  --tree['title123']
state="COLLAPSED",
},
{ branchname="Zinsen mit Zinseszinsen unterjährig = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner * Anzahl_Zinsperioden_im_Jahr)-1)",  --tree['title124']
 "",  --tree['title125']
},
},
{ branchname="Zinsen stetig verzinst = Kapital * (e^(Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner) -1)",  --tree['title126']
 "",  --tree['title127']
},
{ branchname="Alle Zinsen mit Titel in eine Datei ausgeben",  --tree['title128']
 "C:\\Tree\\LuatoLua\\reflexive_Tree_calculator_with_interests.txt",  --tree['title129']
},
},
},
{ branchname="Zurücksetzen",  --tree['title130']
state="COLLAPSED",
},
},
},
},
},
{ branchname="Quellen",  --tree['title131']
state="COLLAPSED",
 "https://en.m.wikipedia.org/wiki/Day_count_convention",  --tree['title132']
 "https://m.zinsen-berechnen.de/zinsmethoden/",  --tree['title133']
}}--actualtree=


--1. basic data
--1.1 libraries and clipboard
--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs
require("iuplua_scintilla") --for Scintilla-editor

--1.1.2 initalize clipboard
clipboard=iup.clipboard{}

--1.1.3 math.integer for Lua 5.1 and Lua 5.2
if _VERSION=='Lua 5.1' then
	function math.tointeger(a) return a end
elseif _VERSION=='Lua 5.2' then
	function math.tointeger(a) return a end
end --if _VERSION=='Lua 5.1' then


--1.1.4 securisation by allowing only necessary os.execute commands
do --sandboxing
	local old=os.date("%H%M%S")
	local secureTable={}
	secureTable[old]=os.execute
	function os.execute(a)
		if 
		a:lower():match("^sftp ") or
		a:lower():match("^dir ") or
		a:lower():match("^pause") or
		a:lower():match("^title") or
		a:lower():match("^md ") or
		a:lower():match("^copy ") or
		a:lower():match("^color ") or
		a:lower():match("^start ") or
		a:lower():match("^cls") 
		then
			return secureTable[old](a)
		else
			print(a .." ist nicht erlaubt.")
		end --if a:match("del") then 
	end --function os.execute(a)
	secureTable[old .. "1"]=io.popen
	function io.popen(a)
		if 
		a:lower():match("^dir ") or
		a:lower():match('^"dir ') 
		then
			return secureTable[old .. "1"](a)
		else
			print(a .." ist nicht erlaubt.")
		end --if a:match("del") then 
	end --function io.popen(a)
end --do --sandboxing

--1.2 color section
--1.2.1 color of the console associated with the graphical user interface if started with lua54.exe and not wlua54.exe
os.execute('color 71')

--1.2.2 colors
color_red="135 131 28"
color_light_color_grey="96 197 199"
color_grey="162 163 165"
color_blue="18 132 86"

--1.2.3 color definitions
color_background=color_light_color_grey
color_buttons=color_blue -- works only for flat buttons
color_button_text="255 255 255"
color_background_tree="246 246 246"


--2. path of the graphical user interface and filename of this script
path=arg[0]:match("(.*)\\")
--test with: print(path)
thisfilename=arg[0]:match("\\([^\\]+)$")
--test with: print(arg[0])
--test with: print(thisfilename)

--3 functions

--3.1 general Lua functions

--3.1.1 function checking if file exits
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end --function file_exists(name)

--3.1.2 function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--3.1.3 round function here away-from-zero
--other forms of round functions can also be implemented in Lua
function math.round(a,precisionNumber) 
precisionNumber=precisionNumber or 0 
if a>0 then return math.floor(a*10^precisionNumber+0.5)/10^precisionNumber 
else        return math.ceil (a*10^precisionNumber-0.5)/10^precisionNumber 
end --if a>0 then
end --function math.round(a,precisionNumber)

--3.2 functions for GUI

--3.2.1 function which saves the current iup tree as a Lua table
function save_tree_to_lua(tree, outputfile_path)
	local output_tree_text="actualtree=" --the output string
	local outputfile=io.output(outputfile_path) --a output file
	for i=0,tree.count - 1 do --loop for all nodes
		if tree["KIND" .. i ]=="BRANCH" then --consider cases, if actual node is a branch
			if (i > 0 and (tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) ) ) or i==0 then --consider cases if depth increases
				output_tree_text = output_tree_text .. '{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",  --tree[\'title' .. i .. "']\n" -- we open a new branch
				--save state
				if tree["STATE" .. i ]=="COLLAPSED" then
					output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
				end --if tree["STATE" .. i ]=="COLLAPSED" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) < tonumber(tree["DEPTH" .. i-1 ]) then --if depth decreases
				if tree["KIND" .. i-1 ] == "BRANCH" then --depending if the predecessor node was a branch we need to close one bracket more
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
					output_tree_text = output_tree_text .. '{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",  --tree[\'title' .. i .. "']\n" --and we open the new branch
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				else
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do -- or if the predecessor node was a leaf
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
					output_tree_text = output_tree_text .. '{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",  --tree[\'title' .. i .. "']\n" --and we open the new branch
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				end --if tree["KIND" .. i-1 ] == "BRANCH" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) == tonumber(tree["DEPTH" .. i-1 ]) then --or if depth stays the same
				if tree["KIND" .. i-1 ] == "BRANCH" then --again consider if the predecessor node was a branch
					output_tree_text = output_tree_text .. '},\n{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",  --tree[\'title' .. i .. "']\n"
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				else --or a leaf
					output_tree_text = output_tree_text .. '\n{ branchname="' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",  --tree[\'title' .. i .. "']\n"
					--save state
					if tree["STATE" .. i ]=="COLLAPSED" then
						output_tree_text = output_tree_text .. 'state="COLLAPSED",\n'
					end --if tree["STATE" .. i ]=="COLLAPSED" then
				end --if tree["KIND" .. i-1 ] == "BRANCH" then
			end --if (i > 0 and (tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) ) ) or i==0 then
		elseif tree["KIND" .. i ]=="LEAF" then --or if actual node is a leaf
			if (i > 0 and tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) )  or i==0 then
				output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",  --tree[\'title' .. i .. "']\n" --we add the leaf
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) < tonumber(tree["DEPTH" .. i-1 ]) then
				if tree["KIND" .. i-1 ] == "LEAF" then --in the same manner as above, depending if the predecessor node was a leaf or branch, we have to close a different number of brackets
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) do
					output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",  --tree[\'title' .. i .. "']\n" --and in each case we add the new leaf
				else
					for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
						output_tree_text = output_tree_text .. '},\n'
					end --for j=1, tonumber(tree["DEPTH" .. i-1 ])- tonumber(tree["DEPTH" .. i ]) +1 do
					output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",  --tree[\'title' .. i .. "']\n"
				end --if tree["KIND" .. i-1 ] == "LEAF" then
			elseif i > 0 and tonumber(tree["DEPTH" .. i ]) == tonumber(tree["DEPTH" .. i-1 ]) then
				if tree["KIND" .. i-1 ] == "LEAF" then
					output_tree_text = output_tree_text .. ' "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",  --tree[\'title' .. i .. "']\n"
				else
					output_tree_text = output_tree_text .. '},\n "' .. string.escape_forbidden_char(tree["TITLE" .. i ]) .. '",  --tree[\'title' .. i .. "']\n"
				end --if tree["KIND" .. i-1 ] == "LEAF" then
			end --if (i > 0 and tonumber(tree["DEPTH" .. i ]) > tonumber(tree["DEPTH" .. i-1 ]) )  or i==0 then
		end --if tree["KIND" .. i ]=="BRANCH" then
	end --for i=0,tree.count - 1 do
	for j=1, tonumber(tree["DEPTH" .. tree.count-1]) do
		output_tree_text = output_tree_text .. "}" --close as many brackets as needed
	end --for j=1, tonumber(tree["DEPTH" .. tree.count-1]) do
	if tree["KIND" .. tree.count-1]=="BRANCH" then
		output_tree_text = output_tree_text .. "}" -- we need to close one more bracket if last node was a branch
	end --if tree["KIND" .. tree.count-1]=="BRANCH" then
	--output_tree_text=string.escape_forbidden_char(output_tree_text)
	outputfile:write(output_tree_text .. "--" .. "actualtree" .. "=\n") --write everything into the outputfile
	outputfile:close()
end --function save_tree_to_lua(tree, outputfile_path)


--3.3 functions for tree calculations
--3.3.1 functions in function Table
functionTable={}
functionTable["Zinsen mit Zinseszinsen unterjährig = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner * Anzahl_Zinsperioden_im_Jahr)-1)"]=function()
--Diese Funktion gibt die Zinsen bei einer unterjährigen Verzinsung aus
if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title110']) then 
Ergebnis = tree['title13']*(math.pow(-(-1-tree['title14']), tonumber(tree['title76']) / tonumber(tree['title105']) * tree['title123'])-1)
Ergebnis = "" .. math.round(Ergebnis,2)
tree['title125'] = tree['title125'] .. ";" .. '"' .. tree['title112'] .. '"' .. ";" .. '"' .. Ergebnis:gsub('%.',',') .. '"' 
end --if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title110']) then 
end --functionTable["Zinsen mit Zinseszinsen unterjährig = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner * Anzahl_Zinsperioden_im_Jahr)-1)"]=function()
functionTable["Schalttage im Zins-Intervall bestimmen"]=function()
Startdatum=os.time{year=tonumber(tree['title16']:match("^%d%d.%d%d.(%d%d%d%d)")),month=tonumber(tree['title16']:match("^%d%d.(%d%d).")),day=tonumber(tree['title16']:match("^(%d%d).%d%d."))}
Endedatum=os.time{year=tonumber(tree['title20']:match("^%d%d.%d%d.(%d%d%d%d)")), month=tonumber(tree['title20']:match("^%d%d.(%d%d).")),day=tonumber(tree['title20']:match("^(%d%d).%d%d."))}
LastOfFebruaryCollection=""
for i=tonumber(tree['title16']:match("^%d%d.%d%d.(%d%d%d%d)")),tonumber(tree['title20']:match("^%d%d.%d%d.(%d%d%d%d)")) do
	LastOfFebruary=os.time{year=i,month=3,day=0}
	if Startdatum<=LastOfFebruary and LastOfFebruary<=Endedatum then
		if os.date("%d",LastOfFebruary)=="29" then
			if LastOfFebruaryCollection=="" then 
				LastOfFebruaryCollection=os.date("%d.%m.%Y",LastOfFebruary)
			else
				LastOfFebruaryCollection=LastOfFebruaryCollection .. "/" .. os.date("%d.%m.%Y",LastOfFebruary)
			end --if LastOfFebruaryCollection=="" then 
		end --if os.date("%d",LastOfFebruary)="29" then
	end --if Startdatum<=LastOfFebruary and LastOfFebruary<=Endedatum then
end --for i=tonumber(tree['title16']:match("^%d%d.%d%d.(%d%d%d%d)")),tonumber(tree['title20']:match("^%d%d.%d%d.(%d%d%d%d)")) do
tree['title24']=LastOfFebruaryCollection
end --functionTable["Schalttage im Zins-Intervall bestimmen"]=function()

functionTable["Berechnen"]=function() 
load("Ergebnis = " .. tree['title' .. 3]:gsub('×','*'):gsub('÷','/'):gsub(',','.'))()
tree['title' .. 5]=Ergebnis
end --functionTable["Berechnen"]=function() 


--3.3.2 functions with function names corresponding to nodes
function Schaltjahr() 
Jahr = tree['title' .. 8]
Tage = 28 
if (Jahr%4==0) then Tage=Tage+1 end
if (Jahr%100==0) then Tage=Tage+1 end --;if(Jahr%400==0) Tage++;
if (Tage==28) then tree['title' .. 10] = Jahr .. " ist kein Schaltjahr" end ;
if (Tage==29) then tree['title' .. 10] =Jahr .. " ist ein Schaltjahr" end ;
end --function Schaltjahr() 



--
-- 360 Methode
function Anzahltage30zaehler()
-- 30/360 Bond Basis This convention is exactly as 30U/360 below, except for the first two rules. Note that the order of calculations is important:
D1 = tonumber(tree['title16']:match("^(%d%d).%d%d."))
D2 = tonumber(tree['title20']:match("^(%d%d).%d%d."))
M1 = tonumber(tree['title16']:match("^%d%d.(%d%d)."))
M2 = tonumber(tree['title20']:match("^%d%d.(%d%d)."))
Y1 = tonumber(tree['title16']:match("^%d%d.%d%d.(%d%d%d%d)"))
Y2 = tonumber(tree['title20']:match("^%d%d.%d%d.(%d%d%d%d)"))
if (D1>30) then D1 = 30 end --Regel 1: D1 = MIN (D1, 30).
if (D1==30) then if (D2>30) then D2 = 30 end end--Regel 2: If D1 = 30 Then D2 = MIN (D2,30)
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)
tree['title33'] = Ergebnis
tree['title76'] = Ergebnis
tree['title112'] = "M30";
tree['title110'] =  Ergebnis / 360
tree['title105'] = 360
end --function Anzahltage30zaehler()

--
function Anzahltage30ISDAzaehler() 
-- 30/360 ISDA:
D1 = tonumber(tree['title16']:match("^(%d%d).%d%d."))
D2 = tonumber(tree['title20']:match("^(%d%d).%d%d."))
M1 = tonumber(tree['title16']:match("^%d%d.(%d%d)."))
M2 = tonumber(tree['title20']:match("^%d%d.(%d%d)."))
Y1 = tonumber(tree['title16']:match("^%d%d.%d%d.(%d%d%d%d)"))
Y2 = tonumber(tree['title20']:match("^%d%d.%d%d.(%d%d%d%d)"))
applied30="Regel1 not applied mit 30";
if (D1==31) then D1 = 30; applied30="Regel 1 applied mit 30" end--Regel 1: if D1 = 30 then change D1 to 30.
if (applied30=="Regel 1 applied mit 30") then if (D2==31) then D2 = 30 end end --Regel 2: If D1 = 30 after applying Regel 1 Then D2 = 30
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)
tree['title39'] = Ergebnis .. " " .. applied30
tree['title76'] = Ergebnis
tree['title112'] = "M30ISDA";
tree['title110'] =  Ergebnis / 360
tree['title105'] = 360
end --function Anzahltage30ISDAzaehler()


--
function Anzahltage30Ezaehler() 
-- 30E/360 Date adjustment rules:
D1 = tonumber(tree['title16']:match("^(%d%d).%d%d."))
D2 = tonumber(tree['title20']:match("^(%d%d).%d%d."))
M1 = tonumber(tree['title16']:match("^%d%d.(%d%d)."))
M2 = tonumber(tree['title20']:match("^%d%d.(%d%d)."))
Y1 = tonumber(tree['title16']:match("^%d%d.%d%d.(%d%d%d%d)"))
Y2 = tonumber(tree['title20']:match("^%d%d.%d%d.(%d%d%d%d)"))
if (D1==31) then D1 = 30 end --Regel 1: If D1 is 31, then change D1 to 30.
if (D2==31) then D2 = 30 end --Regel 2: If D2 is 31, then change D2 to 30.
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)
tree['title45'] = Ergebnis
tree['title76'] = Ergebnis
tree['title112'] = "M30E";
tree['title110'] =  Ergebnis / 360
tree['title105'] = 360
end --function Anzahltage30Ezaehler()

--
function Anzahltage30EPluszaehler() 
-- 30E+/360 Date adjustment rules:
D1 = tonumber(tree['title16']:match("^(%d%d).%d%d."))
D2 = tonumber(tree['title20']:match("^(%d%d).%d%d."))
D2Plus = -(-tree['title53'])
M1 = tonumber(tree['title16']:match("^%d%d.(%d%d)."))
M2 = tonumber(tree['title20']:match("^%d%d.(%d%d)."))
M2Plus = -(-tree['title52'])
Y1 = tonumber(tree['title16']:match("^%d%d.%d%d.(%d%d%d%d)"))
Y2 = tonumber(tree['title20']:match("^%d%d.%d%d.(%d%d%d%d)"))
Y2Plus = -(-tree['title51'])
veraendert = "unverändert: "
if (D1==31) then D1 = 30 end --Regel 1: If D1 is 31, then change D1 to 30.
if (D2==31) then D2 = D2Plus; M2 = M2Plus; Y2 = Y2Plus; veraendert = "verändert: " end --Regel 2: If D2 is 31, then set D2.M2.Y2 to 1st day of the next month.
--Die Umrechnung in den ersten des nächsten Monats entspricht der Beibehaltung des 31. des Endemonats in der Formel. Es wird eh nur ein Tag hinzugerechnet.
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1) 
tree['title55'] = Ergebnis .. " Endedatum " .. veraendert .. D2 .. "." .. M2 .. "." .. Y2;
tree['title76'] = Ergebnis
tree['title112'] = "M30E+";
tree['title110'] =  Ergebnis / 36
tree['title105'] = 360
end --function Anzahltage30PlusEzaehler()

--
function Anzahltage30Germanzaehler() 
-- 30German/360 Date adjustment rules:
D1 = tonumber(tree['title16']:match("^(%d%d).%d%d."))
D2 = tonumber(tree['title20']:match("^(%d%d).%d%d."))
M1 = tonumber(tree['title16']:match("^%d%d.(%d%d)."))
M2 = tonumber(tree['title20']:match("^%d%d.(%d%d)."))
Y1 = tonumber(tree['title16']:match("^%d%d.%d%d.(%d%d%d%d)"))
Y2 = tonumber(tree['title20']:match("^%d%d.%d%d.(%d%d%d%d)"))
D1LetzterFebruar =""
D2LetzterFebruar =""
if (D1==31) then D1 = 30 end --Regel 1: If D1 is 31, then change D1 to 30.
if (D2==31) then D2 = 30 end --Regel 1: If D2 is 31, then change D2 to 30.
--nämlich Regel 1: If D1 and/or D2 is 31, then change D1 to 30 and/or D2 to. 
if (tree['title18']=="ja") then D1=30; D1LetzterFebruar=" Startdatum letzter vom Februar " end
if (tree['title22']=="ja") then D2=30; D2LetzterFebruar=" Endedatum letzter vom Februar "  end
-- Regel 2 If D1.M1.Y1 and/or D2.M2.Y2 = last day of february =1.3.-1 Tag then change D1 to 30 and/or D2 to 30. 
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)
tree['title61'] = Ergebnis .. "" .. D1LetzterFebruar .. D2LetzterFebruar;
tree['title76'] = Ergebnis
tree['title112'] = "M30German";
tree['title110'] =  Ergebnis / 360
tree['title105'] = 360
end --function Anzahltage30Germanzaehler()


function Anzahltage30USzaehler() 
-- 30German/360 Date adjustment rules:
D1 = tonumber(tree['title16']:match("^(%d%d).%d%d."))
D2 = tonumber(tree['title20']:match("^(%d%d).%d%d."))
M1 = tonumber(tree['title16']:match("^%d%d.(%d%d)."))
M2 = tonumber(tree['title20']:match("^%d%d.(%d%d)."))
Y1 = tonumber(tree['title16']:match("^%d%d.%d%d.(%d%d%d%d)"))
Y2 = tonumber(tree['title20']:match("^%d%d.%d%d.(%d%d%d%d)"))
Regel1 = ""
Regel2 = ""
if (tree['title18']=="ja" and tree['title22']=="ja") then D2=30; Regel1="Regel1 beide letzte vom Februar" end --Regel 1: If D2.M2.Y2 ist the last day of February (28 ohne Schaltjahr und 29 im Schaltjahr) and D1.M1.Y1 ist the last day of February then D2 = 30
if (tree['title18']=="ja") then D1=30; Regel2=" Regel2 Startdatum letzter vom Februar" end --Regel 2: If D1.M1.Y1 ist the last day of February (28 ohne Schaltjahr und 29 im Schaltjahr) then D1 = 30
if (D2==31 and D1==30) then D2 = 30 end --Regel 3: If D2 is 31 and D1=30 or D1=31, then change D2 to 30.
if (D2==31 and D1==31) then D2 = 30 end
if (D1==31) then D1 = 30 end --Regel 4: If D1 is 31, then change D1 to 30.
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)
tree['title69'] = Ergebnis ..  " " .. Regel1 .. Regel2 
tree['title76'] = Ergebnis
tree['title112'] = "M30US"
tree['title110'] =  Ergebnis / 360
tree['title105'] = 360
end --function Anzahltage30USzaehler()



--
--actual Methode
function Anzahltagezaehler() 
Startdatum=os.time{year=tonumber(tree['title16']:match("^%d%d.%d%d.(%d%d%d%d)")),month=tonumber(tree['title16']:match("^%d%d.(%d%d).")),day=tonumber(tree['title16']:match("^(%d%d).%d%d."))}
Endedatum=os.time{year=tonumber(tree['title20']:match("^%d%d.%d%d.(%d%d%d%d)")), month=tonumber(tree['title20']:match("^%d%d.(%d%d).")),day=tonumber(tree['title20']:match("^(%d%d).%d%d."))}
Ergebnis = math.tointeger(math.round((Endedatum - Startdatum)/60/60/24,0))
tree['title72']= Ergebnis
tree['title76'] = Ergebnis - tree['title74']
end --function Anzahltagezaehler()

--
function Nenneractual36525() 
Anzahltagezaehler() 
tree['title82'] = 365.25
tree['title112'] = "act365Komma25bzw1durch1";
tree['title105'] = 365.25
if tonumber(tree['title76']) then tree['title110'] =  tonumber(tree['title76']) / 365.25 end
end --function Nenneractual36525()

--
function Nenneractual366() 
Anzahltagezaehler() 
tree['title86'] = 366
tree['title112'] = "act366";
if tonumber(tree['title76']) then tree['title110'] =  tonumber(tree['title76']) / 366 end
tree['title105'] = 366
end --function Nenneractual366()


--
function Nenneractual365() 
Anzahltagezaehler() 
tree['title92'] = 365
tree['title112'] = "act365";
if tonumber(tree['title76']) then tree['title110'] =  tonumber(tree['title76']) / 365 end
tree['title105'] = 365
end --function Nenneractual365()


--


--
function Nenneractual364() 
Anzahltagezaehler() 
tree['title97'] = 364
tree['title112'] = "act364";
if tonumber(tree['title76']) then tree['title110'] =  tonumber(tree['title76']) / 364 end
tree['title105'] = 364
end --function Nenneractual364()


--
function Nenneractual360() 
Anzahltagezaehler() 
tree['title103'] = 360
tree['title112'] = "act360";
if tonumber(tree['title76']) then tree['title110'] =  tonumber(tree['title76']) / 360 end
tree['title105'] = 360
end --function Nenneractual360()


--Zinsrechner
function JahreManuellSetzen() 
tree['title110'] = tree['title107']
tree['title112'] = "manuell";
end --function JahreManuellSetzen()


function KapitalZinssatzSchreiben() 
Start=os.date("%d.%m.%Y",os.time{year=tonumber(tree['title16']:match("^%d%d.%d%d.(%d%d%d%d)")),month=tonumber(tree['title16']:match("^%d%d.(%d%d).")),day=tonumber(tree['title16']:match("^(%d%d).%d%d."))})
Ende=os.date("%d.%m.%Y",os.time{year=tonumber(tree['title20']:match("^%d%d.%d%d.(%d%d%d%d)")), month=tonumber(tree['title20']:match("^%d%d.(%d%d).")),day=tonumber(tree['title20']:match("^(%d%d).%d%d."))})
tree['title117'] = '"' .. "Zinsart" .. '"' .. ";" .. '"' .. "Kapital" .. '"' .. ";" .. '"' .. "Zinssatz" .. '"' .. ";" .. '"' .. "Startdatumsangabe" .. '"' .. ";" .. '"' .. "Endedatumsangabe" .. '"'
tree['title119'] = '"' .. "Zins" .. '"' .. ";" .. '"' .. tree['title13']:gsub('%.',',') .. '"' .. ";" .. '"' .. tree['title14']:gsub('%.',',') .. '"' .. ";" .. '"' .. Start .. '"' .. ";" .. '"' .. Ende .. '"' ;
tree['title121'] = '"' .. "ZinsZinseszins" .. '"' .. ";" .. '"' .. tree['title13']:gsub('%.',',') .. '"' .. ";" .. '"' .. tree['title14']:gsub('%.',',') .. '"' .. ";" .. '"' .. Start .. '"' .. ";" .. '"' .. Ende .. '"' ;
tree['title125'] = '"' .. "ZinsZinseszinsunterjaehrig" .. '"' .. ";" .. '"' .. tree['title13']:gsub('%.',',') .. '"' .. ";" .. '"' .. tree['title14']:gsub('%.',',') .. '"' .. ";" .. '"' .. Start .. '"' .. ";" .. '"' .. Ende .. '"' ;
tree['title127'] ='"' ..  "Zinsstetig" .. '"' .. ";" .. '"' .. tree['title13']:gsub('%.',',') .. '"' .. ";" .. '"' .. tree['title14']:gsub('%.',',') .. '"' .. ";" .. '"' .. Start .. '"' .. ";" .. '"' .. Ende .. '"' ;
end --function KapitalZinssatzSchreiben()

function TitelErgaenzen() 
if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title110']) then 
tree['title117'] = tree['title117'] .. ";" .. '"' .. "Methode_" .. tree['title112'] .. '"' .. ";" .. '"' .. "Ergebnis_" .. tree['title112'] .. '"' 
end --if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title110']) then 
end --function TitelErgaenzen()


function Zinsen() 
if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title110']) then 
Ergebnis = tonumber(tree['title13']) * tonumber(tree['title14']) * tonumber(tree['title76']) / tonumber(tree['title105']) 
Ergebnis = math.round(Ergebnis,2)
tree['title119'] = tree['title119'] .. ";" .. '"' .. tree['title112'] .. '"' .. ";" .. '"' .. tostring(Ergebnis):gsub('%.',',') .. '"' 
end --if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title110']) then 
end --function Zinsen()
function Zinseszinsen() 
if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title110']) then 
Ergebnis = tree['title13']*(math.pow(-(-1-tree['title14']), tonumber(tree['title76']) / tonumber(tree['title105']))-1)
Ergebnis = "" .. math.round(Ergebnis,2)
tree['title121'] = tree['title121'] .. ";" .. '"' .. tree['title112'] .. '"' .. ";" .. '"' .. Ergebnis:gsub('%.',',') .. '"' 
end --if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title110']) then 
end --function Zinseszinsen()
function Zinsenstetig() 
if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title110']) then 
Ergebnis = tree['title13']*(math.exp(-(-tree['title14']) * tonumber(tree['title76']) / tonumber(tree['title105']) )-1);
Ergebnis = "" .. math.round(Ergebnis,2)
tree['title127'] = tree['title127'] .. ";" .. '"' .. tree['title112'] .. '"' .. ";" .. '"' .. Ergebnis:gsub('%.',',') .. '"'
end --if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title110']) then 
end --function Zinsenstetig()

function ZinsenTitelAlle()
TitelErgaenzen();
Zinsen();
Zinseszinsen();
functionTable["Zinsen mit Zinseszinsen unterjährig = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner * Anzahl_Zinsperioden_im_Jahr)-1)"]();
Zinsenstetig();
end --function ZinsenTitelAlle()

--
function KapitalZinssatzZuruecksetzen() 
tree['title117']=""
tree['title119']=""
tree['title121']=""
tree['title125']=""
tree['title127']=""
end --function KapitalZinssatzZuruecksetzen() 
--

function ZinsErgebnisAlleZeilenAusgabe() 
local outputfile1=io.open(path .. "\\" .. thisfilename:gsub("%.lua",".txt"),"w")
outputfile1:write(tree['title117'] .. "\n")
outputfile1:write(tree['title119'] .. "\n")
outputfile1:write(tree['title121'] .. "\n")
outputfile1:write(tree['title125'] .. "\n")
outputfile1:write(tree['title127'] .. "\n")
outputfile1:close()
end --function ZinsErgebnisAlleZeilenAusgabe()

--4. dialogs

--4.1 rename dialog
--ok button
ok = iup.flatbutton{title = "Speichern und neu Öffnen. Zusätzliche Zeilen:",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function ok:flat_action()
	--test with: print(tostring(math.tointeger(text_NumberOfNodesMore.value)==1))
	local treeValue=tree.value
	tree.title = text.value
	--save copy of program
	os.execute('copy "' .. path .. "\\" .. thisfilename .. '" "' .. path .. "\\" .. thisfilename:gsub("%.lua","_Sicherung.lua") .. '"')
	--store the programm in the Lua table outputfile1Table
	local startWriteProgramm="no"
	local outputfile1Table={}
	for line in io.lines(path .. "\\" .. thisfilename) do
		if startWriteProgramm=="yes" then
			if math.tointeger(text_NumberOfNodesMore.value)==1 then
				local digitTable={}
				for field in line:gmatch("tree%['[^%d]+%d+'%]") do
					digitTable[#digitTable+1]=field
				end --for field in line:gmatch("tree%['[^%d]+%d+'%]") do
				table.sort(digitTable,function(a,b) local ad=tonumber(a:match("%d+")) bd=tonumber(b:match("%d+")) return ad>bd end)
				for i,v in ipairs(digitTable) do
					local vMatch=v:gsub("%[","%%["):gsub("%]","%%]"):gsub("%(","%%("):gsub("%)","%%)"):gsub("%-","%%-"):gsub("%*","%%*"):gsub("%+","%%+")
					--test with: print(i,v)
					local treeType,digitText=v:match("'([^%d]+)(%d+)'")
					--test with: print(treeType,digitText)
					--test with: print(treeValue,digitText)
					if math.tointeger(tonumber(digitText))>=math.tointeger(tonumber(treeValue)) then
					--test with: print(line) print(vMatch)
						line=line:gsub(vMatch,"tree['" .. treeType .. math.tointeger(tonumber(digitText+1)) .. "']")
					--test with: print("tree['" .. treeType .. math.tointeger(tonumber(digitText-1)) .. "']") print(line)
					end --if math.tointeger(tonumber(digitText))>=math.tointeger(tonumber(treeValue)) then
				end --for i,v in ipairs(digitTable) d
			end --if text_NumberOfNodesMore.value==1 then
			outputfile1Table[#outputfile1Table+1]=line	
		end --if startWriteProgramm=="yes" then
		if line:match("%-%-actualtree" .. "=") then startWriteProgramm="yes" end
	end --for line in io.lines(path .. "\\" .. thisfilename) do
	--save the tree
	save_tree_to_lua(tree, path .. "\\" .. thisfilename)
	--save the programm stored in the Lua table outputfile1Table
	local outputfile1=io.open(path .. "\\" .. thisfilename,"a")
	for i,v in ipairs(outputfile1Table) do
		outputfile1:write(v .. "\n")
	end --for i,v in ipairs(outputfile1Table) do
	outputfile1:close()
	os.execute('start "Neu" "' .. path .. "\\" .. thisfilename .. '"')
	return iup.CLOSE
end --function ok:flat_action()


text = iup.multiline{size="120x50",border="YES",expand="YES",wordwrap="YES"} --textfield
text_NumberOfNodesMore = iup.multiline{value="0",size="20x20",border="YES",expand="YES",wordwrap="YES",readonly="YES"} --textfield
label1 = iup.label{title="Name:"}--label for textfield

--open the dialog for renaming branch/leaf
dlg_rename = iup.dialog{
	iup.vbox{label1, text, iup.hbox{ok,text_NumberOfNodesMore}}; 
	title="Knoten bearbeiten",
	size="QUARTER",
	startfocus=text,
	}

--4.1 rename dialog end

--4.2 icon dialog
--ok button
icon_ok = iup.flatbutton{title = "Speichern und neu öffnen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function icon_ok:flat_action()
	--save copy of program
	os.execute('copy "' .. path .. "\\" .. thisfilename .. '" "' .. path .. "\\" .. thisfilename:gsub("%.lua","_Sicherung.lua") .. '"')
	--read the programm and store it in a Lua table
	local startWriteProgramm="yes"
	local outputfile1Table={}
	for line in io.lines(path .. "\\" .. thisfilename) do
		if line:match("%-%-tree" .. "%['image%.%.%.") then startWriteProgramm="no" end
		if startWriteProgramm=="yes" then
			outputfile1Table[#outputfile1Table+1]=line	
		end --if startWriteProgramm=="yes" then
	end --for line in io.lines(path .. "\\" .. thisfilename) do
	--save the programm stored in the Lua table outputfile1Table
	local outputfile1=io.open(path .. "\\" .. thisfilename,"w")
	for i,v in ipairs(outputfile1Table) do
		outputfile1:write(v .. "\n")
	end --for i,v in ipairs(outputfile1Table) do
	--save the icon list
	outputfile1:write(icon_text.value .. "\n")
	--save the rest of the program
	outputfile1:write("\n\n--7.6 Main Loop\n")
	outputfile1:write("if (iup.MainLoopLevel()==0) then iup.MainLoop() end\n")
	outputfile1:close()
	os.execute('start "Neu" "' .. path .. "\\" .. thisfilename .. '"')
	return iup.CLOSE
end --function icon_ok:flat_action()

icon_searchtext = iup.multiline{border="YES",expand="YES", SELECTION="ALL",wordwrap="YES"} --textfield for search

--search icon_searchtext.value in icon_text
search_in_icon_text   = iup.flatbutton{title = "Suche in den Symboldefinitionen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
searchPosition=1
function search_in_icon_text:flat_action()
from,to=icon_text.value:find(icon_searchtext.value,searchPosition)
if to and from==to then searchPosition=to+1 else searchPosition=to end
if from==nil then 
searchPosition=1 
iup.Message("Suchtext in den Symboldefinitionen nicht gefunden",tostring(icon_searchtext.value) .. " in den Symboldefinitionen nicht gefunden")
else
icon_text.SELECTIONPOS=from-1 .. ":" .. to
end --if from==nil then 
end --	function search_in_icon_text:flat_action()


--field as scintilla editor
icon_text=iup.scintilla{}
icon_text.SIZE="500x320" --I think this is not optimal! (since the size is so appears to be fixed)
--icon_text.wordwrap="WORD" --enable wordwarp
icon_text.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
icon_text.FONT="Courier New, 8" --font of shown code
icon_text.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
icon_text.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false function true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
icon_text.STYLEFGCOLOR0="0 0 0"      -- 0-Default
icon_text.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
icon_text.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
icon_text.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
icon_text.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
icon_text.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
icon_text.STYLEFGCOLOR6="160 20 180"  -- 6-String 
icon_text.STYLEFGCOLOR7="128 0 0"    -- 7-Character
icon_text.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
icon_text.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
icon_text.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--icon_text.STYLEBOLD10="YES"
--icon_text.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--icon_text.STYLEITALIC10="YES"
icon_text.MARGINWIDTH0="40"
icon_text.value=""
icon_label1 = iup.label{title="Liste der Symbole:"}--label for textfield

for line in io.lines(path .. "\\" .. thisfilename) do
	if line:match("tree%['image") then
		if icon_text.value=="" then
			icon_text.value=line
		else
			icon_text.value=icon_text.value .. "\n" .. line
		end --if icon_text.value=="" then
	end --if line:match("tree%['image") then
end --for line in io.lines(path .. "\\" .. thisfilename) do



--open the dialog for renaming branch/leaf
dlg_icon_rename = iup.dialog{
	iup.vbox{icon_label1, icon_text, iup.hbox{icon_ok,icon_searchtext, search_in_icon_text}}; 
	title="Symbole der Knoten bearbeiten",
	size="600x360",
	startfocus=icon_text,
	}

--4.2 icon dialog end

--4.3 node_function dialog
--ok button
node_function_ok = iup.flatbutton{title = "Speichern zu markiertem Knoten und neu öffnen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function node_function_ok:flat_action()
	if tree['title']==nodeChosen then
		--save copy of program
		os.execute('copy "' .. path .. "\\" .. thisfilename .. '" "' .. path .. "\\" .. thisfilename:gsub("%.lua","_Sicherung.lua") .. '"')
		--read the programm and store it in a Lua table
		local startWriteProgramm="yes"
		local outputfile1Table={}
		local outputfile2Table={}
		local newFunctionName=node_function_text.value:match('functionTable%["[^%]]*"%]')
		newFunctionName=newFunctionName or node_function_text.value:match('function [^%(]+%([^%)]*%)')
		--test with: iup.Message(newFunctionName,newFunctionName)
		local inputfile1=io.open(path .. "\\" .. thisfilename,"r")
		inputText1=inputfile1:read("*a")
		inputfile1:close()
		newFunctionNameMatch=newFunctionName:gsub("%[","%%["):gsub("%]","%%]"):gsub("%(","%%("):gsub("%)","%%)"):gsub("%-","%%-"):gsub("%*","%%*"):gsub("%+","%%+")
		--test with: iup.Message(tostring(inputText1:match(newFunctionNameMatch)),newFunctionName)
		if inputText1:match(newFunctionNameMatch) then
			--for existing functions
			for line in io.lines(path .. "\\" .. thisfilename) do
				treeTitleMatch=tree['title']:gsub("%[","%%["):gsub("%]","%%]"):gsub("%(","%%("):gsub("%)","%%)"):gsub("%-","%%-"):gsub("%*","%%*"):gsub("%+","%%+")
				if line:match('^functionTable%["' .. treeTitleMatch .. '"%]=function%(.*%)') or line:match("^function " .. tostring(nodeFunctionTable[tree['title']]) .. "%(.*%)") then startWriteProgramm="no" end
				if startWriteProgramm=="yes" then
					outputfile1Table[#outputfile1Table+1]=line	
				elseif startWriteProgramm=="yes2" then
					outputfile2Table[#outputfile2Table+1]=line	
				end --if startWriteProgramm=="yes" then
				if line:match('^end %-%-functionTable%["' .. treeTitleMatch .. '"%]=function%(.*%)') or line:match("^end %-%-function " .. tostring(nodeFunctionTable[tree['title']]) .. "%(.*%)") then startWriteProgramm="yes2" end
			end --for line in io.lines(path .. "\\" .. thisfilename) do
			--save the programm stored in the Lua table outputfile1Table
			local outputfile1=io.open(path .. "\\" .. thisfilename,"w")
			for i,v in ipairs(outputfile1Table) do
				outputfile1:write(v .. "\n")
			end --for i,v in ipairs(outputfile1Table) do
			--save the node_function list
			outputfile1:write(node_function_text.value .. "\n")
			--save the rest of the program
			for i,v in ipairs(outputfile2Table) do
				outputfile1:write(v .. "\n")
			end --for i,v in ipairs(outputfile1Table) do
			outputfile1:close()
		else
			--for new functions
			for line in io.lines(path .. "\\" .. thisfilename) do
				if startWriteProgramm=="yes" then
					outputfile1Table[#outputfile1Table+1]=line	
				elseif startWriteProgramm=="yes2" then
					outputfile2Table[#outputfile2Table+1]=line	
				end --if startWriteProgramm=="yes" then
				if line:match('^functionTable={}') then startWriteProgramm="yes2" end
			end --for line in io.lines(path .. "\\" .. thisfilename) do
			--save the programm stored in the Lua table outputfile1Table
			local outputfile1=io.open(path .. "\\" .. thisfilename,"w")
			for i,v in ipairs(outputfile1Table) do
				outputfile1:write(v .. "\n")
			end --for i,v in ipairs(outputfile1Table) do
			--save the node_function list
			outputfile1:write(node_function_text.value .. "\n")
			--save the rest of the program
			for i,v in ipairs(outputfile2Table) do
				outputfile1:write(v .. "\n")
			end --for i,v in ipairs(outputfile1Table) do
			outputfile1:close()
		end --if inputText1:match(newFunctionNameMatch) then
		os.execute('start "Neu" "' .. path .. "\\" .. thisfilename .. '"')
		return iup.CLOSE
	else
		iup.Message("Der ausgewählte Knoten entspricht nicht der Funktionsdefinition","Der ausgewählte Knoten entspricht nicht der Funktionsdefinition")
	end --if tree['title']==nodeChosen then
end --function node_function_ok:flat_action()

node_function_searchtext = iup.multiline{border="YES",expand="YES", SELECTION="ALL",wordwrap="YES"} --textfield for search

--search node_function_searchtext.value in node_function_text
search_in_node_function_text   = iup.flatbutton{title = "Suche in der Funktionsdefinition",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
searchPosition=1
function search_in_node_function_text:flat_action()
from,to=node_function_text.value:find(node_function_searchtext.value,searchPosition)
if to and from==to then searchPosition=to+1 else searchPosition=to end
if from==nil then 
searchPosition=1 
iup.Message("Suchtext in der Funktionsdefinition nicht gefunden",tostring(node_function_searchtext.value) .. " in der Funktionsdefinition nicht gefunden")
else
node_function_text.SELECTIONPOS=from-1 .. ":" .. to
end --if from==nil then 
end --	function search_in_node_function_text:flat_action()


--field as scintilla editor
node_function_text=iup.scintilla{}
node_function_text.SIZE="500x320" --I think this is not optimal! (since the size is so appears to be fixed)
--node_function_text.wordwrap="WORD" --enable wordwarp
node_function_text.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
node_function_text.FONT="Courier New, 8" --font of shown code
node_function_text.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
node_function_text.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false function true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
node_function_text.STYLEFGCOLOR0="0 0 0"      -- 0-Default
node_function_text.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
node_function_text.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
node_function_text.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
node_function_text.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
node_function_text.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
node_function_text.STYLEFGCOLOR6="160 20 180"  -- 6-String 
node_function_text.STYLEFGCOLOR7="128 0 0"    -- 7-Character
node_function_text.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
node_function_text.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
node_function_text.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--node_function_text.STYLEBOLD10="YES"
--node_function_text.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--node_function_text.STYLEITALIC10="YES"
node_function_text.MARGINWIDTH0="40"
node_function_text.value=""
node_function_label1 = iup.label{title='Funktion des Knotens: (Zum Löschen bitte Funktion auskommentieren und mindestens den Funktionsnamen lassen z.B. --functionTable["Test"] wurde gelöscht)'}--label for textfield




--open the dialog for renaming branch/leaf
dlg_node_function_rename = iup.dialog{
	iup.vbox{node_function_label1, node_function_text, iup.hbox{node_function_ok,node_function_searchtext, search_in_node_function_text}}; 
	title="Funktion des Knotens bearbeiten",
	size="600x360",
	startfocus=node_function_text,
	}

--4.3 node_function dialog end





--4.4 nodeFunctionTable dialog
--ok button
nodeFunctionTable_ok = iup.flatbutton{title = "Speichern und neu öffnen",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function nodeFunctionTable_ok:flat_action()
	--save copy of program
	os.execute('copy "' .. path .. "\\" .. thisfilename .. '" "' .. path .. "\\" .. thisfilename:gsub("%.lua","_Sicherung.lua") .. '"')
	--read the programm and store it in a Lua table
	local startWriteProgramm="yes"
	local outputfile1Table={}
	local outputfile2Table={}
	for line in io.lines(path .. "\\" .. thisfilename) do
		if line:match("%-%-nodeFunctionTable" .. '%["') then startWriteProgramm="no" end
		if startWriteProgramm=="yes" then
			outputfile1Table[#outputfile1Table+1]=line	
		elseif startWriteProgramm=="yes2" then
			outputfile2Table[#outputfile2Table+1]=line	
		end --if startWriteProgramm=="yes" then
		if line:match("--end nodeFunctionTable" .. '%["') then startWriteProgramm="yes2" end
	end --for line in io.lines(path .. "\\" .. thisfilename) do
	--save the programm stored in the Lua table outputfile1Table
	local outputfile1=io.open(path .. "\\" .. thisfilename,"w")
	for i,v in ipairs(outputfile1Table) do
		outputfile1:write(v .. "\n")
	end --for i,v in ipairs(outputfile1Table) do
	--save the nodeFunctionTable list
	outputfile1:write(nodeFunctionTable_text.value .. "\n")
	--save the rest of the program
	for i,v in ipairs(outputfile2Table) do
		outputfile1:write(v .. "\n")
	end --for i,v in ipairs(outputfile1Table) do
	outputfile1:close()
	os.execute('start "Neu" "' .. path .. "\\" .. thisfilename .. '"')
	return iup.CLOSE
end --function nodeFunctionTable_ok:flat_action()

nodeFunctionTable_searchtext = iup.multiline{border="YES",expand="YES", SELECTION="ALL",wordwrap="YES"} --textfield for search

--search nodeFunctionTable_searchtext.value in nodeFunctionTable_text
search_in_nodeFunctionTable_text   = iup.flatbutton{title = "Suche in der Zuordnung der Funktionen zu den Knoten",size="EIGHTH", BGCOLOR=color_buttons, FGCOLOR=color_button_text} 
searchPosition=1
function search_in_nodeFunctionTable_text:flat_action()
from,to=nodeFunctionTable_text.value:find(nodeFunctionTable_searchtext.value,searchPosition)
if to and from==to then searchPosition=to+1 else searchPosition=to end
if from==nil then 
searchPosition=1 
iup.Message("Suchtext in der Zuordnung der Funktionen zu den Knoten nicht gefunden",tostring(nodeFunctionTable_searchtext.value) .. " in der Zuordnung der Funktionen zu den Knoten nicht gefunden")
else
nodeFunctionTable_text.SELECTIONPOS=from-1 .. ":" .. to
end --if from==nil then 
end --	function search_in_nodeFunctionTable_text:flat_action()


--field as scintilla editor
nodeFunctionTable_text=iup.scintilla{}
nodeFunctionTable_text.SIZE="500x320" --I think this is not optimal! (since the size is so appears to be fixed)
--nodeFunctionTable_text.wordwrap="WORD" --enable wordwarp
nodeFunctionTable_text.WORDWRAPVISUALFLAGS="MARGIN" --show wrapped lines
nodeFunctionTable_text.FONT="Courier New, 8" --font of shown code
nodeFunctionTable_text.LEXERLANGUAGE="lua" --set the programming language to Lua for syntax higlighting
nodeFunctionTable_text.KEYWORDS0="for end while date time if io elseif else execute do dofile require return break and or os type string nil not next false function true gsub gmatch goto ipairs open popen pairs print" --list of keywords for syntaxhighlighting, this list is not complete and can be enlarged
--colors for syntax highlighting
nodeFunctionTable_text.STYLEFGCOLOR0="0 0 0"      -- 0-Default
nodeFunctionTable_text.STYLEFGCOLOR1="0 128 0"    -- 1-Lua comment
nodeFunctionTable_text.STYLEFGCOLOR2="0 128 0"    -- 2-Lua comment line
nodeFunctionTable_text.STYLEFGCOLOR3="0 128 0"    -- 3-JavaDoc/ Doxygen style Lua commen
nodeFunctionTable_text.STYLEFGCOLOR4="180 0 0"    -- 4-Number 
nodeFunctionTable_text.STYLEFGCOLOR5="0 0 255"    -- 5-Keywords (id=0) 
nodeFunctionTable_text.STYLEFGCOLOR6="160 20 180"  -- 6-String 
nodeFunctionTable_text.STYLEFGCOLOR7="128 0 0"    -- 7-Character
nodeFunctionTable_text.STYLEFGCOLOR8="160 20 180"  -- 8-Literal string
nodeFunctionTable_text.STYLEFGCOLOR9="0 0 255"    -- 9-Old preprocessor block (obsolete)
nodeFunctionTable_text.STYLEFGCOLOR10="128 0 0" -- 10-Operator 
--nodeFunctionTable_text.STYLEBOLD10="YES"
--nodeFunctionTable_text.STYLEFGCOLOR11="255 0 255" -- 11-Identifier (this overwrites the default color)
--nodeFunctionTable_text.STYLEITALIC10="YES"
nodeFunctionTable_text.MARGINWIDTH0="40"
nodeFunctionTable_text.value=""
nodeFunctionTable_label1 = iup.label{title="Zuordnung der Funktionen zu den Knoten:"}--label for textfield

for line in io.lines(path .. "\\" .. thisfilename) do
	if line:match('nodeFunctionTable%[".*"%]=".*%(.*%)') then
		if nodeFunctionTable_text.value=="" then
			nodeFunctionTable_text.value=line
		else
			nodeFunctionTable_text.value=nodeFunctionTable_text.value .. "\n" .. line
		end --if nodeFunctionTable_text.value=="" then
	end --if line:match("tree%['image") then
end --for line in io.lines(path .. "\\" .. thisfilename) do



--open the dialog for renaming branch/leaf
dlg_nodeFunctionTable_rename = iup.dialog{
	iup.vbox{nodeFunctionTable_label1, nodeFunctionTable_text, iup.hbox{nodeFunctionTable_ok,nodeFunctionTable_searchtext, search_in_nodeFunctionTable_text}}; 
	title="Zuordnung der Funktionen zu den Knoten bearbeiten",
	size="600x360",
	startfocus=nodeFunctionTable_text,
	}

--4.4 nodeFunctionTable dialog end


--5. context menus (menus for right mouse click)

--5.1 menu of tree
--5.1.1 copy node of tree
startcopy = iup.item {title = "Knoten kopieren"}
function startcopy:action() --copy node
	 clipboard.text = tree['title']
end --function startcopy:action()

--5.1.1.1 show node number with message
number_of_node = iup.item {title = "Nummer des Knotens anzeigen"}
function number_of_node:action() 
	 iup.Message("Die Nummer des Knotens ist:",tree.value)
end --function number_of_node:action()

--5.1.1.2 copy node image definition for inputs
copy_for_image_input = iup.item {title = "Eingabefeld für Symbol kopieren"}
function copy_for_image_input:action()
	 clipboard.text = "tree" .. "['image" .. tree.value .. "']=img_inputarrow --" .. tree['title' .. tree.value-1]
end --function copy_for_image_input:action()

--5.1.1.3 copy node image definition for functions
copy_for_image_function = iup.item {title = "Funktionsfeld für Symbol kopieren"}
function copy_for_image_function:action()
	 clipboard.text = "tree" .. "['imageexpanded" .. tree.value .. "']=img_functionarrow tree" .. "['image" .. tree.value .. "']=img_functionarrow --" .. tree['title']
end --function copy_for_image_function:action()

--5.1.1.4 copy node function definition to define the function
nodeChosen=""
define_function_of_node = iup.item {title = "Funktion definieren"}
function define_function_of_node:action()
	nodeChosen=tree['title']
	node_function_text.value=""
	local nodeFunctionWrite="no"
	--test with: print(functionTable[tree['title']])
	if functionTable[tree['title']] or nodeFunctionTable[tree['title']] then 
		--test with: iup.Message(tree['title'],nodeFunctionTable[tree['title']]) 
		--test with: iup.Message(tree['title'],tostring(functionTable[tree['title']])) 
		for line in io.lines(path .. "\\" .. thisfilename) do
			treeTitleMatch=tree['title']:gsub("%[","%%["):gsub("%]","%%]"):gsub("%(","%%("):gsub("%)","%%)"):gsub("%-","%%-"):gsub("%*","%%*"):gsub("%+","%%+")
			if line:match('^functionTable%["' .. treeTitleMatch .. '"%]=function%(.*%)') or line:match("^function " .. tostring(nodeFunctionTable[tree['title']]) .. "%(.*%)") then nodeFunctionWrite="yes" end
			if nodeFunctionWrite=="yes" then 
				if node_function_text.value=="" then 
					node_function_text.value=line 
				else
					node_function_text.value=node_function_text.value .. "\n" .. line 
				end --if node_function_text.value=="" then 
			end --if nodeFunctionWrite=="yes" then 
			if line:match('^end %-%-functionTable%["' .. treeTitleMatch .. '"%]=function%(.*%)') or line:match("^end %-%-function " .. tostring(nodeFunctionTable[tree['title']]) .. "%(.*%)") then nodeFunctionWrite="no" end
		end --for line in io.lines(path .. "\\" .. thisfilename) do
		dlg_node_function_rename:showxy(iup.RIGHT,iup.CENTER)
	else
		node_function_text.value='functionTable["' .. tree['title'] .. '"]=function()\n--Bitte die neue Funktion eingeben\nend --functionTable["' .. tree['title'] .. '"]=function()'
		dlg_node_function_rename:showxy(iup.RIGHT,iup.CENTER)
	end --	if functionTable[tree['title']] or nodeFunctionTable[tree['title']] then 
end --function define_function_of_node:action()

--5.1.1.5 copy node image definition for outputs
copy_for_image_output = iup.item {title = "Ausgabefeld für Symbol kopieren"}
function copy_for_image_output:action() --copy node
	 clipboard.text = "tree" .. "['image" .. tree.value .. "']=img_rightarrow --" .. tree['title' .. tree.value-1] 
end --function copy_for_image_output:action()

--5.1.2 rename node and rename action for other needs of tree
renamenode = iup.item {title = "Knoten bearbeiten"}
function renamenode:action()
	text.value = tree['title']
	dlg_rename:showxy(iup.CENTER, iup.CENTER) --popup rename dialog
	iup.SetFocus(dlg_rename)
	--test with: for i=tree.count,tonumber(tree.value),-1 do print(i,i+text_NumberOfNodesMore.value) end
end --function renamenode:action()

--5.1.3 add branch to tree
addbranch = iup.item {title = "Ast hinzufügen"}
function addbranch:action()
	tree.addbranch = ""
	tree.value=tree.value+1
	text_NumberOfNodesMore.value=1
	renamenode:action()
end --function addbranch:action()

--5.1.3.1 add branch to tree by insertbranch
addbranchbottom = iup.item {title = "Ast darunter hinzufügen"}
function addbranchbottom:action()
	tree["insertbranch" .. tree.value] = ""
	for i=tree.value+1,tree.count-1 do
		if tree["depth" .. i]==tree["depth" .. tree.value] then
			tree.value=i
			text_NumberOfNodesMore.value=1
			renamenode:action()
			break
		end --if tree["depth" .. tree.value+1]==tree["depth" .. tree.value] then
	end --for i=tree.value+1,tree.count-1 do
end --function addbranchbottom:action()

--5.1.3.2 add leaf to tree by insertleaf
addleafbottom = iup.item {title = "Blatt darunter hinzufügen"}
function addleafbottom:action()
	tree["insertleaf" .. tree.value] = ""
	for i=tree.value+1,tree.count-1 do
		if tree["depth" .. i]==tree["depth" .. tree.value] then
			tree.value=i
			text_NumberOfNodesMore.value=1
			renamenode:action()
			break
		end --if tree["depth" .. tree.value+1]==tree["depth" .. tree.value] then
	end --for i=tree.value+1,tree.count-1 do
end --function addleafbottom:action()

--5.1.4 add leaf of tree
addleaf = iup.item {title = "Blatt hinzufügen"}
function addleaf:action()
	tree.addleaf = ""
	tree.value=tree.value+1
	text_NumberOfNodesMore.value=1
	renamenode:action()
end --function addleaf:action()


--5.1.5 copy a version of the file selected in the tree and give it the next version number
startversion = iup.item {title = "Version archivieren"}
function startversion:action()
	--get the version of the file
	if tree['title']:match(".:\\.*%.[^\\]+") then
		Version=0
		p=io.popen('dir "' .. tree['title']:gsub("(%.+)","_Version*%1") .. '" /b/o')
		for Datei in p:lines() do 
			--test with: iup.Message("Version",Datei) 
			if Datei:match("_Version(%d+)") then Version_alt=Version Version=tonumber(Datei:match("_Version(%d+)")) if Version<Version_alt then Version=Version_alt end end
			--test with: iup.Message("Version",Version) 
		end --for Datei in p:lines() do 
		--test with: iup.Message(Version,Version+1)
		Version=Version+1
		iup.Message("Archivieren der Version:",tree['title']:gsub("(%.+)","_Version" .. Version .. "%1"))
		os.execute('copy "' .. tree['title'] .. '" "' .. tree['title']:gsub("(%.+)","_Version" .. Version .. "%1") .. '"')
	end --if tree['title']:match(".:\\.*%.[^\\]+") then
end --function startversion:action()

--5.1.6 start file of node of tree in IUP Lua scripter or start empty file in notepad or start empty scripter
startnodescripter = iup.item {title = "Skripter starten"}
function startnodescripter:action()
	--read first line of file. If it is empty then scripter cannot open it. So open file with notepad.exe
	if file_exists(tree['title']) then inputfile=io.open(tree['title'],"r") ErsteZeile=inputfile:read() inputfile:close() end
	if file_exists(tree['title']) and ErsteZeile then 
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. tree['title'] .. '"')
	elseif file_exists(tree['title']) then 
		os.execute('start "d" notepad.exe "' .. tree['title'] .. '"')
	else
		os.execute('start "d" C:\\Lua\\iupluascripter54.exe ')
	end --if file_exists(tree['title']) and ErsteZeile then 
end --function startnodescripter:action()


--5.1.7 start the file or repository of the node of tree
startnode = iup.item {title = "Starten"}
function startnode:action() 
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
		os.execute('start "D" "' .. tree['title'] .. '"') 
	elseif tree['title']:match("sftp .*") then 
		os.execute(tree['title']) 
	end --if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then 
end --function startnode:action()

--5.1.8 put the menu items together in the menu for tree
menu = iup.menu{
		startcopy,  --to be deactivated
		number_of_node,  --to be deactivated
		copy_for_image_input,  --to be deactivated
		copy_for_image_function,  --to be deactivated
		define_function_of_node,  --to be deactivated
		copy_for_image_output,  --to be deactivated
		renamenode,   --to be deactivated
		addbranch,  --to be deactivated
		addbranchbottom,    --to be deactivated
		addleaf,  --to be deactivated
		addleafbottom,  --to be deactivated
		startversion,
		startnodescripter,
		startnode, 
		}
--5.1 menu of tree end


--6 buttons
--6.1 logo image definition and button with logo
img_logo = iup.image{
  { 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 },
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,1,1,1,1,3,3,1,1,3,3,3,1,1,1,1,1,3,1,1,1,3,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,1,1,1,1,3,3,1,1,3,1,1,3,1,1,1,1,3,1,1,3,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,3,3,3,3,1,1,1,1,1,3,1,1,3,1,1,1,1,3,1,3,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,3,3,3,4,4,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,3,3,3,3,4,4,3,3,1,1,1,3,1,1,1,3,1,1,1,3,1,3,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,3,3,3,3,3,3,3,3,1,1,1,3,1,1,1,3,1,1,1,3,1,1,3,1,1,1,1,1,4,4,4 },
  { 4,1,1,3,3,3,3,3,3,3,3,1,1,1,3,3,3,3,1,1,3,1,3,1,1,1,3,1,3,1,1,4,4,4 },
  { 4,1,1,1,3,3,3,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,3,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,1,3,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,3,1,3,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,1,1,1,1,3,1,3,3,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,3,3,1,3,1,3,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,1,1,1,1,1,4,4,4,4,4,4,4,1,1,3,3,1,3,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,1,1,1,4,4,4,4,4,3,3,4,4,4,4,1,3,3,1,1,1,1,1,1,1,4,4,4,4 },
  { 4,1,1,1,1,1,1,1,4,4,4,4,3,3,3,3,3,3,4,4,4,3,1,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,1,4,4,4,4,4,3,3,3,3,3,3,3,3,3,4,3,4,1,1,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,1,1,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,1,1,1,1,1,1,4,4,4 },
  { 4,1,1,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,1,1,1,1,1,4,4,4 },
  { 4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,1,1,1,4,4,4 },
  { 4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,1,1,4,4,4 },
  { 4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,4,4,4 },
  { 4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4 },
  { 4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4 },
  { 4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4 },
  { 4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3 },
  { 4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4 },
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4 },
  { 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 },
  { 3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 },
  { 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4 }
  ; colors = { "255 255 255", color_light_color_grey, color_blue, "255 255 255" }
}
button_logo=iup.button{image=img_logo,title="", size="23x20"}
function button_logo:action()
	iup.Message("Dr. Bruno Kaiser","Lizenz Open Source\nidiv.kaiser@t-online.de")
end --function button_logo:flat_action()

--6.2 button to edit in IUP Lua scripter the script for tree2
button_edit_treescript=iup.flatbutton{title="Programmieren des \ngesamten Programms", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_treescript:flat_action()
	os.execute('start "d" C:\\Lua\\iupluascripter54.exe "' .. path .. '\\' .. thisfilename .. '"')
end --function button_edit_treescript:flat_action()

--6.3 button to edit the icon definition list
button_edit_icon_list=iup.flatbutton{title="Programmieren der \nSymbole", size="75x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_icon_list:flat_action()
	dlg_icon_rename:showxy(iup.RIGHT, iup.CENTER) --show rename dialog
end --function button_edit_icon_list:flat_action()


--6.4 button to edit the relation table for node to function
button_edit_nodeFunctionTable=iup.flatbutton{title="Programmieren der \nFunktionszuordnung zu den Knoten", size="135x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_edit_nodeFunctionTable:flat_action()
	dlg_nodeFunctionTable_rename:showxy(iup.RIGHT, iup.CENTER) --show rename dialog
end --function button_edit_nodeFunctionTable:flat_action()

--6.5 button to save version without buttons and menus to be fixed calculation
button_save_fixed_calculation=iup.flatbutton{title="Speichern einer\nfixierten Version", size="85x20", BGCOLOR=color_buttons, FGCOLOR=color_button_text}
function button_save_fixed_calculation:flat_action()
	--open a filedialog
	filedlg1=iup.filedlg{dialogtype="SAVE",title="Ziel auswählen",filter="*.lua",filterinfo="Lua Files", directory=path}
	filedlg1:popup(iup.ANYWHERE,iup.ANYWHERE)
	if filedlg1.status=="1" or filedlg1.status=="0" then
		local outputfile=io.output(filedlg1.value) --setting the outputfile
		for line in io.lines(path .. "\\" .. thisfilename) do
			if line:match("%-%-to be deactivated") then
				outputfile:write("--deactivated: " .. line .. "\n")
			elseif line:match("%-%-%[%[to be deactivated%]%]") then
				outputfile:write("--[====[deactivated: " .. line .. "\n")
			elseif line:match("%-%-%[%[to be deactivated end%]%]") then
				outputfile:write(line .. "\n--deactivated end]====]\n")
			else
				outputfile:write(line .. "\n")
			end --if line:match("%-%-to be deactivated") then
		end --for line in io.lines(path .. "\\" .. thisfilename) do
		outputfile:close() --close the outputfile
	else --no outputfile was choosen
		iup.Message("Schließen","Keine Datei ausgewählt")
		iup.NextField(maindlg)
	end --if filedlg1.status=="1" or filedlg1.status=="0" then
end --function button_save_fixed_calculation:flat_action()


--7 Main Dialog
--7.1 icon definitions
img_functionarrow= iup.image{
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,2,1,1,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,2,2,1,1,2,2,1,1,1,1,1 }, 
  { 1,1,1,1,2,2,1,1,1,1,2,2,1,1,1,1 }, 
  { 1,1,1,1,2,2,1,1,1,1,2,2,1,1,1,1 },  
  { 1,1,1,1,2,2,1,1,1,1,2,2,1,1,1,1 },
  { 1,1,1,1,2,2,1,1,1,1,2,2,1,1,1,1 }, 
  { 1,1,1,1,2,2,1,1,1,1,2,2,1,1,1,1 }, 
  { 1,1,1,1,2,2,1,1,1,1,2,2,1,1,1,1 },  
  { 1,1,1,1,1,2,2,1,1,2,2,1,1,1,1,1 },
  { 1,1,1,1,1,1,2,1,1,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
   
  -- Sets "X" image colors
  ; colors = { color_background_tree, color_red}
}
img_inputarrow= iup.image{
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,2,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,2,2,2,2,2,2,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,2,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,2,2,2,2,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,2,2,2,2,1,1,1,1,1,1 },
  { 1,1,1,1,1,1,2,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,2,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,2,2,2,2,1,1,1,1,1,1 },  
  { 1,1,1,1,1,2,2,2,2,2,2,1,1,1,1,1 },
  { 1,1,1,1,1,1,2,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
   
  -- Sets "X" image colors
  ; colors = { color_background_tree, color_red}
}
img_rightarrow= iup.image{
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,2,2,2,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,2,2,2,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,2,2,2,1,1,1 },  
  { 1,1,2,2,2,2,2,2,2,2,2,2,2,2,1,1 },
  { 1,1,2,2,2,2,2,2,2,2,2,2,2,2,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,2,2,2,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,2,2,2,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,2,2,2,1,1,1,1,1 },
  { 1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,1 }, 
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 },  
  { 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }
   
  -- Sets "X" image colors
  ; colors = { color_background_tree, color_red}
}

--7.2 build tree
tree=iup.tree{
map_cb=function(self)
self:AddNodes(actualtree)
end, --function(self)
SIZE="10x200",
showrename="YES",--F2 key active
markmode="SINGLE",--for Drag & Drop SINGLE not MULTIPLE
--showdragdrop="YES",
}
-- Callback for pressed keys
function tree:k_any(c)
	if c == iup.K_DEL then
--[[to be deactivated]]
		if tree.childcount=="0" then
			local treeValue=tree.value
			--test with: print(tree.value)
			--save copy of program
			os.execute('copy "' .. path .. "\\" .. thisfilename .. '" "' .. path .. "\\" .. thisfilename:gsub("%.lua","_Sicherung.lua") .. '"')
			--test with: iup.Message(tree.childcount,tree.childcount)
			tree.delnode = "SELECTED"
			--test with: iup.Message(tree.count,tree.value)
			--store the programm in the Lua table outputfile1Table
			local startWriteProgramm="no"
			local outputfile1Table={}
			for line in io.lines(path .. "\\" .. thisfilename) do
			--test with: print(tree.value)
				if startWriteProgramm=="yes" then
					local digitTable={}
					for field in line:gmatch("tree%['[^%d]+%d+'%]") do
						digitTable[#digitTable+1]=field
					end --for field in line:gmatch("tree%['[^%d]+%d+'%]") do
					table.sort(digitTable,function(a,b) local ad=tonumber(a:match("%d+")) bd=tonumber(b:match("%d+")) return ad<bd end)
					for i,v in ipairs(digitTable) do
						local vMatch=v:gsub("%[","%%["):gsub("%]","%%]"):gsub("%(","%%("):gsub("%)","%%)"):gsub("%-","%%-"):gsub("%*","%%*"):gsub("%+","%%+")
						--test with: print(i,v)
						local treeType,digitText=v:match("'([^%d]+)(%d+)'")
						--test with: print(treeType,digitText)
						--test with: print(treeValue,digitText)
						if tonumber(digitText)>tonumber(treeValue) then
						--test with: print(line) print(vMatch)
							line=line:gsub(vMatch,"tree['" .. treeType .. math.tointeger(tonumber(digitText-1)) .. "']")
						--test with: print("tree['" .. treeType .. math.tointeger(tonumber(digitText-1)) .. "']") print(line)
						elseif digitText==treeValue then
						--test with: print(line) print(vMatch)
							line=line:gsub(vMatch,"tree['" .. treeType .. digitText .. "xxx']")
						--test with: print("tree['" .. treeType .. math.tointeger(tonumber(digitText-1)) .. "']") print(line)
						end --if tonumber(digitText)>=tonumber(treeValue) then
					end --for i,v in ipairs(digitTable) d
					outputfile1Table[#outputfile1Table+1]=line	
				end --if startWriteProgramm=="yes" then
				if line:match("%-%-actualtree" .. "=") then startWriteProgramm="yes" end
			end --for line in io.lines(path .. "\\" .. thisfilename) do
			--save the tree
			save_tree_to_lua(tree, path .. "\\" .. thisfilename)
			--save the programm stored in the Lua table outputfile1Table
			local outputfile1=io.open(path .. "\\" .. thisfilename,"a")
			for i,v in ipairs(outputfile1Table) do
				outputfile1:write(v .. "\n")
			end --for i,v in ipairs(outputfile1Table) do
			outputfile1:close()
		end --if tree.childcount=="0" then
		os.execute('start "Neu" "' .. path .. "\\" .. thisfilename .. '"')
		return iup.CLOSE
--[[to be deactivated end]]
	elseif c == iup.K_cC then
		--copy node of tree
		clipboard.text = tree['title']
	elseif c == iup.K_Menu then
		menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if c == iup.K_DEL then
end --function tree:k_any(c)
-- Callback for right click preparing by node function table
--nodeFunctionTablefunction table --nodeFunctionTable["node name"]="name_of_the_function()"
nodeFunctionTable={} --nodeFunctionTable["Knotentext eingeben"]="Name_der_Funktion()"
nodeFunctionTable["Ausgabe"]="Schaltjahr()"
nodeFunctionTable["Anzahl Tage Zähler 30 und Nenner 360"]="Anzahltage30zaehler()"
nodeFunctionTable["Anzahl Tage Zähler 30ISDA und Nenner 360"]="Anzahltage30ISDAzaehler()"
nodeFunctionTable["Anzahl Tage Zähler 30E und Nenner 360"]="Anzahltage30Ezaehler()"
nodeFunctionTable["Anzahl Tage Zähler 30E+ und Nenner 360"]="Anzahltage30EPluszaehler()"
nodeFunctionTable["Anzahl Tage Zähler 30German und Nenner 360"]="Anzahltage30Germanzaehler()"
nodeFunctionTable["Anzahl Tage Zähler 30US und Nenner 360"]="Anzahltage30USzaehler()"
nodeFunctionTable["Anzahl Tage Zähler actual und Nenner für actual im Weiteren Knoten bestimmen"]="Anzahltagezaehler()"
nodeFunctionTable["Nenner actual 365.25 1/1"]="Nenneractual36525()"
nodeFunctionTable["Nenner actual 366"]="Nenneractual366()"
nodeFunctionTable["Nenner actual 365"]="Nenneractual365()"
nodeFunctionTable["Nenner actual 364"]="Nenneractual364()"
nodeFunctionTable["Nenner actual 360"]="Nenneractual360()"
nodeFunctionTable["Jahre manuell setzen"]="JahreManuellSetzen()"
nodeFunctionTable["Kapital und Zinssatz eintragen"]="KapitalZinssatzSchreiben()" 
nodeFunctionTable["Alle Zinsen mit Titel ausgeben"]="ZinsenTitelAlle()"
nodeFunctionTable["Titel"]="TitelErgaenzen()"
nodeFunctionTable["Zinsen linear = Kapital * Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner"]="Zinsen()"
nodeFunctionTable["Zinsen mit Zinseszinsen = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner)-1)"]="Zinseszinsen()"
nodeFunctionTable["Zinsen stetig verzinst = Kapital * (e^(Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner) -1)"]="Zinsenstetig()"
nodeFunctionTable["Alle Zinsen mit Titel in eine Datei ausgeben"]="ZinsErgebnisAlleZeilenAusgabe()"
nodeFunctionTable["Zurücksetzen"]="KapitalZinssatzZuruecksetzen()"
--end nodeFunctionTable["node name"]="name_of_the_function()"
--Callback for right click
function tree:rightclick_cb(id)
	if nodeFunctionTable[tree['title']] then load(nodeFunctionTable[tree['title']])() 
	elseif functionTable[tree['title']] then functionTable[tree['title']]()                  --test with: print(tree['title'])
	else                                                                                                       menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if tree['title']=="Berechnen" then
end --function tree:rightclick_cb(id)


--7.3 building the dialog and put buttons, trees and preview together
maindlg = iup.dialog {
		iup.scrollbox{iup.vbox{
			iup.hbox{
				button_logo,
				button_edit_treescript,        --to be deactivated
				button_edit_icon_list,         --to be deactivated
				button_edit_nodeFunctionTable, --to be deactivated
				button_save_fixed_calculation, --to be deactivated
				},
			iup.frame{title="Zinsrechner",
			tree,
			size="FULLxFULL"},
		},}, --iup.scrollbox{iup.vbox{
	icon = img_logo,
	size="HALFxFULL", --"FULLxFULL",
	--gap="3",
	--alignment="ARIGHT",
	--margin="5x5" 
}--maindlg = iup.dialog {

--7.4 show the dialog
maindlg:showxy(iup.LEFT,iup.CENTER) 


--7.5 icons adopted in tree
--default image for branch collapsed can be defined by: tree.imagebranchcollapsed=img_rightarrow

--tree['image... default image for branch expanded
--tree['image... image for branches with functions
tree['imageexpanded4']=img_functionarrow   --Berechnen                                                                      Rechner()
tree['imageexpanded9']=img_functionarrow   --Ausgabe                                                                        Schaltjahr()
tree['imageexpanded23']=img_functionarrow tree['image23']=img_functionarrow --Schalttage im Zins-Intervall bestimmen
tree['imageexpanded32']=img_functionarrow  --Anzahl Tage Zähler 30 und Nenner 360                                           Anzahltage30zaehler()
tree['imageexpanded38']=img_functionarrow  --Anzahl Tage Zähler 30ISDA und Nenner 360                                       Anzahltage30ISDAzaehler()
tree['imageexpanded44']=img_functionarrow  --Anzahl Tage Zähler 30E und Nenner 360                                          Anzahltage30Ezaehler()
tree['imageexpanded54']=img_functionarrow  --Anzahl Tage Zähler 30E+ und Nenner 360                                         Anzahltage30EPluszaehler()
tree['imageexpanded60']=img_functionarrow  --Anzahl Tage Zähler 30German und Nenner 360                                     Anzahltage30Germanzaehler()
tree['imageexpanded68']=img_functionarrow  --Anzahl Tage Zähler 30US und Nenner 360                                         Anzahltage30USzaehler()
tree['imageexpanded71']=img_functionarrow  --Anzahl Tage Zähler actual und Nenner für actual im Weiteren Knoten bestimmen   Anzahltagezaehler()
tree['imageexpanded81']=img_functionarrow  --Nenner actual 365.25 1/1                                                       Nenneractual36525()
tree['imageexpanded85']=img_functionarrow  --Nenner actual 366                                                              Nenneractual366()
tree['imageexpanded91']=img_functionarrow  --Nenner actual 365                                                              Nenneractual365()
tree['imageexpanded96']=img_functionarrow  --Nenner actual 364                                                              Nenneractual364()
tree['imageexpanded102']=img_functionarrow --Nenner actual 360                                                              Nenneractual360()
tree['imageexpanded108']=img_functionarrow --Jahre manuell setzen                                                           JahreManuellSetzen()
tree['image108']=img_functionarrow         --Jahre manuell setzen                                                           JahreManuellSetzen()
tree['imageexpanded114']=img_functionarrow --Kapital und Zinssatz eintragen                                                 KapitalZinssatzSchreiben()
tree['imageexpanded115']=img_functionarrow --Alle Zinsen mit Titel ausgeben                                                 ZinsenTitelAlle()
tree['imageexpanded116']=img_functionarrow --Titel                                                                          TitelErgaenzen()
tree['imageexpanded118']=img_functionarrow --Zinsen linear = Kapital * Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner                                                                  Zinsen()
tree['imageexpanded120']=img_functionarrow --Zinsen mit Zinseszinsen = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner)-1)                                                        Zinseszinsen()
tree['imageexpanded124']=img_functionarrow tree['image124']=img_functionarrow --Zinsen mit Zinseszinsen unterjährig = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner * Anzahl_Zinsperioden_im_Jahr)-1)
tree['imageexpanded126']=img_functionarrow --Zinsen stetig verzinst = Kapital * (e^(Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner) -1)                                                         Zinsenstetig()
tree['imageexpanded128']=img_functionarrow --Alle Zinsen mit Titel in eine Datei ausgeben                                   ZinsErgebnisAlleZeilenAusgabe()
tree['imageexpanded130']=img_functionarrow --Zurücksetzen                                                                   KapitalZinssatzZuruecksetzen()
tree['image130']=img_functionarrow --Zurücksetzen                                                                           KapitalZinssatzZuruecksetzen()
--tree['image... input and output nodes
tree['image3']=img_inputarrow   --document.Formular.Eingabe.value
tree['image5']=img_rightarrow   --document.Formular.Ergebnis.value
tree['image8']=img_inputarrow   --document.Formular1.Eingabe3.value
tree['image10']=img_rightarrow  --document.Formular1.ErgebnisSchaltjahr.value
tree['image13']=img_inputarrow  --document.FormularZins.Kapital.value
tree['image14']=img_inputarrow  --document.FormularZins.Zinssatz.value
tree['image16']=img_inputarrow  --document.FormularZins.Startmonat.value
tree['image18']=img_inputarrow  --document.FormularZins.ManuellLastDayFebruary1.value
tree['image20']=img_inputarrow  --document.FormularZins.Endemonat.value
tree['image22']=img_inputarrow  --document.FormularZins.ManuellLastDayFebruary2.value
tree['image24']=img_rightarrow --Schalttage im Zins-Intervall bestimmen
tree['image33']=img_rightarrow  --document.FormularZins.Anzahltage30.value
tree['image39']=img_rightarrow  --document.FormularZins.Anzahltage30ISDA.value
tree['image45']=img_rightarrow  --document.FormularZins.Anzahltage30E.value
tree['image51']=img_inputarrow  --document.FormularZins.EndejahrPlus.value
tree['image52']=img_inputarrow  --document.FormularZins.EndemonatPlus.value
tree['image53']=img_inputarrow  --document.FormularZins.EndetagPlus.value
tree['image55']=img_rightarrow  --document.FormularZins.Anzahltage30EPlus.value
tree['image61']=img_rightarrow  --document.FormularZins.Anzahltage30German.value
tree['image69']=img_rightarrow  --document.FormularZins.Anzahltage30US.value
tree['image72']=img_rightarrow  --document.FormularZins.Anzahltageactual.value 
tree['image74']=img_inputarrow  --document.FormularZins.AnzahltageNoLeap.value
tree['image76']=img_rightarrow  --document.FormularZins.AnzahlTageZaehler.value
tree['image82']=img_rightarrow  --document.FormularZins.Nenner36525.value
tree['image86']=img_rightarrow  --document.FormularZins.Nenner366.value
tree['image92']=img_rightarrow  --document.FormularZins.Nenner365.value
tree['image97']=img_rightarrow  --document.FormularZins.Nenner364.value
tree['image103']=img_rightarrow --document.FormularZins.Nenner360.value
tree['image105']=img_rightarrow --document.FormularZins.AnzahlTageNenner.value
tree['image107']=img_inputarrow --document.FormularZins.JahreManuelleEingabe.value
tree['image110']=img_rightarrow --document.FormularZins.Jahre.value
tree['image112']=img_rightarrow --document.FormularZins.Methode.value
tree['image117']=img_rightarrow --document.FormularZins.Titel.value
tree['image119']=img_rightarrow --document.FormularZins.Zins.value
tree['image121']=img_rightarrow --document.FormularZins.Zinszins.value
tree['image123']=img_inputarrow --Anzahl unterjähriger Zinsperioden
tree['image125']=img_rightarrow --Zinsen mit Zinseszinsen unterjährig = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner * Anzahl_Zinsperioden_im_Jahr)-1)
tree['image129']=img_rightarrow --Alle Zinsen mit Titel in eine Datei ausgeben
tree['image127']=img_rightarrow --document.FormularZins.Zinsstetig.value


--7.6 Main Loop
if (iup.MainLoopLevel()==0) then iup.MainLoop() end
