/*==============================================================================*/
/* PURPOSE:    1.   Exports a SAS dataset to a PSF file.                        */
/* ---------------------------------------------------------------------------- */
/* PARMS:      1.   STEP      =    SPECIFY A STEP NUMBER.                       */
/*                                                                              */
/*             2.   TITLE     =    GENERATE A TITLE MESSAGE BOX.                */
/*                                                                              */
/*             3.   LIB       =    SPECIFY THE INPUT SAS LIBRARY NAME.          */
/*                                                                              */
/*             4.   DATA      =    SPECIFY THE INPUT SAS DATASET NAME.          */
/*                                                                              */
/*             5.   SUFFIX    =    SPECIFY THE DATASET SUFFIX DATE ( YYYYMM )   */
/*                                                                              */
/*             6.   OUTPATH   =    SPECIFY THE OUTPUT DIRECTORY PATH.           */
/*                                                                              */
/*             7.   OUT       =    SPECIFY THE OUTPUT DATASET NAME.             */
/*                                                                              */
/*             6.   EXT       =    SPECIFY THE OUTPUT EXTENSION.                */
/*============+=================================================================*/
%MACRO PROC_EXPORT_PSV(
 STEP     = 13000,                           /* STEP NUMBER FOR TITLE BOX.      */
 TITLE    = EXPORT TABLE TO A PSV FILE,      /* TITLE FOR THE TITLE BOX.        */

 LIB      = WORK,                            /* INPUT SAS LIBRARY.              */
 DATA     = NULL,                            /* INPUT SAS DATASET.              */
 DATASFX  = NULL,                            /* INPUT DATA SUFFIX.              */

 OUTPATH  = NULL,                            /* OUTPUT PATH                     */
 OUT      = psv_file,                        /* OUTPUT DATASET NAME OF PSV FILE */
 OUTSFX   = NULL,                            /* SUFFIX FILE DATE ( YYYYMM )     */

 EXT      = psv,                             /* EXTENSION OF PSV FILE.          */
 );                                          /*---------------------------------*/

 
%IF       %UPCASE(&DATASFX.)   NE   NULL
    %THEN     %LET DATA           =    &DATA._&DATASFX.;
    %ELSE     %LET DATA           =    &DATA.;

%IF       %UPCASE(&OUTSFX.)   NE   NULL
    %THEN     %LET OUT            =    &OUT._&OUTSFX.;
    %ELSE     %LET OUT            =    &OUT.;

/*==============================================================================*/
/* STEP 04000  LOCAL     GENERATE REMOTE SUBMIT STATEMENTS.                     */
/*==============================================================================*/

    %SYSLPUT  LIB       = &LIB.;
    %SYSLPUT  DATA      = &DATA.;
    %SYSLPUT  OUTPATH   = &OUTPATH.;
    %SYSLPUT  OUT       = &OUT.;
    %SYSLPUT  EXT       = &EXT.;

/*==============================================================================*/
/*                                                                              */
/* STEP 05000  REMOTE    EXPORT THE TABLE TO A PSV FILE.                        */
/*                                                                              */
/*==============================================================================*/

PROC EXPORT DATA = &LIB..&DATA.
     OUTFILE     = "&OUTPATH./&OUT..&EXT."
     DBMS        = DLM
     REPLACE;
     DELIMITER   = '|';
RUN;

/*==============================================================================*/
/*                                                                              */
/* OUTR 09000  LOCAL     DISPLAY ENDING SAS MACRO TITLE BOX.                    */
/*                                                                              */
/*==============================================================================*/

%SAS_TITLE; RUN;


%MEND;
/*%PROC_EXPORT_PSV(*/
/* STEP        = 13000,*/
/* TITLE       = EXPORT THE TABLE TO A PSV FILE,*/
/* LIB         = APPXHIS,*/
/* DATA        = ADVISOR_CHANNEL,*/
/* DATASFX     = NULL,*/
/* OUTPATH     = &APPXMTH.,*/
/* OUT         = cca_advisor_channel,*/
/* OUTSFX      = &CUR_EOM_YYM_DATE.,*/
/* EXT         = psv*/
/* ); RUN;*/
