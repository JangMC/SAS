%let PATH 	=/home/meredithjang20170/my_courses/Jang/411/Wine;
%let NAME 	= LR;
%let LIB	= &NAME..;

libname &NAME. "&PATH.";


%let INFILE   =	&LIB.wine;
%let TEMPFILE = TEMPFILE;
%let FIXFILE = FIXFILE;
%Let TEMPFILE2 = TEMPFILE2;
%Let TEMPFILE3 = TEMPFILE3;
%Let FIXFILE2 = FIXFILE2;
%let MODELFILE = MODELFILE;

proc contents data=&INFILE.;
run;

proc print data=&INFILE.(obs=10);
run;

proc means data=&INFILE. N NMISS MIN p1 p5 MEAN MEDIAN p95 p99 MAX std;
run;


%LET VAR = 
FixedAcidity
VolatileAcidity
CitricAcid
ResidualSugar
Chlorides
FreeSulfurDioxide
TotalSulfurDioxide
Density
pH
Sulphates
Alcohol
LabelAppeal
AcidIndex
STARS;

%Let FLAG_VAR =  
M_Sulphates
M_Stars
M_Alcohol
M_FreeSulfurDioxide
M_pH
M_ResidualSugar
M_Chlorides
M_TotalSulfurDioxide;

%let Model_VAR1 =
		CAP_FixedAcidity
		CAP_VolatileAcidity
		CAP_CitricAcid
		CAP_ResidualSugar
		CAP_Chlorides
		CAP_FreeSulfurDioxide
		CAP_TotalSulfurDioxide
		CAP_Density
		CAP_pH
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		Original_Stars1
		Original_Stars2
		Original_Stars3
		Original_Stars4
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal1
		LabelAppeal2
		M_Sulphates
		M_Stars
		M_Alcohol
		M_FreeSulfurDioxide
		M_pH
		M_ResidualSugar
		M_Chlorides
		M_TotalSulfurDioxide;



%let Model_VAR2=
		CAP_FixedAcidity
		CAP_VolatileAcidity
		CAP_CitricAcid
		CAP_ResidualSugar
		CAP_Chlorides
		CAP_FreeSulfurDioxide
		CAP_TotalSulfurDioxide
		CAP_Density
		CAP_pH
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		CAP_Stars1
		CAP_Stars2
		CAP_Stars3
		CAP_Stars4
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal1
		LabelAppeal2
		M_Sulphates
		M_Stars
		M_Alcohol
		M_FreeSulfurDioxide
		M_pH
		M_ResidualSugar
		M_Chlorides
		M_TotalSulfurDioxide;

**** EDA - HISTOGRAMS AND BOXPLOTS;
proc univariate data=&INFILE. noprint;
var TARGET &VAR;
histogram;
run;

**proc univariate data=&INFILE. plot;
**var &VAR;
**run;


***EDA Correlations;
proc corr data=&INFILE.; 
run;

******VIEW TRANSFORMATIONS;
data &TEMPFILE3.;
set &INFILE.;

LOG1_SULPHATES = log10(abs(SULPHATES)); 
LOG1_pH = sign(pH)*log10(abs(pH)+1); 
LOG1_DENSITY = sign(Density)*log10(abs(Density)+1); 
LOG1_TotalSulfurDioxide = log10(abs(TotalSulfurDioxide)); 
LOG1_FreeSulfurDioxide = sign(FreeSulfurDioxide)*log10(abs(FreeSulfurDioxide)+1);
LOG1_Chlorides = sign(Chlorides)*log10(abs(Chlorides)+1);
LOG1_ResidualSugar = sign(ResidualSugar)*log10(abs(ResidualSugar)+1);
LOG1_CitricAcid = sign(CitricAcid)*log10(abs(CitricAcid)+1);
LOG1_VolatileAcidity = sign(VolatileAcidity)*log10(abs(VolatileAcidity)+1);
LOG1_FixedAcidity = sign(FixedAcidity)*log10(abs(FixedAcidity)+1);

proc univariate data=&TEMPFILE3. noprint;
var LOG1_SULPHATES  
LOG1_pH 
LOG1_DENSITY  
LOG1_TotalSulfurDioxide  
LOG1_FreeSulfurDioxide 
LOG1_Chlorides 
LOG1_ResidualSugar
LOG1_CitricAcid 
LOG1_VolatileAcidity 
LOG1_FixedAcidity;
histogram;
run;


*******COUNT NEGATIVE RECORDS;

PROC SQL;
         SELECT COUNT (Index) AS NegFixedAcidity
         FROM &INFILE.
         WHERE FixedAcidity <0;
QUIT;


PROC SQL;
         SELECT COUNT (Index) AS NegVolatileAcidity
         FROM &INFILE.
         WHERE VolatileAcidity <0;
QUIT;

PROC SQL;
         SELECT COUNT (Index) AS NegCitricAcid
         FROM &INFILE.
         WHERE CitricAcid <0;
QUIT;

PROC SQL;
         SELECT COUNT (Index) AS NegResidualSugar
         FROM &INFILE.
         WHERE ResidualSugar <0;
QUIT;

PROC SQL;
         SELECT COUNT (Index) AS NegChorides
         FROM &INFILE.
         WHERE Chlorides <0;
QUIT;

PROC SQL;
         SELECT COUNT (Index) AS NegFreeSulfurDioxide
         FROM &INFILE.
         WHERE FreeSulfurDioxide <0;
QUIT;

PROC SQL;
         SELECT COUNT (Index) AS NegTotalSulfurDioxide
         FROM &INFILE.
         WHERE TotalSulfurDioxide <0;
QUIT;

PROC SQL;
         SELECT COUNT (Index) AS Sulphates
         FROM &INFILE.
         WHERE Sulphates <0;
QUIT;

PROC SQL;
         SELECT COUNT (Index) AS NegAlcohol
         FROM &INFILE.
         WHERE Alcohol <0;
QUIT;

PROC SQL;
         SELECT COUNT (Index) AS POSAlcohol
         FROM &INFILE.
         WHERE Alcohol >=0;
QUIT;


PROC SQL;
         SELECT COUNT (Index) AS TotalNegatives
         FROM &INFILE.
         WHERE Alcohol < 0 OR Sulphates <0 OR TotalSulfurDioxide<0 OR FreeSulfurDioxide <0 OR Chlorides <0 
         OR ResidualSugar <0 OR CitricAcid <0 OR VolatileAcidity <0 OR FixedAcidity <0;;
QUIT;




*************************************************************************************************
************************************************************************************************
*************************************************************************************************
*****FIX LARGE NEGATIVE VALUES WITH ABSOLUTES; 
data &TEMPFILE.;
set &INFILE.;

FixedAcidity = ABS (FixedAcidity);
VolatileAcidity = ABS (VolatileAcidity);
CitricAcid = ABS (CitricAcid);
ResidualSugar = ABS(ResidualSugar);
Chlorides = ABS(Chlorides);
FreeSulfurDioxide = ABS(FreeSulfurDioxide);
TotalSulfurDioxide = ABS(TotalSulfurDioxide);
Sulphates = ABS(Sulphates);
Alcohol = ABS(Alcohol);



*****************HISTOGRAMS OF NON-NEGATIVE DATA;
proc univariate data=&TEMPFILE. noprint;
var TARGET &VAR;
histogram;
run;

**proc univariate data=&TEMPFILE2. plot;
**var &VAR;
**run;




***EDA Correlations;
proc corr data=&TEMPFILE.; 
run;


libname wine "/home/meredithjang20170/my_courses/Jang/411/Wine";

data wine.Absolutevalue_wine_file;
set &TEMPFILE.;
run;

*****FIX MISSING VALUES WITH DECISION TREE RESULTS; 
data &TEMPFILE2.;
set &TEMPFILE.;

IMP_Sulphates= Sulphates; 
M_Sulphates= 0; 
if missing(IMP_Sulphates) then do; 
if Chlorides >= .05 AND STARS >=1 then IMP_Sulphates = 0.85;
else if Chlorides >= .05 AND STARS = . then IMP_Sulphates = 0.91;
else if Chlorides = . AND STARS >=1 then IMP_Sulphates = 0.85;
else if Chlorides = . AND STARS = . then IMP_Sulphates = 0.91; 
else if Chlorides < .05 then IMP_Sulphates = 0.81; 
M_Sulphates= 1; 
end; 

IMP_Stars= STARS; 
M_Stars= 0; 
if missing(IMP_Stars) then do; 
if LabelAppeal = 2 AND AcidIndex >= 9 then IMP_Stars = 1; 
else if LabelAppeal = 2 AND AcidIndex < 9 then IMP_Stars = 3;
else if LabelAppeal = 1 AND AcidIndex >= 9 then IMP_Stars = 2;
else if LabelAppeal = 1 AND AcidIndex = 8 AND Alcohol >= 11.5 then IMP_Stars = 3;
else if LabelAppeal = 1 AND AcidIndex = 8 AND Alcohol < 11.5 then IMP_Stars = 2;
else if LabelAppeal = 1 AND AcidIndex = 8 AND Alcohol < . then IMP_Stars = 2;
else if LabelAppeal = 1 AND AcidIndex <= 7 AND Chlorides > = 0.04 AND Alcohol >=10 then IMP_Stars = 3;
else if LabelAppeal = 1 AND AcidIndex <= 7 AND Chlorides > = 0.04 AND Alcohol = . then IMP_Stars = 3;
else if LabelAppeal = 1 AND AcidIndex <= 7 AND Chlorides > = 0.04 AND Alcohol < 10 then IMP_Stars = 2;
else if LabelAppeal = 1 AND AcidIndex <= 7 AND Chlorides = . AND Alcohol >=10 then IMP_Stars = 3;
else if LabelAppeal = 1 AND AcidIndex <= 7 AND Chlorides = . AND Alcohol = . then IMP_Stars = 3;
else if LabelAppeal = 1 AND AcidIndex <= 7 AND Chlorides = . AND Alcohol < 10 then IMP_Stars = 2;
else if LabelAppeal = 1 AND AcidIndex <= 7 AND Chlorides < 0.04 then IMP_Stars = 3;
else if LabelAppeal = 0 AND AcidIndex >= 10 then IMP_Stars = 1;
else if LabelAppeal = 0 AND AcidIndex = 9 AND Chlorides >= .4 then IMP_Stars = 2;
else if LabelAppeal = 0 AND AcidIndex = 9 AND Chlorides < .4 then IMP_Stars = 1;
else if LabelAppeal = 0 AND AcidIndex = 9 AND Chlorides= . then IMP_Stars = 1;
else if LabelAppeal = 0 AND AcidIndex <= 8 then IMP_Stars = 2;
else if LabelAppeal = -1 then IMP_Stars = 1;
else if LabelAppeal = -2 then IMP_Stars = 1;
M_Stars= 1; 
end; 

IMP_Alcohol= Alcohol; 
M_Alcohol= 0; 
if missing(IMP_Alcohol) then do; 
if Density >= 1.00974 AND Chlorides < .044 then IMP_Alcohol = 11.28; 
else if Density >= 1.00974 AND Chlorides >= .044  then IMP_Alcohol = 10.25; 
else if Density >= 1.00974 AND Chlorides = .  then IMP_Alcohol = 10.25;
else if Density >= .9984 AND Density < 1.00974 AND ResidualSugar < 10.3 AND STARS >= 2  then IMP_Alcohol = 11.38;
else if Density >= .9984 AND Density < 1.00974 AND ResidualSugar = . AND STARS >= 2  then IMP_Alcohol = 11.38;
else if Density >= .9984 AND Density < 1.00974 AND ResidualSugar < 10.3 AND STARS = 1  then IMP_Alcohol = 10.19;
else if Density >= .9984 AND Density < 1.00974 AND ResidualSugar = . AND STARS = 1  then IMP_Alcohol = 10.19;
else if Density >= .9984 AND Density < 1.00974 AND ResidualSugar < 10.3 AND STARS = .  then IMP_Alcohol = 10.19;
else if Density >= .9984 AND Density < 1.00974 AND ResidualSugar = . AND STARS = .  then IMP_Alcohol = 10.19;
else if Density >= .9984 AND Density < 1.00974 AND ResidualSugar >= 10.3 AND ResidualSugar < 28.10 then IMP_Alcohol = 9.54;
else if Density >= .9984 AND Density < 1.00974 AND ResidualSugar >= 28.10 then IMP_Alcohol = 10.19;
else if Density >= .99627 AND Density <.9984 then IMP_Alcohol = 9.88;
else if Density >= .9945 and Density < .99627 AND TotalSulfurDioxide >= 169 then IMP_Alcohol = 9.81;
else if Density >= .9945 and Density < .99627 AND TotalSulfurDioxide < 169 then IMP_Alcohol = 10.56;
else if Density >= .9945 and Density < .99627 AND TotalSulfurDioxide = . then IMP_Alcohol = 10.56;
else if Density >= .9925 AND Density <.9945 then IMP_Alcohol = 10.62;
else if Density >=.977769 AND Density <.9925 AND STARS = . then IMP_Alcohol = 11.12;
else if Density >=.977769 AND Density <.9925 AND STARS <= 2 then IMP_Alcohol = 11.2;
else if Density >=.977769 AND Density <.9925 AND STARS >= 3 then IMP_Alcohol = 11.80;
else if Density < .977769 then IMP_Alcohol = 10.41;
M_Alcohol= 1; 
end; 

IMP_FreeSulfurDioxide = FreeSulfurDioxide;  
M_FreeSulfurDioxide= 0; 
if missing(IMP_FreeSulfurDioxide) then do; 
if TotalSulfurDioxide = . AND Chlorides >=.54 then IMP_FreeSulfurDioxide = 128.43;
else if TotalSulfurDioxide >= 427 AND Chlorides >=.54 then IMP_FreeSulfurDioxide = 128.43;
else if TotalSulfurDioxide >= 427 AND Chlorides >= .27 AND Chlorides <.54 AND AcidIndex >=8 then IMP_FreeSulfurDioxide = 85.68;
else if TotalSulfurDioxide >= 427 AND Chlorides >= .27 AND Chlorides <.54 AND AcidIndex < 8 then IMP_FreeSulfurDioxide = 112.25;
else if TotalSulfurDioxide >= . AND Chlorides >= .27 AND Chlorides <.54 AND AcidIndex >=8 then IMP_FreeSulfurDioxide = 85.68;
else if TotalSulfurDioxide >= . AND Chlorides >= .27 AND Chlorides <.54 AND AcidIndex < 8 then IMP_FreeSulfurDioxide = 112.25;
else if TotalSulfurDioxide >= 427 AND Chlorides >= 08 AND Chlorides <.27 AND FixedAcidity >=7 then IMP_FreeSulfurDioxide = 115.57;
else if TotalSulfurDioxide >= 427 AND Chlorides >= .08 AND Chlorides <.27 AND FixedAcidity < 7 then IMP_FreeSulfurDioxide = 140.31;
else if TotalSulfurDioxide >= . AND Chlorides >= .08 AND Chlorides <.27 AND FixedAcidity >=7 then IMP_FreeSulfurDioxide = 115.57;
else if TotalSulfurDioxide >= . AND Chlorides >= .08 AND Chlorides <.27 AND FixedAcidity < 7 then IMP_FreeSulfurDioxide = 140.31;
else if TotalSulfurDioxide >= 427 AND Chlorides < 08  AND CitricAcid >= 1.57 then IMP_FreeSulfurDioxide = 135.68;
else if TotalSulfurDioxide >= . AND Chlorides < 08  AND CitricAcid >= 1.57 then IMP_FreeSulfurDioxide = 135.68;
else if TotalSulfurDioxide >= 427 AND Chlorides < .  AND CitricAcid >= 1.57 then IMP_FreeSulfurDioxide = 135.68;
else if TotalSulfurDioxide >= . AND Chlorides < .  AND CitricAcid >= 1.57 then IMP_FreeSulfurDioxide = 135.68;
else if TotalSulfurDioxide >= 427 AND Chlorides < 08  AND CitricAcid >= .44 AND CitricAcid <1.57 AND Density >= .99448 then IMP_FreeSulfurDioxide = 114.48;
else if TotalSulfurDioxide >= . AND Chlorides < 08  AND CitricAcid >= .44 AND CitricAcid <1.57 AND Density >= .99448 then IMP_FreeSulfurDioxide = 114.48;
else if TotalSulfurDioxide >= 427 AND Chlorides < .  AND CitricAcid >= .44 AND CitricAcid <1.57 AND Density >= .99448 then IMP_FreeSulfurDioxide = 114.48;
else if TotalSulfurDioxide >= . AND Chlorides < .  AND CitricAcid >= .44 AND CitricAcid <1.57 AND Density >= .99448 then IMP_FreeSulfurDioxide = 114.48;
else if TotalSulfurDioxide >= 427 AND Chlorides < 08  AND CitricAcid >= .44 AND CitricAcid <1.57 AND Density < .99448 then IMP_FreeSulfurDioxide = 91.7;
else if TotalSulfurDioxide >= . AND Chlorides < 08  AND CitricAcid >= .44 AND CitricAcid <1.57 AND Density < .99448 then IMP_FreeSulfurDioxide = 91.7;
else if TotalSulfurDioxide >= 427 AND Chlorides < .  AND CitricAcid >= .44 AND CitricAcid <1.57 AND Density < .99448 then IMP_FreeSulfurDioxide = 91.7;
else if TotalSulfurDioxide >= . AND Chlorides < .  AND CitricAcid >= .44 AND CitricAcid <1.57 AND Density < .99448 then IMP_FreeSulfurDioxide = 91.7;
else if TotalSulfurDioxide >= 427 AND Chlorides < .  AND CitricAcid >= .36 AND CitricAcid <.44 then IMP_FreeSulfurDioxide = 137.04;
else if TotalSulfurDioxide >= . AND Chlorides < .  AND CitricAcid >= .36 AND CitricAcid <.44   then IMP_FreeSulfurDioxide = 137.04;
else if TotalSulfurDioxide >= 427 AND Chlorides < .08  AND CitricAcid >= .36 AND CitricAcid <.44 then IMP_FreeSulfurDioxide = 137.04;
else if TotalSulfurDioxide >= . AND Chlorides < .08  AND CitricAcid >= .36 AND CitricAcid <.44   then IMP_FreeSulfurDioxide = 137.04;
else if TotalSulfurDioxide >= 427 AND Chlorides < 08  AND CitricAcid < .36 AND AcidIndex >= 8 then IMP_FreeSulfurDioxide = 94.43;
else if TotalSulfurDioxide >= . AND Chlorides < 08  AND CitricAcid < .36 AND AcidIndex >= 8  then IMP_FreeSulfurDioxide = 94.43;
else if TotalSulfurDioxide >= 427 AND Chlorides < .  AND CitricAcid < .36 AND AcidIndex >= 8  then IMP_FreeSulfurDioxide = 94.43;
else if TotalSulfurDioxide >= . AND Chlorides < .  AND CitricAcid < .36 AND AcidIndex >= 8  then IMP_FreeSulfurDioxide = 94.43;
else if TotalSulfurDioxide >= 427 AND Chlorides < 08  AND CitricAcid < .36 AND AcidIndex < 8 then IMP_FreeSulfurDioxide = 110.42;
else if TotalSulfurDioxide >= . AND Chlorides < 08  AND CitricAcid < .36 AND AcidIndex < 8  then IMP_FreeSulfurDioxide = 110.42;
else if TotalSulfurDioxide >= 427 AND Chlorides < .  AND CitricAcid < .36 AND AcidIndex < 8  then IMP_FreeSulfurDioxide = 110.42;
else if TotalSulfurDioxide >= . AND Chlorides < .  AND CitricAcid < .36 AND AcidIndex < 8  then IMP_FreeSulfurDioxide = 110.42;
else if TotalSulfurDioxide >= . AND Chlorides < 08  AND CitricAcid >= 1.57 then IMP_FreeSulfurDioxide = 135.68;
else if TotalSulfurDioxide >= 427 AND Chlorides < .  AND CitricAcid >= 1.57 then IMP_FreeSulfurDioxide = 135.68;
else if TotalSulfurDioxide >= . AND Chlorides < .  AND CitricAcid >= 1.57 then IMP_FreeSulfurDioxide = 135.68;
else if TotalSulfurDioxide <427 AND VolatileAcidity >= 1.44 AND FixedAcidity >= 4.6 AND Density >= .99835  then IMP_FreeSulfurDioxide = 105.09;
else if TotalSulfurDioxide <427 AND VolatileAcidity >= 1.44 AND FixedAcidity >= 4.6 AND Density >= .99448 AND Density <.99835  then IMP_FreeSulfurDioxide = 80.13;
else if TotalSulfurDioxide <427 AND VolatileAcidity >= 1.44 AND FixedAcidity >= 4.6 AND Density < .99448 then IMP_FreeSulfurDioxide = 104.28;
else if TotalSulfurDioxide <427 AND VolatileAcidity >= 1.44 AND FixedAcidity < 4.6 then IMP_FreeSulfurDioxide = 78.9;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates >= .65 AND Density >=.99448  then IMP_FreeSulfurDioxide = 104.36;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates >= .65 AND Density >=.9925  AND Density < .99448 then IMP_FreeSulfurDioxide = 89.70;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates >= .65 AND Density <.99448  then IMP_FreeSulfurDioxide = 108.16;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates >= .48 AND Sulphates < .65 AND pH >=3.34  then IMP_FreeSulfurDioxide = 116.17;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates >= .48 AND Sulphates < .65 AND pH = .  then IMP_FreeSulfurDioxide = 116.17;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates >= .48 AND Sulphates < .65 AND pH >=3.24 AND pH < 3.34 then IMP_FreeSulfurDioxide = 88.03;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates >= .48 AND Sulphates < .65 AND ph < 3.24  then IMP_FreeSulfurDioxide = 114.67;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates < .48  AND CitricAcid >=3.86  then IMP_FreeSulfurDioxide = 105.59;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates = .  AND CitricAcid >=3.86  then IMP_FreeSulfurDioxide = 105.59;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates < .48 AND CitricAcid >=.3 AND CitricAcid < 3.86  then IMP_FreeSulfurDioxide = 119.69;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates = . AND CitricAcid >=.3 AND CitricAcid < 3.86  then IMP_FreeSulfurDioxide = 119.69;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates < .48 AND CitricAcid < .3 then IMP_FreeSulfurDioxide = 99.63;
else if TotalSulfurDioxide <427 AND VolatileAcidity < 1.44 AND Sulphates = . AND CitricAcid < .3 then IMP_FreeSulfurDioxide = 99.63;
M_FreeSulfurDioxide= 1; 
end; 


IMP_pH = pH; 
M_pH= 0; 
if missing(IMP_pH) then do; 
if AcidIndex >= 8 AND VolatileAcidity >=0.41 then IMP_pH = 3.20;
else if AcidIndex >= 8 AND VolatileAcidity >=0.17 AND VolatileAcidity < 0.41 then IMP_pH = 3.12;
else if AcidIndex >= 8 AND VolatileAcidity < .17 then IMP_pH = 3.19;
else if AcidIndex = 7 AND TotalSulfurDioxide >= 169 then IMP_pH = 3.24;
else if AcidIndex = 7 AND TotalSulfurDioxide >= 93 AND TotalSulfurDioxide < 169 then IMP_pH = 3.17;
else if AcidIndex = 7 AND TotalSulfurDioxide < 93 then IMP_pH =3.28;
else if AcidIndex = 7 AND TotalSulfurDioxide  = . then IMP_pH =3.28;
else if AcidIndex < 7 then IMP_pH = 3.32;
M_pH= 1; 
end; 


IMP_ResidualSugar = ResidualSugar; 
M_ResidualSugar= 0; 
if missing(IMP_ResidualSugar) then do; 
if Density  >= 1.00944 then IMP_ResidualSugar = 22.54; 
else if Density >= .99445 AND Density < 1.00944 then IMP_ResidualSugar = 25.02;
else if Density >= .97764 AND Density < .99445 AND CitricAcid >= 1.5699 then IMP_ResidualSugar = 17.86;
else if Density >= .97764 AND Density < .99445 AND CitricAcid < 1.5699 then IMP_ResidualSugar = 22.6;
else if Density < .97764 AND FreeSulfurDioxide >= 26 then IMP_ResidualSugar = 24.77;else if Density < .97764 AND FreeSulfurDioxide >= 26 then IMP_ResidualSugar = 24.77;
else if Density < .97764 AND FreeSulfurDioxide < 26 then IMP_ResidualSugar = 20.20;
else if Density < .97764 AND FreeSulfurDioxide =. then IMP_ResidualSugar = 20.2;
M_ResidualSugar= 1; 
end; 


IMP_Chlorides = Chlorides; 
M_Chlorides= 0; 
if missing(IMP_Chlorides) then do;
if FixedAcidity >= 8.6 then IMP_Chlorides = .23;
else if FixedAcidity >= 4.6 AND FixedAcidity <8.6 then IMP_Chlorides = .21;
else if FixedAcidity < 4.6 then IMP_Chlorides = .23;
M_Chlorides= 1; 
end; 
 
 
IMP_TotalSulfurDioxide = TotalSulfurDioxide; 
M_TotalSulfurDioxide= 0; 
if missing(IMP_TotalSulfurDioxide) then do; 
if FreeSulfurDioxide  >= 68 AND ResidualSugar >= 10.2 then IMP_TotalSulfurDioxide = 204.18; 
else if FreeSulfurDioxide  >= 68 AND ResidualSugar >= 6.4 AND ResidualSugar < 10.2 then IMP_TotalSulfurDioxide = 225.89;
else if FreeSulfurDioxide  >= 68 AND ResidualSugar = . then IMP_TotalSulfurDioxide = 225.89;
else if FreeSulfurDioxide  >= 68 AND ResidualSugar < 6.4 then IMP_TotalSulfurDioxide = 191.35;
else if FreeSulfurDioxide  >= 47 AND FreeSulfurDioxide < 68 AND Density >= .99441 then IMP_TotalSulfurDioxide = 250.04; 
else if FreeSulfurDioxide  >= 47 AND FreeSulfurDioxide < 68 AND Density >= .97764 AND Density < .99441 then IMP_TotalSulfurDioxide = 193.57;
else if FreeSulfurDioxide  >= 47 AND FreeSulfurDioxide < 68 AND Density < .97764 then IMP_TotalSulfurDioxide = 220.56;
else if FreeSulfurDioxide  >= 15 AND FreeSulfurDioxide < 47 AND ResidualSugar >= 15.8 AND VolatileAcidity >= 1.44 then IMP_TotalSulfurDioxide = 172.25;
else if FreeSulfurDioxide  >= 15 AND FreeSulfurDioxide < 47 AND ResidualSugar >= 15.8 AND VolatileAcidity >= .27 AND VolatileAcidity < 1.44 then IMP_TotalSulfurDioxide = 203.36;
else if FreeSulfurDioxide  >= 15 AND FreeSulfurDioxide < 47 AND ResidualSugar >= 15.8 AND VolatileAcidity < .27 then IMP_TotalSulfurDioxide = 222.36;
else if FreeSulfurDioxide  >= 15 AND FreeSulfurDioxide < 47 AND ResidualSugar = . AND VolatileAcidity >= 1.44 then IMP_TotalSulfurDioxide = 172.25;
else if FreeSulfurDioxide  >= 15 AND FreeSulfurDioxide < 47 AND ResidualSugar = . AND VolatileAcidity >= .27 AND VolatileAcidity < 1.44 then IMP_TotalSulfurDioxide = 203.36;
else if FreeSulfurDioxide  >= 15 AND FreeSulfurDioxide < 47 AND ResidualSugar = . AND VolatileAcidity < .27 then IMP_TotalSulfurDioxide = 222.36;
else if FreeSulfurDioxide  >= 15 AND FreeSulfurDioxide < 47 AND ResidualSugar >= 6.4 AND ResidualSugar < 15.8 then IMP_TotalSulfurDioxide = 224.71;
else if FreeSulfurDioxide  >= 15 AND FreeSulfurDioxide < 47 AND ResidualSugar < 6.4  then IMP_TotalSulfurDioxide = 192.25;
else if FreeSulfurDioxide  = .  AND ResidualSugar >= 15.8 AND VolatileAcidity >= 1.44 then IMP_TotalSulfurDioxide = 172.25;
else if FreeSulfurDioxide  = .   AND ResidualSugar >= 15.8 AND VolatileAcidity >= .27 AND VolatileAcidity < 1.44 then IMP_TotalSulfurDioxide = 203.36;
else if FreeSulfurDioxide  = .   AND ResidualSugar >= 15.8 AND VolatileAcidity < .27 then IMP_TotalSulfurDioxide = 222.36;
else if FreeSulfurDioxide  = .   AND ResidualSugar = . AND VolatileAcidity >= 1.44 then IMP_TotalSulfurDioxide = 172.25;
else if FreeSulfurDioxide  = .   AND ResidualSugar = . AND VolatileAcidity >= .27 AND VolatileAcidity < 1.44 then IMP_TotalSulfurDioxide = 203.36;
else if FreeSulfurDioxide  = .   AND ResidualSugar = . AND VolatileAcidity < .27 then IMP_TotalSulfurDioxide = 222.36;
else if FreeSulfurDioxide  = .   AND ResidualSugar >= 6.4 AND ResidualSugar < 15.8 then IMP_TotalSulfurDioxide = 224.71;
else if FreeSulfurDioxide  = .   AND ResidualSugar < 6.4  then IMP_TotalSulfurDioxide = 192.25;
else if FreeSulfurDioxide  < 15 AND CitricAcid >= .82 then IMP_TotalSulfurDioxide = 202.03;
else if FreeSulfurDioxide  < 15 AND CitricAcid < .82 then IMP_TotalSulfurDioxide = 165;
M_TotalSulfurDioxide= 1; 
end; 


run;


***************ENSURE MISSING VARIABLES HAVE BEEN FIXED;
proc means data= &TEMPFILE2. N NMISS MIN p1 p5 MEAN MEDIAN p95 p99 MAX std;
run;




*********************CAP OUTLIERS;

data &FIXFILE.;
set &TEMPFILE2.;


CAP_FixedAcidity = FixedAcidity;
	IF FixedAcidity > 17.8 THEN CAP_FixedAcidity = 17.8;

CAP_VolatileAcidity = VolatileAcidity;
	IF VolatileAcidity > 1.72 THEN CAP_VolatileAcidity = 1.72;


CAP_CitricAcid = CitricAcid;
	IF CitricAcid > 1.88 THEN CAP_CitricAcid = 1.88;	
	
CAP_ResidualSugar = IMP_ResidualSugar;
	IF IMP_ResidualSugar > 67.8 THEN CAP_ResidualSugar = 67.8;	

CAP_Chlorides = IMP_Chlorides;
	IF IMP_Chlorides > .635 THEN CAP_Chlorides = .635;

CAP_FreeSulfurDioxide = IMP_FreeSulfurDioxide;
	IF IMP_FreeSulfurDioxide > 303 THEN CAP_FreeSulfurDioxide = 303;

CAP_TotalSulfurDioxide = IMP_TotalSulfurDioxide;
	IF IMP_TotalSulfurDioxide > 536 THEN CAP_TotalSulfurDioxide = 536;

CAP_Density = Density;
	IF Density < .9168 THEN CAP_Density = .9168;
	IF Density> 1.06981 THEN CAP_Density = 1.06981 ;
	
CAP_pH = IMP_pH;
	IF IMP_pH < 1.32 THEN CAP_pH = 1.32;
	IF IMP_pH > 5.125 THEN CAP_pH = 5.125;

CAP_Sulphates = IMP_Sulphates;
	IF IMP_Sulphates > 2.15 THEN CAP_Sulphates = 2.15;

CAP_Alcohol = IMP_Alcohol;
	IF IMP_Alcohol > 20.3 THEN CAP_Alcohol = 20.3;

CAP_LabelAppeal = LabelAppeal;
	IF LabelAppeal < -2 THEN CAP_LabelAppeal = -2;
	IF LabelAppeal > 2 THEN CAP_LabelAppeal = 2;

CAP_AcidIndex = AcidIndex;
	IF AcidIndex < 4 THEN CAP_AcidIndex = 4;
	IF AcidIndex > 10  THEN CAP_AcidIndex = 10 ;

CAP_Stars = IMP_Stars;
	IF IMP_Stars < 1 THEN CAP_Stars  = 1;
	IF IMP_Stars > 4 THEN CAP_Stars  = 4;


*****************TRANSFORMATIONS;

LOG_SULPHATES = sign(CAP_SULPHATES)*log10(abs(CAP_SULPHATES)+1); 
SQRT_TotalSulfurDioxide = SQRT(CAP_TotalSulfurDioxide);
SQRT_FreeSulfurDioxide = SQRT(CAP_FreeSulfurDioxide);
LOG_FreeSulfurDioxide = sign(CAP_FreeSulfurDioxide)*log10(abs(CAP_FreeSulfurDioxide)+1); 
T_Chlorides = log10(CAP_FreeSulfurDioxide); 
T_ResidualSugar = log10(CAP_ResidualSugar); 
SQRT_ResidualSugar = SQRT(CAP_ResidualSugar);
T_CitricAcid = -1/(CAP_CitricAcid);
T_VolatileAcidity = -1/(CAP_VolatileAcidity);



***CREATE CATEGORICAL VAIABLES;
if STARS = 1 then Original_Stars1=1;
else Original_Stars1=0;
if STARS = 2 then Original_Stars2=1;
else Original_Stars2=0;
if STARS = 3 then Original_Stars3=1;
else Original_Stars3=0;
if STARS = 4 then Original_Stars4=1;
else Original_Stars4=0;



if CAP_Stars = 1 then CAP_Stars1=1;
else CAP_Stars1=0;
if CAP_Stars= 2 then CAP_Stars2=1;
else CAP_Stars2=0;
if CAP_Stars= 3 then CAP_Stars3=1;
else CAP_Stars3=0;
if CAP_Stars= 4 then CAP_Stars4=1;
else CAP_Stars4=0;


if CAP_LabelAppeal= -2 then LabelAppealMINUS2=1;
else LabelAppealMINUS2=0;
if CAP_LabelAppeal= -1 then LabelAppealMINUS1=1;
else LabelAppealMINUS1=0;
if CAP_LabelAppeal= 0 then LabelAppeal0=1;
else LabelAppeal0=0;
if CAP_LabelAppeal= 1 then LabelAppeal1=1;
else LabelAppeal1=0;
if CAP_LabelAppeal= 2 then LabelAppeal2=1;
else LabelAppeal2=0;


drop 	TotalSulfurDioxide
	Chlorides
	ResidualSugar
	pH
	Alcohol
	FreeSulfurDioxide
	STARS
	Sulphates;

run;


proc means data=&FIXFILE. N NMISS MIN p1 p5 MEAN MEDIAN p95 p99 MAX std;
run;

proc univariate data=&FIXFILE. noprint;
var 
CAP_SULPHATES
LOG_SULPHATES 
CAP_pH 
CAP_Density
SQRT_TotalSulfurDioxide 
CAP_TotalSulfurDioxide 
CAP_FreeSulfurDioxide
SQRT_FreeSulfurDioxide
LOG_FreeSulfurDioxide
CAP_Chlorides 
T_Chlorides
CAP_ResidualSugar 
SQRT_ResidualSugar
T_ResidualSugar
CAP_CitricAcid
T_CitricAcid
CAP_VolatileAcidity 
T_VolatileAcidity
CAP_FixedAcidity ;
histogram;
run;

*****REGRESSION MODELS;

Title color ='red' 'Regression - Var1';
ods graphics on;
proc reg data= &FIXFILE.
outest=outfile AIC BIC SBC CP ADJRSQ
plots = diagnostics(stats=(default aic sbc CP ADJRSQ));

model TARGET = &Model_VAR1.
		/selection = stepwise ADJRSQ VIF AIC BIC CP SBC MSE;
RUN;
quit;

Title color ='green' 'Regression - Var2';
ods graphics on;
proc reg data= &FIXFILE.
outest=outfile AIC BIC SBC CP ADJRSQ
plots = diagnostics(stats=(default aic sbc CP ADJRSQ));

model TARGET = &Model_VAR2.
		/selection = stepwise ADJRSQ VIF AIC BIC CP SBC MSE;
RUN;
quit;


***NON-ZERO REGRESSION;
data NoZero;
set &FIXFILE;
IF TARGET = 0 THEN DELETE;
run;

Title color ='red' 'NON-ZERO Regression ';
ods graphics on;
proc reg data= NoZero
outest=outfile AIC BIC SBC CP ADJRSQ
plots = diagnostics(stats=(default aic sbc CP ADJRSQ));

model TARGET = &Model_VAR1.
		/selection = stepwise ADJRSQ VIF AIC BIC CP SBC MSE;
RUN;
quit;



**********GENMOD WITH POISSON DISTRIBUTION;

Title color ='red' 'GENMOD WITH POISSON DISTRIBUTION - Var1';
proc genmod data=&FIXFILE.;
model TARGET = &Model_VAR1. /link=log dist=poi;
output out=outfile pred = P_TARGET_POI1;
run;


Title color ='red' 'GENMOD WITH POISSON DISTRIBUTION - Var2';
proc genmod data=&FIXFILE.;
model TARGET = &Model_VAR2. /link=log dist=poi;
output out=outfile pred = P_TARGET_POI2;
run;

Title color ='blue' 'GENMOD WITH POISSON DISTRIBUTION - Reduced Variables';
proc genmod data=&FIXFILE.;
model TARGET = 
		CAP_VolatileAcidity
		CAP_TotalSulfurDioxide
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		Original_Stars1
		Original_Stars2
		Original_Stars4
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal2
		M_Stars
		 /link=log dist=poi;
output out=outfile pred = P_TARGET_POIr;
run;



Title color ='red' 'GENMOD WITH POISSON DISTRIBUTION - reduced revised';
proc genmod data=&FIXFILE.;
model TARGET = 	
		CAP_VolatileAcidity
		CAP_TotalSulfurDioxide
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		CAP_Stars1
		CAP_Stars2
		CAP_Stars3
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal1
		M_Stars
		/link=log dist=poi;
output out=outfile pred = P_TARGET_POIrr;
run;

Title color ='red' 'GENMOD WITH POISSON DISTRIBUTION - using variables from stepwise';
proc genmod data=&FIXFILE.;
model TARGET = 	
		M_Stars
		CAP_Stars1
		CAP_Stars2
		CAP_Stars4
		CAP_AcidIndex
		LabelAppeal1
		LabelAppeal2
		LabelAppeal0
		CAP_VolatileAcidity
		LabelAppealMINUS2
		CAP_Alcohol
		CAP_TotalSulfurDioxide
		CAP_pH
		CAP_Density
		CAP_Sulphates
		CAP_CitricAcid
		CAP_FreeSulfurDioxide
		/link=log dist=poi;
output out=outfile pred = P_TARGET_POIrr;
run;





*PROC COUNTREG data= &FIXFILE.;
*model TARGET = &Model_VAR1. / dist=zip;
*zeromodel TARGET ~ CAP_VolatileAcidity
		CAP_TotalSulfurDioxide
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		Original_Stars1
		Original_Stars2
		Original_Stars4
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal2
		M_Stars;
*run;


**********GENMOD WITH NEGATIVE BINOMIAL DISTRIBUTION;

Title color ='red' 'GENMOD WITH NEGATIVE BINOMIAL DISTRIBUTION - Var1';
proc genmod data= &FIXFILE.;
model TARGET = &Model_VAR1. /link=log dist=nb;
output out=outfile pred=P_TARGET__NB1;
run;

Title color ='green' 'GENMOD WITH NEGATIVE BINOMIAL DISTRIBUTION - Var2';
proc genmod data= &FIXFILE.;
model TARGET = &Model_VAR1. /link=log dist=nb;
output out=outfile pred=P_TARGET__NB2;
run;


Title color ='blue' 'GENMOD WITH NEGATIVE BINOMIAL DISTRIBUTION - with reduced variables';
proc genmod data= &FIXFILE.;
model TARGET = CAP_VolatileAcidity
		CAP_TotalSulfurDioxide
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		Original_Stars1
		Original_Stars2
		Original_Stars4
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal2
		M_Stars /link=log dist=nb;
output out=outfile pred=P_TARGET__NBR;
run;

Title color ='blue' 'GENMOD WITH NEGATIVE BINOMIAL DISTRIBUTION - with revised reduced variables';
proc genmod data= &FIXFILE.;
model TARGET = CAP_VolatileAcidity
		CAP_TotalSulfurDioxide
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		CAP_Stars1
		CAP_Stars2
		CAP_Stars3
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal1
		M_Stars /link=log dist=nb;
output out=outfile pred=P_TARGET__NBR;
run;



**********GENMOD WITH ZERO INFLATED POISSON DISTRIBUTION;
proc means data=&FIXFILE. mean var;
where TARGET > 0;
var TARGET;
run;

Title color ='red' 'GENMOD WITH ZIP - Var1';
proc genmod data=&FIXFILE.;
   model TARGET = &Model_VAR1. / dist=ZIP link=log;
   zeromodel CAP_VolatileAcidity
		CAP_Chlorides
		CAP_TotalSulfurDioxide
		CAP_Density
		CAP_pH
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		Original_Stars2
		Original_Stars3
		Original_Stars4
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal2
		M_Stars
		M_ResidualSugar / link=logit;
   output out=outfile pred=P_TARGET_ZIP1 pzero=P_ZERO_ZIP1;
run;

Title color ='green' 'GENMOD WITH ZIP - Var2';
proc genmod data=&FIXFILE.;
   model TARGET = &Model_VAR2. / dist=ZIP link=log;
   zeromodel CAP_VolatileAcidity
		CAP_Chlorides
		CAP_TotalSulfurDioxide
		CAP_Density
		CAP_pH
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		Original_Stars2
		Original_Stars3
		Original_Stars4
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal2
		M_Stars
		M_ResidualSugar / link=logit;
   output out=outfile pred=P_TARGET_ZIP2 pzero=P_ZERO_ZIP2;
run;

Title color ='blue' 'GENMOD WITH ZIP - reduced';
proc genmod data=&FIXFILE.;
   model TARGET = CAP_Alcohol
		CAP_AcidIndex
		Original_Stars1
		Original_Stars2
		Original_Stars4
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal2
		M_Stars / dist=ZIP link=log;
   zeromodel CAP_VolatileAcidity
		CAP_TotalSulfurDioxide
		CAP_pH
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		Original_Stars2
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		M_Stars
		 / link=logit;
   output out=outfile pred=P_TARGET_ZIPr pzero=P_ZERO_ZIPr;
run;


**********GENMOD WITH ZERO INFLATED NEGATIVE BINOMIAL DISTRIBUTION;

Title color ='red' 'GENMOD WITH Negative Binomial - Var1';
proc genmod data=&FIXFILE.;
   model TARGET = &Model_VAR1. / dist=ZINB link=log;
   zeromodel CAP_VolatileAcidity
		CAP_Chlorides
		CAP_TotalSulfurDioxide
		CAP_Density
		CAP_pH
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		Original_Stars2
		Original_Stars3
		Original_Stars4
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal2
		M_Stars
		M_ResidualSugar / link=logit;
   output out=outfile pred=P_TARGET_ZINB1 pzero=P_ZERO_ZINB1;
run;

Title color ='green' 'GENMOD WITH Negative Binomial- Var2';
proc genmod data=&FIXFILE.;
   model TARGET = &Model_VAR2. / dist=ZINB link=log;
   zeromodel CAP_VolatileAcidity
		CAP_Chlorides
		CAP_TotalSulfurDioxide
		CAP_Density
		CAP_pH
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		Original_Stars2
		Original_Stars3
		Original_Stars4
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal2
		M_Stars
		M_ResidualSugar / link=logit;
   output out=outfile pred=P_TARGET_ZINB2 pzero=P_ZERO_ZINB2;
run;

Title color ='blue' 'GENMOD WITH Negative Binomial - reduced';
proc genmod data=&FIXFILE.;
   model TARGET = CAP_Alcohol
		CAP_AcidIndex
		Original_Stars1
		Original_Stars2
		Original_Stars4
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		LabelAppeal2
		M_Stars / dist=ZINB link=log;
   zeromodel CAP_VolatileAcidity
		CAP_TotalSulfurDioxide
		CAP_pH
		CAP_Sulphates
		CAP_Alcohol
		CAP_AcidIndex
		Original_Stars2
		LabelAppealMINUS2
		LabelAppealMINUS1
		LabelAppeal0
		M_Stars
		 / link=logit;
   output out=outfile pred=P_TARGET_ZINBr pzero=P_ZERO_ZINBr;
run;

******************HURDLE MODEL;

data HURDLE;
set &FIXFILE.;
TARGET_FLAG	= (TARGET >0);
TARGET_AMT	= TARGET - 1;
if TARGET_FLAG = 0 then TARGET_AMT = .;
run;

Title color ='red' 'HURDLE - Target Flag';
proc logistic data= HURDLE;
model TARGET_FLAG(ref="0") = &Model_VAR1. /selection=stepwise;
output out=outfile pred=P_TARGET_FLAG;
run;

Title color ='red' 'HURDLE - Target AMT';
proc genmod data= HURDLE;
   model TARGET_AMT = &Model_VAR1. / dist=poi link=log;
   output out=outfile pred=P_TARGET_AMT;
run;

data HURDLE2;
set HURDLE;
P_TARGET_HURDLE = P_TARGET_FLAG * (P_TARGET_AMT+1);
run;

proc print data=outfile;



****************CHECK MODELS;

data MODELCHECK;
set &FIXFILE.;

TEMP   = 1.7590
	+ CAP_Alcohol * 0.0072
	+ CAP_AcidIndex * -0.0265
	+ Original_Stars1 * -0.2698
	+ Original_Stars2 * -0.0971
	+ Original_Stars4 * 0.0993
	+ LabelAppealMINUS2 * -0.8998
	+ LabelAppealMINUS1 * -0.4758
	+ LabelAppeal0 * -0.1903
	+ LabelAppeal2 * 0.1565
	+ M_Stars * -0.2812;
P_SCORE_ZIP_ALL = exp( TEMP  );

P_ZERO_ZIP = -7.7194
	+ CAP_VolatileAcidity * 0.3433
	+ CAP_TotalSulfurDioxide * -0.0014
	+ CAP_pH * 0.2126
	+ CAP_Sulphates * 0.2573
	+ CAP_Alcohol * 0.0184
	+ CAP_AcidIndex * 0.5553
	+ Original_Stars2 * -2.2989
	+ LabelAppealMINUS2 * -2.7774
	+ LabelAppealMINUS1 * -1.2618
	+ LabelAppeal0 * -0.4965
	+ M_Stars * 3.3433;
P_SCORE_ZERO = exp(TEMP)/(1+exp(P_TEMP));


P_SCORE_ZIP = P_SCORE_ZIP_ALL * (1-P_SCORE_ZERO);


proc print data=MODELCHECK (obs=14);
var P_ZERO_ZIPr P_SCORE_ZERO;
RUN;


proc print data=MODELCHECK (obs=14);
var P_TARGET_ZIPr P_SCORE_ZIP;
run;


