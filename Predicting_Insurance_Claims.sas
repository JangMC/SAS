%let PATH 	=/home/meredithjang20170/my_courses/Jang/411/Insurance;
%let NAME 	= LR;
%let LIB	= &NAME..;

libname &NAME. "&PATH.";


%let INFILE   =	&LIB.logit_insurance;

%let TEMPFILE = TEMPFILE;
%LET CHAR = 
CAR_TYPE
CAR_USE
EDUCATION
JOB
MSTATUS
PARENT1
RED_CAR
REVOKED
SEX
URBANICITY;

%LET NUMB = 
KIDSDRIV
AGE
HOMEKIDS
YOJ
INCOME
HOME_VAL
TRAVTIME
BLUEBOOK
TIF
OLDCLAIM
CLM_FREQ
MVR_PTS
CAR_AGE;

proc contents data=&INFILE.;
run;

proc print data=&INFILE.(obs=10);
run;

proc means data=&INFILE. N NMISS MIN p1 p5 MEAN MEDIAN p95 p99 MAX std;
var _numeric_;
run;

proc freq data = &INFILE.;
table _character_  /missing;
run;

data EDA; set &INFILE.;
run;

PROC FREQ DATA = &INFILE.;
TABLES TARGET_FLAG;
run;

proc corr data=&INFILE.; 
run;

** HISTOGRAMS AND BOXPLOTS FOR ADDITIONAL INFO;
proc univariate data=&INFILE. plot;
var TARGET_AMT
&NUMB;
run;

ods graphics on;
proc univariate data=&INFILE.;
  class Target_Flag;
  var &NUMB;      /* computes descriptive statisitcs */
  histogram &NUMB / nrows=2;
  ods select histogram; /* display on the histograms */
run;


proc means data=&INFILE. N MEAN MEDIAN MIN MAX;
var _numeric_;
class Target_Flag;
run;

****Histograms of Continuous Variables;
proc sgplot data=&INFILE.;
HISTOGRAM KIDSDRIV;
run;

proc sgplot data=&INFILE.;
HISTOGRAM AGE;
run;

proc sgplot data=&INFILE.;
HISTOGRAM HOMEKIDS;
run;

proc sgplot data=&INFILE.;
HISTOGRAM YOJ;
run;

proc sgplot data=&INFILE.;
HISTOGRAM INCOME;
run;

proc sgplot data=&INFILE.;
HISTOGRAM HOME_VAL;
run;

proc sgplot data=&INFILE.;
HISTOGRAM TRAVTIME;
run;

proc sgplot data=&INFILE.;
HISTOGRAM BLUEBOOK;
run;

proc sgplot data=&INFILE.;
HISTOGRAM TIF;
run;

proc sgplot data=&INFILE.;
HISTOGRAM OLDCLAIM;
run;

proc sgplot data=&INFILE.;
HISTOGRAM CLM_FREQ;
run;

proc sgplot data=&INFILE.;
HISTOGRAM MVR_PTS ;
run;

proc sgplot data=&INFILE.;
HISTOGRAM CAR_AGE;
run;

data temp5;
set &INFILE.;

OLDCLAIMMORETHANZERO = OLDCLAIM;
IF OLDCLAIMMORETHANZERO ^= 0;
Run;


proc sgplot data=temp5;
HISTOGRAM OLDCLAIMMORETHANZERO ;
run;




*****Bar charts of Categorical Variables split by Target Flag;
proc sgplot data=&INFILE.;
vbar  target_flag / group = CAR_TYPE groupdisplay = cluster STAT = PERCENT;
run;

proc sgplot data=&INFILE.;
vbar target_flag  / group = CAR_USE groupdisplay = cluster STAT = PERCENT;
run;

proc sgplot data=&INFILE.;
vbar target_flag  / group = EDUCATION groupdisplay = cluster STAT = PERCENT;
run;

proc sgplot data=&INFILE.;
vbar target_flag  / group = JOB groupdisplay = cluster MISSING STAT = PERCENT;
run;

proc sgplot data=&INFILE.;
vbar target_flag / group = MSTATUS groupdisplay = cluster STAT = PERCENT;
run;

proc sgplot data=&INFILE.;
vbar target_flag  / group = PARENT1 groupdisplay = cluster STAT = PERCENT;
run;

proc sgplot data=&INFILE.;
vbar target_flag  / group = RED_CAR groupdisplay = cluster STAT = PERCENT;
run;

proc sgplot data=&INFILE.;
vbar target_flag  / group = REVOKED groupdisplay = cluster STAT = PERCENT;
run;

proc sgplot data=&INFILE.;
vbar target_flag  / group = SEX groupdisplay = cluster STAT = PERCENT;
run;

proc sgplot data=&INFILE.;
vbar target_flag / group = URBANICITY  groupdisplay = cluster STAT = PERCENT;
run;

*****FIX MISSING VALUES WITH DECISION TREE RESULTS; 
data dataprep;
set &INFILE.;

IMP_INCOME= INCOME; 
M_INCOME= 0; 
if missing(IMP_INCOME) then do; 
if EDUCATION = "PhD" AND HOME_VAL >= 326553.63 then IMP_INCOME = 177308.52; 
else if EDUCATION = "PhD" AND HOME_VAL < 326553.63 then IMP_INCOME = 96235.61;
else if EDUCATION = "PhD" then IMP_INCOME = 101397.83;
else if EDUCATION = "Masters" AND HOME_VAL >= 326553.63 AND HOME_VAL <= 885282.35 then IMP_INCOME = 140114.65; 
else if EDUCATION = "Masters" AND HOME_VAL >= 270550.08 AND HOME_VAL < 326553.63 then IMP_INCOME = 101639.9;
else if EDUCATION = "Masters" AND HOME_VAL >= 235004.06 AND HOME_VAL < 270550.08 then IMP_INCOME = 79968.36;
else if EDUCATION = "Masters" AND HOME_VAL >= 207946.18 AND HOME_VAL < 235004.06 then IMP_INCOME = 68545.97; 
else if EDUCATION = "Masters" AND HOME_VAL >= 180795.40 AND HOME_VAL < 207946.18 then IMP_INCOME = 55896.43;
else if EDUCATION = "Masters" AND HOME_VAL < 180795.40 then IMP_INCOME = 28221.46;
else if EDUCATION = "Masters" then IMP_INCOME = 50223.42;
else if EDUCATION = "Bachelors" AND HOME_VAL >= 326553.63 AND HOME_VAL <= 885282.35 then IMP_INCOME = 133301.79; 
else if EDUCATION = "Bachelors" AND HOME_VAL >= 270550.08 AND HOME_VAL < 326553.63 then IMP_INCOME = 96985.21; 
else if EDUCATION = "Bachelors" AND HOME_VAL >= 235004.06 AND HOME_VAL < 270550.08 then IMP_INCOME = 78287.80;
else if EDUCATION = "Bachelors" AND HOME_VAL >= 207946.18 AND HOME_VAL < 235004.06 then IMP_INCOME = 64362.45;
else if EDUCATION = "Bachelors" AND HOME_VAL >= 180795.40 AND HOME_VAL < 207946.18 then IMP_INCOME = 54390.16;
else if EDUCATION = "Bachelors" AND HOME_VAL < 180795.40 then IMP_INCOME = 39426.33; 
else if EDUCATION = "Bachelors" then IMP_INCOME = 121206.19;
else if EDUCATION = "z_High School" AND JOB = "Home Maker" OR JOB = "Student" then IMP_INCOME= 6925.83;
else if EDUCATION = "z_High School" AND JOB = "Clerical" then IMP_INCOME= 35040.30;
else if EDUCATION = "z_High School" AND JOB = "z_Blue Collar" then IMP_INCOME= 54999.84;
else if EDUCATION = "z_High School" AND JOB = "Manager" OR JOB = "Professional" then IMP_INCOME= 59367.99;
else if EDUCATION = "<High School" AND JOB = "Home Maker" OR JOB = "Student" then IMP_INCOME= 4673.49;
else if EDUCATION = "<High School" AND JOB = "Clerical" then IMP_INCOME= 25692.74;
else if EDUCATION = "z_High School" AND JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar" then IMP_INCOME= 40763.97;

M_INCOME= 1; 
end; 


IMP_HOME_VAL= HOME_VAL; 
M_HOME_VAL= 0; 
if missing(IMP_HOME_VAL) then do; 
if MSTATUS = "Yes" AND INCOME >= 118276.78 then IMP_HOME_VAL = 409444.61;  
else if MSTATUS = "Yes" AND 91518.63 <= INCOME < 118276.78 then IMP_HOME_VAL = 297864.71;
else if MSTATUS = "Yes" AND  73376.11<= INCOME < 91518.63  then IMP_HOME_VAL = 252733.84;
else if MSTATUS = "Yes" AND 60413.30 <= INCOME < 73376.11 then IMP_HOME_VAL = 225903.42;
else if MSTATUS = "Yes" AND 48407.17<= INCOME < 60413.30 then IMP_HOME_VAL = 198898.38;
else if MSTATUS = "Yes" AND 36621.89 <= INCOME < 48407.17 then IMP_HOME_VAL = 171134.11;
else if MSTATUS = "Yes" AND 24789.25<= INCOME < 36621.89 then IMP_HOME_VAL = 150959.82;
else if MSTATUS = "Yes" AND 6847.71 <= INCOME < 24789.25 then IMP_HOME_VAL = 102797.70;
else if MSTATUS = "Yes" AND 0 <= INCOME < 6847.71 then IMP_HOME_VAL = 50642.48;
else if MSTATUS = "Yes" then IMP_HOME_VAL = 184819.82;
ELSE if MSTATUS = "z_No" AND INCOME >= 118276.78 then IMP_HOME_VAL = 367030.26;  
else if MSTATUS = "z_No" AND 91518.63 <= INCOME < 118276.78 then IMP_HOME_VAL = 123596.22;
else if MSTATUS = "z_No" AND 3376.11 <= INCOME < 91518.63 then IMP_HOME_VAL = 101809.80;
else if MSTATUS = "z_No" AND 36621.89 <= INCOME < 73376.11 then IMP_HOME_VAL = 77637.46;
else if MSTATUS = "z_No" AND 24789.25 <= INCOME < 36621.89 then IMP_HOME_VAL = 54103.42;
else if MSTATUS = "z_No" AND 6847.71 <= INCOME < 24789.25 then IMP_HOME_VAL = 43495.97;
else if MSTATUS = "z_No" AND 0 <= INCOME < 6847.71 Then IMP_HOME_VAL = 20314.13;
else if MSTATUS = "z_No" then IMP_HOME_VAL = 77637.46;
M_HOME_VAL= 1; 
end; 


IMP_YOJ= YOJ; 
M_YOJ= 0; 
if missing(IMP_YOJ) then do; 
if JOB = "Home Maker" AND INCOME>= 6929.74 THEN IMP_YOJ = 11;
else if JOB = "Student" AND INCOME>= 6929.74 THEN IMP_YOJ = 11;
ELSE IF JOB = "Home Maker" THEN IMP_YOJ = 4;
ELSE IF JOB = "Student" THEN IMP_YOJ = 4;
ELSE if JOB = "Clerical" OR JOB = "Doctor" OR JOB = "Lawyer" OR JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar" AND HOMEKIDS >= 4 THEN IMP_YOJ = 14;
ELSE if JOB = "Clerical" OR JOB = "Doctor" OR JOB = "Lawyer" OR JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar"  AND HOMEKIDS = 3 THEN IMP_YOJ = 13;
ELSE if JOB = "Clerical" OR JOB = "Doctor" OR JOB = "Lawyer" OR JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar"  AND HOMEKIDS = 2 THEN IMP_YOJ = 12;
ELSE if JOB = "Clerical" OR JOB = "Doctor" OR JOB = "Lawyer" OR JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar"  AND HOMEKIDS <=2 THEN IMP_YOJ = 11;
ELSE if JOB = "Clerical" OR JOB = "Doctor" OR JOB = "Lawyer" OR JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar"  THEN IMP_YOJ = 13;
else IMP_YOJ = 11;
M_YOJ= 1; 
end; 

IMP_CAR_AGE= ABS(CAR_AGE); 
M_CAR_AGE= 0; 
if missing(IMP_CAR_AGE) then do; 
if EDUCATION = "PhD" then IMP_CAR_AGE = 14;
else if EDUCATION = "Masters" then IMP_CAR_AGE = 14; 
else if EDUCATION = "Bachelors" then IMP_CAR_AGE = 9; 
else if EDUCATION = "z_High School" then IMP_CAR_AGE= 5;
ELSE IF EDUCATION = "<High School" THEN IMP_CAR_AGE = 4; 
M_CAR_AGE= 1; 
end; 

IMP_AGE= AGE; 
M_AGE= 0; 
if missing(IMP_AGE) then do; 
if HOMEKIDS >= 4 then IMP_AGE = 35;
else if HOMEKIDS = 3 THEN IMP_AGE = 39;
Else if HOMEKIDS = 2 THEN IMP_AGE = 40;
Else if HOMEKIDS = 1 THEN IMP_AGE = 38;
Else if HOMEKIDS = 0 THEN IMP_AGE = 48; 
M_AGE= 1; 
end; 


IMP_Job= Job;
if missing(IMP_Job) then do; 
if EDUCATION = "PhD" then IMP_Job = "Doctor";
else if EDUCATION = "Masters" then IMP_Job = "Lawyer"; 
else if EDUCATION = "z_High School"  AND 36634.90 <= INCOME THEN IMP_Job = "z_Blue Collar";
else if EDUCATION = "z_High School"  AND 6842.82 <= INCOME THEN IMP_Job = "Clerical";
else if EDUCATION = "z_High School"  AND 0 <= INCOME THEN IMP_Job = "Home Maker";
else if EDUCATION = "z_High School"  THEN IMP_Job = "z_Blue Collar";
else IF EDUCATION = "Bachelors" AND 36634.90 <= INCOME THEN IMP_Job = "Professional";
else IF EDUCATION = "Bachelors" AND 24671.59 <= INCOME THEN IMP_Job = "Clerical"; 
else IF EDUCATION = "Bachelors" AND 6842.82 <= INCOME THEN IMP_Job = "Student"; 
else IF EDUCATION = "Bachelors" AND 0 <= INCOME THEN IMP_Job = "Home Maker";
else IF EDUCATION = "Bachelors" THEN IMP_Job = "Professional"; 
else IF EDUCATION = "<High School" AND 36634.90 <= INCOME THEN IMP_Job = "z_Blue Collar"; 
else IF EDUCATION = "<High School" AND 6842.82 <= INCOME THEN IMP_Job = "Clerical";
else IF EDUCATION = "<High School" THEN IMP_Job = "Student";  
end; 


***ENSURE MISSING VALUES HAVE BEEN FIXED; 
Title color ='red' 'ENSURE NO MISSING VALUES REMAIN';
proc means data=dataprep N NMISS MIN MEAN MEDIAN MAX ;
var IMP_AGE AGE IMP_CAR_AGE CAR_AGE IMP_YOJ YOJ IMP_INCOME INCOME IMP_HOME_VAL HOME_VAL;
run;

proc sgplot data=DATAPREP;
vbar IMP_JOB / group = target_flag groupdisplay = cluster MISSING STAT = PERCENT;
run;


proc sgplot data=DATAPREP;
vbar JOB / group = target_flag groupdisplay = cluster MISSING STAT = PERCENT;
run;



*****FIX MISSING VALUES  WITH MEDIAN; 
data median;
set &INFILE.;
IMP_MED_INCOME = INCOME;
if missing (IMP_INCOME) then IMP_MED_INCOME = 54028.17;

IMP_MED_AGE= AGE;
if missing(IMP_AGE) then IMP_MED_AGE = 45;

IMP_MED_YOJ= YOJ;
if missing(YOJ) then IMP_MED_YOJ = 11;

IMP_MED_HOME_VAL= HOME_VAL;
if missing(HOME_VAL) then IMP_MED_HOME_VAL = 161159.53;

IMP_MED_CAR_AGE=abs(CAR_AGE);
if missing(CAR_AGE) then IMP_MED_CAR_AGE = 8;

IMP_MED_JOB = JOB;
If missing(JOB) then IMP_JOB = "Unspecified";

drop INCOME
		AGE
		YOJ
		HOME_VAL
		CAR_AGE
		JOB;

LABEL   IMP_MED_INCOME  ="Income"
          IMP_MED_AGE  ="Age"
          IMP_MED_YOJ  ="Years on Job"
          IMP_MED_HOME_VAL  ="Home Value"
          IMP_MED_CAR_AGE  ="Age of car"
          IMP_MED_JOB = "Job"
               ;
RUN;

**Confirm that no missing values remain;
Title color ='red' 'ENSURE NO MISSING VALUES REMAIN';
proc sgplot data=DATAPREP;
vbar IMP_JOB / group = target_flag groupdisplay = cluster MISSING STAT = PERCENT;
run;

proc means data=dataprep N NMISS MIN p1 p5 MEAN MEDIAN p95 p99 MAX std;
var _numeric_;
run;

** CAP OUTLIERS;
data DATAPREP2; set DATAPREP;
CAP_CAR_AGE = IMP_CAR_AGE;
	if  IMP_CAR_AGE<1.00 then CAP_CAR_AGE = 1;
	if IMP_CAR_AGE >23 then CAP_CAR_AGE = 23;
IF CAP_CAR_AGE <= 1 then NEWCAR = 1;
else NEWCAR=0;

CAP_BLUEBOOK= BLUEBOOK; 
if missing(CAP_BLUEBOOK) then do; 
CAP_BLUEBOOK = 13600; 
end; 
	IF BLUEBOOK<1500 THEN CAP_BLUEBOOK = 1500;
	IF BLUEBOOK> 40900 THEN CAP_BLUEBOOK = 40900;
	
CAP_AGE = IMP_AGE;
	IF IMP_AGE<16 THEN CAP_AGE = 16;
	IF IMP_AGE>66 THEN CAP_AGE = 66;
	
CAP_HOME_VAL = IMP_HOME_VAL;
	IF IMP_HOME_VAL<0 THEN CAP_HOME_VAL = 0;
	IF IMP_HOME_VAL>531301.2 THEN CAP_HOME_VAL = 531301.2;

if CAP_HOME_VAL = 0 then RENTER = 1; 
else RENTER = 0; 
	
CAP_INCOME = IMP_INCOME;
	IF IMP_INCOME<0 THEN CAP_INCOME = 0;
	IF IMP_INCOME>228376.1 THEN CAP_INCOME = 228376.1;


if CAP_INCOME = 0 then No_Income = 1; 
else No_Income = 0; 

	
CAP_YOJ = IMP_YOJ;
	IF IMP_YOJ<0 THEN CAP_YOJ = 0;
	IF IMP_YOJ>18 THEN CAP_YOJ =18;

if CAP_YOJ <= 0 then UNEMPLOYED= 1; 
else UNEMPLOYED = 0;

CAP_OLDCLAIM= OLDCLAIM; 
if missing(CAP_OLDCLAIM) then do; 
if CLM_FREQ > 0 then CAP_OLDCLAIM = 2448; 
else CAP_OLDCLAIM= 0; 
end;
CAP_OLDCLAIM = OLDCLAIM;
	IF OLDCLAIM<0 THEN CAP_OLDCLAIM =0;
	IF OLDCLAIM>46600 THEN CAP_OLDCLAIM=46600;
 
if 0<CAP_OLDCLAIM < 2400 then LOW_OLDCLAIM = 1; 
else LOW_OLDCLAIM = 0; 
if CAP_OLDCLAIM > 8300 then HIGH_OLDCLAIM = 1; 
else HIGH_OLDCLAIM = 0; 




CAP_TIF = TIF;
if missing(CAP_TIF) then do;
CAP_TIF =5;
end;
	IF TIF<1 THEN CAP_TIF =1;
	IF TIF>18 THEN CAP_TIF =18;
if CAP_TIF <= 1 then NEWPOLICY = 1; 
else NEWPOLICY = 0;


CAP_TRAVTIME= TRAVTIME; 
if missing(CAP_TRAVTIME) then do; 
CAP_TRAVTIME = 33; 
end; 
	IF TRAVTIME<5 THEN CAP_TRAVTIME = 5;
	IF TRAVTIME>81 THEN CAP_TRAVTIME = 81;

CAP_CLM_FREQ= CLM_FREQ; 
if missing(CAP_CLM_FREQ) then do; 
if CAP_OLDCLAIM > 0 then CAP_CLM_FREQ = 1; 
else CAP_CLM_FREQ= 0; 
end; 
if CAP_CLM_FREQ = 0 then NO_CLM_FREQ = 1; 
else NO_CLM_FREQ = 0; 
if CAP_CLM_FREQ > 4 then CAP_CLM_FREQ = 4; 
 


CAP_KIDSDRIV= KIDSDRIV; 
if missing(CAP_KIDSDRIV) then do; 
CAP_KIDSDRIV = 0; 
end; 
if CAP_KIDSDRIV > 2 then CAP_KIDSDRIV = 2; 

if CAP_KIDSDRIV = 0 then No_Kidsdriv = 1; 
else No_Kidsdriv = 0; 


CAP_HOMEKIDS= HOMEKIDS; 
if missing(CAP_HOMEKIDS) then do; 
CAP_HOMEKIDS = 0; 
end; 
if CAP_HOMEKIDS > 4 then CAP_HOMEKIDS = 4; 

CAP_MVR_PTS= MVR_PTS; 
if missing(CAP_MVR_PTS) then do; 
if CAP_CLM_FREQ < 2 then CAP_MVR_PTS = 1; 
else if CAP_CLM_FREQ > 1 then CAP_MVR_PTS = 2; 
else CAP_MVR_PTS= 1; 
end; 

if CAP_MVR_PTS = 0 then No_MVR_PTS = 1; 
else No_MVR_PTS = 0; 


if CAP_MVR_PTS > 2 then HIGH_MVR_PTS = 1; 
else HIGH_MVR_PTS = 0; 
if CAP_MVR_PTS > 7 then CAP_MVR_PTS = 7; 

****CATEGORICAL DUMMY VARIABLES;
if (EDUCATION= "z_High School") then ED_HS=1; else ED_HS=0; 
if (EDUCATION= "Bachelors") then ED_BACHELORS=1; else ED_BACHELORS=0; 
if (EDUCATION= "<High School") then ED_LESSHS=1; else ED_LESSHS=0; 
if (EDUCATION= "PhD") then ED_PhD=1; else ED_PhD=0; 
if (EDUCATION= "Masters") then ED_MASTERS=1; else ED_MASTERS=0; 


if (CAR_TYPE= "Van") then CAR_VAN=1; else CAR_VAN=0; 
if (CAR_TYPE= "Sports Car") then CAR_SPORTS=1; else CAR_SPORTS=0; 
if (CAR_TYPE= "Pickup") then CAR_PICKUP=1; else CAR_PICKUP=0; 
if (CAR_TYPE= "z_SUV") then CAR_SUV=1; else CAR_SUV=0; 
if (CAR_TYPE= "Minivan") then CAR_MINIVAN=1; else CAR_MINIVAN=0;
if (CAR_TYPE= "Van") then CAR_VAN=1; else CAR_VAN=0;
 if (CAR_TYPE= "Panel Truck") then CAR_PANELTRUCK=1; else CAR_PANELTRUCK=0;


if (IMP_JOB= "Clerical") then JOB_CLERICAL=1; else JOB_CLERICAL=0; 
if (IMP_JOB= "Home Maker") then JOB_HOMEMAKER=1; else JOB_HOMEMAKER=0; 
if (IMP_JOB= "Manager") then JOB_MANAGER=1; else JOB_MANAGER=0; 
if (IMP_JOB= "Professional") then JOB_PROF=1; else JOB_PROF=0; 
if (IMP_JOB= "Student") then JOB_STUDENT=1; else JOB_STUDENT=0; 
if (IMP_JOB= "z_Blue Collar") then JOB_BCOLLAR=1; else JOB_BCOLLAR=0; 
if (IMP_JOB= "Doctor") then JOB_DOCTOR=1; else JOB_DOCTOR=0;
if (IMP_JOB= "Lawyer") then JOB_LAWYER=1; else JOB_LAWYER=0;


LOG_TARGET_AMT = sign(TARGET_AMT)*log10(abs(TARGET_AMT)+1); 
LOG_BLUEBOOK = sign(CAP_BLUEBOOK)*log10(abs(CAP_BLUEBOOK)+1); 
LOG_OLDCLAIM = sign(CAP_OLDCLAIM)*log10(abs(CAP_OLDCLAIM)+1); 
LOG_INCOME = sign(CAP_INCOME)*log10(abs(CAP_INCOME)+1); 
LOG_HOME_VAL = sign(CAP_HOME_VAL)*log10(abs(CAP_HOME_VAL)+1);

drop BLUEBOOK
	OLDCLAIM
	TIF
	TRAVTIME
	JOB
	MVR_PTS
	HOMEKIDS
	KIDSDRIV
	CLM_FREQ
	AGE
	YOJ
	INCOME
	HOME_VAL
	CAR_AGE;

LABEL   CAP_INCOME  ="Income"
          CAP_AGE  ="Age"
          CAP_YOJ  ="Years on Job"
          CAP_HOME_VAL  ="Home Value"
          CAP_CAR_AGE  ="Age of car"
          CAP_BLUEBOOK = "Bluebook"
          CAP_OLDCLAIM = "Total Claims(Past 5 Years)"
          CAP_TIF = "Time in Force"
          CAP_TRAVTIME = "Distance to Work"
          CAP_MVR_PTS = "Motor Vehicle Records Points"
          CAP_HOMEKIDS = "Number of Kids At Home"
          CAP_KIDSDRIV = "Number of Kids Driving"   
          CAP_CLM_FREQ = "Number of Previous Claims"
          M_INCOME = "Flag for Missing Income"
	  M_HOME_VAL = "FLag for missing Home Values"
	  M_YOJ = "Flag for missing years on job"
	  M_CAR_AGE = "Flag for missing age of car"
	  M_AGE = "Flag for missing age"
	  LOW_OLDCLAIM = "Old Claims Under $2400"
	  HIGH_OLDCLAIM = "Old Claims More than $8300"
	  HIGH_MVR_PTS = "More than 7 MVR Points"
	  RENTER = "Rents a Home"
	  NEWCAR = "Car 1 year old or less"
	  NEWPOLICY = "Policy 1 year old or less"
	  UNEMPLOYED = "Income = $0"
	  UNEMPLOYED = "YOJ =0"
	  LOG_TARGET_AMT = "Log Value of Target Amount"
	  LOG_BLUEBOOK = "Log Value of Bluebook"
	  LOG_OLDCLAIM = "Log Value of OldClaim" 
	  LOG_INCOME = "Log Value of Income" 
	  LOG_HOME_VAL = "Log Value of Home Value";
run;

**Confirm outliers have been updated;
Title color ='red' 'ENSURE OUTLIERS ARE HANDLED';
proc means data=dataprep2 N NMISS MIN p1 p5 MEAN MEDIAN p95 p99 MAX std;
var _numeric_;
run;


****FIRST MODEL WITH ALL VARIABLES;
Proc logistic data = dataprep2 Plot(only)=(roc(ID=prob));
Class CAR_USE
	CAR_TYPE
	EDUCATION
	IMP_JOB
	MSTATUS
	PARENT1
	RED_CAR
	REVOKED
	SEX
	URBANICITY 
PARENT1 / param=ref;
Model TARGET_FLAG (ref="0")=
		M_INCOME
					M_HOME_VAL
					M_YOJ
					M_CAR_AGE
					M_AGE
					CAP_CAR_AGE
					NEWCAR
					CAP_BLUEBOOK
					CAP_AGE
					CAP_HOME_VAL
					RENTER
					CAP_INCOME
					UNEMPLOYED
					CAP_YOJ
					CAP_OLDCLAIM
					LOW_OLDCLAIM
					HIGH_OLDCLAIM
					CAP_TIF
					NEWPOLICY
					CAP_TRAVTIME
					CAP_CLM_FREQ
					NO_CLM_FREQ
					CAP_KIDSDRIV
					CAP_HOMEKIDS
					CAP_MVR_PTS
					HIGH_MVR_PTS
					CAR_USE
					CAR_TYPE
					EDUCATION
					IMP_JOB
					MSTATUS
					PARENT1
					RED_CAR
					REVOKED
					SEX
					URBANICITY
					/selection=stepwise roceps=.01;
	Score out = SCORED_FILE;
output out=model_ins pred=yhat; 
run; 

Proc print data =SCORED_FILE (obs=10);
Run;

*********CUMULATIVE LIFT CHART FOR MODEL 1************; 
 proc rank data=model_ins out=training_scores descending groups=10; 
var yhat; 
ranks score_decile;  

run; 
title "Scale Factor for Lift Charts"; 
proc freq data=DATAPREP2; 
tables TARGET_FLAG; 
run; 

proc means data=training_scores sum; 
class score_decile; 
var TARGET_FLAG; 
output out=pm_out sum(TARGET_FLAG)=Y_Sum; 
run; 
proc print data=pm_out; run; 
data lift_chart; 
set pm_out (where=(_type_=1)); 
by _type_; 
Nobs=_freq_; 
score_decile = score_decile+1; 
if first._type_ then do; 
cum_obs=Nobs; 
model_pred=Y_Sum; 
end; 
else do; 
cum_obs=cum_obs+Nobs; 
model_pred=model_pred+Y_Sum; 
end; 
retain cum_obs model_pred; 
* 2153 represents the number of successes, OR how many Y=1 in original data set; 
* This value will need to be changed with different samples; 
pred_rate=model_pred/2153; 
base_rate=score_decile*0.1; 
lift = pred_rate-base_rate; 
drop _freq_ _type_ ; 
run; 
proc print data=lift_chart; run; 
ods graphics on; 
axis1 label=(angle=90 '% Captured from Target Population'); 
axis2 label=('Total Population'); 
legend1 label=(color=black height=1 '') 
value=(color=black height=1 'Model #1' 'Random Guess'); 
title 'Model #1: Lift Chart'; 
symbol1 color=BLUE interpol=join w=2 value=dot height=1; 
symbol2 color=black interpol=join w=2 value=dot height=1;  

proc gplot data=lift_chart; 
plot pred_rate*base_rate base_rate*base_rate / overlay 
legend=legend1 vaxis=axis1 haxis=axis2; 
run; quit; 
ods graphics off; 



*****SECOND MODEL WITH LOGS;
Proc logistic data = dataprep2 Plot(only)=(roc(ID=prob));
Class CAR_USE
	CAR_TYPE
	EDUCATION
	IMP_JOB
	MSTATUS
	PARENT1
	RED_CAR
	REVOKED
	SEX
	URBANICITY 
PARENT1 / param=ref;
Model TARGET_FLAG (ref="0")=
		M_INCOME
					M_HOME_VAL
					M_YOJ
					M_CAR_AGE
					M_AGE
					CAP_CAR_AGE
					NEWCAR
					CAP_AGE
					RENTER
					UNEMPLOYED
					CAP_YOJ
					LOW_OLDCLAIM
					HIGH_OLDCLAIM
					CAP_TIF
					NEWPOLICY
					CAP_TRAVTIME
					CAP_CLM_FREQ
					NO_CLM_FREQ
					CAP_KIDSDRIV
					CAP_HOMEKIDS
					CAP_MVR_PTS
					HIGH_MVR_PTS
					CAR_USE
					CAR_TYPE
					EDUCATION
					IMP_JOB
					MSTATUS
					PARENT1
					RED_CAR
					REVOKED
					SEX
					URBANICITY
					LOG_BLUEBOOK
					LOG_OLDCLAIM
					LOG_INCOME
					LOG_HOME_VAL
					/selection=stepwise roceps=.01;
	Score out = SCORED_FILE;
output out=model_ins pred=yhat; 
run; 

Proc print data =SCORED_FILE (obs=10);
Run;

*********CUMULATIVE LIFT CHART FOR MODEL 2************; 
 proc rank data=model_ins out=training_scores descending groups=10; 
var yhat; 
ranks score_decile;  

run; 
title "Scale Factor for Lift Charts"; 
proc freq data=DATAPREP2; 
tables TARGET_FLAG; 
run; 

proc means data=training_scores sum; 
class score_decile; 
var TARGET_FLAG; 
output out=pm_out sum(TARGET_FLAG)=Y_Sum; 
run; 
proc print data=pm_out; run; 
data lift_chart; 
set pm_out (where=(_type_=1)); 
by _type_; 
Nobs=_freq_; 
score_decile = score_decile+1; 
if first._type_ then do; 
cum_obs=Nobs; 
model_pred=Y_Sum; 
end; 
else do; 
cum_obs=cum_obs+Nobs; 
model_pred=model_pred+Y_Sum; 
end; 
retain cum_obs model_pred; 
* 2153 represents the number of successes, OR how many Y=1 in original data set; 
* This value will need to be changed with different samples; 
pred_rate=model_pred/2153; 
base_rate=score_decile*0.1; 
lift = pred_rate-base_rate; 
drop _freq_ _type_ ; 
run; 
proc print data=lift_chart; run; 
ods graphics on; 
axis1 label=(angle=90 '% Captured from Target Population'); 
axis2 label=('Total Population'); 
legend1 label=(color=black height=1 '') 
value=(color=black height=1 'Model #2' 'Random Guess'); 
title 'Model #2: Lift Chart'; 
symbol1 color=blue interpol=join w=2 value=dot height=1; 
symbol2 color=black interpol=join w=2 value=dot height=1;  

proc gplot data=lift_chart; 
plot pred_rate*base_rate base_rate*base_rate / overlay 
legend=legend1 vaxis=axis1 haxis=axis2; 
run; quit; 
ods graphics off;



*****THIRD MODEL WITH LOGS & DUMMY VARIABLES, VARIABLES ADDRESSING ZERO INFLATION;
Proc logistic data = dataprep2 Plot(only)=(roc(ID=prob));
Class CAR_USE
	MSTATUS
	PARENT1
	RED_CAR
	REVOKED
	SEX
	URBANICITY 
PARENT1 / param=ref;
Model TARGET_FLAG (ref="0")=
			M_INCOME
			M_HOME_VAL
			M_YOJ
			M_CAR_AGE
			M_AGE
			CAR_USE
			MSTATUS
			PARENT1
			RED_CAR
			REVOKED
			SEX
			URBANICITY 
			CAP_CAR_AGE
			NEWCAR
			CAP_AGE
			RENTER
			No_Income
			CAP_YOJ
			UNEMPLOYED
			LOW_OLDCLAIM
			HIGH_OLDCLAIM
			CAP_TIF
			NEWPOLICY
			CAP_TRAVTIME
			CAP_CLM_FREQ
			NO_CLM_FREQ
			CAP_KIDSDRIV
			No_Kidsdriv
			CAP_HOMEKIDS
			CAP_MVR_PTS
			No_MVR_PTS
			HIGH_MVR_PTS
			ED_HS
			ED_BACHELORS
			ED_LESSHS
			ED_PhD
			ED_MASTERS
			CAR_VAN
			CAR_SPORTS
			CAR_PICKUP
			CAR_SUV
			CAR_MINIVAN
			CAR_PANELTRUCK
			JOB_CLERICAL
			JOB_HOMEMAKER
			JOB_MANAGER
			JOB_PROF
			JOB_STUDENT
			JOB_BCOLLAR
			JOB_DOCTOR
			JOB_LAWYER
			LOG_BLUEBOOK
			LOG_OLDCLAIM
			LOG_INCOME
			LOG_HOME_VAL
					/selection=stepwise roceps=.01;
	Score out = SCORED_FILE;
output out=model_ins pred=yhat; 
run; 

Proc print data =SCORED_FILE (obs=10);
Run;

*********CUMULATIVE LIFT CHART FOR MODEL 3************; 
 proc rank data=model_ins out=training_scores descending groups=10; 
var yhat; 
ranks score_decile;  

run; 
title "Scale Factor for Lift Charts"; 
proc freq data=DATAPREP2; 
tables TARGET_FLAG; 
run; 

proc means data=training_scores sum; 
class score_decile; 
var TARGET_FLAG; 
output out=pm_out sum(TARGET_FLAG)=Y_Sum; 
run; 
proc print data=pm_out; run; 
data lift_chart; 
set pm_out (where=(_type_=1)); 
by _type_; 
Nobs=_freq_; 
score_decile = score_decile+1; 
if first._type_ then do; 
cum_obs=Nobs; 
model_pred=Y_Sum; 
end; 
else do; 
cum_obs=cum_obs+Nobs; 
model_pred=model_pred+Y_Sum; 
end; 
retain cum_obs model_pred; 
* 2153 represents the number of successes, OR how many Y=1 in original data set; 
* This value will need to be changed with different samples; 
pred_rate=model_pred/2153; 
base_rate=score_decile*0.1; 
lift = pred_rate-base_rate; 
drop _freq_ _type_ ; 
run; 
proc print data=lift_chart; run; 
ods graphics on; 
axis1 label=(angle=90 '% Captured from Target Population'); 
axis2 label=('Total Population'); 
legend1 label=(color=black height=1 '') 
value=(color=black height=1 'Model #3' 'Random Guess'); 
title 'Model #3: Lift Chart'; 
symbol1 color=blue interpol=join w=2 value=dot height=1; 
symbol2 color=black interpol=join w=2 value=dot height=1;  

proc gplot data=lift_chart; 
plot pred_rate*base_rate base_rate*base_rate / overlay 
legend=legend1 vaxis=axis1 haxis=axis2; 
run; quit; 
ods graphics off;

*****FOURTH MODEL WITH DUMMY VARIABLES;
Proc logistic data = dataprep2 Plot(only)=(roc(ID=prob));
Class CAR_USE
	MSTATUS
	PARENT1
	RED_CAR
	REVOKED
	SEX
	URBANICITY 
PARENT1 / param=ref;
Model TARGET_FLAG (ref="0")=
			CAR_USE
			MSTATUS
			PARENT1
			RED_CAR
			REVOKED
			CAR_USE
			SEX
			URBANICITY
			M_INCOME
			M_HOME_VAL
			M_YOJ
			M_CAR_AGE
			M_AGE
			CAP_CAR_AGE
			NEWCAR
			CAP_AGE
			RENTER
			No_Income
			CAP_YOJ
			UNEMPLOYED
			LOW_OLDCLAIM
			HIGH_OLDCLAIM
			CAP_TIF
			NEWPOLICY
			CAP_TRAVTIME
			CAP_CLM_FREQ
			NO_CLM_FREQ
			CAP_KIDSDRIV
			No_Kidsdriv
			CAP_HOMEKIDS
			CAP_MVR_PTS
			No_MVR_PTS
			HIGH_MVR_PTS
			ED_HS
			ED_BACHELORS
			ED_MASTERS
			CAR_SPORTS
			CAR_PICKUP
			CAR_SUV
			CAR_MINIVAN
			JOB_HOMEMAKER
			JOB_MANAGER
			JOB_BCOLLAR
			JOB_DOCTOR
			CAP_BLUEBOOK
			CAP_OLDCLAIM
			CAP_INCOME
			CAP_HOME_VAL
					/selection=stepwise roceps=.01;
	Score out = SCORED_FILE;
output out=model_ins pred=yhat; 
run; 

Proc print data =SCORED_FILE (obs=10);
Run;

*********CUMULATIVE LIFT CHART FOR MODEL 4************; 
 proc rank data=model_ins out=training_scores descending groups=10; 
var yhat; 
ranks score_decile;  

run; 
title "Scale Factor for Lift Charts"; 
proc freq data=DATAPREP2; 
tables TARGET_FLAG; 
run; 

proc means data=training_scores sum; 
class score_decile; 
var TARGET_FLAG; 
output out=pm_out sum(TARGET_FLAG)=Y_Sum; 
run; 
proc print data=pm_out; run; 
data lift_chart; 
set pm_out (where=(_type_=1)); 
by _type_; 
Nobs=_freq_; 
score_decile = score_decile+1; 
if first._type_ then do; 
cum_obs=Nobs; 
model_pred=Y_Sum; 
end; 
else do; 
cum_obs=cum_obs+Nobs; 
model_pred=model_pred+Y_Sum; 
end; 
retain cum_obs model_pred; 
* 2153 represents the number of successes, OR how many Y=1 in original data set; 
* This value will need to be changed with different samples; 
pred_rate=model_pred/2153; 
base_rate=score_decile*0.1; 
lift = pred_rate-base_rate; 
drop _freq_ _type_ ; 
run; 
proc print data=lift_chart; run; 
ods graphics on; 
axis1 label=(angle=90 '% Captured from Target Population'); 
axis2 label=('Total Population'); 
legend1 label=(color=black height=1 '') 
value=(color=black height=1 'Model #4' 'Random Guess'); 
title 'Model #4: Lift Chart'; 
symbol1 color=blue interpol=join w=2 value=dot height=1; 
symbol2 color=black interpol=join w=2 value=dot height=1;  

proc gplot data=lift_chart; 
plot pred_rate*base_rate base_rate*base_rate / overlay 
legend=legend1 vaxis=axis1 haxis=axis2; 
run; quit; 
ods graphics off;



*************************
*************************
************************
***TARGET_AMT MODEL;


data Data_Amount;
set Dataprep2;
if TARGET_FLAG > 0;
drop TARGET_FLAG;
run;


data Data_Amount2;
set Data_Amount;
if SEX = "M" then MALE_YES=1;
else MALE_YES=0;
if PARENT1= "Yes" then PARENT_YES=1;
else PARENT_YES=0;
if MSTATUS= "z_No" then MARRIED_NO=1;
else MARRIED_NO=0;
if URBANICITY= "Highly Urban/ Urban" then URBAN_YES=1;
else URBAN_YES=0;
if REVOKED= "Yes" then REVOKED_YES=1;
else REVOKED_YES=0;
if RED_CAR= "yes" then RED_CAR_YES=1;
else RED_CAR_YES=0;
if CAR_USE= "Commercial" then USE_COMMERCIAL=1;
else USE_COMMERCIAL=0;
run; 

ods graphics on;
proc reg data=Data_Amount2
outest=outfile AIC BIC SBC CP ADJRSQ
plots = diagnostics(stats=(default aic sbc CP ADJRSQ));

model TARGET_AMT =
					M_INCOME
			M_HOME_VAL
			M_YOJ
			M_CAR_AGE
			M_AGE
			CAP_CAR_AGE
			NEWCAR
			CAP_AGE
			RENTER
			No_Income
			CAP_YOJ
			UNEMPLOYED
			LOW_OLDCLAIM
			HIGH_OLDCLAIM
			CAP_TIF
			NEWPOLICY
			CAP_TRAVTIME
			CAP_CLM_FREQ
			NO_CLM_FREQ
			CAP_KIDSDRIV
			No_Kidsdriv
			CAP_HOMEKIDS
			CAP_MVR_PTS
			No_MVR_PTS
			HIGH_MVR_PTS
			ED_HS
			ED_BACHELORS
			ED_LESSHS
			ED_PhD
			ED_MASTERS
			CAR_VAN
			CAR_SPORTS
			CAR_PICKUP
			CAR_SUV
			CAR_MINIVAN
			CAR_PANELTRUCK
			JOB_CLERICAL
			JOB_HOMEMAKER
			JOB_MANAGER
			JOB_PROF
			JOB_STUDENT
			JOB_BCOLLAR
			JOB_DOCTOR
			JOB_LAWYER
			LOG_BLUEBOOK
			LOG_OLDCLAIM
			LOG_INCOME
			LOG_HOME_VAL
			MALE_YES
			PARENT_YES
			MARRIED_NO
			URBAN_YES
			REVOKED_YES
			RED_CAR_YES
			USE_COMMERCIAL

/selection = stepwise ADJRSQ VIF AIC BIC CP SBC MSE;
RUN;
quit;

	  
Title color ='red' 'STEPWISE MODEL';
proc reg data = dataprep2 outest =estsl2;
model TARGET_AMT = 	CAP_INCOME 
		          CAP_AGE 
		          CAP_YOJ 
		          CAP_HOME_VAL 
		          CAP_CAR_AGE  
		          CAP_BLUEBOOK 
		          CAP_OLDCLAIM 
		          CAP_TIF 
		          CAP_TRAVTIME
		          CAP_MVR_PTS 
		          CAP_HOMEKIDS 
		          CAP_KIDSDRIV 
		          CAP_CLM_FREQ 
		          M_INCOME 
			  M_HOME_VAL 
			  M_YOJ 
			  M_CAR_AGE 
			  M_AGE 
			  LOW_OLDCLAIM 
			  HIGH_OLDCLAIM 
			  HIGH_MVR_PTS 
			  RENTER 
			  NEWCAR 
			  NEWPOLICY 
			  UNEMPLOYED  
			  LOG_BLUEBOOK 
			  LOG_OLDCLAIM 
			  LOG_INCOME 
			  LOG_HOME_VAL 
						/selection = stepwise VIF ADJRSQ AIC BIC CP SBC MSE;
run;
quit;	  


	  
Title color ='red' 'forward MODEL';
proc reg data = dataprep2 outest =estsl2;
model TARGET_AMT = 	CAP_INCOME 
		          CAP_AGE 
		          CAP_YOJ 
		          CAP_HOME_VAL 
		          CAP_CAR_AGE  
		          CAP_BLUEBOOK 
		          CAP_OLDCLAIM 
		          CAP_TIF 
		          CAP_TRAVTIME
		          CAP_MVR_PTS 
		          CAP_HOMEKIDS 
		          CAP_KIDSDRIV 
		          CAP_CLM_FREQ 
		          M_INCOME 
			  M_HOME_VAL 
			  M_YOJ 
			  M_CAR_AGE 
			  M_AGE 
			  LOW_OLDCLAIM 
			  HIGH_OLDCLAIM 
			  HIGH_MVR_PTS 
			  RENTER 
			  NEWCAR 
			  NEWPOLICY 
			  UNEMPLOYED  
			  LOG_BLUEBOOK 
			  LOG_OLDCLAIM 
			  LOG_INCOME 
			  LOG_HOME_VAL 
						/selection = forward VIF ADJRSQ AIC BIC CP SBC MSE;
run;
quit;	  

	  
Title color ='red' 'backward MODEL';
proc reg data = dataprep2 outest =estsl2;
model TARGET_AMT = 	CAP_INCOME 
		          CAP_AGE 
		          CAP_YOJ 
		          CAP_HOME_VAL 
		          CAP_CAR_AGE  
		          CAP_BLUEBOOK 
		          CAP_OLDCLAIM 
		          CAP_TIF 
		          CAP_TRAVTIME
		          CAP_MVR_PTS 
		          CAP_HOMEKIDS 
		          CAP_KIDSDRIV 
		          CAP_CLM_FREQ 
		          M_INCOME 
			  M_HOME_VAL 
			  M_YOJ 
			  M_CAR_AGE 
			  M_AGE 
			  LOW_OLDCLAIM 
			  HIGH_OLDCLAIM 
			  HIGH_MVR_PTS 
			  RENTER 
			  NEWCAR 
			  NEWPOLICY 
			  UNEMPLOYED  
			  LOG_BLUEBOOK 
			  LOG_OLDCLAIM 
			  LOG_INCOME 
			  LOG_HOME_VAL 
						/selection = backward VIF ADJRSQ AIC BIC CP SBC MSE;
run;
quit;	


*****EXPERIMENTAL MODEL;
*****SECOND MODEL WITH LOGS and dummy variables;
Proc logistic data = dataprep2 Plot(only)=(roc(ID=prob));
Class CAR_USE
	MSTATUS
	PARENT1
	RED_CAR
	REVOKED
	SEX
	URBANICITY 
PARENT1 / param=ref;
Model TARGET_FLAG (ref="0")=
		M_INCOME
					M_HOME_VAL
					M_YOJ
					M_CAR_AGE
					M_AGE
					CAP_CAR_AGE
					NEWCAR
					CAP_AGE
					RENTER
					UNEMPLOYED
					CAP_YOJ
					LOW_OLDCLAIM
					HIGH_OLDCLAIM
					CAP_TIF
					NEWPOLICY
					CAP_TRAVTIME
					CAP_CLM_FREQ
					NO_CLM_FREQ
					CAP_KIDSDRIV
					CAP_HOMEKIDS
					CAP_MVR_PTS
					HIGH_MVR_PTS
					CAR_USE
					MSTATUS
					PARENT1
					RED_CAR
					REVOKED
					SEX
					URBANICITY
					ED_HS
			ED_BACHELORS
			ED_LESSHS
			ED_PhD
			ED_MASTERS
			CAR_VAN
			CAR_SPORTS
			CAR_PICKUP
			CAR_SUV
			CAR_MINIVAN
			CAR_PANELTRUCK
			JOB_CLERICAL
			JOB_HOMEMAKER
			JOB_MANAGER
			JOB_PROF
			JOB_STUDENT
			JOB_BCOLLAR
			JOB_DOCTOR
			JOB_LAWYER
					LOG_BLUEBOOK
					LOG_OLDCLAIM
					LOG_INCOME
					LOG_HOME_VAL
					/selection=stepwise roceps=.01;
	Score out = SCORED_FILE;
output out=model_ins pred=yhat; 
run; 

data TEMPFILE6; set SCORED_FILE;
keep index;
Keep TARGET_FLAG;
Keep P_0;
KEEP P_1;
KEEP I_TARGET_FLAG;
run;

Proc print data = TEMPFILE6 (obs=100);
RUN;


**************************************
**************************************
*************************************
********DEPLOYFILE;
data DEPLOYFILE; set &INFILE.;
IMP_INCOME= INCOME; 
M_INCOME= 0; 
if missing(IMP_INCOME) then do; 
if EDUCATION = "PhD" AND HOME_VAL >= 326553.63 then IMP_INCOME = 177308.52; 
else if EDUCATION = "PhD" AND HOME_VAL < 326553.63 then IMP_INCOME = 96235.61;
else if EDUCATION = "PhD" then IMP_INCOME = 101397.83;
else if EDUCATION = "Masters" AND HOME_VAL >= 326553.63 AND HOME_VAL <= 885282.35 then IMP_INCOME = 140114.65; 
else if EDUCATION = "Masters" AND HOME_VAL >= 270550.08 AND HOME_VAL < 326553.63 then IMP_INCOME = 101639.9;
else if EDUCATION = "Masters" AND HOME_VAL >= 235004.06 AND HOME_VAL < 270550.08 then IMP_INCOME = 79968.36;
else if EDUCATION = "Masters" AND HOME_VAL >= 207946.18 AND HOME_VAL < 235004.06 then IMP_INCOME = 68545.97; 
else if EDUCATION = "Masters" AND HOME_VAL >= 180795.40 AND HOME_VAL < 207946.18 then IMP_INCOME = 55896.43;
else if EDUCATION = "Masters" AND HOME_VAL < 180795.40 then IMP_INCOME = 28221.46;
else if EDUCATION = "Masters" then IMP_INCOME = 50223.42;
else if EDUCATION = "Bachelors" AND HOME_VAL >= 326553.63 AND HOME_VAL <= 885282.35 then IMP_INCOME = 133301.79; 
else if EDUCATION = "Bachelors" AND HOME_VAL >= 270550.08 AND HOME_VAL < 326553.63 then IMP_INCOME = 96985.21; 
else if EDUCATION = "Bachelors" AND HOME_VAL >= 235004.06 AND HOME_VAL < 270550.08 then IMP_INCOME = 78287.80;
else if EDUCATION = "Bachelors" AND HOME_VAL >= 207946.18 AND HOME_VAL < 235004.06 then IMP_INCOME = 64362.45;
else if EDUCATION = "Bachelors" AND HOME_VAL >= 180795.40 AND HOME_VAL < 207946.18 then IMP_INCOME = 54390.16;
else if EDUCATION = "Bachelors" AND HOME_VAL < 180795.40 then IMP_INCOME = 39426.33; 
else if EDUCATION = "Bachelors" then IMP_INCOME = 121206.19;
else if EDUCATION = "z_High School" AND JOB = "Home Maker" OR JOB = "Student" then IMP_INCOME= 6925.83;
else if EDUCATION = "z_High School" AND JOB = "Clerical" then IMP_INCOME= 35040.30;
else if EDUCATION = "z_High School" AND JOB = "z_Blue Collar" then IMP_INCOME= 54999.84;
else if EDUCATION = "z_High School" AND JOB = "Manager" OR JOB = "Professional" then IMP_INCOME= 59367.99;
else if EDUCATION = "<High School" AND JOB = "Home Maker" OR JOB = "Student" then IMP_INCOME= 4673.49;
else if EDUCATION = "<High School" AND JOB = "Clerical" then IMP_INCOME= 25692.74;
else if EDUCATION = "z_High School" AND JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar" then IMP_INCOME= 40763.97;

M_INCOME= 1; 
end; 


IMP_HOME_VAL= HOME_VAL; 
M_HOME_VAL= 0; 
if missing(IMP_HOME_VAL) then do; 
if MSTATUS = "Yes" AND INCOME >= 118276.78 then IMP_HOME_VAL = 409444.61;  
else if MSTATUS = "Yes" AND 91518.63 <= INCOME < 118276.78 then IMP_HOME_VAL = 297864.71;
else if MSTATUS = "Yes" AND  73376.11<= INCOME < 91518.63  then IMP_HOME_VAL = 252733.84;
else if MSTATUS = "Yes" AND 60413.30 <= INCOME < 73376.11 then IMP_HOME_VAL = 225903.42;
else if MSTATUS = "Yes" AND 48407.17<= INCOME < 60413.30 then IMP_HOME_VAL = 198898.38;
else if MSTATUS = "Yes" AND 36621.89 <= INCOME < 48407.17 then IMP_HOME_VAL = 171134.11;
else if MSTATUS = "Yes" AND 24789.25<= INCOME < 36621.89 then IMP_HOME_VAL = 150959.82;
else if MSTATUS = "Yes" AND 6847.71 <= INCOME < 24789.25 then IMP_HOME_VAL = 102797.70;
else if MSTATUS = "Yes" AND 0 <= INCOME < 6847.71 then IMP_HOME_VAL = 50642.48;
else if MSTATUS = "Yes" then IMP_HOME_VAL = 184819.82;
ELSE if MSTATUS = "z_No" AND INCOME >= 118276.78 then IMP_HOME_VAL = 367030.26;  
else if MSTATUS = "z_No" AND 91518.63 <= INCOME < 118276.78 then IMP_HOME_VAL = 123596.22;
else if MSTATUS = "z_No" AND 3376.11 <= INCOME < 91518.63 then IMP_HOME_VAL = 101809.80;
else if MSTATUS = "z_No" AND 36621.89 <= INCOME < 73376.11 then IMP_HOME_VAL = 77637.46;
else if MSTATUS = "z_No" AND 24789.25 <= INCOME < 36621.89 then IMP_HOME_VAL = 54103.42;
else if MSTATUS = "z_No" AND 6847.71 <= INCOME < 24789.25 then IMP_HOME_VAL = 43495.97;
else if MSTATUS = "z_No" AND 0 <= INCOME < 6847.71 Then IMP_HOME_VAL = 20314.13;
else if MSTATUS = "z_No" then IMP_HOME_VAL = 77637.46;
M_HOME_VAL= 1; 
end; 


IMP_YOJ= YOJ; 
M_YOJ= 0; 
if missing(IMP_YOJ) then do; 
if JOB = "Home Maker" AND INCOME>= 6929.74 THEN IMP_YOJ = 11;
else if JOB = "Student" AND INCOME>= 6929.74 THEN IMP_YOJ = 11;
ELSE IF JOB = "Home Maker" THEN IMP_YOJ = 4;
ELSE IF JOB = "Student" THEN IMP_YOJ = 4;
ELSE if JOB = "Clerical" OR JOB = "Doctor" OR JOB = "Lawyer" OR JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar" AND HOMEKIDS >= 4 THEN IMP_YOJ = 14;
ELSE if JOB = "Clerical" OR JOB = "Doctor" OR JOB = "Lawyer" OR JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar"  AND HOMEKIDS = 3 THEN IMP_YOJ = 13;
ELSE if JOB = "Clerical" OR JOB = "Doctor" OR JOB = "Lawyer" OR JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar"  AND HOMEKIDS = 2 THEN IMP_YOJ = 12;
ELSE if JOB = "Clerical" OR JOB = "Doctor" OR JOB = "Lawyer" OR JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar"  AND HOMEKIDS <=2 THEN IMP_YOJ = 11;
ELSE if JOB = "Clerical" OR JOB = "Doctor" OR JOB = "Lawyer" OR JOB = "Manager" OR JOB = "Professional" OR JOB = "z_Blue Collar"  THEN IMP_YOJ = 13;
else IMP_YOJ = 11;
M_YOJ= 1; 
end; 

IMP_CAR_AGE= ABS(CAR_AGE); 
M_CAR_AGE= 0; 
if missing(IMP_CAR_AGE) then do; 
if EDUCATION = "PhD" then IMP_CAR_AGE = 14;
else if EDUCATION = "Masters" then IMP_CAR_AGE = 14; 
else if EDUCATION = "Bachelors" then IMP_CAR_AGE = 9; 
else if EDUCATION = "z_High School" then IMP_CAR_AGE= 5;
ELSE IF EDUCATION = "<High School" THEN IMP_CAR_AGE = 4; 
M_CAR_AGE= 1; 
end; 

IMP_AGE= AGE; 
M_AGE= 0; 
if missing(IMP_AGE) then do; 
if HOMEKIDS >= 4 then IMP_AGE = 35;
else if HOMEKIDS = 3 THEN IMP_AGE = 39;
Else if HOMEKIDS = 2 THEN IMP_AGE = 40;
Else if HOMEKIDS = 1 THEN IMP_AGE = 38;
Else if HOMEKIDS = 0 THEN IMP_AGE = 48; 
M_AGE= 1; 
end; 


IMP_Job= Job;
if missing(IMP_Job) then do; 
if EDUCATION = "PhD" then IMP_Job = "Doctor";
else if EDUCATION = "Masters" then IMP_Job = "Lawyer"; 
else if EDUCATION = "z_High School"  AND 36634.90 <= INCOME THEN IMP_Job = "z_Blue Collar";
else if EDUCATION = "z_High School"  AND 6842.82 <= INCOME THEN IMP_Job = "Clerical";
else if EDUCATION = "z_High School"  AND 0 <= INCOME THEN IMP_Job = "Home Maker";
else if EDUCATION = "z_High School"  THEN IMP_Job = "z_Blue Collar";
else IF EDUCATION = "Bachelors" AND 36634.90 <= INCOME THEN IMP_Job = "Professional";
else IF EDUCATION = "Bachelors" AND 24671.59 <= INCOME THEN IMP_Job = "Clerical"; 
else IF EDUCATION = "Bachelors" AND 6842.82 <= INCOME THEN IMP_Job = "Student"; 
else IF EDUCATION = "Bachelors" AND 0 <= INCOME THEN IMP_Job = "Home Maker";
else IF EDUCATION = "Bachelors" THEN IMP_Job = "Professional"; 
else IF EDUCATION = "<High School" AND 36634.90 <= INCOME THEN IMP_Job = "z_Blue Collar"; 
else IF EDUCATION = "<High School" AND 6842.82 <= INCOME THEN IMP_Job = "Clerical";
else IF EDUCATION = "<High School" THEN IMP_Job = "Student";  
end; 


** CAP OUTLIERS;
CAP_CAR_AGE = IMP_CAR_AGE;
	if  IMP_CAR_AGE<1.00 then CAP_CAR_AGE = 1;
	if IMP_CAR_AGE >23 then CAP_CAR_AGE = 23;
IF CAP_CAR_AGE <= 1 then NEWCAR = 1;
else NEWCAR=0;

CAP_BLUEBOOK= BLUEBOOK; 
if missing(CAP_BLUEBOOK) then do; 
CAP_BLUEBOOK = 13600; 
end; 
	IF BLUEBOOK<1500 THEN CAP_BLUEBOOK = 1500;
	IF BLUEBOOK> 40900 THEN CAP_BLUEBOOK = 40900;
	
CAP_AGE = IMP_AGE;
	IF IMP_AGE<16 THEN CAP_AGE = 16;
	IF IMP_AGE>66 THEN CAP_AGE = 66;
	
CAP_HOME_VAL = IMP_HOME_VAL;
	IF IMP_HOME_VAL<0 THEN CAP_HOME_VAL = 0;
	IF IMP_HOME_VAL>531301.2 THEN CAP_HOME_VAL = 531301.2;

if CAP_HOME_VAL = 0 then RENTER = 1; 
else RENTER = 0; 
	
CAP_INCOME = IMP_INCOME;
	IF IMP_INCOME<0 THEN CAP_INCOME = 0;
	IF IMP_INCOME>228376.1 THEN CAP_INCOME = 228376.1;


if CAP_INCOME = 0 then No_Income = 1; 
else No_Income = 0; 

	
CAP_YOJ = IMP_YOJ;
	IF IMP_YOJ<0 THEN CAP_YOJ = 0;
	IF IMP_YOJ>18 THEN CAP_YOJ =18;

if CAP_YOJ <= 0 then UNEMPLOYED= 1; 
else UNEMPLOYED = 0;

CAP_OLDCLAIM= OLDCLAIM; 
if missing(CAP_OLDCLAIM) then do; 
if CLM_FREQ > 0 then CAP_OLDCLAIM = 2448; 
else CAP_OLDCLAIM= 0; 
end;
CAP_OLDCLAIM = OLDCLAIM;
	IF OLDCLAIM<0 THEN CAP_OLDCLAIM =0;
	IF OLDCLAIM>46600 THEN CAP_OLDCLAIM=46600;
 
if 0<CAP_OLDCLAIM < 2400 then LOW_OLDCLAIM = 1; 
else LOW_OLDCLAIM = 0; 
if CAP_OLDCLAIM > 8300 then HIGH_OLDCLAIM = 1; 
else HIGH_OLDCLAIM = 0; 




CAP_TIF = TIF;
if missing(CAP_TIF) then do;
CAP_TIF =5;
end;
	IF TIF<1 THEN CAP_TIF =1;
	IF TIF>18 THEN CAP_TIF =18;
if CAP_TIF <= 1 then NEWPOLICY = 1; 
else NEWPOLICY = 0;


CAP_TRAVTIME= TRAVTIME; 
if missing(CAP_TRAVTIME) then do; 
CAP_TRAVTIME = 33; 
end; 
	IF TRAVTIME<5 THEN CAP_TRAVTIME = 5;
	IF TRAVTIME>81 THEN CAP_TRAVTIME = 81;

CAP_CLM_FREQ= CLM_FREQ; 
if missing(CAP_CLM_FREQ) then do; 
if CAP_OLDCLAIM > 0 then CAP_CLM_FREQ = 1; 
else CAP_CLM_FREQ= 0; 
end; 
if CAP_CLM_FREQ = 0 then NO_CLM_FREQ = 1; 
else NO_CLM_FREQ = 0; 
if CAP_CLM_FREQ > 4 then CAP_CLM_FREQ = 4; 
 


CAP_KIDSDRIV= KIDSDRIV; 
if missing(CAP_KIDSDRIV) then do; 
CAP_KIDSDRIV = 0; 
end; 
if CAP_KIDSDRIV > 2 then CAP_KIDSDRIV = 2; 

if CAP_KIDSDRIV = 0 then No_Kidsdriv = 1; 
else No_Kidsdriv = 0; 


CAP_HOMEKIDS= HOMEKIDS; 
if missing(CAP_HOMEKIDS) then do; 
CAP_HOMEKIDS = 0; 
end; 
if CAP_HOMEKIDS > 4 then CAP_HOMEKIDS = 4; 

CAP_MVR_PTS= MVR_PTS; 
if missing(CAP_MVR_PTS) then do; 
if CAP_CLM_FREQ < 2 then CAP_MVR_PTS = 1; 
else if CAP_CLM_FREQ > 1 then CAP_MVR_PTS = 2; 
else CAP_MVR_PTS= 1; 
end; 

if CAP_MVR_PTS = 0 then No_MVR_PTS = 1; 
else No_MVR_PTS = 0; 


if CAP_MVR_PTS > 2 then HIGH_MVR_PTS = 1; 
else HIGH_MVR_PTS = 0; 
if CAP_MVR_PTS > 7 then CAP_MVR_PTS = 7; 

****CATEGORICAL DUMMY VARIABLES;
if (EDUCATION= "z_High School") then ED_HS=1; else ED_HS=0; 
if (EDUCATION= "Bachelors") then ED_BACHELORS=1; else ED_BACHELORS=0; 
if (EDUCATION= "<High School") then ED_LESSHS=1; else ED_LESSHS=0; 
if (EDUCATION= "PhD") then ED_PhD=1; else ED_PhD=0; 
if (EDUCATION= "Masters") then ED_MASTERS=1; else ED_MASTERS=0; 


if (CAR_TYPE= "Van") then CAR_VAN=1; else CAR_VAN=0; 
if (CAR_TYPE= "Sports Car") then CAR_SPORTS=1; else CAR_SPORTS=0; 
if (CAR_TYPE= "Pickup") then CAR_PICKUP=1; else CAR_PICKUP=0; 
if (CAR_TYPE= "z_SUV") then CAR_SUV=1; else CAR_SUV=0; 
if (CAR_TYPE= "Minivan") then CAR_MINIVAN=1; else CAR_MINIVAN=0;
if (CAR_TYPE= "Van") then CAR_VAN=1; else CAR_VAN=0;
 if (CAR_TYPE= "Panel Truck") then CAR_PANELTRUCK=1; else CAR_PANELTRUCK=0;


if (IMP_JOB= "Clerical") then JOB_CLERICAL=1; else JOB_CLERICAL=0; 
if (IMP_JOB= "Home Maker") then JOB_HOMEMAKER=1; else JOB_HOMEMAKER=0; 
if (IMP_JOB= "Manager") then JOB_MANAGER=1; else JOB_MANAGER=0; 
if (IMP_JOB= "Professional") then JOB_PROF=1; else JOB_PROF=0; 
if (IMP_JOB= "Student") then JOB_STUDENT=1; else JOB_STUDENT=0; 
if (IMP_JOB= "z_Blue Collar") then JOB_BCOLLAR=1; else JOB_BCOLLAR=0; 
if (IMP_JOB= "Doctor") then JOB_DOCTOR=1; else JOB_DOCTOR=0;
if (IMP_JOB= "Lawyer") then JOB_LAWYER=1; else JOB_LAWYER=0;


LOG_TARGET_AMT = sign(TARGET_AMT)*log10(abs(TARGET_AMT)+1); 
LOG_BLUEBOOK = sign(CAP_BLUEBOOK)*log10(abs(CAP_BLUEBOOK)+1); 
LOG_OLDCLAIM = sign(CAP_OLDCLAIM)*log10(abs(CAP_OLDCLAIM)+1); 
LOG_INCOME = sign(CAP_INCOME)*log10(abs(CAP_INCOME)+1); 
LOG_HOME_VAL = sign(CAP_HOME_VAL)*log10(abs(CAP_HOME_VAL)+1);

drop BLUEBOOK
	OLDCLAIM
	TIF
	TRAVTIME
	JOB
	MVR_PTS
	HOMEKIDS
	KIDSDRIV
	CLM_FREQ
	AGE
	YOJ
	INCOME
	HOME_VAL
	CAR_AGE;

LABEL   CAP_INCOME  ="Income"
          CAP_AGE  ="Age"
          CAP_YOJ  ="Years on Job"
          CAP_HOME_VAL  ="Home Value"
          CAP_CAR_AGE  ="Age of car"
          CAP_BLUEBOOK = "Bluebook"
          CAP_OLDCLAIM = "Total Claims(Past 5 Years)"
          CAP_TIF = "Time in Force"
          CAP_TRAVTIME = "Distance to Work"
          CAP_MVR_PTS = "Motor Vehicle Records Points"
          CAP_HOMEKIDS = "Number of Kids At Home"
          CAP_KIDSDRIV = "Number of Kids Driving"   
          CAP_CLM_FREQ = "Number of Previous Claims"
          M_INCOME = "Flag for Missing Income"
	  M_HOME_VAL = "FLag for missing Home Values"
	  M_YOJ = "Flag for missing years on job"
	  M_CAR_AGE = "Flag for missing age of car"
	  M_AGE = "Flag for missing age"
	  LOW_OLDCLAIM = "Old Claims Under $2400"
	  HIGH_OLDCLAIM = "Old Claims More than $8300"
	  HIGH_MVR_PTS = "More than 7 MVR Points"
	  RENTER = "Rents a Home"
	  NEWCAR = "Car 1 year old or less"
	  NEWPOLICY = "Policy 1 year old or less"
	  UNEMPLOYED = "Income = $0"
	  UNEMPLOYED = "YOJ =0"
	  LOG_TARGET_AMT = "Log Value of Target Amount"
	  LOG_BLUEBOOK = "Log Value of Bluebook"
	  LOG_OLDCLAIM = "Log Value of OldClaim" 
	  LOG_INCOME = "Log Value of Income" 
	  LOG_HOME_VAL = "Log Value of Home Value";

YHAT =  6.3559
	+ (CAR_USE in ("Commercial")) * .6646
	+ (MSTATUS in ("Yes")) * -0.4310
	+ (PARENT1 in ("No")) * -0.4361
	+ (REVOKED in ("No")) * -0.9040
	+ (URBANICITY In ("Highly Urban/ Urban")) * 2.3739
	+ RENTER * -2.5501
	+ LOW_OLDCLAIM * -0.3212
	+ CAP_TIF * -0.0542
	+ CAP_TRAVTIME * 0.0152
	+ NO_CLM_FREQ * -2.5716
	+ CAP_KIDSDRIV * 0.4654
	+ CAP_MVR_PTS * 0.0975
	+ ED_HS * 0.3977
	+ ED_LESSHS * 0.3347
	+ CAR_SPORTS * 0.2721
	+ CAR_MINIVAN * -0.6690
	+ JOB_CLERICAL * 0.3722
	+ JOB_MANAGER * -0.6745
	+ JOB_BCOLLAR * 0.2926
	+ JOB_DOCTOR * -0.4363
	+ LOG_BLUEBOOK * -0.7714
	+ LOG_OLDCLAIM * -0.5499
	+ LOG_INCOME * -0.1365
	+ LOG_HOME_VAL * -0.5501
	;

IF YHAT > 99 THEN YHAT = 99;
IF YHAT < -99 THEN YHAT = -99;

P_TARGET_FLAG = EXP(YHAT)/(1+EXP(YHAT));



P_TARGET_AMT = -8651.80787
		+ CAP_MVR_PTS * 141.39602  
		+ JOB_MANAGER * -1125.30999
		+ LOG_BLUEBOOK * 3205.59227
		+ LOG_HOME_VAL * 133.53393
		+ MALE_YES * 645.29063
		+ MARRIED_NO * 917.68553
		+ REVOKED_YES* -709.20586
;

***PUT IN LOGIC TO HAVE SANE ANSWERS based on above info;

if P_TARGET_AMT <1 then P_TARGET_AMT = 1;
if P_TARGET_AMT >100000 then P_TARGET_AMT = 100000;



PURE_PREMIUM = P_TARGET_FLAG * P_TARGET_AMT;

LABEL   PURE_PREMIUM ="P_TARGET_AMT";

** Limit the values;
keep index;
keep P_TARGET_FLAG;
keep PURE_PREMIUM;

RUN;



Proc print data = deployfile (OBS=10);
run; 





*****PROC GENMOD;

data dataprep3;
set dataprep2;
if SEX = "M" then MALE_YES=1;
else MALE_YES=0;
if PARENT1= "No" then PARENT_NO=1;
else PARENT_NO=0;
if MSTATUS= "Yes" then MARRIED_YES=1;
else MARRIED_YES=0;
if URBANICITY= "Highly Urban/ Urban" then URBAN_YES=1;
else URBAN_YES=0;
if REVOKED= "z_No" then REVOKED_NO=1;
else REVOKED_NO=0;
if RED_CAR= "yes" then RED_CAR_YES=1;
else RED_CAR_YES=0;
if CAR_USE= "Commercial" then USE_COMMERCIAL=1;
else USE_COMMERCIAL=0;
run; 

proc genmod data=dataprep3 descending;
model TARGET_FLAG = 
	USE_COMMERCIAL
	PARENT_NO
	MARRIED_YES
	REVOKED_NO
	URBAN_YES
	RENTER 
	LOW_OLDCLAIM
	CAP_TIF 
	CAP_TRAVTIME
	NO_CLM_FREQ 
	CAP_KIDSDRIV 
	CAP_MVR_PTS
	ED_HS
	ED_LESSHS 
	CAR_SPORTS 
	CAR_MINIVAN 
	JOB_CLERICAL 
	JOB_MANAGER 
	JOB_BCOLLAR 
	JOB_DOCTOR 
	LOG_BLUEBOOK 
	LOG_OLDCLAIM 
	LOG_INCOME 
	LOG_HOME_VAL
	/dist=binomial link=logit;
run;
quit;


