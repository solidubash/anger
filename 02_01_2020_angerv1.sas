libname anger 'C:\Users\solid\Google Drive\courses\PHD_2_Reading Course\data\clean';
ods graphics on / LOESSOBSMAX = 15000 gtitle;


/*SELF-CONCEPT AND THE DEVELOPMENT OF ANGER - ALL YA IN 2008, 2010, 2012

ALL VARIABLES FROM WAVES 2004 - 2012

HIGHEST GRADE OF SCHOOL COMPLETED
NUMBER OF HOUSEHOLD MEMBERS IN HH OF R
OFFICIAL MARITAL STATUS
COHABITATION STATUS OF R
WORK STATUS AT DATE OF INTERVIEW - CONSTRUCTED

RACE
GENDER
AGE - used for time in the curve (accelerated cohort design?)

ANGER IS A COUNT OF DAYS IN LAST WEEK. 
exploratory visualizations then 
POISSON OR NEGBIN regressions after dispersion check 

needs weights 
*/


data anger.first;
set anger.v2;

/*r id*/
rcaseid = C0000100;

/*gender*/
IF C0005400 =2 THEN female =1; ELSE female =0;

/*label C0005700 = "DATE OF BIRTH OF CHILD - YEAR"; */
r_birthy = C0005700;

array aage (3) age_08 age_10 age_12;

do i=1 to 3;
aage(i) = 2006+(i*2) - r_birthy; /*age at first wave constructed for visualizations*/
end;

/*race*/
race = C0005300;

/*coded from mother's ethic group from scr*/
if C0005300 = 1 then hisp = 1; else if C0005300 =. then hisp =.; else hisp =0;
if C0005300 =2 then black =1; else if C0005300 =. then black =.; else black =0;

/*focal dependent var. 3 waves: 08,10,12

Y2235800	# DAYS IN PAST WEEK R FELT ANNOYED OR FRUSTRATED 2008
Y2235900	# DAYS IN PAST WEEK R FELT ANGRY 2008
Y2236000	# DAYS IN PAST WEEK R FELT VERY CRITICAL OF OTHERS 2008
Y2236100	# DAYS IN PAST WEEK R YELLED AT SOMEONE OR SMTHG 2008
Y2236200	# DAYS IN PAST WEEK R FELT RAGE 2008
Y2236300	# DAYS IN PAST WEEK R LOST TEMPER 2008
*/
/*counting waves of data -N counts number of non-missing */

anger_valid_08 = N(Y2235800 , Y2235900 , Y2236000 , Y2236100 , Y2236200 , Y2236300);
anger_valid_10 = N(Y2587800 , Y2587900 , Y2588000 , Y2588100 , Y2588200 , Y2588300);
anger_valid_12 = N(Y2935800 , Y2935900 , Y2936000 , Y2936100 , Y2936200 , Y2936300);

/*different measures for visualizations*/
anger_08 =(Y2235800 + Y2235900 + Y2236000 + Y2236100 + Y2236200 + Y2236300);
anger_10 =(Y2587800 + Y2587900 + Y2588000 + Y2588100 + Y2588200 + Y2588300);
anger_12 =(Y2935800 + Y2935900 + Y2936000 + Y2936100 + Y2936200 + Y2936300);

anger_08_wkavg	=(Y2235800	+	Y2235900	+	Y2236000	+	Y2236100	+	Y2236200	+	Y2236300)/6;
anger_10_wkavg	=(Y2587800	+	Y2587900	+	Y2588000	+	Y2588100	+	Y2588200	+	Y2588300)/6;												
anger_12_wkavg	=(Y2935800	+	Y2935900	+	Y2936000	+	Y2936100	+	Y2936200	+	Y2936300)/6;

anger_perday_08 =(Y2235800 + Y2235900 + Y2236000 + Y2236100 + Y2236200 + Y2236300)/7;
anger_perday_10 =(Y2587800 + Y2587900 + Y2588000 + Y2588100 + Y2588200 + Y2588300)/7;
anger_perday_12 =(Y2935800 + Y2935900 + Y2936000 + Y2936100 + Y2936200 + Y2936300)/7;

/*indep var : self concepts section*/
/*esteem and mastery items reversed scores as appropriate per nlsy doc.

THESE ARE LESS 7 TO MAKE THE INTECEPT THE LOWEST POSSIBLE LEVEL OF SELF-CONCEPT
*/
/*04 - staggered, so next wave is those not interviewed in this wave*/
mastery_04 = ( (5- Y1645800 ) + (5- Y1645900 ) + (5- Y1646000 ) + ( Y1646100 ) + (5- Y1646200 ) + ( Y1646300 ) + (5- Y1646400 )) -7 ;
esteem_04 = ( Y1646500) + (  Y1646600) + ( 4- Y1646700) + (  Y1646800) + ( 4- Y1646900) + (  Y1647000) + (  Y1647100) + ( 4- Y1647200) + ( 4- Y1647300) + ( 4- Y1647400);

/*06*/

mastery_06 = ( (5- Y1917600 ) + (5- Y1917700 ) + (5- Y1917800 ) + ( Y1917900 ) + (5- Y1918000 ) + ( Y1918100 ) + (5- Y1918200 )  )-7;
esteem_06 = ( Y1918300) + ( Y1918400) + (4- Y1918500) + ( Y1918600) + (4- Y1918700) + ( Y1918800) + ( Y1918900) + (4- Y1919000) + (4- Y1919100) + (4- Y1919200);

/*then dealing with missing*/
mastery_missing_04 = nmiss(Y1645800 , Y1645900 , Y1646000 , Y1646100 , Y1646200 , Y1646300 , Y1646400 );
mastery_missing_06 = nmiss(Y1917600 , Y1917700 , Y1917800 , Y1917900 , Y1918000 , Y1918100 , Y1918200);
*if nmiss(Y1645800 , Y1645900 , Y1646000 , Y1646100 , Y1646200 , Y1646300 , Y1646400 ) >0 then mastery04 =. ;
*if nmiss(Y1917600 , Y1917700 , Y1917800 , Y1917900 , Y1918000 , Y1918100 , Y1918200) >0 then mastery06 =. ;

esteem_missing_06 = nmiss( Y1918300 , Y1918400 , Y1918500 , Y1918600 , Y1918700 , Y1918800 , Y1918900 , Y1919000 , Y1919100 , Y1919200 );
esteem_missing_04 = nmiss( Y1646500 , Y1646600 , Y1646700 , Y1646800 , Y1646900 , Y1647000 , Y1647100 , Y1647200 , Y1647300 , Y1647400 );
*if nmiss ( Y1918300 , Y1918400 , Y1918500 , Y1918600 , Y1918700 , Y1918800 , Y1918900 , Y1919000 , Y1919100 , Y1919200 ) >0 then esteem_06 =99 ;
*if nmiss ( Y1646500 , Y1646600 , Y1646700 , Y1646800 , Y1646900 , Y1647000 , Y1647100 , Y1647200 , Y1647300 , Y1647400 ) >0 then esteem_04 =99 ;


/*staggered nature of sample means that we are cutting sample by using any wave
to test sensitivity of each year /subsample, I also combine these years*/
mastery_waves = N(mastery_04 , mastery_06);
esteem_waves = N(esteem_04 , esteem_06);

mastery = max(mastery_04 , mastery_06); /*not sure if max is best choice - but this concatenates them*/
esteem = max(esteem_04 , esteem_06);
*how does sas handle missing within this expression?;

/*DROP ALL RESPONDENTS WHO DO NOT HAVE ANY MEASURES OF SELF-CONCEPT -  this has to be tested*/
IF MASTERY_WAVES =0 and ESTEEM_WAVES =0 THEN DELETE;

run;

data angerpp;
set anger.first;
/*3 time periods*/
array aanger(3) anger_08 anger_10 anger_12;

/*first wave is 2008*/
do i=1 to 3;
/*temporal variables*/
time = 2006+(i*2);
wave = i;
r_age = 2006+(i*2) - r_birthy;

/*time varying*/
anger = aanger(i);

output;
end;

run;


proc genmod data=anger.first;
model anger_08 =  mastery esteem female hisp black age_08
 / link=log dist = negbin type3  scale=d ;
 output out=vis_08 predicted=p ;
 run;

proc sgplot data=vis_08;
inset (' '=  "Predicted and Observed for Anger (sum symptom day per week) 2008") / position=top;
yaxis label= "predicted anger";
loess x=esteem y=p / name="predicted" nomarkers
legendLabel="predicted anger";
loess x=esteem y=anger_08 / name="observed" nomarkers
legendLabel="observed anger" ;
discretelegend "predicted" "observed";
RUN;



 proc genmod data=anger.first;
model anger_10 =  mastery esteem female hisp black age_10
 / link=log dist = negbin type3  scale=d ;
 output out=vis_10 predicted=p;
 run;

 proc genmod data=anger.first;
model anger_12 =  mastery esteem female hisp black age_12
 / link=log dist = negbin type3  scale=d ;
 output out=vis_12 predicted=p;
  run;
 

/*basic models for each year
proc genmod data=anger.first;
model anger_08 =  mastery esteem female hisp black age_08
 / link=log dist = poisson type3 scale=0;
 run;

 proc genmod data=anger.first;
model anger_10 =  mastery esteem female hisp black age_10
 / link=log dist = poisson type3 scale=0;
 run;

 proc genmod data=anger.first;
model anger_12 =  mastery esteem female hisp black age_12
 / link=log dist = poisson type3 scale=0;
 run;



/*mean and deviation for hybrid effect models for changing depression, educ, mastery, etc - if we decide to do avg days per week etc 
PROC MEANS DATA=angerpp NWAY NOPRINT;
CLASS rcaseid;
VAR  anger ;
OUTPUT OUT=a(drop= _TYPE_ _FREQ_)  MEAN=anger_mean ;
PROC SORT DATA=angerpp;
BY rcaseid;
PROC SORT DATA=a;
BY rcaseid;
DATA combine;
MERGE angerpp a;
BY rcaseid;
anger_dev = anger - anger_mean;
RUN;
*/

/*basic controls
proc glimmix data=angerpp OR NOCLPRINT ;
class rcaseid;
model anger = r_age mastery esteem female hisp black / SOLUTION ddfm=kr dist=poi; 
random intercept / type=un sub=rcaseid ;
output out=overdisp pearson=pearson;
run;
 PROC MEANS DATA =overdisp n mean var;
var pearson; run;


/*direct effects*/
/*variance much higher than mean requires negative binomial regression. 
need to check for 0 inflated 
proc glimmix data=angerpp OR asycov NOCLPRINT ;
class rcaseid;
model anger = r_age mastery esteem/ SOLUTION ddfm=kr dist=nb; ;
random intercept r_age / type=un sub=rcaseid ;
output out=overdisp pearson=pearson;
run;
 PROC MEANS DATA =overdisp n mean var;
var pearson; run;
*/

/*

proc freq data=temp;
tables 
/ plots=freqplot()
;
run;

*//* DESCRIPTIVES 
proc freq data=anger.first;
tables 
age_08 age_10 age_12
anger_08	anger_10	anger_12
anger_valid_08 anger_valid_10 anger_valid_12
anger_08_wkavg anger_10_wkavg anger_12_wkavg
anger_perday_08 anger_perday_10 anger_perday_12
mastery esteem
mastery_waves esteem_waves
mastery_04 mastery_06
esteem_04 esteem_06 
/ plots=freqplot()
;
run;


***************************************************************************************
CODE GRAVEYARD
***************************************************************************************;

/*seems to be stable over time. may run a factor analysis if we decide to go SEM
proc corr data=temp nomiss alpha plots=matrix;
   var anger_08	anger_10	anger_12 ;
run;
*/

/*cronbachs alphas do not work, because there are no overlapping observations due to the stratified nature
of the sample. Due to this, I am uncertain if we should focus on the effects of age, or if we should 
pick one wave and use the subsample - but lose the representative value?
proc corr data=temp  alpha plots=matrix;
   var esteem_04 esteem_06;
run;

proc corr data=temp  alpha plots=matrix;
   var mastery_04 mastery_06;
run;
*/


