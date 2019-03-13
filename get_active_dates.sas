/*==============================================================================*/
/*                                                                              */
/* MACRO:      GET_ACTIVE_DATES                                                 */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* PURPOSE:    1.   GENERATE THE ACTIVE DATES IN AN ARRAY FORMAT.               */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* EXAMPLE:         WHEN TYPE = ORA                                             */
/*                                                                              */
/*             1.   M01_A030D_SOP_ORA_DATE - ACTIVE 030 DAYS                    */
/*                  M01_A030D_EOP_ORA_DATE                                      */
/*                                                                              */
/*             2.   M01_A090D_SOP_ORA_DATE - ACTIVE 090 DAYS                    */
/*                  M01_A090D_EOP_ORA_DATE                                      */
/*                                                                              */
/*             3.   M01_A180D_SOP_ORA_DATE - ACTIVE 180 DAYS                    */
/*                  M01_A180D_EOP_ORA_DATE                                      */
/*                                                                              */
/*             4.   M01_A001M_SOP_ORA_DATE - ACTIVE 1 MONTH                     */
/*                  M01_A001M_EOP_ORA_DATE                                      */
/*                                                                              */
/*             5.   M01_A003M_SOP_ORA_DATE - ACTIVE 3 MONTHS                    */
/*                  M01_A003M_EOP_ORA_DATE                                      */
/*                                                                              */
/*             6.   M01_A006M_SOP_ORA_DATE - ACTIVE 6 MONTHS                    */
/*                  M01_A006M_EOP_ORA_DATE                                      */
/*                                                                              */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* EXAMPLE:         WHEN TYPE = EDW                                             */
/*                                                                              */
/*             1.   M01_A030D_SOP_EDW_DATE - ACTIVE 030 DAYS                    */
/*                  M01_A030D_EOP_EDW_DATE                                      */
/*                                                                              */
/*             2.   M01_A090D_SOP_EDW_DATE - ACTIVE 090 DAYS                    */
/*                  M01_A090D_EOP_EDW_DATE                                      */
/*                                                                              */
/*             3.   M01_A180D_SOP_EDW_DATE - ACTIVE 180 DAYS                    */
/*                  M01_A180D_EOP_EDW_DATE                                      */
/*                                                                              */
/*             4.   M01_A001M_SOP_EDW_DATE - ACTIVE 1 MONTH                     */
/*                  M01_A001M_EOP_EDW_DATE                                      */
/*                                                                              */
/*             5.   M01_A003M_SOP_EDW_DATE - ACTIVE 3 MONTHS                    */
/*                  M01_A003M_EOP_EDW_DATE                                      */
/*                                                                              */
/*             6.   M01_A006M_SOP_EDW_DATE - ACTIVE 6 MONTHS                    */
/*                  M01_A006M_EOP_EDW_DATE                                      */
/*                                                                              */
/*==============================================================================*/
%MACRO GET_ACTIVE_DATES(
 OUTLIB   = WORK,
 OUT      = ACTIVE_DATES,
 GEN      = &SAS_GEN.,
 PERIODS  = 16,
 PREFIX   = M,
 TYPE     = ORA,
 TRACE    = NO
 );



/*==============================================================================*/
/*                                                                              */
/* STEP 01000  GENERATE  THE SAS MONTHEND DATES FOR THE PAST PERIODS.           */
/*                                                                              */
/*==============================================================================*/

%IF  %UPCASE(&TRACE.) = YES %THEN %DO;

OPTIONS MACROGEN SYMBOLGEN MLOGIC MTRACE MPRINT SOURCE SOURCE2 NOTES; RUN;

%END;



/*==============================================================================*/
/*                                                                              */
/* STEP 02000  GENERATE  THE SAS MONTHEND DATES FOR THE PAST PERIODS.           */
/*                                                                              */
/*==============================================================================*/

DATA &OUTLIB..&OUT. ;

     /*-------------------------------------------------------------------------*/
     /* 1.1    GENERATE  THE BASE SAS DATE.                                     */
     /*-------------------------------------------------------------------------*/

     TIME_BASE_DATE  =    INTNX('MONTH', TODAY(), &GEN. , 'E' );

     /*-------------------------------------------------------------------------*/
     /* 1.2    GENERATE  THE SOM AND EOM SAS DATES FOR EACH PERIOD.             */
     /*-------------------------------------------------------------------------*/

     DO   I = 1 TO &PERIODS. ;

          PREFIX         =    "&PREFIX." || PUT( (I) , Z2. );

          TIME_SOM_DATE  =    INTNX( 'MONTH', TIME_BASE_DATE, -(I-1), 'B' );

          TIME_EOM_DATE  =    INTNX( 'MONTH', TIME_BASE_DATE, -(I-1), 'E' );

          OUTPUT;

     END;

     /*-------------------------------------------------------------------------*/
     /* 1.3    GENERATE  THE SAS FORMATS FOR EACH SAS DATE.                     */
     /*-------------------------------------------------------------------------*/

     FORMAT    TIME_BASE_DATE      DATE9.;
     FORMAT    TIME_SOM_DATE       DATE9.; 
     FORMAT    TIME_EOM_DATE       DATE9.;

RUN;



/*==============================================================================*/
/*                                                                              */
/* STEP 03000  CREATE LOCAL SAS MACRO DATE VARIABLE NAMES FOR EACH PERIOD.      */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/* ACTIVE MONTHS:                                                               */
/*                                                                              */
/* DATES: 1.   A001M_SOPx = M00_A001M_SOP_ORA_DATE                              */
/*             A001M_EOPx = M00_A001M_EOP_ORA_DATE                              */
/*                                                                              */
/* DATES: 2.   A003M_SOPx = M00_A003M_SOP_ORA_DATE                              */
/*             A003M_EOPx = M00_A003M_EOP_ORA_DATE                              */
/*                                                                              */
/* DATES: 3.   A006M_SOPx = M00_A006M_SOP_ORA_DATE                              */
/*             A006M_EOPx = M00_A006M_EOP_ORA_DATE                              */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/* ACTIVE DAYS:                                                                 */
/*                                                                              */
/* NOTE:  1.   A030D_SOPx = M00_A030D_SOP_ORA_DATE                              */
/*             A030D_EOPx = M00_A030D_EOP_ORA_DATE                              */
/*                                                                              */
/*        2.   A090D_SOPx = M00_A090D_SOP_ORA_DATE                              */
/*             A090D_EOPx = M00_A090D_EOP_ORA_DATE                              */
/*                                                                              */
/*        3.   A180D_SOPx = M00_A180D_SOP_ORA_DATE                              */
/*             A180D_EOPx = M00_A180D_EOP_ORA_DATE                              */
/*                                                                              */
/*==============================================================================*/

DATA &OUTLIB..&OUT.;

     /*-------------------------------------------------------------------------*/
     /* 2.1    READ THE ACTIVE DATES SAS DATASET.                               */
     /*-------------------------------------------------------------------------*/

     SET       &OUTLIB..&OUT.;

     /*-------------------------------------------------------------------------*/
     /* 2.2    CREATE ACTIVE MONTHS GLOBAL MACRO VARIABLES.                     */
     /*-------------------------------------------------------------------------*/

     CALL SYMPUT('A001M_SOP'  || LEFT(I), TRIM(PREFIX) || '_A001M_SOP_ORA_DATE' );
     CALL SYMPUT('A001M_EOP'  || LEFT(I), TRIM(PREFIX) || '_A001M_EOP_ORA_DATE' );

     CALL SYMPUT('A003M_SOP'  || LEFT(I), TRIM(PREFIX) || '_A003M_SOP_ORA_DATE' );
     CALL SYMPUT('A003M_EOP'  || LEFT(I), TRIM(PREFIX) || '_A003M_EOP_ORA_DATE' );

     CALL SYMPUT('A006M_SOP'  || LEFT(I), TRIM(PREFIX) || '_A006M_SOP_ORA_DATE' );
     CALL SYMPUT('A006M_EOP'  || LEFT(I), TRIM(PREFIX) || '_A006M_EOP_ORA_DATE' );

     /*-------------------------------------------------------------------------*/
     /* 2.3    CREATE ACTIVE DAYS   GLOBAL MACRO VARIABLES.                     */
     /*-------------------------------------------------------------------------*/

     CALL SYMPUT('A030D_SOP'  || LEFT(I), TRIM(PREFIX) || '_A030D_SOP_ORA_DATE' );
     CALL SYMPUT('A030D_EOP'  || LEFT(I), TRIM(PREFIX) || '_A030D_EOP_ORA_DATE' );

     CALL SYMPUT('A090D_SOP'  || LEFT(I), TRIM(PREFIX) || '_A090D_SOP_ORA_DATE' );
     CALL SYMPUT('A090D_EOP'  || LEFT(I), TRIM(PREFIX) || '_A090D_EOP_ORA_DATE' );

     CALL SYMPUT('A180D_SOP'  || LEFT(I), TRIM(PREFIX) || '_A180D_SOP_ORA_DATE' );
     CALL SYMPUT('A180D_EOP'  || LEFT(I), TRIM(PREFIX) || '_A180D_EOP_ORA_DATE' );

RUN;



/*==============================================================================*/
/*                                                                              */
/* STEP 04000  DEFINE    ACTIVE DATES GLOBAL MACRO VARIABLE ARRAYS.             */
/*                                                                              */
/*==============================================================================*/

%DO  I = 1     %TO  &PERIODS. ;

     /*-------------------------------------------------------------------------*/
     /* 1.     DEFINE ACTIVE MONTH VARIABLES.                                   */
     /*-------------------------------------------------------------------------*/

     %GLOBAL   &&A001M_SOP&I. ;
     %GLOBAL   &&A001M_EOP&I. ;

     %GLOBAL   &&A003M_SOP&I. ;
     %GLOBAL   &&A003M_EOP&I. ;

     %GLOBAL   &&A006M_SOP&I. ;
     %GLOBAL   &&A006M_EOP&I. ;

     /*-------------------------------------------------------------------------*/
     /* 2.     DEFINE ACTIVE DAYS  VARIABLES.                                   */
     /*-------------------------------------------------------------------------*/

     %GLOBAL   &&A030D_SOP&I. ;
     %GLOBAL   &&A030D_EOP&I. ;

     %GLOBAL   &&A090D_SOP&I. ;
     %GLOBAL   &&A090D_EOP&I. ;

     %GLOBAL   &&A180D_SOP&I. ;
     %GLOBAL   &&A180D_EOP&I. ;

%END;



/*==============================================================================*/
/*                                                                              */
/* STEP 05000  DISPLAY   ACTIVE DATES ARRAYS TO THE SAS LOG.                    */
/*                                                                              */
/*==============================================================================*/

%DO  I = 1 %TO &PERIODS. ;

%PUT NOTE: &SLINE. ;
%PUT NOTE: ;
%PUT NOTE: A001M_SOP&I. = &&A001M_SOP&I. ;
%PUT NOTE: A001M_EOP&I. = &&A001M_EOP&I. ;
%PUT NOTE: ;
%PUT NOTE: A003M_SOP&I. = &&A003M_SOP&I. ;
%PUT NOTE: A003M_EOP&I. = &&A003M_EOP&I. ;
%PUT NOTE: ;
%PUT NOTE: A006M_SOP&I. = &&A006M_SOP&I. ;
%PUT NOTE: A006M_EOP&I. = &&A006M_EOP&I. ;
%PUT NOTE: ;
%PUT NOTE: A030D_SOP&I. = &&A030D_SOP&I. ;
%PUT NOTE: A030D_EOP&I. = &&A030D_EOP&I. ;
%PUT NOTE: ;
%PUT NOTE: A090D_SOP&I. = &&A090D_SOP&I. ;
%PUT NOTE: A090D_EOP&I. = &&A090D_EOP&I. ;
%PUT NOTE: ;
%PUT NOTE: A180D_SOP&I. = &&A180D_SOP&I. ;
%PUT NOTE: A180D_EOP&I. = &&A180D_EOP&I. ;
%PUT NOTE: ;
%PUT NOTE: &SLINE. ;

%END;


 
/*==============================================================================*/
/*                                                                              */
/* STEP 06000  GENERATE  ACTIVE DATES MACRO ARRAYS                              */
/*                                                                              */
/*==============================================================================*/

DATA &OUTLIB..&OUT. ;


     /*=========================================================================*/
     /*                                                                         */
     /* 1.     READ      ACTIVE DATES SAS DATASET.                              */
     /*                                                                         */
     /*=========================================================================*/

     SET       &OUTLIB..&OUT. ;


     /*=========================================================================*/
     /*                                                                         */
     /* 2.     CALC      ACTIVE 1 MONTH - SAS DATE VARIABLES.                   */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        A001M_SOP_DATE = ACTIVE 1 MONTH - START OF PERIOD.     */
     /*                                                                         */
     /*                  A001M_EOP_DATE = ACTIVE 1 MONTH - END OF PERIOD.       */
     /*                                                                         */
     /*=========================================================================*/

     A001M_SOP_DATE      =    TIME_SOM_DATE ;

     A001M_EOP_DATE      =    TIME_EOM_DATE ;

     FORMAT    A001M_SOP_DATE      DATE9. ;
     FORMAT    A001M_EOP_DATE      DATE9. ;


     /*=========================================================================*/
     /*                                                                         */
     /* 3.     CALC      ACTIVE 3 MONTH - SAS DATE VARIABLES.                   */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        A003M_SOP_DATE = ACTIVE 3 MONTH - START OF PERIOD.     */
     /*                                                                         */
     /*                  A003M_EOP_DATE = ACTIVE 3 MONTH - END OF PERIOD.       */
     /*                                                                         */
     /*=========================================================================*/

     A003M_SOP_DATE      =    INTNX( 'MONTH' , TIME_EOM_DATE, (-3+1), 'B' ) ;

     A003M_EOP_DATE      =    INTNX( 'MONTH' , TIME_EOM_DATE, ( 0  ), 'E' ) ;

     FORMAT    A003M_SOP_DATE      DATE9. ;
     FORMAT    A003M_EOP_DATE      DATE9. ;


     /*=========================================================================*/
     /*                                                                         */
     /* 4.     CALC      ACTIVE 6 MONTH - SAS DATE VARIABLES.                   */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        A006M_SOP_DATE = ACTIVE 6 MONTH - START OF PERIOD.     */
     /*                                                                         */
     /*                  A006M_EOP_DATE = ACTIVE 6 MONTH - END OF PERIOD.       */
     /*                                                                         */
     /*=========================================================================*/

     A006M_SOP_DATE      =    INTNX( 'MONTH', TIME_EOM_DATE, (-6+1), 'B' ) ;

     A006M_EOP_DATE      =    INTNX( 'MONTH', TIME_EOM_DATE, ( 0  ), 'E' ) ;

     FORMAT    A006M_SOP_DATE      DATE9. ;
     FORMAT    A006M_EOP_DATE      DATE9. ;


     /*=========================================================================*/
     /*                                                                         */
     /* 5.     CALC      ACTIVE 30 DAYS SAS DATE VARIABLES.                     */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        A030D_SOP_DATE = ACTIVE 30 DAYS - START OF PERIOD.     */
     /*                                                                         */
     /*                  A030D_EOP_DATE = ACTIVE 30 DAYS - END OF PERIOD.       */
     /*                                                                         */
     /*=========================================================================*/

     A030D_SOP_DATE      =    INTNX('DAY',   TIME_EOM_DATE, (-30+1),'B' ) ;

     A030D_EOP_DATE      =    INTNX('MONTH', TIME_EOM_DATE, ( 0 )  ,'E' ) ;

     FORMAT    A030D_SOP_DATE      DATE9. ;
     FORMAT    A030D_EOP_DATE      DATE9. ;


     /*=========================================================================*/
     /*                                                                         */
     /* 6.     CALC      ACTIVE 90 DAYS SAS DATE VARIABLES.                     */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        A090D_SOP_DATE = ACTIVE 90 DAYS - START OF PERIOD.     */
     /*                                                                         */
     /*                  A090D_EOP_DATE = ACTIVE 90 DAYS - END OF PERIOD.       */
     /*                                                                         */
     /*=========================================================================*/

     A090D_SOP_DATE      =    INTNX( 'DAY',   TIME_EOM_DATE, (-90+1), 'B' ) ;

     A090D_EOP_DATE      =    INTNX( 'MONTH', TIME_EOM_DATE, (0)    , 'E' ) ;

     FORMAT    A090D_SOP_DATE      DATE9. ;
     FORMAT    A090D_EOP_DATE      DATE9. ;


     /*=========================================================================*/
     /*                                                                         */
     /* 7.     CALC      ACTIVE 180 DAYS SAS DATE VARIABLES.                    */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        A180D_SOP_DATE = ACTIVE 180 DAYS - START OF PERIOD.    */
     /*                                                                         */
     /*                  A180D_EOP_DATE = ACTIVE 180 DAYS - END OF PERIOD.      */
     /*                                                                         */
     /*=========================================================================*/

     A180D_SOP_DATE      =    INTNX( 'DAY',   TIME_EOM_DATE, (-180+1) , 'B' ) ;

     A180D_EOP_DATE      =    INTNX( 'MONTH', TIME_EOM_DATE, (0)      , 'E' ) ;

     FORMAT    A180D_SOP_DATE      DATE9. ;
     FORMAT    A180D_EOP_DATE      DATE9. ;

RUN;



/*==============================================================================*/
/*                                                                              */
/* STEP 07000  GENERATE  ORACLE / SAS LITERAL FORMATTED DATES( 'DDMMMYYYY'D )   */
/*                                                                              */
/*==============================================================================*/

%IF  %UPCASE(&TYPE.)     =    ORA       %THEN %DO;

DATA &OUTLIB..&OUT.;

     /*=========================================================================*/
     /*                                                                         */
     /* 1.     BUILD     ACTIVE DAYS ORACLE DATE STRING VARIABLES               */
     /*                                                                         */
     /*=========================================================================*/

     SET &OUTLIB..&OUT.;


     /*=========================================================================*/
     /*                                                                         */
     /* 2.     BUILD     ACTIVE DAYS ORACLE DATE STRING VARIABLES               */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        A030D_SOP_ORA_DATE = '02JAN2017'D                      */
     /* NOTE:  2.        A030D_EOP_ORA_DATE = '31JAN2017'D                      */
     /*                                                                         */
     /*=========================================================================*/

     A030D_SOP_ORA_DATE  =    "'" || PUT( A030D_SOP_DATE, DATE9.) || "'D" ;
     A030D_EOP_ORA_DATE  =    "'" || PUT( A030D_EOP_DATE, DATE9.) || "'D" ;

     A090D_SOP_ORA_DATE  =    "'" || PUT( A090D_SOP_DATE, DATE9.) || "'D" ;
     A090D_EOP_ORA_DATE  =    "'" || PUT( A090D_EOP_DATE, DATE9.) || "'D" ;

     A180D_SOP_ORA_DATE  =    "'" || PUT( A180D_SOP_DATE, DATE9.) || "'D" ;
     A180D_EOP_ORA_DATE  =    "'" || PUT( A180D_EOP_DATE, DATE9.) || "'D" ;


     /*=========================================================================*/
     /*                                                                         */
     /* 3.     BUILD     ACTIVE MONTHS ORACLE DATE STRING VARIABLES.            */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        A030D_SOP_ORA_DATE = '02JAN2017'D                      */
     /* NOTE:  2.        A030D_EOP_ORA_DATE = '31JAN2017'D                      */
     /*                                                                         */
     /*=========================================================================*/

     A001M_SOP_ORA_DATE    =    "'" || PUT( A001M_SOP_DATE, DATE9.) || "'D" ;
     A001M_EOP_ORA_DATE    =    "'" || PUT( A001M_EOP_DATE, DATE9.) || "'D" ;

     A003M_SOP_ORA_DATE    =    "'" || PUT( A003M_SOP_DATE, DATE9.) || "'D" ;
     A003M_EOP_ORA_DATE    =    "'" || PUT( A003M_EOP_DATE, DATE9.) || "'D" ;

     A006M_SOP_ORA_DATE    =    "'" || PUT( A006M_SOP_DATE, DATE9.) || "'D" ;
     A006M_EOP_ORA_DATE    =    "'" || PUT( A006M_EOP_DATE, DATE9.) || "'D" ;


     /*=========================================================================*/
     /*                                                                         */
     /* 4.     CREATE    ACTIVE DAYS - ORACLE DATE STRING MACRO VARIABLES.      */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        M00_A030D_SOP_ORA_DATE = '02JAN2017'D                  */
     /* NOTE:  2.        M00_A030D_EOP_ORA_DATE = '31JAN2017'D                  */
     /*                                                                         */
     /*=========================================================================*/

     CALL SYMPUT( STRIP(PREFIX) || '_A030D_SOP_ORA_DATE' , A030D_SOP_ORA_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A030D_EOP_ORA_DATE' , A030D_EOP_ORA_DATE );

     CALL SYMPUT( STRIP(PREFIX) || '_A090D_SOP_ORA_DATE' , A090D_SOP_ORA_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A090D_EOP_ORA_DATE' , A090D_EOP_ORA_DATE );

     CALL SYMPUT( STRIP(PREFIX) || '_A180D_SOP_ORA_DATE' , A180D_SOP_ORA_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A180D_EOP_ORA_DATE' , A180D_EOP_ORA_DATE );


     /*=========================================================================*/
     /*                                                                         */
     /* 5.     CREATE    ACTIVE MTHS - ORACLE DATE STRING MACRO VARIABLES.      */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        M00_A001M_SOP_ORA_DATE = '01JAN2017'D                  */
     /* NOTE:  2.        M00_A001M_EOP_ORA_DATE = '31JAN2017'D                  */
     /*                                                                         */
     /*=========================================================================*/

     CALL SYMPUT( STRIP(PREFIX) || '_A001M_SOP_ORA_DATE' , A001M_SOP_ORA_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A001M_EOP_ORA_DATE' , A001M_EOP_ORA_DATE );

     CALL SYMPUT( STRIP(PREFIX) || '_A003M_SOP_ORA_DATE' , A003M_SOP_ORA_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A003M_EOP_ORA_DATE' , A003M_EOP_ORA_DATE );

     CALL SYMPUT( STRIP(PREFIX) || '_A006M_SOP_ORA_DATE' , A006M_SOP_ORA_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A006M_EOP_ORA_DATE' , A006M_EOP_ORA_DATE );

RUN;

%END;



/*==============================================================================*/
/*                                                                              */
/* STEP 06000  GENERATE  ORACLE / SAS LITERAL FORMATTED DATES( 'DDMMMYYYY'D )   */
/*                                                                              */
/*==============================================================================*/

%IF  %UPCASE(&TYPE.)     =    EDW       %THEN %DO;

DATA &OUTLIB..&OUT.;
     
     SET &OUTLIB..&OUT.;


     /*=========================================================================*/
     /*                                                                         */
     /* 1.     BUILD     ACTIVE DAYS ORACLE DATE STRING VARIABLES               */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        A030D_SOP_EDW_DATE       =    '2017-01-02'             */
     /* NOTE:  2.        A030D_EOP_EDW_DATE       =    '2017-01-31'             */
     /*                                                                         */
     /*=========================================================================*/

     A030D_SOP_EDW_DATE  =    "'" || PUT( A030D_SOP_DATE, YYMMDDD10. ) || "'" ;
     A030D_EOP_EDW_DATE  =    "'" || PUT( A030D_EOP_DATE, YYMMDDD10. ) || "'" ;

     A090D_SOP_EDW_DATE  =    "'" || PUT( A090D_SOP_DATE, YYMMDDD10. ) || "'" ;
     A090D_EOP_EDW_DATE  =    "'" || PUT( A090D_EOP_DATE, YYMMDDD10. ) || "'" ;

     A180D_SOP_EDW_DATE  =    "'" || PUT( A180D_SOP_DATE, YYMMDDD10. ) || "'" ;
     A180D_EOP_EDW_DATE  =    "'" || PUT( A180D_EOP_DATE, YYMMDDD10. ) || "'" ;


     /*=========================================================================*/
     /*                                                                         */
     /* 2.     BUILD     ACTIVE MONTHS ORACLE DATE STRING VARIABLES.            */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        A030D_SOP_EDW_DATE       =    '2017-01-02'             */
     /* NOTE:  2.        A030D_EOP_EDW_DATE       =    '2017-01-31'             */
     /*                                                                         */
     /*=========================================================================*/

     A001M_SOP_EDW_DATE    =    "'" || PUT( A001M_SOP_DATE, YYMMDDD10. ) || "'" ;
     A001M_EOP_EDW_DATE    =    "'" || PUT( A001M_EOP_DATE, YYMMDDD10. ) || "'" ;

     A003M_SOP_EDW_DATE    =    "'" || PUT( A003M_SOP_DATE, YYMMDDD10. ) || "'" ;
     A003M_EOP_EDW_DATE    =    "'" || PUT( A003M_EOP_DATE, YYMMDDD10. ) || "'" ;

     A006M_SOP_EDW_DATE    =    "'" || PUT( A006M_SOP_DATE, YYMMDDD10. ) || "'" ;
     A006M_EOP_EDW_DATE    =    "'" || PUT( A006M_EOP_DATE, YYMMDDD10. ) || "'" ;


     /*=========================================================================*/
     /*                                                                         */
     /* 3.     CREATE    ACTIVE DAYS - EDW DATE STRING MACRO VARIABLES.         */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        M00_A030D_SOP_EDW_DATE   =    '2017-01-01'             */
     /* NOTE:  2.        M00_A030D_EOP_EDW_DATE   =    '2017-01-31'             */
     /*                                                                         */
     /*=========================================================================*/

     CALL SYMPUT( STRIP(PREFIX) || '_A030D_SOP_EDW_DATE' , A030D_SOP_EDW_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A030D_EOP_EDW_DATE' , A030D_EOP_EDW_DATE );

     CALL SYMPUT( STRIP(PREFIX) || '_A090D_SOP_EDW_DATE' , A090D_SOP_EDW_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A090D_EOP_EDW_DATE' , A090D_EOP_EDW_DATE );

     CALL SYMPUT( STRIP(PREFIX) || '_A180D_SOP_EDW_DATE' , A180D_SOP_EDW_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A180D_EOP_EDW_DATE' , A180D_EOP_EDW_DATE );


     /*=========================================================================*/
     /*                                                                         */
     /* 4.     CREATE    ACTIVE MTHS - EDW DATE STRING MACRO VARIABLES.         */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* NOTE:  1.        M00_A001M_SOP_EDW_DATE   =    '2017-01-01'             */
     /* NOTE:  2.        M00_A001M_EOP_EDW_DATE   =    '2017-01-31'             */
     /*                                                                         */
     /*=========================================================================*/

     CALL SYMPUT( STRIP(PREFIX) || '_A001M_SOP_EDW_DATE' , A001M_SOP_EDW_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A001M_EOP_EDW_DATE' , A001M_EOP_EDW_DATE );

     CALL SYMPUT( STRIP(PREFIX) || '_A003M_SOP_EDW_DATE' , A003M_SOP_EDW_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A003M_EOP_EDW_DATE' , A003M_EOP_EDW_DATE );

     CALL SYMPUT( STRIP(PREFIX) || '_A006M_SOP_EDW_DATE' , A006M_SOP_EDW_DATE );
     CALL SYMPUT( STRIP(PREFIX) || '_A006M_EOP_EDW_DATE' , A006M_EOP_EDW_DATE );

RUN;

%END;


%DISPLAY_ACTIVE_DATES(
 PERIODS  = &PERIODS.,
 TYPE     = &TYPE.
 ); RUN;



%MEND;
/*OPTIONS MACROGEN SYMBOLGEN MLOGIC MPRINT mtrace NOTES source source2; RUN;*/
/*OPTIONS NOMACROGEN NOSYMBOLGEN NOMLOGIC NOMTRACE;*/
/*%GET_ACTIVE_DATES(*/
/* OUTLIB   = WORK,*/
/* OUT      = ACTIVE_DATES,*/
/* GEN      = -2,*/
/* PERIODS  = 16,*/
/* PREFIX   = M,*/
/* TYPE     = EDW*/
/* ); RUN;*/
