**Question 1**
mean wage if asian==1 & female==1
mean wage if black==1 & female==1
/*The average wage earned by a black woman is 18.21848 and the average wage earned
by an asian woman is 21.38277, hence the asian woman on a average earn 3.16429*/

**Question 2**
mean educ if asian==1 & female==1
mean educ if black==1 & female==1

generate var1=0 if asian==1 & female==1
replace var1=1 if black==1 & female==1
label define var1 0 "Asian Female" 1 "Black Female"
label value var1 var1

ttest educ, by(var1)
**No, as per the test black females are not more educated than the asian ones

**Question 3**
generate more_work=1 if hrswk>60
replace more_work=0 if hrswk<=60
label variable more_work "=1, if working more than 60 hrs per week"

tab more_work if asian==1
tab more_work if black==1
bysort var1 : tab more_work //EXTRA

histogram more_work if asian==1, discrete percent barwidth(0.8) addlabel ///
xlabel(0 "Work Less" 1 "Work More") title(Asian People working hours)

histogram more_work if black==1, discrete percent barwidth(0.8) addlabel /// 
xlabel(0 "Work Less" 1 "Work More") title(Black People working hours)

histogram more_work if black==1, discrete percent barwidth(0.8) addlabel //
xlabel(0 "Work Less" 1 "Work More") title(Black People working hours)

/*Among the black people only 0.89% of the people work hard, bu among the 
asian peole 4.65% of the people work hard*/

**Question 4**
recode educ (0/6=1) (8/11=2) (12/13=3) (else=4), gen(reduc)
label define reduc 1 "Primary" 2 "Secondary" 3 "Higher-Secondary" 4 "Graduate and above"
label value reduc reduc

**HOWEVER NOW WE NEED TO CREATE DUMMY VARIABLES LIKE FOR EACH OF THEM 
/* 5 CATEGORIES
1. UNEDUCATED 0
2. PRIMARY 1-6
3. SECONDARY 8-11
4. HIGHER SECONDARY 12-13
5. GRADUATE AND ABOVE 14-21
*/

generate primary=1 if educ>1 | educ<=6
replace primary=0 if educ>6
label variable primary "=1,primary education"

recode educ (8/11=1) (else=0), generate(secondary)
label variable secondary "=1,secondary education"

recode educ (12/13=1) (else=0), generate(higher_secondary)
label variable higher_secondary "=1,higher secondary education"

recode educ (14/21=1) (else=0), generate(graduate)
label variable graduate "=1,graduate and above education"

**Question 5**
graph matrix wage educ exper hrswk, diagonal(, color(white)) ///
mcolor(cranberry) msymbol(circle)

**No proper relationship

**Question 6**
gen lwage=log(wage)
gen lexper=log(exper)

twoway (scatter lwage lexper) (lfit lwage lexper)
twoway (scatter lwage lexper) (lfit lwage lexper) if lwage>1 //extra
correl lwage lexper // positive correlation of 0.132
 
**Question 7**
reg wage educ exper

**a**
test educ // reject H0
test exper // reject H0

**b**
test educ=exper=0 // Reject H0-JOINTLY SISGNIFICANT

**Question 8**
reg wage exper metro ib3.reduc // Adj R^2 and t statistic rule doesn't work for factor variables

**Question 9**
rvfplot,yline(0) // There is some kind of trend
estat hettest // H0 of constant variance is rejected

**Question 10**
reg wage exper metro ib3.reduc, robust

**Question 11**
by female,sort: summ wage
/*INTERPRETATION- Mean Wages for married male workers are the highest.
Maximum wages are received by the female unmarried workers*/

set more off // extra-need to put set more off before running the other code
by female married, sort: summ wage

/*INTERPRETATION- Mean Wages for married male workers are the highest.
Maximum wages are received by the female unmarried workers*/

**Question 12**
* - USED TO COMMENT IN A SINGLE LINE

// - STATA DOESN'T RUN ANHYTHING WRITTEN AFTER //. USED TO COMMENT OUT OF A CODE
tab educ if female==1 // & asian==1-> Here the // could be removed later just to run the code later

/// - TO CHANGE LINES IN THE CODE
tab educ  ///
if female==1 & asian==1

/*...*/ 
*Multiple line commenting
