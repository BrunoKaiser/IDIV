--1. tree as Lua table
actualtree={branchname="Zinsrechner", --0
{branchname="1. Allgemeiner Rechner", state="COLLAPSED",  --1
"Geben Sie eine Rechenaufgabe ein, z.B. 5+7:", --2
"10000*0.03",            --3: document.Formular.Eingabe.value
{branchname="Berechnen", --4: onclick="Rechner()"
"",                      --5: document.Formular.Ergebnis.value
}, --{branchname="Berechnen",
}, --{branchname="1. Allgemeiner Rechner",
{branchname="2. Schaltjahrberechnung", state="COLLAPSED", --6
"Geben Sie ein Jahr zwischen 1900 und 2999 ein:",         --7
os.date("%Y"),           --8: document.Formular1.Eingabe3.value
{branchname="Ausgabe",   --9: onclick="Schaltjahr()"
"",                      --10: document.Formular1.ErgebnisSchaltjahr.value
}, --{branchname="Ausgabe",
}, --{branchname="2. Schaltjahrberechnung",




{branchname="3. Zinsberechnung",       --11
"Geben Sie Kapital und Zinssatz ein:", --12
"10000",                               --13: document.FormularZins.Kapital.value
"0.3",                                 --14: document.FormularZins.Zinssatz.value

{branchname="Startdatum:", state="COLLAPSED", --15
"2012",                      --16: document.FormularZins.Startjahr.value
"2",                         --17: document.FormularZins.Startmonat.value
"1",                         --18: document.FormularZins.Starttag.value
{branchname="Startdatum ist Last of day February", --19
"nein",                      --20: document.FormularZins.ManuellLastDayFebruary1.value
}, --{branchname="Startdatum ist Last of day February",
}, --{branchname="Startdatum:",

{branchname="Endedatum:", state="COLLAPSED", --21
"2013",                      --22: document.FormularZins.Endejahr.value
"5",                         --23: document.FormularZins.Endemonat.value
"31",                        --24: document.FormularZins.Endetag.value
{branchname="Endedatum ist Last day of February",  --25
"nein",                      --26: document.FormularZins.ManuellLastDayFebruary2.value
}, --{branchname="Endedatum ist Last day of February",
}, --{branchname="Endedatum:",




{branchname="Anzahl Tage im Zähler bestimmen und soweit schon möglich im Nenner, sonst weitere Knoten verwenden", --27
{branchname="Tageskonventionen für 360 Tage mit der Formel",  state="COLLAPSED",--28
{branchname="Tage = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)", --29
{branchname="30/360 Bond Basis, 30A/360:", state="COLLAPSED",  --30
"This convention is exactly as 30U/360 below, except for the first two rules. Note that the order of calculations is important:",  --31
"D1 = MIN (D1, 30).If D1 = 30 Then D2 = MIN (D2,30)", --32
"Sources: ISDA 2006 Section 4.16(f), though the first two rules are not included. 'ISDA Definitions, Section 4.16'. 2006. Retrieved2014-09-18.", --33
}, --{branchname="30/360 Bond Basis, 30A/360:",
{branchname="Anzahl Tage Zähler 30 und Nenner 360", --onclick="Anzahltage30zaehler()" --34
"", --35: document.FormularZins.Anzahltage30.value
}, --{branchname="Anzahl Tage Zähler 30 und Nenner 360",

{branchname="30/360 ISDA:", state="COLLAPSED", --36
"Regel 1: If D1 is 31, then change D1 to 30.", --37
"Regel 2 If D1 = 30 after applying Regel 1 and D2 =31 then change D2 to 30.", --38
"Sources: alternate names of day conventions.", --39
}, --{branchname="30/360 ISDA:",
{branchname="Anzahl Tage Zähler 30ISDA und Nenner 360", --onclick="Anzahltage30ISDAzaehler()" --40
"" --41: document.FormularZins.Anzahltage30ISDA.value
}, --"",
 
{branchname="30E/360, 30/360 ICMA, 30S/360, Eurobond basis (ISDA 2006), Special German (spezielle deutsche Zinsmethode):", state="COLLAPSED", --42
"Regel 1: If D1 is 31, then change D1 to 30.", --43
"Regel 2 If D2 is 31, then change D2 to 30.", --44
"Sources: 'ICMA Rule Book, Rule 251'. Retrieved 2014-09-18. ICMA Rule 251.1(ii), 251.2. 'ISDA Definitions, Section 4.16'. 2006. Retrieved 2014-09-18. ISDA 2006 Section 4.16(g).", --45
}, --{branchname="30E/360, 30/360 ICMA, 30S/360, Eurobond basis (ISDA 2006), Special German (spezielle deutsche Zinsmethode):",
{branchname="Anzahl Tage Zähler 30E und Nenner 360", --onclick="Anzahltage30Ezaehler()" --46
"" --47: document.FormularZins.Anzahltage30E.value
}, --{branchname="Anzahl Tage Zähler 30E und Nenner 360",



{branchname="30E+/360:", state="COLLAPSED", --48
"Regel 1: If D1 is 31, then change D1 to 30.", --49
"Regel 2 If D2 is 31, set D2.M2.Y2 to 1st day of the next month.", --50
"Sources: alternate names of day conventions.", --51
}, --{branchname="30E+/360:",
{branchname="Zum Endedatum 1. des Folgemonats für Regel 30E+:", --52
"2013", --53: document.FormularZins.EndejahrPlus.value
"6",    --54: document.FormularZins.EndemonatPlus.value
"1",   --55: document.FormularZins.EndetagPlus.value
}, --{branchname="Zum Endedatum 1. des Folgemonats für Regel 30E+:",
{branchname="Anzahl Tage Zähler 30E+ und Nenner 360", --onclick="Anzahltage30EPluszaehler()" --56
"" --57: document.FormularZins.Anzahltage30EPlus.value
}, --{branchname="Anzahl Tage Zähler 30E+ und Nenner 360",


{branchname="30/360 German (spezielle deutsche Zinsmethode siehe oben):", state="COLLAPSED", --58
"Regel 1: If D1 and/or D2 is 31, then change D1 to 30 and/or D2 to 30.", --59
"Regel 2 If D1.M1.Y1 and/or D2.M2.Y2 = last day of february =1.3.-1 Tag then change D1 to 30 and/or D2 to 30.", --60
"Sources: alternate names of day conventions.", --61
}, --{branchname="30/360 German (spezielle deutsche Zinsmethode siehe oben):",
{branchname="Anzahl Tage Zähler 30German und Nenner 360", --onclick="Anzahltage30Germanzaehler()" --62
"" --63: document.FormularZins.Anzahltage30German.value
}, --{branchname="Anzahl Tage Zähler 30German und Nenner 360",

{branchname="30/360 US:", state="COLLAPSED", --64
"Regel 1: If D2.M2.Y2 ist the last day of February (28 ohne Schaltjahr und 29 im Schaltjahr) and D1.M1.Y1 ist the last day of February then D2 = 30", --65
"Regel 2: If D1.M1.Y1 ist the last day of February (28 ohne Schaltjahr und 29 im Schaltjahr) then D1 = 30", --66
"Regel 3: If D2 is 31 and D1=30 or D1=31, then change D2 to 30.", --67
"Regel 4: If D1 is 31, then change D1 to 30.", --68
"Sources: alternate names of day conventions.", --69
}, --{branchname="30/360 US:",
{branchname="Anzahl Tage Zähler 30US und Nenner 360", --onclick="Anzahltage30USzaehler()" --70
"" --71: document.FormularZins.Anzahltage30US.value 
}, --{branchname="Anzahl Tage Zähler 30US und Nenner 360",

}, --{branchname="Tage = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)",
}, --{branchname="Tageskonventionen für 360 Tage mit der Formel",



{branchname="Tageskonventionen actual mit der exakten Anzahl Tage im Zähler und Nenner für actual im Weiteren Knoten bestimmen", state="COLLAPSED", --72
{branchname="Anzahl Tage Zähler actual und Nenner für actual im Weiteren Knoten bestimmen", --onclick="Anzahltagezaehler()" --73
"", --74: document.FormularZins.Anzahltageactual.value 
{branchname="Für die no leap year abgezogene Tage im Zähler bei der Methode NL/365", --75
"0", --76: document.FormularZins.AnzahltageNoLeap.value
}, --{branchname="Für die no leap year abgezogene Tage im Zähler bei der Methode NL/365"
}, --{branchname="Anzahl Tage Zähler actual und Nenner für actual im Weiteren Knoten bestimmen",
}, --{branchname="Tageskonventionen actual mit der exakten Anzahl Tage im Zähler und Nenner für actual im Weiteren Knoten bestimmen"

{branchname="Für die Rechnung benutzte Tage im Zähler", --77
"", --78: document.FormularZins.AnzahlTageZaehler.value
{branchname="Nenner bestimmen für Tageskonventionen actual mit der exakten Anzahl Tage", state="COLLAPSED", --79

{branchname="actual 365.25 1/1:", state="COLLAPSED", --80
"This is used for inflation instruments and divides the overall 4 year period distributing the additional day across all 4 years i.e. giving 365.25 days to each year.", --81
"Sources: 'ISDA Definitions, Section 4.16'. 2006. Retrieved2014-09-18. ISDA 2006 Section 4.16(a). 'FBF Master Agreement for Financial Transactions, Supplement to the Derivatives Annex, Edition 2004'. 2004. Retrieved 2014-09-18. FBF Master Agreement for Financial Transactions, Supplement to the Derivatives Annex, Edition 2004, section 7a.", --82
}, --{branchname="actual 365.25 1/1:",
{branchname="Nenner actual 365.25 1/1", --onclick="Nenneractual36525()" --83
"", --84: document.FormularZins.Nenner36525.value
}, --{branchname="Nenner actual 365.25 1/1",


{branchname="actual 366:", state="COLLAPSED", --85
"Für Schaltjahre oder Act/365A für gesamte Periode, falls Schalttag vorhanden oder Act/365L falls Endedatum im Schaltjahr" --86
}, --{branchname="actual 365.25 1/1:",
{branchname="Nenner actual 366", --onclick="Nenneractual366()" --87
"", --88: document.FormularZins.Nenner366.value
}, --{branchname="Nenner actual 366",


{branchname="actual 365, Act/365, FixedAct/365, FixedAct/365FEnglish:", state="COLLAPSED", --89
"Each month is treated normally and the year is assumed to be 365 days. For example, in a period from February 1, 2005 to April 1, 2005, the Factor is considered to be 59 days divided by 365.", --90
"The CouponFactor uses the same formula, replacing Date2 by Date3. In general, coupon payments will vary from period to period, due to the differing number of days in the periods. The formula applies to both regular and irregular coupon periods.", --91
"Sources: 'ISDA Definitions, Section 4.16'. 2006. Retrieved2014-09-18. ISDA 2006 Section 4.16(d).", --92
}, --{branchname="actual 365, Act/365, FixedAct/365, FixedAct/365FEnglish:",
{branchname="Nenner actual 365", --onclick="Nenneractual365()" --93
"", --94: document.FormularZins.Nenner365.value
}, --{branchname="Nenner actual 365"




{branchname="actual 364:", state="COLLAPSED", --95
"Each month is treated normally and the year is assumed to be 364 days. For example, in a period from February 1, 2005 to April 1, 2005, the Factor is considered to be 59 days divided by 364.", --96
"The CouponFactor uses the same formula, replacing Date2 by Date3. In general, coupon payments will vary from period to period, due to the differing number of days in the periods. The formula applies to both regular and irregular coupon periods.", --97
}, --{branchname="actual 364:",
{branchname="Nenner actual 364", --onclick="Nenneractual365()" --98
"", --99: document.FormularZins.Nenner364.value
}, --{branchname="Nenner actual 364"

{branchname="Actual 360, Act/360, A/360, French (französische Methode):", state="COLLAPSED", --100
"This convention is used in money markets for short-term lending of currencies, including the US dollar and Euro, and is applied in ESCBmonetary policy operations. It is the convention used withRepurchase agreements. Each month is treated normally and the year is assumed to be 360 days. For example, in a period from February 1, 2005 to April 1, 2005, the Factor is 59 days divided by 360 days.", --101
"The CouponFactor uses the same formula, replacing Date2 by Date3. In general, coupon payments will vary from period to period, due to the differing number of days in the periods. The formula applies to both regular and irregular coupon periods.", --102
"Sources: 'ICMA Rule Book, Rule 251'. Retrieved 2014-09-18. ICMA Rule 251.1(i) (not sterling). 'ISDA Definitions, Section 4.16'. 2006. Retrieved2014-09-18. ISDA 2006 Section 4.16(e). (Mayle 1993)", --103
}, --{branchname="Actual 360, Act/360, A/360, French (französische Methode):",
{branchname="Nenner actual 360", --onclick="Nenneractual360()" --104
"", --105: document.FormularZins.Nenner360.value
}, --{branchname="Nenner actual 364"

}, --{branchname="Nenner bestimmen für Tageskonventionen actual mit der exakten Anzahl Tage",


{branchname="Für die Rechnung benutzte Tage im Nenner", --106
"", --107: document.FormularZins.AnzahlTageNenner.value
}, --{branchname="


{branchname="Geben Sie die Anzahl Jahre mit Nachkommastellen manuell ein:", state="COLLAPSED", --108
"1", --109: document.FormularZins.JahreManuelleEingabe.value
{branchname="Jahre manuell setzen", -- onclick="JahreManuellSetzen()" --110
}, --{branchname="Jahre manuell setzen",
}, --{branchname="Geben Sie die Anzahl Jahre mit Nachkommastellen manuell ein:",


{branchname="Für die Rechnung benutzte Jahre mit Nachkommastellen", --111
"", --112: document.FormularZins.Jahre.value
}, --{branchname="Für die Rechnung benutzte Jahre mit Nachkommastellen",
{branchname="Für die Rechnung benutzte Methode:", --113
"", --114: document.FormularZins.Methode.value
}, --{branchname="Methode:",

{branchname="Zinsberechnung", --115


{branchname="Kapital und Zinssatz eintragen", -- onclick="KapitalZinssatzSchreiben()" --116

{branchname="Alle Zinsen mit Titel ausgeben", -- onclick="ZinsenTitelAlle()" --117

{branchname="Titel", -- onclick="TitelErgaenzen()" --118
"", --119: document.FormularZins.Titel.value
},
{branchname="Zinsen linear = Kapital * Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner", -- onclick="Zinsen()" --120
"", --121: document.FormularZins.Zins. value
},
{branchname="Zinsen mit Zinseszinsen = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner)-1)", -- onclick="Zinseszinsen() --122
"", --123: document.FormularZins.Zinszins. value
},
{branchname="Zinsen stetig verzinst = Kapital * (e^(Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner) -1)", -- onclick="Zinsenstetig()" --124
"", --125: document.FormularZins.Zinsstetig. value
},

{branchname="Alle Zinsen mit Titel in eine Datei ausgeben", -- onclick="ZinsErgebnisAlleZeilenAusgabe()" --126

"C:\\Tree\\LuatoLua\\Tree_calculator_with_interests.txt", --127
},


}, --{branchname="Alle Zinsen mit Titel ausgeben",

}, --{branchname="Kapital und Zinssatz eintragen",

{branchname="Zurücksetzen", -- onclick="KapitalZinssatzZuruecksetzen()" --128

}, --{branchname="Zurücksetzen",


}, --{branchname="Zinsberechnung",


}, --{branchname="Für die Rechnung benutzte Tage im Zähler"
}, --{branchname="Anzahl Tage im Zähler bestimmen und soweit schon möglich im Nenner, sonst weitere Knoten verwenden",
}, --{branchname="3. Zinsberechnung",

{branchname="Quellen", state="COLLAPSED",
"https://en.m.wikipedia.org/wiki/Day_count_convention",
"https://m.zinsen-berechnen.de/zinsmethoden/",
},
} --actualtree={branchname="Zinsrechner",






--1. basic data

--1.1 libraries and clipboard
--1.1.1 libraries
require("iuplua")           --require iuplua for GUIs

--1.1.2 math.integer for Lua 5.1 and Lua 5.2
if _VERSION=='Lua 5.1' then
	function math.tointeger(a) return a end
elseif _VERSION=='Lua 5.2' then
	function math.tointeger(a) return a end
end --if _VERSION=='Lua 5.1' then


--1.1.3 securisation by allowing only necessary os.execute commands
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
color_buttons=color_blue --works only for flat buttons
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

--3.1.2 round function here away-from-zero
--other forms of round functions can also be implemented in Lua
function math.round(a,precisionNumber)
precisionNumber=precisionNumber or 0
if a>0 then return math.floor(a*10^precisionNumber+0.5)/10^precisionNumber
else        return math.ceil (a*10^precisionNumber-0.5)/10^precisionNumber
end --if a>0 then
end --function math.round(a,precisionNumber)




--3.3 functions for tree calculations

--3.3.1 functions with function names corresponding to nodes

function Schaltjahr ()
Jahr = tree['title' .. 8]
Tage = 28 
if (Jahr%4==0) then Tage=Tage+1 end
if (Jahr%100==0) then Tage=Tage+1 end --;if(Jahr%400==0) Tage++;
if (Tage==28) then tree['title' .. 10] = Jahr .. " ist kein Schaltjahr" end ;
if (Tage==29) then tree['title' .. 10] =Jahr .. " ist ein Schaltjahr" end ;
end --function Schaltjahr()

function Rechner()
load("Ergebnis = " .. tree['title' .. 3]:gsub('×','*'):gsub('÷','/'):gsub(',','.'))()
tree['title' .. 5]=Ergebnis
end--function Rechner()


--
-- 360 Methode
function Anzahltage30zaehler()
-- 30/360 Bond Basis This convention is exactly as 30U/360 below, except for the first two rules. Note that the order of calculations is important:
D1 = -(-tree['title18'])
D2 = -(-tree['title24'])
M1 = -(-tree['title17'])
M2 = -(-tree['title23'])
Y1 = -(-tree['title16'])
Y2 = -(-tree['title22'])
if (D1>30) then D1 = 30 end --Regel 1: D1 = MIN (D1, 30).
if (D1==30) then if (D2>30) then D2 = 30 end end--Regel 2: If D1 = 30 Then D2 = MIN (D2,30)
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)
tree['title35'] = Ergebnis
tree['title78'] = Ergebnis
tree['title114'] = "M30";
tree['title112'] =  Ergebnis / 360
tree['title107'] = 360
end --function Anzahltage30zaehler()

--
function Anzahltage30ISDAzaehler()
-- 30/360 ISDA:
D1 = -(-tree['title18'])
D2 = -(-tree['title24'])
M1 = -(-tree['title17'])
M2 = -(-tree['title23'])
Y1 = -(-tree['title16'])
Y2 = -(-tree['title22'])
applied30="Regel1 not applied mit 30";
if (D1==31) then D1 = 30; applied30="Regel 1 applied mit 30" end--Regel 1: if D1 = 30 then change D1 to 30.
if (applied30=="Regel 1 applied mit 30") then if (D2==31) then D2 = 30 end end --Regel 2: If D1 = 30 after applying Regel 1 Then D2 = 30
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)
tree['title41'] = Ergebnis .. " " .. applied30
tree['title78'] = Ergebnis
tree['title114'] = "M30ISDA";
tree['title112'] =  Ergebnis / 360
tree['title107'] = 360
end --function Anzahltage30ISDAzaehler()


--
function Anzahltage30Ezaehler()
-- 30E/360 Date adjustment rules:
D1 = -(-tree['title18'])
D2 = -(-tree['title24'])
M1 = -(-tree['title17'])
M2 = -(-tree['title23'])
Y1 = -(-tree['title16'])
Y2 = -(-tree['title22'])
if (D1==31) then D1 = 30 end --Regel 1: If D1 is 31, then change D1 to 30.
if (D2==31) then D2 = 30 end --Regel 2: If D2 is 31, then change D2 to 30.
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)
tree['title47'] = Ergebnis
tree['title78'] = Ergebnis
tree['title114'] = "M30E";
tree['title112'] =  Ergebnis / 360
tree['title107'] = 360
end --function Anzahltage30Ezaehler()

--
function Anzahltage30EPluszaehler()
-- 30E+/360 Date adjustment rules:
D1 = -(-tree['title18'])
D2 = -(-tree['title24'])
D2Plus = -(-tree['title55'])
M1 = -(-tree['title17'])
M2 = -(-tree['title23'])
M2Plus = -(-tree['title54'])
Y1 = -(-tree['title16'])
Y2 = -(-tree['title22'])
Y2Plus = -(-tree['title53'])
veraendert = "unverändert: "
if (D1==31) then D1 = 30 end --Regel 1: If D1 is 31, then change D1 to 30.
if (D2==31) then D2 = D2Plus; M2 = M2Plus; Y2 = Y2Plus; veraendert = "verändert: " end --Regel 2: If D2 is 31, then set D2.M2.Y2 to 1st day of the next month.
--Die Umrechnung in den ersten des nächsten Monats entspricht der Beibehaltung des 31. des Endemonats in der Formel. Es wird eh nur ein Tag hinzugerechnet.
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)
tree['title57'] = Ergebnis .. " Endedatum " .. veraendert .. D2 .. "." .. M2 .. "." .. Y2;
tree['title78'] = Ergebnis
tree['title114'] = "M30E+";
tree['title112'] =  Ergebnis / 36
tree['title107'] = 360
end --function Anzahltage30PlusEzaehler()

--
function Anzahltage30Germanzaehler()
-- 30German/360 Date adjustment rules:
D1 = -(-tree['title18'])
D2 = -(-tree['title24'])
M1 = -(-tree['title17'])
M2 = -(-tree['title23'])
Y1 = -(-tree['title16'])
Y2 = -(-tree['title22'])
D1LetzterFebruar =""
D2LetzterFebruar =""
if (D1==31) then D1 = 30 end --Regel 1: If D1 is 31, then change D1 to 30.
if (D2==31) then D2 = 30 end --Regel 1: If D2 is 31, then change D2 to 30.
--nämlich Regel 1: If D1 and/or D2 is 31, then change D1 to 30 and/or D2 to.
if (tree['title20']=="ja") then D1=30; D1LetzterFebruar=" Startdatum letzter vom Februar " end
if (tree['title26']=="ja") then D2=30; D2LetzterFebruar=" Endedatum letzter vom Februar "  end
-- Regel 2 If D1.M1.Y1 and/or D2.M2.Y2 = last day of february =1.3.-1 Tag then change D1 to 30 and/or D2 to 30.
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)
tree['title63'] = Ergebnis .. "" .. D1LetzterFebruar .. D2LetzterFebruar;
tree['title78'] = Ergebnis
tree['title114'] = "M30German";
tree['title112'] =  Ergebnis / 360
tree['title107'] = 360
end --function Anzahltage30Germanzaehler()


function Anzahltage30USzaehler()
-- 30German/360 Date adjustment rules:
D1 = -(-tree['title18'])
D2 = -(-tree['title24'])
M1 = -(-tree['title17'])
M2 = -(-tree['title23'])
Y1 = -(-tree['title16'])
Y2 = -(-tree['title22'])
Regel1 = ""
Regel2 = ""
if (tree['title20']=="ja" and tree['title26']=="ja") then D2=30; Regel1="Regel1 beide letzte vom Februar" end --Regel 1: If D2.M2.Y2 ist the last day of February (28 ohne Schaltjahr und 29 im Schaltjahr) and D1.M1.Y1 ist the last day of February then D2 = 30
if (tree['title20']=="ja") then D1=30; Regel2=" Regel2 Startdatum letzter vom Februar" end --Regel 2: If D1.M1.Y1 ist the last day of February (28 ohne Schaltjahr und 29 im Schaltjahr) then D1 = 30
if (D2==31 and D1==30) then D2 = 30 end --Regel 3: If D2 is 31 and D1=30 or D1=31, then change D2 to 30.
if (D2==31 and D1==31) then D2 = 30 end
if (D1==31) then D1 = 30 end --Regel 4: If D1 is 31, then change D1 to 30.
Ergebnis = 360 * ( Y2 -  Y1 ) + 30 * ( M2 - M1 ) + (D2 - D1)
tree['title71'] = Ergebnis ..  " " .. Regel1 .. Regel2
tree['title78'] = Ergebnis
tree['title114'] = "M30US"
tree['title112'] =  Ergebnis / 360
tree['title107'] = 360
end --function Anzahltage30USzaehler()



--
--actual Methode
function Anzahltagezaehler()
Startdatum=os.time{year=tree['title16'],month=tree['title17'],day=tree['title18']}
Endedatum=os.time{year=tree['title22'], month=tree['title23'],day=tree['title24']}
Ergebnis = math.tointeger(math.round((Endedatum - Startdatum)/60/60/24,0))
tree['title74']= Ergebnis
tree['title78'] = Ergebnis - tree['title76']
end --function Anzahltagezaehler()


--
function Nenneractual36525()
Anzahltagezaehler()
tree['title84'] = 365.25
tree['title114'] = "act365Komma25bzw1durch1";
if tonumber(tree['title78']) then tree['title112'] =  tonumber(tree['title78']) / 365.25 end
tree['title107'] = 365.25
end --function Nenneractual36525()

--
function Nenneractual366()
Anzahltagezaehler()
tree['title88'] = 366
tree['title114'] = "act366";
if tonumber(tree['title78']) then tree['title112'] =  tonumber(tree['title78']) / 366 end
tree['title107'] = 366
end --function Nenneractual366()


--
function Nenneractual365()
Anzahltagezaehler()
tree['title94'] = 365
tree['title114'] = "act365";
if tonumber(tree['title78']) then tree['title112'] =  tonumber(tree['title78']) / 365 end
tree['title107'] = 365
end --function Nenneractual365()


--
function Nenneractual364()
Anzahltagezaehler()
tree['title99'] = 364
tree['title114'] = "act364";
if tonumber(tree['title78']) then tree['title112'] =  tonumber(tree['title78']) / 364 end
tree['title107'] = 364
end --function Nenneractual364()


--
function Nenneractual360()
Anzahltagezaehler()
tree['title105'] = 360
tree['title114'] = "act360";
if tonumber(tree['title78']) then tree['title112'] =  tonumber(tree['title78']) / 360 end
tree['title107'] = 360
end --function Nenneractual360()


--Zinsrechner
function JahreManuellSetzen()
tree['title112'] = tree['title109']
tree['title114'] = "manuell";
end --function JahreManuellSetzen()


function KapitalZinssatzSchreiben()
Start=os.date("%d.%m.%Y",os.time{year=tree['title16'],month=tree['title17'],day=tree['title18']})
Ende=os.date("%d.%m.%Y",os.time{year=tree['title22'], month=tree['title23'],day=tree['title24']})
tree['title119'] = '"' .. "Zinsart" .. '"' .. ";" .. '"' .. "Kapital" .. '"' .. ";" .. '"' .. "Zinssatz" .. '"' .. ";" .. '"' .. "Startdatumsangabe" .. '"' .. ";" .. '"' .. "Endedatumsangabe" .. '"'
tree['title121'] = '"' .. "Zins" .. '"' .. ";" .. '"' .. tree['title13']:gsub('%.',',') .. '"' .. ";" .. '"' .. tree['title14']:gsub('%.',',') .. '"' .. ";" .. '"' .. Start .. '"' .. ";" .. '"' .. Ende .. '"' ;
tree['title123'] = '"' .. "ZinsZinseszins" .. '"' .. ";" .. '"' .. tree['title13']:gsub('%.',',') .. '"' .. ";" .. '"' .. tree['title14']:gsub('%.',',') .. '"' .. ";" .. '"' .. Start .. '"' .. ";" .. '"' .. Ende .. '"' ;
tree['title125'] ='"' ..  "Zinsstetig" .. '"' .. ";" .. '"' .. tree['title13']:gsub('%.',',') .. '"' .. ";" .. '"' .. tree['title14']:gsub('%.',',') .. '"' .. ";" .. '"' .. Start .. '"' .. ";" .. '"' .. Ende .. '"' ;
end --function KapitalZinssatzSchreiben()


function TitelErgaenzen()
if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title112']) then
tree['title119'] = tree['title119'] .. ";" .. '"' .. "Methode_" .. tree['title114'] .. '"' .. ";" .. '"' .. "Ergebnis_" .. tree['title114'] .. '"'
end --if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title112']) then
end --function TitelErgaenzen()


function Zinsen()
if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title112']) then
Ergebnis = tonumber(tree['title13']) * tonumber(tree['title14']) * tonumber(tree['title78']) / tonumber(tree['title107'])
Ergebnis = math.round(Ergebnis,2)
tree['title121'] = tree['title121'] .. ";" .. '"' .. tree['title114'] .. '"' .. ";" .. '"' .. tostring(Ergebnis):gsub('%.',',') .. '"'
end --if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title112']) then
end --function Zinsen()
function Zinseszinsen()
if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title112']) then
Ergebnis = tree['title13']*(math.pow(-(-1-tree['title14']), tonumber(tree['title78']) / tonumber(tree['title107']))-1)
Ergebnis = "" .. math.round(Ergebnis,2)
tree['title123'] = tree['title123'] .. ";" .. '"' .. tree['title114'] .. '"' .. ";" .. '"' .. Ergebnis:gsub('%.',',') .. '"'
end --if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title112']) then
end --function Zinseszinsen()
function Zinsenstetig()
if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title112']) then
Ergebnis = tree['title13']*(math.exp(-(-tree['title14']) * tonumber(tree['title78']) / tonumber(tree['title107']) )-1);
Ergebnis = "" .. math.round(Ergebnis,2)
tree['title125'] = tree['title125'] .. ";" .. '"' .. tree['title114'] .. '"' .. ";" .. '"' .. Ergebnis:gsub('%.',',') .. '"'
end --if tonumber(tree['title13']) and tonumber(tree['title14']) and tonumber(tree['title112']) then
end --function Zinsenstetig()

function ZinsenTitelAlle()
TitelErgaenzen();
Zinsen();
Zinseszinsen();
Zinsenstetig();
end --function ZinsenTitelAlle()

--
function KapitalZinssatzZuruecksetzen()
tree['title119']=""
tree['title121']=""
tree['title123']=""
tree['title125']=""
end --function KapitalZinssatzZuruecksetzen()
--

function ZinsErgebnisAlleZeilenAusgabe()
outputfile1=io.open(path .. "\\" .. thisfilename:gsub("%.lua",".txt"),"w")
outputfile1:write(tree['title119'] .. "\n")
outputfile1:write(tree['title121'] .. "\n")
outputfile1:write(tree['title123'] .. "\n")
outputfile1:write(tree['title125'] .. "\n")
outputfile1:close()
end --function ZinsErgebnisAlleZeilenAusgabe()

--4. no dialogs needed since tree is fixed

--5. context menus (menus for right mouse click)

--5.1 menu of tree

--5.1.1 start file of node of tree in IUP Lua scripter or start empty file in notepad or start empty scripter
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

--5.1.2 start the file or repository of the node of tree
startnode = iup.item {title = "Starten"}
function startnode:action()
	if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then
		os.execute('start "D" "' .. tree['title'] .. '"')
	elseif tree['title']:match("sftp .*") then
		os.execute(tree['title'])
	end --if tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$") then
end --function startnode:action()

--5.1.3 put the menu items together in the menu for tree
menu = iup.menu{
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
-- Callback for right click on tree
function tree:rightclick_cb(id)
	if tree['title']=="Berechnen"                                                                         then Rechner()
	elseif tree['title']=="Ausgabe"                                                                       then Schaltjahr()
	elseif tree['title']=="Anzahl Tage Zähler 30 und Nenner 360"                                          then Anzahltage30zaehler()
	elseif tree['title']=="Anzahl Tage Zähler 30ISDA und Nenner 360"                                      then Anzahltage30ISDAzaehler()
	elseif tree['title']=="Anzahl Tage Zähler 30E und Nenner 360"                                         then Anzahltage30Ezaehler()
	elseif tree['title']=="Anzahl Tage Zähler 30E+ und Nenner 360"                                        then Anzahltage30EPluszaehler()
	elseif tree['title']=="Anzahl Tage Zähler 30German und Nenner 360"                                    then Anzahltage30Germanzaehler()
	elseif tree['title']=="Anzahl Tage Zähler 30US und Nenner 360"                                        then Anzahltage30USzaehler()
	elseif tree['title']=="Anzahl Tage Zähler actual und Nenner für actual im Weiteren Knoten bestimmen"  then Anzahltagezaehler()
	elseif tree['title']=="Nenner actual 365.25 1/1"                                                      then Nenneractual36525()
	elseif tree['title']=="Nenner actual 366"                                                             then Nenneractual366()
	elseif tree['title']=="Nenner actual 365"                                                             then Nenneractual365()
	elseif tree['title']=="Nenner actual 364"                                                             then Nenneractual364()
	elseif tree['title']=="Nenner actual 360"                                                             then Nenneractual360()
	elseif tree['title']=="Jahre manuell setzen"                                                          then JahreManuellSetzen()
	elseif tree['title']=="Kapital und Zinssatz eintragen"                                                then KapitalZinssatzSchreiben()
	elseif tree['title']=="Alle Zinsen mit Titel ausgeben"                                                then ZinsenTitelAlle()
	elseif tree['title']=="Titel"                                                                         then TitelErgaenzen()
	elseif tree['title']=="Zinsen linear = Kapital * Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner"                                                                 then Zinsen()
	elseif tree['title']=="Zinsen mit Zinseszinsen = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner)-1)"                                                       then Zinseszinsen()
	elseif tree['title']=="Zinsen stetig verzinst = Kapital * (e^(Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner) -1)"                                                        then Zinsenstetig()
	elseif tree['title']=="Alle Zinsen mit Titel in eine Datei ausgeben"                                  then ZinsErgebnisAlleZeilenAusgabe()
	elseif tree['title']=="Zurücksetzen"                                                                  then KapitalZinssatzZuruecksetzen()
	elseif tree['title']:match("^.:\\.*%.[^\\ ]+$") or tree['title']:match("^.:\\.*[^\\]+$") or tree['title']:match("^.:\\$") or tree['title']:match("^[^ ]*//[^ ]+$")                                                             then menu:popup(iup.MOUSEPOS,iup.MOUSEPOS) --popup the defined menue
	end --if tree['title']=="Berechnen" then
end --function tree:rightclick_cb(id)


--7.3 building the dialog and put buttons, trees and other elements together
maindlg = iup.dialog {iup.frame{title="Zinsrechner",
		iup.scrollbox{iup.vbox{
			--iup.hbox{button_logo,},
			tree,
		},}, --iup.scrollbox{iup.vbox{
		size="FULLxFULL"},
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

--image for branches with functions
tree['imageexpanded4']=img_functionarrow   --Berechnen                                                                      Rechner()
tree['imageexpanded9']=img_functionarrow   --Ausgabe                                                                        Schaltjahr()
tree['imageexpanded34']=img_functionarrow  --Anzahl Tage Zähler 30 und Nenner 360                                           Anzahltage30zaehler()
tree['imageexpanded40']=img_functionarrow  --Anzahl Tage Zähler 30ISDA und Nenner 360                                       Anzahltage30ISDAzaehler()
tree['imageexpanded46']=img_functionarrow  --Anzahl Tage Zähler 30E und Nenner 360                                          Anzahltage30Ezaehler()
tree['imageexpanded56']=img_functionarrow  --Anzahl Tage Zähler 30E+ und Nenner 360                                         Anzahltage30EPluszaehler()
tree['imageexpanded62']=img_functionarrow  --Anzahl Tage Zähler 30German und Nenner 360                                     Anzahltage30Germanzaehler()
tree['imageexpanded70']=img_functionarrow  --Anzahl Tage Zähler 30US und Nenner 360                                         Anzahltage30USzaehler()
tree['imageexpanded73']=img_functionarrow  --Anzahl Tage Zähler actual und Nenner für actual im Weiteren Knoten bestimmen   Anzahltagezaehler()
tree['imageexpanded83']=img_functionarrow  --Nenner actual 365.25 1/1                                                       Nenneractual36525()
tree['imageexpanded87']=img_functionarrow  --Nenner actual 366                                                              Nenneractual366()
tree['imageexpanded93']=img_functionarrow  --Nenner actual 365                                                              Nenneractual365()
tree['imageexpanded98']=img_functionarrow  --Nenner actual 364                                                              Nenneractual364()
tree['imageexpanded104']=img_functionarrow --Nenner actual 360                                                              Nenneractual360()
tree['imageexpanded110']=img_functionarrow --Jahre manuell setzen                                                           JahreManuellSetzen()
tree['image110']=img_functionarrow         --Jahre manuell setzen                                                           JahreManuellSetzen()
tree['imageexpanded116']=img_functionarrow --Kapital und Zinssatz eintragen                                                 KapitalZinssatzSchreiben()
tree['imageexpanded117']=img_functionarrow --Alle Zinsen mit Titel ausgeben                                                 ZinsenTitelAlle()
tree['imageexpanded118']=img_functionarrow --Titel                                                                          TitelErgaenzen()
tree['imageexpanded120']=img_functionarrow --Zinsen linear = Kapital * Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner                                                                  Zinsen()
tree['imageexpanded122']=img_functionarrow --Zinsen mit Zinseszinsen = Kapital * ((1+Zinssatz)^(Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner)-1)                                                        Zinseszinsen()
tree['imageexpanded124']=img_functionarrow --Zinsen stetig verzinst = Kapital * (e^(Zinssatz * Anzahl_Tage_Zaehler / Anzahl_Tage_Nenner) -1)                                                         Zinsenstetig()
tree['imageexpanded126']=img_functionarrow --Alle Zinsen mit Titel in eine Datei ausgeben                                   ZinsErgebnisAlleZeilenAusgabe()
tree['imageexpanded128']=img_functionarrow --Zurücksetzen                                                                   KapitalZinssatzZuruecksetzen()
tree['image128']=img_functionarrow --Zurücksetzen                                                                           KapitalZinssatzZuruecksetzen()



--Eingabefelder
tree['image3']=img_inputarrow   --document.Formular.Eingabe.value
tree['image5']=img_rightarrow   --document.Formular.Ergebnis.value
tree['image8']=img_inputarrow   --document.Formular1.Eingabe3.value
tree['image10']=img_rightarrow  --document.Formular1.ErgebnisSchaltjahr.value
tree['image13']=img_inputarrow  --document.FormularZins.Kapital.value
tree['image14']=img_inputarrow  --document.FormularZins.Zinssatz.value
tree['image16']=img_inputarrow  --document.FormularZins.Startjahr.value
tree['image17']=img_inputarrow  --document.FormularZins.Startmonat.value
tree['image18']=img_inputarrow  --document.FormularZins.Starttag.value
tree['image20']=img_inputarrow  --document.FormularZins.ManuellLastDayFebruary1.value
tree['image22']=img_inputarrow  --document.FormularZins.Endejahr.value
tree['image23']=img_inputarrow  --document.FormularZins.Endemonat.value
tree['image24']=img_inputarrow  --document.FormularZins.Endetag.value
tree['image26']=img_inputarrow  --document.FormularZins.ManuellLastDayFebruary2.value
tree['image35']=img_rightarrow  --document.FormularZins.Anzahltage30.value
tree['image41']=img_rightarrow  --document.FormularZins.Anzahltage30ISDA.value
tree['image47']=img_rightarrow  --document.FormularZins.Anzahltage30E.value
tree['image53']=img_inputarrow  --document.FormularZins.EndejahrPlus.value
tree['image54']=img_inputarrow  --document.FormularZins.EndemonatPlus.value
tree['image55']=img_inputarrow  --document.FormularZins.EndetagPlus.value
tree['image57']=img_rightarrow  --document.FormularZins.Anzahltage30EPlus.value
tree['image63']=img_rightarrow  --document.FormularZins.Anzahltage30German.value
tree['image71']=img_rightarrow  --document.FormularZins.Anzahltage30US.value
tree['image74']=img_rightarrow  --document.FormularZins.Anzahltageactual.value
tree['image76']=img_inputarrow  --document.FormularZins.AnzahltageNoLeap.value
tree['image78']=img_rightarrow  --document.FormularZins.AnzahlTageZaehler.value
tree['image84']=img_rightarrow  --document.FormularZins.Nenner36525.value
tree['image88']=img_rightarrow  --document.FormularZins.Nenner366.value
tree['image94']=img_rightarrow  --document.FormularZins.Nenner365.value
tree['image99']=img_rightarrow  --document.FormularZins.Nenner364.value
tree['image105']=img_rightarrow --document.FormularZins.Nenner360.value
tree['image107']=img_rightarrow --document.FormularZins.AnzahlTageNenner.value
tree['image109']=img_inputarrow --document.FormularZins.JahreManuelleEingabe.value
tree['image112']=img_rightarrow --document.FormularZins.Jahre.value
tree['image114']=img_rightarrow --document.FormularZins.Methode.value
tree['image119']=img_rightarrow --document.FormularZins.Titel.value
tree['image121']=img_rightarrow --document.FormularZins.Zins.value
tree['image123']=img_rightarrow --document.FormularZins.Zinszins.value
tree['image125']=img_rightarrow --document.FormularZins.Zinsstetig.value





--7.6 Main Loop
if (iup.MainLoopLevel()==0) then iup.MainLoop() end


