// project:		Methoden 2, Übung # 3
// Tasks: 		Signifikanztests und Ein-Stichproben t-Test
// updated: 	2019/05/07


*******************
*§ 0 Vorbereitungen
*******************

* Geben Sie hier den Pfad zu Ihrem 01_M2 Ordner an!!
cd "\\nas.ads.mwn.de\ru25jan\Desktop\workingdirectory

* Führen Sie dann die folgenden Befehle aus: 

version 14.0
clear all
set more off
set linesize 80
set scheme s1mono 
numlabel, add
capture log close

** Zunächst laden Sie sich den neuen Datensatz ALLBUS 2016 von der Homepage der GESIS
** Erklärungen siehe Folien Einzelübung

* Öffnen Sie anschließend den Datensatz 
use ZA5251_v1-1-0, clear // Daten öffnen 


*********************************
*§ 1 Einstieg: Rechen-Operatoren
*********************************


/* Berechnen Sie folgende Aufgaben mit Hilfe der Stata-Operatoren und dem display-Befehl:  */


* 809 - 923
 display(809-923)


* 9876 : 56
 display(9876 / 56)


* 25^5 
display(25^5)


* Quadratwurzel aus 81 
 display(sqrt(81))


* Exponentialfuntkion von 8.9
 display(exp(8.9))


**********************************
*§ 2 Variable bilden und labeln 
**********************************

/* Variable bilden:
1. Schritt: 
Erstellen Sie aus der Variable educ eine neue Variable 
bildung2.
Die neue Variable soll zweistufig sein. 
Den Wert 1 haben alle Befragten, die einen niedrigen oder mittleren Schulabschluss haben 
(ohne Abschluss, Volks-,Hauptschule, Mittlere Reife); 
den Wert 2 haben Befragte mit hohem Schulabschluss 
(Fachhochschulreife, Hochschulreife). 
"Anderer Abschluss", fehlende Werte und 
Befragte, die noch zur Schule gehen, setzen Sie auf Missing.*/

*Tipps: siehe Beispiel in der heutigen Einzelübung

fre educ
//generieren der variable bildung2
generate bildung2 = .
replace bildung2 = 1 if educ == 1 | educ == 2 | educ == 3
replace bildung2 = 2 if educ == 4 | educ == 5
replace bildung2 = . if educ == 6 | educ == 7 | educ ==  -41 | educ == -9

/* Variable labeln:
2. Schritt:
Anschließend labeln Sie sowohl die Variable als auch deren Ausprägungen entsprechend: 
* Label Variable: "Bildungsabschluss (binär)"
* Label Ausprägungen: 1"niedrig/mittel" 2"hoch" */

label variable bildung2 "Bildungsabschluss (binaer)" 
label define lbild2 1"niedrig/mittel" 2"hoch"     
label value bildung2 lbild2	
	
/* Häufigkeitstabelle:
3. Schritt:  Nach dem Labeln betrachten wir immer (!) mit dem fre-Befehl, 
ob das Labeln erfolgreich war!	*/

fre bildung2


***************************************************
*§ 2 Alter ALLBUS und Durchschnitt stat. Bundesamt
***************************************************

/* Nun gehen Sie von folgender Situation aus: 
 Laut statistischem Bundesamt betrug das Durchschnittsalter für 
 weibliche Deutsche 2016 45,7 Jahre.
 
 Finden Sie heraus, 
 ob es bei deutschen Frauen eine Differenz zwischen dem Alter im ALLBUS und dem 
 wahren Alter vom stat. Bundesamt gibt.
 
 Beachten Sie dabei zunächst, dass Sie Ihre Stichprobe (temporär!) auf 
 deutsche Frauen begrenzen müssen.

* Nicht vergessen: Auch hier die Ergebnisse interpretieren und am besten 
schriftlich im do-File festhalten! */


/* 1. Schritt: 
Betrachten Sie das Alter der Befragten im Jahr 2016 (age)
Bilden Sie eine neue Variable alter, die der Variable age entspricht.
Achten Sie auf fehlende Werte und rekodieren Sie diese auf .(Missing)!  */

fre age

gen alter = age

replace alter = . if age == -32

fre alter


 /* 2. Schritt: Kerndichteschätzer
Erstellen Sie nun einen Kerndichteschätzer zur Variable alter.  */

kdensity(alter)

/* 3. Schritt:
Nun lassen Sie sich das durchschnittliche Alter für die Subgruppe 
(weiblich + deutsch) anzeigen. Welcher Befehl ist der richtige? */

fre alter if sex == 2 & german == 1

sum alter if sex == 2 & german == 1, det

// sum alter if sex == 2 & german == 1, det 
// ist der richtige befehl => summary 
// mean = 51.36 
// Das Durchschnittsalter der Deutschen Frauen im Datensatz beträgt 51.36 Jahre

/* 4. Schritt: 
Erstellen Sie nun die Variable diff_fd, die aus der Differenz des indiv. Alter 
im Allbus und dem durchschnittl. Alter des stat. Bundesamtes besteht. 
(Achtung: erneut nur für deutsche Frauen!) */



gen diff_fd = .
replace diff_fd = alter - 45.7 if sex == 2 & german == 1 & alter!=.
lab var diff_fd "Differenz Alter ALLBUS / Stabu dt. Frauen"
sum diff_fd


/* 5. Schritt: Histogramm
Lassen Sie ich zudem ein Histogramm der Variable anzeigen. */

hist(diff_fd)


/* 6. Schritt:
 Abschließend führen Sie den T-Test aus und interpretieren ihn. */

ttest diff_fd == 0

/* Da 0 nicht innerhalb des 95% konfidenzintervalls liegt kann die hypothese
zum p-wert 0.05 verworfen werden. Auch der p-wert von 0.0000 liefert 
die gleiche Aussage. 
=> Das durchscnittsalter der deutschen Frauen im Allbusdatensatz 
ist signifikant verschieden zum Durchschnittsalter der deutschen Frauen 
das vom Statistischen Bundesamt angegeben wurde.
*/


*********************
*§ 4 Ausländeranteil 
*********************
* (Optinale Zusatzaufgabe, falls Zeit oder als Vorbereitung für Klausur / Hausarbeit)

/* 2016 lag der Anteil an Ausländern an der Gesamtbevölkerung in Westdeutschland 
(ohne Bremen und Hamburg) bei 12,1 Prozent (Quelle: Destatis). 

Im Allbus 2016 sollten die Befragten den Ausländeranteil in Westdeutschland 
schätzen (Variable: mp13). 

Gibt es eine Differenz zwischen der durchschnittlichen Ausländerschätzung für 
Westdeutschland im ALLBUS und dem offiziellen Wert von Destatis?  

Ist diese Differenz signifikant? 

Gehen Sie die heute gelernten Schritte nacheinander durch und versuchen Sie, 
die Aufgabe möglichst selbstständig zu lösen.

Vergessen Sie nicht, dass Sie die Daten möglicherweise zunächst mit replace 
umkodieren müssen oder Labels erstellen. */

tabulate(mp13)
gen mp13new = mp13
replace mp13new = . if mp13 == -8
fre mp13new

kdensity(mp13new)

gen diff_mp13new = .
replace diff_mp13new = mp13new - 12.1 
lab var diff_mp13new "Differenz Auslaender ALLBUS / Stabu"
sum diff_mp13new

hist(diff_mp13new)
ttest diff_mp13new == 0

/*
Auch hier unterscheidet sich der Mittelwert aus den Allbus Daten von der Angabe
des Statistischen Bundesamtes signifikant. 
Erkennbar wieder daran, dass 12.1 nicht im Konfidenzintervall liegt und am p-wert
von Pr(|T| > |t|) = 0.0000
*/



*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§

* Vergessen Sie nicht, Ihren do-file zu speichern (Klick auf die das blaue 
* Disketten-Icon links oben im do-file).
* Anschließend können Sie Stata beenden. 

exit





