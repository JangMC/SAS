%let path=/sscc/home/m/mcj412/predict;
libname orion "&path";

title "exploratory data analysis";

data ames; set orion.ames_housing;
proc contents; 
run;

data temp; set ames;
houseage = YrSold - YearBuilt;



data temp; set temp; keep LotArea SalePrice GRLivArea;

 ** Task 2 - SORTING;

 ** Sorting - Highest Sale Price;
title "SORTING";

 data temp1; set temp;
 proc sort data=temp1; by descending SalePrice;
   proc print data=temp1 (obs=15);

   
 ** Sorting - Lowest Sale Price;
 data temp1; set temp;
 proc sort data=temp1; by SalePrice;
   proc print data=temp1 (obs=15);

  

  ** Sorting - Highest SF;  
 data temp1; set temp;
 proc sort data=temp1; by descending GRLivArea;
   proc print data=temp1 (obs=15);

  ** Sorting - Lowest SF; 
  
 data temp1; set temp;
 proc sort data=temp1; by GRLivArea;
   proc print data=temp1 (obs=15);
 
  ** Sorting - Highest Lot Size; 
   
 data temp1; set temp;
 proc sort data=temp1; by descending LotArea;
   proc print data=temp1 (obs=15);
  
  ** Sorting - Lowest Lot Size; 
  
 data temp1; set temp;
 proc sort data=temp1; by LotArea;
   proc print data=temp1 (obs=15); 
   
 ** Task 3 - correlations;  
data temp2; set ames;

data temp2; set temp2; keep LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2 
BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GRLivArea GarageArea
WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch 	ScreenPorch PoolArea 
MiscVal SalePrice;


ods graphics on;

proc corr data=temp2 plot=matrix(histogram nvar=all) plots(maxpoints=NONE); 
run;

data temp3; set ames;

data temp3; set temp3; keep GRLivArea GarageArea TotalBsmtSF MasVnrArea FirstFlrSF  
PoolArea SalePrice BsmtFinSF2 ThreeSsnPorch EnclosedPorch;
ods graphics on;

proc corr data=temp3 plot=matrix(histogram nvar=all) plots(maxpoints=NONE); 
run;


 
 ** Task 4 - scatter plots; 
PROC SGSCATTER data=temp3;
MATRIX SalePrice BsmtFinSF2 MasVnrArea GrLivArea/ DIAGONAL= (HISTOGRAM);
ods graphics on;

proc sgplot; scatter x= GRLivArea y=SalePrice; run;
proc sgplot; scatter x= BsmtFinSF2 y=SalePrice; run;
proc sgplot; scatter x= MasVnrArea y=SalePrice; run;

** Task 5 - LOESS; 

proc sgscatter data=temp3;
compare Y=SalePrice X=GRLivArea / loess reg;
run;
proc sgscatter data=temp2;
compare Y=SalePrice X=BsmtFinSF2 / loess reg;
run;
proc sgscatter data=temp2;
compare Y=SalePrice X=MasVnrArea / loess reg;
run;


** Task 6 - analysis of categorical variables;
data love; set ames;
proc freq; tables BldgType Foundation Heating Electrical; run;

proc sgplot; vbar Foundation; run;
proc sgplot; vbar Heating; run;
proc sgplot; vbar Electrical; run;
proc sgplot; vbar BldgType; run;

proc gchart; vbar Electrical Heating Foundation; run;

title;
** Task 7 - realting categorical variables with the response;
proc sort data = love; by Foundation;
proc means; var SalePrice; by Foundation; run;
proc sort data = love; by Heating;
proc means; var SalePrice; by Heating; run;
proc sort data = love; by Electrical;
proc means; var SalePrice; by Electrical; run;

** Task 8 - EDA;


proc means data = temp n mean clm stderr min max;	
  var SalePrice GRLivArea; run;
  



proc means; var SalePrice GRLivArea; run;
proc sort data = temp; by Neighborhood;
proc boxplot data = temp;
  plot SalePrice*Neighborhood;
run;
proc sort data = temp; by LotConfig;
proc boxplot data = temp;
  plot SalePrice*LotConfig;
run;
 
   proc univariate data=temp;
      var SalePrice GRLivArea;
      histogram;
      probplot / normal(mu=est sigma=est);
   run;
** subsetting the data;   
data temp2; set temp; if SalePrice < 500000;
data temp3; set temp; if SalePrice > 500000 then delete;
run;

