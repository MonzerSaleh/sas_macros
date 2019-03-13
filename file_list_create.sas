/*==============================================================================*/
/*                                                                              */
/* Macro:           file_list_create                                            */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* Purpose:    1.   This sas macro is designed to create a list of files        */
/*                  that will be used with the %file_list_execute sas macro.    */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*   1.   PATH      Specify the Input Directory Path to be analysed.            */
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
/*                                                                              */
/*============+=================================================================*/
%macro file_list_create(

/*------------------------------------------------------------------------------*/
/* 1.     Input File directory path being searched.                             */
/*------------------------------------------------------------------------------*/

path      = &appxinp.,

/*------------------------------------------------------------------------------*/
/* 2.     Input File components.                                                */
/*------------------------------------------------------------------------------*/

prefix    = NULL,
suffix    = NULL,
ext       = NULL,

/*------------------------------------------------------------------------------*/
/* 3.     Output SAS dataset containing the list of files.                      */
/*------------------------------------------------------------------------------*/

outlib    = appxcur,
out       = file_list

);


/*==============================================================================*/
/*                                                                              */
/* step 101    Define local macro variables.                                    */
/*                                                                              */
/*==============================================================================*/

%local    filetype
          filedelim
          filepathdelim;

/*==============================================================================*/
/*                                                                              */
/* step 103    Assign the WIN File Variables.                                   */
/*                                                                              */
/*==============================================================================*/

          %let filepath       = &path.;

          %let fileprefix     = &prefix.;
          %let filesuffix     = &suffix.;
          %let fileext        = &ext.;

          %let filetype       =    WIN;
          %let filepathdelim  =    \;
          %let filedelim      =    _;

/*==============================================================================*/
/*                                                                              */
/* step 104    Display the SAS macro parameters to the SAS LOG.                 */
/*                                                                              */
/*==============================================================================*/

%put NOTE: &dline.;
%put NOTE: Macro:   file_list_create;
%put NOTE: ;
%put NOTE: ;
%put NOTE: Purpose: 1.   This sas macro will create a directory file list and;
%put NOTE:               then call an End User SAS macro that will process;
%put NOTE:               each file in the list.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: Input File Complete Path:;
%put NOTE: ========================;
%put NOTE: ;
%put NOTE: filetype      = &filetype.;
%put NOTE: ;
%put NOTE: filepath      = &filepath.;
%put NOTE: ;
%put NOTE: filepathdelim = &filepathdelim.;
%put NOTE: ;   
%put NOTE: fileprefix    = &fileprefix.;
%put NOTE: ;   
%put NOTE: filedelim     = &filedelim.;
%put NOTE: ;
%put NOTE: filesuffix    = &filesuffix.;
%put NOTE: ;
%put NOTE: fileext       = &fileext.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: Output SAS Dataset Parameters:;
%put NOTE: =============================;
%put NOTE: ;
%put NOTE: outlib        = &outlib.;
%put NOTE: ;
%put NOTE: out           = &out.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: &dline.;



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
/* step 300    Generate rsubmit when submitted to windows client.               */
/*                                                                              */
/* Note:       Send local macro variables to the sas server.                    */
/*                                                                              */
/*==============================================================================*/

%syslput filetype        = &filetype.;
%syslput filepath        = &filepath.;
%syslput filepathdelim   = &filepathdelim.;
%syslput fileprefix      = &fileprefix.;
%syslput filedelim       = &filedelim.;
%syslput filesuffix      = &filesuffix.;
%syslput fileext         = &fileext.;

%syslput filesearch      = &filesearch.;

%syslput outlib          = &outlib.;
%syslput out             = &out.;

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
/*%file_list_create(*/
/*path    = &appxcur.,*/
/*prefix  = gic_cust_level,*/
/*outlib  = appxcur,*/
/*out     = file_list*/
/*); run;*/
