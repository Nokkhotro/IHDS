**Question 1**
gen large=1 if sqrft>2500
replace large=0 if sqrft<=2500
label variable large "=1,if sqrft>2500"

tab large //18.18% of the houses are large 

**Question 2**
tab large if bdrms==3 // 2 large houses have 3 bed rooms
mean price if large==1 // Avg Prices of large houses are $445,7516

**Question 3**
reg price i.large bdrms 

/* Estimated increase in the price of the house with one more bedroom is 26.33176*/
/* Average price difference for larger and smaller houses with the same number 
of bedrooms is 158.0515*/

**Question 4**
predict resid1, r

histogram resid1, normal normopts(lcolor(forest_green) lwidth(thick))
/*This follows a bell shaped curve hence a normal distribution*/

**Question 5**
test 1.large=bdrms=0

/*Reject null hypothesis at 1% LOS, The model is significant*/

**Question 6**
reg lprice sqrft
*Here B1 shows the change in log(prices) due to change in house size
twoway (scatter lprice sqrft) (lfit lprice sqrft)

**Question 7**
reg lprice sqrft

predict resid2,r
histogram resid2, normal normopts(lcolor(forest_green) lwidth(thick))
/*This follows a bell shaped curve hence a normal distribution*/

rvfplot,yline(0) // There is no trend
estat hettest // Accept H0 of constant variance
