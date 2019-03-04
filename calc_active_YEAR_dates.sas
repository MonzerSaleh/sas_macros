/*==============================================================================*/
/* MACRO:           CALC_ACTIVE_YEAR_DATES                                      */
/* ---------------------------------------------------------------------------- */
/* NOTE:       1.   Accepts an input sas date and converts the date into        */
/*                  the following 90 formatted dates:                           */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* SYNTAX:     1.   %CALC_ACTIVE_YEAR_DATES(                                    */
/*                   DATE     = <SAS DATE NUMBER> OR <SAS DATE LITERAL>         */
/*                   PERIODS  = <SPECIFY NO OF MONTHLY PERIODS>                 */
/*                   ); RUN;                                                    */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* PARMS:      1.   DATE      = SPECIFY THE ENDING PERIODS DATE.                */
/*                                                                              */
/*             2.   PERIODS   = SPECIFY THE NOMBER OF PERIODS TO BE CREATED.    */
/*                                                                              */
/*                                                                              */
/* ============================================================================ */
/* ============================================================================ */
/*                                                                              */
/* DATES:      10.0      ACTIVE 03 MONTH          = START OF MONTH DATES        */
/*                                                                              */
/*             10.1      A003M_SOY_SAS_DATE       = 12345                       */
/*             10.2      A003M_SOY_ORA_DATE       = '01MAY2016'D                */
/*             10.3      A003M_SOY_QTD_DATE       = '2016-05-01'                */
/*             10.4      A003M_SOM_YMDDL_DATE     = 2016-05-01                  */
/*             10.5      A003M_SOM_YYMMN_DATE     = 201605                      */
/*                                                                              */
/* DATES:      11.0      ACTIVE 03 MONTH          = END OF MONTH DATES          */
/*                                                                              */
/*             11.1      A003M_EOM_SAS_DATE       = 12345                       */
/*             11.2      A003M_EOM_ORA_DATE       = '31MAY2016'D                */
/*             11.3      A003M_EOM_QTD_DATE       = '2016-05-31'                */
/*             11.4      A003M_EOM_YMDDL_DATE     = 2016-05-31                  */
/*             11.5      A003M_EOM_YYMMN_DATE     = 201605                      */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* DATES:      12.0      ACTIVE 02 MONTH          = START OF MONTH DATES        */
/*                                                                              */
/*             12.1      A002M_SOM_SAS_DATE       = 12345                       */
/*             12.2      A002M_SOM_ORA_DATE       = '01JUN2016'D                */
/*             12.3      A002M_SOM_QTD_DATE       = '2016-06-01'                */
/*             12.4      A002M_SOM_YMDDL_DATE     = 2016-06-01                  */
/*             12.5      A002M_SOM_YYMMN_DATE     = 201606                      */
/*                                                                              */
/* DATES:      13.0      ACTIVE 02 MONTH          = END OF MONTH DATES          */
/*                                                                              */
/*             13.1      A002M_EOM_SAS_DATE       = 12345                       */
/*             13.2      A002M_EOM_ORA_DATE       = '30JUN2016'D                */
/*             13.3      A002M_EOM_QTD_DATE       = '2016-06-30'                */
/*             13.4      A002M_EOM_YMDDL_DATE     = 2016-06-30                  */
/*             13.5      A002M_EOM_YYMMN_DATE     = 201606                      */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* DATES:      14.0      ACTIVE 01 MONTH          = START OF MONTH DATES        */
/*                                                                              */
/*             14.1      A01M_SOM_SAS_DATE        = 12345                       */
/*             14.2      A01M_SOM_ORA_DATE        = '01JUL2016'D                */
/*             14.3      A01M_SOM_QTD_DATE        = '2016-07-01'                */
/*             14.4      A01M_SOM_YMDDL_DATE      = 2016-07-01                  */
/*             14.5      A01M_SOM_YYMMN_DATE      = 201607                      */
/*                                                                              */
/* DATES:      15.0      ACTIVE 01 MONTH          = END OF MONTH DATES          */
/*                                                                              */
/*             15.1      A01M_EOM_SAS_DATE        = 12345                       */
/*             15.2      A01M_EOM_ORA_DATE        = '31JUL2016'D                */
/*             15.3      A01M_EOM_QTD_DATE        = '2016-07-31'                */
/*             15.4      A01M_EOM_YMDDL_DATE      = 2016-07-31                  */
/*             15.5      A01M_EOM_YYMMN_DATE      = 201607                      */
/*                                                                              */
/* ============================================================================ */
/* ============================================================================ */
/*                                                                              */
/* DATES:      20.0      ACTIVE 03 MONTH          = START OF MONTH PERIOD DATES */
/*                                                                              */
/*             20.1      A03M_SOP_SAS_DATE        = 12345                       */
/*             20.2      A03M_SOP_ORA_DATE        = '01MAY2016'D                */
/*             20.3      A03M_SOP_QTD_DATE        = '2016-05-01'                */
/*             20.4      A03M_SOP_YMDDL_DATE      = 2016-05-01                  */
/*             20.5      A03M_SOP_YYMMN_DATE      = 201605                      */
/*                                                                              */
/* DATES:      21.0      ACTIVE 03 MONTH          = END OF MONTH PERIOD DATES   */
/*                                                                              */
/*             21.1      A03M_EOP_SAS_DATE        = 12345                       */
/*             21.2      A03M_EOP_ORA_DATE        = '31JUL2016'D                */
/*             21.3      A03M_EOP_QTD_DATE        = '2016-07-31'                */
/*             21.4      A03M_EOP_YMDDL_DATE      = 2016-07-31                  */
/*             21.5      A03M_EOP_YYMMN_DATE      = 201607                      */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* DATES:      22.0      ACTIVE 02 MONTH          = START OF MONTH PERIOD DATES */
/*                                                                              */
/*             22.1      A02M_SOP_SAS_DATE        = 12345                       */
/*             22.2      A02M_SOP_ORA_DATE        = '01JUN2016'D                */
/*             22.3      A02M_SOP_QTD_DATE        = '2016-06-01'                */
/*             22.4      A02M_SOP_YMDDL_DATE      = 2016-06-01                  */
/*             22.5      A02M_SOP_YYMMN_DATE      = 201606                      */
/*                                                                              */
/* DATES:      23.0      ACTIVE 02 MONTH          = END OF MONTH PERIOD DATES   */
/*                                                                              */
/*             23.1      A02M_EOM_SAS_DATE        = 12345                       */
/*             23.2      A02M_EOM_ORA_DATE        = '31JUL2016'D                */
/*             23.3      A02M_EOM_QTD_DATE        = '2016-07-31'                */
/*             23.4      A02M_EOM_YMDDL_DATE      = 2016-07-31                  */
/*             23.5      A02M_EOM_YYMMN_DATE      = 201607                      */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* DATES:      24.0      ACTIVE 01 MONTH          = START OF MONTH PERIOD DATES */
/*                                                                              */
/*             24.1      A01M_SOP_SAS_DATE        = 12345                       */
/*             24.2      A01M_SOP_ORA_DATE        = '01JUL2016'D                */
/*             24.3      A01M_SOP_QTD_DATE        = '2016-07-01'                */
/*             24.4      A01M_SOP_YMDDL_DATE      = 2016-07-01                  */
/*             24.5      A01M_SOP_YYMMN_DATE      = 201607                      */
/*                                                                              */
/* DATES:      25.0      ACTIVE 02 MONTH          = END OF MONTH PERIOD DATES   */
/*                                                                              */
/*             25.1      A01M_EOP_SAS_DATE        = 12345                       */
/*             25.2      A01M_EOP_ORA_DATE        = '31JUL2016'D                */
/*             25.3      A01M_EOP_QTD_DATE        = '2016-07-31'                */
/*             25.4      A01M_EOP_YMDDL_DATE      = 2016-07-31                  */
/*             25.5      A01M_EOP_YYMMN_DATE      = 201607                      */
/*                                                                              */
/* ============================================================================ */
/* ============================================================================ */
/*                                                                              */
/* DATES:      30.0      ACTIVE 30 DAYS           = START OF PERIOD DATES       */
/*                                                                              */
/*             30.1      A30D_SOP_SAS_DATE        = 12345                       */
/*             30.2      A30D_SOP_ORA_DATE        = '01JUL2016'D                */
/*             30.3      A30D_SOP_QTD_DATE        = '2016-07-01'                */
/*             30.4      A30D_SOP_YMDDL_DATE      = 2016-07-01                  */
/*             30.5      A30D_SOP_YYMMN_DATE      = 201607                      */
/*                                                                              */
/* DATES:      31.0      ACTIVE 30 DAYS           = END OF PERIOD DATES         */
/*                                                                              */
/*             31.1      A30D_EOP_SAS_DATE        = 12345                       */
/*             31.2      A30D_EOP_ORA_DATE        = '31JUL2016'D                */
/*             31.3      A30D_EOP_QTD_DATE        = '2016-07-31'                */
/*             31.4      A30D_EOP_YMDDL_DATE      = 2016-07-31                  */
/*             31.5      A30D_EOP_YYMMN_DATE      =  201607                     */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* DATES:      32.0      ACTIVE 60 DAYS           = START OF PERIOD DATES       */
/*                                                                              */
/*             32.1      A60D_SOP_SAS_DATE        = 12345                       */
/*             32.2      A60D_SOP_ORA_DATE        = '01JUN2016'D                */
/*             32.3      A60D_SOP_QTD_DATE        = '2016-06-01'                */
/*             32.4      A60D_SOP_YMDDL_DATE      = 2016-06-01                  */
/*             32.5      A60D_SOP_YYMMN_DATE      = 201606                      */
/*                                                                              */
/* DATES:      33.0      ACTIVE 60 DAYS           = END OF PERIOD DATES         */
/*                                                                              */
/*             33.1      A60D_EOP_SAS_DATE        = 12345                       */
/*             33.2      A60D_EOP_ORA_DATE        = '31JUL2016'D                */
/*             33.3      A60D_EOP_QTD_DATE        = '2016-07-31'                */
/*             33.4      A60D_EOP_YMDDL_DATE      = 2016-07-31                  */
/*             33.5      A60D_EOP_YYMMN_DATE      = 201607                      */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* DATES:      34.0      ACTIVE 90 DAYS           = START OF PERIOD DATES       */
/*                                                                              */
/*             34.1      A90D_SOP_SAS_DATE        = 12345                       */
/*             34.2      A90D_SOP_ORA_DATE        = '02MAY2016'D                */
/*             34.3      A90D_SOP_QTD_DATE        = '2016-05-02'                */
/*             34.4      A90D_SOP_YMDDL_DATE      = 2016-05-02                  */
/*             34.5      A90D_SOP_YYMMN_DATE      = 201605                      */
/*                                                                              */
/* DATES:      35.0      ACTIVE 90 DAYS           = END OF PERIOD DATES         */
/*                                                                              */
/*             35.1      A90D_EOP_SAS_DATE        = 12345                       */
/*             35.2      A90D_EOP_ORA_DATE        = '31JUL2016'D                */
/*             35.3      A90D_EOP_QTD_DATE        = '2016-07-31'                */
/*             35.4      A90D_EOP_YMDDL_DATE      = 2016-07-31                  */
/*             36.5      A90D_EOP_YYMMN_DATE      = 201607                      */
/*                                                                              */
/*============+=================================================================*/
%MACRO CALC_ACTIVE_YEAR_DATES(
 DATE          = NOW(),
 PERIODS       = 6,
 INCLUSIVE     = YES,
 DEBUG         = NO
 );


/*==============================================================================*/
/* STEP 01000       DEFINE GLOBAL VARIABLES                                     */
/*==============================================================================*/

%IF  %UPCASE(&DEBUG.) = YES %THEN %DO;
    OPTIONS MPRINT SYMBOLGEN SOURCE NOTES MLOGIC;
%END;
%ELSE %DO;
    OPTIONS NOSYMBOLGEN NOMLOGIC NOMPRINT;
%END;


/*==============================================================================*/
/*                                                                              */
/* STEP 02000       TRANSFORM THE INCLUSIVE DAYS RANGE SWITCH.                  */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/*  NOTE:      1.   THE INCLUSIVE FLAG HAS BEEN TRUNCATED TO 1 CHAR IN LENGTH.  */
/*                                                                              */
/*                  WHEN INCLUSIVE = YES = Y                                    */
/*                  WHEN INCLUSIVE = NO  = N                                    */
/*                                                                              */
/*==============================================================================*/

%LET      INCLUSIVE                = %UPCASE(&INCLUSIVE.);
     
%LET      INCLUSIVE                = %SUBSTR(&INCLUSIVE.,1,1);



/*==============================================================================*/
/*==============================================================================*/
/*                                                                              */
/* STEP 03000  ACTIVE-DATES   CALCULATE ACTIVE DATES                            */
/*                                                                              */
/*==============================================================================*/
/*==============================================================================*/
%MACRO INNER_ACTIVE_YEAR_DATES(
 PFX1          = A30,
 PFX2          = SOM,
 PERIOD        = MONTH,
 DATE          = TODAY(),
 GEN           = -1,
 LOC           = B
 );


/*==============================================================================*/
/*                                                                              */
/* STEP 03010  ACTIVE-DATES   DEFINE GLOBAL MACRO DATE VARIABLES                */
/*                                                                              */
/*==============================================================================*/

%GLOBAL        &PFX1._&PFX2._SAS_DATE;
%GLOBAL        &PFX1._&PFX2._ORA_DATE;
%GLOBAL        &PFX1._&PFX2._QTD_DATE;

%GLOBAL        &PFX1._&PFX2._YMDDL_DATE;

%GLOBAL        &PFX1._&PFX2._YYMMN_DATE;
%GLOBAL        &PFX1._&PFX2._YYM_DATE;

%GLOBAL        &PFX1._&PFX2._YEAR_DATE;


/*==============================================================================*/
/*                                                                              */
/* STEP 03020  ACTIVE-DATES   -    CALC ACTIVE DATES                            */
/*                                                                              */
/*==============================================================================*/

DATA &PFX1._&PFX2._&PERIOD.;

     /*=========================================================================*/
     /*                                                                         */
     /* 1.0    ACTIVE-DATES        DEFINE BASE DATE                             */
     /*                                                                         */
     /*=========================================================================*/

     BASE_DATE = &DATE.;

     FORMAT    BASE_DATE     DATE9.;
     

               




     /*=========================================================================*/
     /*                                                                         */
     /* 2.0    ACTIVE-DATES        CALC BEGINNING OF YEAR SAS DATES             */
     /*                                                                         */
     /*=========================================================================*/

     %IF       %UPCASE(&LOC.) = B
     OR        %UPCASE(&LOC.) = S  %THEN %DO;

     &PFX1._&PFX2._SAS_DATE = INTNX( "&PERIOD.", BASE_DATE, &GEN., "&LOC." ) &inclusive_str.;

     %END;


     /*=========================================================================*/
     /*                                                                         */
     /* 3.0    ACTIVE-DATES        CALC END-OF-YEAR SAS DATES.                  */
     /*                                                                         */
     /*=========================================================================*/

     %IF       %UPCASE(&LOC.) = E %THEN %DO;
     &PFX1._&PFX2._SAS_DATE = INTNX( "&PERIOD.", BASE_DATE, &GEN., "&LOC." );
     %END;

     FORMAT    &PFX1._&PFX2._SAS_DATE   DATE9.;


     /*=========================================================================*/
     /*                                                                         */
     /* 4.0    CALC-ACTIVE-YEAR-DATES        FORMAT SAS DATES.                  */
     /*                                                                         */
     /*=========================================================================*/

     /*-------------------------------------------------------------------------*/
     /* 4.1    &PFX1._SAS_DATE          =    nnnnn.         = 19567             */
     /*-------------------------------------------------------------------------*/

     CALL SYMPUT( "&pfx1._&pfx2._SAS_DATE" , LEFT( &pfx1._&pfx2._SAS_DATE ) );


     /*-------------------------------------------------------------------------*/
     /* 4.2    &PFX1._BASE_DATE         =    YYMMDDD10.     = 2017-09-30        */
     /*-------------------------------------------------------------------------*/

     &PFX1._BASE_DATE         = PUT( BASE_DATE, YYMMDDD10. );

     CALL SYMPUT( "&pfx1._BASE_DATE" , LEFT( &pfx1._BASE_DATE ) );


     /*-------------------------------------------------------------------------*/
     /* 4.3    &PFX1._ORA_DATE          =    DATE9.         = '30SEP2017'D      */
     /*-------------------------------------------------------------------------*/

     &pfx1._&pfx2._ORA_DATE   = "'" || PUT( &pfx1._&pfx2._SAS_DATE , DATE9. ) || "'D";

     CALL SYMPUT( "&pfx1._&pfx2._ORA_DATE" , LEFT( &pfx1._&pfx2._ORA_DATE ) );

 
     /*-------------------------------------------------------------------------*/
     /* 4.3    &PFX1._QTD_DATE          =    YYMMDDD10.     = '2017-09-30'      */
     /*-------------------------------------------------------------------------*/

     &pfx1._&pfx2._QTD_DATE   = "'" ||  PUT( &pfx1._&pfx2._SAS_DATE , YYMMDDD10. ) || "'";

     CALL SYMPUT( "&pfx1._&pfx2._QTD_DATE" , LEFT( &pfx1._&pfx2._QTD_DATE ) );


     /*-------------------------------------------------------------------------*/
     /* 4.4    &PFX1._&PFX2._YMDDL_DATE      =    YYMMDDD10.     = 2017-09-30   */
     /*-------------------------------------------------------------------------*/

     &pfx1._&pfx2._YMDDL_DATE = PUT( &pfx1._&pfx2._SAS_DATE , YYMMDDD10. );

     CALL SYMPUT( "&pfx1._&pfx2._YMDDL_DATE" , LEFT( &pfx1._&pfx2._YMDDL_DATE ) );


     /*-------------------------------------------------------------------------*/
     /* 4.5    &PFX1._&PFX2._YYMMN_DATE      =    YYMMN6.        = 201709       */
     /*        &PFX1._&PFX2._YYM_DATE        =    YYMMN6.        = 201709       */
     /*-------------------------------------------------------------------------*/

     &pfx1._&pfx2._YYMMN_DATE = PUT( &pfx1._&pfx2._SAS_DATE , YYMMN6. );
     &pfx1._&pfx2._YYM_DATE   = PUT( &pfx1._&pfx2._SAS_DATE , YYMMN6. );

     CALL SYMPUT( "&pfx1._&pfx2._YYMMN_DATE" , LEFT( &pfx1._&pfx2._YYMMN_DATE ) );

     CALL SYMPUT( "&pfx1._&pfx2._YYM_DATE"   , LEFT( &pfx1._&pfx2._YYM_DATE   ) );


     /*-------------------------------------------------------------------------*/
     /* 4.6    &PFX1._&pfx2._YEAR_DATE  =    YEAR4.         = 2017              */
     /*-------------------------------------------------------------------------*/

     &pfx1._&pfx2._YEAR_DATE  = PUT( &pfx1._&pfx2._SAS_DATE , YEAR4. );

     CALL SYMPUT( "&pfx1._&pfx2._YEAR_DATE"  , LEFT( &pfx1._&pfx2._YEAR_DATE ) );


RUN;


/*==============================================================================*/
/*                                                                              */
/* STEP 03030  ACTIVE-DATES             DISPLAY MACRO VARIABLES                 */
/*                                                                              */
/*==============================================================================*/

%PUT;
%PUT NOTE: &DLINE.;
%PUT NOTE: TITLE:   ACTIVE_DATES:       &PFX1. &PFX2. DATES ;
%PUT NOTE: ;
%PUT NOTE: ;
%PUT NOTE: PFX1                         = &PFX1.;
%PUT NOTE: PFX2                         = &PFX2.;
%PUT NOTE: PERIODS                      = &PERIODS.;
%PUT NOTE: GEN                          = &GEN.;
%PUT NOTE: ;
%PUT NOTE: &PFX1._BASE_DATE             = &&&PFX1._BASE_DATE.;
%PUT NOTE: ;
%PUT NOTE: &PFX1._&PFX2._SAS_DATE       = &&&PFX1._&PFX2._SAS_DATE.;
%PUT NOTE: &PFX1._&PFX2._ORA_DATE       = &&&PFX1._&PFX2._ORA_DATE.;
%PUT NOTE: &PFX1._&PFX2._QTD_DATE       = &&&PFX1._&PFX2._QTD_DATE.;
%PUT NOTE: &PFX1._&PFX2._YMDDL_DATE     = &&&PFX1._&PFX2._YMDDL_DATE.;
%PUT NOTE: &PFX1._&PFX2._YYMMN_DATE     = &&&PFX1._&PFX2._YYMMN_DATE.;
%PUT NOTE: &PFX1._&PFX2._YYM_DATE       = &&&PFX1._&PFX2._YYM_DATE.;
%PUT NOTE: &PFX1._&PFX2._YEAR_DATE      = &&&PFX1._&PFX2._YEAR_DATE.;
%PUT NOTE: ;
%PUT NOTE: ;
%PUT NOTE: &DLINE.;
%PUT;

%MEND; /* END OF CALC_ACTIVE_DATES MACRO */





/*==============================================================================*/
/*==============================================================================*/
/*                                                                              */
/* STEP 04000  ACTIVE_DAY_PERIODS       ACTIVE 30/60/90 DAYS - PERIOD RANGES    */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* DATES       CALC =  ACTIVE =    MONTH  =  INT  =  LOC  =  DATES              */
/* ============================================================================ */
/*             A090D =  SOP    =    DAY    =  -90  =   B   =  MAY 02, 2016      */
/*             A090D =  EOP    =    DAY    =   0   =   E   =  JUL 31, 2016      */
/*             ---------------------------------------------------------------- */
/*             A060D =  SOP    =    DAY    =  -60  =   B   =  JUN 01, 2016      */
/*             A060D =  EOP    =    DAY    =   0   =   E   =  JUL 31, 2016      */
/*             ---------------------------------------------------------------- */
/*             A030D =  SOP    =    DAY    =  -30  =   B   =  JUN 01, 2016      */
/*             A030D =  EOP    =    DAY    =   0   =   E   =  JUL 31, 2016      */
/*                                                                              */
/*==============================================================================*/
/*==============================================================================*/

%MACRO CALC_ACTIVE_PERIODS(
 TYPE          = DAYPER,
 INCLUSIVE     = YES,
 PERIODS       = 3,
 DATE          = NULL
 );


/*==============================================================================*/
/*                                                                              */
/* STEP 04010  ACTIVE-PERIODS           ASSIGN DAY PERIOD AS 30 UNITS           */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* NOTE: 1.    ACTIVE-DAY-PERIODS       A&PFX_NUM.D_SOP          30 DAY UNIT    */
/*       2.    ACTIVE-MTH-PERIODS       A&PFX_NUM.M_SOP|EOP      1 MONTH UNIT   */
/*       3.    ACTIVE-MTH               A&PFX_NUM.M_SOP|EOP      1 MONTH UNIT   */
/*==============================================================================*/

%IF       %UPCASE(&TYPE.)          =    DAYPER
%THEN     %LET PERIOD_UNIT         =    30;

%ELSE %IF %UPCASE(&TYPE.)          =    MTHPER    
%THEN     %LET PERIOD_UNIT         =    1;

%ELSE %IF %UPCASE(&TYPE.)          =    CALMTH
%THEN     %LET PERIOD_UNIT         =    1;


/*==============================================================================*/
/*                                                                              */
/* STEP 04020  ACTIVE-PERIODS           ASSIGN INCLUSIVE PERIOD RANGE IND(1/0)  */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* NOTE:  1.   THE INCLUSIVE PARAMETER HAS BEEN TRUNCATED TO 1 CHAR IN LENGTH.  */
/*                                                                              */
/*             INCLUSIVE = YES = Y                                              */
/*             INCLUSIVE = NO  = N                                              */
/*                                                                              */
/*==============================================================================*/

%IF       %UPCASE(&INCLUSIVE.)     =    Y
AND       %UPCASE(&TYPE.)          =    DAYPER

%THEN     %LET INCLUSIVE_STR       =    %STR( + 1 );
%ELSE     %LET INCLUSIVE_STR       =    %STR( + 0 );


/*==============================================================================*/
/*                                                                              */
/* STEP 04030  ACTIVE-DAY-PERIODS       DISPLAY PARMS TO THE SAS LOG            */
/*                                                                              */
/*==============================================================================*/

%PUT;
%PUT NOTE: &DLINE.;
%PUT NOTE:;
%PUT NOTE: SECTION:           CALC ACTIVE PERIODS: &TYPE.;
%PUT NOTE:;
%PUT NOTE:;
%PUT NOTE: TYPE          =    &TYPE.;
%PUT NOTE:;
%PUT NOTE:;
%PUT NOTE: PERIODS       =    &PERIODS.;
%PUT NOTE:;
%PUT NOTE: PERIOD_UNIT   =    &PERIOD_UNIT.;
%PUT NOTE:;
%PUT NOTE: INCLUSIVE     =    &INCLUSIVE.;
%PUT NOTE:;
%PUT NOTE: INCLUSIVE_STR =    &INCLUSIVE_STR.;
%PUT NOTE:;
%PUT NOTE:;
%PUT NOTE: &DLINE.;
%PUT;


/*==============================================================================*/
/*                                                                              */
/* STEP 04040  ACTIVE-DAY-PERIODS       LOOP THRU MONTHLY PERIODS.              */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/*   PERIOD_NO      PERIODS     PERIOD_UNIT   TOTAL_PERIOD_UNITS                */
/*   =======        =======     ===========   ================================= */
/*   1              1           30 | 1 | 1    30  | 1  | 1                      */
/*   2              2           30 | 1 | 1    60  | 3  | 3                      */
/*   3              3           30 | 1 | 1    90  | 3  | 3                      */
/*   4              4           30 | 1 | 1    120 | 3  | 3                      */
/*   5              5           30 | 1 | 1    150 | 3  | 3                      */
/*   6              6           30 | 1 | 1    180 | 6  | 6                      */
/*                                                                              */
/*==============================================================================*/

%DO  PERIOD_NO = 1  %TO &PERIODS. %BY 1;


     /*=========================================================================*/
     /*                                                                         */
     /* 1.          ACTIVE-DAY-PERIODS:      DAYPER                             */
     /*                                                                         */
     /*             START OF MONTH PERIOD:   A030D_SOP_XXX_DATE                 */
     /*                                                                         */
     /*             END OF MONTH PERIOD:     A030D_EOP_XXX_DATE                 */
     /*                                                                         */
     /*                                                                         */
     /* ----------------------------------------------------------------------- */
     /*             PERIOD_TYP     =    DAY  =    ADVANCE DATE BY DAYS          */
     /*             PERIOD_STA     =    SOP  =    START OF PERIOD FOR 1ST CALL  */
     /*             PERIOD_END     =    EOP  =    END OF PERIOD   FOR 2ND CALL  */
     /*             PREFIX_COL     =         =    A&PREFIX_NO.D                 */
     /*             GEN_NUM        =         =    &PREFIX_NO.                   */
     /*                                                                         */
     /* ----------------------------------------------------------------------- */
     /*                                                                         */
     /* EXAMPLE:    INPUT DATE: 2017-04-30 AND INCLUSIVE = YES             DAYS */
     /*             ====================================================   ==== */
     /*             WHEN PERIOD_NO = 1  SOP = 2017-04-01 EOP = 2017-04-30  30   */
     /*             WHEN PERIOD_NO = 2  SOP = 2017-03-02 EOP = 2017-04-30  60   */
     /*             WHEN PERIOD_NO = 3  SOP = 2017-01-31 EOP = 2017-04-30  90   */
     /*                                                                         */
     /* ----------------------------------------------------------------------- */
     /*                                                                         */
     /* EXAMPLE:    INPUT DATE: 2017-04-30 AND INCLUSIVE = NO              DAYS */
     /*             ====================================================   ==== */
     /*             WHEN PERIOD_NO = 1  SOP = 2017-03-31 EOP = 2017-04-30  30   */
     /*             WHEN PERIOD_NO = 2  SOP = 2017-03-01 EOP = 2017-04-30  60   */
     /*             WHEN PERIOD_NO = 3  SOP = 2017-01-30 EOP = 2017-04-30  90   */
     /*                                                                         */
     /*=========================================================================*/

     %IF  %UPCASE(&TYPE.)          =    DAYPER         %THEN %DO;

          /*--------------------------------------------------------------------*/
          /* 1.     PERIOD CONTROL PARMS                                        */
          /*--------------------------------------------------------------------*/

          %LET      PERIOD_TYP     =    DAY;
          %LET      PERIOD_STA     =    SOP;
          %LET      PERIOD_END     =    EOP;

          /*--------------------------------------------------------------------*/
          /* 2.     CREATE PREFIX COLUMN:        030,060,090,120,150,180        */
          /*--------------------------------------------------------------------*/

          %LET      PREFIX_COL     =    %EVAL( &PERIOD_NO. * &PERIOD_UNIT. );
          %LET      PREFIX_COL     =    %SYSFUNC( PUTN( &PREFIX_COL. , Z3. ) );
          %LET      PREFIX_COL     =    A&PREFIX_COL.D;

          /*--------------------------------------------------------------------*/
          /* 3.     CREATE CALC GEN NUMBER:      1,2,3,4,5,6                    */
          /*--------------------------------------------------------------------*/

          %LET      STA_GEN        =    %EVAL( &PERIOD_NO. * &PERIOD_UNIT. );
          %LET      STA_GEN        =    %SYSFUNC( PUTN( &STA_GEN. , Z3. ) );

          %LET      END_GEN        =    0;

          %PUT NOTE: STA_GEN       =    &STA_GEN.;
          %PUT NOTE: END_GEN       =    &END_GEN.;

     %END;


     /*=========================================================================*/
     /*                                                                         */
     /* 2.          ACTIVE-MTH-PERIODS:      MTHPER                             */
     /*                                                                         */
     /*             START OF MONTH PERIOD:   A001M_SOP_XXX_DATE                 */
     /*                                                                         */
     /*             END OF MONTH PERIOD:     A001M_EOP_XXX_DATE                 */
     /*                                                                         */
     /* ----------------------------------------------------------------------- */
     /*                                                                         */
     /* NOTE:  1.   THIS SECTION SETS THE PERIOD INPUT PERAMETERS TO ADVANCE    */
     /*             THE DATE IN MONTHS AND DISPLAY THE SOP (START OF PERIOD)    */
     /*             AND THE EOP ( END OF MONTH ) FOR EACH INPUT PERIOD DATE.    */
     /*                                                                         */
     /* ----------------------------------------------------------------------- */
     /*                                                                         */
     /* EXAMPLE:    INPUT DATE: 2017-04-30                                      */
     /*                                                                         */
     /*             WHEN PERIOD_NO = 1  SOP = 2017-04-01 EOP = 2017-04-30       */
     /*             WHEN PERIOD_NO = 2  SOP = 2017-03-01 EOP = 2017-04-30       */
     /*             WHEN PERIOD_NO = 3  SOP = 2017-02-01 EOP = 2017-04-30       */
     /*                                                                         */
     /*=========================================================================*/

     %IF  %UPCASE(&TYPE.)          =    MTHPER         %THEN %DO;

          /*--------------------------------------------------------------------*/
          /* 1. CREATE PERIOD PARMS:                                            */
          /*--------------------------------------------------------------------*/

          %LET PERIOD_TYP          =    MONTH;
          %LET PERIOD_STA          =    SOP;
          %LET PERIOD_END          =    EOP;

          /*--------------------------------------------------------------------*/
          /* 2. CREATE PREFIX COL:        PREFIX COLUMN NAME FOR WORD 1.        */
          /*--------------------------------------------------------------------*/
          /*    WHEN PERIOD_NO = 1, THEN PREFIX_COL = A001M                     */
          /*    WHEN PERIOD_NO = 2, THEN PREFIX_COL = A002M                     */
          /*    WHEN PERIOD_NO = 3, THEN PREFIX_COL = A003M                     */
          /*--------------------------------------------------------------------*/

          %LET PREFIX_COL          =    %EVAL( &PERIOD_NO. );
          %LET PREFIX_COL          =    %SYSFUNC( PUTN( &PREFIX_COL. , Z3. ) );
          %LET PREFIX_COL          =    A&PREFIX_COL.M;

          /*--------------------------------------------------------------------*/
          /* 3. CREATE CALC GEN:        INTNX FUNCTION GENERATION NO.           */
          /*--------------------------------------------------------------------*/
          /*    WHEN PERIOD_NO = 1, THEN CALC_GEN = 0                           */
          /*    WHEN PERIOD_NO = 2, THEN CALC_GEN = 1                           */
          /*    WHEN PERIOD_NO = 3, THEN CALC_GEN = 2                           */
          /*--------------------------------------------------------------------*/

          %LET STA_GEN             =    %EVAL( &PERIOD_NO. - 1 );
          %LET STA_GEN             =    %SYSFUNC( PUTN( &STA_GEN. , Z3. ) );

          %LET END_GEN             =    0;

          %PUT NOTE: STA_GEN       =    &STA_GEN.;
          %PUT NOTE: END_GEN       =    &END_GEN.;

     %END;


     /*=========================================================================*/
     /*                                                                         */
     /* 3.          ACTIVE-CAL=MONTHS:       CALMTH                             */
     /*                                                                         */
     /*             START OF MONTH PERIOD:   A001M_SOM_XXX_DATE                 */
     /*                                                                         */
     /*             END OF MONTH PERIOD:     A001M_EOM_XXX_DATE                 */
     /*                                                                         */
     /* ----------------------------------------------------------------------- */
     /*                                                                         */
     /* NOTE:  1.   THIS SECTION SETS THE PERIOD INPUT PERAMETERS TO ADVANCE    */
     /*             THE DATE IN MONTHS AND DISPLAY THE SOM (START OF MONTH )    */
     /*             AND THE EOM ( END OF MONTH ) FOR EACH INPUT PERIOD DATE.    */
     /*                                                                         */
     /* ----------------------------------------------------------------------- */
     /*                                                                         */
     /* EXAMPLE:    INPUT DATE: 2017-04-30                                      */
     /*                                                                         */
     /*             WHEN PERIOD_NO = 1  SOP = 2017-04-01 EOP = 2017-04-30       */
     /*             WHEN PERIOD_NO = 2  SOP = 2017-03-01 EOP = 2017-03-31       */
     /*             WHEN PERIOD_NO = 3  SOP = 2017-02-01 EOP = 2017-02-28       */
     /*                                                                         */
     /*=========================================================================*/

     %IF  %UPCASE(&TYPE.)          =    CALMTH         %THEN %DO;

          /*--------------------------------------------------------------------*/
          /* 1.     CAL-MTH   ASSIGN PERIOD PARAMETERS.                         */
          /*--------------------------------------------------------------------*/

          %LET PERIOD_TYP          =    MONTH;
          %LET PERIOD_STA          =    SOM;
          %LET PERIOD_END          =    EOM;

          /*--------------------------------------------------------------------*/
          /* 2.     CAL_MTH   ASSIGN PREFIX COLUMN FOR WORD 1.                  */
          /*--------------------------------------------------------------------*/
          /*        WHEN PERIOD_NO = 1, THEN PREFIX_COL = A001M                 */
          /*        WHEN PERIOD_NO = 2, THEN PREFIX_COL = A002M                 */
          /*        WHEN PERIOD_NO = 3, THEN PREFIX_COL = A003M                 */
          /*--------------------------------------------------------------------*/

          %LET PREFIX_COL          =    %EVAL( &PERIOD_NO. );
          %LET PREFIX_COL          =    %SYSFUNC( PUTN( &PREFIX_COL. , Z3. ) );
          %LET PREFIX_COL          =    A&PREFIX_COL.M;

          /*--------------------------------------------------------------------*/
          /* 3.     CAL-MTH   ASSIGN CALCULATED GENERATION NUMBER.              */
          /*--------------------------------------------------------------------*/
          /*        WHEN PERIOD_NO = 1, THEN CALC_GEN = 1                       */
          /*        WHEN PERIOD_NO = 2, THEN CALC_GEN = 2                       */
          /*        WHEN PERIOD_NO = 3, THEN CALC_GEN = 3                       */
          /*--------------------------------------------------------------------*/

          %LET STA_GEN             =    %EVAL( &PERIOD_NO. - 1 );

          %LET STA_GEN             =    %SYSFUNC( PUTN( &STA_GEN. , Z3. ) );

          %LET END_GEN             =    &STA_GEN.;

          %PUT NOTE: STA_GEN       =    &STA_GEN.;
          %PUT NOTE: END_GEN       =    &END_GEN.;

     %END;


     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* 4.     ACTIVE-DATES        CALCUATE START OF PERIOD DATE.               */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/

     %INNER_ACTIVE_YEAR_DATES( 
                                   /*-------------------------------------------*/
     PFX1   = &PREFIX_COL.,        /* WHEN: DAYPER  =  A&PREFIX_NUM.D           */
                                   /* WHEN: MTHPER  =  A&PREFIX_NUM.M           */
                                   /* WHEN: MONTH   =  A&PREFIX_NUM.M           */
                                   /*-------------------------------------------*/
     PFX2   = &PERIOD_STA.,        /* WHEN: DAYPER  =  EOP   - END OF PERIOD    */
                                   /* WHEN: MTHPER  =  EOP   - END OF PERIOD    */
                                   /* WHEN: MONTH   =  EOM   - END OF MONTH     */
                                   /*-------------------------------------------*/
     PERIOD = &PERIOD_TYP.,        /* WHEN: DAYPER  =  DAY   - ADVANCE BY DAY   */
                                   /* WHEN: MTHPER  =  MONTH - ADVANCE BY MTH   */
                                   /* WHEN: MONTH   =  MONTH - ADVANCE BY MTH   */
                                   /*-------------------------------------------*/
     DATE   = &DATE.,              /* ALWAYS: USE:  =  EOM DATE: '30APR2-17'D   */
                                   /*-------------------------------------------*/
     GEN    = -&STA_GEN.,          /* ALWAYS: USE:  =  CALCULATE PERIOD GEN.    */
                                   /*-------------------------------------------*/
     LOC    = B                    /* ALWAYS: USE:  =  'E'                      */
                                   /*-------------------------------------------*/
     ); RUN;


     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* 5.     ACTIVE-DATES        CALCUATE END OF PERIOD DATE.                 */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/

     %INNER_ACTIVE_YEAR_DATES(                
                                   /*-------------------------------------------*/
     PFX1   = &PREFIX_COL.,        /* WHEN: DAYPER  =  A&PREFIX_NUM.D           */
                                   /* WHEN: MTHPER  =  A&PREFIX_NUM.M           */
                                   /* WHEN: MONTH   =  A&PREFIX_NUM.M           */
                                   /*-------------------------------------------*/
     PFX2   = &PERIOD_END.,        /* WHEN: DAYPER  =  EOP   - END OF PERIOD    */
                                   /* WHEN: MTHPER  =  EOP   - END OF PERIOD    */
                                   /* WHEN: MONTH   =  EOM   - END OF MONTH     */
                                   /*-------------------------------------------*/
     PERIOD = &PERIOD_TYP.,        /* WHEN: DAYPER  =  DAY   - ADVANCE BY DAY   */
                                   /* WHEN: MTHPER  =  MONTH - ADVANCE BY MTH   */
                                   /* WHEN: MONTH   =  MONTH - ADVANCE BY MTH   */
                                   /*-------------------------------------------*/
     DATE   = &DATE.,              /* ALWAYS: USE:  =  EOM DATE: '30APR2-17'D   */
                                   /*-------------------------------------------*/
     GEN    = -&END_GEN.,          /* ALWAYS: USE:  =  0                        */
                                   /*-------------------------------------------*/
     LOC    = E                    /* ALWAYS: USE:  =  'E'                      */
                                   /*-------------------------------------------*/
     ); RUN;

%END;

%MEND;


/*==============================================================================*/
/*                                                                              */
/* STEP 04040  ACTIVE-DAY-PERIODS       ACTIVE DAYS SOP EOP                     */
/*                                                                              */
/*==============================================================================*/

%CALC_ACTIVE_PERIODS(
 TYPE          = DAYPER,
 PERIODS       = &PERIODS.,
 DATE          = &DATE.,
 INCLUSIVE     = &INCLUSIVE.
 ); RUN;

%CALC_ACTIVE_PERIODS(
 TYPE          = MTHPER,
 PERIODS       = &PERIODS.,
 DATE          = &DATE.,
 INCLUSIVE     = &INCLUSIVE.
 ); RUN;

%CALC_ACTIVE_PERIODS(
 TYPE          = CALMTH,
 PERIODS       = &PERIODS.,
 DATE          = &DATE.,
 INCLUSIVE     = &INCLUSIVE.
 ); RUN;



/*==============================================================================*/
/*                                                                              */
/* STEP 05000  RESET OPTIONS                                                    */
/*                                                                              */
/*==============================================================================*/

OPTIONS NOMACROGEN NOSYMBOLGEN NOMLOGIC MPRINT;


%MEND;
/*%CALC_ACTIVE_YEAR_DATES(*/
/* INCLUSIVE     = YES,*/
/* PERIODS       = 6,*/
/* DATE          = '30APR2017'D*/
/* ); RUN;*/
