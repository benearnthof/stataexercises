// project:		Methoden 2, Übung # 7
// Tasks: 		Drittvariablen: Mediation, Moderation, Confounder
// updated: 	2019/06/07


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
  Ebenso sind meist auch noch weitere Drittvariablen wichtig um den Zusammenhang
  erklären zu können. Multivariate Analyseverfahren lernen Sie in den nächsten 
  Wochen.
*/

*********************************************************
*§ 1 Bildung und Einkommen: Unterschiede nach Geschlecht?
*********************************************************

/*	Zunächst interessieren Sie sich dafür, ob sich für Männer und Frauen die 
	Bildung	unterschiedlich im Einkommen auszahlt. Dazu betrachten Sie zunächst 
	den Zusammenhang zwischen Bildung und Einkommen ohne dem Einfluss von 
	Geschlecht.
	In einem nächsten Schritt erstellen Sie weitere Kreuztabellen, die  nach
	Geschlecht unterscheiden. 
	Beachten Sie: Für Kreuztabellen müssen die Variablen kategorial sein,
	d.h. Variablen müssen eventuell zusammengefasst werden.
	
	Versuchen Sie die Schritte nachzuvollziehen!*/


*** Schritt 1: Variablen vorbereiten
*Einkommen
	sum inc, d
	codebook inc
	*Achtung auf Missings beim Umkodieren!
	*Die Missings sind hier .e .k und .o (bspw. über 'fre inc' herauszufinden)
	*Um lange if-Bedingungen zu vermeiden, kodieren wir alle Missings auf '.'.
	
	gen inc1=inc   //nicht die Originalvariable überschreiben!
	recode inc1 (.e .k .o =.)
	fre inc1
	
	*Variable generieren
	gen dum_ek=.
	replace dum_ek= 0 if inc1 <=1400 
	replace dum_ek=1 if inc1 >1400 & inc1 !=.
	
	
*Erklärung: wir splitten die metrische Variable am Median. 
*Achtung: Kategorisierung von metrischen Variablen ist nicht immer sinnvoll. 
*Für Kreuztabellen ist es notwendig, bei Regressionen (nächste Stunden) bspw. nicht.

	*Variable und Werte labeln
	lab var dum_ek "Dummy: Einkommen"
	lab def hn 0"niedrig" 1"hoch"
	lab val dum_ek hn
	*Überprüfen
	fre dum_ek


*Bildung (Vorgehen bekannt aus Sitzung 5)
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
	
	
*Geschlecht
	fre sex
	
	*bereits dichotom, passt so
	/*Anmerkung: Die Variable ist allerdings keine Dummy-Variable(0/1).
	Vorgehen für Dummy (->Beispiel):
	gen woman= sex-1
	lab var women "Geschlech weiblich"
	lab def jn 0"nein" 1"ja"
	lab val woman jn
	fre woman
	*/


*** Schritt 2: Kreuztabelle ohne Drittvariable
tab dum_ek dum_bil, column chi2 V
*moderater höchstsiginifikanter Zusammenhang (p<0.001, V=0.2270)

*** Schritt 3: Kreuztabelle mit Drittvariable
bysort sex: tab dum_ek dum_bil, column chi2 V

/*Für Männer liegt ein moderater Zusammenhang vor, der höchstsignifikant ist 
  (p<0.001, V=0.1856)
  Der Zusammenhang ist schwächer als der für alle Befragten.
  Für Frauen liegt ein moderater Zusammenhang vor, der höchstsignifikant ist 
  (p<0.001, V=0.2923)
  Der Zusammenhang ist stärker als der für alle Befragtem
*/


*** Schritt 4: Bewertung Drittvariableneffekt


/*Es liegt eine Interaktion vor, das Geschlecht ist ein Moderator.
Je nach Gruppe liegt entweder ein stärkerer oder schwächerer Zusammenhang 
als für alle Befragten vor.
Für Frauen ist die Korrelation zwischen Bildung und Einkommen stärker als für Männer. 
Für Männer ist die Korrelation schwächer als für Frauen.
(Anmerkung: Ob der Interaktionseffekt statistisch signifikant ist, muss mit anderen 
Verfahren (bspw. Regression) gestestet werden.)
*/

*****************************************************
*§ 2 Kirchgangshäufigkeit in Ost- und Westdeutschland
******************************************************

/* 
Sie untersuchen den Zusammenhang zwischen Wohnort (Ost- vs. West-D)
und Kirchgangshäufigkeit und finden einen Zusammenhang, der statistisch 
signifikant ist. 
Sie möchten nun herausfinden, ob es sich hierbei nur um einen scheinbaren
Zusammenhang handelt! Eine mögliche Drittvariable könnte die 
Konfessionszugehörigkeit sein. 
Führen Sie die bekannten Schritte durch und bewerten Sie den Drittvariableneffekt! 
Zeichnen Sie sich als Hilfe ein Kausalschema auf!
   
   
   Hinweis: Am Ende des Do-Files finden Sie Lösungshinweise!
   Variablen: rp01, eastwest, rd01
   rp01 (Kirchgangshäufigkeit) soll wie folgt zusammengefasst werden:
   selten/nie =0: Ausprägungen 5 und 6
   öfter=1: Ausprägungen 1 bis 4
 
   rd01 (Konfession) soll wie folgt zusammengefasst werden:
   Evangelisch=1: Ausprägung 1   
   römisch-katholisch=2: Ausprägung 3
   konfessionslos=3: Ausprägung 6
   restliche Ausprägungen=.
   
   Schließen Sie für die Kreuztabelle temporär Fälle mit fehlenden Angaben in der
   Konfession aus [Hilfe: bysort drittvar: tab aV uV if konfession!=., col chi2 V]*/

	*Kirchgangshäufigkeit 
	fre rp01
	gen kirchgang=.
	replace kirchgang =1 if rp01 ==1 | rp01==2 |rp01==3 | rp01==4 
	replace kirchgang =0 if  rp01==5 | rp01==6
	
	*Variable und Werte labeln
	label var kirchgang "Kirchgaenge"
	lab def soe 0"selten/nie" 1"oefter"
	lab val kirchgang soe

	tab rp01 kirchgang,m
	
	**Konfession 
	fre rd01

	*Variable generieren
	gen konfession=.
	replace konfession=1 if rd01==1 
	replace konfession=2 if rd01==3
	replace konfession=3 if rd01==6

	*Variable und Werte labeln
	lab var konfession "Konfession des Befragten" 
	lab def konfe 1"evangelisch" 2"katholisch" 3"none"
	lab val konfession konfe
	tab rd01 konfession, m

	* variable fuer ost und west deutschland
	fre eastwest
	
*** Schritt 2: Kreuztabelle ohne Drittvariable
tab kirchgang eastwest, column chi2 V
*moderater höchstsiginifikanter Zusammenhang (p<0.001, V=0.2270)

*** Schritt 3: Kreuztabelle mit Drittvariable
bysort konfession: tab kirchgang eastwest, column chi2 V


***Schritt 4: Bewertung Drittvariableneffekt
* Kreuztabelle ohne Drittvariable: V= |0.2320|; p<0.001
* Kreuztabelle für evangelisch: V=|0.0683| ; p<0.05
* Kreuztabelle für nicht römisch-katholisch: V=|0.0526| ;p>0.05
* Kreuztabelle für konfessionslos: V=|0.0915|; p<0.01
/*Berwertung: hier könnte eine Mediation vorliegen, da alle Zusammenhänge nach
Kontrolle auf Konfession schwächer sind. Es müsste dann der Wohnort die Konfession 
beeinflussen und die Konfession die Kirchgangshäufigkeit. Wenn diese Argumentation
nicht plausibel erscheint,dann handelt es sich um einen Confounder.
*/
* effekt fuer missing konfession nicht signifikant da sehr kleine stichprobengroesse


*********************************
*§  3 Einkommen und Attraktivität
*********************************

/*	Sie wollen nun herausfinden, ob es einen Zusammenhang zwischen dem Einkommen 
	und der Attraktivität gibt. Sie stellen die These auf, dass attraktivere Personen
	ein höheres Einkommen erzielen. Eine relevante Drittvariable kann hier der 
	Gesundheitszustand sein. Testen Sie, ob der Gesundheitzustand den 
	Zusammenhang beeinflusst. 
	Wenn ja, beurteilen und bewerten Sie den gefundenen Effekt!
	
	Gehen Sie die bekannten Schritte durch und interpretieren
	Sie Ihre Ergebnisse.(Zeichnen Sie sich als Hilfe ein Kausalschema auf!)
	
	Hinweis: am Ende des Do-Files finden Sie Lösungshinweise!
	Variablen: hs01, xr14, inc
	
	xr14 und inc sind (quasi-)metrische Variablen, wir verwenden also Korrelationen!
	[-->Hilfe: Befehl: pwcorr aV uV, sig]
	
	hs01 (Gesundheitszustand) soll wie folgt zusammengeafsst werden: 
	sehr gut (1) und gut(2) =1
	zufriedenstellend (3), schlecht (4) und sehr schlecht (5)=0
	*/
	

***Schritt 1: relevante Variablen erstellen/prüfen
* variable fuer einkommen: dum_ek
* variable fuer attraktivitaet: dum_att

	*Variable generieren
	gen dum_att=.
	replace dum_att = 0 if xr14 <= 7
	replace dum_att = 1 if xr14 > 7

	*Variable und Werte labeln
	lab var dum_att "Attraktivitaet des Befragten" 
	lab def dum_att_lab 0"hoch" 1"niedrig"
	lab val dum_att dum_att_lab
	fre dum_att
	
* variable fuer gesundheitszustand: hs01
	fre hs01
	
	
***Schritt 2: Korrelation ohne Drittvariable
	tab dum_ek dum_att, column chi2 V
	
***Schritt 3: Korrelation mit Drittvariable
bysort hs01: tab dum_att dum_ek, column chi2 V


***Schritt 4: Bewertung Drittvariableneffekt
* no idea, die aufteilung in dummykategorien war nicht sinn der sache
pwcorr inc xr14, sig
bysort gesund: pwcorr inc xr14

*Korrelationstabelle ohne Drittvariable: r=0.0980, p<0.001
*Korrelationstabelle gute Gesundheit: r=0.0496, p<0.05
*Korrelationstabelle schlechte Gesundheit: r=0.1011, p<0.001

*Interpretation:
*ohne Drittvariable:
/*Es besteht ein schwacher Zusammenhang zwischen der Attraktivität und 
dem Einkommen, der Zusammenhang ist höchst signifikant (r=0.0980, 
p<0.001). Je attraktiver eine Person ist, desto höher ist ihr Einkommen.
*/

/*Für Personen mit schlechtem Gesundheitszustand besteht ein schwacher aber höchst siginifikanter 
Zusammenhang zwischen Attraktivität und dem Einkommen; je attraktiver eine (kranke) Person, 
desto höher ist das Einkommen (r=0.1011, p<0.001).
Für Personen mit gutem Gesundheitszustand besteht ein schacher signifikanter 
Zusammenhang zwischen Attratktivität und dem Einkommen; je attraktiver eine (gesunde) Person, 
desto höher ist das Einkommen (r=0.0496, p<0.05)	
*/
*Bewertung Drittvariableneffekt
/*Für Personen mit schlechtem Gesunheitszustand ist die Korrelation zwischen 
Attraktivität und Einkommen höher als für alle Personen und Personen 
mit gutem Gesundheitszustand (r=0.1011 vs. r=0.098 vs. r=0.0496).
Für Personen mit gutem Gesundheitszusatnd ist die Korrelation zwischen 
Attraktivität und Einkommen schwächer als für alle Personen und für Personen mit 
schlechtem Gesundheitszustand (r=0.0496 vs. r=0.098 vs. r=0.1011).

--> Attraktivität zahlt sich 'mehr' für Personen mit schlechtem Gesundheitszustand aus
(Anmerkung: Ob der Interaktionseffekt statistisch signifikant ist, muss mit anderen 
Verfahren (bspw. Regression) gestestet werden..)
*/

**********************************
*§ 4 Fremdenfeindliche Einstellung
**********************************
* (Optionale Zusatzaufgabe, falls Zeit oder als Vorbereitung für Klausur / Hausarbeit)
/*	Sie wollen nun prüfen, ob es einen Zusammenhang zwischen dem Kontakt zu Ausländern (uV)
	und einer fremdenfeindlichen Einstellung (aV) gibt. Zudem interessiert Sie, ob eine 
	Erwerbstätigkeit (Drittvariable) diesen Zusammenhang beeinflusst.
 
Hinweis: um den Kontakt zu Ausländern zu messen, verwenden Sie die Variable, die angibt,
	ob man in der Nachbarschaft Kontakt zu Ausländern hat. 
	Um eine fremdenfeindliche Einstellung zu messen, verwenden Sie die Variable, die 
	angibt, ob man der Meinung ist, dass bei Arbeitsplatzknappheit Ausländer das Land 
	verlassen sollen. 
	
 Am Ende dieses do-files finden Sie Hinweise zur Überprüfung Ihres Ergebnisses.
 
*/



*** Schritt 1: Relevante Variablen vorbereiten
fre mc03 
	recode mc03 (1=1) (2=0), gen(contact)
	fre contact
	lab var contact "Kontakt zu Ausländern in der Nachbarschaf"
	lab def jn 0"nein" 1"ja"
	lab val contact jn
	fre contact
	fre ma02

	gen fremdenf=.
	replace fremdenf=0 if ma02==1 | ma02==2 | ma02==3
	replace fremdenf=1 if ma02==4 | ma02==5 | ma02==6 | ma02==7

	lab var fremdenf "Fremdenfeinlichkeit"
	lab val fremdenf jn

	fre fremdenf
	
	fre work

	gen erwerb=.
	replace erwerb=1 if work==1|work==2|work==3
	replace erwerb=0 if work==4

	lab var erwerb "Erwerbstätig?"
	lab val erwerb jn

	fre erwerb

*** Schritt 2: Kreuztabelle ohne Drittvariable
tab contact fremdenf, column chi2 V
	

*** Schritt 3: Kreuztabelle mit Drittvarialbe
bysort erwerb: tab contact fremdenf, column chi2 V

*** Schritt 4: Bwertung Drittvariable
	
* Kreuztabelle ohne Drittvariable: V= |0.1466|; p<0.001
* Kreuztabelle für Erwerbstätige: V=|0.1457|; p<0.001
* Kreuztabelle für nicht Erwerbstätige: V=|0.1285|; p<0.001
* Drittvariableneffekt:Confounder; Mediator scheint hier aufgrund zeitlicher 
* Struktur unplausibel.
*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§

* Vergessen Sie nicht, Ihren do-file zu speichern (Klick auf die das blaue 
* Disketten-Icon links oben im do-file).
* Anschließend können Sie Stata beenden. 

exit





