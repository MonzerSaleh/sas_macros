/*------------------------------------------------------------------------------*/
/* Macro:           file_copy                                                   */
/* System:          Utility                                                     */
/*                                                                              */
/* Purpose:    1.   Copies a source file to a target file.                      */
/*                                                                              */
/* Type:            procedure                                                   */
/*                                                                              */
/* Platform:        Windows or AIX                                              */
/*                                                                              */
/* Syntax:          %file_copy(                                                 */
/*                  srcfile = <srcfile> ,                                       */
/*                  trgfile = <trgfile>                                         */ 
/*                  ); run;                                                     */
/*                                                                              */
/*                                                                              */
/* Details:   1.    srcfile   specifies the source file(s) to be copied.        */
/*                                                                              */
/*            2.    trgfile   specifies the target dir/file(s).                 */
/*                                                                              */
/*                                                                              */
/* Codes:     0    indicates the files were successfully copied.                */
/*                                                                              */
/*            1    indicates the files could not be copied.                     */
/*                                                                              */
/*            8    indicates the file parameters were invalid for               */
/*                 operating system.                                            */
/*                                                                              */
/*============+=================================================================*/
%macro file_copy (
 srcfile  = ,
 trgfile  = ,
 opt      = ,
 debug    = no
 );

/*==============================================================================*/
/* step 001    Convert parms to lower case                                      */
/*==============================================================================*/

%let debug     = %lowcase(&debug);

/*==============================================================================*/
/* step 002    Turn on debug options                                            */
/*==============================================================================*/

%if  %lowcase(&debug.) = yes %then %do;
     options macrogen symbolgen mlogic mprint mtrace ; run;
%end;

/*==============================================================================*/
/* step 003    Define global return code.                                       */
/*==============================================================================*/

%global        file_copy_rc;

%let           file_copy_rc = 0 ;


/*==============================================================================*/
/*                                                                              */
/* step 004    Define signle and double quotes and double line.                 */
/*                                                                              */
/*==============================================================================*/

%local         sq dq dline ;

%let           sq        = %str(%'); 
%let           dq        = %str(%");
%let           dline     = %sysfunc( repeat(=,85) );
     

/*==============================================================================*/
/*                                                                              */
/* step 005    validate the source file macro parameter.                        */
/*                                                                              */
/*==============================================================================*/

%if  %bquote(%upcase(&srcfile.)) eq     %then %do;
   
     %putmlog(
     name = file_copy,
     var  = file_copy_rc,
     rc   = 8 ,
     msg1 = The Mandatory Parameter: srcfile is missing,
     msg2 = Please specify the parameter and rerun
     ); run;

%end;


/*==============================================================================*/
/*                                                                              */
/* step 005    validate the windows directory path deliminators.                */
/*                                                                              */
/*==============================================================================*/

%if  %upcase(&sysscp.) = WIN and %index(&srcfile.,/) ne 0 %then %do;
 
     %putmlog(
     name = file_copy,
     var  = file_copy_rc,
     rc   = 8 ,
     msg1 = The Windows Directory path has an invalid deliminator ,
     msg2 = Operating System       => &sysscpl. ,
     msg3 = Source Directory Path  => &srcfile. ,
     msg4 = Please specify backward slashes in the source path and rerun
     ); run;
    
%end;


/*==============================================================================*/
/*                                                                              */
/* step 007    build the file copy command statement.                           */
/*                                                                              */
/*==============================================================================*/

%local    file_copy_cmd;

%if       %upcase(&sysscp.)   = WIN          %then %do;
    %let      file_copy_cmd       = &sq.copy /Y &dq.&srcfile.&dq. &dq.&trgfile.&dq.&sq.;
%end;

/*==============================================================================*/
/*                                                                              */
/* step 008    execute the copy command.                                        */
/*                                                                              */
/*==============================================================================*/

systask   command %unquote( &file_copy_cmd. )
          shell
          wait
          taskname  = "file_copy"
          status    = file_copy_rc ; 
run;


/*==============================================================================*/
/*                                                                              */
/* step 009    Assign the copy return codes and return message.                 */
/*                                                                              */
/*==============================================================================*/

%if       &file_copy_rc.      =    0       %then %do;
          %let file_copy_msg  =    File Copy was successful;
          %let file_copy_rc   =    0 ; 
%end;
%else %do;
          %let file_copy_msg  =    File Copy has failed;
          %let file_copy_rc   =    1 ;  
%end;


/*==============================================================================*/
/*                                                                              */
/* step 010    Display the messages to the sas log.                             */
/*                                                                              */
/*==============================================================================*/

%put ;
%put NOTE: &dline. ;
%put NOTE: Macro:        file_copy;
%put NOTE: ;
%put NOTE: ;
%put NOTE: Message       => &file_copy_msg.;
%put NOTE: ;
%put NOTE: file_copy_rc  => &file_copy_rc. ;
%put NOTE: ;
%put NOTE: ;
%put NOTE: Source File   => &srcfile. ;
%put NOTE: ;
%put NOTE: Target File   => &trgfile. ;  
%put NOTE: ;
%put NOTE: ;
%put NOTE: Command       => &file_copy_cmd. ;
%put NOTE: ;
%put NOTE: ;
%put NOTE: &dline. ;
%put ;


%mend;
/*------------------------------------------------------------------------------*/
/* step 020    Windows Test - Copy a file to a target file.                     */
/*------------------------------------------------------------------------------*/
/*%file_copy(*/
/*srcfile=&appwmod.\Test_File.xls,*/
/*trgfile=&appwout.\Test_File.xls*/
/*); run;*/
