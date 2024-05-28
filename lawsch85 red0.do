**Question 1**
mean salary if north==1
mean salary if south==1
mean salary if east==1
mean salary if west==1

**Collges in the east fetch a higher starting salary on an average

generate var1=0 if north==1
replace var1=1 if south==1
label define var1 0 "North" 1 "South"
label value var1 var1

ttest salary, by(var1)
**H0, that there is no difference is rejected at 1%los

**Question 2**
**a**
generate faculty_size=1 if faculty>=150
replace faculty_size=0 if faculty<150
label variable faculty_size "=1, higher faculty size"

**b**
twoway (scatter faculty clsize) (lfit faculty clsize)
twoway (scatter faculty clsize) (lfit faculty clsize) if faculty<150 /// Extra

correl faculty clsize

**Has a positive correlation of 0.7526

**c**
generate cost1=1 if cost>18000
replace cost1=0 if cost<=18000
label variable cost1 "=1,higher cost"

**d**
tab cost1 faculty_size, row

histogram faculty_size if cost1==1, discrete percent barwidth(0.8) addlabel ///
title(High Cost colleges and faculty size) xlabel (0 "Small Faculty" 1 "Large Faculty")

histogram faculty_size if cost1==0, discrete percent barwidth(0.8) addlabel ///
title(Low Cost colleges and faculty size) xlabel (0 "Small Faculty" 1 "Large Faculty")

/*Low Cost colleges tend to have more colleges because their number is also less*/

**Question 3**
graph matrix salary cost GPA  age, diagonal(, color(white)) mcolor(cranberry) msymbol(circle)

/*Almost all of them are positively correlated with each other*/

**Question 4**
gen lsalary=log(salary)
gen lcost=log(cost)

twoway (scatter lsalary lcost) (lfit lsalary lcost)
/*Let the presence of outlier being given by lsalary>11.1*/
twoway (scatter lsalary lcost) (lfit lsalary lcost) if lsalary<=11.1 /// After removing outlier-NOT INFLUENTIAL

**Question 5**
regress salary rank cost GPA i.faculty_size

**a**
test GPA
**Reject H0 Coef=0

test cost
**Reject H0 Coef=0

**b**
test rank=cost=GPA=1.faculty_size=0
*H0 is rejected, hence jointly significant

**c**
regress salary rank GPA i.faculty_size##c.cost
/*t statistic of i.faculty_size##c.cost <1 hence addition of that variable reduced Adj R^2*/

**Question 6**
regress salary rank GPA i.faculty_size##c.cost

rvfplot,yline(0) // There is a trend visible in the data
estat hettest // p<0.01 reject H0 of constant variance 

**Question 7**
regress salary rank GPA i.faculty_size##c.cost, robust
/* USED TO GIVE UNBIASED STANDARD ERRORS*/

**Question 8**
regress salary rank cost GPA i.faculty_size

predict resid1, r
histogram resid1, normal normopts(lcolor(magenta) lwidth(thick))
**Shows normality**

**Question 9**
regress lsalary lcost
*B1 is the change in lsalary due to per unit change in lcost - 0.3151103
twoway (scatter lsalary lcost) (lfit lsalary lcost)

**Question 10**
rvfplot,yline(0) // There is trend in the data
estat hettest // Reject H0 of constant variance there is heteroscedastcity

