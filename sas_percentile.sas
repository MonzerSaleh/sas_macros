/*==============================================================================*/
/*                                                                              */
/* MACRO:           SAS_PERCENTILE                                              */
/*                                                                              */
/* NOTE:       1.   Create the Percentile Report.                               */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* PARMS:      1.   LIB       =    Specify the input sas library name.          */
/*                                                                              */
/*             2.   DATA      =    Specify the input sas dataset name.          */
/*                                                                              */
/*             3.   CLASS     =    Specify the class variables:                 */
/*                                                                              */
/*                  Default:       TIME EOM DATE                                */
/*                                 and                                          */
/*                                 CUST_TP_CAT_CD ( RT, SB )                    */
/*                                                                              */
/*             4.   VAR       =    Specify the ANALYSIS VARIABLE to be analysed.*/
/*                                                                              */
/*             5.   OUTLIB    =    Specify the output sas library.              */
/*                                                                              */
/*             6.   OUTPFX    =    Specify the output PREFIX OF THE SAS DATASET */
/*                                 Default: PCTILE                              */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* Note:       1.   The output sas dataset is built using the OUTPFX value      */
/*                  and the VAR value.                                          */
/*                                                                              */
/* Example:         OUT       =    &OUTPFX._&VAR.                               */
/*                            =    PCTILE_MYVAR                                 */
/*                                                                              */
/*==============================================================================*/
%macro sas_percentile(
 lib      = APPXDAT,
 data     = CUST_DATA,
 class    = TIME_EOM_DATE CUST_TP_CAT_CD,
 VAR      = CUST_DEP_AMT,
 OUTLIB   = APPXDAT,
 OUTPFX   = PCTILE,
 CHANNEL  = NULL,
 QUERY    = NULL,
 QUESTION = NULL
 ); 


/*==============================================================================*/
/*                                                                              */
/* step 01000  Pass macro parms to the SAS server.                              */
/*                                                                              */
/*==============================================================================*/

%IF       &SYSSCP.       =    WIN      %THEN %DO;

%SYSLPUT  LIB            =    &LIB.;
%SYSLPUT  DATA           =    &DATA.;
%SYSLPUT  CLASS          =    &CLASS.;
%SYSLPUT  VAR            =    &VAR.;
%SYSLPUT  OUTLIB         =    &OUTLIB.;
%SYSLPUT  OUTPFX         =    &OUTPFX.;
%SYSLPUT  CHANNEL        =    &CHANNEL.;
%SYSLPUT  QUERY          =    &QUERY.;
%SYSLPUT  QUESTION       =    &QUESTION.;

%END;


/*==============================================================================*/
/*                                                                              */
/* step 03000  Generate Percentile Report.                                      */
/*                                                                              */
/*==============================================================================*/

PROC UNIVARIATE DATA = &LIB..&DATA.                NOPRINT;

     CLASS     &CLASS.;

     VAR       &VAR.;

     OUTPUT    OUT       = &OUTLIB..&OUTPFX._&VAR.

               pctlpts   = 10 20 30 40 50 60 70 80 90 100
               pctlpre   = pct
               pctlname  = _10 _20 _30 _40 _50 _60 _70 _80 _90 _100;

RUN;

/*==============================================================================*/
/*                                                                              */
/* step 04000  Add the Channel, Query Number, Question to the data.             */
/*                                                                              */
/*==============================================================================*/

DATA &OUTLIB..&OUTPFX._&VAR.;

     SET       &OUTLIB..&OUTPFX._&VAR.;

     %IF       %QUPCASE(&CHANNEL.)      NE   NULL      %THEN %DO;
               CHANNEL                  =    "&CHANNEL.";
     %END;

     %IF       %QUPCASE(&QUERY.)        NE   NULL      %THEN %DO;
               QUERY                    =    "&QUERY.";
     %END;

     %IF       %QUPCASE(&QUESTION.)     NE   NULL      %THEN %DO;
               QUESTION                 =    "&QUESTION.";
     %END; 

RUN;

%MEND; 
/*%sas_percentile(*/
/* lib      = APPXDAT,*/
/* data     = CUST_DATA,*/
/* class    = TIME_EOM_DATE CUST_TP_CAT_CD,*/
/* VAR      = CUST_DEP_AMT,*/
/* OUTLIB   = APPXDAT,*/
/* OUTPFX   = PCTILE,*/
/* CHANNEL  = NULL,*/
/* QUERY    = NULL,*/
/* QUESTION = NULL*/
/* ); run; */
