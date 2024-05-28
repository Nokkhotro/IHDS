**Question 1**
reg ed dist
/*Estimated slope is -0.0725*/

**Question 2**
regress ed dist bytest i.female i.black i.hispanic i.incomehi i.ownhome /// 
i.dadcoll cue80 stwmtg80
/*Estimated effect of distance on education is -0.0376*/

**Question 3**
/*Yes the effect is less if the other variables are included as in Q2*/
ovtest
/*The model has ommited variables as the H0 of the model having no ommited varia
bles is rejected*/

**Question 4**
/*SSR is lower in Model 2 than model 1*/
/*Both R^2 and Adj R^2 are higher in model 2 due to the addition of variables with
|t|>1 */
/*The reason why R^2 and Adj R^2 is so same in model 2 could be that the loss in 
df has a very less effect on the model 2*/

**Question 5**
/*It measures the effect on average number of years of education depending on 
whether the father was a graduate or not*/

**Question 6**
regress ed black hispanic female dist bytest incomehi ownhome momcoll dadcoll cue80 stwmtg80

margins, at(black=1 female=1 hispanic=2 dist=2 bytest=58.0 incomehi=2 ownhome=2 momcoll=2 ///
dadcoll=1 cue80=7.5 stwmtg80=9.75)

**Hence Bob's predicted years of schooling is 15 years aprrox
