/*==============================================================================*/
/* purpose:    This sas macro is designed to export a sas dataset to a          */
/*             microsoft excel file.                                            */
/*==============================================================================*/
%MACRO PROC_EXPORT_EXCEL(
 LIB      = NULL,        /* LIB         =    INPUT SAS LIBRARY.                 */
 DATA     = NULL,        /* DATA        =    INPUT SAS DATASET NAME.            */
 DATASFX  = NULL,        /* DATASFX     =    INPUT SAS DATASET SUFFIX.          */
                         /*                  DEFAULT:  NULL                     */
                         /*                  OPTIONS:  201803                   */
 OUTLIB   = APPXOUT,     /* OUTLIB.     =    OUTPUT LIBRARY.                    */
 OUTPATH  = &APPXOUT.,   /* OUTPATH.    =    OUTPUT DIRECTOR PATH.              */
 OUT      = NULL,        /* OUT         =    OUTPUT EXCEL FILE NAME.            */
 OUTSFX   = NULL,        /* OUTSFX      =    OUTPUT EXCEL FILE DATE SUFFIX.     */
 EXT      = XLSX,        /* EXT         =    OUTPUT EXCEL FILE EXTENSION.       */
                         /*                  xls                                */
                         /*                  xlsx                               */
 SHEET    = NULL,        /* SHEET.           SPECIFY NAME OF WORKSHEET.         */
 REPLACE  = YES,         /* REPLACE          REPLACE WORKSHEET OPTION.          */
                         /*                  OPTIONS:  YES = REPLACE WORKSHEET. */
                         /*                            NO  = BLANK.             */
 TIMESTAMP = NULL,       /* TIMESTAMP   =    USE A FILE TIME STAMP.             */
                         /*                  DEFAULT: NULL                      */
 OUTVER   = OBSOLETE,    /* OUTVER      =    OBSOLETE OPTION.                   */
 DBMS     = OBSOLETE     /* DBMS        =    OBSOLETE OPTION.                   */
 );

/*==============================================================================*/
/* STEP 01000       BUILD DATA PARM ATTACHING DATASFX VALUE WHEN NOT NULL.      */
/*==============================================================================*/
%IF       %UPCASE(&DATASFX.)  NE   NULL           %THEN %DO;
          %LET DATA           =    &DATA._&DATASFX.;
%END;

/*==============================================================================*/
/* STEP 02000       BUILD OUT PARM BY ATTACHING OUTSFX VALUE WHEN NOT NULL.     */
/*==============================================================================*/
%IF       %UPCASE(&OUTSFX.)   NE   NULL           %THEN %DO;
          %LET OUT            =    &OUT._&OUTSFX.;
%END;

/*==============================================================================*/
/* STEP 03000       CONVERT REPLACE OPTION.                                     */
/* ---------------------------------------------------------------------------- */
/* OPTIONS:    1.   REPLACE   = YES     = REPLACE                               */
/*             2.   REPLACE   = NO      = %STR ( )                              */
/*==============================================================================*/

%LET      REPLACE        = %UPCASE(&REPLACE.);

    %IF       &REPLACE.      = YES 
    %THEN     %LET REPLACE   = REPLACE;
    %ELSE     %LET REPLACE   = %STR( );

/*==============================================================================*/
/* STEP 04000       CONVERT THE OUTPUT FILE EXTENSION TO UPPER CASE FOR TESTING.*/
/*==============================================================================*/

%LET      OUTEXT    = %LOWCASE(&EXT.);

/*==============================================================================*/
/* STEP 05000       CONVERT FILE EXTENSION TO LOWER CASE FOR FILE DEFINITION    */
/*==============================================================================*/

%LET      FILEEXT   = %UPCASE(&EXT.);

/*==============================================================================*/
/* STEP 06000       DEFINE THE DEFAULT SHEET AS THE OUT PARM VALUE.             */
/*==============================================================================*/

%IF       %UPCASE(&SHEET.)    = NULL    %THEN %DO;
          %LET SHEET          = &OUT.;
%END;

/*==============================================================================*/
/* step 07000       Define the Operating System Deliminators.                   */
/*==============================================================================*/

%LET      WINDLM    =    %str(\);
%LET      WINSYS    =    WIN;

%GLOBAL   OUTDLM;
%GLOBAL   OUTSYS;

%LET      OUTDLM              =    %STR(\);
%LET      OUTSYS              =    WIN;

/*==============================================================================*/
/* STEP 09000       ATTACH FILE TIMESTAMP TO THE OUT MACRO VARIABLE.            */
/*==============================================================================*/

%FILE_TIMESTAMP; RUN;

%IF       &SYSVER.                 =    9.3
AND       &OUTSYS.                 =    AIX       %THEN %DO;

          %LET OUT = &OUT._&FILE_TIMESTAMP.;
%END;

%ELSE %IF %UPCASE(&TIMESTAMP.)     =    YES       %THEN %DO;

          %LET OUT = &OUT._&FILE_TIMESTAMP.;
%END;




/*==============================================================================*/
/*                                                                              */
/* step 10000       Display the SAS macro parameters to the sas log.            */
/*                                                                              */
/*==============================================================================*/

%put NOTE: ;
%put NOTE: &dline.;
%put NOTE: Macro:   PROC_EXPORT_EXCEL;
%put NOTE: ;
%put NOTE: ;
%put NOTE: INPUT  PARMS:;
%put NOTE: ============;
%put NOTE: ;
%put NOTE: LIB                => &LIB.; 
%put NOTE: DATA               => &DATA.; 
%put NOTE: ;
%put NOTE: ;
%put NOTE: OUTPUT PARMS:;
%put NOTE: ============;
%put NOTE: ;
%put NOTE: OUTLIB             => &OUTLIB.; 
%put NOTE: OUTPATH            => &OUTPATH.;
%put NOTE: OUT                => &OUT.; 
%put NOTE: OUTEXT             => &OUTEXT.;
%put NOTE: ;
%put NOTE: REPLACE            => &REPLACE.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: OUTPUT OPTIONS:;
%put NOTE: ==============;
%put NOTE: ;
%put NOTE: TIMESTAMP          => &TIMESTAMP.;
%put NOTE: ;
%put NOTE: FILE_TIMESTAMP     => &FILE_TIMESTAMP.;
%put NOTE: ;
%put NOTE: SYSVER             => &SYSVER.;
%put NOTE: FILEEXT            => &FILEEXT.;
%put NOTE: ;
%put NOTE: WINDLM             => &WINDLM.; 
%put NOTE: WINSYS             => &WINSYS.;
%put NOTE: ;
%put NOTE: AIXDLM             => &AIXDLM.; 
%put NOTE: AIXSYS             => &AIXSYS.;
%put NOTE: ;
%put NOTE: OUTDLM             => &OUTDLM.; 
%put NOTE: OUTSYS             => &OUTSYS.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: OBSOLETE PARMS:;
%put NOTE: ==============;
%put NOTE: ;
%put NOTE: OUTVER   => &OUTVER.;
%put NOTE: DBMS     => &DBMS.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: &dline.;
%put NOTE: ;



/*------------------------------------------------------------------------------*/
/* step 12032s WIN  SAS 9.3   32-BIT    Excel 2010 xls files.                   */
/*------------------------------------------------------------------------------*/

%IF            &OUTSYS.                 =    WIN
AND            &SYSVER.                 =    9.3                
AND            &FILEEXT.                =    XLS
%THEN %DO; 

PROC EXPORT    DATA                     =    &LIB..&DATA.
               OUTFILE                  =    "&OUTPATH.&OUTDLM.&OUT..&OUTEXT."
               DBMS                     =    xls  
               &REPLACE.;

               SHEET                    =    "&SHEET.";
RUN;

%END;


/*------------------------------------------------------------------------------*/
/* step 12032x WIN  SAS 9.3   32-BIT    Excel 2010 xlsx files.                  */
/*------------------------------------------------------------------------------*/

%IF            &OUTSYS.                 =    WIN
AND            &SYSVER.                 =    9.3                
AND            &FILEEXT.                =    XLSX
%THEN %DO;     

PROC EXPORT    DATA                     =    &LIB..&DATA.
               OUTFILE                  =    "&OUTPATH.&OUTDLM.&OUT..&OUTEXT."
               DBMS                     =    xlsx 
               &REPLACE.;

               SHEET                    =    "&SHEET.";
RUN;

%END;

%MEND; /* OF PROC EXPORT EXCEL FILE */
/*DATA bob; X=1; RUN;*/
/*OPTIONS MACROGEN SYMBOLGEN MLOGIC MPRINT SOURCE;*/
/*%PROC_EXPORT_EXCEL( */
/* LIB           = APPXDAT,*/
/* DATA          = CUST_COUNTS,*/
/* DATASFX       = NULL,*/
/* OUTLIB        = APPXOUT,*/
/* OUTPATH       = &APPXOUT.,*/
/* OUT           = &SAS_JOBNAME.,*/
/* OUTSFX        = NULL,*/
/* EXT           = XLSX,*/
/* SHEET         = CUST_COUNTS,*/
/* REPLACE       = YES*/
/* ); run;*/
