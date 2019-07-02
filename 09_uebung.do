// project:		Methoden 2, Übung # 9
// Tasks: 		Multiple lineare Regression
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


/*Hinweis: alle hier verwendeten Beispiele sind exemplarischer Natur! Je nach 
  theoretischer Fundierung könnten die aufgestellten Thesen z.T. auch anders 
  gerichtet sein.
*/

*****************************************
*§ 1 Einkommen und Bildung und Geschlecht
*****************************************
/* Aus vorangegangenen Übungen ist bekannt, dass Bildung einen Einfluss auf das
Einkommen hat, ebenso wissen wir aus Übung 07, dass auch das Geschlecht einen Einfluss hat.
Wir wollen nun in einer multiplen linearen Regression herausfinden,
wie groß der Unterschied im Einkommen zwischen hoher und niedriger Bildung unter Kontrolle
des Geschlechts ist. 

Anschließend berechnen wir das geschätzte Einkommen für eine weibliche Person mit hoher Bildung.

Versuchen Sie alle Schritte nachzuvollziehen!

Anmerkung: Für Regressionen müssen die Variablen entweder
Dummy-kodiert (0/1) oder metrisch vorliegen!
*/


****Schritt 1: Relevante Variablen ansehen/erstellen
***Einkommen
sum inc, d
*Anmerkung: Metrische Variablen sollten immer daraufhin überprüft werden, ob 
*unplausible Werte oder Ausreißer enthalten sind. Der Forscher muss dann entscheiden, wie
*mit den möglichen unplausiblen Werten umgegangen wird (meist werden unplausible
*Werte aus der Analyse ausgschlossen). Wann ein Wert als 'Ausreißer' oder unplausibel
*gilt und warum diese Werte problematisch sind, wird in späteren Veranstaltungen   
*gelernt.

***Bildung
fre educ

*Dummy Variable erstellen:
recode educ (1 2 3=0) (4 5=1) (6 7=.), gen(dum_bil)
*Variable Labeln
	lab var dum_bil "Bildung (Dummy)"
	lab def nh 0"niedrig" 1"hoch"
	lab val dum_bil nh
*Überprüfen
tab educ dum_bil

***Geschlecht
fre sex

gen woman=sex-1

lab var woman "Geschlecht: weiblich"
lab def jn 0"nein" 1"ja"
lab val woman jn

fre woman


****Schritt 2: Regression 

regress inc dum_bil woman

****Schritt 3: Interpretation
* Das Modell beruht auf 3077 Fällen.
* Das R2 liegt bei 0.1736 (-->17.36% der Varianz werden durch die unabhängigen Variablen
* erklärt)
* Unter Kontrolle des Geschlechts verdienen Personen mit hoher Bildung durchschnittlich
* 688.8€ Euro mehr als Personen mit niedriger Bildung.
* Dieser Wert ist statistisch höchst signifikant.
* Unter Kontrolle der Bildung verdienen Frauen durchschnittlich 747.8€ weniger als
* Männer.
* Dieser Wert ist statistisch höchst signifikant.

****Schritt 4: Vorhersage
*Die Regressionsgleichung lautet:
*y=b0+b1*dum_bil+b2*woman (allg.: y=b0+b1*x+b2*x)

*Einsetzen ergibt: 
gen intercept = _b[_cons]
gen beta_bil = _b[dum_bil]
gen beta_woman = _b[woman]
display intercept + 1*beta_bil + 1*beta_woman
*y=1785.99+688.77*1+(-747.88*1)
display 1785.99+688.77-747.88

*Eine weibliche Person mit hoher Bildung verdient durchschnittlich 1726.88€.

*****************************************
*§ 2 Einkommen, Alter, Gesundheitszustand
*****************************************
/* Wir nehmen weiter an, dass das Einkommen vom Gesundheitszustand beeinflusst wird.
Das Alter einer Person hat dabei sowohl einen Einfluss auf das Einkommen als auch auf
den Gesundheitszustand einer Person, das Alter ist dieser Argumentation nach ein 
Confounder. Wir nehmen den Gesundheitszustand und das Alter in unser Regressionsmodell
auf.

Es gibt verschiedene Varianten Dummy-Variablen in ein Modell aufzunehmen (siehe Tafelübung). 

Schätzen Sie ein Regressionsmodell in dem Sie die Dummy-Variablen per Hand 
zuvor gebildet haben und ein Modell mit der 'i.'-Schreibweise
(Anmerkung: Referenzkategorie soll "schlechter Gesundheitszustand" sein;
versuchen Sie aber zusätzlich die Referenzkategorie zu ändern und beobachten Sie,
was sich im Ergebnis verändert)!

Benötigte Variablen: inc, age (am Mittelwert zentriert!) und
hs01 (-->hs01 soll wie folgt zusammengefasst werden:
0=weniger gut und schlecht, 1=zufriedenstellend, 2=gut und sehr gut)

Interpretieren Sie auch die Konstante inhaltlich.

Führen Sie die bekannten Schritte der Reihe nach durch.

Hinweis: Am Ende des Do-Files finden Sie Lösungshinweise!
*/

*Variablenaufbereitung:
*Alter
sum age, d
gen age_mean = r(mean)
gen age_centr = age - age_mean
lab var age_centr "Centered Age"

*Gesundheitszustand
fre hs01

recode hs01 (4 5=0) (3=1) (1 2=2), gen(health)

lab var health "health"
lab def lab_health 0"niedrig" 1"mittel" 2"hoch"
lab val health lab_health
fre health

*Dummy-Variablen bilden
recode health (1 2=0) (0=1), gen(health_low)
recode health (0 2=0) (1=1), gen(health_nor)
recode health (0 1=0) (2=1), gen(health_good)

lab var health_low "health low"
lab var health_nor "health nor"
lab var health_good "health good"

lab def yesno 0"no" 1"yes"
lab val health_low yesno
lab val health_nor yesno
lab val health_good yesno

fre health_low
fre health_nor
fre health_good

****Schritt 2: Regression mit einzelnen Dummy-Variablen
reg inc age health_low health_nor health_good

****Schritt 3: Regression mit 'i.'-Schreibweise
reg inc age i.health
* aendern der referenzkategorie
reg inc age ib2.health
* specify the base level of a factor using the ib operator
reg inc age ibn.health
/*
ib#. use # as base # = value of variable 
ib(##). use #th ordered value as base 
ib(first). use smallest value as base => default
ib(last). use largest value as base
ib(freq). use most frequent value as base
ibn. no base level => omits the last one and actually returns 0 as coefficient
*/

****Schritt 4: Interpretation
/*
n = 3093; just 3.4% of the variance in the data can be explained by the variance
in the data. 
all coefficients are statistically significant, in the base model the coefficients
are to be interpreted in reference to the default category => low health in this case
Every year a person ages increases their income by 6.9€ ceteris paribus (also sig)
Interpretation of the intercept: 
Expected income of a person that is of average age (display age_mean = 51.1 years)
if that person is a member of the reference category => low health.
*/



***************************************************
*§ 3 Lebenszufriedenheit, Einkommen und Geschlecht
***************************************************
* (Optionale Zusatzaufgabe, falls Zeit oder als Vorbereitung für Klausur / Hausarbeit)
/* Aus der letzten Übung ist bekannt, dass sowohl das Einkommen als auch das Geschlecht
die Lebenszufriedenheit beeinflusst. Wir schätzen nun eine multiple Regression mit 
Einkommen und Geschlecht als unabhängige Variablen. Wir haben bisher herausgefunden,
dass das Geschlecht einen Einfluss auf das Einkommen und auch die Lebenszufriedenheit hat; 
das Geschlecht nehmen wir also als Confounder in unsere Analyse auf. 

Verwenden Sie wieder die Variable "Einkommen in Tausend Euro" (bekannt von letzter Woche).

Berechnen Sie die durchschnittliche Lebenszufriedenheit einer männlichen Person 
mit einem Einkommen von 2500€.


Führen Sie die bekannten Schritte der Reihe nach durch.

Hinweis: Am Ende des Do-Files finden Sie Lösungshinweise!
*/
****Schritt 1: Variable ansehen/erstellen
fre ls01
gen inc_tsd = inc/1000
fre inc_tsd
fre woman
****Schritt 2: Regression
reg ls01 inc_tsd woman
****Schritt 3: Interpretation
/*
n = 3096; just 4.8% of the variance in the data can be explained by the regressors
all estimated coefficients are of statistical significance
The expected happiness of a nonwoman (man) with an income of 0€ would be 6.9.
Controlling for income the women seem to rate themselves 0.45 points happier than men
Every 1000€ a person earns increases their expected happiness by 0.32 points. (ceteris paribus)
*/
****Schritt 4: Vorhersage
gen inter = _b[_cons]
gen beta_inc_tsd = _b[inc_tsd]
gen beta_gender = _b[woman]
display inter + 0*beta_gender + 2.5*beta_inc_tsd

exit
