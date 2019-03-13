/*==============================================================================*/
/* MACRO:           FILE_TIMESTAMP                                              */
/* -----------------------------------------------------------------------------*/
/* Purpose:    1.   Extracts the current date and time and formats the          */
/*                  value and assigns to a user specified macro variable.       */
/* -----------------------------------------------------------------------------*/
/* SYNTAX:          %TIMESTAMP(                                                 */
/*                                 VAR       = < macro-variable-name >  ,       */
/*                                 DISPLAY   = < YES | NO >             );      */
/* -----------------------------------------------------------------------------*/
/* PARMS:      1.   VAR       =    specify a macro variable name to hold        */
/*                                 the date time stamp.                         */
/*                                 The value of this global macro variable      */
/*                                 may be used as a date time stamp in output   */
/*                                 file names.                                  */
/* PARMS:      2.   DISPLAY   =    Display the Global Macro Variable to the     */
/*                                 SAS log.                                     */
/*                                                                              */
/*                                 DEFAULT: YES                                 */
/* -----------------------------------------------------------------------------*/
/*                                                                              */
/* EXAMPLE:    1.   %TIMESTAMP(VAR=TIMESTAMP);                                  */
/*                                                                              */
/*                                                                              */
/* RETURNS:    1.   If   the current date is:     MAY 17, 2018                  */
/*                                                                              */
/*                  and  the current time is:     8:35:45                       */
/*                                                                              */
/*                  then this routine will return the following global          */
/*                  macro variable and value:                                   */
/*                                                                              */
/*                  global macro variable:   TIMESTAMP                          */
/*                                                                              */
/*                  global macro value:      20180517_083545                    */
/*============+=================================================================*/

%MACRO FILE_TIMESTAMP(
 VAR      = FILE_TIMESTAMP,
 DISPLAY  = YES
 );


/*------------------------------------------------------------------------------*/
/* MACR 01000       DEFINE THE CURRENT BACKUP DATE FORMATTED AS: YYYYMMDD       */
/*------------------------------------------------------------------------------*/

%LOCAL    BKUPDATE;

%LET      BKUPDATE  = %SYSFUNC( DATE(),YYMMDDN8.);


/*------------------------------------------------------------------------------*/
/* MACR 02000       DEFINE THE CURRENT BACKUP TIME FORMATTED AS: HHMMSS         */
/*------------------------------------------------------------------------------*/

%LOCAL    BKUPTIME;

%LET      BKUPTIME  = %SYSFUNC( COMPRESS( %SYSFUNC(time(),tod8.) , ':') );


/*------------------------------------------------------------------------------*/
/* MACR 03000       DEFINE THE GLOBAL OUTPUT VARIABLE NAME.                     */
/*------------------------------------------------------------------------------*/

%GLOBAL   &VAR.;

%LET      &VAR.     = &BKUPDATE._&BKUPTIME.;


/*------------------------------------------------------------------------------*/
/* MACR 04000       DISPLAY THE GLOBAL MACRO VARIABLE.                          */
/*------------------------------------------------------------------------------*/

%IF       %UPCASE(&DISPLAY.)  = YES %THEN %DO;

%PUT NOTE: ======================================================================;
%PUT NOTE: MACRO:        FILE_TIMESTAMP;
%PUT NOTE: ;
%PUT NOTE: PURPOSE:      CREATES A FILE TIME STAMP GLOBAL MACRO VARIABLE.;
%PUT NOTE: ;
%PUT NOTE: FORMAT:       YYYYMMDD_HHMMSS;
%PUT NOTE: ;
%PUT NOTE: VAR:          &VAR.;
%PUT NOTE: ;
%PUT NOTE: VALUE:        &&&VAR.;
%PUT NOTE: ;
%PUT NOTE: ;
%PUT NOTE: ======================================================================;

%END;


%MEND FILE_TIMESTAMP;
/*%FILE_TIMESTAMP; RUN;*/
/*%PUT FILE_TIMESTAMP = &FILE_TIMESTAMP.;*/
