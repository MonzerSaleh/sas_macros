/*==============================================================================*/
/* MACRO:           CALC_DATE_FORMATS                                           */
/* DESCR:			Take a sas date and converts it into 90 diff formats        */
/* ---------------------------------------------------------------------------- */
/* SYNTAX:     1.   %CALC_ACTIVE_TIME_DATES(                                    */
/*                   DATE     = <SAS DATE NUMBER> OR <SAS DATE LITERAL>         */
/*                   PERIODS  = <SPECIFY NO OF MONTHLY PERIODS>                 */
/*                   ); RUN;                                                    */
/* ---------------------------------------------------------------------------- */
/* PARMS:      1.   DATE      = SPECIFY THE ENDING PERIODS DATE.                */
/*             2.   PERIODS   = SPECIFY THE NOMBER OF PERIODS TO BE CREATED.    */
/* ============================================================================ */
/* A03M_      ACTIVE  3 MONTH  		SOP 	START OF PERIOD						*/
/* A02M_      ACTIVE  2 MONTH  		EOP		END OF PERIOD						*/
/* A01M_      ACTIVE  1 MONTH  													*/
/* A30D_      ACTIVE 30 DAYS           											*/
/* A60D_      ACTIVE 60 DAYS           											*/
/* A90D_      ACTIVE 90 DAYS           											*/
/*==============================================================================*/

%MACRO CALC_DATE_FORMATS(
 DATE          = NOW(),
 PERIODS       = 6,
 INCLUSIVE     = YES,
 DEBUG         = NO
 );

	%IF  %UPCASE(&DEBUG.) = YES %THEN %DO;
		OPTIONS MPRINT SYMBOLGEN SOURCE NOTES MLOGIC;
	%END;
	%ELSE %DO;
		OPTIONS NOSYMBOLGEN NOMLOGIC NOMPRINT;
	%END;

	%LET INCLUSIVE = %UPCASE(&INCLUSIVE.);

%MACRO CALC_ACTIVE_DATES(
	 PFX1          = A30,
	 PFX2          = SOM,
	 PERIOD        = MONTH,
	 DATE          = TODAY(),
	 GEN           = -1,
	 LOC           = B,
	 INCLUSIVE     = YES
);


%LOCAL    INCLUSIVE_STR;

	%IF       %UPCASE(&INCLUSIVE.)     =    YES 
		AND       %UPCASE(&TYPE.)          =    DAYPER
	%THEN     %LET INCLUSIVE_STR       =    %STR( + 1 );
	%ELSE     %LET INCLUSIVE_STR       =    %STR( + 0 );


%GLOBAL        &PFX1._&PFX2._SAS_DATE;
%GLOBAL        &PFX1._&PFX2._ORA_DATE;
%GLOBAL        &PFX1._&PFX2._DBW_DATE;

%GLOBAL        &PFX1._&PFX2._YMDDL_DATE;

%GLOBAL        &PFX1._&PFX2._YYMMN_DATE;
%GLOBAL        &PFX1._&PFX2._YYM_DATE;

%GLOBAL        &PFX1._&PFX2._YEAR_DATE;



DATA &PFX1._&PFX2._&PERIOD.;


     BASE_DATE = &DATE.;
     FORMAT    BASE_DATE     DATE9.; 

     %IF       %UPCASE(&LOC.) = B
	     OR    %UPCASE(&LOC.) = S  %THEN %DO;
     &PFX1._&PFX2._SAS_DATE = INTNX( "&PERIOD.", BASE_DATE, &GEN., "&LOC." ) &inclusive_str.;
     %END;
     %IF       %UPCASE(&LOC.) = E %THEN %DO;
	     &PFX1._&PFX2._SAS_DATE = INTNX( "&PERIOD.", BASE_DATE, &GEN., "&LOC." );
     %END;
     FORMAT    &PFX1._&PFX2._SAS_DATE   DATE9.;

     &PFX1._BASE_DATE         =         PUT( BASE_DATE, YYMMDDD10. );
     &pfx1._&pfx2._ORA_DATE   = "'" ||  PUT( &pfx1._&pfx2._SAS_DATE , DATE9.     ) || "'D";
     &pfx1._&pfx2._DBW_DATE   = "'" ||  PUT( &pfx1._&pfx2._SAS_DATE , YYMMDDD10. ) || "'";
     &pfx1._&pfx2._YMDDL_DATE =         PUT( &pfx1._&pfx2._SAS_DATE , YYMMDDD10. );
     &pfx1._&pfx2._YYMMN_DATE =         PUT( &pfx1._&pfx2._SAS_DATE , YYMMN6.    );
     &pfx1._&pfx2._YYM_DATE   =         PUT( &pfx1._&pfx2._SAS_DATE , YYMMN6.    );
     &pfx1._&pfx2._YEAR_DATE  =         PUT( &pfx1._&pfx2._SAS_DATE , YEAR4.     );


     CALL SYMPUT( "&pfx1._BASE_DATE"         , LEFT( &pfx1._BASE_DATE           ) );

     CALL SYMPUT( "&pfx1._&pfx2._SAS_DATE"   , LEFT( &pfx1._&pfx2._SAS_DATE     ) );

     CALL SYMPUT( "&pfx1._&pfx2._ORA_DATE"   , LEFT( &pfx1._&pfx2._ORA_DATE     ) );

     CALL SYMPUT( "&pfx1._&pfx2._DBW_DATE"   , LEFT( &pfx1._&pfx2._DBW_DATE     ) );

     CALL SYMPUT( "&pfx1._&pfx2._YMDDL_DATE" , LEFT( &pfx1._&pfx2._YMDDL_DATE   ) );

     CALL SYMPUT( "&pfx1._&pfx2._YYMMN_DATE" , LEFT( &pfx1._&pfx2._YYMMN_DATE   ) );
     CALL SYMPUT( "&pfx1._&pfx2._YYM_DATE"   , LEFT( &pfx1._&pfx2._YYM_DATE     ) );

     CALL SYMPUT( "&pfx1._&pfx2._YEAR_DATE"  , LEFT( &pfx1._&pfx2._YEAR_DATE    ) );

RUN;


/*==============================================================================*/
/*                                                                              */
/* STEP 03030  ACTIVE-DATES             DISPLAY MACRO VARIABLES                 */
/*                                                                              */
/*==============================================================================*/

%PUT;
%PUT NOTE: ==============================================================================;
%PUT NOTE: TITLE:   ACTIVE_DATES:       &PFX1. &PFX2. DATES ;
%PUT NOTE: ;
%PUT NOTE: ;
%PUT NOTE: PFX1                      = &PFX1.;
%PUT NOTE: PFX2                      = &PFX2.;
%PUT NOTE: PERIODS                   = &PERIODS.;
%PUT NOTE: GEN                       = &GEN.;
%PUT NOTE: ;
%PUT NOTE: &PFX1._BASE_DATE          = &&&PFX1._BASE_DATE.;
%PUT NOTE: ;
%PUT NOTE: &PFX1._&PFX2._SAS_DATE       = &&&PFX1._&PFX2._SAS_DATE.;
%PUT NOTE: &PFX1._&PFX2._ORA_DATE       = &&&PFX1._&PFX2._ORA_DATE.;
%PUT NOTE: &PFX1._&PFX2._DBW_DATE       = &&&PFX1._&PFX2._DBW_DATE.;
%PUT NOTE: &PFX1._&PFX2._YMDDL_DATE     = &&&PFX1._&PFX2._YMDDL_DATE.;
%PUT NOTE: &PFX1._&PFX2._YYMMN_DATE     = &&&PFX1._&PFX2._YYMMN_DATE.;
%PUT NOTE: &PFX1._&PFX2._YYM_DATE       = &&&PFX1._&PFX2._YYM_DATE.;
%PUT NOTE: &PFX1._&PFX2._YEAR_DATE      = &&&PFX1._&PFX2._YEAR_DATE.;
%PUT NOTE: ;
%PUT NOTE: ;
%PUT NOTE: ==============================================================================;
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
/* STEP 04030  ACTIVE-DAY-PERIODS       DISPLAY PARMS TO THE SAS LOG            */
/*                                                                              */
/*==============================================================================*/

%PUT;
%PUT NOTE: ==============================================================================;
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
%PUT NOTE:;
%PUT NOTE: ==============================================================================;
%PUT;


%DO  PERIOD_NO = 1  %TO &PERIODS. %BY 1;
     %IF  %UPCASE(&TYPE.)          =    DAYPER         %THEN %DO;
          %LET      PERIOD_TYP     =    DAY;
          %LET      PERIOD_STA     =    SOP;
          %LET      PERIOD_END     =    EOP;

          %LET      PREFIX_COL     =    %EVAL( &PERIOD_NO. * &PERIOD_UNIT. );
          %LET      PREFIX_COL     =    %SYSFUNC( PUTN( &PREFIX_COL. , Z3. ) );
          %LET      PREFIX_COL     =    A&PREFIX_COL.D;
          %LET      STA_GEN        =    %EVAL( &PERIOD_NO. * &PERIOD_UNIT. );
          %LET      STA_GEN        =    %SYSFUNC( PUTN( &STA_GEN. , Z3. ) );
          %LET      END_GEN        =    0;

          %PUT NOTE: STA_GEN       =    &STA_GEN.;
          %PUT NOTE: END_GEN       =    &END_GEN.;

     %END;

     %IF  %UPCASE(&TYPE.)          =    MTHPER         %THEN %DO;
     
          %LET PERIOD_TYP          =    MONTH;
          %LET PERIOD_STA          =    SOP;
          %LET PERIOD_END          =    EOP;

          %LET PREFIX_COL          =    %EVAL( &PERIOD_NO. );
          %LET PREFIX_COL          =    %SYSFUNC( PUTN( &PREFIX_COL. , Z3. ) );
          %LET PREFIX_COL          =    A&PREFIX_COL.M;

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

     %CALC_ACTIVE_DATES( 
                                   /*-------------------------------------------*/
     PFX1      = &PREFIX_COL.,     /* WHEN: DAYPER  =  A&PREFIX_NUM.D           */
                                   /* WHEN: MTHPER  =  A&PREFIX_NUM.M           */
                                   /* WHEN: MONTH   =  A&PREFIX_NUM.M           */
                                   /*-------------------------------------------*/
     PFX2      = &PERIOD_STA.,     /* WHEN: DAYPER  =  EOP   - END OF PERIOD    */
                                   /* WHEN: MTHPER  =  EOP   - END OF PERIOD    */
                                   /* WHEN: MONTH   =  EOM   - END OF MONTH     */
                                   /*-------------------------------------------*/
     PERIOD    = &PERIOD_TYP.,     /* WHEN: DAYPER  =  DAY   - ADVANCE BY DAY   */
                                   /* WHEN: MTHPER  =  MONTH - ADVANCE BY MTH   */
                                   /* WHEN: MONTH   =  MONTH - ADVANCE BY MTH   */
                                   /*-------------------------------------------*/
     DATE      = &DATE.,           /* ALWAYS: USE:  =  EOM DATE: '30APR2-17'D   */
                                   /*-------------------------------------------*/
     GEN       = -&STA_GEN.,       /* ALWAYS: USE:  =  CALCULATE PERIOD GEN.    */
                                   /*-------------------------------------------*/
     LOC       = B,                /* ALWAYS: USE:  =  'E'                      */
                                   /*-------------------------------------------*/
     INCLUSIVE = &INCLUSIVE.
     ); RUN;



     /*-------------------------------------------------------------------------*/
     /*                                                                         */
     /* 5.     ACTIVE-DATES        CALCUATE END OF PERIOD DATE.                 */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/

     %CALC_ACTIVE_DATES(                
                                   /*-------------------------------------------*/
     PFX1      = &PREFIX_COL.,     /* WHEN: DAYPER  =  A&PREFIX_NUM.D           */
                                   /* WHEN: MTHPER  =  A&PREFIX_NUM.M           */
                                   /* WHEN: MONTH   =  A&PREFIX_NUM.M           */
                                   /*-------------------------------------------*/
     PFX2      = &PERIOD_END.,     /* WHEN: DAYPER  =  EOP   - END OF PERIOD    */
                                   /* WHEN: MTHPER  =  EOP   - END OF PERIOD    */
                                   /* WHEN: MONTH   =  EOM   - END OF MONTH     */
                                   /*-------------------------------------------*/
     PERIOD    = &PERIOD_TYP.,     /* WHEN: DAYPER  =  DAY   - ADVANCE BY DAY   */
                                   /* WHEN: MTHPER  =  MONTH - ADVANCE BY MTH   */
                                   /* WHEN: MONTH   =  MONTH - ADVANCE BY MTH   */
                                   /*-------------------------------------------*/
     DATE      = &DATE.,           /* ALWAYS: USE:  =  EOM DATE: '30APR2-17'D   */
                                   /*-------------------------------------------*/
     GEN       = -&END_GEN.,       /* ALWAYS: USE:  =  0                        */
                                   /*-------------------------------------------*/
     LOC       = E,                /* ALWAYS: USE:  =  'E'                      */
                                   /*-------------------------------------------*/

     INCLUSIVE = &INCLUSIVE.
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
 INCLUSIVE     = &INCLUSIVE.,
 PERIODS       = &PERIODS.,
 DATE          = &DATE.
 ); RUN;

%CALC_ACTIVE_PERIODS(
 TYPE          = MTHPER,
 INCLUSIVE     = &INCLUSIVE.,
 PERIODS       = &PERIODS.,
 DATE          = &DATE.
 ); RUN;

%CALC_ACTIVE_PERIODS(
 TYPE          = CALMTH,
 INCLUSIVE     = &INCLUSIVE.,
 PERIODS       = &PERIODS.,
 DATE          = &DATE.
 ); RUN;



/*==============================================================================*/
/*                                                                              */
/* STEP 05000  RESET OPTIONS                                                    */
/*                                                                              */
/*==============================================================================*/

OPTIONS NOMACROGEN NOSYMBOLGEN NOMLOGIC MPRINT;


%MEND;

%calc_date_formats(
 INCLUSIVE     = YES,
 PERIODS       = 6,
 DATE          = '31DEC2017'D  ); RUN;

