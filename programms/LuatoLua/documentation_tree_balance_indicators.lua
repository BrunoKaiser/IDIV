

--Allgemeine Kennzahlen
Aktivseitensumme                   = tree3['title1']:match(": (%d[^ ]*%d)[^%d]*"):gsub("%.","")
Aktivseitensumme                   = tonumber(Aktivseitensumme)
Passivseitensumme_ohne_Eigenkapital= tree2['title1']:match(": (%d[^ ]*%d)[^%d]*"):gsub("%.","")
Passivseitensumme_ohne_Eigenkapital= tonumber(Passivseitensumme_ohne_Eigenkapital)
Eigenkapitalsumme                  = Aktivseitensumme -  Passivseitensumme_ohne_Eigenkapital


textfield1.value="Eigenkapital: " .. Eigenkapitalsumme 
Eigenkapitalquote                  = Eigenkapitalsumme / Aktivseitensumme


textfield1.value=textfield1.value .."\n" .. 
"Eigenkapitalquote: " .. Eigenkapitalquote 

textfield1.value=textfield1.value .."\n" .. "Weitere Bilanzkennzahlen abhängig von der Bilanzstruktur ermitteln..."

--ASF Eigenkapital
textfield1.value=textfield1.value .."\n" .. "ASF EK: " .. Eigenkapitalsumme * 1

--ASF gesamt berechnen, Available Stable Funding, Verfügbare stabile Refinanzierung
for i=0,tree2.totalchildcount0 do
	if tree2["title" .. i]:match("^ASF") then
		ASF_gesamt_ohne_EK=tree2["title" .. i]:match("^ASF: (%d[^ ]*%d)[^%d]*"):gsub("%.","")
	end --if tree2["title" .. i]:match("^ASF") then
end --for i=0,tree2.totalchildcount0 do
ASF_gesamt_ohne_EK=ASF_gesamt_ohne_EK:gsub(",",".")
ASF_gesamt=tonumber(ASF_gesamt_ohne_EK) + Eigenkapitalsumme * 1
textfield1.value=textfield1.value .."\n" .. "ASF gesamt: " .. tostring(ASF_gesamt):gsub("%.",",")

--RSF gesamt berechnen, Required Stable Funding, Erforderliche stabile Refinanzierung
for i=0,tree3.totalchildcount0 do
	if tree3["title" .. i]:match("^RSF") then
		RSF_gesamt=tree3["title" .. i]:match("^RSF: (%d[^ ]*%d)[^%d]*"):gsub("%.","")
	end --if tree3["title" .. i]:match("^RSF") then
end --for i=0,tree3.totalchildcount0 do
RSF_gesamt=RSF_gesamt:gsub(",",".")
RSF_gesamt=tonumber(RSF_gesamt)
textfield1.value=textfield1.value .."\n" .. "RSF gesamt: " .. tostring(RSF_gesamt):gsub("%.",",")

--Verhältnis aus ASF und RSF als strukturelle Liquiditätsquote NSFR
strukturelle_Liquiditaetsquote_NSFR=ASF_gesamt/RSF_gesamt
textfield1.value=textfield1.value .."\n" .. "strukturelle Liquiditätsquote NSFR: " .. math.floor(strukturelle_Liquiditaetsquote_NSFR*10000)/100 .. "%"
textfield1.value=textfield1.value .."\n" .. "Berechnungen siehe https://de.m.wikipedia.org/wiki/Strukturelle_Liquidit%C3%A4tsquote"

