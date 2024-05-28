**Question 1**
mean wage if female==1 & bigcity==1
mean wage if female==1 & smllcity==1

gen var1=0 if bigcity==1 & female==1
replace var1=1 if smllcity==1 & female==1
label variable var1 "=1,small city female"

ttest wage,by(var1)
**H0 is rejected at 1% LOS. The difference is significant as H0 is rejected at 1% LOS

**Question 2**
*a
gen belavg=1 if looks<=2
replace belavg=0 if looks>2
label variable belavg "=1 if looks<=2"

*b
gen abvavg=1 if looks>=4
replace abvavg=0 if looks<4
label variable abvavg "=1 if looks>=4"

*c
/* No there won't be any problem of dummy variable because we have three categories
looks<=2,2-3,looks>=4 and two dummy variables*/

*d
tab abvavg if black==1 & female==1
tab abvavg if black==0 & female==1

histogram abvavg if black==1 & female==1, discrete percent barwidth(0.8) ///
addlabel title(Proportion of black females in the above average looks category) ///
xlabel(0 "Not Above Average" 1 "Above average")

histogram abvavg if black==0 & female==1, discrete percent barwidth(0.8) ///
addlabel title(Proportion of white females in the above average looks category) ///
xlabel(0 "Not Above Average" 1 "Above average")

/*Proportion of black female=26%*/
/*Proportion of white female=33.94%*/
/*Proportion of white female is more than the proportion of black female*/

**Question 3**
twoway (scatter lwage exper) (lfit lwage exper)
/*Let outlier be lwage>4*/
twoway (scatter lwage exper) (lfit lwage exper) if lwage<=4
/*Outlier is not influential, not much difference in fitted line*/

**Question 4**
regress wage exper ib3.looks i.goodhlth i.black i.female i.married

*a
test exper // H0 is rejected

test 1.looks // H0 is accepted at 1% LOS
test 2.looks // H0 is accepted at 1% LOS
test 4.looks // H0 is accepted at 1% LOS
test 5.looks // H0 is accepted at 1% LOS

*b
test exper 1.looks 2.looks 4.looks 5.looks 1.goodhlth 1.black 1.female 1.married
**The model is statistically significant**

*c
regress wage exper ib3.looks i.goodhlth i.black i.female i.married educ
/*R^2 and Adj R^2 increses*/
/*t value of educ is greater>1 so addition increases Adj R^2*/

**Question 5**
regress wage exper ib3.looks i.goodhlth i.black i.female i.married educ

*a
rvfplot,yline(0) // There is no clear trend
*b
estat hettest // There is heteroscedasticity

**Question6**
predict resid1, r
histogram resid1, normal normopts(lcolor(red) lwidth(thick))

**Question 7**
regress wage exper educ south married female looks service

*a
**B2 increase in wages due to 1 year increase in education
**B1 increase in wages dur to 1 year increase in experience

*b
predict resid2,r
histogram resid2, normal normopts(lcolor(red) lwidth(thick))

*c
margins, at(exper=15 educ=15 south=0 married=1 female=1 looks=4 service=0)
**The predicted wages are 6.36774


**Question 8**
regress wage exper educ south married female looks service

rvfplot,yline(0)
estat hettest

**There is heteroscedasticity in the data
