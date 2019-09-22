%let path=/sscc/home/m/mcj412/predict;
libname orion "&path";

title "regression models";

data ames; set orion.ames_housing;
proc contents; 
run;

data temp; set ames;
houseage = YrSold - YearBuilt;


** Task 1 Simple Linear Regression with approximate r=0.5;
proc reg data=temp;
model SalePrice = MasVnrArea/ vif;
title 'Model 1 - SLR with MasVnrArea';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

** Task 1 Simple Linear Regression with labeled cooks d;
ods graphics on;
proc reg data = temp
plots(label only) = (cooksd rstudentbypredicted dffits dfbetas);
model SalePrice = MasVnrArea/ vif;
run;
quit;
ods graphics off;


/*
proc gplot data=fitted_model;
plot SalePrice*MasVnrArea yhat*MasVnrArea / overlay;
title 'Output from Gplot for Model 1 -  with MasVnrArea';
run;
*/

** task 2 'best' SLR NEED TO SEE IF ALL VARIABLES ARE INCLUDED;
Proc Reg data=temp outest=rsq_var;
	Title 'Model 2 - SLR with best R-Squared';
	model SalePrice = GrLivArea houseage OverallQual
        FullBath LotArea BsmtFinSF1/ selection = rsquare AIC VIF BIC MSE best=1 B stop = 1;
		 output out=model_R2 pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
		 covratio=cov dffits=dfits press=prss;
run;

** task 2 'best' SLR - ONLY CONTINUOUS VARIABLES;
data temp2; set ames;
houseage = YrSold - YearBuilt;

data temp2; set temp2; keep LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch 	ScreenPorch PoolArea 
MiscVal SalePrice houseage;

Proc Reg data=temp2 outest=rsq_var;
	Title 'Model 2 - SLR with best R-Squared';
	model SalePrice = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch 	ScreenPorch PoolArea houseage
MiscVal / selection = rsquare AIC VIF BIC MSE best=1 B stop = 1;
		 output out=model_R2 pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
		 covratio=cov dffits=dfits press=prss;
run;

** Task 3 Simple Linear Regression with Foundation - NEED TO FIX;
proc reg data=temp;
model SalePrice = Foundation/ vif;
title 'Model 3 - SLR with Foundation';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;


** Task 3 Simple Linear Regression with Foundation - USING DUMMY VARIABLES;


Data temp3; set ames;
if Foundation not in ('BrkTil' 'CBlock' 'PConc' 'Slab' 'Stone' 'Wood') then call missing(BrkTil, CBlock, PConc, Slab, Stone, Wood);
else if Foundation = 'BrkTil' then BrkTil = 1;
else BrkTil = 0;
if Foundation = 'CBlock' then CBlock = 1;
else CBlock = 0;
if Foundation = 'PConc' then Pconc = 1;
else Pconc = 0;
if Foundation = 'Slab' then Slab = 1;
else Slab = 0;
if Foundation = 'Stone' then Stone = 1;
else Stone = 0;
if Foundation = 'Wood' then Wood = 1;
else Wood = 0;
run;
proc print data = temp3(obs=10) noobs;
var Foundation;
run;

proc reg data = temp3;
model SalePrice = Foundation / vif;
title 'Model 3 - SLR with Foundation';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;



data temp3; set ames;
If Foundation = 'BrkTil' then BrkTil = 1; else Style1 = 0;
If HouseStyle = '2Story' then Style2 = 1; else Style2 = 0;


** task 5 MLR with MasVnrArea & GrLivArea;
proc reg data=temp;
model SalePrice = MasVnrArea GrLivArea/ vif;
title 'Model 5 - MLR with MasVnrArea GrLivArea';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

** task 6 MLR with MasVnrArea & GRLiveArea along with BsmtFinSF2;
proc reg data=temp;
model SalePrice = MasVnrArea GrLivArea BsmtFinSF2/ vif;
title 'Model 6 - MLR with MasVnrArea and GRLiveArea and BsmtFinSF2';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;


