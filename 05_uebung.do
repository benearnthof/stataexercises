// project:		Methoden 2, Übung # 5
// Tasks: 		Bivariate Datenanalyse: Kreuztabellen
// updated: 	2019/05/15


*******************
*§ 0 Vorbereitungen
*******************

* Geben Sie hier den Pfad zu Ihrem M2 Ordner an!
cd "\\nas.ads.mwn.de\ru25jan\Desktop\workingdirectory"

*use ZA5251_v1-1-0, clear 

*do ALLBUS_missing

*save Allbus2016 

* Führen Sie dann die folgenden Befehle aus: 

version 14.0
clear all
set more off
set linesize 80
set scheme s1mono 
numlabel, add
capture log close



* Zunächst öffnen Sie wieder den Datensatz ALLBUS 2016 aus Ihrem Verzeichnis.
* Beachten Sie dabei, dass wir hier die aufbereitete Datensatz-Version verwenden,
* die wir vergangene Woche erstellt haben und in der Missings bereits als solche
* kodiert sind!
use Allbus2016, clear


*********************************
*§ 1 Ein erstes Beispiel
*********************************

/* In den nächsten Zeilen finden Sie zunächst ein Beispiel zum Zusammenhang 
zwischen Ost-/Westdt. und der Befürwortung einer Erhöhung von Ausgaben im Bildungswesen.
	
Lassen Sie die Befehle Schritt für Schritt durchlaufen und versuchen Sie, 
die Schritte selbstständig nachzuvollziehen und zu verstehen.
	
Üben Sie auch die Interpretation der Ergebnisse (beachten Sie hierzu auch 
die Vorlesungsfolien). */


*** Schritt 1: Variablen vorbereiten

fre J006_4

* Ausgaben Bildungswesen in 3 Kategorien: erhöhen / beibehalten / senken
recode J006_4 (1 2=1)(3=2)(4 5=3), gen(educ_exp3)
lab var educ_exp3 "Ausgaben Bildungswesen (3 Kat.)"
lab def explbl_3 1"(Stark) erhöhen" 2"Unverändert lassen" 3"(Stark) senken"
lab val educ_exp3 explbl_3
fre educ_exp3

* Ausgaben Bildungswesen in 2 Kategorien: erhöhen / beibehalten oder senken 
recode J006_4 (1 2=1)(3 4 5=2), gen(educ_exp2a)
lab var educ_exp2a "Ausgaben Bildungswesen (2 Kat.)"
lab def explbl_2a 1"(Stark) erhöhen" 2"(Maximal) derzeitigen Stand halten"
lab val educ_exp2a explbl_2a
fre educ_exp2a

* Inwiefern unterscheiden sich die erstellten Variablen?
/*
Die erste Variable unterteilt die Antworten in drei Kategorien: Stark erhöhen, 
Stark senken, unverändert lassen.
Die zweite Variable unterteilt die Antworten in zwei Kategorien: Stark erhöhen, 
und Maximal derzeitigen Stand halten
*/



*** Schritt 2: Kreuztabellen erstellen

* Zusammenhang Ost/West und Ausgaben Bildungswesen (in 3 Kategorien)
tab educ_exp3 eastwest, col chi2 V

* Zusammenhang Ost/West und Ausgaben Bildungswesen (in 2 Kategorien)
tab educ_exp2a eastwest, col chi2 V


* Was folgern Sie aus den Ergebnissen? Macht es einen Unterschied wie stark 
* die Kategorien zusammengefasst werden?
/*
Für die Gruppen (Stark) erhöhen macht es keinen unterschied, da die Anzahlen
konstant bleiben, auch die Effekte sind höchstsignifikant, mit p-Werten kleiner 
als 0.000. Allerdings ändert sich das Vorzeichen von cramers V. Dies geschieht, 
weil für 2x2 tabellen cramers V identisch mit dem Assoziationsmaß Phi ist. 
Dieses kann werte kleiner 1 annehmen. 
*/



**************************************
*§ 2 Ein weiteres Beispiel
**************************************

/* Sie wollen nun prüfen, ob es einen Zusammenhang zwischen dem Bildungsgrad
des Vaters und dem erreichten Schulabschluss gibt.

Ihre unabhängige Variable soll angeben, ob der Vater über eine (Fach-)Hochschulreife
verfügt. Ihre abhängige Variable soll Auskunft darüber geben, ob der*die Befragte 
selbst über eine(Fach-)Hochschulreife verfügt.

Bereiten Sie zunächst die benötigten Variablen auf. Erstellen Sie anschließend die
Kreuztabelle (inkl. Chi2-Test und Cramer's V). Üben Sie auch die Interpretation der
Ergebnisse.

Zur Überprüfung Ihrer Ergebnisse finden Sie am Ende dieses do-files hilfreiche
Hinweise. */


*** Schritt 1: Variablen vorbereiten
fre J006_4

* Ausgaben Bildungswesen in 3 Kategorien: erhöhen / beibehalten / senken
recode feduc(1 2 3 6=1)(4 5=2), replace(vSchule)
lab var vSchule "Schulabschluss Vater (2Kat)"
lab def vSlab 1"keine (fach) Hochschulreife" 2"(fach)Hochschulreife"
lab val vSchule vSlab
fre vSchule

* Ausgaben Bildungswesen in 2 Kategorien: erhöhen / beibehalten oder senken 
recode educ(1 2 3 6 7=1)(4 5=2)(6 7=.), gen(bSchule)
lab var bSchule "Schulabschluss Befragter (2Kat)"
lab def bSlab 1"keine (fach) Hochschulreife" 2"(fach)Hochschulreife"
lab val bSchule bSlab
fre bSchule


*** Schritt 2: Kreuztabelle erstellen
tabulate vSchule bSchule, all exact
tab vSchule bSchule, col chi2 V

*** Schritt 3: Interpretation
/*
Es besteht ein höchstsignifikanter leicht bis mitelstarker Zusammenhang zwischen
Schulabschluss des Vaters und Schulabschluss des Befragten. 
*/


**************************************
*§ 3 Erweiterung des Beispiels
**************************************

* (Optionale Zusatzaufgabe, falls Zeit oder als Vorbereitung für Klausur / Hausarbeit)

/* Sie möchten nun herausfinden, ob der oben untersuchte Zusammenhang auch bei
 Betrachtung der Bildung beider Elternteile auftritt. Zudem wollen Sie eine
 etwas feinere Abstufung in 3 Kategorien (niedrig/mittel/hoch) vornehmen.
 Führen Sie hierzu die Ihnen bekannten Schritte zur Untersuchung des 
 Zusammenhangs sowie zur grafischen Veranschaulichung durch.
 
 Hinweis: Sie können den jeweils höchsten erreichten Schulabschluss der Eltern
 verwenden (auch wenn das andere Elternteil über einen geringeren Abschluss verfügt).
 Personen, die noch Schüler sind oder deren Abschluss sich nicht klar zuordnen lässt
 brauchen Sie in Ihrer Analyse nicht zu berücksichtigen.
 
 Gehen Sie die heute gelernten Schritte nacheinander durch und versuchen Sie, 
 die Aufgabe möglichst selbstständig zu lösen. Vergessen Sie nicht, die Ergebnisse
 auch inhaltlich zu interpretieren und schriftlich festzuhalten. 
 Falls nötig finden Sie am Ende dieses do-files einen Lösungsvorschlag. */

*** Schritt 1: Variablen vorbereiten
fre meduc
fre feduc
gen sEltern = .
replace sEltern = 1 if feduc < 3 | meduc < 3
replace sEltern = 2 if feduc == 3 | meduc == 3
replace sEltern = 3 if feduc == 4 | feduc == 5 | meduc == 4 | meduc == 5
lab var sEltern "Bildung Eltern 3k"
lab def sElab 1"low" 2"med" 3"high"
lab val sEltern sElab
fre sEltern

fre educ
recode educ (1 2=1)(3=2)(4 5=3)(6 7=.), gen(sBefragt)
lab var sBefragt "Bildung Befragter 3k"
lab def sBlab 1"low" 2"med" 3"high"
lab val sBefragt sBlab
fre sBefragt









*** Schritt 2: Kreuztabellen erstellen

tab bild3 pareduc3, col chi2 V


*** Schritt 3: Interpretation

* Chi2(4)=728.7989; p<0,001; H0 wird verworfen


*** Schritt 4: Grafik erstellen
ssc install catplot

catplot sBefragt sEltern, percent(sEltern) recast(bar) asyvar stack





*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§

***** Hilfestellung zu Aufgabe § 2 

* Chi2(1)=383.4577; p<0,001; H0 wird verworfen


***** Hilfestellung zu Aufgabe § 3

*** Schritt 1: Variablen vorbereiten
fre meduc
fre feduc
gen pareduc3 = .
replace pareduc3 = 1 if feduc < 3 | meduc < 3
replace pareduc3 = 2 if feduc == 3 | meduc == 3
replace pareduc3 = 3 if feduc == 4 | feduc == 5 | meduc == 4 | meduc == 5
lab var pareduc3 "Schulbildung Eltern (3 Kat.)"
lab def nmh 1"niedrig" 2"mittel" 3"hoch"
lab val pareduc3 nmh
fre pareduc

fre educ
recode educ (1 2=1)(3=2)(4 5=3)(6 7=.), gen(bild3)
lab var bild3 "Schulbildung (3 Kat.)"
lab val bild3 nmh
fre bild3

*** Schritt 2: Kreuztabellen erstellen

tab bild3 pareduc3, col chi2 V


*** Schritt 3: Interpretation

* Chi2(4)=728.7989; p<0,001; H0 wird verworfen


*** Schritt 4: Grafik erstellen
ssc install catplot

catplot bild3 pareduc3, percent(pareduc3) recast(bar) asyvar stack




*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§

* Vergessen Sie nicht, Ihren do-file zu speichern (Klick auf die das blaue 
* Disketten-Icon links oben im do-file).
* Anschließend können Sie Stata beenden. 

exit





