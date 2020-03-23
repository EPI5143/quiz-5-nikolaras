/*Quiz 5*/

libname classdat '/folders/myfolders/class_data';
libname ex '/folders/myfolders/epi databases work folder/data';

/*1*/
data ex.nhrabstracts;
set classdat.nhrabstracts;
run;

data ex.newnhrabstracts;
set ex.nhrabstracts;
if year(datepart(hradschdtm)) in (2003,2004);
keep hraEncWID hraAdmDtm
run;

proc sort data = ex.newnhrabstracts nodupkey;
by hraEncWID;
run;


/*2, 3*/

data ex.nhrdiagnosis;
set classdat.nhrdiagnosis;
run;

data ex.nhrdiagnosis1;
set ex.nhrdiagnosis;
by hdghraencwid;
if first.hdghraencwid then do;
DM = 0;count=0;
end;
if hdgcd in :("250", "E11", "E10") then do;
DM = 1;
count = count+1;
end;
if last.hdghraencwid then output;
retain dm count;
run;

/*4*/

data ex.merge;
merge ex.newnhrabstracts (in=a) ex.nhrdiagnosis1 (in=b rename = (hdgHraEncWID = HraEncWid));
by HraEncWid;
if a;
run;

/*5*/

proc freq data = ex.merge;
table dm / missing;
run;