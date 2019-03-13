/*==============================================================================*/
/* MACRO:           GET_P3M_REPORT_DATES                                        */
/* ---------------------------------------------------------------------------- */
/* PURPOSE:    1.   GET THE PAST 3 MONTHS AS OF RELATIVE GENERATION MONTH.      */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* SYNTAX:     1.   %GET_P3M_REPORT_DATES                                       */
/*                   GEN      = <RELATIVE-GENERATION-NO> ,                      */
/*                   OUTLIB   = <OUTPUT-SAS-LIBRARY>     ,                      */
/*                   OUT      = <OUTPUT-SAS-TABLE>                              */
/*                   ); RUN;                                                    */
/*============+=================================================================*/

%MACRO GET_P3M_REPORT_DATES(
 GEN      = -1,
 OUTLIB   = WORK,
 OUT      = P3M_REPORT_DATES
 );

/*==============================================================================*/
/* STEP 01000       GENERATE PAST 3 MONTHS AS OF A RELATIVE GENERATION.         */
/*==============================================================================*/

DATA &OUTLIB..&OUT.;

     /*-------------------------------------------------------------------------*/
     /* 1.          DEFINE BASE END OF MONTH DATE.                              */
     /*-------------------------------------------------------------------------*/

     BASE_EOQ_IND   =    1;

     TIME_EOM_DATE  =    INTNX( 'MONTH', TODAY(), &GEN., 'E'); OUTPUT;

     /*-------------------------------------------------------------------------*/
     /* 2.          GENERATE MONTHLY DATE RECORDS FOR THE PAST THREE MONTHS.    */
     /*-------------------------------------------------------------------------*/

     DO I = 1 TO 2;
     TIME_EOM_DATE  =    INTNX('MONTH',TIME_EOM_DATE,-I,'E'); OUTPUT;
     END;

     FORMAT TIME_EOM_DATE     DATE9.;

RUN;


/*==============================================================================*/
/*                                                                              */
/* STEP 02000       SORT PAST 3 MONTHS BY DESCENDING MONTH END DATES.           */
/*                                                                              */
/*==============================================================================*/

PROC SORT DATA = &OUTLIB..&OUT.;
     BY   
     BASE_EOQ_IND 
     DESCENDING TIME_EOM_DATE;
RUN;


/*==============================================================================*/
/*                                                                              */
/* STEP 03000       CALC REPORT END OF QUARTER DATES.                           */
/*                                                                              */
/*==============================================================================*/

DATA &OUTLIB..&OUT.;

     /*-------------------------------------------------------------------------*/
     /* 1.     DEFINE    LENGTH AND ORDER OF COLUMNS.                           */
     /*-------------------------------------------------------------------------*/

     LENGTH    
     REPT_EOQ_DATE       8.
     TIME_EOM_DATE       8.;

     /*-------------------------------------------------------------------------*/
     /* 2.     READ      PAST 3 MONTHS OF DATES.                                */
     /*-------------------------------------------------------------------------*/

     SET       &OUTLIB..&OUT.;

     BY        BASE_EOQ_IND;

     /*-------------------------------------------------------------------------*/
     /* 3.     DEFINE    REPORT END OF QUARTER DATE.                            */
     /*-------------------------------------------------------------------------*/

     IF        FIRST.BASE_EOQ_IND 

     THEN      REPT_EOQ_DATE  = TIME_EOM_DATE;

     /*-------------------------------------------------------------------------*/
     /* 4.     RETAIN    REPORT END OF QUARTER DATE.                            */
     /*-------------------------------------------------------------------------*/

     RETAIN    
     REPT_EOQ_DATE;

     /*-------------------------------------------------------------------------*/
     /* 5.     DEFINE    SAS FORMATS                                            */
     /*-------------------------------------------------------------------------*/

     FORMAT
     REPT_EOQ_DATE  DATE9.
     TIME_EOM_DATE  DATE9.;

     /*-------------------------------------------------------------------------*/
     /* 6.     DROP      SAS COLUMNS                                            */
     /*-------------------------------------------------------------------------*/

     DROP
     I
     BASE_EOQ_IND;

RUN;


/*==============================================================================*/
/*                                                                              */
/* STEP 04000       SORT BY ASCENDING TIME EOM DATES.                           */
/*                                                                              */
/*==============================================================================*/

PROC SORT DATA = &OUTLIB..&OUT.;
     BY   TIME_EOM_DATE;
RUN;


%MEND;
/*%GET_P3M_REPORT_DATES(GEN=-2); RUN;*/