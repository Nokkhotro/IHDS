tab sex
describe
***
set more off
describe
set more on
describe
***viewing data
**list education and p stat is the status of occupation for first five observations
li edu pstat in 1/5
** list for education religion and pstat for fiveth to fifteenth observations
li edu rel pstat in 5/15
** list education for last 7 observation
li edu in -7/L
***list sex, age and marital status if age>=20 and <23 with clean output
li sex age state mstat if (age>=20 & age<23) & (state == 19 | state == 32) , clean
** browse marital staus and pstat for females (sex = 2) who have age>35 and <45 
brow mstat pstat if (sex==2) & (age>35& age<45)


***DATE-2/4/24(TUESDAY)

***tabulation
/*tab works with categorical varable only and it is never ending for
 the continuous variable*/ 
tab sex
tab pstat

***for removing levels
tab sex, nol

*** if conditions
tab sex if age>35

tab sex if age>35 &  state==19

*** TWO WAY TABLES 

tab sex mstat 

***if we want the row percentage
tab sex mstat , row 
** for the column percentage
tab sex mstat , col
**for both
tab sex mstat , row col


**if conditions
tab sex mstat if age>35 & hhsize <=4 ,row

tab sex mstat if age>35 & hhsize <=4 & (state==19|state==32)  ,row

*** IF WE WANT MULTIPLE TABLES AT ONCES THEN USE tab1
tab1 sex mstat rel caste

***two categorical variables are independent in influencing the test statistic
*null hypothesis is that no balance (baised)between the two variables
** we will reject as probability pr is 0
tab sector sex ,chi2

***breaking into multiple groups using bysort command
bysort caste: tab mstat
bysort caste: tab sector
bysort sector: tab caste

***summarize continuous variables
summarize age edu hhsize

* if we want in detail
summarize age edu hhsize, detail

* for categorical variable use bysort
bysort sector: summ edu hhsize, detail


***GENERATING VARIBLE
**EXAMPLE 1
*using mathematical formulas using existing variables to create new variables
drop mhe
gen mhe = (mcd/12)+mcc+mcb+mca
gen mpce=mhe/hhsize
gen impce = log(mpce)
label variable mhe " Monthly per capita expenditure"
label variable impce " Log of Monthly per capita expenditure"
***IF WE WANT TO REWRITE THE CODE THEN WE HAVE TO DROP ALL THE VARIABLES


***EXAMPLE 2 recode
drop rrel
tab rrel
* to get the codes of each religion
tab rel, nol
*3/7 means from 3to 7
recode rel (1=1)(2=2)(3/7=3)(else = 4),gen(rrel)
* labelling categories of the varible
label define rrel 1 "hindu" 2 "Muslim" 3 "Minorities" 4 "Others"
label value rrel rrel

tab mstat 
recode mstat (1=1) (2/4=2), gen(rmstat)
label define rmstat 1 "Unmarried" 2 "Married"
label value rmstat rmstat
tab rmstat

tab cfuel, nol
** the space between 2 11 represents AND 
recode cfuel (2 11=1) (else=0), gen(bcfuel)
/** the space between 2 and 11 is for or. 
if the fuel is either lpg (2) or electricity(11) then it is clean*/
label define bcfuel 0 "Not Clean" 1 "Clean"
label value bcfuel bcfuel
tab bcfuel

**renaming and labelling 
tab1 rel caste, nol
rename caste socgrp
tab srcgrp
label variable socgrp "Social Group"
tab1 rel socgrp, nol
**9 is the number to represent "others", if two digit variables then others is 99
label define socgrp 1 "ST" 2 "SC" 3 "OBC" 9 "Others"
label value socgrp socgrp
tab1 rel socgrp
 
**EXAMPLE 3
**using two variables to create a new single variable
/*Create a variable called src(SOCIAL RELIGIOUS COMMUNITY) as
 follows and labels:
 HFC=1, HST=2 ,HSC=3, HOBC=4, Muslims=5,Others=6*/
 tab socgrp rrel
gen src =1 if socgrp==9 & rrel==1
replace src=2 if socgrp==1 & rrel==1
replace src=3 if socgrp==2 & rrel==1
replace src=4 if socgrp==3 & rrel==1
replace src=5 if rrel==2
replace src=6 if rrel>=3

*date-4/4/24
/*reconstruct src considering only 2 categories for "Hindu":
as HFC and HBC containing hst hsc hobc*/
recode src (1=1) (2/4=2) (5=3) (6=4), gen(rsrc)
**label the categories of rsrc 
label define rsrc 1 "HUC" 2 "HBC" 3 "Muslims" 4 "others"
tab rsrc
label define rsrc 1 "HUC" 2 "HBC" 3 "Muslims" 4 "others", modify
tab rsrc

**EXAMPLE 4
/*create a dummy variable from a continuous variable*/
summarize age
gen dage=1
replace dage =2 if age >=25 & age <=40
replace dage =3 if age >=40 & age <=55
replace dage =4 if age >=55 
replace dage =. if age ==.
tab dage
label variable dage "Age Dummy"
label define dape 1 "very young" 2 "young" 3 "miiddle age" 4 "aged"
label value dage dage

*ALTERBNATIVE
recode age (18/25=1) (26/40=2) (41/55=3) (.=.) (else=4), gen(rage)
label define rage 1 "very young" 2 "young" 3 "miiddle age" 4 "aged"
label value rage rage

**EXAMPLE 5
/*using egen command we can create a new variable using non
missing values of the variable
here row mean values of the considered  variables will generate the values
for the newly created variables*/
egen meanwork = rowmean(owork uwork swork lwork)
rename meanwork totupact
label variable totupact "total unpaid work"
**standardized totupact
egen ztotupact = std(totupact)

***ASSIGNMENT
/* create redu having 4 categories- illiterate, below secondary, secondary, HS & above
1. prepare 2-way table between redu & choice of fuel, place of residents & choice of fuel
and rsrc & fuel.
2. is there any association between redu & choice of fuel,
place of residents and rsrc */
drop redu
tab redu
recode edu (1=1) (2/4=2) (5=3) (6=4) (7/12=5), gen(redu)
label define redu 1 "illiterate" 2 "below secondary" 3 "secondary" 4 "HS" 5 "above" , modify
label value redu redu
tab redu cfuel
tab redu sector
tab redu rsrc
tab edu

tab redu cfuel, chi2
cor redu cfuel
tab redu sector, chi2
tab redu sscr, chi2

***STATISTIC VARIABLE 
mean age
*asking the differnece in age between male and female
/* ttest measuring if there is any statistically significant difference in a
continuous varibale across different groups*/
ttest age==45

ttest age==25
ttest age, by(sex)
bysort sector: ttest age, by(sex)

/*NOTE:- if the pr of any statistic is 1 then that alternative hypothesis 
is irrelevant*/

/*ttest is applicable for the continuous variables, and we use
pr test categorical variables*/
/*by sort rsc across sector for hhsize*/
mean hhsize
ttest hhsize, by(sector)
bysort rsrc: ttest hhsize, by(sector)

**pr test
prtest bcfuel, by(sector)
/*CONCLUSION: reject h0 since pvalue of diff>0 is <0.01
48% of rural use clean fuel while 87% of urban use clean fuel.
and their diff is 38% 
thus the diff is positive so diff<0 is irrelevant.*/

prtest bcfuel, by(rmstat)
/*CONCLUSION: reject h0 since pvalue of diff>0 is <0.01*/

bysort sector: prtest bcfuel, by(rmstat)
/*CONCLUSION: in urban reject h0 at 1% level of signficance.*/

**date-5/4/24


**CALCULATION OF AVERAGE
mean mpce
      *sector ==0 means rural and 1 means urban
mean mpce if sector==0 & state==19 
mean mpce if sector==1 & state==19
mean mpce if mpce>=1000 & sector==0 & state==32
mean mpce if mpce>=1000 & sector==0 & (state==32 | state==19)


/*if we use summarize we get mean for a continuous variable*/
/*if we write ttest==25, means our h0 is age = 25 */

summarize age
/* if p value is less than 0.01 the coeffient is significant at 1% level.
or 0 paramenter type hypo we will wr ejerct h0 at 1% level of significance
if p value is more than 0.01 but less than 0.05 the coefficient is sign at 5% level.
0 parameter type h0 will be rejected at 5% level.
if p value is greater than 0.1 then accept h0*/


mean mpce
ttest mpce==2383
/* here the p value is greater than 0.1 for all altenatives thus we will accept the h0*/

ttest mpce, by(sector)
/* testing if the diff in mpce between sectors are significant or not*/
/*CONCLUSION: diff<0 is irrelevant, and pvalue of diff>0 is <0.01 thus reject h0*/

ttest mpce if state==19, by(sector)
/* we want to test for the above test for the west bengal state only*/
/*CONCLUSION: reject h0 at 1% level of significance as p value for difference>0 is <0.01*/


***CORRELATION (use corr)***

corr age mpce totupact

/* the relation between age and mpce is positive and same for age and totupact
relation between mpce and totupact(total unpaid activities) is negative */

graph matrix age mpce totupact, half jitter(2)
/*grpah will ploted only on one side by using half jitter*/

graph matrix age mpce totupact

***REGRESSION ANALYSIS (use regress)

regress impce hhsize
/* model ss means ESS*/
/*diff between rss and ess is because their are some other
component that should have being included but had not so it goes into the error causing rss to rise*/
/* hhsize can explains impce 1% level of significance.
there exists an inverse relationship between hhsize and impce 
corr impce hhsize.
as hhsize increases by 1 person the impce decreases with beta.
if both hhsize and impce is log transformation the beta is the elasticity.
since p value for both alpha and beta is <0.01 the reject h0.
the coefficient is within the conf interval.
lesser the sd lower will be the diff between the lower and upper interval*/

***DATE- 10/04/24
**ESTIMATION OF THE REGRESSION COEFFICIENT:-

reg impce hhsize

** impce = 8.094017 - 0.1168513* hhsize 
** the above is the regression equation 

**DUMMY VARIBALES

reg impce hhsize
reg impce hhsize i.sector
*NOTE: for categorical variables we have to put i. infront of them

**since the p value is less than 0.1 thus 

** impce = 8.4009 - .04779343 rural - 0.112 * hhsize 

/*since only rural is shown in sector, we have to understand that the cal is
 made with urban as a refrence*/

/* -ve beta for rural means reduction compared to the reference*/

/*compared to urban if a person belongs to rural, the monthly per capita
decreases by 48%*/

/* here thwere are two estimated equations, one for urban and other for rural
for urban: rural =0
impce hat = 8.40 - .11 hhsize

for rural: rural =1
impce hat = (8.40 - .48 ) -.11 hhsize*/
**additive dummy variable.

**DOUBT the concept: interpretation of the dummy variable

reg impce hhsize i.sector i.sex

/* the model is signficant as p value is less than 0.01*/

/*all the betas(coefficient) are sig at 1% level*/

/* compared to the male, if an individul is female, then the
monthly per capita will rise by 3.2%*/


** impce = 8.4 - .048 rural + 0.0317 sex - 0.112 * hhsize 

**EXAMPLE 3

reg impce age hhsize i.sector ib2.rsrc i.mstat i.sex
/*if we have more than 2 categories for a variable , we use ib2.
before for making the second category as the reference*/

*lowest numerical denomination is the default referrence point

/* the divored is significant at 10% and the muslims are not 
significant*/

*HBC is considered as the ref. cat. as we have used ib2.

* if age inc with 1 yr there will be almost no change in the impce
* if hhsize inc with 1 person there will be a reduction of 10.4% in the impce
/*there is no diff in the impce between hbc and the muslims as 
is not sign*/

/* if an continuous variable is insig then we have to say that 
it is not related to the impce*/

/* if an categorical variable is insig then we have to say that 
it is not diff from its ref. ctegory*/

reg impce age hhsize i.sector ib3.rsrc ib2.mstat i.sex

**WORK: DO THE INTERPRETATION FOR THIS YOURSELF

predict impcehat
/* impcehat is the name of the variable storing the estimated 
value of the explained vriable*/

predict res1, residuals
* residual values have been saved 

/*how to find the first 5 predicted vlues nad residual with observed 
impce*/

li impce impcehat res1 in 1/5



***REGRESSION DIAGNOSTICS
*chcecking for homoscedasticity
/* post reg method*/
**garphical method 

rvfplot, yline(0)
/*shape not random*/

**formal test

hettest
/*looking at the prob value, we will reject h0 at 1% level of sign*/


/*"robust" standard error is a technique to obtain unbiased
standard errors of ols coefficients under heteroscedsticity*/

reg impce age hhsize i.sector ib2.rsrc i.mstat i.sex, robust


**checking for autocorrelation

tsset TIME VARIABLE 
estat dwatson

