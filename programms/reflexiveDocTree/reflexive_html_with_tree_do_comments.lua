--Fachliches Konzept IDIV-Produkte mit den Oberflächen koordinieren

--1. chosen number of the scripts
chosenNumber=10

--2. comment table
commentsTable={}


commentsTable["build Lua table for the tree as table of contents"]={
"Eine Lua-Tabelle wird für die Bildung einer Baumansicht des Inhaltsverzeichnisses hergestellt.",
"A Lua table for the tree as table of contents is build.",
}
commentsTable["input field as scintilla editor"]={
"Ein Textfeld als Scintilla Editor wird für die Eingabe benötigt.",
"An input field as scintilla editor is needed.",
}
commentsTable["button for filtering the two texts to be compared on filtered lines"]={
"Eine Schaltfläche filtert beide Texte nach einem Filtermuster, damit nur die gefilterten Zeilen verglichen werden.",
"A button filters the two texts according to a pattern to be compared on filtered lines.",
}
commentsTable["output field as scintilla editor"]={
"Ein Textfeld als Scintilla Editor wird für die Ausgabe benötigt.",
"An output field as scintilla editor is needed.",
}
commentsTable["button for inserting tabulators in text with comments"]={
"Eine Schaltfläche fügt in einen Text mit Kommentaren die geeigneten Tabulatoren ein. Nach den Kommentarzeichen werden die Ebenen der Gliederung nach Zahlen ermittelt und die entsprechende Anzahl Tabulatoren gesetzt.",
"A button inserts tabulators in text with comments. The level of the order is determined with the numbering after the comment signs. Afterwards the same number of tabulators is set.",
}
commentsTable["button for building tree from text with tabulators"]={
"Eine Schaltfläche bildet den Baum aus dem Text mit den Tabulatoren.",
"A button builds the tree from text with tabulators.",
}
commentsTable["button for mirroring tree"]={
"Eine Schaltfläche spiegelt den Baum.",
"A button mirrors the tree.",
}
commentsTable["write html file with tree in right order"]={
"Eine Html-Datie mit dem neuen Baum in der richtigen Reihenfolge wird geschrieben.",
"A html file with tree in right order is written.",
}
commentsTable["build new tree with titles"]={
"Ein neuer Baum mit den Titeln wird gebildet.",
"A new tree with titles is built.",
}
commentsTable["search for the version before"]={
"Die letzte Version vor der neuen Konvertierung wird bestimmt.",
"The last convertion, i.e. the version before the new conversion must be found.",
}
commentsTable["read html file from convertion before"]={
"Die Html-Datei, die bei der vorigen Konvertierung entstanden ist, wird gelesen.",
"The html file from the convertion done before the new conversion is to be read.",
}
commentsTable["exchange words in upper cases and brackets"]={
"Wörter in Großbuchstaben mit direkt angrenzender Klammer werden mit dieser in der Reihenfolge umgetauscht.",
"Words in upper cases and brackets are exchanged.",
}

commentsTable["example text variable"]={
"Eine Textvariable dient als Beispiel.",
"A text variable is used as an example.",
}

commentsTable["read opening and closing brackets and count them and add missing ones"]={
"Die öffnenden und schließenden runden Klammern werden gelesen und gezählt, damit die jeweils fehlenden bei Ungleichheit ergänzt werden.",
"The opening and closing brackets are read and counted so that the missing brackets are added.",
}
commentsTable["build from previous data a previous file"]={
"Eine Textdatei mit den Daten aus dem vorherigen Lauf wird geschrieben.",
"A previous text file is built from previous data.",
}
commentsTable["build new titles in tree compared to previous tree"]={
"Die neuen Titeln im Baum im Vergleich zu dem vorherigen Baum werden ermittelt.",
"New titles in tree compared to previous tree are determined.",
}
commentsTable["collect new titles with the distance to all the previous titles if not in previous tree"]={
"Die neuen Titeln im Baum, die nicht im vorherigen Baum sind, werden bezüglich ihrer Levenshtein-Distance, also der Änderungen in den Zeichenketten im Vergleich zu allen Titeln des vorherigen Baumes ausgewertet.",
"New titles in tree are collected with the Levenshtein distance, i.e. all differences in characters, to all the previous titles if not in previous tree.",
}
commentsTable["read previous tree and current tree"]={
"Der vorherige und der aktuelle Baum werden gelesen.",
"Previous tree and current tree are read.",
}
commentsTable["optional: show it in a simple documentation tree"]={
"Der Baum wird optional ein einer einfachen Baumansicht gezeigt.",
"Optionally the tree is shown in a simple documentation tree.",
}

commentsTable["show all parts of brackets"]={
"Alle Klammerpaarinhalte werden gezeigt.",
"All parts of brackets are shown.",
}
commentsTable["cut of all leafs of a node"]={
"Ein Kontextmenüpunkt schneidet alle Blätter darunter aus.",
"A menu item cuts all leafs of a node.",
}

commentsTable["cut of all nodes of a node"]={
"Ein Kontextmenüpunkt schneidet alle Knoten darunter aus.",
"A menu item cuts all nodes of a node.",
}

commentsTable["copy of all leafs of a node"]={
"Ein Kontextmenüpunkt kopiert alle Blätter darunter.",
"A menu item copies all leafs of a node.",
}

commentsTable["copy of all nodes of a node"]={
"Ein Kontextmenüpunkt kopiert alle Knoten darunter.",
"A menu item copies all nodes of a node.",
}

commentsTable["paste of all leafs of a node"]={
"Ein Kontextmenüpunkt fügt alle Blätter darunter ein.",
"A menu item pastes all leafs of a node.",
}

commentsTable["paste of all nodes of a node"]={
"Ein Kontextmenüpunkt fügt alle Knoten darunter ein.",
"A menu item pastes all nodes of a node.",
}

commentsTable["paste of all nodes of a node in an ascending order"]={
"Ein Kontextmenüpunkt fügt alle Knoten darunter aufsteigend sortiert ein.",
"A menu item pastes all nodes of a node in an ascending order.",
}

commentsTable["paste of all nodes of a node in a descending order"]={
"Ein Kontextmenüpunkt fügt alle Knoten darunter absteigend sortiert ein.",
"A menu item pastes all nodes of a node in a descending order.",
}

commentsTable["alphabetic sort of leafs ascending case sensitive"]={
"Ein Kontextmenüpunkt sortiert alle Blätter darunter alphabetisch nach Klein- und Großbuchstaben aufsteigend.",
"A menu item makes an alphabetic sort of leafs ascending case sensitive.",
}

commentsTable["alphabetic sort of leafs ascending case insensitive"]={
"Ein Kontextmenüpunkt sortiert alle Blätter darunter alphabetisch aufsteigend.",
"A menu item makes an alphabetic sort of leafs ascending case insensitive.",
}

commentsTable["alphabetic sort of leafs ascending case sensitive"]={
"Ein Kontextmenüpunkt sortiert alle Blätter darunter alphabetisch nach Klein- und Großbuchstaben absteigend.",
"A menu item makes an alphabetic sort of leafs ascending case sensitive.",
}

commentsTable["alphabetic sort of leafs ascending case insensitive"]={
"Ein Kontextmenüpunkt sortiert alle Blätter darunter alphabetisch absteigend.",
"A menu item makes an alphabetic sort of leafs ascending case insensitive.",
}

commentsTable["show node number with message"]={
"Ein Kontextmenüpunkt zeigt die Nummer des Knotens an.",
"A menu item shows node number with message.",
}
commentsTable["button for deleting one node leaving all other nodes but changing the order"]={
"Eine Schaltfläche löscht einen Knoten heraus und ändert die Reihenfolge. Es wird also eine Ebene herausgelöscht und die Unterknoten wandern eine Ebene hoch.",
"A button deletes one node leaving all other nodes but changing the order. One level is deleted and the child nodes are changed to a higher level.",
}
commentsTable["paste of all leafs of a node"]={
"Ein Kontextmenüpunkt fügt alle Blätter eines Knotens ein.",
"A menu item pastes all leafs of a node.",
}

commentsTable["copy node image definition for inputs"]={
"Ein Kontextmenüpunkt kopiert die Bilddefinition des Knotens für den Fall, dass es ein Input sein sollte.",
"A menu item copies node image definition for inputs.",
}
commentsTable["copy node image definition for outputs"]={
"Ein Kontextmenüpunkt kopiert die Bilddefinition des Knotens für den Fall, dass es ein Output sein sollte.",
"A menu item copies node image definition for outputs.",
}
commentsTable["copy node image definition for functions"]={
"Ein Kontextmenüpunkt kopiert die Bilddefinition des Knotens für den Fall, dass es eine Funktion sein sollte.",
"A menu item copies node image definition for functions.",
}
commentsTable["functions for tree calculations"]={
"Funktionen werden definiert, die für die Berechnungen im Baum nötig sind.",
"The functions are defined, which are necessary for tree calculations, i.e. calculation in the tree.",
}
commentsTable["functions in function Table"]={
"Funktionen werden definiert, die in einer Funktionentabelle gesammelt sind. Ihr Namen ist der des Elements der Funktionentabelle mit dem Knotennamen.",
"The functions in a function table are defined. The function names are the names of the elements of the function table equal to nodes names.",
}




commentsTable["node_function dialog"]={
"Ein zusätzliches Fenster dient dazu, die Funktionen in der Funktionentabelle festzulegen.",
"An additional dialog is needed to write the definition of the functions in the function table.",
}
commentsTable["copy node function definition to define the function"]={
"Ein Kontextmenüpunkt öffnet ein zusätzliches Fenster, das dient dazu, die Funktionen in der Funktionentabelle festzulegen.",
"A menu item opens an additional dialog that is needed to write the definition of the functions in the function table.",
}
commentsTable["nodeFunctionTable dialog"]={
"Ein zusätzliches Fenster dient dazu, die Funktionen in der Funktionenzuordnungstabelle festzulegen, d.h. Programmieren der Funktionszuordnung zu den Knoten.",
"An additional dialog is needed to write the definition of the functions in the function relation table.",
}


commentsTable["button for building tree with text file of tree1 deleting nodes being in tree2"]={
"Eine Schaltfläche bildet einen neuen Baum mit einer Textdatei, die einen ersten Baum enthält, und löscht alle Knoten heraus, die in einem zweiten Baum sind. Notwendige Zwischenknoten werden stehengelassen, weil sie im Pfad zu benötigten Knoten gebraucht werden, die nicht im zweiten Baum sind.",
"A button builds tree with text file of tree1 deleting nodes being in second tree. Necessary intermediate nodes are remained because they are needed in the path for other nodes not beeing in the second tree.",
}



commentsTable["button for sorting text file of tree in text file of tree2 to tree deleting not needed nodes"]={
"Eine Schaltfläche bildet einen neuen Baum mit einer Textdatei, die einen ersten Baum enthält, und behält alle Knoten, die in einem zweiten Baum enthalten sind. Notwendige Zwischenknoten werden stehengelassen, weil sie im Pfad zu benötigten Knoten gebraucht werden, die im ersten Baum sind.",
"A button sorts a text file of a first tree in text file of a second tree to a new tree deleting not needed nodes. Necessary intermediate nodes are remained because they are needed in the path for other nodes not beeing in the first tree.",
}

commentsTable["button for sorting text file of tree with text file of tree2 to a tree with parent child"]={
"Eine Schaltfläche bildet einen neuen Baum mit einer Textdatei, die einen ersten Baum enthält, und behält alle Knoten, die in einem zweiten Baum enthalten sind, in Form von Knoten und Unterknoten. Knoten, die nur im ersten Baum sind, werden separat ausgewiesen.",
"A button sorts a text file of a first tree with text file of second tree to a new tree with parent child relations of the nodes in both. En extra node is build with nodes beeing only in the first tree.",
}





commentsTable["functions with function names corresponding to nodes"]={
"Funktionen werden definiert, die einen Namen haben, der mit dem Namen eines Knotens korrespondiert. Der Name muss nicht identisch sein, weil eine Zuordnung hergestellt wird.",
"The functions with function names corresponding to nodes are defined. The name of the function may not be identical with the nodes name because the correspondence is coded.",
}
commentsTable["write end of file with return"]={
"Das Ende der Textdatei wird mit der Ergebnis-Variable geschrieben.",
"The end of file is written with the returned variable.",
}
commentsTable["round function here away-from-zero"]={
"Eine Rundungsfunktion bildet den kaufmännischen Durchschnitt.",
"A function math.round() rounds here away-from-zero.",
}
commentsTable["recursive function to build variable inputs from tree as Lua variables"]={
"Eine Funktion bildet rekursiv aus einem Baum Lua-Input-Variablen.",
"A function builds recursively Lua input variables from a tree.",
}
commentsTable["table of contents as a tree on the first page"]={
"Das Inhaltsverzeichnis als Baum wird für die erste Seite ermittelt und dort angezeigt.",
"The table of contents as a tree on the first page is built.",
}
commentsTable["initialisation of the current page"]={
"Die aktuelle Seite wird initialisiert.",
"The current page is initialised.",
}
commentsTable["button for transformation of the webpage with mathematical expressions"]={
"Eine Schaltfläche, die den Text der Internetseite mit Formeln umwandelt, ist nötig. Die Formeln sind in LaTEX geschrieben und werden in reinem Html umgewandelt.",
"A button for the transformation of the webpage with mathematical expressions is needed. The mathematical expressions are in LaTEX and are converted in pure html.",
}
commentsTable["button for saving text in text file"]={
"Eine Schaltfläche, die den Text in eine Textdatei speichert, ist nötig.",
"A button for saving text in text file is needed.",
}
commentsTable["button for saving tree reflexive with the programm"]={
"Eine Schaltfläche, die den Baum reflexiv mit dem gesamten Programm speichert, ist nötig.",
"A button for saving tree reflexive with the programm is needed.",
}
commentsTable["button for getting internet sites from text"]={
"Eine Schaltfläche, die aus dem Text die Internetseitenadressen ermittelt, ist nötig.",
"A button for getting internet sites from text is needed.",
}
commentsTable["function which saves the current iup htmlTexts as a Lua table"]={
"Eine Funktion, die die aktuellen IUP-Html-Texte als Lua-Tabelle und das Programm der graphischen Benutzeroberfläche speichert, ist nötig.",
"A function is needed which saves the current iup html texts as a Lua table and the programm of the graphical user interface.",
}
commentsTable["button for building new page"]={
"Eine Schaltfläche, die eine neue Seite anlegt, ist nötig.",
"A button for building new page is needed.",
}
commentsTable["initialise the data needed"]={
"Die nötigen Daten werden initialisiert.",
"The data needed are initialised.",
}
commentsTable["button for saving TextHTMLtable and the programm of the graphical user interface"]={
"Eine Schaltfläche für das Speichern der Texte in der Html-Tabelle und des Programms der graphischen Benutzeroberfläche wird benötigt.",
"A button for saving the text in HTML table and the programm of the graphical user interface is needed.",
}
commentsTable["button for saving TextHTMLtable as html file"]={
"Eine Schaltfläche für das Speichern der Texte in der Html-Tabelle als Html-Datei wird benötigt.",
"A button for saving the text in HTML table as html file is needed.",
}
commentsTable["example 1: load Welt Nachrichten"]={
"Als erstes Beispiel werden die Welt-Nachrichten geladen.",
"As a first example load Welt news.",
}
commentsTable["example 2: Domradio Nachrichten"]={
"Als erstes Beispiel werden die Domradio-Nachrichten geladen.",
"As a second example load Domradio news.",
}
commentsTable["button for converting PDF to text file with Word"]={
"Eine Schaltfläche konvertiert eine PDF-Datei in eine Textdatei mit Word.",
"A button for converting PDF to text file with Word is needed.",
}
commentsTable["start node of tree as a tree GUI or save a new one if not existing"]={
"Ein Kontextmenüpunkt startet den ausgewählten Knoten, der ein Verzeichnis sein muss, als Tree-Benutzeroberfläche, d.h. mit dem gleichen Fenster wird die geöffnete GUI oder es legt eine neue Oberfläche an. Die Anlage erfolgt nur bei Bestätigung, damit es nicht so viele Baum-Oberflächen gibt.",
"A menu item starts selected node of tree that must be a directory as a tree graphical user interface as the opened dialog or save a new one if not existing. The new one is only then build if the user confirm it. Therefore there are not so much tree graphical user interfaces.",
}
commentsTable["copy node of tree2 and add it to root of first tree as branch"]={
"Ein Kontextmenüpunkt kopiert den ausgewählten Knoten des zweiten Baumes und fügt ihn an den Stammknoten des ersten Baumes als Ast an (Knoten als Ast an Zuordnung senden).",
"A menu item copies the selected node of the second tree as a branch.",
}
commentsTable["start the directory of the file of the node of tree"]={
"Ein Kontextmenüpunkt startet den Ordner der Datei des ausgewählten Knotens.",
"A menu item starts the directory of the file of the selected node of the tree.",
}
commentsTable["function to calculate the portions with the sums of the levels above"]={
"Eine Funktion wird definiert, um die Anteile mit den Summen aus den Ebenen darüber zu berechnen.",
"A function is defined to calculate the portions with the sums of the levels above.",
}
commentsTable["function for printing dependencies in a csv file"]={
"Eine Funktion wird definiert, um die Abhängigkeiten in eine CSV-Datei zu schreiben.",
"A function is defined to export the dependencies in a csv file.",
}

commentsTable["start a preview of path and filenames of the scipt chosen in node"]={
"Ein Kontextmenüpunkt startet die Vorschau der Dateien und Verzeichnissen, die in dem Skript des ausgewählten Knotens des Baumes zu finden sind. Die Dateien können Input- oder Outputdateien sein. Die Verzeichnisse können Verzeichnisse sein, die bei Input- und Outputdaten relevant sind.",
"A menu item starts a preview of path and filenames of the scipt chosen in node.",
}
commentsTable["start a preview of file of tree with columns for csv files or dir for repository or the text of the node"]={
"Ein Kontextmenüpunkt startet die Vorschau der Datei des ausgewählten Knotens des Baumes. Wenn es eine CSV-Datei ist, werden die Spalten mit zusätzlichen Leerzeichen angezeigt. Bei einem Verzeichnis wird der dir-Befehl ausgewertet. Andernfalls wird der Text des Knotens gezeigt.",
"A menu item starts a preview of text file of selected node of the tree with columns for csv files or dir for repository or the text of the node.",
}
commentsTable["start a preview of file of tree2 with columns for csv files or dir for repository or the text of the node"]={
"Ein Kontextmenüpunkt startet die Vorschau der Datei des ausgewählten Knotens des zweiten Baumes. Wenn es eine CSV-Datei ist, werden die Spalten mit zusätzlichen Leerzeichen angezeigt. Bei einem Verzeichnis wird der dir-Befehl ausgewertet. Andernfalls wird der Text des Knotens gezeigt.",
"A menu item starts a preview of text file of selected node of the second tree with columns for csv files or dir for repository or the text of the node.",
}
commentsTable["add leaf to tree by insertleaf from clipboard"]={
"Ein Kontextmenüpunkt fügt ein Blatt darunter aus der Zwischenablage hinzu.",
"A menu item adds leaf to tree by insertleaf from clipboard.",
}
commentsTable["add leaf to console.outputTree by insertleaf from clipboard"]={
"Ein Kontextmenüpunkt fügt ein Blatt im Baum console.outputTree darunter aus der Zwischenablage hinzu.",
"A menu item adds leaf to tree console.outputTree by insertleaf from clipboard.",
}
commentsTable["add leaf to console.inputTree by insertleaf from clipboard"]={
"Ein Kontextmenüpunkt fügt ein Blatt im Baum console.inputTree darunter aus der Zwischenablage hinzu.",
"A menu item adds leaf to tree console.inputTree by insertleaf from clipboard.",
}
commentsTable["add leaf to console.commandTree by insertleaf from clipboard"]={
"Ein Kontextmenüpunkt fügt ein Blatt im Baum console.commandTree darunter aus der Zwischenablage hinzu.",
"A menu item adds leaf to tree console.commandTree by insertleaf from clipboard.",
}
commentsTable["add leaf to tree by insertleaf"]={
"Ein Kontextmenüpunkt fügt ein Blatt darunter hinzu.",
"A menu item adds leaf to tree by insertleaf.",
}
commentsTable["add leaf to console.outputTree by insertleaf"]={
"Ein Kontextmenüpunkt fügt ein Blatt im Baum console.outputTree darunter hinzu.",
"A menu item adds leaf to tree console.outputTree by insertleaf.",
}
commentsTable["add leaf to console.commandTree by insertleaf"]={
"Ein Kontextmenüpunkt fügt ein Blatt im Baum console.commandTree darunter hinzu.",
"A menu item adds leaf to tree console.commandTree by insertleaf.",
}
commentsTable["add leaf to console.inputTree by insertleaf"]={
"Ein Kontextmenüpunkt fügt ein Blatt im Baum console.inputTree darunter hinzu.",
"A menu item adds leaf to tree console.inputTree by insertleaf.",
}
commentsTable["add leaf to console.inputTree by insertleaf after the last leaf of the branch chosen"]={
"Ein Kontextmenüpunkt fügt ein Blatt im Baum console.inputTree unter dem letztem Blatt hinzu.",
"A menu item adds leaf to tree console.inputTree by insertleaf after the last leaf of the branch chosen.",
}
commentsTable["add leaf to console.inputTree by insertleaf after the last leaf of the branch chosen from clipboard"]={
"Ein Kontextmenüpunkt fügt aus der Zwischenablage ein Blatt im Baum console.inputTree unter dem letztem Blatt hinzu.",
"A menu item adds leaf to tree console.inputTree by insertleaf after the last leaf of the branch from clipboard chosen.",
}
commentsTable["add leaf to console.outputTree by insertleaf after the last leaf of the branch chosen"]={
"Ein Kontextmenüpunkt fügt ein Blatt im Baum console.outputTree unter dem letztem Blatt hinzu.",
"A menu item adds leaf to tree console.outputTree by insertleaf after the last leaf of the branch chosen.",
}
commentsTable["add leaf to console.outputTree by insertleaf after the last leaf of the branch chosen from clipboard"]={
"Ein Kontextmenüpunkt fügt aus der Zwischenablage ein Blatt im Baum console.outputTree unter dem letztem Blatt hinzu.",
"A menu item adds leaf to tree console.outputTree by insertleaf after the last leaf of the branch from clipboard chosen.",
}




commentsTable["add branch to tree by insertbranch from clipboard"]={
"Ein Kontextmenüpunkt fügt einen Ast darunter aus der Zwischenablage hinzu.",
"A menu item adds branch to tree by insertbranch from clipboard.",
}
commentsTable["add branch to console.outputTree by insertbranch from clipboard"]={
"Ein Kontextmenüpunkt fügt einen Ast im Baum console.outputTree darunter aus der Zwischenablage hinzu.",
"A menu item adds branch to tree console.outputTree by insertbranch from clipboard.",
}
commentsTable["add branch to console.commandTree by insertbranch from clipboard"]={
"Ein Kontextmenüpunkt fügt einen Ast im Baum console.commandTree darunter aus der Zwischenablage hinzu.",
"A menu item adds branch to tree console.commandTree by insertbranch from clipboard.",
}
commentsTable["add branch to console.inputTree by insertbranch from clipboard"]={
"Ein Kontextmenüpunkt fügt einen Ast im Baum console.inputTree darunter aus der Zwischenablage hinzu.",
"A menu item adds branch to tree console.inputTree by insertbranch from clipboard.",
}

commentsTable["add branch to tree by insertbranch"]={
"Ein Kontextmenüpunkt fügt einen Ast darunter hinzu.",
"A menu item adds branch to tree by insertbranch.",
}

commentsTable["add branch to console.outputTree by insertbranch"]={
"Ein Kontextmenüpunkt fügt einen Ast zum Baum console.outputTree darunter hinzu.",
"A menu item adds branch to tree console.outputTree by insertbranch.",
}
commentsTable["add branch to console.commandTree by insertbranch"]={
"Ein Kontextmenüpunkt fügt einen Ast zum Baum console.commandTree darunter hinzu.",
"A menu item adds branch to tree console.commandTree by insertbranch.",
}
commentsTable["add branch to console.inputTree by insertbranch"]={
"Ein Kontextmenüpunkt fügt einen Ast zum Baum console.inputTree darunter hinzu.",
"A menu item adds branch to tree console.inputTree by insertbranch.",
}



commentsTable["search for valid tree"]={
"Die Inputdatei wird durchsucht, ob sie einen gültigen Baum hat.",
"In the input file the search is done to see whether there is a valid tree.",
}

commentsTable["function for deleting all nodes of an given tree, but that does not delete the tree"]={
"Eine Funktion wird definiert, die die Tiefe wird berechnet, um die Anzahl Rekursionen zu begrenzen.",
"A function is defined that deletes all nodes of an given tree, but does not delete the tree.",
}
commentsTable["calculate the depth to reduce number of recursions"]={
"Die Tiefe wird berechnet, um die Anzahl Rekursionen zu begrenzen.",
"The depth is calculated to reduce the number of recursions.",
}
commentsTable["if no valid tree is found in manual tree then take the securised file"]={
"Wenn kein gültiger Baum als Lua-Tabelle gefunden wird, wird die Sicherungskopie als Baum genommen.",
"If no valid tree as a Lua table is found in manual tree then the securised file is taken.",
}
commentsTable["securise file with date and with standard name"]={
"Die Datei wird mit Datumstempel und Standardnamen gesichert.",
"The file is saved with date and with standard name.",
}
commentsTable["empty temporary tree needed to copy node with all its child nodes"]={
"Ein leerer temporärer Baum als Lua-Tabelle wird benötigt, um einen ausgewählten Knoten mit allen seinen Unterknoten zu kopieren.",
"A empty temporary tree as Lua table is defined because it is needed to copy a selected node with all its child nodes.",
}
commentsTable["function for sorting the tree alphabetically"]={
"Eine Funktion dient dem alphabetischen Sortieren des Baumes.",
"A function is used to sort alphabetically the tree.",
}
commentsTable["button for alphabetic sort of the tree"]={
"Eine Schaltfläche dient dem alphabetischen Sortieren des Baumes.",
"A button is used to sort alphabetically the tree.",
}
commentsTable["button for building tree with new directory"]={
"Eine Schaltfläche dient dazu, das Zielverzeichnis als Baum darzustellen.",
"A button is used to show the goal directory as a tree.",
}

commentsTable["button for building tree with new directory without versions"]={
"Eine Schaltfläche dient dazu, das Zielverzeichnis ohne Versionsdateien als Baum darzustellen.",
"A button is used to show the goal directory without file versions as a tree.",
}
commentsTable["button for building tree with start directory without versions"]={
"Eine Schaltfläche dient dazu, das Quellverzeichnis ohne Versionsdateien als Baum darzustellen.",
"A button is used to show the start directory without file versions as a tree.",
}
commentsTable["button for building tree with SQL"]={
"Eine Schaltfläche dient dazu, das SQL als Baum darzustellen.",
"A button is used to show the SQL as a tree.",
}
commentsTable["button for building tree with Excel formula"]={
"Eine Schaltfläche dient dazu, die Excel-Formel als Baum darzustellen.",
"A button is used to show the Excel formula as a tree.",
}
commentsTable["button for copying page as a Lua tree"]={
"Eine Schaltfläche dient dazu, die Html-Seite als Baum zu kopieren.",
"A button is used to copy the site page as a tree.",
}
commentsTable["button for copying page as a pure programm"]={
"Eine Schaltfläche dient dazu, die Html-Seite als Programm zu kopieren.",
"A button is used to copy the site page as a programm.",
}
commentsTable["button for copying page as a programm with comments"]={
"Eine Schaltfläche dient dazu, die Html-Seite als Programm mit Kommentaren zu kopieren. Die Kommentarzeichen werden in einer Textbox gezeigt und können dort verändert werden.",
"A button is used to copy the site page as a programm with comments. The comment characters are shown in a textbox and can be changed there.",
}

commentsTable["filter all leafs under the branch for pattern in console prompt"]={
"Ein Kontextmenüpunkt filtert alle Blätter unter dem Ast nach einem Muster, das im Konsolen-Prompt-Textfeld eingegeben ist.",
"A menu item filters all leafs under the branch for pattern in console prompt.",
}

commentsTable["button for saving tree"]={
"Eine Schaltfläche dient dazu, den Baum als Lua-Tabelle zu speichern.",
"A button is used to save the tree as a Lua table.",
}
commentsTable["rename node and rename action for other needs of tree"]={
"Ein Kontextmenüpunkt ruft das zusätzliche Fenster auf, um den Knoten umzubenennen, also den Text zu ändern.",
"A menu item opens the additional dialog to rename node and rename action for other needs of tree.",
}
commentsTable["rename node and rename action for other needs of console.commandTree"]={
"Ein Kontextmenüpunkt ruft das zusätzliche Fenster auf, um den Knoten im Baum console.commandTree umzubenennen, also den Text zu ändern.",
"A menu item opens the additional dialog to rename node and rename action for other needs of tree console.commandTree.",
}
commentsTable["rename node and rename action for other needs of console.inputTree"]={
"Ein Kontextmenüpunkt ruft das zusätzliche Fenster auf, um den Knoten im Baum console.inputTree umzubenennen, also den Text zu ändern.",
"A menu item opens the additional dialog to rename node and rename action for other needs of tree console.inputTree.",
}
commentsTable["rename node and rename action for other needs of console.outputTree"]={
"Ein Kontextmenüpunkt ruft das zusätzliche Fenster auf, um den Knoten des Baumes console.outputTree umzubenennen, also den Text zu ändern.",
"A menu item opens the additional dialog to rename node and rename action for other needs of tree console.outputTree.",
}
commentsTable["copy a version of the file selected in the tree and give it the next version number"]={
"Ein Kontextmenü stellt eine Kopie der Datei des ausgewählten Knotens her und vergibt ihr die nächste Versionsnummer.",
"A menu item copies a version of the file selected in the tree and gives it the next version number.",
}
commentsTable["copy a version of the file selected in the console.commandTree and give it the next version number"]={
"Ein Kontextmenü stellt eine Kopie der Datei des ausgewählten Knotens des Baumes console.commandTree her und vergibt ihr die nächste Versionsnummer.",
"A menu item copies a version of the file selected in the tree console.commandTree and gives it the next version number.",
}
commentsTable["copy a version of the file selected in the console.outputTree and give it the next version number"]={
"Ein Kontextmenü stellt eine Kopie der Datei des ausgewählten Knotens des Baumes console.outputTree her und vergibt ihr die nächste Versionsnummer.",
"A menu item copies a version of the file selected in the tree console.outputTree and gives it the next version number.",
}
commentsTable["copy a version of the file selected in the console.inputTree and give it the next version number"]={
"Ein Kontextmenü stellt eine Kopie der Datei des ausgewählten Knotens des Baumes console.inputTree her und vergibt ihr die nächste Versionsnummer.",
"A menu item copies a version of the file selected in the tree console.inputTree and gives it the next version number.",
}
commentsTable["move a version of the file selected in the tree1 and give it the next version number"]={
"Ein Kontextmenü benennt der Datei des ausgewählten Knotens im ersten Baum um und vergibt ihr die nächste Versionsnummer.",
"A menu item moves a version of the file selected in the first tree and gives it the next version number.",
}

commentsTable["button for copy and paste all missing files in goal directory"]={
"Eine Schaltfläche kopiert alle Dateien aus dem Quellverzeichnis, die im Zielverzeichnis fehlen.",
"A button copies and pastes all missing files from the start directory in the goal directory.",
}

commentsTable["pick file selected in the tree2"]={
"Ein Kontextmenü kopiert den Dateinamen der Datei des ausgewählten Knotens in die Zwischenablage, um diese ins Zielverzeichnis einfügen zu können.",
"A menu item copies the file selected in the first tree in the clipboard to be able to paste it in the goal directory.",
}
commentsTable["button paste file picked"]={
"Eine Schaltfläche fügt die Datei mit dem Namen aus der Zwischenablage ins Zielverzeichnis ein. Die alte Datei wird vorher mit der nächsten Versionsnummer abgespeichert.",
"A button pastes the file in the clipboard in the goal directory. The old file is moved before with the next version number.",
}

commentsTable["pick file selected in the tree2 and copy it in goal directory with versioning"]={
"Ein Kontextmenü kopiert den Dateinamen der Datei des ausgewählten Knotens in die Zwischenablage, fügt diese ins Zielverzeichnis mit einer Versionkopie der alten Datei ein und vergleicht Quell- und Zielordner.",
"A menu item copies the file selected in the first tree in the clipboard, pastes it in the goal directory with a version copy of the old file and compares the start with the goal directory.",
}
commentsTable["libraries for images"]={
"Bibliotheken für Bilder werden benötigt.",
"Libraries for images are needed.",
}
commentsTable["libraries for videos"]={
"Bibliotheken für Videos werden benötigt.",
"Libraries for videos are needed.",
}
commentsTable["convert XML to Lua table"]={
"Die XML-Datei wird in eine Lua-Tabelle umgewandelt.",
"The XML file is converted in a Lua table.",
}
commentsTable["function string:split() for splittings strings"]={
"Die Funktion, um Texte zu splitten, hat als erstes Argument den Text, der gesplittet werden soll, und als zweites Argument das Pattern, nach dem der Text gesplittet oder aufgeteilt werden soll. Die Funktion gibt eine Tabelle zurück, die alle Untertextbausteine ohne das Pattern zum Splitten enthält.",
"The function for splittings strings, the first argument is the string, which should be splitted and the second argument is the pattern, were the string is split/separated. The function returns a value as a table, containg all the substrings without the splitting pattern",
}
commentsTable["write Lua script"]={
"Das Lua-Skript wird geschrieben.",
"The Lua script is written.",
}
commentsTable["read XML File"]={
"Die XML-Datei wird gelesen.",
"The XML file is read.",
}
commentsTable["export pdf files to text if there is no export or if the date of the export to text is older than the date of the pdf file"]={
"Die PDF-Dateien werden exportiert, wenn es noch keinen Export gab oder das Datum des letzten Exports älter als das Datum der PDF-Datei ist.",
"The pdf files are exported to text if there is no export or if the date of the export to text is older than the date of the pdf file.",
}
commentsTable["read text file names of the securisations in a Lua table"]={
"Die Textdateinnamen der Sicherung werden in einer Lua-Tabelle gesammelt.",
"The text file names of the securisations are collected in a Lua table.",
}
commentsTable["button for expand and collapse"]={
"Eine Schaltfläche dient dem Ein- und Ausklappen. Es kann nach einem Suchwort oder nach der Ebene des ausgewählten Knotens ein- und ausgeklappt werden.",
"A button for expand and collapse the nodes is build. This button can expand and collapse by search word or the level of the selected node.",
}
commentsTable["read pdf file names of the directory in a Lua table"]={
"Die PDF-Dateinnamen in dem Verzeichnis werden in einer Lua-Tabelle gesammelt.",
"The pdf file names of the directory are collected in a Lua table.",
}
commentsTable["collect file names from tree"]={
"Die Dateinnamen werden aus dem Baum heraus gesammelt.",
"The file names are collected from the tree.",
}
commentsTable["initalize clipboard"]={
"Die Zwischenablage wird initialisiert und zugänglich gemacht.",
"The clipboard is initalized and made available.",
}
commentsTable["collect data with curl as an example"]={
"Die Daten werden mit dem Konsolen-Befehl curl als Beispiel gesammelt.",
"The data are collected with curl, a command from the console, as an example.",
}
commentsTable["read html text file"]={
"Die Html-Textdatei wird gelesen.",
"The html text file is read.",
}
commentsTable["read data from textfile"]={
"Die Textdatei wird gelesen.",
"The text file is read.",
}
commentsTable["build tree from html text file"]={
"Der Baum wird auf Grundlage der Html-Textdatei gebildet.",
"The tree is built from html text file.",
}
commentsTable["library"]={
"Die Bibliothek wird eingebunden.",
"The library is made available.",
}
commentsTable["libraries"]={
"Die Bibliotheken werden eingebunden.",
"The libraries are made available.",
}
commentsTable["libraries and clipboard"]={
"Die Bibliotheken und die Zwischenablage werden eingebunden.",
"The libraries and the clipboard are made available.",
}
commentsTable["goal repository"]={
"Das Zielverzeichnis wird festgelegt.",
"The goal repository is defined.",
}
commentsTable["original repository"]={
"Das ursprüngliche Verzeichnis wird festgelegt.",
"The original repository is defined.",
}
commentsTable["put dynamic in the tree"]={
"Der dynamische Teil der gesammelten Daten wird in die Baumansicht eingebaut.",
"The dynamic part of the collected data is put in the tree.",
}
commentsTable["button for search in tree with paths as result"]={
"Eine Schaltfläche für die Suche im Baum mit dem Ergebnis als Pfade wird gebildet.",
"A button for search in tree with paths as result is built.",
}
commentsTable["function for collection without the files and directories being in manual tree"]={
"Eine Funktion wird definiert, um die Daten ohne die Dateien und Verzeichnisse zu sammeln, die schon im manuellen Baum sind.",
"A function is defined for collection without the files and directories being in manual tree.",
}
commentsTable["collect data about files and directories on the device not being in the manual tree"]={
"Die Daten über die Dateien und Verzeichnisse auf dem Gerät werden ohne die Dateien und Verzeichnisse, die schon im manuellen Baum sind, gesammelt.",
"Data about files and directories on the device not being in the manual tree are collected.",
}
commentsTable["dynamic collection of data for the tree"]={
"Die Daten werden dynamisch für die Baumansicht gesammelt.",
"There is a dynamic collection of data for the tree.",
}
commentsTable["class for the frame"]={
"Eine Klasse für den Frame wird eingebunden, um die graphische Benutzeroberfläche zu bilden.",
"The class for the frame is bound to build a graphical user interface.",
}
commentsTable["border Layout"]={
"Eine Klasse für den Layout als Border Layout wird eingebunden, um die graphische Benutzeroberfläche in fünf Felder aufzuteilen.",
"The class for the Layout as Border Layout is bound to divide the graphical user interface in five fields.",
}
commentsTable["build the frame and get content"]={
"Die graphische Benutzeroberfläche wird gebildet der Inhalt zugänglich gemacht.",
"The graphical user interface is built and the content is made available.",
}
commentsTable["button for changing the tree"]={
"Eine Schaltfläche wird zur Veränderung der Baumansicht definiert.",
"A button for changing the tree is defined.",
}
commentsTable["constants for the GUI"]={
"Konstanten für die graphische Benutzeroberfläche werden definiert, um die vertikalen und horizontalen Bildlaufleisten einzubauen.",
"Constants are defined to have vertical and horizontal scrollbars.",
}
commentsTable["read input tree"]={
"Die Input-Baumansicht wird von einer Datei gelesen.",
"The input tree is read from a file.",
}
commentsTable["apply the recursive function and build html file"]={
"Mit einer rekursiven Funktion wird die Html-Datei gebildet.",
"The recursive function is applied and builds the html file.",
}
commentsTable["collect data about files and directories on the device"]={
"Die Daten über die Dateien und Verzeichnisse auf dem Gerät werden gesammelt.",
"Data about files and directories on the device are collected.",
}
commentsTable["list files and repositories for Touch Lua"]={
"Die Daten über die Dateien und Verzeichnisse für Touch Lua auf dem Gerät werden gesammelt.",
"Data about files and directories for Touch Lua on the device are collected.",
}
commentsTable["function to build recursively the tree"]={
"Eine rekursive Funktion wird definiert, um die Baumansicht rekursiv zu bilden.",
"A recursive function is defined to build recursively the tree.",
}
commentsTable["tree as Lua table"]={
"Eine Lua-Tabelle für die Baumansicht wird zusammengestellt.",
"A Lua table for the tree is written.",
}
commentsTable["build the video"]={
"Das Video wird aufgenommen und weiterverarbeitet.",
"The video is build and treated.",
}
commentsTable["capture video and connect to camera"]={
"Das Video durch die Verbindung mit der Kamera aufgenommen.",
"The video is build by connecting to the camera.",
}
commentsTable["function to build video in canvas"]={
"Eine Funktion, um das Video in einem Bildrahmen zu bilden wird genötigt.",
"A function to build video in canvas is needed.",
}
commentsTable["get image from camera"]={
"Das Bild wird von der Kamera aufgenommen.",
"The image is got from the camera.",
}
commentsTable["function to resize canvas"]={
"Eine Funktion, um den Bildrahmen in seiner Größe neu zu dimensionieren, wird benötigt.",
"A function to resize canvas is needed.",
}
commentsTable["set canvas with automatic size or manual size"]={
"Der Bildrahmen wird mit manueller oder automatischer Größe erstellt.",
"The canvas is set with automatic or manual size.",
}
commentsTable["optional save video"]={
"Optional kann das Video gespeicher werden.",
"The video can be optionally saved.",
}
commentsTable["no dialogs"]={
"Es gibt keine zusätzlichen Fenster neben dem Hauptfenster oder dem Skript.",
"There are no dialogs except the main dialog or the script.",
}
commentsTable["no functions"]={
"Es gibt keine Funktionen.",
"There are no functions.",
}
commentsTable["no dialogs needed since tree is fixed"]={
"Es gibt keine zusätzlichen Fenster neben dem Hauptfenster oder dem Skript, weil der Baum fix ist.",
"There are no dialogs except the main dialog or the script because the tree is fixed.",
}
commentsTable["securisation by allowing only necessary os.execute commands"]={
"Das Skript wird mit einer Einschränkung der Systembefehle versehen, so dass eine Sicherung realisiert wird. Das ist eine Methode des Sandboxings.",
"The securisation of the script is done by allowing only necessary system commands. This is a method of sandboxing.",
}
commentsTable["libraries for video and GUI"]={
"Die Bibliotheken für das Video und die graphische Benutzeroberfläche werden geladen.",
"The libraries for the video and the graphical user interface is loaded.",
}
commentsTable["set video live"]={
"Das Video von der Kamera wird eingeschaltet.",
"The video of the camera is set live.",
}
commentsTable["icon dialog"]={
"Ein zusätzliches Fenster wird benötigt, um die Symbole der Knoten zu definieren.",
"An additional dialog is needed to define the icons of the nodes.",
}
commentsTable["special video functions"]={
"Spezielle Funktionen für das Video werden definiert.",
"Special video functions are defined.",
}
commentsTable["basic data"]={
"In den Grunddaten werden die Bibliotheken, die Farben und grundlegende Variablen für die Benutzeroberfläche definiert.",
"Basic data are needed to define the used libraries, colors and variables for the graphical interface.",
}
commentsTable["show the dialog"]={
"Die graphische Benutzeroberfläche muss beim Starten des Skriptes angezeigt werden.",
"The graphical user interface must be shown when starting the script.",
}
commentsTable["show the frame"]={
"Die graphische Benutzeroberfläche muss beim Starten des Skriptes angezeigt werden.",
"The graphical user interface must be shown when starting the script.",
}
commentsTable["Main Dialog"]={
"Es handelt sich um eine graphische Benutzeroberfläche.",
"The script is a graphical user interface.",
}
commentsTable["building the dialog and put buttons, trees and preview together"]={
"Die Schaltflächen, die Baumansichten und das Vorschaufeld der graphischen Benutzeroberfläche werden in einem Hauptfenster zusammengestellt.",
"The buttons, trees and preview field of the graphical user interface are put in a main dialog.",
}
commentsTable["building the dialog and put buttons, trees and other elements together"]={
"Die Schaltflächen, die Baumansichten und die anderen Elemente der graphischen Benutzeroberfläche werden in einem Hauptfenster zusammengestellt.",
"The buttons, trees and other elements of the graphical user interface are put in a main dialog.",
}
commentsTable["building the dialog and put buttons and tree together depending on locking file"]={
"Die Schaltflächen und die Baumansicht der graphischen Benutzeroberfläche werden in einem Hauptfenster je nach Sperrdatei zusammengestellt. Beim ersten Öffnen wird die graphische Benutzeroberfläche mit Speicherbutton, sonst ohne Speicherbutton gezeigt.",
"The buttons and trees of the graphical user interface are put in a main dialog depending on the locking file. The first user opening the graphical user interface sees the save button, all other during the existence of the locking file do not see the save button.",
}
commentsTable["building the dialog and put trees and video together"]={
"Die Schaltflächen, die Baumansichten und das Videofeld der graphischen Benutzeroberfläche werden in einem Hauptfenster zusammengestellt.",
"The buttons, trees and video field of the graphical user interface are put in a main dialog.",
}
commentsTable["Main Loop"]={
"Die graphische Benutzeroberfläche und alle Dialoge müssen angezeigt werden.",
"The graphical user interface and all dialogs must be shown.",
}
commentsTable["variable for loop"]={
"Die graphische Benutzeroberfläche und alle Dialoge müssen angezeigt werden. Eine Hilfsvariable hilft dabei.",
"The graphical user interface and all dialogs must be shown. A variable is defined to perform this.",
}
commentsTable["preview field as scintilla editor"]={
"Ein Vorschau-Feld kann Text von Textdateien mit farblicher Markierung der Lua-Syntax anzeigen.",
"An area as preview can show text of text files with Lua syntax highlighting.",
}
commentsTable["text file field as scintilla editor 1"]={
"Ein Feld mit farblicher Markierung der Lua-Syntax zeigt die erste Textdatei.",
"An area with Lua syntax highlighting shows the first text file.",
}
commentsTable["text file field as scintilla editor 2"]={
"Ein Feld mit farblicher Markierung der Lua-Syntax zeigt die zweite Textdatei.",
"An area with Lua syntax highlighting shows the second text file.",
}
commentsTable["console objects"]={
"Die Konsole-Objekte, der Prompt, das Outputfenster und Textboxen werden definiert.",
"The console objects, the prompt, the output area and textboxes are defined.",
}
commentsTable["prompt text area"]={
"Als Konsolen-Objekte wird der Prompt als Textfeld definiert.",
"As a console objects the prompt is defined as a textbox.",
}
commentsTable["output in a standard way as text area replaced by tree"]={
"Der Output, der standardmäßig ein Textfeld ist wird durch eine Baumansicht ersetzt.",
"The output area which is in a standard way a text area is replaced by a tree.",
}
commentsTable["textboxes"]={
"Textfelder zeigen den Inhalt von Dateien oder Variablen.",
"Textboxes show the content of files or variables.",
}
commentsTable["checkboxes"]={
"Checkfelder mit einem Häkchen oder einem leeren Feld können an und ausgestellt werden.",
"Checkboxes can be checked ON or OFF.",
}
commentsTable["text areas"]={
"Textfelder zeigen den Inhalt von Dateien oder Variablen.",
"Textboxes show the content of files or variables.",
}
commentsTable["text area for search results and examples for changing the tree"]={
"Ein Textfeld wird angezeigt, um die Suchergebnisse und Beipiele für die Änderungen der Baumansicht zu zeigen.",
"A textbox is shown to show search results and examples for changing the tree.",
}
commentsTable["text area for search text and to change the tree with"]={
"Ein Textfeld wird angezeigt, um den Suchertext und die Änderungsanweisungen der Baumansicht einzugeben.",
"A textbox is shown to input search text and commands for changing the tree.",
}
commentsTable["button for search in TextHTMLtable"]={
"Eine Schaltfläche für die Suche in dem Webbrowser geht zur gefundenen Seite.",
"A button for the search in the webbrowser goes to the page found.",
}
commentsTable["button for search in tree"]={
"Eine Schaltfläche für die Suche in der Baumansicht öffnet einen Suchdialog, mit dem in der Baumstruktur die übergeordneten Knoten in rot, die Fundknoten in blau und die untergeordneten Knoten in grün gefärbt werden. Es kann auch mit einer Abwärts- und Aufwärtssuche direkt zu den Funkknoten gesprungen werden. Eine Suche in Textdateien ist ebenfalls möglich.",
"A button starts a dialog for the search in the tree, with which parent nodes on higher levels in the path are colored in red, found nodes are colored in blue and child nodes on lower levels are colored in green. It is also possible to go directly to the found nodes. A search in text files is possible.",
}
commentsTable["button for search in tree and tree2"]={
"Eine Schaltfläche für die Suche in beiden Baumansichten öffnet einen Suchdialog, mit dem in der Baumstruktur die übergeordneten Knoten in rot, die Fundknoten in blau und die untergeordneten Knoten in grün gefärbt werden. Es kann auch mit einer Abwärts- und Aufwärtssuche direkt zu den Funkknoten gesprungen werden. Eine Suche in Textdateien ist ebenfalls möglich.",
"A button starts a dialog for the search in both trees, with which parent nodes on higher levels in the path are colored in red, found nodes are colored in blue and child nodes on lower levels are colored in green. It is also possible to go directly to the found nodes. A search in text files is possible.",
}
commentsTable["button for search in tree2 and tree3"]={
"Eine Schaltfläche für die Suche in beiden Baumansichten öffnet einen Suchdialog, mit dem in der Baumstruktur die übergeordneten Knoten in rot, die Fundknoten in blau und die untergeordneten Knoten in grün gefärbt werden. Es kann auch mit einer Abwärts- und Aufwärtssuche direkt zu den Funkknoten gesprungen werden. Eine Suche in Textdateien ist ebenfalls möglich.",
"A button starts a dialog for the search in both trees, with which parent nodes on higher levels in the path are colored in red, found nodes are colored in blue and child nodes on lower levels are colored in green. It is also possible to go directly to the found nodes. A search in text files is possible.",
}
commentsTable["button for search in tree, tree1 and tree2"]={
"Eine Schaltfläche für die Suche in den drei Baumansichten öffnet einen Suchdialog, mit dem in der Baumstruktur die übergeordneten Knoten in rot, die Fundknoten in blau und die untergeordneten Knoten in grün gefärbt werden. Es kann auch mit einer Abwärts- und Aufwärtssuche direkt zu den Funkknoten gesprungen werden. Eine Suche in Textdateien ist ebenfalls möglich.",
"A button starts a dialog for the search in the three trees, with which parent nodes on higher levels in the path are colored in red, found nodes are colored in blue and child nodes on lower levels are colored in green. It is also possible to go directly to the found nodes. A search in text files is possible.",
}
commentsTable["button for search in tree, tree2 and tree3"]={
"Eine Schaltfläche für die Suche in den drei Baumansichten öffnet einen Suchdialog, mit dem in der Baumstruktur die übergeordneten Knoten in rot, die Fundknoten in blau und die untergeordneten Knoten in grün gefärbt werden. Es kann auch mit einer Abwärts- und Aufwärtssuche direkt zu den Funkknoten gesprungen werden. Eine Suche in Textdateien ist ebenfalls möglich.",
"A button starts a dialog for the search in the three trees, with which parent nodes on higher levels in the path are colored in red, found nodes are colored in blue and child nodes on lower levels are colored in green. It is also possible to go directly to the found nodes. A search in text files is possible.",
}
commentsTable["button to update tree2, mark non existing files in grey and copy node with path"]={
"Eine Schaltfläche aktualisiert die dynamische Baumansicht, prüft und markiert nicht existierende Dateien im manuellen Baum in grau und kopiert den ausgewählten Knoten in die Zwischenablage.",
"A button updates the dynamic second tree, marks non existing files in the manual tree in grey and copy selected node with path.",
}
commentsTable["button to update tree3"]={
"Eine Schaltfläche aktualisiert die Statistik in Form einer dritten Baumansicht.",
"A button updates the third tree, a statistic with the shape of a tree.",
}
commentsTable["button for loading tree"]={
"Eine Schaltfläche öffnet ein Dateiauswahlfenster, damit die Baumansicht mit einer Datei aktualisiert wird, sonst erfolgt eine Meldung, dass keine Datei ausgewählt wurde.",
"A button opens a file picker dialog to update the tree with a file, otherwise there is a message that no file is choosen.",
}
commentsTable["button for loading tree 1"]={
"Eine Schaltfläche öffnet ein Dateiauswahlfenster, damit die erste Baumansicht mit einer Datei aktualisiert wird, sonst erfolgt eine Meldung, dass keine Datei ausgewählt wurde.",
"A button opens a file picker dialog to update the first tree with a file, otherwise there is a message that no file is choosen.",
}
commentsTable["button for loading tree 2"]={
"Eine Schaltfläche öffnet ein Dateiauswahlfenster, damit die zweite Baumansicht mit einer Datei aktualisiert wird, sonst erfolgt eine Meldung, dass keine Datei ausgewählt wurde.",
"A button opens a file picker dialog to update the second tree with a file, otherwise there is a message that no file is choosen.",
}
commentsTable["button for loading all text files without versions in IUP Lua scripter found in first directory and subdirectories containing the search text"]={
"Eine Schaltfläche öffnet alle Dateien außer den Versionsdateien im IUP-Lua-Skripter, die in dem ersten Verzeichnis und seinen Unterverzeichnissen ist und die einen Suchtext enthalten.",
"A button loads all text files without versions in IUP Lua scripter found in first directory and subdirectories containing the search text.",
}
commentsTable["button to rotate image"]={
"Eine Schaltfläche dreht das Bild um 90 Grad nach rechts.",
"A button rotates the image by 90 degrees to the right.",
}
commentsTable["button for editing page with potential code"]={
"Eine Schaltfläche wird benötigt, um die Seite in den Editmodus zu bringen, so dass der potentielle Programmcode verändert werden kann.",
"A button for editing page is needed to be able to change the content of the site. Only text that can be used as a code is left in the page.",
}
commentsTable["button for not editing and go back to page"]={
"Eine Schaltfläche wird benötigt, um den Edit-Modus der Seite zu beenden und zur gespeicherten Seite zurückzugehen.",
"A button for leaving edit mode of the page is needed and going back to the page.",
}
commentsTable["button for screen capture"]={
"Eine Schaltfläche macht einen Bildschirmausdruck mit dem Knotentext als Dateinamen, falls möglich, sonst mit einem Standard-Dateinamen.",
"A button makes a screen capture with the node text as file name, if possible, otherwise with a default file name.",
}
commentsTable["button to show next image"]={
"Eine Schaltfläche zeigt das nächste Bild im selben Ordner nach der alphabetischen Sortierung.",
"A button shows the next image in the same directory alphabetically sorted.",
}
commentsTable["button for going to the previous page"]={
"Eine Schaltfläche zeigt das vorherige Blatt an.",
"A button shows the previous page.",
}
commentsTable["button for going to the next page"]={
"Eine Schaltfläche zeigt das nächste Blatt an.",
"A button shows the next page.",
}
commentsTable["button to show previous image"]={
"Eine Schaltfläche zeigt das voherige Bild im selben Ordner nach der alphabetischen Sortierung.",
"A button shows the previous image in the same directory alphabetically sorted.",
}
commentsTable["button exchange start and new directory"]={
"Eine Schaltfläche tauscht das Quell- mit dem Zielverzeichnis aus.",
"A button exchanges start and new directory.",
}
commentsTable["button to update indicators"]={
"Eine Schaltfläche aktualisiert die Bilanzkennzahlen.",
"A button updates the balance indicators.",
}
commentsTable["button to save version without buttons and menus to be fixed calculation"]={
"Eine Schaltfläche speichert die graphische Benutzeroberfläche als fixes Kalkulationsschema ohne Schaltflächen.",
"A button saves the graphical user interface as fixed calculation scheme without buttons.",
}
commentsTable["button to edit the relation table for node to function"]={
"Eine Schaltfläche öffnet ein Fenster zum Programmieren der Funktionszuordnung zu dem ausgewählten Knoten.",
"A button starts a dialog to edit the programm for the function of the selected node.",
}
commentsTable["button to edit the icon definition list"]={
"Eine Schaltfläche öffnet ein Fenster zum Programmieren der Symbole der Knoten.",
"A button starts a dialog to edit the programm for the icons of the nodes.",
}
commentsTable["webbrowser"]={
"Ein Webbrowser-Feld zeigt Inhalte von lokalen html-Seiten und von Intranet- sowie Internetseiten.",
"A webbrowser area shows the content of local html files, of intranet and internet sites.",
}
commentsTable["zoom the webbrowser"]={
"Das Webbrowser-Feld wird auf den angemessenen Zoomfaktor für den Start eingestellt.",
"The graphical user interface needs a webbrowser area.",
}
commentsTable["collection of tree data by applying the recursive function"]={
"Der rekursive Durchlauf durch die Baumstruktur wird angewendet.",
"The recursive traversation of the tree is to be applied.",
}
commentsTable["Beckmann und Partner colors"]={
"Die Beckmann & Partner Farben werden nach der Definition im Intranet festgelegt: Rot, Hellgrau, Grau und Blau.",
"The Beckmann & Partner colors are defined according to the intranet definition: red, light grey, grey and blue.",
}
commentsTable["color section"]={
"Die Farben werden festgelegt.",
"The colors are defined.",
}
commentsTable["color definitions"]={
"Die Farben werden für den Hintergrund (grau), die Schaltflächen (blau) und die Texte der Schaltflächen (weiß) festgelegt.",
"The colors are set for the background (grey), for the buttons (blue) and for the texts of the buttons (white).",
}
commentsTable["color of the console associated with the graphical user interface if started with lua54.exe and not wlua54.exe"]={
"Die Farben werden der mitlaufenden Konsole, falls mit Lua54.exe gestartet und nicht mit wLua4.exe werden auf Hellblau für den Hintergrund und Dunkelblau für die Schrift gesetzt.",
"The colors of the console associated with the graphical user interface if started with lua54.exe and not wlua54.exe are set for the background in light blue and for the text in dark blue.",
}
commentsTable["path of the graphical user interface and filename of this script"]={
"Der Pfad der graphischen Benutzeroberfläche und der Dateiname des Skriptes werden in Variablen geschrieben.",
"The path of the graphical user interface and filename of this script are put in variables.",
}
commentsTable["functions"]={
"Die Funktionen werden definiert.",
"The functions are defined.",
}
commentsTable["install skript documentation_tree.lua"]={
"Das Skript documentation_tree.lua wird in dem gleichen Verzeichnis wie die graphische Benutzeroberfläche installiert",
"The script documentation_tree.lua is installed in the same directory as the graphical user interface",
}
commentsTable["install skript documentation_tree_balance.lua"]={
"Das Skript documentation_tree_balance.lua wird in dem gleichen Verzeichnis wie die graphische Benutzeroberfläche installiert",
"The script documentation_tree_balance.lua is installed in the same directory as the graphical user interface",
}
commentsTable["install skript documentation_tree_balance_active.lua"]={
"Das Skript documentation_tree_balance_active.lua wird in dem gleichen Verzeichnis wie die graphische Benutzeroberfläche installiert",
"The script documentation_tree_balance_active.lua is installed in the same directory as the graphical user interface",
}
commentsTable["install skript documentation_tree_balance_indicators.lua"]={
"Das Skript documentation_tree_balance_indicators.lua wird in dem gleichen Verzeichnis wie die graphische Benutzeroberfläche installiert",
"The script documentation_tree_balance_indicators.lua is installed in the same directory as the graphical user interface",
}
commentsTable["install skript documentation_tree_balance_passive.lua"]={
"Das Skript documentation_tree_balance_passive.lua wird in dem gleichen Verzeichnis wie die graphische Benutzeroberfläche installiert",
"The script documentation_tree_balance_passive.lua is installed in the same directory as the graphical user interface",
}
commentsTable["install skript documentation_tree_script.lua"]={
"Das Skript documentation_tree_script.lua wird in dem gleichen Verzeichnis wie die graphische Benutzeroberfläche installiert",
"The script documentation_tree_script.lua is installed in the same directory as the graphical user interface",
}
commentsTable["install skript documentation_tree_statistics.lua"]={
"Das Skript documentation_tree_statistics.lua wird in dem gleichen Verzeichnis wie die graphische Benutzeroberfläche installiert",
"The script documentation_tree_statistics.lua is installed in the same directory as the graphical user interface",
}


commentsTable["general Lua functions"]={
"Die allgemeinen Lua-Funktionen werden definiert.",
"The general Lua functions are defined.",
}
commentsTable["function checking if file exits"]={
"Die Funktion, ob eine Datei existiert, wird definiert.",
"The function checking if file exits is defined.",
}
commentsTable["put the menu items together in the menu for tree"]={
"Die Kontextmenüpunkte werden in ein Kontextmenü für den Baum zusammengestellt.",
"The menu items are put together in the menu for tree.",
}
commentsTable["put the menu items together in the menu for console.commandTree"]={
"Die Kontextmenüpunkte werden in ein Kontextmenü für den Baum console.commandTree zusammengestellt.",
"The menu items are put together in the menu for tree console.commandTree.",
}
commentsTable["put the menu items together in the menu for console.inputTree"]={
"Die Kontextmenüpunkte werden in ein Kontextmenü für den Baum console.inputTree zusammengestellt.",
"The menu items are put together in the menu for tree console.inputTree.",
}
commentsTable["put the menu items together in the menu for console.outputTree"]={
"Die Kontextmenüpunkte werden in ein Kontextmenü für den Baum console.outputTree zusammengestellt.",
"The menu items are put together in the menu for tree console.outputTree.",
}
commentsTable["put the menu items together in the menu for tree2"]={
"Die Kontextmenüpunkte werden in ein Kontextmenü für den zweiten Baum zusammengestellt.",
"The menu items are put together in the menu for second tree.",
}
commentsTable["tree2 to explore thé computer"]={
"Eine Baumansicht zur Anzeige der Dateien und Unterverzeichnisse in einem Verzeichnis auf dem Rechner wird gebildet.",
"A tree with all files and subdirectories in a directory of a computer is build.",
}
commentsTable["tree3 to explore thé computer"]={
"Eine Baumansicht zur Anzeige der Verzeichnisse auf allen zugänglichen Laufwerken dem Rechner wird gebildet.",
"A tree with all directories on all drives of a computer is build.",
}
commentsTable["Timer for autosave of tree"]={
"Ein Timer wird aktiviert, um in regelmäßigen Zeitabständen die Datei zu speichern.",
"A timer is activated to autosave the file.",
}
commentsTable["statistics about the tree"]={
"Eine Statistik über die Baumansicht wird ausgegeben.",
"A statistics of the tree is printed.",
}
commentsTable["statistics about the pages"]={
"Eine Statistik über die Webseiten wird ausgegeben.",
"A statistics of the web pages is printed.",
}
commentsTable["read plugins directory"]={
"Das Verzeichnis, aus dem die Plugins geladen werden, wird gelesen.",
"The directory with the plugins is read to be able to load the plugins.",
}
commentsTable["optional: mark not existing files in grey (is possible only after having the GUI shown)"]={
"Optional können die nicht existierenden Dateien in grauer Farbe angezeigt werden.",
"Optionally not existing files are marked in grey.",
}
commentsTable["optional show properties of element"]={
"Optional können die Eigenschaften eines Elements in IUP in einem vorgefertigten Dialogfenster angezeigt werden.",
"Optionally the properties of an element can be shown in a prebuild dialog.",
}
commentsTable["load tree from self file"]={
"Die Baumansicht wird aus dem Skript selbst der Oberfläche heraus gestartet.",
"The tree is loaded from the script of the graphical interface itself.",
}
commentsTable["load tree from file"]={
"Die Baumansicht wird aus einer externen Datei heraus gestartet.",
"The tree is loaded from an external file.",
}
commentsTable["build MDI menu"]={
"Ein Menü für die multiplen Fenster (Multiple document interfaces) wird gebildet.",
"A MDI (multiple document interfaces) menu is built.",
}
commentsTable["build MDI subdialog"]={
"Ein Unterfenster für die multiplen Fenster (Multiple document interfaces) wird definiert.",
"A MDI (multiple document interfaces) subdialog is defined.",
}
commentsTable["load input tree from file"]={
"Die Baumansicht des Inputs wird aus einer externen Datei heraus gestartet.",
"The input tree is loaded from an external file.",
}
commentsTable["load output tree from file"]={
"Die Baumansicht des Outputs wird aus einer externen Datei heraus gestartet.",
"The output tree is loaded from an external file.",
}
commentsTable["load command tree from file"]={
"Die Baumansicht der Befehle wird aus einer externen Datei heraus gestartet.",
"The command tree is loaded from an external file.",
}
commentsTable["load tree2 from file"]={
"Die zweite Baumansicht wird aus einer externen Datei heraus gestartet.",
"The second tree is loaded from an external file.",
}
commentsTable["load tree3 from file"]={
"Die dritte Baumansicht wird aus einer externen Datei heraus gestartet.",
"The third tree is loaded from an external file.",
}
commentsTable["load tree1 from directory"]={
"Die erste Baumansicht wird aus einem Verzeichnisinhalt heraus gestartet.",
"The first tree is loaded from the content of a directory.",
}
commentsTable["load tree2 from directory"]={
"Die zweite Baumansicht wird aus einem Verzeichnisinhalt heraus gestartet.",
"The second tree is loaded from the content of a directory.",
}
commentsTable["load tree in webbrowser"]={
"Die Baumansicht wird in ein Webbrowser-Feld geladen.",
"The tree is loaded in a webbrowser area.",
}
commentsTable["load the data use recursive function to build variable inputs from tree as Lua variables"]={
"Die Daten in der Input-Baumansicht werden so geladen, dass sie die geeigneten Knoteninformationen als Lua-Variablen zur Verfügung stehen.",
"The data of the tree are loaded in such a manner that node informations are available as Lua variables.",
}
commentsTable["build tree"]={
"Die Baumansicht wird aus vorher ermittelten Daten gebildet.",
"The tree is build from data previously collected.",
}
commentsTable["build recursively the tree"]={
"Die Baumansicht wird rekursiv aus vorher ermittelten Daten gebildet.",
"The tree is build recursively from data previously collected.",
}
commentsTable["close Main Dialog"]={
"Die graphische Benutzeroberfläche muss ordentlich beendet werden.",
"The graphical user interface must be closed correctly.",
}
commentsTable["callback on close of the main dialog for saving or restoring"]={
"Beim Beenden der graphischen Benutzeroberfläche wird abgefragt, ob gespeichert oder wiederhergestellt wird.",
"At the close of the graphical user interface the user must answer to save or to restore the data.",
}
commentsTable["callback on close of the main dialog for saving"]={
"Beim Beenden der graphischen Benutzeroberfläche wird abgefragt, ob gespeichert wird.",
"At the close of the graphical user interface the user must answer to save the data.",
}
commentsTable["callback on close of the main dialog for saving and unlocking"]={
"Beim Beenden der graphischen Benutzeroberfläche wird abgefragt, ob gespeichert wird. Die Sperrdatei wird gelöscht.",
"At the close of the graphical user interface the user must answer to save the data. The locking file is deleted.",
}
commentsTable["write locking file if it does not exist"]={
"Eine Sperrdatei wird geschrieben, falls diese nicht existiert.",
"A locking file is to be written if it does not exist.",
}
commentsTable["dialogs"]={
"Zusatzfenster zusätzlich zum Hauptfenster werden benötigt.",
"An additional dialogs are needed.",
}


commentsTable["expand and collapse dialog"]={
"Ein Zusatzfenster zum Ein- und Ausklappen wird benötigt.",
"An additional dialog to expand and collapse nodes is needed.",
}
commentsTable["rename dialog"]={
"Ein Zusatzfenster zur Änderung des Textes eines Knotens wird benötigt.",
"An additional dialog to rename the nodes is needed.",
}
commentsTable["command rename dialog"]={
"Ein Zusatzfenster zur Änderung des Textes eines Knotens des Befehle-Baums wird benötigt.",
"An additional dialog to rename the nodes of a command tree is needed.",
}
commentsTable["output rename dialog"]={
"Ein Zusatzfenster zur Änderung des Textes eines Knotens des Output-Baums wird benötigt.",
"An additional dialog to rename the nodes of a output tree is needed.",
}

commentsTable["change page dialog"]={
"Ein Zusatzfenster zur Änderung des Inhaltes einer Seite wird benötigt.",
"An additional dialog to change the page content is needed.",
}


commentsTable["no buttons"]={
"Es werden keine Schaltflächen benötigt.",
"No buttons are needed.",
}
commentsTable["buttons"]={
"Es werden Schaltflächen benötigt.",
"Buttons are needed.",
}


commentsTable["no context menus"]={
"Es werden keine Kontextmenüs benötigt.",
"No context menus are needed.",
}
commentsTable["menu of tree"]={
"Es wird ein Kontextmenü für die Baumansicht benötigt.",
"A context menu for the tree are needed.",
}
commentsTable["menu of tree1"]={
"Es wird ein Kontextmenü für die erste Baumansicht benötigt.",
"A context menu for the first tree are needed.",
}
commentsTable["function to delete the first elements if it is a number"]={
"Eine Funktion wir benötigt, um das erste Element zu löschen, wenn es eine Zahl ist.",
"A function to delete the first elements if it is a number is needed.",
}
commentsTable["menu of tree2"]={
"Es wird ein Kontextmenü für die zweite Baumansicht benötigt.",
"A context menu for the second tree are needed.",
}
commentsTable["function to use the recursion until depth to avoid endless loop"]={
"Eine Funktion wird benötigt, um die Rekursion bis zur Tiefe anzuwenden, damit es keinen unendlichen Regress gibt.",
"A function to use the recursion until depth to avoid endless loop is needed.",
}
commentsTable["function for visualisation of the backward recursion to have values in the same line as the texts"]={
"Eine Funktion wird benötigt, um die Rückwärtsrekursion zu visualisieren, damit die Werte in den gleichen Zeilen wie die Texte sind.",
"A function for visualisation of the backward recursion to have values in the same line as the texts is needed.",
}
commentsTable["function for recursion to build the sum backwards"]={
"Eine Funktion wird benötigt, um die Rekursion anzuwenden, damit die Summen entlang des Baumes berechnet werden.",
"A function for recursion to build the sum backwards is needed.",
}

commentsTable["write out the paths in file"]={
"Für die Suchergebnisse werden die Pfade in ermittelt. Die Pfade sind alle übergeordneten Knoten ab dem Stammknoten bis jedem einzelnen Knoten.",
"The paths for the results of searches are written. The paths are all the parent nodes starting with the root until to each given node.",
}
commentsTable["tree in scrollpane added to content"]={
"Die Baumstruktur wird in der graphischen Benutzeroberfläche gezeigt.",
"The tree is shown in the graphical user interface.",
}
commentsTable["button for editing the page"]={
"Eine Schaltfläche editiert die Seite. Diese kann in einem zusätzlichen Fenster verändert und abgespeichert werden.",
"A button edits the page. The page can be changed and saved.",
}
commentsTable["button for deleting the page"]={
"Eine Schaltfläche löscht die Seite, wenn bestätigt wird.",
"A button deletes the page if confirmed.",
}
commentsTable["button for going one page forward"]={
"Eine Schaltfläche geht eine Seite vor.",
"A button goes one page forward.",
}
commentsTable["button for going one page back"]={
"Eine Schaltfläche geht eine Seite zurück.",
"A button goes one page back.",
}
commentsTable["button for normal screen"]={
"Eine Schaltfläche stellt einen normalen Bildschirm wieder her, insbesondere wenn es vorher ein Vollbildschirm war.",
"A button restore the normal screen, especially when it was a fullscreen before.",
}
commentsTable["button for fullscreen"]={
"Eine Schaltfläche stellt einen Vollbildschirm her.",
"A button changes in fullscreen mode.",
}
commentsTable["function which deletes nodes in the second tree, if they occur in the tree of the first argument"]={
"Eine Funktion wird definiert, welche Knoten im zweiten Baum löscht, wenn sie im ersten Baum als erstes Argument existieren.",
"A function is defined which deletes nodes in the second tree, if they occur in the tree of the first argument.",
}
commentsTable["functions which compares first text file with second text file"]={
"Es werden Funktionen definiert, um zwei Textdateien vergleichen zu können.",
"Functions are defined which compares first text file with second text file.",
}

commentsTable["functions for summing up in the tree"]={
"Es werden Funktionen definiert, um die Summierung entlang des Baumes durchführen zu können.",
"Functions are defined for summing up in the tree.",
}
commentsTable["Mouse listener for the tree to start programms"]={
"Durch Mausklick werden Programme mit dem Namen des Knotens gestartet.",
"Programms with the name of the node are startet with mouse click.",
}
commentsTable["start file of node of tree in IUP Lua scripter or start empty file in notepad or start empty scripter"]={
"Mit einem Kontextmenüpunkt wird die Datei mit dem Knotennamen im IUP-Lua-Skripter geöffnet. Wenn diese Datei leer ist, aber existiert, wird sie im Notepad geöffnet. Wenn es kein gültiger Dateiname ist, dann wird ein leeres IUP-Lua-Skripter geöffnet.",
"With a menu item a file of nodename of the tree is opened in IUP Lua scripter or an empty, but existing file is startet in notepad with the name of the node or an empty scripter is started if there is no valid file name of the node.",
}
commentsTable["start file of node of console.commandTree in IUP Lua scripter or start empty file in notepad or start empty scripter"]={
"Mit einem Kontextmenüpunkt wird die Datei mit dem Knotennamen im Baum console.commandTree im IUP-Lua-Skripter geöffnet. Wenn diese Datei leer ist, aber existiert, wird sie im Notepad geöffnet. Wenn es kein gültiger Dateiname ist, dann wird ein leeres IUP-Lua-Skripter geöffnet.",
"With a menu item a file of nodename of the tree console.commandTree is opened in IUP Lua scripter or an empty, but existing file is startet in notepad with the name of the node or an empty scripter is started if there is no valid file name of the node.",
}
commentsTable["start file of node of console.inputTree in IUP Lua scripter or start empty file in notepad or start empty scripter"]={
"Mit einem Kontextmenüpunkt wird die Datei mit dem Knotennamen im Baum console.inputTree im IUP-Lua-Skripter geöffnet. Wenn diese Datei leer ist, aber existiert, wird sie im Notepad geöffnet. Wenn es kein gültiger Dateiname ist, dann wird ein leeres IUP-Lua-Skripter geöffnet.",
"With a menu item a file of nodename of the tree console.inputTree is opened in IUP Lua scripter or an empty, but existing file is startet in notepad with the name of the node or an empty scripter is started if there is no valid file name of the node.",
}
commentsTable["start file of node of tree2 in IUP Lua scripter or start empty file in notepad or start empty scripter"]={
"Mit einem Kontextmenüpunkt wird die Datei mit dem Knotennamen des zweiten Baumes im IUP-Lua-Skripter geöffnet. Wenn diese Datei leer ist, aber existiert, wird sie im Notepad geöffnet. Wenn es kein gültiger Dateiname ist, dann wird ein leeres IUP-Lua-Skripter geöffnet.",
"With a menu item a file of nodename of the second tree is opened in IUP Lua scripter or an empty, but existing file is startet in notepad with the name of the node or an empty scripter is started if there is no valid file name of the node.",
}
commentsTable["start the file or repository of the node of tree"]={
"Mit einem Kontextmenüpunkt wird die Datei oder der Ordner des Knotennamens geöffnet oder gestartet.",
"With a menu item the file or repository of the node of tree is started.",
}
commentsTable["start the file or repository of the node of console.commandTree"]={
"Mit einem Kontextmenüpunkt wird die Datei oder der Ordner des Knotennamens des Baumes console.commandTree geöffnet oder gestartet.",
"With a menu item the file or repository of the node of tree console.commandTree is started.",
}
commentsTable["start the file or repository of the node of console.inputTree"]={
"Mit einem Kontextmenüpunkt wird die Datei oder der Ordner des Knotennamens des Baumes console.inputTree geöffnet oder gestartet.",
"With a menu item the file or repository of the node of tree console.inputTree is started.",
}
commentsTable["start the file or repository of the node of tree2"]={
"Mit einem Kontextmenüpunkt wird die Datei oder der Ordner des Knotennamens im zweiten Baum geöffnet oder gestartet.",
"With a menu item the file or repository of the node of second tree is started.",
}
commentsTable["start the file or repository of the node of console.outputTree"]={
"Mit einem Kontextmenüpunkt wird die Datei oder der Ordner des Knotennamens des Baumes console.outputTree geöffnet oder gestartet.",
"With a menu item the file or repository of the node of tree console.outputTree is started.",
}
commentsTable["button for loading text from text file or loading standard text file"]={
"Eine Standardtextdatei wird in eine Textbox als Standard, wenn die Textdatei des Knotennamens existiert, wird diese geladen.",
"A standard text file is loaded into a textbox as a default. If the text file of the node name exists, this file is loaded into a textbox.",
}
commentsTable["load standard text file"]={
"Eine Standardtextdatei wird in eine Textbox geladen.",
"A standard text file is loaded into a textbox.",
}
commentsTable["fill the tree with version informations if tree not build by file"]={
"Eine Standardbaumstruktur wird geladen, wenn es keine Textdatei für eine Baumansicht gibt.",
"A standard tree is loaded if there is no text file of a tree that can be loaded.",
}
commentsTable["icons adopted in tree"]={
"Die Bilder für die Knoten werden angewendet. Ein Knoten als Eingabefeld wird mit einem Pfeil nach oben und unten, eine Funktion des Knotens wird mit ein Bild Klammer auf Klammer zu und ein Knoten als Ergebnisfeld wird als Pfeil nach rechts symbolisiert.",
"The images for the nodes are applied. A node as input data is represented by an arrow to top and bottom, a function of a node is represented by a opening and closing round bracket, and a node as a result field is represented by an arrow to the right.",
}
commentsTable["icon definitions"]={
"Die Bilder für die Knoten werden definiert. Ein Knoten als Eingabefeld wird mit einem Pfeil nach oben und unten, eine Funktion des Knotens wird mit ein Bild Klammer auf Klammer zu und ein Knoten als Ergebnisfeld wird als Pfeil nach rechts symbolisiert.",
"The images for the nodes are defined. A node as input data is represented by an arrow to top and bottom, a function of a node is represented by a opening and closing round bracket, and a node as a result field is represented by an arrow to the right.",
}
commentsTable["function for keys pressed in main dialog for full screen and closing"]={
"Die F1-Taste wird für die Vollbildansicht bzw. das Verlassen dieser verwendet, die Esc-Taste dient dem Schließen der graphischen Benutzeroberfläche.",
"The key F1 is to use for fullscreen on resp. off. The key Esc is to close the main dialog.",
}
commentsTable["callback to add branch with drag & drop"]={
"Durch Ziehen einer Datei aus dem MS-Explorer auf ein Feld in der graphischen Benutzeroberfläche wird ein Ast im Baum unterhalb der mit dem Cursor markierten Stelle mit dem Dateinamen erstellt.",
"With a file dragged from the MS explorer to a field in the graphical user interface the filename is inserted as a branch under the node marked with the cursor.",
}
commentsTable["callback to add leaf with drag & drop"]={
"Durch Ziehen einer Datei aus dem MS-Explorer auf ein Feld in der graphischen Benutzeroberfläche wird ein Blatt im Baum unterhalb der mit dem Cursor markierten Stelle mit dem Dateinamen erstellt.",
"With a file dragged from the MS explorer to a field in the graphical user interface the filename is inserted as a leaf under the node marked with the cursor.",
}
commentsTable["drag & drop text area branch"]={
"Ein Feld in der graphischen Benutzeroberfläche ermöglicht das Einfügen eines Dateinamens als Ast aus dem MS-Explorer mit Drag & Drop.",
"A field in the graphical user interface gives the possibility to drag & drop a filename in the tree as a branch.",
}
commentsTable["drag & drop text area leaf"]={
"Ein Feld in der graphischen Benutzeroberfläche ermöglicht das Einfügen eines Dateinamens als Blatt aus dem MS-Explorer mit Drag & Drop.",
"A field in the graphical user interface gives the possibility to drag & drop a filename in the tree as a leaf.",
}
commentsTable["display empty first tree"]={
"Beim Start der graphischen Benutzeroberfläche wird ein leerer erster Baum angezeigt.",
"At the load of the graphical user interface an empty first tree is shown.",
}
commentsTable["display empty SQL tree"]={
"Beim Start der graphischen Benutzeroberfläche wird ein leerer SQL-Baum angezeigt.",
"At the load of the graphical user interface an empty SQL tree is shown.",
}
commentsTable["display empty second tree"]={
"Beim Start der graphischen Benutzeroberfläche wird ein leerer zweiter Baum angezeigt.",
"At the load of the graphical user interface an empty second tree is shown.",
}
commentsTable["display empty compare tree"]={
"Beim Start der graphischen Benutzeroberfläche wird ein leerer Vergleichsbaum angezeigt.",
"At the load of the graphical user interface an empty compare tree is shown.",
}
commentsTable["delete nodes in tree2 that are in tree and mark not existing files in grey (is possible only after having the GUI shown)"]={
"Die Prüfung der Verarbeitung der Dateien erfolgt beim Start der graphischen Benutzeroberfläche. Es werden die Knoten, die im zweiten, d.h. dynamisch erstellten Baum im ersten, d.h. im manuellen Baum gelöscht. Die Prüfung der Existenz der Dateien im manuellen Baum erfolgt, indem die nicht existierenden Dateien grau gefärbt werden.",
"At the load of the graphical user interface delete nodes in second, i.e. dynamic tree that are in first, i.e. manual, tree and mark not existing files in grey.",
}
commentsTable["canvas for images"]={
"Eine Fläche für das Anzeigen von Bildern bzw. Graphiken wird in der graphischen Benutzeroberfläche eingebaut.",
"An Area is build in the graphical user interface to show images and graphics.",
}
commentsTable["build indicators with the execution of an individual script"]={
"Um Bilanzkennzahlen herzustellen wird ein Skript ausgeführt. Die Bilanzkennzahlenberechnung wird individuell eingestellt.",
"Indicators of the balance are calculated with the execution of an individual script.",
}
commentsTable["button with second logo"]={
"Eine Schaltfläche mit dem zweiten Logo und der Meldung mit der Lizenzangabe und der Adresse wird rechts oben gezeigt.",
"A button with second logo is shown on the top right side with a message with the licence information and the address.",
}
commentsTable["logo image definition and button with logo"]={
"Eine Schaltfläche mit dem Logo und der Meldung mit der Lizenzangabe und der Adresse wird links oben gezeigt. Das Logo wird im Skript definiert.",
"A button with logo is shown on the top left side with a message with the licence information and the address. The logo is defined in the script.",
}

commentsTable["input access database file"]={
"Die Inputdatei ist eine MS-Access-Datenbank.",
"The input file is a MS-Access database file.",
}
commentsTable["input text file"]={
"Die Inputdatei ist eine Textdatei.",
"The input file is a text file.",
}
commentsTable["output function"]={
"Eine Hilfsfunktion für output wird definiert.",
"An auxiliary function is needed to define output.",
}
commentsTable["open_file function"]={
"Eine Hilfsfunktion für open_file wird definiert.",
"An auxiliary function is needed to define open_file.",
}
commentsTable["do_file auxiliary function"]={
"Eine Hilfsfunktion für do_file wird definiert.",
"An auxiliary function is needed to define do_file.",
}
commentsTable["do_string function"]={
"Eine Hilfsfunktion für do_string wird definiert.",
"An auxiliary function is needed to define do_string.",
}
commentsTable["write function"]={
"Eine Hilfsfunktion für write wird definiert.",
"An auxiliary function is needed to define write.",
}
commentsTable["print to output function"]={
"Eine Hilfsfunktion für print to output wird definiert.",
"An auxiliary function is needed to define print to output.",
}
commentsTable["print function"]={
"Eine Hilfsfunktion für print wird definiert.",
"An auxiliary function is needed to define print.",
}
commentsTable["print command function"]={
"Eine Hilfsfunktion für den print Befehl wird definiert.",
"An auxiliary function is needed to define print command.",
}
commentsTable["put original functions in variables"]={
"Die Originalfunktionen werden in Variablen gesichert.",
"The original functions are stored in variables.",
}
commentsTable["previous command function"]={
"Eine Hilfsfunktion für den vorherigen Befehl wird definiert.",
"An auxiliary function is needed to define previous command.",
}
commentsTable["next command function"]={
"Eine Hilfsfunktion für den nächsten Befehl wird definiert.",
"An auxiliary function is needed to define next command.",
}
commentsTable["add command function"]={
"Eine Hilfsfunktion für den add Befehl wird definiert.",
"An auxiliary function is needed to define add command.",
}
commentsTable["simplified version of table.move for Lua 5.1 and Lua 5.2 that is enough for using of table.move here"]={
"Eine Funktion table.move als vereinfachte Version von table.move in Lua 5.1 und Lua 5.2 wird definiert.",
"A function is needed as a simplified version of table.move for Lua 5.1 and Lua 5.2 that is enough for using of table.move here.",
}
commentsTable["math.integer for Lua 5.1 and Lua 5.2"]={
"Eine Funktion für die ganzen Zahlen in Lua 5.1 und Lua 5.2 wird definiert.",
"A function for integers is defined for Lua 5.1 and Lua 5.2.",
}
commentsTable["loadstring for Lua 5.3 and higher Lua versions"]={
"Eine Funktion loadstring für Lua-Versionen ab Lua 5.3 wird definiert.",
"A function for loadstring  is defined for Lua 5.3 and higher Lua versions.",
}
commentsTable["output CSV file"]={
"Die Outputdatei ist eine CSV-Datei.",
"The output file is a CSV file.",
}
commentsTable["collect internet site names from tree"]={
"Die Internetseitennamen bzw. URLs werden aus der Baumansicht gesammelt.",
"Internet site names or URLs from tree are collected.",
}
commentsTable["get SQL with Names of queries, i.e. views in Access"]={
"Die SQLs werden mit den Namen der Abfragen, die in Access den Views entsprechen, gesammelt.",
"SQL with Names of queries, i.e. views in Access, are collected.",
}
commentsTable["global data definition"]={
"Globale Daten werden definiert.",
"Global data are defined.",
}
commentsTable["open Access"]={
"MS-Access wird geöffnet.",
"MS-Access is opened.",
}
commentsTable["open Access database"]={
"Die MS-Access-Datenbank wird geöffnet.",
"The MS-Access database file is opened.",
}
commentsTable["output CSV file"]={
"Die Outputdatei ist eine CSV-Datei.",
"The output file is a CSV file.",
}
commentsTable["read CSV input file"]={
"Die CSV-Datei mit den Abhängigkeiten gelesen. Die erste Spalte hat die Kinds- (Abfrage, Tabelle, in die eingefügt wird oder die erstellt wird),die zweite die Elternknoten (Tabelle oder Abfrage).",
"The CSV file with dependencies is read. first column: child, for database query or insert table or build table and second clumn: parent, for database table or query.",
}
commentsTable["read excel file names of the directory in a Lua table"]={
"Die Excel-Dateinamen werden in eine Lua-Tabelle geschrieben.",
"The excel file names of the directory are read in a Lua table.",
}
commentsTable["build the outputstring for the tree"]={
"Die Outputzeichenkette für den Baum wird geschrieben.",
"The the outputstring for the tree built.",
}
commentsTable["read names of excel file exports as pdf in a Lua table"]={
"Die Excel-Dateinnamen, die als PDF-Dateien exportiert wurdn, werden in einer Lua-Tabelle gesammelt.",
"The excel file names which have been exported as pdf files are collected in a Lua table.",
}
commentsTable["read names of excel file exports as txt in a Lua table"]={
"Die Excel-Dateinnamen, die als Textdateien exportiert wurdn, werden in einer Lua-Tabelle gesammelt.",
"The excel file names which have been exported as text files are collected in a Lua table.",
}
commentsTable["read names of powerpoint file exports as pdf in a Lua table"]={
"Die Powerpoint-Dateinnamen, die als PDF-Dateien exportiert wurdn, werden in einer Lua-Tabelle gesammelt.",
"The powerpoint file names which have been exported as PDF files are collected in a Lua table.",
}
commentsTable["read powerpoint file names of the directory in a Lua table"]={
"Die Powerpoint-Dateinamen werden in eine Lua-Tabelle geschrieben.",
"The powerpoint file names of the directory are read in a Lua table.",
}
commentsTable["read word file names of the directory in a Lua table"]={
"Die Word-Dateinamen werden in eine Lua-Tabelle geschrieben.",
"The word file names of the directory are read in a Lua table.",
}
commentsTable["functions for GUI"]={
"Die Funktionen für die graphische Benutzeroberfläche werden definiert.",
"The functions for the graphical user interface are defined.",
}


commentsTable["export excel files to pdf if there is no export or if the date of the export to pdf is older than the date of the excel file"]={
"Die Excel-Dateien werden in eine PDF-Datei exportiert, wenn es noch keinen Export gab oder das Datum des letzten Exports älter als das Datum der Excel-Datei ist.",
"The excel files are exported to pdf files if there is no export or if the date of the export to PDF is older than the date of the excel file.",
}
commentsTable["export excel files to txt if there is no export or if the date of the export to txt is older than the date of the excel file"]={
"Die Excel-Dateien werden in eine Textdatei exportiert, wenn es noch keinen Export gab oder das Datum des letzten Exports älter als das Datum der Excel-Datei ist.",
"The excel files are exported to text files if there is no export or if the date of the export to text is older than the date of the excel file.",
}
commentsTable["export internet files to text if there is no export"]={
"Die Internetdateien werden als Textdateien exportiert, wenn es noch keinen Export gab.",
"The internet files are exported to text if there is no export.",
}
commentsTable["export powerpoint files to pdf if there is no export or if the date of the export to pdf is older than the date of the powerpoint file"]={
"Die Powerpoint-Dateien werden als PDF-Dateien exportiert, wenn es noch keinen Export gab oder das Datum des letzten Exports zu PDF älter als das Datum der Powerpoint-Datei ist.",
"The powerpoint files are exported to PDF files if there is no export to pdf or if the date of the export to pdf is older than the date of the powerpoint file.",
}
commentsTable["export word files to text if there is no export or if the date of the export to text is older than the date of the word file"]={
"Die Word-Dateien werden exportiert, wenn es noch keinen Export gab oder das Datum des letzten Exports älter als das Datum der Word-Datei ist.",
"The word files are exported to text if there is no export or if the date of the export to text is older than the date of the word file.",
}
commentsTable["function escaping magic characters"]={
"Eine Funktion wird definiert, um magische Zeichen zu maskieren.",
"A function is defined for escaping magic characters.",
}
commentsTable["function for version informations"]={
"Eine Funktion für die Versionsinformationen wird definiert.",
"A function for version informations is defined.",
}
commentsTable["function for writing tree in a text file (function for printing tree)"]={
"Eine Funktion speichert den IUP-Baum als Textdatei mit Tabulatoren ab.",
"A function saves the current iup tree as a text file with tabulators.",
}
commentsTable["function for writing tree2 in a text file (function for printing tree2)"]={
"Eine Funktion speichert den zweiten IUP-Baum als Textdatei mit Tabulatoren ab.",
"A function saves the current second iup tree as a text file with tabulators.",
}
commentsTable["function that sorts ascending whole Lua table with tree but not the tree in IUP"]={
"Eine Funktion sortiert aufsteigend eine ganze Lua-Tabelle mit Rekursion, aber nicht den Baum in IUP.",
"A function sorts ascending whole Lua table with tree, but not the tree in IUP.",
}
commentsTable["function that sorts descending whole Lua table with tree but not the tree in IUP"]={
"Eine Funktion sortiert absteigend eine ganze Lua-Tabelle mit Rekursion, aber nicht den Baum in IUP.",
"A function sorts descending whole Lua table with tree, but not the tree in IUP.",
}
commentsTable["first a recursive function for the performed insertion sort"]={
"Eine rekursive Funktion sortiert den Baum in IUP als erstes mit Einfügen.",
"A recursive function sorts the tree in IUP with insertion.",
}
commentsTable["function that sorts effectively"]={
"Eine Funktion sortiert den Baum in IUP.",
"A function sorts the tree in IUP.",
}
commentsTable["function to change expand/collapse relying on depth"]={
"Eine Funktion wird definiert, um das Ein- und Ausklappen auf die Ebene beruhen zu lassen.",
"A function is defined to change expand/collapse relying on depth.",
}

commentsTable["function to change expand/collapse relying on keyword"]={
"Eine Funktion wird definiert, um das Ein- und Ausklappen auf ein Suchwort beruhen zu lassen.",
"A function is defined to change expand/collapse relying on a keyword.",
}

commentsTable["function which saves the current iup tree as a Lua table"]={
"Eine Funktion speichert den IUP-Baum als Lua-Tabelle.",
"A function saves the current iup tree as a Lua table.",
}

commentsTable["functions for writing text files"]={
"Funktionen, um Textdateien zu schreiben, werden definiert.",
"Functions for writing text files are defined.",
}

commentsTable["general function for distance between texts"]={
"Eine Funktion wird definiert, die die Distanz zwischen Texten nach dem Levenshtein-Algorithmus berechnet.",
"A function is needed for the calculation of the distance of text according to the Levenshtein algorithm.",
}

commentsTable["get standardised sections in SQL-statements by reserved words"]={
"Die Inputdatei wird in standardisierten Blöcken von SQL-Statements durch reservierte Wörter unterteilt. Es werden dabei künstlich welche erzeugt, damit die Leerzeichen und andere Probleme behandelt werden.",
"The test file is splitted in standardised sections in SQL-statements by reserved words. There artificial built reserved words because of blanks and other problems.",
}

commentsTable["recursive function to build the tree with stopp of circles"]={
"Eine rekursive Funktion bildet den Baum und hört jeweils auf, wenn Abhängigkeiten zu einem Zirkelbezug führen.",
"A recursive function builds the tree with stopp of circles.",
}

commentsTable["recursive function to build the tree with stopp of circles"]={
"Eine rekursive Funktion bildet den Baum und hört jeweils auf, wenn Abhängigkeiten zu einem Zirkelbezug führen.",
"A recursive function builds the tree with stopp of circles.",
}

commentsTable["build dependencies in a csv file"]={
"Die Outputdatei als CSV-Datei wird mit den Abhängigkeiten gebildet.",
"The output file as a CSV file is built with the dependencies.",
}

commentsTable["button for replacing in tree"]={
"Ein Kontextmenüpunkt öffnet das zusätzliche Fenster zum Suchen und Ersetzen im Baum.",
"A menu item opens the additional dialog to search and replace in the tree.",
}

commentsTable["replace dialog"]={
"Ein zusätzliches Fenster dient dem Suchen und Ersetzen im Baum.",
"An additional dialog is needed to search and replace in the tree.",
}

commentsTable["search dialog"]={
"Ein Suchfenster wird definiert, das die Markierungsfunktion, die Suche in Textdateien, die Auswahl zwischen case sensitive und nicht und die Suche in der Vorschau hat, wenn es eine gibt.",
"A search dialog is defined with the mark functionality, the search in text files, the choice between case sensitive an not case sensitive and the search in the preview is existent.",
}
commentsTable["storage for checking if a name is the name of a query"]={
"Es wird geprüft, ob ein Name in den Abhängigkeiten ein Abfragenahmen ist.",
"There is a check whether a name is the name of a query.",
}
commentsTable["context menus (menus for right mouse click)"]={
"Es werden Kontextmenüs benötigt.",
"Context menus are needed.",
}
commentsTable["menu of console.inputTree"]={
"Es wird ein Kontextmenü für die Baumansicht der Inputdaten benötigt.",
"A context menu for the input tree are needed.",
}
commentsTable["menu of console.commandTree"]={
"Es wird ein Kontextmenü für die Baumansicht der Befehle benötigt.",
"A context menu for the command tree are needed.",
}
commentsTable["menu of console.outputTree"]={
"Es wird ein Kontextmenü für die Baumansicht der Outputdaten benötigt.",
"A context menu for the output tree are needed.",
}
commentsTable["add branch of tree from clipboard"]={
"Ein Kontextmenüpunkt fügt aus der Zwischenablage einen Ast an der Stelle des ausgewählten Knotens hinzu.",
"A menu item adds a branch of the tree at the selected node from the clipboard.",
}
commentsTable["add branch of console.outputTree"]={
"Ein Kontextmenüpunkt fügt einen Ast an der Stelle des ausgewählten Knotens im Baum console.outputTree hinzu.",
"A menu item adds a branch of the tree console.outputTree at the selected node.",
}
commentsTable["add branch of console.commandTree"]={
"Ein Kontextmenüpunkt fügt einen Ast an der Stelle des ausgewählten Knotens im Baum console.commandTree hinzu.",
"A menu item adds a branch of the tree console.commandTree at the selected node.",
}
commentsTable["add branch of console.inputTree"]={
"Ein Kontextmenüpunkt fügt einen Ast an der Stelle des ausgewählten Knotens im Baum console.inputTree hinzu.",
"A menu item adds a branch of the tree console.inputTree at the selected node.",
}
commentsTable["add branch of console.outputTree from clipboard"]={
"Ein Kontextmenüpunkt fügt aus der Zwischenablage einen Ast an der Stelle des ausgewählten Knotens im Baum console.outputTree hinzu.",
"A menu item adds a branch of the tree console.outputTree at the selected node from the clipboard.",
}
commentsTable["add branch of console.commandTree from clipboard"]={
"Ein Kontextmenüpunkt fügt aus der Zwischenablage einen Ast an der Stelle des ausgewählten Knotens im Baum console.commandTree hinzu.",
"A menu item adds a branch of the tree console.commandTree at the selected node from the clipboard.",
}
commentsTable["add branch of console.inputTree from clipboard"]={
"Ein Kontextmenüpunkt fügt aus der Zwischenablage einen Ast an der Stelle des ausgewählten Knotens im Baum console.inputTree hinzu.",
"A menu item adds a branch of the tree console.inputTree at the selected node from the clipboard.",
}
commentsTable["button for adding branch of tree from filename of image"]={
"Eine Schaltfläche fügt einen Ast an den Baum mit dem Dateinamen des Bildes oder der Graphik.",
"A button adds a branch of the tree with the filenam of the image or graphic.",
}
commentsTable["button for adding leaf of tree from filename of image"]={
"Eine Schaltfläche fügt ein Blatt an den Baum mit dem Dateinamen des Bildes oder der Graphik.",
"A button adds a leaf of the tree with the filenam of the image or graphic.",
}
commentsTable["add branch to tree"]={
"Ein Kontextmenüpunkt fügt einen Ast an der Stelle des ausgewählten Knotens hinzu.",
"A menu item adds a branch to the tree at the selected node.",
}
commentsTable["add branch to console.outputTree"]={
"Ein Kontextmenüpunkt fügt einen Ast an der Stelle des ausgewählten Knotens im Baum console.outputTree hinzu.",
"A menu item adds a branch to the tree console.outputTree at the selected node.",
}
commentsTable["add branch to console.commandTree"]={
"Ein Kontextmenüpunkt fügt einen Ast an der Stelle des ausgewählten Knotens im Baum console.commandTree hinzu.",
"A menu item adds a branch to the tree console.commandTree at the selected node.",
}
commentsTable["add branch to console.inputTree"]={
"Ein Kontextmenüpunkt fügt einen Ast an der Stelle des ausgewählten Knotens im Baum console.inputTree hinzu.",
"A menu item adds a branch to the tree console.inputTree at the selected node.",
}
commentsTable["button to copy filename in clipboard"]={
"Eine Schaltfläche kopiert den Dateinamen in die Zwischenablage.",
"A button copies filename in clipboard.",
}

commentsTable["add leaf of tree"]={
"Ein Kontextmenüpunkt fügt ein Blatt an der Stelle des ausgewählten Knotens hinzu.",
"A menu item adds a leaf of the tree at the selected node.",
}
commentsTable["add leaf of console.outputTree"]={
"Ein Kontextmenüpunkt fügt ein Blatt an der Stelle des ausgewählten Knotens des Baumes console.outputTree hinzu.",
"A menu item adds a leaf of the tree console.outputTree at the selected node.",
}
commentsTable["add leaf of console.commandTree"]={
"Ein Kontextmenüpunkt fügt ein Blatt an der Stelle des ausgewählten Knotens des Baumes console.commandTree hinzu.",
"A menu item adds a leaf of the tree console.commandTree at the selected node.",
}
commentsTable["add leaf of console.inputTree"]={
"Ein Kontextmenüpunkt fügt ein Blatt an der Stelle des ausgewählten Knotens des Baumes console.inputTree hinzu.",
"A menu item adds a leaf of the tree console.inputTree at the selected node.",
}
commentsTable["button to edit in IUP Lua scripter the script for tree2"]={
"Eine Schaltfläche öffnet das Skript für den zweiten Baum, den Arbeitsvorrat, im IUP-Lua-Skripter.",
"A button edits in IUP Lua scripter the script for second tree.",
}
commentsTable["button to edit in IUP Lua scripter the script for tree3"]={
"Eine Schaltfläche öffnet das Skript für den dritten Baum, die Statistik, im IUP-Lua-Skripter.",
"A button edits in IUP Lua scripter the script for third tree.",
}
commentsTable["button to edit in IUP Lua scripter the script for indicators"]={
"Eine Schaltfläche öffnet das Skript für die Bilanzkennzahlen im IUP-Lua-Skripter.",
"A button edits in IUP Lua scripter the script for indicators of the balance.",
}
commentsTable["script for manual tree"]={
"Das Skript für die manuelle Zuordnung als Baum wird definiert.",
"The script for manual tree is defined.",
}
commentsTable["add leaf of tree from clipboard"]={
"Ein Kontextmenüpunkt fügt aus der Zwischenablage ein Blatt an der Stelle des ausgewählten Knotens hinzu.",
"A menu item adds a leaf of the tree at the selected node from the clipboard.",
}
commentsTable["add leaf of console.outputTree from clipboard"]={
"Ein Kontextmenüpunkt fügt aus der Zwischenablage ein Blatt an der Stelle des ausgewählten Knotens des Baumes console.outputTree hinzu.",
"A menu item adds a leaf of the tree console.outputTree at the selected node from the clipboard.",
}
commentsTable["add leaf of console.commandTree from clipboard"]={
"Ein Kontextmenüpunkt fügt aus der Zwischenablage ein Blatt an der Stelle des ausgewählten Knotens des Baumes console.commandTree hinzu.",
"A menu item adds a leaf of the tree console.commandTree at the selected node from the clipboard.",
}
commentsTable["add leaf of console.inputTree from clipboard"]={
"Ein Kontextmenüpunkt fügt aus der Zwischenablage ein Blatt an der Stelle des ausgewählten Knotens des Baumes console.inputTree hinzu.",
"A menu item adds a leaf of the tree console.inputTree at the selected node from the clipboard.",
}
commentsTable["copy node of tree with all children and add to the root"]={
"Ein Kontextmenüpunkt verdoppelt den ausgewählten Knoten mit allen Unterknoten, indem es ihn kopiert und unter den Stammknoten einfügt.",
"A menu item copies selected node of tree with all children and add it to the root.",
}
commentsTable["copy node of tree2 with all children and add to the root of the tree"]={
"Ein Kontextmenüpunkt sendet den ausgewählten Knoten des zweiten Baumes mit allen Unterknoten an die manuelle Zuordnung, d.h. den ersten Baum, indem es ihn kopiert und unter den Stammknoten des ersten Baumes einfügt.",
"A menu item copies selected node of second tree with all children and add it to the root of the first tree.",
}
commentsTable["menu for building tree from new directory"]={
"Ein Kontextmenüpunkt bildet eine Baumansicht aus dem Zielverzeichnis.",
"A menu item builds the tree from new directory.",
}
commentsTable["menu for building tree from new directory without versions"]={
"Ein Kontextmenüpunkt bildet eine Baumansicht ohne die Versionsdateien aus dem Zielverzeichnis.",
"A menu item builds the tree from new directory without versions of files.",
}
commentsTable["menu for building tree from start directory without versions"]={
"Ein Kontextmenüpunkt bildet eine Baumansicht ohne die Versionsdateien aus dem Quellverzeichnis.",
"A menu item builds the tree from start directory without versions of files.",
}
commentsTable["menu for making new directory from selected node"]={
"Ein Kontextmenüpunkt legt ein Unterverzeichnis mit dem Pfadnamen des ausgewählten Knotens an. Wenn ein Verzeichnis im Pfadnamen nicht existiert wird es ebenfalls angelegt.",
"A menu item makes a subdirectory with the path name of the selected node. If a directory in the path name does not exist it is made also.",
}
commentsTable["execute Lua script with Lua chunk of the node of console.outputTree and write result under the node"]={
"Ein Kontextmenüpunkt führt ein Lua Skript mit dem Inhalt des ausgewählten Knotens im Baum console.outputTree und schreibt die Ergebnisse unter dem Knoten.",
"A menu item executes a Lua script with Lua chunk of the node of console.outputTree and write result under the node.",
}
commentsTable["execute Lua script with Lua chunk of the node of console.commandTree and write result under the node of tree console.outputTree"]={
"Ein Kontextmenüpunkt führt ein Lua Skript mit dem Inhalt des ausgewählten Knotens im Baum console.commandTree und schreibt die Ergebnisse unter dem Knoten.",
"A menu item executes a Lua script with Lua chunk of the node of console.commandTree and write result under the node.",
}
commentsTable["execute Lua script with Lua chunk of the node of console.outputTree and rewrite result under the node of tree console.outputTree"]={
"Ein Kontextmenüpunkt führt ein Lua Skript mit dem Inhalt des ausgewählten Knotens im Baum console.outputTree und schreibt die Ergebnisse unter dem Knoten erneut, falls es ein Ast ist.",
"A menu item executes a Lua script with Lua chunk of the node of console.outputTree and rewrite result under the node in the case it is a branch.",
}
commentsTable["execute Lua script with Lua chunk of the node of console.commandTree and rewrite result under the node in console.outputTree"]={
"Ein Kontextmenüpunkt führt ein Lua Skript mit dem Inhalt des ausgewählten Knotens im Baum console.commandTree und schreibt die Ergebnisse unter dem Knoten des Baumes console.outputTree erneut, falls es ein Ast ist.",
"A menu item executes a Lua script with Lua chunk of the node of console.commandTree and rewrite result under the node of the tree console.outputTree in the case it is a branch.",
}
commentsTable["execute Lua script with Lua chunk of the node and the child nodes of console.outputTree and write result under the node"]={
"Ein Kontextmenüpunkt führt ein Lua Skript mit dem Inhalt des ausgewählten Knotens und aller darunterliegender Unterknoten im Baum console.outputTree und schreibt die Ergebnisse unter dem Knoten erneut, falls es ein Ast ist.",
"A menu item executes a Lua script with Lua chunk of the node and all child nodes of console.outputTree and rewrite result under the node in the case it is a branch.",
}
commentsTable["execute Lua script with Lua chunk of the node and all child nodes of console.commandTree and write result under the node of tree console.outputTree"]={
"Ein Kontextmenüpunkt führt ein Lua Skript mit dem Inhalt des ausgewählten Knotens und aller darunterliegender Unterknoten im Baum console.commandTree und schreibt die Ergebnisse unter dem Knoten erneut, falls es ein Ast ist.",
"A menu item executes a Lua script with Lua chunk of the node and all child nodes of console.commandTree and rewrite result under the node in the case it is a branch.",
}
commentsTable["copy node of tree"]={
"Ein Kontextmenüpunkt den Namen des ausgewählten Knotens in die Zwischenablage.",
"A menu item copies the name of the selected node of the tree in the clipboard.",
}
commentsTable["copy node of console.outputTree"]={
"Ein Kontextmenüpunkt den Namen des ausgewählten Knotens des Baumes console.outputTree in die Zwischenablage.",
"A menu item copies the name of the selected node of the tree console.outputTree in the clipboard.",
}
commentsTable["copy node of console.commandTree"]={
"Ein Kontextmenüpunkt den Namen des ausgewählten Knotens des Baumes console.outputTree in die Zwischenablage.",
"A menu item copies the name of the selected node of the tree console.outputTree in the clipboard.",
}
commentsTable["copy node of console.inputTree"]={
"Ein Kontextmenüpunkt den Namen des ausgewählten Knotens des Baumes console.outputTree in die Zwischenablage.",
"A menu item copies the name of the selected node of the tree console.outputTree in the clipboard.",
}
commentsTable["copy node of tree1"]={
"Ein Kontextmenüpunkt den Namen des ausgewählten Knotens im ersten Baum in die Zwischenablage.",
"A menu item copies the name of the selected node of the first tree in the clipboard.",
}
commentsTable["copy node of tree2"]={
"Ein Kontextmenüpunkt den Namen des ausgewählten Knotens im zweiten Baum in die Zwischenablage.",
"A menu item copies the name of the selected node of the second tree in the clipboard.",
}
commentsTable["delete all children nodes"]={
"Ein Kontextmenüpunkt löscht alle Knoten, also alle Blätter und Äste, unterhalb des ausgewählten Astes.",
"A menu item deletes all nodes, i.e. all leafs and branches, under the branch.",
}
commentsTable["delete all leafs under the branch"]={
"Ein Kontextmenüpunkt löscht alle Blätter unterhalb des ausgewählten Astes.",
"A menu item deletes all leafs under the branch.",
}
commentsTable["menu for building new page"]={
"Ein Kontextmenüpunkt fügt eine neue Seite mit dem Namen des ausgewählten Knotens als Schlüssel hinzu.",
"A menu item adds a new page with the selected node of the tree as the key.",
}
commentsTable["menu for going to webbrowser page"]={
"Ein Kontextmenüpunkt geht zur Seite des ausgewählten Knotens.",
"A menu item goes to the page of the selected node.",
}
commentsTable["button for going to webbrowser page"]={
"Eine Schaltfläche geht zur Seite des ausgewählten Knotens.",
"A button goes to the page of the selected node.",
}
commentsTable["shut all access processes to be able to reopen the database"]={
"Alle MS-Access-Prozesse werden geschlossen, damit die Datenbank erneut geöffnet werden kann.",
"All access processes are shut to be able to reopen the database.",
}
commentsTable["start file of node of console.outputTree in IUP Lua scripter or start empty file in notepad or start empty scripter"]={
"Mit einem Kontextmenüpunkt wird die Datei mit dem Knotennamen des Konsolenbaums im IUP-Lua-Skripter geöffnet. Wenn diese Datei leer ist, aber existiert, wird sie im Notepad geöffnet. Wenn es kein gültiger Dateiname ist, dann wird ein leeres IUP-Lua-Skripter geöffnet.",
"With a menu item a file of nodename of the tree of the console is opened in IUP Lua scripter or an empty, but existing file is startet in notepad with the name of the node or an empty scripter is started if there is no valid file name of the node.",
}
commentsTable["start the url in webbrowser"]={
"Ein Kontextmenüpunkt startet die URL des Knotens im Webbrowser.",
"A menu item starts the url os the node in the webbrowser.",
}
commentsTable["write the Lua table for the tree"]={
"Die Lua-Tabelle für den Baum wird geschrieben.",
"The Lua table for the tree is written.",
}
commentsTable["button for building video from tree images"]={
"Eine Schaltfläche bildet aus den Baumknoten ein Video.",
"A button builds from the tree nodes a video.",
}
commentsTable["button for comparing text file of tree and text file of tree2"]={
"Eine Schaltfläche vergleicht die erste mit der zweiten Textdatei mit dem Ergebnis in einem Baum.",
"A button compares the first with the second text file with the result in a tree.",
}

commentsTable["button for going to first page"]={
"Eine Schaltfläche geht zur ersten Seite oder Startseite.",
"A button goes to the first page.",
}

commentsTable["button for going to the page"]={
"Eine Schaltfläche geht zur Seite des ausgewählten Knotens bzw. der ausgewählten Nummer.",
"A button goes to the page of the selected node or of the selected number.",
}

commentsTable["button for going to the page and edit the page"]={
"Eine Schaltfläche geht zur Seite des ausgewählten Knotens bzw. der ausgewählten Nummer und editiert diese.",
"A button goes to the page of the selected node or of the selected number and edit this page.",
}

commentsTable["button for loading text file 1"]={
"Eine Schaltfläche lädt die erste Textdatei in eine Textbox.",
"A button loads the first text file in a text box.",
}

commentsTable["button for loading text file 2"]={
"Eine Schaltfläche lädt die zweite Textdatei in eine Textbox.",
"A button loads the second text file in a text box.",
}

commentsTable["write the output file"]={
"Die Outputdatei wird geschrieben.",
"The output file is written.",
}
commentsTable["installation of the repositories and scripts"]={
"Der Ordner Archiv und die notwendigen Skripte müssen existieren. Falls es sie nicht gibt, werden diese installiert.",
"The directory Archiv and the necessary scripts must exist. If they do not exist they are installed.",
}
commentsTable["make repository or make directory Archiv"]={
"Der Ordner Archiv wird angelegt, falls es diesen noch nicht gibt.",
"The directory Archiv is made if there is no such directory.",
}
commentsTable["write end curly brackets"]={
"Die geschweiften Klammer zu werden geschrieben.",
"The end curly brackets are written.",
}
commentsTable["text written in html to build a tree in html with textboxes, buttons and functions"]={
"Ein Programmtext wird benötigt, in dem in Html die Textboxes, Schaltflächen und Funktionen für den Baum in Html definiert sind.",
"A code text written in html is needed to build a tree in html with textboxes, buttons and functions.",
}
commentsTable["write tree in html in the tree frame"]={
"Der Baum in Html-Code wird in den Frame mit der Baumansicht geschrieben.",
"A code text written in html is needed to write tree in html in the tree frame.",
}
commentsTable["write home html in the home frame"]={
"Die Startseite in Html-Code wird in den Frame mit der Startseite geschrieben.",
"A code text written in html is needed to write home in html in the home frame.",
}
commentsTable["build whole frame with tree and home frame"]={
"Es wird ein Frame mit einem Baumansicht-Frame und einem Startseiten-Frame benötigt.",
"A frame with tree and home frame is needed.",
}
commentsTable["build the path wb_img for the images"]={
"Es wird das Unterverzeichnis wb_img für die Bilder gebildet.",
"The images on the path wb_img are build.",
}
commentsTable["build the needed images for the frames"]={
"Es werden die Bilder für die Frames gebildet.",
"The images for the frames are build.",
}
commentsTable["optional section for pdf or powerpoint and screen capture"]={
"Es werden optional der Bildschirmausdruck sowie der PDF und Powerpoint-Export definiert.",
"An optional section for pdf or powerpoint and screen capture is defined.",
}
commentsTable["library for LuaCOM"]={
"Die Bibliothek für LuaCOM, d.h. das Microsoft Objekt-Modell für Lua, wird eingebunden.",
"The library LuaCOM, i.e. the Microsoft object model for Lua, is made available.",
}
commentsTable["open Word with LuaCOM"]={
"Word wird mit LuaCOM geöffnet.",
"Word is opened with LuaCOM.",
}
commentsTable["build a new Word document"]={
"Ein neues Word-Dokument wird gebildet.",
"A new Word document is built.",
}
commentsTable["save Word document"]={
"Das Word-Dokument wird gespeichert.",
"The Word document is saved.",
}
commentsTable["previously delete temporary test data"]={
"Die temporären Testdaten werden vorab gelöscht.",
"The temporary test data are previously deleted.",
}

--1. function escaping magic characters
function string.escape_forbidden_char(insertstring) --this function takes a string and returns the same string with escaped characters
	return insertstring:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\'", "\\\'"):gsub("\n", "\\n"):gsub("\r", "\\n")
end --function string.escape_forbidden_char(insertstring)

--2. collect data for the tree

outputfile1=io.open("C:\\Tree\\reflexiveDocTree\\reflexive_html_with_tree_scripts.lua","w")
outputfile1:write('fileTable={}' .. "\n")
for line in io.lines("C:\\Tree\\reflexiveDocTree\\reflexive_html_with_tree_Produktpalette.lua") do
	line=string.escape_forbidden_char(line)
	if line:match("<.*<!--") then
		if line:match("%(.*%)") then UnterGruppe="_" .. line:match("%([^%)]*%)") else UnterGruppe="" end
		line=line:gsub("&nbsp;","")
			:gsub("<tr><td>","<ul><li>IDIV-Hilfsprogramm ")
			:gsub(" ?</td><td>&#8594; </td><td> ?"," zu ")
			:gsub("</td></tr>"," zu Lua </li></ul>")
			:gsub("<ul><li>",'{branchname="')
			:gsub("</li></ul>",'",')
			:gsub("<!%-%-",'"')
			:gsub("%-%->",'"},')
			:gsub("%([^%)]*%)",'')
		--test with: print(line:gsub("&nbsp;",""))
		if line:match('%.lua') then
			outputfile1:write('fileTable[#fileTable+1]="' .. tostring(line:match('"([^"]*)"}')):gsub(" ","") .. '"\n')
		end --if line:match('%.lua') then
	end --if line:match("<!--") then
end --for line in io.lines("C:\\Tree\\reflexiveDocTree\\reflexive_html_with_tree.lua") do
outputfile1:close()


dofile("C:\\Tree\\reflexiveDocTree\\reflexive_html_with_tree_scripts.lua")


scriptTable={}
componentTable={}
componentSortTable={}

for i,v in ipairs(fileTable) do
	for line in io.lines(v) do
		if line:match("^%-%-%d+") and line:match(" end$")==nil then
			if scriptTable[line:match("^%-%-(%d)") .. ": " .. line:match("%-%-%d+[^ ]* (.*)")] then
				scriptTable[line:match("^%-%-(%d)") .. ": " .. line:match("%-%-%d+[^ ]* (.*)")]=scriptTable[line:match("^%-%-(%d)") .. ": " .. line:match("%-%-%d+[^ ]* (.*)")] .. "/" .. i .. ": " .. line:match("%-%-%d+[^ ]* ")
			else
				scriptTable[line:match("^%-%-(%d)") .. ": " .. line:match("%-%-%d+[^ ]* (.*)")]= i .. ": " .. line:match("%-%-%d+[^ ]* ")
			end --if scriptTable[line:match("%-%-%d+[^ ]* (.*)")] then
		end --if line:match("%-%-%d+") then
	end --for line in io.lines(v) do
end --for i,v in ipairs(fileTable) do

for k,v in pairs(scriptTable) do 
	componentTable[#componentTable+1]=k 
	componentSortTable[k]=k --table to sort with the original sort
end --for k,v in pairs(scriptTable) do 

--Change the sort criteria
componentSortTable["1: basic data"]="1: a1"
componentSortTable["1: color section"]="1: a2"
componentSortTable["2: color section"]="2: a2"
componentSortTable["1: color definitions"]="1: a3"
componentSortTable["2: color definitions"]="2: a3"
componentSortTable["1: libraries"]="1: a4"
componentSortTable["1: library"]="1: a5"
componentSortTable["1: libraries for video and GUI"]="1: a6"
componentSortTable["1: libraries for images"]="1: a7"
componentSortTable["1: libraries for videos"]="1: a8"
componentSortTable["1: library for LuaCOM"]="1: a9"
componentSortTable["1: open Word with LuaCOM"]="1: b1"
componentSortTable["3: functions"]="3: a1"
componentSortTable["3: general Lua functions"]="3: a2"
componentSortTable["3: functions for GUI"]="3: a3"
componentSortTable["3: no functions"]="3: a4"
componentSortTable["4: dialogs"]="4: a1"
componentSortTable["4: no dialogs"]="4: a2"
componentSortTable["4: no dialogs needed since tree is fixed"]="4: a3"
componentSortTable["5: context menus (menus for right mouse click)"]="5: a1"
componentSortTable["5: menu of tree"]="5: a2"
componentSortTable["5: menu of tree1"]="5: a3"
componentSortTable["5: menu of tree2"]="5: a4"
componentSortTable["5: no context menus"]="5: a5"
componentSortTable["5: menu of console.inputTree"]="5: a6"
componentSortTable["5: menu of console.commandTree"]="5: a7"
componentSortTable["5: menu of console.outputTree"]="5: a8"
componentSortTable["6: buttons"]="6: a1"
componentSortTable["6: no buttons"]="6: a2"
componentSortTable["6: logo image definition and button with logo"]="6: a3"
componentSortTable["6: button with second logo"]="6: a4"
componentSortTable["7: Main Dialog"]="7: a1"
componentSortTable["7: close Main Dialog"]="7: a4"
componentSortTable["7: show the dialog"]="7: zz1"
componentSortTable["7: show the frame"]="7: zz2"
componentSortTable["7: Main Loop"]="7: zz3"

--sort the table with sort criteria changed partly
table.sort(componentTable,function(a,b) return componentSortTable[a]:lower()<componentSortTable[b]:lower() end)


--Ausgabe in html

function string.utf8convert(aText) 
local aText=aText:gsub("ä","&auml;"):gsub("ö","&ouml;"):gsub("ü","&uuml;"):gsub("Ä","&Auml;"):gsub("Ö","&Ouml;"):gsub("Ü","&Uuml;"):gsub("ß","&szlig;")
--:gsub("ä","\u{00E4}"):gsub("ö","\u{00F6}"):gsub("ü","\u{00FC}"):gsub("Ä","\u{00C4}"):gsub("Ö","\u{00D6}"):gsub("Ü","\u{00DC}"):gsub("ß","\u{00DF}")
return aText 
end --function utf8convert(aText)

numberNilComment=0
numberComments=0
nilCommentTable={}
outputfile2=io.open("C:\\Tree\\reflexiveDocTree\\reflexive_html_with_tree_do_comments.html","w")
outputfile2:write(string.utf8convert('<html>  <body leftmargin="120"><h2>Business concept for components of the interactive dynamic table of contents products</h2><h2>Fachkonzept für Einzelbestandteile der IDIV-Produkte (Produkte der interaktiv-dynamischen Inhaltsverzeichnisse)</h2>\n' ))
for k,v in pairs(componentTable) do 
	if commentsTable[v:match("%d+: (.*)")] then
		outputfile2:write("<ul><li><b>" .. k .. "<br> " .. "<ul><li>" .. v .. "</b><br><br> " )
		if type(commentsTable[v:match("%d+: (.*)")])=="table" then
			for i1,v1 in ipairs(commentsTable[v:match("%d+: (.*)")]) do
				outputfile2:write("<ul><li>" .. tostring(string.utf8convert(v1)):gsub("\\n","<br>") )
				if i1<#commentsTable[v:match("%d+: (.*)")] then 
					outputfile2:write("</li></ul>" .. "<br> ") 
				else
					outputfile2:write("<br> ") 
				end
			end --for i1,v1 in ipairs(commentsTable[v:match("%d+: (.*)")]) do
		else
			outputfile2:write( "<ul><li>" .. tostring(string.utf8convert(commentsTable[v:match("%d+: (.*)")])):gsub("\\n","<br>") .. "</li></ul>" .. "<br> " )
		end --if type(commentsTable[v:match("%d+: (.*)")])=="table" then
		outputfile2:write( "<br><ul><li>" .. "<em>" .. scriptTable[v] .. "</em>" .. "</li></ul></li></ul></li></ul></li></ul>" .. "<br> " 
					.. "<br><br>\n") --only one line for each component, so that afterwards individual business concepts can be built
	else
		numberNilComment=numberNilComment+1
		--test with: print(k,v,scriptTable[v],tostring(commentsTable[v:match("%d+: (.*)")])) 
		nilCommentTable[#nilCommentTable+1]=k .. ": " .. v .. ": " .. scriptTable[v] .. ": " .. tostring(commentsTable[v:match("%d+: (.*)")]) 
	end --if commentsTable[v:match("%d+: (.*)")] then
	numberComments=k
end --for k,v in pairs(componentTable) do 
outputfile2:write(string.utf8convert("<h2>Appendix: files/Anhang: Dateien</h2>\n" ))
for k,v in pairs(fileTable) do 
	outputfile2:write("" .. k .. ": " 
				.. v .. "<br>\n" 
				.. "<br>\n") 
end --for k,v in pairs(componentTable) do 

outputfile2:write(string.utf8convert("<h2>Appendix 2: missing comments /Anhang: fehlende Kommentare</h2>\n" ))

print("number of Nil Comment: " .. numberNilComment .. " of " .. numberComments .. " or " .. math.floor(numberNilComment/numberComments*1000)/10 .. "%")
outputfile2:write("<br>number of Nil Comment: " .. numberNilComment .. " of " .. numberComments .. " or " .. math.floor(numberNilComment/numberComments*1000)/10 .. "%<br>\n")

for i,v in pairs(nilCommentTable) do outputfile2:write(v .. "<br>\n") end

outputfile2:write("</body></html>\n" )
outputfile2:close()

outputfile3=io.open("C:\\Tree\\reflexiveDocTree\\reflexive_html_with_tree_do_comments_individual.html","w")
outputfile3:write('<html>  <body leftmargin="120"><h2>' .. chosenNumber .. ": " .. fileTable[chosenNumber] .. '</h2><h2>Business concept by components of the interactive dynamic table of contents product</h2><h2>Fachkonzept nach Einzelbestandteilen des IDIV-Produktes (Produktes der interaktiv-dynamischen Inhaltsverzeichnisse)</h2>\n' )
for line in io.lines("C:\\Tree\\reflexiveDocTree\\reflexive_html_with_tree_do_comments.html") do
	if line:match("/" .. chosenNumber .. ": %-%-") or line:match(">" .. chosenNumber .. ": %-%-") or line:match(": " .. chosenNumber .. ": %-%-") then
		outputfile3:write(line .. "\n" )
	elseif line:match("Appendix") then
		outputfile3:write("<br>\n" .. line:gsub("files","file"):gsub("Dateien","Datei") .. "<br>\n" )
	elseif line:match("^" .. chosenNumber .. ": C:\\") then
		outputfile3:write("<br>\n" .. line:gsub("files","file"):gsub("Dateien","Datei") .. "<br>\n" )
	end--if line:match("5: %-%-") then
end --for line in io.lines("C:\\Tree\\reflexiveDocTree\\reflexive_html_with_tree_do_comments.html") do
outputfile3:write("<br><br><br></body></html>\n" )
outputfile3:close()
