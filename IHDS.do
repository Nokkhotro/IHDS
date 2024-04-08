** Generate a new state column `RSTATEID` with relevant states
generate RSTATEID=1 if STATEID==28, after(STATEID)
replace RSTATEID=2 if STATEID==33
replace RSTATEID=3 if STATEID==32
replace RSTATEID=4 if STATEID==29
replace RSTATEID=5 if STATEID==31
replace RSTATEID=6 if STATEID==35
replace RSTATEID=7 if STATEID==34

label variable RSTATEID "State Names"

label define RSTATEID 	///
	1 "Andhra Pradesh" 	///
	2 "Tamil Nadu" 		///
	3 "Kerala" 			///
	4 "Karnataka" 		///
	5 "Lakshawadeep" 	///
	6 "A&N Islands" 	///
	7 "Pondicherry"
label value RSTATEID RSTATEID

** Generate `SOCREL` column given the following criteria:
/* 1 = HFC [Hindu FC (others)]
 * 2 = HOBC [Hindu OBC]
 * 3 = HSC [Hindu SC]
 * 4 = HST [Hindu ST]
 * 5 = Muslims
 * 6 = Others [Sikh, Buddhist, Christian, etc.] */

rename XGROUPS6 SOCREL
label variable SOCREL "Socio-Religious Identity"

label define SOCREL 2 "HFC" 3 "HOBC" 4 "HSC" 5 "HST" 6 "Muslims" 7 "Others"
label value SOCREL SOCREL


** --- Section A ---

** --- 1 ---
tab SOCREL if RSTATEID != .
graph bar (count) if RSTATEID != ., over(SOCREL) ///
	title("Socio-Religious Group Distribution") blabel(total)

** --- 2 ---
tab SOCREL XPOOR1 if RSTATEID != .
graph pie if XPOOR1 == 0 & RSTATEID != ., over(SOCREL) plabel(_all percent) title("NON POOR SOCREL")
graph pie if XPOOR1 == 1 & RSTATEID != ., over(SOCREL) plabel(_all percent) title("POOR SOCREL")
** graph pie if RSTATEID != ., over(SOCREL) by(XPOOR1) plabel(_all percent)

** --- 3 ---
tab SOCREL URBAN
bysort URBAN: tab SOCREL if XPOOR1 == 1 		// Doubt
graph pie if XPOOR1==1, over(SOCREL) by(URBAN) 	// Doubt

** --- 4 ---
tab SOCREL XPOOR1 if RSTATEID != .
graph pie if POOR2 == 0 & RSTATEID != ., over(SOCREL) plabel(_all percent) title("NON POOR SOCREL")
graph pie if POOR2 == 1 & RSTATEID != ., over(SOCREL) plabel(_all percent) title("POOR SOCREL")

bysort URBAN: tab SOCREL if POOR2 == 1 			// Doubt
graph pie if POOR2==1, over(socrel) by(URBAN)	// Doubt

** --- 5 ---
** Generate a `TRANS` to represent poverty transitions
/* 1 = NP2NP [Non Poor to Non Poor]
 * 2 = NP2P [Non Poor to Poor]
 * 3 = P2NP [Poor to Non Poor]
 * 4 = P2P [Poor to Poor]  
 * . = . [Inconclusive] */

egen TRANS = group(XPOOR1 POOR2)
order XPOOR1, before(POOR2)
order TRANS, after(POOR2)

label variable TRANS "Transitions and Persistence of Poverty"
label define TRANS 					///
	1 "NP2NP - Persistence"			///
	2 "NP2P - Poverty Transition" 	///
	3 "P2NP - Poverty Transition"	///
	4 "P2P - Poverty Persistence"
label value TRANS TRANS

** Direction of Transition and Persistence
generate TRANS_DIR = 0 if TRANS == 2 | TRANS == 4
replace TRANS_DIR = 1 if TRANS == 1 | TRANS == 3
order TRANS_DIR, after(TRANS)

label variable TRANS_DIR "Implications of the Transitions and Persistence"
label define TRANS_DIR 0 "Bad" 1 "Good"
label value TRANS_DIR TRANS_DIR

** Matrix Analysis
tab TRANS SOCREL if RSTATEID != ., row col
bysort TRANS_DIR: tab TRANS SOCREL if RSTATEID != ., row col

**Pie Chart Analysis - FOR EACH SOCREL GROUP WHAT WAS THE TREND?
graph pie if SOCREL == 2 & RSTATEID != ., over(TRANS) plabel(_all percent) pie(_all, explode(5))
graph pie if SOCREL == 3 & RSTATEID != ., over(TRANS) plabel(_all percent) pie(_all, explode(5))
graph pie if SOCREL == 4 & RSTATEID != ., over(TRANS) plabel(_all percent) pie(_all, explode(5))
graph pie if SOCREL == 5 & RSTATEID != ., over(TRANS) plabel(_all percent) pie(_all, explode(5))
graph pie if SOCREL == 6 & RSTATEID != ., over(TRANS) plabel(_all percent) pie(_all, explode(5))
graph pie if SOCREL == 7 & RSTATEID != ., over(TRANS) plabel(_all percent) pie(_all, explode(5))

graph pie if TRANS == 1 & RSTATEID != ., over(SOCREL) plabel(_all percent) pie(_all, explode(5))
graph pie if TRANS == 2 & RSTATEID != ., over(SOCREL) plabel(_all percent) pie(_all, explode(5))
graph pie if TRANS == 3 & RSTATEID != ., over(SOCREL) plabel(_all percent) pie(_all, explode(5))
graph pie if TRANS == 4 & RSTATEID != ., over(socrel) plabel(_all percent) pie(_all, explode(5))

* graph pie if RSTATEID != ., over(TRANS) by(SOCREL) plabel(_all percent) pie(_all, explode(5))
* graph pie if RSTATEID != ., over(SOCREL) by(TRANS) plabel(_all percent) pie(_all, explode(5))


** --- Section B ---

** --- 1 ---
** Generate a `SOL_DIR` to represent direction of change of standard of living
/* 0 = Negative
 * 1 = Unchanged
 * 2 = Positive
 * . = . [Inconclusive] */

// WARNING: "necessarily not poor," how to proceed?
generate SOL_DIR = 0 if XASSETS5 > ASSETS5
replace SOL_DIR = 1 if XASSETS5 == ASSETS5
replace SOL_DIR = 2 if XASSETS5 < ASSETS5 & ASSETS != .

label variable SOL_DIR "Direction of Change of Standard of Living"
label define SOL_DIR 0 "Negative" 1 "Unchanged" 2 "Positive"
label value SOL_DIR SOL_DIR

** Similarly, generate an `ASSETS_DIR` to represent the change in asset holdings
generate ASSETS_DIR = 0 if XASSETS2005 > ASSETS2005
replace ASSETS_DIR = 1 if XASSETS2005 == ASSETS2005
replace ASSETS_DIR = 2 if XASSETS2005 < ASSETS2005 & ASSETS != .

label variable ASSETS_DIR "Direction of Change in Asset Holdings"
label define ASSETS_DIR 0 "Negative" 1 "Unchanged" 2 "Positive"
label value ASSETS_DIR ASSETS_DIR

** --- 2 ---
tab SOCREL SOL_DIR
tab SOCREL ASSETS_DIR

** --- 3 ---
// WARNING: correlation amongst categorical variables?
corr TRANS_DIR SOL_DIR ASSETS_DIR
** Somewhat strong positive correlation b/w the transition variables


** --- Section C ---

** --- 1 ---

