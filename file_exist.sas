/*------------------------------------------------------------------------------*/
/*                                                                              */
/* macro:           file_exist                                                  */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* Purpose:         Checks the existance of an external file and then sets      */
/*                  a global macro variable.                                    */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* Syntax:          %file_exist( <file_path> );                                 */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* Where:           file_path      is the complete dataset path including the   */
/*                                 Folders, dataset name and extension.         */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* Codes:           0    =    the external file does not exist.                 */
/*                                                                              */
/*                  1    =    the external file exists.                         */
/*                                                                              */
/*============+=================================================================*/

%macro file_exist( file_path );


/*==============================================================================*/
/* step M0010       Convert the Input path macro variable to lower case.        */
/*==============================================================================*/

%global   file_exist_path;

%let      file_exist_path = %lowcase(&file_path.);


/*==============================================================================*/
/* step M0020       Define the File Exist Return Code macro variable.           */
/*==============================================================================*/

%global   file_exist_rc ;

%let      file_exist_rc = 0;


/*==============================================================================*/
/* step M0030       Check the existannce of the external input file path macro  */
/*                  variable and set a return code.                             */
/*==============================================================================*/

%let      file_exist_rc = %sysfunc( fileexist(&file_exist_path.) );

/*==============================================================================*/
/* step M0040       Define the File Exist Message macro variable.               */
/*==============================================================================*/

%local    file_exist_msg ;

%if       &file_exist_rc.     = 0 
%then     %let file_exist_msg = The External File &file_exist_path. does NOT Exist! ;
%else     %let file_exist_msg = The External File &file_exist_path. exists! ;


/*==============================================================================*/
/*                                                                              */
/* step M0050       Display the Message to the SAS log.                         */
/*                                                                              */
/*==============================================================================*/

%put;
%put NOTE: &dline.;
%put NOTE: Macro:   FILE_EXIST;
%put NOTE: ;
%put NOTE: Purpose: 1.   This SAS macro is designed to check the existance;
%put NOTE:               of an external file path by passing the sas macro;
%put NOTE:               one arguement that is the complete file path.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: File_exist_path    = &file_exist_path.;
%put NOTE: ;
%put NOTE: Results:;
%put NOTE: ;
%put NOTE: file_exist_rc      = &file_exist_rc.;
%put NOTE: ;
%put NOTE: file_exist_msg     = &file_exist_msg.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: &dline.;
%put ;


%MEND;
/*%file_exist(c:\bill01.txt); run;*/
/*%put file_exist_path = &file_exist_path.;*/
