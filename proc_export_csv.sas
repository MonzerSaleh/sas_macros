/*==============================================================================*/
/* PURPOSE:    1.   This sas macro is designed to export a sas dataset to a     */
/*                  csv file.                                                   */
/*==============================================================================*/
%MACRO PROC_EXPORT_CSV(
 LIB           = NULL,
 DATA          = NULL,
 DATASFX       = NULL,
 OUTLIB        = appxout,
 OUTPATH       = &appxout.,
 OUT           = PROC_EXPORT_CSV,
 OUTSFX        = NULL,
 ext           = CSV
 );

/*==============================================================================*/
/*                                                                              */
/* STEP 02000       BUILD DATA PARAMETER BASED ON VALUES OF DATA AND DATASFX.   */
/*                                                                              */
/*==============================================================================*/

%IF       %UPCASE(&DATASFX.)  NE   NULL 

%THEN     %LET DATA           =    &DATA._&DATASFX.;
%ELSE     %LET DATA           =    &DATA.;


/*==============================================================================*/
/*                                                                              */
/* STEP 03000       BUILD OUT PARAMETER BASED ON VALUES OF OUT AND OUTSFX.      */
/*                                                                              */
/*==============================================================================*/

%IF       %UPCASE(&OUTSFX.)  NE   NULL 

%THEN     %LET OUT           =    &OUT._&OUTSFX.;
%ELSE     %LET OUT           =    &OUT.;


/*==============================================================================*/
/*                                                                              */
/* STEP 04000       DEFINE STATIC OPERATING SYSTEM FILE DELIMITERS.             */
/*                                                                              */
/*==============================================================================*/

%let win_dlm = %str(\);

%let aix_dlm = %str(/);


/*==============================================================================*/
/*                                                                              */
/* STEP 05000       ASSIGN THE OUTPUT DELIMITER WHEN WINDOWS DELIM IS FOUND.    */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* NOTE:            WHEN THE OUTPUT PATH CONTAINS A WINDOWS FILE SYSTEM         */
/*                  DELIMITER (\).                                              */
/*                                                                              */
/*==============================================================================*/

%let      win_dlm_rc     =    %index( &outpath. , &win_dlm. );

%if       &win_dlm_rc.   ne   0

%then     %let outdlm    =    %str(\);

%let      aix_dlm_rc     =    %index( &outpath. , &aix_dlm. );

    %if   &aix_dlm_rc.   ne   0
    %then     %let outdlm    =    %str(/);


%put NOTE: ;
%put NOTE: &dline.;
%put NOTE: Macro:   PROC_EXPORT_CSV;
%put NOTE: ;
%put NOTE: ;
%put NOTE: Input Parameters:;
%put NOTE: ;
%put NOTE: lib      = &lib.; 
%put NOTE: ;
%put NOTE: data     = &data.; 
%put NOTE: ;
%put NOTE: ;
%put NOTE: Output Parameters:;
%put NOTE: ;
%put NOTE: outlib   = &outlib.; 
%put NOTE: ;
%put NOTE: outpath  = &outpath.;
%put NOTE: ;
%put NOTE: outdlm   = &outdlm.; 
%put NOTE: ;
%put NOTE: out      = &out.; 
%put NOTE: ;
%put NOTE: ext      = &ext.; 
%put NOTE: ;
%put NOTE: ;
%put NOTE: &dline.;
%put NOTE: ;

%SYSLPUT  LIB       = &LIB.;
%SYSLPUT  DATA      = &DATA.;
%SYSLPUT  OUTPATH   = &OUTPATH.;
%SYSLPUT  OUTDLM    = &OUTDLM.;
%SYSLPUT  OUT       = &OUT.;
%SYSLPUT  EXT       = &EXT.;

/*==============================================================================*/
/*                                                                              */
/* step 08020       GENERATE PROC EXPORT                                        */
/*                                                                              */
/*==============================================================================*/

PROC EXPORT DATA    = &lib..&data.
     OUTFILE        = "&outPath.&outdlm.&out..&ext."
     DBMS           = dlm
     REPLACE;
     DELIMITER      = ',';
RUN;

%MEND;
/*%PROC_EXPORT_CSV( */
/* LIB       = APPXDAT,*/
/* DATA      = CASHBACK_MODEL_BLACK,*/
/* OUTLIB    = APPXOUT,*/
/* OUTPATH   = &APPXOUT.,*/
/* OUT       = &sas_jobname.,*/
/* OUTSFX    = &cur_eom_yymmnl_date.*/
/* ); RUN;*/
