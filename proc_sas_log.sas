/*------------------------------------------------------------------------------*/
/* PURPOSE:    1.   Saves the SAS Log window and the SAS output window          */
/*                  to physical files.                                          */
/*============+=================================================================*/

%MACRO PROC_SAS_LOG(
 step          = 99000,
 title         = end of sas program,
 path          = NULL,
 job           = &sas_jobname.,
 filedate      = &sas_out_dir.,
 ext           = txt
 );

/*==============================================================================*/
/* step M0010  LOG  ASSIGN LOG AND LIST OUTPUT TO THE LOG DIRECTORY.            */
/*==============================================================================*/

%LET PATH           =    &APPWLOG.;
 
%GLOBAL   SYSDLM
          SYSOS;

/*------------------------------------------------------------------------------*/
/* step M0011  LOG  THE SAS MACRO WAS SUBMITTED TO WINDOWS OPERATING SYSTEM.    */
/*------------------------------------------------------------------------------*/

%IF       %INDEX(&PATH,%STR(\))    NE   0    %THEN %DO;

          %LET SYSDLM              =    %STR(\);
          %LET SYSOS               =    %STR(WIN);
%END;

/*------------------------------------------------------------------------------*/
/* step M0012  LOG  THE SAS MACRO WAS SUBMITTED TO AIX OPERATING SYSTEM.        */
/*------------------------------------------------------------------------------*/


%IF       %INDEX(&PATH,%STR(/))    NE   0    %THEN %DO;

          %LET SYSDLM              =    %STR(/);
          %LET SYSOS               =    %STR(WIN);
%END;

/*==============================================================================*/
/*                                                                              */
/* step M0030  LOG  DEFINE SINGLE QUOTE MACRO VARIABLE.                         */
/*                                                                              */
/*==============================================================================*/

%GLOBAL   SQ;

%LET      SQ        = %STR(%');

/*==============================================================================*/
/*                                                                              */
/* step M0040  LOG  DEFINE THE LOG DATE FORMATTED AS YYYYMMDD.                  */
/*                                                                              */
/*==============================================================================*/

%LET LOGDATE   = %SYSFUNC( DATE() , YYMMDD10. );
%LET LOGDATE   = %SYSFUNC( COMPRESS(&LOGDATE.,'-') );

/*==============================================================================*/
/* step M0050  LOG  DEFINE THE LOG TIME FORMATTED AS HHMMSS.                    */
/*==============================================================================*/

%LET LOGTIME   = %SYSFUNC( TIME() , TIME8. );
%LET LOGTIME   = %SYSFUNC( COMPRESS(&LOGTIME.,':') );

/*==============================================================================*/
/*                                                                              */
/* step M0060  LOG  DISPLAY THE LOG DATE AND LOG TIME TO THE SAS LOG.           */
/*                                                                              */
/*==============================================================================*/

%SAS_TITLE(
 STEP     = &step.,
 TITLE    = &title.,
 msg1     = path:    &path.,
 msg2     = job:     &job.,
 msg4     = logdate: &logdate.,
 msg5     = logtime: &logtime. 
 ); RUN; 

/*==============================================================================*/
/* step M0070  LOG  SAVE THE LOG WINDOW TO THE LOG DIRECTORY OF SUBMITTED OS.   */
/*==============================================================================*/
/* fmt:             <dir-path>\<&job.>_<&filedate.>_log_&logdate._&logtime..txt */
/* eg:              <dir-path>\log_cvp_bca_00070_201704_20170605_162545..txt    */
/*==============================================================================*/


DM   "LOG;FILE &sq.&path.&sysdlm.&job._&filedate._log_&logdate._&logtime..&ext.&sq."; RUN;
DM   "LOG;CLEAR"; RUN;

/*==============================================================================*/
/* step M0080       SAVE THE SAS OUTPUT WINDOW TO OUTPUT DIRECTORY.             */
/* -----------------------------------------------------------------------------*/
/* fmt:             <dir-path>\<&job.>_<&filedate.>_log_&logdate._&logtime..txt */
/* eg:              <dir-path>\cvp_bca_00070_201704_list_20170605_162545..txt   */
/*==============================================================================*/


DM "OUTPUT;FILE &sq.&path.&sysdlm.&job._&filedate._lst_&logdate._&logtime..&ext.&sq."; RUN;

DM "OUTPUT;CLEAR"; RUN;

%mend;
/*%PROC_SAS_LOG(*/
/* path     = C:\CCA\LOG,*/
/* job      = cim_cca_00030*/
/* ); RUN;*/

