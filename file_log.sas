/*==============================================================================*/
/* Save the active LOG window to an external file.                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* syntax:     1.   file_log(                                                   */
/*                  path      = < Directory Path > ,                            */
/*                  jobname   = < Job Name > ,                                  */
/*                  jobdate   = < Job Date > ); run;                            */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/* parms:      1.   path      =    specify the directory path where the sas     */
/*                                 log is to be saved.                          */
/*                                                                              */
/*             2.   jobname   =    specify the sas job name.                    */
/*                                                                              */
/*             3.   format    =    Define the format for the log file date to be*/
/*                                 placed at the end of  the log file.          */
/*============+=================================================================*/

%macro file_log(
    path     = ,
    jobname  = ,
    format   = 
    );


/*==============================================================================*/
/*                                                                              */
/* step 100    Define the date format for the log file.                         */
/*                                                                              */
/*==============================================================================*/
%if       %upcase(&format.)   =    YYMMDD10  %then %do;

          %let saswlogs_date  = %sysfunc( today(), yymmdd10. );
          %put saswlogs_date  = &saswlogs_date.;
%end;

/*------------------------------------------------------------------------------*/
/* step 102    Define the Job Date Format:  YYYYMNN = 2011M01                   */
/*------------------------------------------------------------------------------*/

%else %if %upcase(&format.)   =    YYMM7     %then %do;

          %let saswlogs_date  = %sysfunc( today(), yymm7. );
          %put saswlogs_date  = &saswlogs_date.;
%end;

/*------------------------------------------------------------------------------*/
/* step 103    Define the Job Date Format:  YYMM    = 201101                    */
/*------------------------------------------------------------------------------*/

%else %if %upcase(&format.)   =    YYMM      %then %do;

          %let saswlogs_date  = %sysfunc( today(), yymm. );
          %put saswlogs_date  = &saswlogs_date.;
%end;

/*------------------------------------------------------------------------------*/
/* step 104    Define the Job Date Format:  Anything you put here.              */
/*------------------------------------------------------------------------------*/

%else %do;

          %let saswlogs_date  = &format.;
          %put saswlogs_date  = &format.;
%end;



/*==============================================================================*/
/*                                                                              */
/* step 200    Save the Active SAS LOG Window to the external log file.         */
/*                                                                              */
/*==============================================================================*/

/*------------------------------------------------------------------------------*/
/* step 201    Define the SAS Windows Log File.                                 */
/*------------------------------------------------------------------------------*/

filename saswlogs "&path."; run;

/*------------------------------------------------------------------------------*/
/* step 202    Save the Active SAS LOG window to the external SAS log file.     */
/*------------------------------------------------------------------------------*/

dm "log; file saswlogs(&jobname._&saswlogs_date.);"; run;

/*------------------------------------------------------------------------------*/
/* step 203    Clear the Log Window after saving the log to the external file.  */
/*------------------------------------------------------------------------------*/

dm "log; clear;";


%MEND;
/*%lib_alloc(*/
/*lib       = comwlog,*/
/*path      = t:\dss\ceprod\mortgage\common\logs,*/
/*server    = null*/
/*); run;*/
/**/
/*%file_log(*/
/* path     = &comwlog.,*/
/* jobname  = dss_mtg_700,*/
/* format   = -1); run;*/

