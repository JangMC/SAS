%let path=/sscc/home/m/mcj412/predict;
libname orion "&path";

title "regression models";

data ames; set orion.ames_housing;
ods graphics on;

data temp; set ames;
houseage = YrSold - YearBuilt;
bathrooms = FullBath + HalfBath;


data temp; set temp; keep LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch 	ScreenPorch PoolArea 
MiscVal SalePrice houseage bathrooms BedroomAbvGr Fireplaces GarageCars KitchenAbvGr 
TotRmsAbvGrd SaleCondition;


** Task 1 - creating transformed variables;

data temp; set temp;
LogSalePrice = log(SalePrice);
SqrtSalePrice = sqrt(SalePrice);
LogGRLivArea = log(GRLivArea);
SqSalePrice = SalePrice*SalePrice;
LogMasVnrArea = log(MasVnrArea);
proc print data=temp (obs=5);

** Task 2 - 4 SLR models;

proc reg data=temp;
model SalePrice = GRLivArea/ vif ;
title 'a) SLR - saleprice vs GRLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;

proc reg data=temp;
model SalePrice = LogGRLivArea/ vif ;
title 'b) SLR - saleprice vs LogGRLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;

proc reg data=temp;
model LogSalePrice = GRLivArea/ vif ;
title 'c)SLR - Logsaleprice vs GRLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;

proc reg data=temp;
model LogSalePrice = LogGRLivArea/ vif ;
title 'd)SLR - Logsaleprice vs LogGRLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;



** Task 3 - Correlation;
PROC CORR DATA=temp PLOT=(matrix) plots(maxpoints=NONE);
VAR SalePrice LogSalePrice;
WITH LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch 	ScreenPorch PoolArea 
MiscVal;
title '';
run;

proc sgscatter data=temp;
compare Y=SalePrice X=GRLivArea / loess reg;
run;
proc sgscatter data=temp;
compare Y=LogSalePrice X=GRLivArea / loess reg;
run;
proc sgscatter data=temp;
compare Y=SqrtSalePrice X=GRLivArea / loess reg;
run;

** task 4 Regression with Sqrt transformation;
proc reg data=temp;
model SqrtSalePrice = GRLivArea/ vif ;
title 'SLR - Sqrtsaleprice vs GRLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;

proc reg data=temp;
model SqrtSalePrice = LogGRLivArea/ vif ;
title 'SLR - Sqsaleprice vs GRLivArea';
output out=fitted_model1 pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;

** Task 5 EDA Before Outliers;
proc sgplot; scatter x= GRLivArea y=SalePrice; run;

proc sort data = temp; by SaleCondition;
proc boxplot data = temp;
  plot SalePrice*SaleCondition;
run;

   proc univariate data=temp;
      var SalePrice;
      histogram;
      probplot / normal(mu=est sigma=est);
   run;


proc univariate normal plot data=temp;
var SalePrice;
histogram SalePrice / normal (color=red w=5);



data outliers;set temp;
 price_outlier = 0;
 if (SalePrice<0) then price_outlier = 1;
 if (GRLivArea>=4000) then price_outlier = 2;
 if (SalePrice>625000) then price_outlier = 3;
 if (SalePrice<34900) then price_outlier = 4;

proc freq data = outliers;
 tables Price_Outlier;
 run;

data pruned; set outliers;
if price_outlier = 1 then delete;
if price_outlier = 2 then delete;
if price_outlier = 3 then delete;
if price_outlier = 4 then delete;


proc freq data = pruned;
 tables Price_Outlier;
 run;

proc univariate normal plot data=pruned;
var SalePrice;
histogram SalePrice / normal (color=red w=5);

** Task 6 Refit models from Assign #2 parts 2 'best' SLR;
Proc Reg data=pruned outest=rsq_var;
	Title 'Model 2 - SLR with best R-Squared';
	model SalePrice = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch 	ScreenPorch PoolArea houseage
MiscVal / selection = rsquare AIC VIF BIC MSE best=1 B stop = 1;
		 output out=model_R2 pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
		 covratio=cov dffits=dfits press=prss;
run;

** Task 6 Refit models from Assign #2 5 MLR with MasVnrArea & GrLivArea;
proc reg data=pruned;
model SalePrice = MasVnrArea GrLivArea/ vif;
title 'Model 5 - MLR with MasVnrArea GrLivArea';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

** task 6 refit models from assign #2 MLR with MasVnrArea & GRLiveArea along with BsmtFinSF2;
proc reg data=pruned;
model SalePrice = MasVnrArea GrLivArea BsmtFinSF2/ vif;
title 'Model 6 - MLR with MasVnrArea and GRLiveArea and BsmtFinSF2';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;


** task 7 Model based outliers;

proc reg data=temp outest=outputmod1;
model LogSalePrice = LogMasVnrArea LogGrLivArea / vif ;
title 'Three variable Regression Model with log transformation';
output out=fitted_model pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;

** DFFITS threshold is 2*Sqrt(p/n) = 2*Sqrt(3/2923) = 0.064;

data out2; set fitted_model; if abs(dfits) > 0.064 then delete;**removes outliers;
 
proc reg data=out2 outest=outputmod2;
model LogSalePrice = LogMasVnrArea LogGrLivArea / vif ;
title 'Two variable Regression Model with log transformation-Outliers Removed';
output out=fitted_model pred=yhat residual=residual ucl=ucl lcl=lcl
cookd=cook covratio=cov dffits=dfits press=prss;
run;
