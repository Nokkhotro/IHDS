drop STATEID2
*to generate the new state name column
gen state=1 if STATEID==28
replace state=2 if STATEID==33
replace state=3 if STATEID==32
replace state=4 if STATEID==29
replace state=5 if STATEID==31
replace state=6 if STATEID==35
replace state=7 if STATEID==34
label define state 1 "Andhra Pradesh" 2 "Tamil Nadu" 3 "Kerala" 4 "Karnataka" 5 "Lakshawadeep" 6 "A&N Islands" 7 "Pondicherry"
label value state state
**
rename state RSTATEID
label variable RSTATEID "State Name"
order RSTATEID,before(DISTID)

**To generate new variable socio religious identity
**socrel criteria
**1= Hindu FC(others)-HFC
**2= Hindu OBC-HOBC
**3= Hindu SC-HSC
**4= Hindu ST-HST
**5= Muslim
**6= Other religion Sikh, Buddhist, Christian etc

rename XGROUPS6 socrel
label define socrel 2 "HFC" 3 "HOBC" 4 "HSC" 5 "HST" 6 "Muslims" 7 "Others"
label value socrel socrel
label variable socrel "Socio-Religious Identity"

****A
****1****
tab socrel if RSTATEID != .
graph bar (count), over(socrel)


****2****
tab socrel XPOOR1
**To plot the pie charts group wise of poor people
graph pie if XPOOR1==0, over(socrel) plabel(_all percent) plabel(1 percent) title (NON POOR SOCREL)
graph pie if XPOOR1==1, over(socrel) plabel(_all percent) plabel(1 percent) title (POOR SOCREL)

****3****
tab socrel URBAN
bysort URBAN:tab socrel if XPOOR1==1
graph pie if XPOOR1==1, over(socrel) by(URBAN)

****4****
tab socrel POOR2
**To plot the pie charts group wise of poor people
graph pie if POOR2==0, over(socrel) plabel(_all percent) plabel(1 percent)
graph pie if POOR2==1, over(socrel) plabel(_all percent) plabel(1 percent)

bysort URBAN:tab socrel if POOR2==1 
graph pie if POOR2==1, over(socrel) by(URBAN)

****5****
**Generate a new variable transition to represent transitions
*1=Poor to Non Poor - P2NP
*2=Poor to Poor - P2P
*3=Non Poor to Poor - NP2P
*4=Non Poor to Non Poor - NP2NP

order XPOOR1,before(POOR2)
gen trans=1 if XPOOR1==1 & POOR2==0
replace trans=2 if XPOOR1==1 & POOR2==1
replace trans=3 if XPOOR1==0 & POOR2==1
replace trans=4 if XPOOR1==0 & POOR2==0
label define trans 1 "P2NP - Transition" 2 "P2P -Poverty Persistence" 3 "NP2P - Transition" 4 "NP2NP - Persistence"
label value trans trans
label variable trans "Transitions and Persistence of Poverty"
order trans,after(POOR2)

**Condition of the transition and persistence
gen trans_cond=0 if trans==2 | trans==3
replace trans_cond=1 if trans==1 | trans==4
label define trans_cond 0 "Bad" 1 "Good"
label value trans_cond trans_cond
label variable trans_cond "Implications of the Transitions and Persistence"
order trans_cond,after(trans)

**Matrix analysis
tab trans socrel, row col
bysort trans_cond: tab trans socrel, row col

**Pie Chart Analysis- FOR EACH SOCREL GROUP WHAT WAS THE TREND?
graph pie if socrel==2, over(trans) plabel(_all percent) plabel(1 percent)
graph pie if socrel==3, over(trans) plabel(_all percent) plabel(1 percent)
graph pie if socrel==4, over(trans) plabel(_all percent) plabel(1 percent)
graph pie if socrel==5, over(trans) plabel(_all percent) plabel(1 percent)
graph pie if socrel==6, over(trans) plabel(_all percent) plabel(1 percent)
graph pie if socrel==7, over(trans) plabel(_all percent) plabel(1 percent)

graph pie if trans==1, over(socrel) plabel(_all percent) plabel(1 percent)
graph pie if trans==2, over(socrel) plabel(_all percent) plabel(1 percent)
graph pie if trans==3, over(socrel) plabel(_all percent) plabel(1 percent)
graph pie if trans==4 & RSTATEID != ., over(socrel) plabel(_all percent) plabel(1 percent)



