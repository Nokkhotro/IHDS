describe
set more on

*** Viewing Data -Listing
***to see the education and principal status of the first 5 individuals 
li edu pstat in 1/5
***to see the data from 5th to 15th observations (next 10 observations from 5) 
li edu pstat rel in 5/15
***list education and religion for last three observations 
list edu rel in -3/L
***list sex,age and marital status if age greater than 20 and less than 25 with clean output
list sex age mstat if age>20 & age<25,clean
list sex age mstat state if (age>=20 & age<22) & (state==19|state==32), clean
***Browse specifics
browse mstat pstat if sex==2 & (age>30 & age<35)

**list will work with all types of variables
 
**tab- WORKS ONLY WITH CATEGORICAL VARIABLE
tab sex, nol // NO LABEL
tab pstat
tab sex if (age>35) & (state==19)
***two way tables
tab sex mstat, row
tab sex mstat, col
tab sex mstat, row col
tab sex mstat if (age>35) & (hhsize<=4), row col
tab sex mstat if (age>35) & (hhsize<=4) & (state==19|state==32), row col
tab1 sex mstat rel caste // MULTIPLE TABULATIONS TOGETHER
tab sector sex, chi2 // H0 of independence is rejected p=0.00
 
rename caste socgrp
***bysort command for sorting
bysort socgrp: tab mstat
bysort socgrp: tab sector

***summarize for continuous variables
summ age edu
summ age edu, detail //TO GET A DETAILED ANALYSIS

***generating variables
**example 1: using mathematical formula and existing variables we create a new variable 
**labelling a variable
gen mhe= (mcd/12)+ mcc+ mcb+ mca
gen mpce= mhe/hhsize
gen lmpce= log(mpce)
label variable mhe "Monthly Household Expenditure"
label variable mpce "Monthly per capita expenditure"
label variable lmpce "Log of MPCE"

**example 2: recode
**labelling categories of a variable
tab rel
recode rel(1=1) (2=2) (3/7=3) (else=4),gen(rrel)
label define rrel 1 "Hindu" 2 "Muslims" 3 "Minorities" 4 "Others"
label value rrel rrel
tab rrel 
order rrel, after(rel)

tab mstat
gen rmstat=1 if mstat==1
replace rmstat=2 if mstat>=2 & mstat<=4
label define rmstat 1 "Unmarried" 2 "Married"
label value rmstat rmstat
tab rmstat

/*or
tab mstat
recode mstat (1=1) (2/4=2), gen(rmstat)
label define rmstat 1"unmarried" 2"married"
label value rmstat rmstat
tab rmstat
*/

tab cfuel
generate rcfuel=0 if (cfuel==3 | cfuel==4 | cfuel==7 | cfuel==8 | cfuel==12 |cfuel==19)
replace rcfuel=1 if (cfuel==1 | cfuel==2 | cfuel==5 | cfuel==6| cfuel==9|cfuel==10)
label define rcfuel 0 "Clean" 1 "Not Clean"
label value rcfuel rcfuel
order rcfuel,after(cfuel)

tab1 rel socgrp, nol
/* Create a variable called src as follows and add labels:
HFC=1, HST=2, HSC=3, HOBC=4, MUSLIMS=5, OTHERS=6 */
tab rrel
generate src=1 if socgrp==9 & rrel==1
replace src=2 if socgrp==1 & rrel==1
replace src=3 if socgrp==2 & rrel==1
replace src=4 if socgrp==3 & rrel==1
replace src=5 if rrel==2
replace src=6 if rrel>=3
brow
***reconstruct src considering only two categories for Hindu- HFC and HBC
/* IN THE 2ND CATEGORY WE WILL COMBINE HST, HSC AND HOBC */
recode src (1=1) (2/4=2) (5=3) (6=4), gen(rsrc)
**label the categories of rsrc
label define rsrc 1"H_FC" 2"H_BC" 3"MUSLIMS" 4"OTHERS"
label value rsrc rsrc
label define rsrc 1"HFC" 2"HBC" 3"MUSLIMS" 4"OTHERS", modify
brow

***example 4: create a dummy variable from a continuous variable 
recode age (18/25=1) (26/40=2) (41/55=3) (.=.) (else=4), gen(rage)
label define rage 1"very young" 2"young" 3"middle aged" 4"aged"
label value rage rage
tab rage
**alternative
gen dage=1
replace dage=2 if age>=25 & age<40
replace dage=3 if age>=40 & age<55
replace dage=4 if age>=55
replace dage=. if age==. 
tab dage
label variable dage "age dummy"
label define dage 1"very young" 2"young" 3"middle aged" 4"aged"
label value dage dage

***example 5
/*using egen command we can create a new variable using non missing values of those variables
Here row mean values of the considered variables will generate the values for the newly craeted variables. */
egen meanwork= rowmean(owork uwork swork lwork)
rename meanwork totupact
label variable totupact "total unpaid activities"
**standardise totupact
egen ztotupact= std(totupact) //Standardize the total unpaid activities

***assignment
drop redu
drop rredu
tab edu
label drop edu
label drop redu
tab edu
gen redu=1 if edu==1
replace redu=2 if edu==2|edu==3|edu==4
replace redu=3 if edu==5
replace redu=4 if edu>5
label define redu 1"illiterate" 2"below secondary" 3"secondary" 4"HS and Above"
label value redu redu
brow

tab redu bcfuel, row col
tab sector bcfuel, row col
tab rsrc bcfuel, row col
corr (bcfuel redu rsrc sector)

*Statistical Tests
**t Test
summ age mpce
ttest age==25
ttest age,by(sex)
bysort sector:ttest age,by(sex)
ttest mpce if state==19|state==32, by(sector)

**Proportion Test
prtest(rcfuel),by(sector)
prtest(rcfuel) if sex==1, by(sector)
bysort sector:prtest rcfuel,by(rmstat)

**Calculation of Average Using Summ and Mean
mean mpce if sector==0&state==19
summ mpce if sector==0&state==19,detail
mean mpce if mpce>=1000 & sector==1 & (state==19|state==32)

**Graph Matrix
graph matrix age mpce totupact edu, half jitter(2) 
graph matrix age totupact mpce edu, diagonal(, color(white)) mcolor(blue) msymbol(circle)

**REGRESSION ANALYSIS
regress mpce hhsize age
test age=hhsize=0

regress lmpce age hhsize i.sector ib(2).rsrc i.mstat i.sex, robust
predict resid,r

histogram resid, fcolor(yellow) normal normopts(lcolor(red) lwidth(thick)) ///
kdensity kdenopts(lcolor(black) lwidth(medthick))

***REGRESSION DIAGNOSTICS
**CHECKING FOR HETEROSCEDASTICITY
*GRAPHICAL METHOD
*ALL REGRESSION DIAGNOSTICS WILL BE POST REGRESSION ANALYSIS COMMANDS
rvfplot, yline(0)
** THERE IS TREND BETWEEN FITTED VALUES AND RESIDUALS 
**HETEROSCEDASTICITY 
regress lmpce age hhsize i.sector ib(2).rsrc i.mstat i.sex
estat hettest
**P VALUE IS 0.00 SO H0:CONSTANT VARIANCE IS REJECTED 
**Check for ommited variable 
ovtest
**This model has omitted variables

/* "Robust" standard errors is a techinque to obtain unbiased standard errors 
of OLS coefficients under heteroscedasticity */
regress lmpce age hhsize i.sector ib2.rsrc i.mstat i.sex, robust
