/*==============================================================================*/ 
/* Macro:           GET_P3M_QTR_DATES                                           */
/* ---------------------------------------------------------------------------- */
/* Purpose:    1.   GENERATES QUARTERLY SOQ=START OF QTR, EOQ=END-OF-QTR.       */
/*============+=================================================================*/ 
%MACRO GET_P3M_QTR_DATES(
 OUTlib   = work,
 OUT      = P3M_QTR_DATES,
 OUTSFX   = NULL,
 PERIODS  = 24,
 GEN      = -1
 );


/*==============================================================================*/
/*                                                                              */
/* step 01000       BUILD THE OUT PARAMETER USING OUTSFX VARIABLE ( YYYYMM )    */
/*                                                                              */
/*==============================================================================*/

%IF  %UPCASE(&OUTSFX.)   NE   NULL           %THEN %DO;

     %LET OUT            =    &OUT._&OUTSFX.;

%END;


/*==============================================================================*/ 
/* step 02000       BUILD THE OUT PARAMETER USING OUTSFX VARIABLE ( YYYYMM )    */
/*==============================================================================*/ 

%SYSLPUT OUTLIB     = &OUTLIB.;
%SYSLPUT OUT        = &OUT.;
%SYSLPUT PERIODS    = &PERIODS.;
%SYSLPUT GEN        = &GEN.;

/*==============================================================================*/ 
/* step 02000       GENERATE QUARTERLY DATES FOR EACH MONTH.                    */
/* ---------------------------------------------------------------------------- */
/* Note:       1.   generates a series of past 3 months quarterly date ranges.  */
/*==============================================================================*/ 

data &outlib..&out.;

     /*-------------------------------------------------------------------------*/ 
     /*   1.        Define the base current date ( todays date )                */
     /*-------------------------------------------------------------------------*/ 

     CUR_SAS_DATE        =    TODAY();
     FORMAT
     CUR_SAS_DATE             DATE9.;

     /*-------------------------------------------------------------------------*/ 
     /*   2.        Define the base current month.                              */
     /*-------------------------------------------------------------------------*/ 

     BASE_MTH_SAS_DATE   =    intnx( 'month' , CUR_SAS_DATE,  &gen. , 'e' );
     FORMAT
     BASE_MTH_SAS_DATE        date9.;

     /*-------------------------------------------------------------------------*/ 
     /*   3.        Define the base current date.                               */
     /*-------------------------------------------------------------------------*/ 

     i                   =    1;

     P3M_SOQ_SAS_DATE    =    intnx( 'month' , BASE_MTH_SAS_DATE, -2, 'b' );
     P3M_EOQ_SAS_DATE    =    intnx( 'month' , BASE_MTH_SAS_DATE,  0, 'e' );

     FORMAT
 
     P3M_SOQ_SAS_DATE         date9.
     P3M_EOQ_SAS_DATE         date9.;

     OUTPUT;

     /*-------------------------------------------------------------------------*/ 
     /*   4.        Define the base current date.                               */
     /*-------------------------------------------------------------------------*/ 

     DO   I = 2 TO &periods.;

          P3M_SOQ_SAS_DATE    =   intnx( 'month' , P3M_SOQ_SAS_DATE, -1, 'b' );
          P3M_EOQ_SAS_DATE    =   intnx( 'month' , P3M_EOQ_SAS_DATE, -1, 'e' );
          OUTPUT;

     END;
RUN;


/*==============================================================================*/ 
/*                                                                              */
/* step 01000       BUILD THE OUT PARAMETER USING OUTSFX VARIABLE ( YYYYMM )    */
/*                                                                              */
/*==============================================================================*/ 

%MEND;
/*%GET_P3M_QTR_DATES(*/
/* OUTLIB=APPXDAT,*/
/* GEN=-1,*/
/* PERIODS=24);*/
/* RUN;*/
