// project:		Methoden 2, Übung # 8
// Tasks: 		Einfache lineare Regression
// updated: 	2019/06/17


*******************
*§ 0 Vorbereitungen
*******************

* Geben Sie hier den Pfad zu Ihrem M2 Ordner an!
cd "\\nas.ads.mwn.de\ru25jan\Desktop\workingdirectory"

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
* in der Missings bereits als solche kodiert sind!
use Allbus2016, clear // Daten öffnen 


/*Hinweis: alle hier verwendeten Beispiele sind exemplarischer Natur! 
*/

**********************************************
*§ 1 Einkommen und Dauer der Arbeitslosigkeit
**********************************************
/*Wir interessierfo weniger verdienen diese Personen gegenwärtig.

Wir führen dazu eine einfache lineare Regression durch und lassen uns vor der Regression 
einen Scatterplot mit Anpassungsgerade ausgeben (Hinweis: siehe Übung06) 
um erste Erkenntnisse zur aufgestellten Hypothese zu bekommen und interpretieren
den Regressionsoutput.

Hinweis: Benötigte Variablen:inc, dw18 und dw19 (um auch Personen im Modell zu haben, 
die 0 Wochen arbeitslos waren, muss dw19 für Personen, die dw18 mit 'nein' beantwortet haben,
zu 0 kodiert werden).

Zuletzt berechnen wir das geschätzte Einkommen für eine Person mit einer
Arbeitslosigkeitserfahrung von 24 Wochen. 

Versuchen Sie alle Schritte nachzuvollziehen!

*/

****Schritt 1: Relevante Variablen ansehen/erstellen
*Einkommen 
sum inc, d
*Anmerkung: Metrische Variablen sollten immer daraufhin überprüft werden, ob 
*unplausible Werte oder Ausreißer enthalten sind. Der Forscher muss dann entscheiden, wie
*mit den möglichen unplausiblen Werten umgegangen wird (meist werden unplausible
*Werte aus der Analyse ausgschlossen). Wann ein Wert als 'Ausreißer' oder unplausibel
*gilt und warum diese Werte problematisch sind, wird in späteren Veranstaltungen   
*gelernt.

*Arbeitslosigkeit in Wochen:
fre dw18
fre dw19

* Variable erstellen
gen arblos=.
replace arblos=dw19
replace arblos=0 if dw18==2
lab var arblos "Arbeitslosigkeit in Wochen"

fre arblos

****Schritt 2: Scatterplot erstellen
twoway (scatter inc arblos) (lfit inc arblos, lcol("green"))
gen ln_arblos = log(arblos)
gen ln_inc = log(inc)
twoway (scatter ln_inc ln_arblos) (lfit ln_inc ln_arblos, lcol("green"))
*Ein negativer Zusammenhang ist erkennbar, allerdings ist evtl. ein linearer 
*Zusammenhang hier nicht der beste. 
*Anmerkung: Diesem Problem kann mit Transformierung von Variablen begenet werden.
*Dazu lernen Sie in den nächsten Wochen mehr.
* ===> ln transformation fuer uebersichtlicheren scatterplot
****Schritt 3: Regression
reg inc arblos

****Schritt 4: Interpretation
*Das Modell beruht auf 1775 Fällen.
*Das Gesamtmodell ist statistisch signifikant (F-Test:  p<0.05)
*3% der Varianz im Einkommen kann durch Arbeitslosigkeit in Wochen erklärt werden.
*Pro Woche Arbeitslosigkeitserfahrung sinkt das Einkommen im Mittel um 5.40€.
*Dieser Wert ist statistisch höchst signifkant (p=0.000 < 0.001)

****Schritt 5: Vorhersage des Einkommens für eine Person mit einer Arbeitslosigkeits-
*erfahrung von 24 Wochen

*Die Regressionsgleichung lautet: y=a+arblos*x (allg.: y=a+b*x)

*Einsetzen in die Gleichung ergibt:
*y= 2106+(-5.40)*24

display 2106-5.40*24

*=1976.4

*Eine Person mit einer Arbeitslosigkeitserfahrung von 24 Wochen verdient im Mittel
*1976.4€.


***************************
*§ 2 Einkommen und Bildung
***************************
/* Aus vorangegangenen Übungen ist bekannt, dass Bildung einen Einfluss auf das
Einkommen hat. Wir wollen nun in einer einfachen linearen Regression herausfinden,
wie groß der Unterschied im Einkommen zwischen hoher und niedriger Bildung ist. 
Anschließend berechnen wir das geschätzte Einkommen für eine Person mit hoher Bildung.

Führen Sie die bekannten Schritte durch und interpretieren Sie die Ergebnisse!

Anmerkung:Für Regressionen müssen die Variablen entweder
Dummy-kodiert (0/1) oder metrisch vorliegen! 
Erstellen Sie die Bildungsvariable wie in der letzten Übung!
Am Ende des Do-files finden Sie Lösungshinweise zur Kontrolle Ihrer Ergebnisse!
*/


****Schritt 1: Relevante Variablen ansehen/erstellen
fre educ
*wir setzen 'noch Schüler' und 'anderer Abschluss' auf Missing

	*Variable generieren 
	gen dum_bil=.
	replace dum_bil=0 if educ==1 | educ==2 | educ==3
	replace dum_bil=1 if educ==4 | educ==5

	*Alternative
	*recode educ (1 2 3=0) (4 5=1) (6 7=.), gen(dum_bil)

	*Variable und Werte labeln
	lab var dum_bil "Bildung"
	lab def nh 0"niedrig"  1"hoch"
	lab val dum_bil nh

	*Überprüfen
	tab educ dum_bil, m
****Schritt 2: Regression berechnen
twoway (scatter inc dum_bil) (lfit inc dum_bil, lcol("green"))
reg inc dum_bil
****Schritt 3: Interpretation
* zusammenhang ist signifikant, intercept: 1423.601, koeffizient fuer dum_bil 
* 690.0562
****Schritt 4: vorhergesagter Wert einer hochgebildeten Person
gen intercept = _b[_cons]
gen beta_educ = _b[dum_bil]
* accessing the coefficients of the virtual result matrix
display intercept + 1*beta_educ
* fuer eine hochgebildete person wuerde man hier unter annahme eines linearen 
* zusammenhangs ein einkommen von 2113.6572 euro erwarten.

*****************************************
***§ 3: Lebenszufriedenheit und Einkommen 
*****************************************

/*Aus der Tafelübung ist bekannt, dass die Lebenszufriedenheit mit dem Einkommen
korreliert (TÜ Folie 148). 

Stellen Sie eine gerichtete Hypothese auf, die diese Korrelation beschreibt!
Lassen Sie sich anschließend einen Scatterplot mit Anpassungsgerade dazu ausgeben 
und schätzen Sie eine Regression und interpretieren Sie die Ergebnisse.
Sagen Sie abschließend die durchschnittliche Lebenszufriedenheit einer Person mit 
einem Einkommen von 2000€ vorher!
Zusatzaufgabe: Was sagt die Konstante inhaltlich aus? 
Zentrieren Sie anschließend das Einkommen am Mittelwert und interpretieren Sie 
die Konstante erneut!

Anmerkung: Verwenden Sie das Einkommen in Tausend Euro 
(Tipp: gen inc_tsd=inc/1000)

Hinweis: Am Ende des Do-Files finden Sie Lösungshinweise!
*/

**** Schritt 1: Hypothese: 
* je hoeher das einkommen desto zufriedener die person ayy

**** Schritt 2: Relevante Variablen ansehen/erstellen
fre ls01
gen inc_tsd = inc/1000
fre inc_tsd

twoway (scatter ls01 inc_tsd) (lfit ls01 inc_tsd, lcol("green"))

**** Schritt 4: Regression
reg ls01 inc_tsd

**** Schritt 5: Interpretation
* zusamenhang ist erneut aufgrund der zahl der beobachtungen signifikant kann aber nur 
* 3 prozent der varianz in den daten erklaeren. 

**** Schritt 6: Vorhersage der durchschnittlichen Zufriedenheit einer Person mit 2000€ Einkommen
gen intercept_3 = _b[_cons]
gen beta_inc_tsd = _b[inc_tsd]
display intercept_3 + 2 * beta_inc_tsd
* man wuerde erwarten, dass eine person mit 2000 euro einkommen im schnitt 
* eine lebenszufriedenheit von 7.81 aufweist.
**** Schritt 8: (Zusatz) Interpretation Konstante, Mittelwertzentrierung und erneute Interpreation
* i hob koan bock nimmer

******************************************
***§ 4: Lebenszufriedenheit und Geschlecht
******************************************
* (Optionale Zusatzaufgabe, falls Zeit oder als Vorbereitung für Klausur / Hausarbeit)
/*Nun interessiert uns, ob Männer und Frauen unterschiedlich zufrieden mit ihrem
Leben sind. Dazu schätzen wir eine einfache lineare Regression.
Suchen Sie die benötigten Variaben. Beachten Sie, dass dichotome Variablen 
Dummy-kodiert sein müssen. Führen Sie die bekannten Schritte durch und schätzen 
Sie die durchschnittliche Lebenszufriedenheit für Männer!
Hinweis: Lebenszufriedenheit wird als quasi-metrisch betrachet!


Hinweis: Am Ende des Do-Files finden Sie Lösungshinweise!
*/

****Schritt 1: relevante Variablen ansehen/erstellen
fre sex
****Schritt 2: Regression
reg ls01 sex
twoway (scatter ls01 sex) (lfit ls01 sex, lcol("green"))

****Schritt 3: Interpretation:
* zusammenhang ist signifikant p nahe null yada yada
* R squared ist atrocious wie zu erwarten war bei dichotomen variablen

****Schritt 4: Vorhersage der mittleren Lebenszufriedenheit der Männer:
* beim uebergang von mann zu frau steigert sich die erwartete ls01 um beta_sex
* intercept ist hier nicht sinnvoll zu interpretieren.
gen intercept_4 = _b[_cons]
gen beta_sex = _b[sex]
display intercept_4 + 1 * beta_sex
* die durchschnittliche ls01 von maennern liegt bei 7.615254


*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
*** Lösungshinweis Aufgabe § 2:
*Interpretation
* Die Schätzung beruht auf 3077 Fällen.
* Das Gesamt Modell ist statistisch signifikant (F-Test:  p<0.05)
* 8% der Varianz im Einkommen kann durch Bildung erklärt werden.
* Das Einkommen von hochgebildeten Personen liegt im Mittel 690€ über dem Einkommen
* von Personen mit niedriger Bildung. Der Zusammenhang ist höchst signifikant (p<0.001).
*Vohersage:
* Eine Person mit hoher Bildung verdient im Mittel 2113.6€.


*** Lösungshinweis Aufgabe § 3:
*Hypothese: 
*Bsp.: Je mehr eine Person verdient, desto zufriedener ist diese Person.

*Interpretation
**Das Modell beruht auf 3096 Fällen.
*Das Gesamtmodell ist statistisch signifikant (F-Test:  p<0.05)
*3.3% der Varianz in der Lebenszufriedenheit kann durch das Einkommen erklärt werden.
*Pro Tausen Euro mehr Einkommen steigt die Lebenszufriedenheit im Mittel um 0,3 Skalenpunkte.
*Dieser Wert ist statistisch höchst signifkant (p=0.000 < 0.001)

*Vorhersage
*Die durchschnittliche Lebenszufriedenheit für eine Person mit 2000€ Einkommen
*liegt bei 7.9 Skalenpunkten.

*Interpretation Konstante
* Eine Person mit 0 Euro Einkommen hat eine durchschnittliche Lebenszufriedenheit von 7,2 Skalenpunkten
*-> nicht sehr sinnvoll, deshalb Zentrierung am Mittelwert. 
*Mittelwertzentrierung und erneute Interpreation
sum inc_tsd,d

gen inc_tsd_zentr= inc_tsd-1.68122

lab var inc_tsd_zentr "Einkommen in Tausen Euro (zentriert)"

reg ls01 inc_tsd_zentr
*Personen mit mittlerem Einkommen (1681€) haben eine durchschnittliche Lebenszufriedenheit
* von 7,72 Skalenpunkten.


*** Lösungshinweis Aufgabe § 4:
*Interpretation:
* Das Modell beruht auf 3488 Fällen.
* Das Gesamtmodell ist statistisch signifikant (F-Test:  p<0.05)
* 0.4% der Varianz in der Lebenszufriedeheit kann durch das Geschlecht erklärt werden.
* Frauen sind im Vergleich zu Männern im Schnitt um 0.22 Skalenpunkte zufriedener.
* Dieser Wert ist statistisch höchst signifikant (p=0.000 <0.001)
*Vorhersage:
* Die durchschnittliche Lebenszufriedenheit von Männern liegt bei 7.6 Skalenpunkten




*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§

* Vergessen Sie nicht, Ihren do-file zu speichern (Klick auf die das blaue 
* Disketten-Icon links oben im do-file).
* Anschließend können Sie Stata beenden. 

exit






