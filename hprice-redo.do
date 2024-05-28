**Question 1**
generate large=1 if sqrft>2500
replace large=0 if sqrft<2500
label define large 0 "Small Sized House" 1 "Large Houses"
label value large large
label variable large "House Size"

tab large
/*18.18% of the houses are large*/

**Question2**
tab large if bdrms==3
**2 houses with 3 bedrooms are large 

mean price if large==1
**445.75 is the average price of large households

**Question 3**
**price=B0+B1large+B2bdrms+u
regress price i.large bdrms 

**Estimated increase in the price for a house with more than one bedroom?
**Answer-That would be equal to the coefficient of bdrms that is 26.33176

**Average difference between the prices for larger and smaller houses with same number of bedrooms?
**Answer-That would be equal to the coefficient of large that is 158.0515

**Question 4**
predict resid1,r
histogram resid1, normal normopts(lcolor(red) lwidth(thick)) ///
kdensity kdenopts(lcolor(black) lwidth(medium))

**Question 5**
test (bdrms 1.large)
** P=0.00 hence H0 is rejected.

**Question 6**
regress lprice sqrft
*Here B1 shows the change in log(prices) due to change in house size
scatter lprice sqrft
twoway (scatter lprice sqrft) (lfit lprice sqrft)
**Positive correlation

**Question 7**
predict resid2,r
histogram resid2, normal normopts(lcolor(red) lwidth(thick))///
kdensity kdenopts(lcolor(black) lwidth(medium))

rvfplot,yline(0) // No pattern could be seen
estat hettest // Null hypothesis of constant variance accpeted at 1% los
