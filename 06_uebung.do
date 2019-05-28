// project:		Methoden 2, Übung # 6
// Tasks: 		Korrelationen, Streudiagramme
// updated: 	2019/05/20


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


* Sie wollen herausfinden, ob es einen Zusammenhang zwischen der politischen
* Selbstverortung und Antisemitismus gibt.


******************************************
*§ 1 Reliabilitätsanalyse / Indexbildung
******************************************

/* Zunächst interessieren Sie sich für das Ausmaß antisemitischer Einstellungen.
 Sie wollen eine Maßzahl erstellen, die Ihnen Auskunft über das Ausmaß
 antisemitischer Einstellungen gibt. Dazu betrachten Sie die relevanten
 Items im Fragebogen. Um zu prüfen, ob diese das gleiche latente Konstrukt
 ("Antisemitismus") messen führen Sie eine Reliabilitätsanalyse durch.
 
 Lassen Sie die Befehle Schritt für Schritt durchlaufen und versuchen Sie, 
 die Schritte selbstständig nachzuvollziehen und zu verstehen.
 
 Üben Sie auch die Interpretation der Ergebnisse. */


*** Schritt 1: Reliabilitätsanalyse

codebook mj01-mj06 // vollständige Fragetexte finden Sie im Codebook
* Hinweis: Das Codebook haben Sie zusammen mit den Daten von der Gesis heruntergeladen.

alpha mj01-mj06, item // mj02 automatisch umgepolt
* mj02 weist geringe Korrelation mit übrigen Items auf
* Cronbach's alpha wäre unter Ausschluss von mj02 höher

alpha mj01 mj03-mj06, item
* mj06 weist vergleichsweise geringe Korrelation mit übrigen Items auf
* Cronbach's alpha wäre unter Ausschluss von mj06 höher

alpha mj01 mj03-mj05, item
* Items weisen (alle) relativ hohe Korrelationen untereinander auf
* Cronbach's alpha unter Einbezug aller Items maximal


*** Schritt 2: Indexbildung

alpha mj01 mj03-mj05, item gen(antisem)

fre antisem
lab var antisem "Index: Antisemitische Einstellung"
lab def indexlbl 1"gering" 4"mäßig" 7"ausgeprägt"
lab val antisem indexlbl
fre antisem

hist antisem, w(0.5) d percent





**************************************
*§ 2 Streudiagramm
**************************************

/* Sie wollen nun prüfen, ob es einen Zusammenhang zwischen der politischen
 Selbstverortung auf einer Links-Rechts-Skala und antisemitischen Einstellungen
 gibt. Um zu prüfen, ob die Annahme eines linearen Zusammenhangs gerechtfertigt
 ist erstellen Sie zunächst ein Streudiagramm.
 
 Tipp: Zur Suche geeigneter Variablen können Sie die Suchfunktion im
 Variablenfenster (rechts oben) nutzen. Am Ende dieses do-files finden Sie
 Hinweise zur Überprüfung Ihres Ergebnisses.
 
 Tipp: Ggf. ist es sinnvoll übereinander liegende Beobachtungen im Streudiagramm
 zu "verwackeln". */

 fre pa01
 scatter antisem pa01, jitter(2)


* Was folgern Sie aus dem Ergebnis? Scheint die Annahme eines linearen 
* Zusammenhangs gerechtfertigt?

/*
Ein linearer zusammenhang scheint möglich, da es scheint als wären die Punkte 
hauptsächlich auf der Diagonalen angesiedelt. 
Allerdings reicht eine rein visuelle Analyse nicht aus. 
*/



/* Mithilfe der "twoway"-Optionen können Sie mehrere Grafen übereinander plotten.
 Diese Möglichkeit kann dazu genutzt werden eine zusätzliche Anpassungsgerade
 in das Streudiagramm einzuzeichnen.
 
 In den folgenden Zeilen finden Sie ein Beispiel. Versuchen Sie das Beispiel
 mithilfe der help-Funktion nachzuvollziehen. */

graph twoway (scatter antisem pa01, jitter(5)) (lfit antisem pa01)
graph twoway (scatter antisem pa01, jitter(5)) (mband antisem pa01)
graph twoway (scatter antisem pa01, jitter(5)) (lfitci antisem pa01)
graph twoway (scatter antisem pa01, jitter(5)) (lowess antisem pa01)

help twoway
help lfit




**************************************
*§ 3 Korrelationen
**************************************

/* Anschließend berechnen Sie den Korrelationskoeffizienten für den Zusammenhang
 zwischen der politischen Selbstverortung und antisemitischen Einstellungen.
 
 Lassen Sie sich dabei auch den p-Wert sowie die Anzahl zugrunde liegender 
 Beobachtungen ausgeben. */

pwcorr antisem pa01, sig obs



* Was können Sie aus dem Ergebnis folgern?

/*
Es besteht ein schwacher zusammenhang (r = 0.2335) dieser Zusammenhang ist 
hoechst signifikant.
*/



**************************************
*§ 4 Zur Wiederholung
**************************************

* (Optionale Zusatzaufgabe, falls Zeit oder als Vorbereitung für Klausur / Hausarbeit)

/* Sie möchten nun herausfinden ob sich das Ausmaß antisemitischer Einstellungen
 zwischen verschiedenen Subgruppen unterscheidet. Überlegen Sie dafür zunächst
 inhaltlich zwischen welchen Gruppen sich die Zustimmung zu antisemitischen Aussagen
 unterscheiden könnte. Führen Sie anschließend die Ihnen bekannten Schritte zur
 Untersuchung eines möglichen Zusammenhangs durch. Stellen Sie diesen auch grafisch
 anhand eines Boxplots dar.
 
 Als Hilfestellung können dabei Ihre Unterlagen aus den vorigen Sitzungen sowie
 die Vorlesungsfolien dienen. Vergessen Sie dabei nicht die Ergebnisse
 auch inhaltlich zu interpretieren und schriftlich festzuhalten. */

 scatter antisem hhinc

 /*
 Schritt 1: logtransformieren der variable Einkommen
 */
 
generate loginc = ln(hhinc)
scatter antisem loginc

graph twoway (scatter antisem loginc, jitter(5)) (lfitci antisem loginc)


/*
Untersuchung nach Subgruppen: 
mc04: Auslaender - Kontakt im Freundeskreis?
*/

generate auslfr = .
replace auslfr = 0 if (mc04 == 2)
replace auslfr = 1 if (mc04 == 1)

lab var auslfr "Index: Auslaender im Freundeskreis"
lab def auslfrlab 0"Nein" 1"Ja"
lab val auslfr auslfrlab
fre auslfr

// scatterplot with confidenceband
graph twoway (scatter antisem auslfr, jitter(5)) (lfitci antisem auslfr)
// correlation table
pwcorr antisem auslfr, sig obs
// es besteht ein signifikanter zusammenhang der schwach bis mittel ausgepraegt 
// ist

graph box antisem, over(auslfr) 
// Auch der Boxplot lässt vermuten, dass Leute die Auslaender im Freundeskreis
// haben weniger antisemitische Ansichten haben. 

/*
Mittelwertsvergleich => ttest
*/

ttest antisem, by(auslfr)
// Auch der t-test zum Vergleich der Gruppenmittelwerte unter der Annahme 
// gleicher Varianzen liefert diese Ergebnisse. 


exit





