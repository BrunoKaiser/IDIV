require("iuplua")
require("iuplua_mglplot")

ZeitreihenTabelle={}
ZoomFaktor=1
LandTabelle={}
ZoomFaktorTabelle={}
--Nordamerika
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.CAD.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Kanada"
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.USD.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Vereinigte Staaten" --US-Dollar
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.MXN.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Mexiko"                 ZoomFaktorTabelle[WaehrungsDatei]=100 
--Europa ohne Europäische Union
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.SEK.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Schweden"               ZoomFaktorTabelle[WaehrungsDatei]=100
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.NOK.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Norwegen"               ZoomFaktorTabelle[WaehrungsDatei]=100
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.ISK.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Island"                 ZoomFaktorTabelle[WaehrungsDatei]=10000 
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.GBP.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Vereinigtes Koenigreich"
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.PLN.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Polen"
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.BGN.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Bulgarien"              ZoomFaktorTabelle[WaehrungsDatei]=100
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.DKK.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Daenemark"              ZoomFaktorTabelle[WaehrungsDatei]=100
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.HRK.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Kroatien"               ZoomFaktorTabelle[WaehrungsDatei]=100
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.CZK.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Tschechien"             ZoomFaktorTabelle[WaehrungsDatei]=100
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.HUF.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Ungarn"                 ZoomFaktorTabelle[WaehrungsDatei]=10000
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.CHF.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Schweiz" --Schweizer Franken
--BRICS
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.BRL.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Brasilien"
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.RUB.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Russische Foederation"  ZoomFaktorTabelle[WaehrungsDatei]=100 --Rubel
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.INR.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Indien"                 ZoomFaktorTabelle[WaehrungsDatei]=100
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.CNY.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Volksrepublik China"    ZoomFaktorTabelle[WaehrungsDatei]=100--Chinesischer Yuan
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.ZAR.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Suedafrika"             ZoomFaktorTabelle[WaehrungsDatei]=100
--Pazifik
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.SGD.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Singapur"               ZoomFaktorTabelle[WaehrungsDatei]=100
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.IDR.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Indonesien"             ZoomFaktorTabelle[WaehrungsDatei]=10000
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.JPY.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Japan"                  ZoomFaktorTabelle[WaehrungsDatei]=10000
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.KRW.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Suedkorea"              ZoomFaktorTabelle[WaehrungsDatei]=10000
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.THB.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Thailand"               ZoomFaktorTabelle[WaehrungsDatei]=100
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.MYR.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Malaysia"               ZoomFaktorTabelle[WaehrungsDatei]=10000
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.PHP.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Philippinen"            ZoomFaktorTabelle[WaehrungsDatei]=100
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.HKD.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Hongkong"               ZoomFaktorTabelle[WaehrungsDatei]=100
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.AUD.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Australien"             ZoomFaktorTabelle[WaehrungsDatei]=100 
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.NZD.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Neuseeland"             ZoomFaktorTabelle[WaehrungsDatei]=100          
--Israel
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.ILS.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Israel"                 ZoomFaktorTabelle[WaehrungsDatei]=100
--Türkei
--bis Ende Dezember 2004
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.TRL.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Tuerkei bis Ende Dezember 2004"         ZoomFaktorTabelle[WaehrungsDatei]=100000
WaehrungsDatei="/home/pi/Downloads/Statistiken/BBEX3.D.TRY.EUR.BB.AC.000.csv" LandTabelle[WaehrungsDatei]="Tuerkei ab Januar 2005"                 ZoomFaktorTabelle[WaehrungsDatei]=100


if arg[1] then
	WaehrungsDatei=arg[1]
end --if arg[1] then

Land=LandTabelle[WaehrungsDatei]
if ZoomFaktorTabelle[WaehrungsDatei] then ZoomFaktor=ZoomFaktorTabelle[WaehrungsDatei] end


Waehrung=WaehrungsDatei:match("BBEX3.D.(...)")
Maximum=0
Minimum=99999
aktuellerWert=0
aktuellesDatum=""
for line in io.lines(WaehrungsDatei) do
	local Datum,Wert=line:match("([^;]*);([^;]*);")
	--Testen mit: print(Datum,Wert)
	Wert=Wert:gsub(",",".")
	if Datum:match("^%d%d%d%d%-%d%d%-%d%d") and tonumber(Wert) then
		Wert=1/tonumber(Wert)*ZoomFaktor
		Wert=math.floor(Wert*100)/100
		--Testen mit: print(Datum,Wert)
		ZeitreihenTabelle[#ZeitreihenTabelle+1]=Datum .. ";" .. Wert
		if Wert>Maximum then Maximum=Wert end
		if Wert<Minimum then Minimum=Wert end
		aktuellesDatum=Datum
		aktuellerWert=Wert
	end --if Wert~="." then
end --for line in io.lines(WaehrungsDatei) do
print("Anzahl Beobachtungen: " .. #ZeitreihenTabelle)
print("Minimum: " .. Minimum)
print("Maximum: " .. Maximum)
if     ZoomFaktor==100000 then Y_Achse_in="in 1000-tel Cent" aktuellerWert=aktuellerWert .. " 1000-tel Cent" LegendenZahl=1 
elseif ZoomFaktor==10000  then Y_Achse_in="in 100-tel Cent" aktuellerWert=aktuellerWert .. " 100-tel Cent" LegendenZahl=1 
elseif ZoomFaktor==100    then Y_Achse_in="in Cent" aktuellerWert=aktuellerWert .. " Cent" LegendenZahl=1 
else Y_Achse_in="in EUR"  aktuellerWert=aktuellerWert .. " EUR" LegendenZahl=1 end
print("aktueller Wert: " .. aktuellerWert)

TitelText="Zeitreihe des Wechselkurses " .. Waehrung .. " in EUR\n@{" .. Land .. " (am " .. aktuellesDatum .. ": " .. aktuellerWert .. ")}"

plot = iup.mglplot{
--    TITLE = "Plot Test",
-- MARGINBOTTOM = 20,
MARGINLEFT="YES", 
MARGINRIGHT="YES", 
MARGINTOP="YES", 
MARGINBOTTOM="YES",
--AXS_XAUTOMIN="NO", 
--AXS_XAUTOMAX="NO",
AXS_YAUTOMIN="NO", 
AXS_YAUTOMAX="NO",
--AXS_ZAUTOMIN="NO", 
--AXS_ZAUTOMAX="NO",
--AXS_XLABEL="Zeit",
AXS_YLABEL="Wechselkurs " .. Y_Achse_in,
--AXS_ZLABEL="Z",
--AXS_XMIN=0, 
--AXS_XMAX=22,
AXS_YMIN=0, 
AXS_YMAX=Maximum+LegendenZahl,
--AXS_YLABELPOSITION="MAX",
AXS_XTICKVALUESROTATION="NO",
AXS_YTICKVALUESROTATION="YES",
--AXS_ZMIN=0, 
--AXS_ZMAX=17,
AXS_ZREVERSE="YES",
AXS_ZARROW="NO",
GRID="XYZ",
--ROTATE="-10.0:10:-1.0",
TITLE=TitelText,
TITLEFONTSIZE=0.7,
LEGEND="YES",
LEGENDPOS="TOPLEFT", --: legend box position. Can be: "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", or "BOTTOMRIGHT. Default: "TOPRIGHT"
--COLORBAR="YES",
BOX="YES",
--AXS_X="NO",
--AXS_Y="NO",
--AXS_Z="YES", --nicht nötig, aber man sieht die Z-Achse nicht
}


plot:Begin(1)
--plot:Add1D("Test", 0)
Schritt=100
Nummer=0
for i,v in ipairs(ZeitreihenTabelle) do
	--
print(v)
	Nummer=Nummer+1
	local Datum,Wert=v:match("([^;]*);([^;]*)")
	if type(Datum)=="string" and type(Wert)=="string" and Nummer%Schritt==0 then
		plot:Add1D(Datum:match("^%d%d%d%d"),tonumber(Wert))
	else
		--print(Datum,Wert)
	end --if type(Datum)=="string" and type(Wert)=="string" then
end --for i,v in ipairs(ZeitreihenTabelle) do
plot:End()
plot.DS_LEGEND="" .. Waehrung .. " in EUR alle " .. Schritt .. " Beobachtungen"
plot.DS_MODE="LINE"
print(plot.CURRENT)

plot:Begin(1)
--plot:Add1D("Test", 0)
Schritt=10
Nummer=0
for i,v in ipairs(ZeitreihenTabelle) do
	--print(v)
	Nummer=Nummer+1
	local Datum,Wert=v:match("([^;]*);([^;]*)")
	if type(Datum)=="string" and type(Wert)=="string" and Nummer%Schritt==0 then
		plot:Add1D(Datum:match("^%d%d%d%d"),tonumber(Wert))
	else
		--print(Datum,Wert)
	end --if type(Datum)=="string" and type(Wert)=="string" then
end --for i,v in ipairs(ZeitreihenTabelle) do
plot:End()
plot.DS_LEGEND="" .. Waehrung .. " in EUR alle " .. Schritt .. " Beobachtungen"
plot.DS_MODE="LINE"
print(plot.CURRENT)

print(plot.COUNT)


dlg = iup.dialog{
    TITLE = "Zeitreihe",
    SIZE = "700x200",
    plot,
}

dlg:showxy(iup.CENTER, iup.CENTER)

iup.MainLoop()

