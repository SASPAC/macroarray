/** Macro Variabel Array **/

/* mva A */
%LET a1 = Macro;
%let a2 = Variables;
%let a3 = Array;

/* mva B */
data _null_;
  length val $ 9;
  do val = "Next", "Macro", "Variables", "Array";
    i+1;
    CALL SYMPUTX(cats("b", i), val);
  end;
run;

/* mva C */
data have;
  input val $9.;
cards;
Proc
SQL
Macro
Variables
Array
;
run;

proc SQL;
  select val
  INTO :c1-
  from have
  ;
quit;

/* preview */
%put _user_;


/* call to mva A */

%macro loop(i);
%do i = 1 %to &i.;
  %put NOTE- &i.) &&a&i;
%end;
%mend loop;

%loop(3)







/* SETUP *//*
----------------------------------------------------------------------
Only the first time:
^^^^^^^^^^^^^^^^^^^^

  filename packages "/path/to/my/packages";

  filename SPFinit url "https://bit.ly/SPFinit";                 *(1);
  %include SPFinit;

  %installPackage(SPFinit macroArray BasePlus)                   *(2);



----------------------------------------------------------------------
On start of fresh SAS session:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  filename packages "/path/to/my/packages";
  %include packages(SPFinit.sas);

  %loadPackageS(macroArray BasePlus)                             *(3);



----------------------------------------------------------------------*/

  
/*footnotes**********************************************************
*(1); Bitly points to:
  https://github.com/yabwon/SAS_PACKAGES/blob/main/SPF/SPFinit.sas

*(2); BasePlus is loaded for this macro:
  %symdelGlobal(quiet);
  resetline;

*(3); symdelGlobal can be just "cherry picked" from BasePlus:
  %loadPackage(BasePlus, cherryPick=symdelGlobal)

*********************************************************************/


/* simple macro array - numeric */
%array(X[6] (101:106))

%put _user_;

data _null_;
  array X[6] (101:106);
  put (_all_) (=/);
run;



/* simple macro array - character */
%array(X[7] $ ("A" "B" "C" "D" "E" "F" "G"))

%put _user_;

data _null_;
  array X[7] $ ("A" "B" "C" "D" "E" "F" "G");
  put (_all_) (=/);
run;




/* vnames=Y option and "character" macro array */

%array(days_A[*] Monday Tuesday Wednesday Saturday, vnames=Y)

%array(days_B[4] $ 20 ("Monday" "Tuesday" "Wednesday" "Saturday"))

%put _user_;




/* vnames = N */
%array(days_A[*] Monday Tuesday Wednesday Saturday)

%put _user_;







/* easy special characters masking */
%array(days_B[4] $ 20 ('&Monday.' '%Tuesday()' "W;e;d;n;e;s;d;a;y;" "S,a,t,u,r,d,a,y"))

%put _user_;









%let Monday=123;

%macro Tuesday();
4567890
%mend Tuesday;

%array(days_D[4] $ 20 ('&Monday' '%Tuesday()' "Wednesday" "Saturday"))

%put _user_;

%put &days_D1. &days_D2. &days_D3. &days_D4.;





/* dates works too */
%array(days_E[4] ('20may2024'd '21may2024'd '22may2024'd '25may2024'd))

%put _user_;






/* function= argument */

/* three constant expressions */
%array(e[1:3] $, function = "A" )

/* first six powers of 2 */
%array(f[0:5], function = (2**_i_) )

/* five random numbers form uniform distribution on (0,1) interval */
%array(g[0:4], function = ranuni(123) )

/* a formated list of twelve months */
%array(h[0:11] $ 11, function = put(intnx("MONTH", '19may2024'd, _i_), yymmd.))

/* Fibonacci sequence, first ten elements */
%array(i[10] (10*0)
        ,function = ifn(_i_ < 2, 1, sum(i[max(_i_-2,1)], i[max(_i_-1,2)]) )
        ,before=put _all_
        ,after=put _all_
)

%put _user_;


/* before= and after= */

%array(j[10]
  ,function = round(rand('Uniform',0,1),0.001)
  ,before = call streaminit(42)
  ,after = call sortn(of j[*]); j[1]=0; j[10]=1; put _all_
)

%put _user_;



/* indexes */
%array(k[5:7] $ ("fifth" "sixth" "seventh"))

%put _user_;


/* negative indexes */
%array(l[-3:3], function = 2**_i_)

%put _user_;


/* why not "_" for negative indexes?

%array(m[-2:-1] (1 2))
%array(m_[1:2] (1 2))

%put _user_;

*/




/* using datasets */

%array(ds=sashelp.class(where=(age=13)), vars=name)

%put _user_;


/* multiple variables */
%array(ds=sashelp.class(where=(age=14)), vars=name height weight)

%put _user_;


/* "Highlander" aka "there can be only one only one" */
data work.class_1 work.class_2;
  set sashelp.class(obs=3);
run;

%array(ds=work.class_:, vars=name) /* !!! */




/* no data set */
%array(ds=NoSuchDataSet, vars=name) /* !!! */

%put _user_;




/* no data */
data work.class;
  stop;
  set sashelp.class;
run;
%array(ds=work.class, vars=name) /* !!! */

%array(ds=sashelp.class(where=(age>20)), vars=name) /* !!! */

%put _user_;



/* no variable */
%array(ds=sashelp.class, vars=x) /* !!! !!! !!! */

%put _user_;






/* unique values only and the pipe operator */
%array(ds=sashelp.class, vars=age|)

%put _user_;




/* alternative names and # operator */
%array(ds=sashelp.class, vars=name#N age|A)

%put _user_;








/* adding quotes */
%array(Letters[6] $ 3, function = byte(rank('A')+_I_-1) , q=2) /* 2 for "double" */

%array(ds=sashelp.class(obs=6), vars=name, q=1) /* 1 for 'single' */

%put _user_;








/* session setting for macro memory */
proc options group = MACRO;
run;

/*

MEXECSIZE  - specifies the maximum macro size that can be executed in memory.
MSYMTABMAX - specifies the maximum amount of memory available to the macro
             variable symbol table or tables.
MVARSIZE   - specifies the maximum size for a macro variable that is stored in memory.

*/



/* looping over macro arrays */



%macro someMacro();
  %array(ARRX[1:3] $ ("first" "second" "third"))

  %do i=1 %to 3;
    %put for &=i. value is &&ARRX&i ;
  %end;
%mend someMacro;

resetline;
%someMacro()

%put _user_;





/* macarray = Y */

%macro someMacro2();
  %array(ARRY[1:3] $ ("first" "second" "third"), macarray=Y)

  %do i=1 %to 3;
    %put for &=i. value is %ARRY(&i) ;
  %end;
%mend someMacro2;

resetline;
%someMacro2()

%put _user_;


%macro someMacro3();
  %array(ds=sashelp.cars, vars=Origin|ARRZ, macarray=Y)

  %do i=&ARRZLBOUND. %to &ARRZHBOUND.;
    %put for &=i. value is %ARRZ(&i) ;
  %end;
%mend someMacro3;

resetline;
%someMacro3()

%put _user_;





/* alternating values */

%array(ABC[3] (1:3), macarray=Y);

%put _user_;

%let %ABC(2,i) = 999999999; /* i for "input mode" */

%put _user_;




/* "filling blanks" */

%let ARR1=1;
%let ARR3=3;
%let ARR5=5;
%let ARRX7=7;

%put _user_;

%array(ARR,macarray=m)

%put _user_;






/* get help on array */
%helpPackage(macroArray, '%array()')













/* deleteMacArray - cleaning after work */

%array(Letters[26] $ 26
, function = repeat(byte(rank("A")+_I_-1),_I_-1)
, macarray=Y
, q=2)
%put _user_;


%macro someMacroX();
  %do i=&LettersLBOUND. %to &LettersHBOUND.;
    %put %Letters(&i.);
  %end;
%mend someMacroX;

%someMacroX()




%deleteMacArray(Letters)

/* %deleteMacArray(Letters, macarray=Y) */
%put _user_;




/* get help on deleteMacArray */
%helpPackage(macroArray, '%deleteMacArray()')
















/* sortMacroArray - reordering values */
%array(n[6] $ 3 ("C33" "B22" "A11" "A1" "A2" "X42"))

%put _user_;

%sortMacroArray(n)

%put _user_;




%array(hij [4:9] $ 512 ("C33" "B22" "A11" "A01" "A02" "X42"), macarray=Y)

%put _user_;

%sortMacroArray(hij, outSet = A_NULL_(compress=char), valLength=3)

%put _user_;




/* get help on sortMacroArray */
%helpPackage(macroArray, '%sortMacroArray()')










/* appendArray and concatArrays - combibining macro arrays */

%array(o[2:4] $ 1 ("A" "B" "C"))

%array(p[3] (1 2 3))

%put _user_;

%appendArray(o, p)

%put _user_;





%array(q[2:4] $ 1 ("E" "F" "G"), macarray=Y)

%array(r[3] (4 5 6), macarray=Y)

%put _user_;

%concatArrays(q, r)

%put _user_;




/* get help on appendArray and concatArrays */
%helpPackage(macroArray, '%concatArrays()')
%helpPackage(macroArray, '%appendArray()')












/* do_over - iterating over array values and more! */

%array(ds=sashelp.class(where=(age=12)), vars=name, q=2, macarray=Y)

%put _user_;









/* loop over NAME - stupid example *//* options mprint; */
%do_over(name)

/*
 "James" 
 "Jane"
 "John"
 "Louise"
 "Robert"
*/




/* loop over NAME - not stupid example */
%put %do_over(name);



/* loop over NAME - practical example */
data test;
  set sashelp.class;
  where name in (%do_over(name));
run;




/* between= operator */
%array(ds=sashelp.class(where=(age=12)), vars=name, macarray=Y) /* no q=*/

%put "%do_over(name, between=|)";

data test;
  set sashelp.class;
  where find("%do_over(name, between=|)", name,"IT");
run;






/*  phrase= operator */

/* Ex.1 */
%array(ds=sashelp.class, vars=age|, macarray=Y)

%put %do_over(age);

options mprint;
data
  %do_over(age, phrase=%nrstr( data_%age(&_i_.) ))
;

  set sashelp.class;

  select(age);
    %do_over(age, phrase=%nrstr(
      /* when ( 15 ) output data_15; */
      when ( %age(&_i_.) ) output data_%age(&_i_.);
    ))
    otherwise put "unknown Age value!";
  end;
run;
options nomprint;




/* Ex.2 */
%macro someMacro4(period);
  title "Running macro for &period.";

  data data_for_&period.;
    put "Running macro for &period.";
    x = &period.;
  run;

  proc print;
  run;

  title;
%mend someMacro4;

%someMacro4(199912)



%array(date[4], function=202400 + _i_, macarray=Y)

%put %do_over(date);

%do_over(date, phrase=%nrstr(
  %someMacro4( %date(&_i_.) )
))





/* Ex.3 */
%array(ds=sashelp.class(obs=6), vars=name age, macarray=Y)

%do_over(name, phrase=%nrstr(
  %put &_i_.. %name(&_i_.) has %age(&_i_.) years.;
))





/* which= operator */

%array(test[*] x01-x06, vnames= Y, macarray=Y)

%put 1) %do_over(test);
%put 2) %do_over(test, which=H:L:-1);



%array(test[*] x0001-x007, vnames= Y, macarray=Y)

%put #%do_over(test)#;
%put #%do_over(test, which= h:l:-1 h:l:-2 h:l:-3)#;


%array(test[*] x01-x99, vnames=Y, macarray=Y)

%put **%do_over(test, which= L:3 97:H, between=**)**;


/* get help on do_over */
%helpPackage(macroArray, '%do_over()')












/* do_over2 and do_over3 - iterating over multiple arrays */

%array(alpha[*] a b c, vnames=Y, macarray=Y)
%array( beta[2] (101 102),   macarray=Y)

%do_over2(beta, alpha, phrase = %NRSTR(
  %put alpha=%alpha(&_j_.), beta=%beta(&_i_) ;
));






resetline;
/*options nofullstimer nostimer;*/
%array(one[3] $ ("A" "B" "C"), macarray=Y)
%array(two[3]   ( 1   2   3 ), macarray=Y)

%macro letsPlay(x,y);
  data &x&y;
    x="&x.";
    y= &y. ;
    put x= y=;
  run;
%mend letsPlay;

%do_over2(one, two
  ,phrase = %NRSTR(
    %letsPlay(%one(&_I_.), %two(&_J_))
  ))




/*options stimer;*/




%array(a[2] (0 1), macarray=Y)

%do_over3(a, a, a
, phrase = %NRSTR(
  %put sum(%a(&_I_.), %a(&_J_), %a(&_K_)) = %sysevalf(%a(&_I_.) + %a(&_J_) + %a(&_K_));
))



/* get help on do_over2 and do_over3 */
%helpPackage(macroArray, '%do_over2()')
%helpPackage(macroArray, '%do_over3()')




/* make_do_over - when three is not enough! */

%make_do_over(2);


%make_do_over(5);


%array(a5_[2] (0 1), macarray=Y)


%do_over5(a5_, a5_, a5_, a5_, a5_
,phrase = %NRSTR(
  %put (%a5_(&_I1_.),%a5_(&_I2_.),%a5_(&_I3_.),%a5_(&_I4_.),%a5_(&_I5_.));
))




/* get help on make_do_over */
%helpPackage(macroArray, '%make_do_over()')



/* zipArrays - zipper for macro arrays */

%array(a[*] $ x1-x3 ("A" "B" "C"))
%array(b[*] x1-x5 (11:15))

%put _user_;

%zipArrays(a, b);

%put _user_;




/* result= and macarray= */
%array(a[6] (1:6))
%array(b[3] (77 88 99))

%zipArrays(a, b, result=A_and_B, macarray=Y);

%put %do_over(A_and_B);

%put %A_and_B(5);




/* operator= */

%array(c[0:4] (000 100 200 300 400))
%array(d[2:16] (1002:1016))

%zipArrays(c, d, operator=+, result=C_plus_D, macarray=Y);

%put %do_over(C_plus_D);

%put %C_plus_D(1);


%zipArrays(c, d, operator=*, result=C_times_D, macarray=Y);

%put %do_over(C_times_D);

%put %C_times_D(1);






/* function= argBf= format= */

%array(one[3] A B C, vnames=Y)
%array(two[5] p q r s t, vnames=Y)

%zipArrays(
 one
,two
,function = catx
,argBf = %str( & )
,format = $quote.
,macarray=Y
)

%put %do_over(onetwo);







/* reuse= */
%array(e[3] (10 20 30))
%array(f[2] (5:6))

%zipArrays(e, f, reuse=n,  operator=+, macarray=Y, result=_noReuse);
%zipArrays(e, f, reuse=y,  operator=+, macarray=Y, result=_yesReuse);
%zipArrays(e, f, reuse=cp, operator=+, macarray=Y, result=_cartProdReuse);

%put %do_over(_noReuse);
%put %do_over(_yesReuse);
%put %do_over(_cartProdReuse);



/* "incompatibility" */
%array(e[3] (10 20 30))
%array(f[2] $ ("A" "B"))

%zipArrays(e, f, reuse=n,  operator=+, macarray=Y, result=_noReuseX);
%zipArrays(e, f, reuse=y,  operator=+, macarray=Y, result=_yesReuseX);
%zipArrays(e, f, reuse=cp, operator=+, macarray=Y, result=_cartProdReuseX);

%put %do_over(_noReuseX);
%put %do_over(_yesReuseX);
%put %do_over(_cartProdReuseX);







/* the same name */
%array(e[5] (10 20 30 40 50))
%array(f[3] (7 8 9))

%put _user_;

%zipArrays(e, f, reuse=y,  operator=+, macarray=Y, result=e);

%put _user_;



/* !!!
options mprint;
%zipArrays(e, f, reuse=y,  operator=+, macarray=Y, result=F);
%put _user_;
*/



%array(a[3] (100 200 300))

%put _user_;

%zipArrays(a, a
, function=SUM
, reuse=CP
, macarray=Y
)

%put %do_over(AA);
















/* macro dictionary */

%mcDictionary(myDict)

resetline;
%myDict(List)

resetline;
%myDict(ADD)

%put _user_;

/* note on "special cases" */
%myDict(ADD)
%myDict(List)
%myDict(ADD,key=,data=ABC)
%myDict(List)
%myDict(ADD,key=_,data=EFG)
%myDict(List)
%myDict(ADD,key=%str( ),data=HIJ)
%myDict(List)
%myDict(ADD,key=%str(  ),data=KLM)
%myDict(List)

%put _user_;



%mcDictionary(myDict)

resetline;
%myDict(ADD,key=A,data=I)
%myDict(A  ,key=B,data=<3)
%myDict(A  ,key=C,data=SAS)
%myDict(L)


resetline;
%put
 A:%myDict(CHECK,key=A)
 B:%myDict(C,key=B)
 C:%myDict(C,key=C)
 D:%myDict(C,key=D) /* ! */
;


resetline;
%put
"%myDict(FIND,key=A)
 %myDict(F,key=B)
 %myDict(F,key=C)
 %myDict(F,key=D)"
;
/*
%myDict(A,key=D,data=9)
*/


resetline;
%myDict(DEL,key=B)
%myDict(L)

%myDict(CLEAR)
%myDict(L)

resetline;
%mcDictionary()
%mcDictionary(_)

%mcDictionary(ABCDEFGHIJKLMNOPQ) %* bad;
%mcDictionary(ABCDEFGHIJKLM)     %* good;


%mcDictionary(ABCDEFGHIJKLM)  %* good;
%ABCDEFGHIJKLM(ADD,key=A,data=I)
%ABCDEFGHIJKLM(A  ,key=B,data=<3)
%ABCDEFGHIJKLM(A  ,key=C,data=SAS)
%ABCDEFGHIJKLM(L)
%put _user_;




/* populating from data set */
data work.have;
  input kVar :$1. @3 dVar $20.;
cards;
A I
B <3
C SAS Institute
C SAS software
C SAS9
;
run;
proc print;
run;

%mcDictionary(myDSdict,DCL,DS=work.have,k=kVar,d=dVar)

%myDSdict(L)








/* small usecase */
data work.metadata;
  infile cards missover;
  input key :$16. data :$128.;
cards;
ID ABC-123-XYZ
path /path/to/study/data
cutoffDT 2023-01-01
startDT 2020-01-01
endDT 2024-12-31
MedDRA v26.0
XXX 123
YYY
ZZZ 789
OBS 13
;
run;
proc print;
run;


%mcDictionary(Study,dcl,DS=work.metadata)

%put _user_;

%Study(L)


/* "size matters" ;-) */
%put *%Study(F,key=ID)**%Study(C,key=ID)*;
%put *%Study(F,key=id)**%Study(C,key=id)*;



title1 "Study %Study(F,key=ID) is located at %Study(F,key=path)";
title2 "it starts %Study(F,key=startDT) and ends %Study(F,key=endDT)";
footnote1 "MedDRA version: %Study(F,key=MedDRA)";
footnote2
%if %Study(C,key=XXX)
  %then %do; "XXX: %Study(F,key=XXX)"; %end;
;

proc print data=sashelp.class(obs=%Study(F,key=OBS));
run;

title;
footnote;













/* lets have a big use case */


/*
%symdelGlobal(quiet);
options mprint nofullstimer stimer;
resetline;
*/

/* project driving data */
/* data set with list of functions to "run over data" */
data work.functions;
input fName $12.;
cards;
sum
mean
median
min
max
nmiss
std
range
stderr
var
;
run;
title "list of functions";
proc print;
run;

/* data set with project metadata */
data work.projectMetadata;
  infile cards dsd dlm=",";
  input key :$16. data :$128.;
cards;
ID,ABC-123-XYZ
TITLE,Use case of the MacroArray package
PATH,/path/to/study/data
INDATASET,sashelp.cars
OUTDATASET,work.results
VARIABLE,invoice
GROUPBY,origin
STARTDT,2020-01-01
ENDDT,2024-12-31
;
run;
title "project metadata";
proc print;
run;

title;



resetline;
/* project code */
/* create macro array FN and macro dictionary PRJ */
%array(ds=work.functions, vars=fName#fN, macarray=Y)
%mcDictionary(prj, DCL, DS=work.projectMetadata)

%put _user_;

title1 "Title: %prj(F,key=TITLE)";
title2 "Project %prj(F,key=ID), located at: %prj(F,key=PATH)";
title3 "starts %prj(F,key=STARTDT) and ends %prj(F,key=ENDDT)";

footnote1 "Input data set: %prj(F,key=INDATASET)";
footnote2 "Output data set: %prj(F,key=OUTDATASET)";
footnote3 "Analyzed variable: %prj(F,key=VARIABLE)";

/* check if the grouping variable exists */
footnote4
  %if %prj(C,key=GROUPBY) %then
    %do; "Analysis in groups by %prj(F,key=GROUPBY)" %end;
;

/*
proc print data=sashelp.vtitle;
run;
*/




/* aggregate data */
options mprint;
Proc SQL feedback;
  create table %prj(F,key=OUTDATASET) as
  select
    /* check if the grouping variable exists */
    %if %prj(C,key=GROUPBY) %then %do; %prj(F,key=GROUPBY), %end;

    /* loop over aggregating functions */
    %do_over(fN
      ,phrase=%NRSTR(
        /* apply function to analysisVariable
           and name the result "analysisVariable_functionName" */
        %fN(&_i_.)(%prj(F,key=VARIABLE)) as %prj(F,key=VARIABLE)_%fN(&_i_.)
        /* e.g., avg(x) as x_avg */
       )
      ,between=%str(,)
      )

  from
    %prj(F,key=INDATASET)

  /* check if the grouping variable exists */
  %if %prj(C,key=GROUPBY) %then
    %do;
      group by
        %prj(F,key=GROUPBY)
    %end;
  ;
Quit;

/* print data */
proc print data = %prj(F,key=OUTDATASET) ;
run;

title;
footnote;

%prj(CLEAR)
%deleteMacArray(fN, macarray=Y)


/* end of project code */















/* since you get up to here, here is a bonus for you */
/*- a bonus - aboiut SAS macro BUG ;-) -*/
%let Monday=123;

%macro Tuesday();
ABC
%mend Tuesday;

%array(days_E[4] $ 20 ('&Monday' '%Tuesday()' "Wednesday" "Saturday"), macArray=Y)
%put _user_;

%put %days_E(1) %days_E(2) %days_E(3) %days_E(4);

data X%days_E(2)Y;
  set sashelp.class;
run;

data X%unquote(%days_E(2))Y;
  set sashelp.class;
run;

data X%days_E(1)Y;
  set sashelp.class;
  if 123=%days_E(1);
  if "123"="%days_E(1)";
run;

%let bug=%days_E(2);
%let bugFix=%days_E(2);

data _null_;
  set sashelp.vmacro;
  where name="BUG";
  put value hex20.;
run;

data X&bugFix.Y;
  set sashelp.class;
run;

data _null_;
  x=resolve('data X%days_E(2)Y;set sashelp.class;run;');
  put x hex100.;
  call execute(x);
run;


