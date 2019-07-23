// project:		Methoden 2, Übung # 12
// Tasks: 		Logistische Regression
// updated: 	2019/07/12


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



*******************************************************************************************
*§ 1 Vergleich lineare und logistische Regressionen: Wohnen in renovierungsbedürftigem Haus
*******************************************************************************************

* Wir stellen uns die Frage: Was beeinflusst die Wahrscheinlichkeit in einem Gebäude zu leben, 
* das renovierungsbedürftig ist?
* Die abhängige Variable hat also nur zwei Ausprägungen:
* 	1 = Befragte/r lebt in einem renovierungsbedürftigen Gebäude
*	0 = Befragte/r lebt NICHT in einem renovierungsbedürftigen Gebäude

/*
Aus der Tafelübung wissen Sie: "Bei kategorialer aV sind lineare Regressionsverfahren nur bedingt geeignet, es gibt Alternativen"

Und eine dieser Alternativen schauen wir uns heute an: die binäre logistische Regression (Logit).

Bei binären (0/1) Variablen interessiert uns die Wahrscheinlichkeit, mit der das Outcome 1 eintritt.
Bei Regressionen interessiert uns also, wie bestimmte unabhängige Variablen diese Wahrscheinlichkeit beeinflussen.
Also etwa: Beeinflusst das Geschlecht die Wahrscheinlichkeit der Wahlbeteiligung?
Beeinflusst die Kinderzahl die Wahrscheinlichkeit, in Vollzeit zu arbeiten?

Natürlich liegen Wahrscheinlichkeiten immer zwischen 0 und 1 (bzw. zwischen 0 und 100%).



Schauen wir uns zunächst das Beispiel an: Was beeinflusst die Wahrscheinlichkeit, in einem renovierungsbedürftigen
Gebäude zu leben? (Die Variable kennen Sie aus der letzten Übung)


Anhand dieses Beispiels wollen wir drei Dinge sehen:
	- wieso lineare Regressionen zu unplausiblen (logisch unmöglichen) Vorhersagen kommen können
	- wie sich logistische und lineare Regressionen in ihren Vorhersagen unterscheiden
	- und wieso dieser Unterschied im Forschungsalltag häufig gering ist
Wir vergleichen also logistische und lineare Regressionsmodelle.

WICHTIGER HINWEIS: Diese erste Übung soll Ihnen beim Grundverständnis des Unterschieds zwischen lienearen und 
logistischen Modellen helfen - Sie müssen aber *nicht* in der Lage sein, alle Einzelheiten des Codes zu verstehen oder zu reproduzieren!
*/


****Schritt 1: RELEVANTE VARIABLEN ANSEHEN/ERSTELLEN

* Interviewereinschätzung: Zustand des Wohngebäudes: renovierungsbedürftig? (ja/nein)
gen renovierungsbed = .
replace renovierungsbed = 0 if xh02 == 1 // Zustand GUT BIS SEHR GUT
replace renovierungsbed = 1 if inlist(xh02,2,3) // Zustand ETWAS RENOVIEREN - STARK RENOVIEREN
label variable renovierungsbed "Renovierungsbedürftig (1=ja)"
tab xh02 renovierungsbed, m // Generierte Variable überprüfen: Kreuztabelle mit Missings

* Einkommen in Tausend €:
gen inc_tsd = inc/1000
label variable inc_tsd "Eink. in 1000€"
hist inc_tsd




****Schritt 2: REGRESSIONSMODELLE
* Linear ("Linear Probability Model"):
reg renovierungsbed inc_tsd  
eststo reg

* Logistisch:
logit renovierungsbed inc_tsd  
eststo logit 
* Knappe Interpretation dieses Modells: mit höherem Einkommen sinkt die Wahrscheinlichkeit, 
* in einem renovierungsbedürftigen Haus zu leben. Dieser Einkommenseffekt ist statistisch 
* höchst signifikant (die Stärke des Effekts lässt sich bei einem logistischen Modell
* nicht so leicht herauslesen; dafür berechnet man am besten Margins - siehe unten).


*** WIESO LINEARE REGRESSIONEN ZU UNPLAUSIBLEN (LOGISCH UNMÖGLICHEN) VORHERSAGEN KOMMEN KÖNNEN &
*** (TEIL 1 VON DER FRAGE): WIE SICH LOGISTISCHE UND LINEARE REGRESSIONEN IN IHREN VORHERSAGEN UNTERSCHEIDEN


* Das sieht man gut, wenn man sich die vorhergesagten Werte (Wahrscheinlichkeit renovierungsbedürftig)
* für sehr unterschiedliche Einkommenswerte anschaut. Wir betrachten hierbei zur Illustration 
* auch Werte, die inhaltlich unplausibel sind (negative Einkommen und auch extrem hohe Einkommen).

* (Hinweis: Sie müssen den Code zur Erstellung der Grafik nicht im Detail nachvollziehen; 
*lassen Sie die Zeilen 110-122 einfach durchlaufen)
reg renovierungsbed inc_tsd  
eststo reg
margins, at(inc_tsd==(-20 (2) 20)) saving(reg,replace)


logit renovierungsbed inc_tsd  
eststo logit 
margins, at(inc_tsd==(-20 (2) 20)) saving(logit,replace)
ssc install combomarginsplot , replace
combomarginsplot reg logit 
combomarginsplot reg logit , file1opts(color(red%60)) fileci1opts(lcolor(red%60)) ///
file2opts(color(blue%60) ytitle("Vorhergesagte Wahrscheinlichkeit")) ///
  fileci2opts(lcolor(blue%60)) labels("reg" "logit") 
/* In der Grafik sehen wir, dass das lineare Modell einen linearen Zusammenhang zeichnet,
während das Logit-Model einen nicht-linearen, ungefähr S-förmigen Zusammenhang zeichnet.
Hier sehen wir auch gleich das Problem des linearen Modells: es sagt teilweise nicht plausible
Werte voraus: für Menschen mit extrem niedrigen (bzw. negativem) Einkommen sagt das Modell
Wahrscheinlichkeiten von über 1 (bzw. 100%) voraus; für sehr hohe Einkommen (ab ca. 6000€) sagt es
Wahrscheinlichkeiten kleiner 0 voraus.

Anders beim logistischen Modell: hier liegen alle vorhergesagten Wahrscheinlichkeitswerte 
zwischen 0 und 1.
 */ 

 
*** (TEIL 2 VON DER FRAGE): WIE SICH LOGISTISCHE UND LINEARE REGRESSIONEN IN IHREN VORHERSAGEN UNTERSCHEIDEN &
*** WIESO DIESER UNTERSCHIED IM FORSCHUNGSALLTAG HÄUFIG GERING IST

/*
In der Grafik oben haben wir uns zur Illustration die vorhergesagten Wahrscheinlichkeitswerte 
für extreme und teils unplausible Einkommenswerte angesehen.
Nun wollen wir die Grafik auf "realistische" bzw. typische Einkommenswerte beschränken:
fast 90% der Befragten haben ein Nettoeinkommen zwischen 500 und 4500€.
Wir erstellen also die gleiche Grafik wie oben, beschränkt auf diesen Wertebereich.
*/
 

* (Hinweis: Sie müssen den Code zur Erstellung der Grafik nicht im Detail nachvollziehen; 
*lassen Sie die Zeilen 149-158 einfach durchlaufen)
reg renovierungsbed inc_tsd  
margins, at(inc_tsd==(.5 (1) 4.5)) saving(reg,replace)


logit renovierungsbed inc_tsd   
margins, at(inc_tsd==(.5 (1) 4.5)) saving(logit,replace)
combomarginsplot reg logit 

combomarginsplot reg logit , file1opts(color(red%60)) fileci1opts(lcolor(red%60)) file2opts(color(blue%60)) ///
  fileci2opts(lcolor(blue%60)) labels("reg" "logit") 
 /*
 Wir sehen: für den typischen Einkommensbereich gibt es keine unplausiblen Vorhersagewerte (kleiner 0 oder größer 1)
 und die Vorhersagen des linearen und des logistischen Modells sind sich sehr ähnlich. 
 */

* Welches Modell trifft den realen bivariaten Zusammenhang am besten?
* Hierzu fügen wir der Grafik noch eine flexible, deskriptive Anpassungskurve mit Konfidenzintervall zu (in Gold):
* Hinweis: in älteren Stata-Versionen (älter als 15) wird die Grafik wohl nicht korrekt angezeigt.
combomarginsplot reg logit , file1opts(color(red)) fileci1opts(lcolor(red)) file2opts(color(blue)) ///
  fileci2opts(lcolor(blue)) labels("reg" "logit") ///
  addplot(lpolyci  renovierungsbed inc_tsd  if inrange(inc_tsd,.5,4.5), color(gold%25) clcolor(gold%100) )
* Im Grunde scheinen beide Modell den realen Zusammenhang ähnlich gut zu treffen 

* --> IM FORSCHUNGSALLTAG IST DER UNTERSCHIED ZWISCHEN LINEAREN UND LOGISTISCHEN MODELLEN HÄUFIG GERING.

 
 
****************************************
*§ 2 Was beeinflusst die Wahlbeteiligung
****************************************


/*
Nun wollen wir wissen: was beeinflusst die Wahrscheinlichkeit, dass Befragte wählen gehen?
Schätzen Sie dazu selbstständig ein logistisches Regressionsmodell und interpretieren Sie es!

Das Modell sollte folgende Variablen enthalten:
	- Abhängige Variable: hat die Person an der letzten Bundestagswahl teilgenommen? (1 = ja, 0 = nein)
	- Unabhängige Variable 1: Alter (linear)
	- Unabhängige Variable 2: Ost-West
	- Unabhängige Variable 3: eine theoretisch relevante Variable Ihrer Wahl. Es 
	kann (aber muss sich nicht) um eine Variable handeln, die wir schon in vorherigen Übungen benutzt haben.
*/


****Schritt 1: RELEVANTE VARIABLEN ANSEHEN/ERSTELLEN
* wahl: pv03
* alter: age
* ost-west: eastwest
* einkommen (linear) : inc

****Schritt 2: REGRESSIONSMODELLE
gen wahl = .
replace wahl = 0 if pv03 == 2
replace wahl = 1 if pv03 == 1
logit wahl age eastwest incc




* ZUSATZ(TEIL)AUFGABEN:

* Stellen Sie den Effekt von Alter auf die Wahlwahrscheinlichkeit grafisch dar. Erstellen Sie hierzu
* einen Marginsplot.


* Vergleichen Sie die Ergebnisse Ihres logistischen Regressionsmodells mit denen eines
* linearen Modells (Linear Probability Model).




*************************************************************************************
*************************************************************************************
*************************************************************************************
*****								LÖSUNGSHINWEISE								*****
*************************************************************************************
*************************************************************************************
*************************************************************************************

*********************************
*§ 2 Wahlbeteiligung & Geschlecht
*********************************

****Schritt 1: RELEVANTE VARIABLEN ANSEHEN/ERSTELLEN

*** Abhängige Variable: Gewählt?
gen gewaehlt =.
replace gewaehlt = 1 if pv03 == 1
replace gewaehlt = 0 if pv03 == 2
tab pv03 gewaehlt

*** Unabhängige Variable 1: Alter
hist age

*** Unabhängige Variable 1: Ost-West
gen west = .
replace west = 0 if eastwest == 2
replace west = 1 if eastwest == 1
label define west 0 "Ostdeutschland" 1 "Westdeutschland"
label values west west


*** Mögliche Unabhängige Variable 3: Bildung
fre educ
*Dummy Variable erstellen:
recode educ (1 2 3=0) (4 5=1) (6 7=.), gen(bild_hoch)
*Variable Labeln
	lab var bild_hoch "Bildung (Dummy)"
	lab def nh 0"niedrig" 1"hoch"
	lab val bild_hoch nh

****Schritt 2: REGRESSIONSMODELLE
logit gewaehlt age i.west i.bild_hoch

* Um die Effektgrößen zu interpretieren sind Average Marginal Effects hilfreich:
/*
Zitat Folien der Tafelübung: "Durchschnittliche Veränderung von P(Y=1) wenn die 
jeweilige uV marginal (~ um 1 Einheit) zunimmt (Durchschnitt über alle vorliegenden Beobachtungen)"
*/
margins, dydx(*) 


/*
INTERPRETATION: das kann sich natürlich je nach gewählter dritter unabhängiger Variable unterscheiden.

Wichtige Hinweise (aus der Tafelübung): 
- McFadden Pseudo-R2: Wie viel von der Likelihood des Nullmodells wird durch das Gesamtmodell „erklärt“?
	- NICHT: Anteil erklärter Varianz!
	- Null, wenn die weiteren X-Variablen nichts erklären
	- Maximum allerdings kleiner Eins (Fällt eher kleiner aus, als das R2 des LPM)
- Die Stärken/Größen der Effekte sind im logistischen Modell schwer zu beschreiben,
  Sie können sich deshalb auf Signifikanz und Richtung beschränken


In diesem Regressionsmodell (logit gewaehlt age i.west i.bild_hoch) sehen wir:
Unter Kontrolle von Region und Bildungsstand haben ältere Menschen eine signifikant
höhere Wahrscheinlichkeit wählen zu gehen. Mit jedem zusätzlichen Lebensjahr nimmt die
vorhergesagte Wahrscheinlichkeit um etwa 0,4%-Punkte zu (Average Marginal Effect).

Westdeutsche haben eine signifikant höhere Wahrscheinlichkeit wählen zu gehen als Ostdeutsche 
(Effektstärke: etwa 3%-Punkte).

Menschen mit höherer Bildung haben eine signifikant höhere Wahrscheinlichkeit wählen zu gehen 
als Menschen mit niedrigerer Bildung. Die Effektstärke ist beträchtlich: etwa 13%-Punkte.
*/

* ZUSATZ(TEIL)AUFGABEN:
* Stellen Sie den Effekt von Alter auf Wahlwahrscheinlichkeit grafisch dar. Erstellen Sie zuerzu
* einen Marginsplot.

logit gewaehlt age i.west i.bild_hoch
margins, at( age == (20 (10) 80)) 
marginsplot


* Vergleichen Sie die Ergebnisse Ihres logistischen Regressionsmodells mit denen eines
* Linear Probability Models.
logit gewaehlt age i.west i.bild_hoch
margins, dydx(*) post  // Die Option "post" ist hier nötig, um diese Ergebnisse dann später mit "esttab" zu benutzen
eststo logit

reg gewaehlt age i.west i.bild_hoch
eststo reg

* Tabelle zum Vergleich beider Modelle
esttab logit reg , p mtitle(Logistisch Linear)

* Interpretation: beide Modelle (logistisch und linear) schätzen fast identische Effektstärken und -Signifikanzen.


