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
MiscVal SalePrice LandSlope LS_1 LS_2 LS_3 PavedDrive PD_1 PD_2 PD_3;
* Create Indicator Variables from Categorical Variable;
    if LandSlope in ('Gtl' 'Mod' 'Sev') then do;
      LS_1 = (LandSlope eq 'Gtl');
      LS_2 = (LandSlope eq 'Mod');
      LS_3 = (Landslope eq 'Sev');
    end;
    * Recode Categorical Variable so we can use in strait reg;
    if LandSlope='Gtl' then LandSlope=1;
    if LandSlope='Mod' then LandSlope=2;
    if LandSlope='Sev' then LandSlope=3;
    * Create Indicator Variables from Categorical Variable;
    if PavedDrive in ('Y' 'P' 'N') then do;
      PD_1 = (PavedDrive eq 'Y');
      PD_2 = (PavedDrive eq 'P');
      PD_3 = (PavedDrive eq 'N');
    end;
    * Recode Categorical Variable so we can use in strait reg;
    if PavedDrive='Y' then PavedDrive=1;
    if PavedDrive='P' then PavedDrive=2;
    if PavedDrive='N' then PavedDrive=3;
  
    
proc means data=temp;
  class LandSlope;
  var SalePrice;

proc freq data=temp;
  tables Landslope LS_1 LS_2;


proc reg data=Temp;
  model SalePrice = LS_1 LS_2;

proc means data=temp;
  class PavedDrive;
  var SalePrice;

proc freq data=temp;
  tables PavedDrive PD_1 PD_2;

proc reg data=temp;
  model SalePrice = LandSlope;
  
  



  *** Task 5;
proc reg data=temp outest=reg_adrsq_out;
	Title 'Adjusted R-Square Model';
	model SalePrice = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
  selection= adjrsq aic bic cp best=1;
  output out=adrsq_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;          
proc print data=reg_adrsq_out;


  *** Best Adjusted R-Square;
proc reg data=temp;
model SalePrice = LotFrontage LotArea MasVnrArea BsmtFinSF1 TotalBsmtSF FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ScreenPorch PoolArea MiscVal LS_2 PD_1/ vif;
title 'Best Adjusted R-Square ';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

  ***  R-Square Model;
proc reg data=temp outest=reg_rsq_out;
	Title 'R-Square Model';
	model SalePrice = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
  selection= rsquare adjrsq aic bic cp best=1;  
    output out=rsq_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;        
proc print data=reg_rsq_out;

  *** Best R-Square;
proc reg data=temp;
model SalePrice = LotFrontage LotArea MasVnrArea BsmtFinSF2 BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea MiscVal LS_2 PD_1/ vif;
title 'Best R-Square ';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;


  ***  Mallows CP Model;
proc reg data=temp outest=reg_cp_out;
	Title 'Mallows CP Model';
	model SalePrice = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
             selection=cp adjrsq aic bic best=1;
            output out=cp_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;
 

proc print data=reg_cp_out;

  *** Best Mallows CP ;
proc reg data=temp;
model SalePrice = LotFrontage LotArea MasVnrArea BsmtFinSF1 TotalBsmtSF LowQualFinSF GrLivArea GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ScreenPorch PoolArea MiscVal LS_1 PD_1/ vif;
title 'Best Mallows CP training';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

  ***  Forward;
proc reg data=temp outest=reg_forward_out;
	Title 'Forward Selection Model';
	model SalePrice = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
  selection=forward adjrsq aic bic cp best=1;
    output out=forward_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;

proc print data=reg_forward_out;

  ***  Backward;
proc reg data=temp outest=reg_backward_out;
	Title 'Backward Selection Model';
	model SalePrice = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
  selection=backward adjrsq aic bic cp best=1;
    output out=backward_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;

proc print data=reg_backward_out;


  ***  Stepwise;
proc reg data=temp outest=reg_stepwise_out;
	Title 'Stepwise Selection Model';
	model SalePrice = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
  selection=stepwise adjrsq aic bic cp best=1;
    output out=stepwise_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;

proc print data=reg_stepwise_out;




  *** Task 6 revised;
proc reg data=temp;
model SalePrice = LotArea MasVnrArea BsmtFinSF1 TotalBsmtSF FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ScreenPorch PoolArea MiscVal LS_1 LS_2 PD_1 PD_2/ vif;
title 'Revised Best Adj R-Square ';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

  *** Task 6 revised;
proc reg data=temp;
model SalePrice = MasVnrArea BsmtFinSF1 TotalBsmtSF FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ScreenPorch PoolArea MiscVal LS_1 LS_2 PD_1 PD_2/ vif;
title 'Revised Best Adj R-Square v2 ';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;


  *** Task 7 - training set;
data temp2;
  set temp;
  u = uniform(123);
  if (u < 0.70) then train = 1;
    else train = 0;
      if (train=1) then train_response=SalePrice;
        else train_response=.;
run;

proc print data=temp2(obs=5); run;

  *** Task 8 - model id with training set;
  proc reg data=temp2 outest=reg_rsq_out;
	Title 'Adjusted R-Square Model -training';
	model train_response = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
  selection= adjrsq aic bic cp best=1;  
    output out=adrsq_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;        
proc print data=reg_rsq_out;


  ***  R-Square Model - training;
proc reg data=temp2 outest=reg_rsq_out;
	Title 'R-Square Model- training';
	model train_response = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
  selection= rsquare adjrsq aic bic cp best=1; 
    output out=rsq_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;         
proc print data=reg_rsq_out;


  ***  Mallows CP Model - training;
proc reg data=temp2 outest=reg_cp_out;
	Title 'Mallows CP Model - training';
	model train_response = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
  selection=cp adjrsq aic bic best=1;
    output out=cp_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;

proc print data=reg_cp_out;


  ***  Forward - training;
proc reg data=temp2 outest=reg_forward_out;
	Title 'Forward Selection Model - training';
	model train_response = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
  selection=forward adjrsq aic bic cp best=1;
    output out=forward_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;

proc print data=reg_forward_out;

  ***  Backward - training;
proc reg data=temp2 outest=reg_backward_out;
	Title 'Backward Selection Model - training';
	model train_response = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
  selection=backward adjrsq aic bic cp best=1;
    output out=backward_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;

proc print data=reg_backward_out;


  ***  Stepwise - training;
proc reg data=temp2 outest=reg_stepwise_out;
	Title 'Stepwise Selection Model - training';
	model train_response = LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
          BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
          WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea 
          MiscVal LS_1 LS_2 LS_3 PD_1 PD_2 PD_3/
  selection=stepwise adjrsq aic bic cp best=1;
    output out=stepwise_out pred=yhat residual = resid ucl=ucl lcl=lcl cookd=cook
	covratio=cov dffits=dfits press=prss;

proc print data=reg_stepwise_out;

  *** Best adjusted R-Square training;
proc reg data=temp;
model SalePrice = LotArea MasVnrArea BsmtFinSF1 BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ScreenPorch PoolArea LS_1 PD_1/ vif;
title 'Best adjusted R-Square training';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;


  *** Best R-Square training;
proc reg data=temp;
model SalePrice =  	LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ScreenPorch PoolArea MiscVal LS_1 PD_1 PD_3/ vif;
title 'Best R-Square training';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

  *** Best Mallows CP training;
proc reg data=temp;
model SalePrice = LotArea MasVnrArea BsmtFinSF2 BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ScreenPorch PoolArea LS_1 PD_1/ vif;
title 'Best Mallows CP training';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;

  *** Best Model overall;
proc reg data=temp2;
model SalePrice = MasVnrArea BsmtFinSF1 TotalBsmtSF LowQualFinSF GRLivArea GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ScreenPorch LS_1 LS_2 PD_1 PD_2/ vif;
title 'Best model overal';
output out=fitted_model pred=yhat residual=resid 
ucl=ucl lcl=lcl cookd=cook covratio=cov dffits=dfits press=prss;
run;




** task 9 - rsqr model;
data rsq_out; set rsq_out;
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(SalePrice-yhat);
square_error = (SalePrice-yhat)*(SalePrice-yhat); end;


proc means data=rsq_out nway noprint;
Title 'R-square';
class train;
var square_error absolute_error;
output out=rsq_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data=rsq_error; run;

** task 9 - adrsqr model;
data adrsq_out; set adrsq_out;
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(SalePrice-yhat);
square_error = (SalePrice-yhat)*(SalePrice-yhat); end;


proc means data=adrsq_out nway noprint;
Title 'Adjusted R-square';
class train;
var square_error absolute_error;
output out=adrsq_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data=adrsq_error; run;

** task 9 - mallows cp;
data cp_out; set cp_out;
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(SalePrice-yhat);
square_error = (SalePrice-yhat)*(SalePrice-yhat); end;


proc means data=cp_out nway noprint;
Title 'Mallows CP';
class train;
var square_error absolute_error;
output out=cp_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data=cp_error; run;


** task 9 - forward;
data forward_out; set forward_out;
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(SalePrice-yhat);
square_error = (SalePrice-yhat)*(SalePrice-yhat); end;


proc means data=forward_out nway noprint;
Title 'Forward';
class train;
var square_error absolute_error;
output out=forward_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data=forward_error; run;

** task 9 - backward;
data backward_out; set backward_out;
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(SalePrice-yhat);
square_error = (SalePrice-yhat)*(SalePrice-yhat); end;


proc means data=backward_out nway noprint;
Title 'Backward';
class train;
var square_error absolute_error;
output out=backward_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data=backward_error; run;

** task 9 - stepwise model;
data stepwise_out; set stepwise_out;
if train=1 then do;
absolute_error = abs(resid);
square_error = resid*resid; end;
if train=0 then do;
absolute_error = abs(SalePrice-yhat);
square_error = (SalePrice-yhat)*(SalePrice-yhat); end;


proc means data=stepwise_out nway noprint;
Title 'Stepwise';
class train;
var square_error absolute_error;
output out=stepwise_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data=stepwise_error; run;

** Task 10 rsq ;
data rsq_out; set rsq_out;
Title 'R-square';
if yhat >= (SalePrice *0.9) and yhat <= (SalePrice *1.1) then
		Prediction_Grade="Grade 1";
	else if yhat >= (SalePrice *0.85) and yhat <= (SalePrice *1.15) then
	Prediction_Grade="Grade 2";
	else Prediction_Grade="Grade 3";
	
proc sort data=rsq_out; by train;
Proc freq data=rsq_out; tables prediction_grade; by train; run;

** Task 10 adrsq ;
data adrsq_out; set adrsq_out;
Title 'Adjusted R-square';
if yhat >= (SalePrice *0.9) and yhat <= (SalePrice *1.1) then
	Prediction_Grade="Grade 1";
	else if yhat >= (SalePrice *0.85) and yhat <= (SalePrice *1.15) then
	Prediction_Grade="Grade 2";
	else Prediction_Grade="Grade 3";
	
proc sort data=adrsq_out; by train;
Proc freq data=adrsq_out; tables prediction_grade; by train; run;

** Task 10 mallows cp ;
data cp_out; set cp_out;
Title 'Mallows CP';
if yhat >= (SalePrice *0.9) and yhat <= (SalePrice *1.1) then
	Prediction_Grade="Grade 1";
	else if yhat >= (SalePrice *0.85) and yhat <= (SalePrice *1.15) then
	Prediction_Grade="Grade 2";
	else Prediction_Grade="Grade 3";
	
proc sort data=cp_out; by train;
Proc freq data=cp_out; tables prediction_grade; by train; run;

** Task 10 forward ;
data forward_out; set forward_out;
Title 'Forward';
if yhat >= (SalePrice *0.9) and yhat <= (SalePrice *1.1) then
	Prediction_Grade="Grade 1";
	else if yhat >= (SalePrice *0.85) and yhat <= (SalePrice *1.15) then
	Prediction_Grade="Grade 2";
	else Prediction_Grade="Grade 3";
	
proc sort data=forward_out; by train;
Proc freq data=forward_out; tables prediction_grade; by train; run;

** Task 10 backward ;
data backward_out; set backward_out;
Title 'Backward';
if yhat >= (SalePrice *0.9) and yhat <= (SalePrice *1.1) then
	Prediction_Grade="Grade 1";
	else if yhat >= (SalePrice *0.85) and yhat <= (SalePrice *1.15) then
	Prediction_Grade="Grade 2";
	else Prediction_Grade="Grade 3";
	
proc sort data=backward_out; by train;
Proc freq data=backward_out; tables prediction_grade; by train; run;

** Task 10  stepwise;
data stepwise_out; set stepwise_out;
Title 'Stepwise';
if yhat >=(SalePrice *0.9) and yhat <=(SalePrice *1.1) then
	Prediction_Grade="Grade 1";
	else if yhat >=(SalePrice *0.85) and yhat <=(SalePrice *1.15) then
	Prediction_Grade="Grade 2";
	else Prediction_Grade="Grade 3";
	
proc sort data=stepwise_out; by train;
Proc freq data=stepwise_out; tables prediction_grade; by train; run;

