# Cody Rorick
library(statmod)

#setwd('/Users/crorick/Documents/MS\ Applied\ Stats\ Fall\ 2023/MA5771/Final\ Project')

demographics <- read.csv('onlinefoods.csv')
demographics$Occupation <- factor(demographics$Occupation)
demographics$Monthly.Income <- factor(demographics$Monthly.Income)
demographics$Educational.Qualifications <- factor(demographics$Educational.Qualifications)

# Making the family size a binomial variable
demographics$Family.size.binom <- factor(cut(demographics$Family.size, breaks = c(0, 2, 6), labels = c("smallFamily", "largeFamily")))

# Checking the number of samples in each family size
plot(demographics$Family.size.binom, xlab = 'Family Size', ylab = 'Number Of Samples', main = 'Count Of Samples In Family Sizes')

# Response vs. explanatory variables boxplot
boxplot(Family.size ~ Educational.Qualifications, xlab = 'Educational Qualifications', ylab = 'Family Size', main = 'Educational Qualifications vs Family Size', data = demographics)
boxplot(Family.size ~ Monthly.Income, xlab = 'Monthly Income Range', ylab = 'Family Size', main = 'Income Range vs Family Size', data = demographics)
boxplot(Family.size ~ Occupation, xlab = 'Occupation Type', ylab = 'Family Size', main = 'Occupation Type vs Family Size',data = demographics)

# Response vs explanatory variables prop tables
xtabs( ~ Family.size.binom + Educational.Qualifications, data = demographics)
xtabs( ~ Family.size.binom + Monthly.Income, data = demographics)
xtabs( ~ Family.size.binom + Occupation, data = demographics)

# Fitting the model
demographics.glm <- glm(Family.size.binom ~ Educational.Qualifications * Monthly.Income * Occupation - Educational.Qualifications:Monthly.Income:Occupation, family = binomial(link = 'logit'), data = demographics)
demographics.glm.1 <- glm(Family.size.binom ~ Educational.Qualifications * Monthly.Income * Occupation - Educational.Qualifications:Monthly.Income:Occupation - Educational.Qualifications:Occupation, family = binomial(link = 'logit'), data = demographics)
demographics.glm.2 <- glm(Family.size.binom ~ Educational.Qualifications + Occupation + Educational.Qualifications:Occupation, family = binomial(link = 'logit'), data = demographics)

# Finding the AIC for all of the fitted models
AIC(demographics.glm)
AIC(demographics.glm.1)
AIC(demographics.glm.2)

# QQplot shows slightly heavy tails, but not noteworthy enough to question normality.  
qqnorm(qresid(demographics.glm.2))
qqline(qresid(demographics.glm.2))

# Checking if the dispersion parameter is approximately 1, close enough to theoretical dispersion
pearson.stat <- sum(resid(demographics.glm.2, type = "pearson")^2)
cat(dispersion <- pearson.stat/demographics.glm$df.residual)

# Goodness of fit test cannot be used because binary data does not meet the 
# minimum response requirement. M=1 for all responses. 

# Plotting the quantile residuals vs the constant information fitted values
scatter.smooth(qresid(demographics.glm.2) ~ asin(sqrt(demographics.glm.2$fitted.values)), xlab = 'Constant information (asin(mean^1/2))', ylab = 'Quantile Residuals', main = 'Quantile Residuals vs Fitted Values')

# Checking for influential points
plot(demographics.glm.2, which = 4)

# Find working residuals
lp <- predict(demographics.glm.2, type = "link") # linear predictor
rW <- resid(demographics.glm.2, type = "working") # working residuals
z <- rW + lp # working response
# Plot of working response against linear predictor
scatter.smooth(z ~ lp, las = 1, ylab = "Working Responses", xlab = "Linear Predictors", main = "Working Responses vs Linear Predictors")

# Type 1 AOV
anova(demographics.glm.2)

#Education p value
cat(pchisq(10.8387, df = 4, lower.tail = F))
#Occupation p value
cat(pchisq(3.8379, df = 3, lower.tail = F))
#Education:Occupation interaction p value
cat(pchisq(21.237, df = 6, lower.tail = F))

#interpret coefficients
summary(demographics.glm.2)
