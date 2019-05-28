// project:		Methoden 2, Übung # 4
// Tasks: 		Signifikanztests: Mittelwertvergleiche
// updated: 	2019/05/09


*******************
*§ 0 Vorbereitungen
*******************

* Geben Sie hier den Pfad zu Ihrem 01_M2 Ordner an!!
cd "L:\Quanti\Tauschlaufwerk\Methoden II\Methoden_2_SS19\Übungen\Vorbereitung\Übung 04"

* Führen Sie dann die folgenden Befehle aus: 

version 14.0
clear all
set more off
set linesize 80
set scheme s1mono 
numlabel, add
capture log close

* Zunächst öffnen Sie wieder den Datensatz ALLBUS 2016 aus Ihrem Verzeichnis
use ZA5251_v1-1-0, clear // Daten öffnen 


*********************************
*§ 1 Einstieg: Aufbereitung von Missings
*********************************

* Machen Sie sich zunächst mit dem Befehl mvdecode vertraut. Für was ist der Befehl nützlich?

help mvdecode


/* Führen Sie anschließend den von Gesis bereitgestellten do-file "ALLBUS_missing.do" aus.
	Beachten Sie dabei, dass der do-file ebenfalls in Ihrem oben angegebenen Verzeichnis liegen muss.
	Anschließend speichern Sie den so aufbereiteten Datensatz unter einem neuen Namen.
	Im weiteren Semester werden wir immer wieder auf diesen Datensatz zugreifen. */

do ALLBUS_missing

save Allbus2016 // Daten speichern


* Vergleichen Sie nun die folgende Häufigkeitstabelle mit der von den Folien der Einzelübung.
* Was fällt Ihnen auf? Was ist der Vorteil des vorbereiteten do-files?

fre mc12

* Erstellen Sie eine Dummy-Variable (0/1-kodiert), die angibt ob sich in der Nähe
* eine Sammelunterkunft befindet.
* Achten Sie unbedingt darauf fehlende Werte nicht als gültig zu betrachten!

gen sammel = . // zunächst alle Werte der neuen Variable auf Missing setzen
replace sammel = 1 if mc12 == 1 // auf 1 setzen, wenn Sammelunterkunft in der Nähe
replace sammel = 0 if mc12 > 1 & mc12 < . // auf 0 setzen, wenn keine in der Nähe

lab var sammel "Nahe Sammelunterkunft (0/1)" // Variablenlabel setzen
lab def jn 1"Ja" 0"Nein" // Wertelabel definieren
lab val sammel jn // Wertelabel zuweisen

fre sammel





**************************************
*§ 2 Mittelwertvergleich
**************************************

/* In den nächsten Zeilen finden Sie ein Beispiel zum Altersunterschied in Ost-D und West-D.
	
Lassen Sie die Befehle Schritt für Schritt durchlaufen und versuchen Sie, 
die Schritte selbstständig nachzuvollziehen und zu verstehen.
	
Üben Sie auch die Interpretation der Ergebnisse. Hilfestellung hierzu finden
Sie im Vorlesungsskript. */

*** Schritt 1: Variablen vorbereiten
fre age // fehlende Werte sind als solche kenntlich gemacht (auf . gesetzt)
sum age, detail

fre eastwest


*** Schritt 2: Test auf Varianzgleichheit
sdtest age, by(eastwest)

* Was folgern Sie aus dem Testergebnis? Und warum ist dieser Test überhaupt sinnvoll?


*** Schritt 3: T-Test
ttest age, by(eastwest)

* Was können Sie über den Mittelwertunterschied aussagen? Unterscheidet sich
* das Alter statistisch signifikant? Woran können Sie das beurteilen?



**************************************
*§ 3 Erweiterung des Beispiels
**************************************

/* Anschließend wollen Sie prüfen, ob der Unterschied bestehen bleibt
 wenn Sie nur Personen mit deutscher Staatsangehörigkeit berücksichtigen.
 
 Wiederholen Sie die von oben bekannten Schritte, um herauszufinden, 
 ob sich das Alter von in Ost-D und in West-D lebenden Personen mit deutscher 
 Staatsangehörigkeit unterscheidet.
 
 Beachten Sie dabei zunächst, dass Sie Ihre Stichprobe (temporär!) auf 
 Befragte mit deutscher Staatsangehörigkeit begrenzen müssen.

* Nicht vergessen: Auch hier die Ergebnisse interpretieren und am besten 
schriftlich im do-file festhalten! */

* Schritt 1: Variablen vorbereiten



* Schritt 2: Test auf Varianzgleichheit



* Schritt 3: T-Test






/* Sie möchten die Altersverteilung in den beiden Gruppen auch grafisch
 darstellen. Dazu lassen Sie sich einen Boxplot ausgeben.
 
 Beachten Sie dabei auch hier, dass Sie Ihre Stichprobe ggf. (temporär) auf 
 die Sie interessierenden Befragten einschränken müssen.
 
 Nicht vergessen: Auch hier die Ergebnisse interpretieren und am besten schriftlich
 im do-file festhalten! */
 
graph box age if german == 1, by(eastwest)


/* Damit Sie auch zentrale Maßzahlen berichten können lassen Sie sich zudem
	summarize-Tabellen für die beiden Subgruppen ausgeben. Was ist der Unterschied
	zwischen den beiden Möglichkeiten? */

* Möglichkeit 1:
sum age if german == 1 & eastwest == 1, detail
sum age if german == 1 & eastwest == 2, detail

* Möglichkeit 2:
bysort eastwest: sum age if german == 1, detail






 
**************************************
*§ 4 Grafische Darstellung nach Familienstand
**************************************

* (Optinale Zusatzaufgabe, falls Zeit oder als Vorbereitung für Klausur / Hausarbeit)

/* Sie möchten nun das Durchschnittsalter in Ost- und Westdeutschland getrennt
 nach Familienstand grafisch anhand eines Balkendiagramms (mit Konfidenzintervallen)
 veranschaulichen. Dazu stellen Sie jeweils das Durchschnittsalter der ledigen,
 verheirateten, geschiedenen und verwitweten in Ost- und Westdeutschland in
 einer Grafik gegenüber.
 
 Hinweis: Lebenspartnerschaften und Ehen können Sie zusammenfassen.
 
 Gehen Sie die heute gelernten Schritte nacheinander durch und versuchen Sie, 
 die Aufgabe möglichst selbstständig zu lösen.
 
 Zudem: Machen Sie sich mit dem Grafikeditor vertraut und bereiten die Grafik
 mithilfe des Editors auf.
 
 Für Fortgeschrittene: Machen Sie sich mit den Grafikoptionen vertraut und 
 bereiten die Grafik in Ihrem do-file auf (Tipp: auch Google ist hier hilfreich).*/



 
 
 
 
 






*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§

* Vergessen Sie nicht, Ihren do-file zu speichern (Klick auf die das blaue 
* Disketten-Icon links oben im do-file).
* Anschließend können Sie Stata beenden. 

exit





