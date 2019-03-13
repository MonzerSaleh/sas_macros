/*==============================================================================*/
/*                                                                              */
/* Macro:           file_list                                                   */
/*                                                                              */
/* -----------------------------------------------------------------------------*/
/*                                                                              */
/* Purpose:         Perform a windows directory list on an input directory and  */
/*                  return a Sas dataset in the work directory THAT CONTAINS    */
/*                  a list of external files in the input directory.            */
/*                                                                              */
/* -----------------------------------------------------------------------------*/
/*                                                                              */
/* Parms:      1.   dir            =    specify the input windows directory path*/
/*                                      where the input files are located.      */
/*                                                                              */
/* Parms:      2.   file_prefix    =    specify the file prefix to be used in   */
/*                                      the search routine.                     */
/*                                                                              */
/* Parms:      3.   ext            =    specify the file extension to be used   */
/*                                      the search routine.                     */
/*                                                                              */
/* Parms:      4.   outlib         =    specify the output sas library name.    */
/*                                      default:  work                          */
/*                                                                              */
/* Parms:      5.   out            =    specify the output sas dataset THAT HAS */
/*                                      the list of file names and the dir      */
/*                                                                              */
/*------------------------------------------------------------------------------*/
/*                                                                              */
/* output:     1.   returns a sas dataset called: work.file_list                */
/*                                                                              */
/*------------------------------------------------------------------------------*/
/*                                                                              */
/* old statement                                                                */
/*%sysexec cd &dir; %sysexec dir &dir.\&file_prefix.*.&ext. /b/o:n >            */
/*                  filelist.txt;                                               */
/*                                                                              */
/*==============================================================================*/
/*                                                                              */
/*============+=================================================================*/
/* YYYY-MM-DD | MAINTENANCE LOG                                                 */
/*============+=================================================================*/
/* 2016-01-01 | CREATED BY VIC NETO.                                            */
/* 2017-07-04 | 2017 PASSWORD AUTHENTICATION REVIEW BY VICTOR NETO.             */
/*============+=================================================================*/
%macro file_list(
 dir           = ,
 file_prefix   = ,
 ext           = xlsx,
 outlib        = work,
 out           = file_list
 );


/*==============================================================================*/
/*                                                                              */
/* step 00010  perform directory list                                           */
/*                                                                              */
/*==============================================================================*/

filename filelist pipe "dir &dir.\&file_prefix.*.&ext. /b/o:n";


/*==============================================================================*/
/*                                                                              */
/* step 00020  create the file_list sas dataset containing the file list.       */
/*                                                                              */
/* -----------------------------------------------------------------------------*/
/*                                                                              */
/* ouptut:     1.   work.file_list                                              */
/*                                                                              */
/* columns:    1.   dir_path       =    contains the directory path.            */
/*                                                                              */
/* columns:    2.   file_name      =    contains the file name.                 */
/*                                                                              */
/*==============================================================================*/

data &outlib..&out.;

     length    dir_path       $200.
               file_name      $200.
               filename       $200.
               ext            $8.;

     infile    filelist  pad  lrecl=200;

     input     @1   file_name  $200.;

     dir_path  =    "&dir.";

     file_name =    strip(file_name);

     filename  =    scan(file_name,1,'.');
     ext       =    scan(file_name,2,'.');

run;

%mend;
/*%file_list(*/
/*dir            = t:\pmg_branch_transactions\input,*/
/*file_prefix    = Branch_Transactions_Report,*/
/*ext            = xlsx,*/
/*outlib         = appxdat,*/
/*out            = file_list*/
/*); run;*/
