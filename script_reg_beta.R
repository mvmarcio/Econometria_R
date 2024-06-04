### DOING THE ANALYSIS USING THE METHODOLOGY: BETA GEE ### 


# REFERENCES --------------------------------------------------------------

# Abonazel, M. R., Dawoud, I., Awwad, F. A., & Lukman, A. F. (2022). Dawoud–Kibria Estimator for Beta Regression Model: 
# Simulation and Application. Frontiers in Applied Mathematics and Statistics, 8.
# https://doi.org/10.3389/fams.2022.775068

# Hunger, M., Döring, A., & Holle, R. (2012). Longitudinal beta regression models for analyzing health-related quality of life scores over time. 
#BMC Medical Research Methodology, 12(1). 
# https://doi.org/10.1186/1471-2288-12-144


# Why am I choosing this methodology? -------------------------------------

## The dependent variable characteristics. 

## My dependent variable is a RATE (early pregnancy rate). Making the linear 
## regression model unsuitable in my case (Abonazel et al., 2022). 
## My dependent variable is not normally distributed and is slightly negatively asymmetrical. 
## My dependent variable is within a specific interval: between 0.1775 and 0.4636. 
## This methodology is under-used in social sciences and public policies analysis.
## I am running this based on the article of Hunger et al., 2012. 

## The independent variable characteristics and controls

## All not normally distributed and USUALLY asymmetrical, with outliers. 

# Transformations were now interesting in this case. They didn't adjust the model and
## were actually distorting the relationship between variables. 

## Fixed effects with robust standard errors was not suitable either. The data is too abnormal,
## with outliers - which are not interesting to remove - and I was experiencing non-linearity and
## heteroscedasticity.

## my data is a panel data going from 2010 until 2016, Beta GEE accounts for interdependence between observations
## - clustered in the municipality level - and allows my dependent variable to be a rate. 



# Loading packages --------------------------------------------------------

### using geepack
setwd("C:/Users/f0034409/Cursos_Aperfeicoamento/UFG/Mestrado/Regressao_Beta")

install.packages("geepack")
install.packages("car")

library(geepack)
library(car)
library(tidyverse)
library(readxl)

# loading the database and making adjustments ----------------------------------------------------

## I am using the HDI variable, hence, I am filtering my dataset only for six years: from 2010 to 2016. 
## this is the timeline that I have the HDI variable. 
## This variable showed a strong negative linear correlation with the outcome variable, that's why I am including it. 

municipalities <- read_excel("municipalities.xlsx", 
                             sheet = "database")

municipalities_filtered <- municipalities %>%
  filter(year >= 2010 & year <= 2016)
municipalities_filtered <- municipalities_filtered %>%
  filter(!is.na(HDI_index_FIRJAN))


# Transforming the outcome variable -----------------------------------------------

municipalities_filtered$early_pregnancy_rt_transformed <- (municipalities_filtered$early_pregnancy_rt - min(municipalities_filtered$early_pregnancy_rt)) / 
  (max(municipalities_filtered$early_pregnancy_rt) - min(municipalities_filtered$early_pregnancy_rt))


# Checking multicolinearity  ----------------------------------------------

lm_model <- lm(
  early_pregnancy_rt_transformed ~ enrollments_high_school_full + gdp_pc + failures_high_school + dropouts_high_school + approvals_high_school + HDI_index_FIRJAN,
  data = municipalities_filtered
)

alias(lm_model)

## Approvals in High School is causing trouble in the model because is correlated with both failures and dropouts. Let's remove it. 

lm_model_adjusted <- lm(
  early_pregnancy_rt_transformed ~ enrollments_high_school_full + gdp_pc + failures_high_school + dropouts_high_school + HDI_index_FIRJAN,
  data = municipalities_filtered
)

## calculating Variance Inflation Factor (VIF)

vif_values_adjusted <- vif(lm_model_adjusted)
print(vif_values_adjusted)

## All values are under 10, indicating that the variables are not correlated between each other. 

# loading the model -------------------------------------------------------

## converting municipalities as a factor

str(municipalities_filtered)

municipalities_filtered$municipality <- as.factor(municipalities_filtered$municipality)


# running the model -------------------------------------------------------

gee_beta_model_1 <- geeglm(
  early_pregnancy_rt_transformed ~ enrollments_high_school_full + gdp_pc + failures_high_school + dropouts_high_school + HDI_index_FIRJAN,
  id = municipality, family = gaussian, data = municipalities_filtered
)
summary(gee_beta_model_1)

# The intercept is significant, what does that mean? Maybe I should look for other controls? 
# My dummy is significant. 
# The HDI is significant. 
# All significant variables have expected signs: municipalities with enrollments in high school full time are more likely to have lower early pregnancy rates than
## municipalities that don't have enrollments in high school full time. 
# Municipalities with higher HDI are more likely to have lower pregnancy rates. 


# Further steps -----------------------------------------------------------

## I need to better present this table: How can I remove the natural logarithm? 
## Should I run other models with transformed variables and see the difference? 
## should I try to run the model with the dummy for the final years of education? 


# Another dummy: final years of primary education -------------------------

gee_beta_model_2 <- geeglm(
  early_pregnancy_rt_transformed ~ enrollments_final_yers_full + gdp_pc + failures_high_school + dropouts_high_school + HDI_index_FIRJAN,
  id = municipality, family = gaussian, data = municipalities_filtered
)
summary(gee_beta_model_2)

## There is no significance for the dummy of final years of primary education. 

max(gee_beta_model_2$fitted.values)
min(gee_beta_model_2$fitted.values)

hist(municipalities_filtered$early_pregnancy_rt_transformed)
hist(gee_beta_model_2$fitted.values)

gee_beta_model_3 <- betareg(
  early_pregnancy_rt ~ enrollments_final_yers_full + gdp_pc + failures_high_school + dropouts_high_school + HDI_index_FIRJAN | municipality + year,
  link = "logit", data = municipalities_filtered
)
summary(gee_beta_model_3)
