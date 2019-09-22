# SAS

<b><i> Cluster_Analysis </b></i>

The European employment dataset consists of employment in various industry segments as a percent for thirty European nations. The goal of using this dataset is to perform a cluster analysis. The analysis begins with an exploratory data analysis and concludes with a comparison of cluster results from raw predictor data along with cluster results from transformed predictor variables using principal components analysis.

<b><i> Dummy_Coding_Automated_Variable_Selection_Methods_Validation </b></i>

This analysis explores the process for building different types of regression models. The goal is to create a predictive model to predict the average sale price of a house in Ames, Iowa. In order to do this, I explored:
-	Dummy coding of two categorical variables
-	Six automated variable selection procedures: adjusted R-Square, Mallow’s CP, R-Square, Forward, Backward, and Stepwise
-	Validation framework
The models are compared and the “best” model is chosen that predicts the average home sale price.

<b><i> EDA </b></i>

This is an exploratory data analysis with the Ames Housing Dataset. The goal of using the dataset is to eventually create a predictive model to predict the sale price of a house. In order to do this, a better understanding of the data is needed through an EDA. The analysis includes the following:
-	An overview of the types of variables in the dataset
-	An exploration of potential unusual values that may be outliers
-	Identification of continuous variables through correlation coefficients and scatterplots that are highly correlated with Sale Price to potentially include in a prediction model
-	Exploration of categorical variables of the dataset
-	Exploration of different visuals such as a histogram, bar chart, and a scatterplot matrix 

<b><i> Factor_Aanalysis </b></i>

The stock portfolio dataset consists of the daily closing stock prices for twenty stocks and a large-cap index fund from Vanguard. The goal of using the dataset is to use a factor analysis to identify sectors in the stock market.

<b><i> Predicting_Baseball_Team_Wins </b></i>

The goal of this analysis is to predict the number of wins for a professional baseball team in a 162 game season. In order to accomplish this goal, I analyzed the Moneyball dataset that includes 2,276 observations from professional baseball teams from 1871-2006. In order to best predict the number of wins, the following linear regression models were explored: 
-	A subjective selection of predictors based on correlations
-	Model selected by forward selection
-	Model selected by backward selection
-	Model selected by stepwise regression

<b><i> Predicting_Insurance_Claims </b></i>

Car insurance provides peace of mind to drivers when they are in an accident that they will be able to fix their car. For car insurance providers, it’s important to know how risky a driver is so an insurance policy can be appropriately priced. To appropriately price a policy, many elements need to be taken into consideration such as the likelihood of a person needing to file a claim as well as how much the company may need to pay out on a claim. This is one reason why we may want to model insurance data. The goal of the analysis is to estimate the probability of a driver filing a claim and estimate the amount of the claim. To do this, logistic regression is used. 

<b><i> Predicting_Wine_Sales </b></i>

The goal of this analysis is to predict the number of cases of wine that will be sold given certain properties of the wine. Models explored include generalized linear models with:
-	Poisson distribution
-	Negative Binomial distribution
-	Zero Inflated Poisson distribution
-	Zero Inflated Negative Binomial distribution

<b><i> Principal_Component_Analysis </b></i>

The stock portfolio dataset consists of the daily closing stock prices for twenty stocks and a large-cap index fund from Vanguard. The goal of using the dataset is to use the log-returns of the twenty individual stocks to explain the variation in the log-returns of the market (Vanguard) index. A linear regression will be used, but because there are so many variables, I also explore the use of a Principal Component Analysis as a method of dimension reduction and as a remedial measure for multicollinearity in Ordinary Least Squares regression. 

<b><i> Regression_Predict_Housing_Prices1 </b></i>

The goal of this analysis is to create a predictive model to predict the sale price of a house in Ames, Iowa. In order to do this, the following models were explored:
-	A simple linear regression with a continuous variable that correlated approximately .5 with Sale Price
-	The “best” simple linear regression model using the selection=rsquare option
-	A simple linear regression with a categorical variable
-	A multiple linear regression using two continuous variables 
-	A multiple linear regression using three continuous variables


<b><i> Regression_Predict_Housing_Prices2 </b></i>

The goal of this analysis is to create a predictive model to predict the average sale price of a house in Ames, Iowa. In order to do this, I explored:
-	Dummy coding of categorical variables
-	Automated variable selection procedures
-	Validation framework

The models are compared with and without transformations and with and without outliers.

