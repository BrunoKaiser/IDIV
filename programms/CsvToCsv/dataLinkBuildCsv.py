
#1. library
import re

#1.1 csv input file
inputText="Feld1;Feld2;Feld3\nTupfingen;Hauptstr. 5;Schmidt\nHinterobertal;Dorfweg 2;Mustermann"

#1.2 first line of csv file as titles
firstLine="no"
searchObject=re.search("([^\n]*)",inputText)
textTitles=searchObject.group()+";"
FieldTable=[] #{"Field1","Field2","Field3"}
fieldNumber=0
fieldText=""
for field in textTitles:
    fieldText=fieldText+field
    if field==";":
        fieldNumber=fieldNumber+1
        if firstLine=="YES":
            FieldTable.append(fieldText.replace(";",""))
            fieldText=""
        else:
            FieldTable.append("Field"+str(fieldNumber))

#test with: print(FieldTable)

#2. goal and link definition
#2.1 goal definition
GoalTable=["Name","Ort","Strasse"]

#2.2 link definition
LinkTable={}
LinkTable["Field1"]="Ort"
LinkTable["Field2"]="Strasse"
LinkTable["Field3"]="Name"

#3. function for treatment of nil values
function tostringNil(aText)
    if tostring(aText)=="nil" then
        return "" --can be "NULL"
    else
        return tostring(aText)
    end --if tostring(aText)=="nil" then
end --function tostringNil(aText)

#4. treat csv file
rowNumber=0
inputText=inputText+"\n"
line=""
outputText=""
for c in inputText:
    line=line+c
    if c=="\n":
        line=line.replace("\n","")+";"
        rowNumber=rowNumber+1
        ColTable={}
        fieldNumber=-1
        #test with: print(line)
        fieldText=""
        for field in line:
            #test with: print(field)
            fieldText=fieldText+field
            if field==";":
                fieldNumber=fieldNumber+1
                fieldText=fieldText.replace(";","")
                #test with: print(LinkTable[FieldTable[fieldNumber]])
                #test with: print(fieldText)
                ColTable[LinkTable[FieldTable[fieldNumber]]]=fieldText
                fieldText=""
                #test with: print(ColTable)
        line=""
        outputText=""
        #test with: print(rowNumber)
        if rowNumber==1:
            if firstLine=="YES":
                #show titles
                for i in range(len(GoalTable)-1):
                    #test with: print(i)
                    outputText=outputText+GoalTable[i]+";"
                outputText=outputText+GoalTable[len(GoalTable)-1]
                #test with: print(outputText)
            elif ColTable[GoalTable[2]]:
                #show titles
                for i in GoalTable:
                    outputText=outputText+i+";"
                outputText=re.sub(";$","",outputText)
                #test with: 
                print(outputText)
                #show first row data
                outputText=""
                for i in GoalTable:
                    #test with: print(ColTable[i])
                    outputText=outputText+ColTable[i]+";"
                outputText=re.sub(";$","",outputText)
                print(outputText)
        elif ColTable[GoalTable[2]]:
            #show data
            for i in GoalTable:
                outputText=outputText+ColTable[i]+";"
            outputText=re.sub(";$","",outputText)
            print(outputText)
