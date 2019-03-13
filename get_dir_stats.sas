/*==============================================================================*/
/* Purpose:    1.   This sas macro is designed to get a list directory files    */
/*                  and their size.                                             */
/* ---------------------------------------------------------------------------- */
/*   1.   DIRPATH   Specify the Input Directory Path to be analysed.            */
/*                                                                              */
/*   2.   PREFIX    Specify the Input Filename prefix.                          */
/*                                                                              */
/*   3.   SUFFIX    Specify the Input Filename suffix.                          */
/*                                                                              */
/*   4.   EXT       Specify the Input Filename extension.                       */
/*                                                                              */
/*   5.   OUTLIB    Specify the Output SAS Library Name that will contain       */
/*                  the output file list.                                       */
/*                                                                              */
/*   7.   OUT       Specify the Output SAS Dataset name that will contain       */
/*                  the list of file names.                                     */
/*============+=================================================================*/

%MACRO GET_DIR_STATS(

/*------------------------------------------------------------------------------*/
/* PARMS: 01   SPECIFY THE INPUT DIRECTORY PATH.                                */
/*------------------------------------------------------------------------------*/

 PATH          = NULL,

/*------------------------------------------------------------------------------*/
/* PARMS: 02   SPECIFY THE INPUT FILE ( PREFIX, SUFFIX, EXT, AND DLM )          */
/*------------------------------------------------------------------------------*/

 FILE_PREFIX   = NULL,
 FILE_SUFFIX   = NULL,
 FILE_EXT      = NULL,
 FILE_DLM      = _,

/*------------------------------------------------------------------------------*/
/* PARMS: 03   SPECIFY THE OUTPUT DATASET PARAMETERS.                           */
/* ============================================================================ */
/*                                                                              */
/* 1.          OUTLIB         SPECIFY THE OUTPUT SAS LIBRARY NAME.              */
/*                            DEFAULT: WORK                                     */
/*                                                                              */
/* 2.          OUT            SPECIFY THE OUTPUT SAS DATASET NAME.              */
/*                                                                              */
/* 3.          OUTSFX         SPECIFY THE OUTPUT SAS DATASET NAME SUFFIX.       */
/*                            DEFAULT: NULL                                     */
/*                                                                              */
/*------------------------------------------------------------------------------*/

 OUTLIB   = WORK,    
 OUT      = FILE_LIST,
 OUTSFX   = NULL
 );

/*==============================================================================*/
/* STEP:  00100          DETERMINE THE DIRECTORY PATH TYPE ( AIX | WIN )        */
/* ---------------------------------------------------------------------------- */
/* NOTE:       1.        FOR THE AIX OPERATING SYSTEM DIRECTORY PATH:           */
/*                                                                              */
/*             1.1.      DIR_PATH_TYPE       =    AIX                           */
/*             1.2.      DIR_PATH_DELIM      =    /                             */
/*                                                                              */
/* NOTE:       2.        FOR THE WIN OPERATING SYSTEM DIRECTORY PATH:           */
/*                                                                              */
/*             2.1.      DIR_PATH_TYPE       =    WIN                           */
/*             2.2.      DIR_PATH_DELIM      =    \                             */
/*                                                                              */
/*==============================================================================*/


/*------------------------------------------------------------------------------*/
/* STEP: 00101 LOCAL     DEFINE LOCAL VARIABLES.                                */
/*------------------------------------------------------------------------------*/

%LOCAL    PATH_TYPE
          PATH_DLM;
RUN;

%LET PATH_TYPE      =    WIN;
%LET PATH_DLM       =    \;

/*------------------------------------------------------------------------------*/
/* STEP: 00104 LOCAL     ATTACH OUTSFX TO OUT PARM WHEN OUTSFX WAS SPECIFIED.   */
/*------------------------------------------------------------------------------*/

%IF  %QUPCASE(&OUTSFX.)  NE   NULL      %THEN %DO;

     %LET OUT            =    &OUT._&OUTSFX.;

%END;



/*==============================================================================*/
/*                                                                              */
/* STEP:  00200          DISPLAY SAS MACRO PARAMETERS TO THE SAS LOG.           */
/*                                                                              */
/*==============================================================================*/

%PUT NOTE: &dline.;
%PUT NOTE: MACRO:        GET_DIR_STATS;
%PUT NOTE: ;
%PUT NOTE: INPUT DIRECTORY PATH:;
%PUT NOTE: ====================;
%PUT NOTE: ;
%PUT NOTE: PATH          = &PATH.;
%PUT NOTE: ;
%PUT NOTE: PATH_TYPE     = &PATH_TYPE.;
%PUT NOTE: ;
%PUT NOTE: PATH_DLM      = &PATH_DLM.;
%PUT NOTE: ;
%PUT NOTE: ;
%PUT NOTE: INPUT FILE PARMS:;
%PUT NOTE: ================;
%put NOTE: ;   
%put NOTE: FILE_PREFIX   = &FILE_PREFIX.;
%put NOTE: ;   
%put NOTE: FILE_SUFFIX   = &FILE_SUFFIX.;
%put NOTE: ;   
%put NOTE: FILE_EXT      = &FILE_EXT.;
%put NOTE: ;
%put NOTE: FILE_DLM      = &FILE_DLM.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: OUTPUT SAS DATASET PARMS:;
%put NOTE: ========================;
%put NOTE: ;
%put NOTE: OUTLIB        = &OUTLIB.;
%put NOTE: ;
%put NOTE: OUT           = &OUT.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: &dline.;



/*==============================================================================*/
/*                                                                              */
/* STEP:  00105          SEND MACRO PARAMETERS TO THE SAS SERVER.               */
/*                                                                              */
/*==============================================================================*/

%SYSLPUT PATH            = &PATH.;
%SYSLPUT PATH_TYPE       = &PATH_TYPE.;
%SYSLPUT PATH_DLM        = &PATH_DLM.;

%SYSLPUT FILE_PREFIX     = &FILE_PREFIX.;
%SYSLPUT FILE_SUFFIX     = &FILE_SUFFIX.;
%SYSLPUT FILE_EXT        = &FILE_EXT.;
%SYSLPUT FILE_DLM        = &FILE_DLM.;

%SYSLPUT FILE_SEARCH     = &FILE_SEARCH.;

%SYSLPUT OUTLIB          = &OUTLIB.;
%SYSLPUT OUT             = &OUT.;

%MEND;

%GET_DIR_STATS(
 PATH     = &APPXHIS.,
 OUTLIB   = APPXDAT,
 OUT      = DIR_STATS
 ); RUN;

/*==============================================================================*/
/*                                                                              */
/* step 200    Define the File Search String.                                   */
/*                                                                              */
/*==============================================================================*/

/*------------------------------------------------------------------------------*/
/* step 201    Define the File Search String with the suffix attached.          */
/*------------------------------------------------------------------------------*/

%if       &suffix.       ne   NULL      %then %do; 

%let      filesearch     =    &filepath.&filepathdelim.&fileprefix.&filedelim.&filesuffix.;

%end;

/*------------------------------------------------------------------------------*/
/* step 202    Define the File Search String with the suffix excluded.          */
/*------------------------------------------------------------------------------*/

%else %if &suffix.       eq   NULL      %then %do; 

%let      filesearch     =    &filepath.&filepathdelim.&fileprefix.;

%end;

/*==============================================================================*/
/*                                                                              */
/* Step 500    Read the FILELIST file reference and Build SAS Macro Call.       */
/*                                                                              */
/* Note:       1.   This step reads the FILELIST file reference that contains   */
/*                  a list of all files and their directories.                  */
/*                                                                              */
/* input:      1.   PIPE COMMAND - LS < complete file path >                    */
/*                                                                              */
/* output:     1.   FILELIST - File Reference.                                  */
/*                                                                              */
/*==============================================================================*/

data &outlib..&out.;

     /*-------------------------------------------------------------------------*/
     /* 1.     Define the file list input file and input a record.              */
     /*-------------------------------------------------------------------------*/

     infile    filelist  pad  lrecl=1000;

     input     @1   file_path      $1000.;

     /*-------------------------------------------------------------------------*/
     /* 2.     Trim the file path.                                              */
     /*-------------------------------------------------------------------------*/

     file_path = trim(file_path);

     /*-------------------------------------------------------------------------*/
     /* 3.     If the extension NE NULL                                         */
     /*        Then select the files.                                           */
     /*-------------------------------------------------------------------------*/

     %if       &ext.     ne   NULL      %then %do;

     if        index(file_path , '.' || "&fileext." )  ne   0;
 
     %end;

run;

%mend;
/*options macrogen symbolgen mprint;*/
%file_list_create(
 path    = &appxhis.,
 prefix  = *,
 outlib  = appxdat,
 out     = file_list
 ); run;
