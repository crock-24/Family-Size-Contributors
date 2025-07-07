# Impacts of Education, Monthly Income, and Occupation on Family Size utilizing Generalized Linear Models 

## Overview

This project investigates whether education level, occupation, and monthly income are significant predictors of family size, with a specific focus on binary classification of "small" vs. "large" families. The analysis is based on data sourced from Kaggle, originally collected via a food ordering app in Bangalore, India.

Family size is defined as the self-reported number of family members, including the respondent. For modeling purposes, family size was transformed into a binary factor variable:
- **Small**: 2 or fewer members
- **Large**: 3 or more members

The goal is to assess whether higher education and income levels correlate with smaller families, as is often suggested in sociological studies.

---

## Data Description

- **Source**: [Kaggle Dataset - Bangalore Food App Data](https://www.kaggle.com)
- **Response Variable**: Binary family size (`Small`, `Large`)
- **Predictors**:
  - **Education** (e.g., School, Undergraduate, Graduate, Postgraduate)
  - **Occupation** (e.g., Student, Housewife, Employee)
  - **Monthly Income** (categorized into factor levels)

---

## Methods

- **Model Type**: Generalized Linear Model (GLM)
- **Family**: Binomial (for binary response)
- **Link Function**: Logit (canonical)
- **Software Used**: R (Open-source statistical software)
- **Significance Level**: α = 0.05

### Model Selection Process

1. **Exploratory Data Analysis** using boxplots to visualize relationships between family size and each predictor.
2. **GLM fitting** with checks for:
   - Diagnostic plots (QQ plot, residuals vs fitted, Cook’s distance)
   - Model selection based on AIC to prevent overfitting
3. **Final Model**:  
   `Family Size ~ Education + Occupation + Education:Occupation`

---

## Results Summary

### Key Findings

- **Education** was a significant predictor (p = 0.0284)
- **Occupation** alone was not significant (p = 0.2759), but was retained due to significant interaction effects
- **Interaction (Education × Occupation)** was highly significant (p = 0.0017)
- The **postgraduate education level** was associated with **smaller family sizes**
- However, **postgraduates who were students** were more likely to report larger family sizes — possibly due to reporting family of origin (parents/siblings)

### Diagnostics

- **QQ Plot**: Mostly normal residuals, a few mild outliers
- **Residuals vs Fitted**: No evidence of heteroskedasticity
- **Cook’s Distance**: No highly influential points
- **Collinearity**: Present, as indicated by elevated standard errors in Wald tests

---

## Discussion

The results suggest that **education level**, particularly in interaction with **occupation**, plays a meaningful role in predicting family size. Income did not show a strong relationship. One limitation is that the **definition of family size may be ambiguous**—respondents could have included siblings or parents. Future data collection should more clearly differentiate between family of origin and nuclear family (e.g., number of children).

Additionally, multicollinearity among categorical predictors may have obscured some effects, future work could benefit from regularization or dimensionality reduction techniques.

---

## Repository Contents

- `project_report.pdf` – Full written report with figures and tables
- `glm_family_size.R` – R script for data cleaning, EDA, model fitting, and diagnostics

---

## Requirements

- R 4.0+  
- Packages: `ggplot2`, `dplyr`, `car`, `MASS`, `broom`, `performance`, `ggpubr`
