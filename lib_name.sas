/*==============================================================================*/
/*                                                                              */
/* macro:      lib_name                                                        */
/*                                                                              */
/* purpose:    1.   assigns a remote sas libref to the remote session and       */
/*                  assigns a local sas libref to the local session.            */
/*                                                                              */
/* libref:     userlib                                                          */
/*                                                                              */
/* home:       appxhome.                                                        */
/* dir1:       mortgage                                                         */
/* dir2:       campaign                                                         */
/* dir3:       output                                                           */
/*                                                                              */
/*==========+===================================================================*/
/* YYYYMMDD | Maintenance Log                                                   */
/*----------+-------------------------------------------------------------------*/
/* 20110515 | Created new lib alloc sas macro... Victor Neto                    */
/*----------+-------------------------------------------------------------------*/
%macro lib_name(
 lib      = NULL,

 home     = DEFAULT,

 app      = NULL,
 project  = NULL,
 type     = NULL,

 dir1     = NULL,
 dir2     = NULL,
 dir3     = NULL,

 server   = NULL,

 chmod    = 777
 );


/*==============================================================================*/
/*                                                                              */
/* step 001    Define the lib_name return code and messgage variables.          */
/*                                                                              */
/*==============================================================================*/

%global   lib_name_rc
          lib_name_msg1
          lib_name_msg2
          lib_name_msg3   
          lib_name_chmod; 


/*==============================================================================*/
/*                                                                              */
/* step 020    Convert the sas macro parameter to upper case.                   */
/*                                                                              */
/*             Default: NULL                                                    */
/*                                                                              */
/*             when the server parameter contains the default value of NULL,    */
/*             Then the library is assumed to be a library assignment on the    */
/*             local sas session.                                               */
/*                                                                              */
/*==============================================================================*/

%let      server    = %upcase(&server.);


/*==============================================================================*/
/*                                                                              */
/* step 030    Convert the sas macro parameters to lower case.                  */
/*                                                                              */
/*==============================================================================*/

%let      home      = %lowcase(&home.);

%let      app       = %lowcase(&app.);
%let      dir1      = %lowcase(&dir1.);

%let      project   = %lowcase(&project.);
%let      dir2      = %lowcase(&dir2.);

%let      type      = %lowcase(&type.);


/*==============================================================================*/
/*                                                                              */
/* step 040    Validate the Mutually Exclusive Application Level Parameters.    */
/*                                                                              */
/*             appcode   =    Use the application Code naming convention.       */
/*             or                                                               */
/*             dir1      -    Use the dir1 naming convention.                   */
/*                                                                              */
/*==============================================================================*/

%if       %upcase(&app.)      eq   NULL
and       %upcase(&dir1.)     eq   NULL
or
          %upcase(&app.)      ne   NULL
and       %upcase(&dir1.)     ne   NULL      %then %do;

%let lib_name_rc   = 99;
%let lib_name_code = NOTE:;
%let lib_name_msg1 = Application Level folder was not specified.;
%let lib_name_msg2 = You must specify one of the following parameters but not both.;
%let lib_name_msg3 = ;
%let lib_name_msg4 = appcode;
%let lib_name_msg5 = dir1;

%put ;
%put &lib_name_code. &dline.;
%put &lib_name_code. Macro:   lib_name;
%put &lib_name_code. ;
%put &lib_name_code. ;
%put &lib_name_code. Message: &lib_name_msg1.;
%put &lib_name_code.          &lib_name_msg2.;
%put &lib_name_code.          &lib_name_msg3.;
%put &lib_name_code.          &lib_name_msg4.;
%put &lib_name_code.          &lib_name_msg5.;
%put &lib_name_code. ;
%put &lib_name_code. ;
%put &lib_name_code. &dline.;
%put ;

abort 99;

%end;



/*==============================================================================*/
/*                                                                              */
/* step 040    Validate the project and dir2 macro parameters.                  */
/*                                                                              */
/*==============================================================================*/

%if       %upcase(&project.)  eq   NULL
and       %upcase(&dir2.)     eq   NULL
or
          %upcase(&project.)  ne   NULL
and       %upcase(&dir2.)     ne   NULL      %then %do;

%let lib_name_rc   = 99;
%let lib_name_code = NOTE:;
%let lib_name_msg1 = The Project Level Folder was not specified.;
%let lib_name_msg2 = You must specify one of the following parameters but not both.;
%let lib_name_msg3 = ;
%let lib_name_msg4 = project;
%let lib_name_msg5 = dir2;

%put ;
%put &lib_name_code. &dline.;
%put &lib_name_code. Macro:   lib_name;
%put &lib_name_code. ;
%put &lib_name_code. ;
%put &lib_name_code. Message: &lib_name_msg1.;
%put &lib_name_code.          &lib_name_msg2.;
%put &lib_name_code.          &lib_name_msg3.;
%put &lib_name_code.          &lib_name_msg4.;
%put &lib_name_code.          &lib_name_msg5.;
%put &lib_name_code. ;
%put &lib_name_code. ;
%put &lib_name_code. &dline.;
%put ;

abort 99;

%end;



/*==============================================================================*/
/*                                                                              */
/* step 040    Assign the Home Parameter.                                       */
/*                                                                              */
/*==============================================================================*/

/*------------------------------------------------------------------------------*/
/* step 041    Local Windows Submission with Windows Library Specification.     */
/*                                                                              */
/* note:  1.   The user submitted the macro to the windows sas system           */
/*             to assign a windows sas library.                                 */
/*                                                                              */
/*------------------------------------------------------------------------------*/

%if       &sysscp.            eq   WIN
and       %upcase(&home.)     eq   DEFAULT
and       %upcase(&server.)   eq   NULL      %then %do;

          %let systype        =    WIN;
          %let libtype        =    WIN;

          %let home           =    &appwhome.;
          %let server         =    NULL;

%end;

/*------------------------------------------------------------------------------*/
/* step 042    Local Windows Submission with UNIX Library Specification.        */
/*                                                                              */
/* note:  1.   The user submitted the macro to the windows sas system           */
/*             and                                                              */
/*             the User is using the default windows home directory             */
/*             and                                                              */
/*             the User is assigning a windows sas library.                     */
/*                                                                              */
/*------------------------------------------------------------------------------*/

%else %if &sysscp.            eq   WIN
and       %upcase(&home.)     eq   DEFAULT
and       %upcase(&server.)   ne   NULL      %then %do;

          %let systype        =    WIN;
          %let libtype        =    AIX;

          %let home           =    &appxhome.;
          %let server         =    &server.;

%end;


/*==============================================================================*/
/*                                                                              */
/* step 043    Override                                                         */
/*                                                                              */
/*==============================================================================*/

/*------------------------------------------------------------------------------*/
/* step 043    Local Windows Submission with User Windows Home Override.        */
/*                                                                              */
/* note:  1.   The user submitted the macro to the windows sas system           */
/*             and                                                              */
/*             the User is overriding the Home Directory.                       */
/*             and                                                              */
/*             the User is assigning a Windows SAS library.                     */
/*------------------------------------------------------------------------------*/

%else %if &sysscp.            eq   WIN
and       %upcase(&home.)     ne   DEFAULT
and       %index(&home.,\)    ne   0
and       %upcase(&server.)   eq   NULL      %then %do;

          %let systype        =    WIN;
          %let libtype        =    WIN;

          %let home           =    &home.;
          %let server         =    NULL;

%end;

/*------------------------------------------------------------------------------*/
/* step 043    A Local Windows Submission with a UNIX Library Specification.    */
/*                                                                              */
/* note:  1.   The user submitted the macro to the windows sas system           */
/*             and                                                              */
/*             the User is overriding the Home Directory.                       */
/*             and                                                              */
/*             the User is assigning a Windows SAS library.                     */
/*                                                                              */
/* Note:  1.   The User may have submitted this code directly to UNIX SAS       */
/*             System via a batch script.                                       */
/*             or                                                               */
/* Note:  1.   The User may pecified HOME=DEFAULT, and SERVER=<server name>     */
/*             Then use the default global macro variable: &appxhome.           */
/*                                                                              */
/*------------------------------------------------------------------------------*/

%else %if &sysscpl.           eq   WIN
and       %upcase(&home.)     ne   DEFAULT
and       %index(&home.,/)    ne   0
and       %upcase(&server.)   ne   NULL      %then %do;

          %let systype        =    AIX;
          %let libtype        =    AIX;
          %let home           =    &home.;
          %let server         =    &server.;

%end;


/*==============================================================================*/
/*                                                                              */
/* step 040    Assign directory paramters when NULL.                            */
/*                                                                              */
/*==============================================================================*/

%if       %upcase(&dir1.)     eq   NULL
%then     %let dir1           =    &app.;

%if       %upcase(&dir2.)     eq   NULL
%then     %let dir2           =    &project.;




/*==============================================================================*/
/*                                                                              */
/* step 040    Validate the type parameter.                                     */
/*                                                                              */
/* values:     input                                                            */
/*             output                                                           */
/*                                                                              */
/*             current                                                          */
/*             history                                                          */
/*             history                                                          */
/*                                                                              */
/*==============================================================================*/

%if       %lowcase(&type.) ne input
and       %lowcase(&type.) ne output
and       %lowcase(&type.) ne current
and       %lowcase(&type.) ne history
and       %lowcase(&type.) ne docs  
and       %lowcase(&type.) ne formats
and       %lowcase(&type.) ne tables 
and       %lowcase(&type.) ne macros
and       %lowcase(&type.) ne scripts
and       %lowcase(&type.) ne wiki
and       %lowcase(&type.) ne programs       %then %do;

%let lib_name_rc   = 99;
%let lib_name_code = NOTE:;
%let lib_name_msg1 = The Library Type is invalid!;
%let lib_name_msg2 = Please code on the following types:;
%let lib_name_msg2 = input output current history;
%let lib_name_msg2 = docs formats tables macros scripts programs wiki;
%let lib_name_msg3 = ;

%put ;
%put &lib_name_code. &dline.;
%put &lib_name_code. Macro:   lib_name;
%put &lib_name_code. ;
%put &lib_name_code. ;
%put &lib_name_code. Message: &lib_name_msg1.;
%put &lib_name_code.          &lib_name_msg2.;
%put &lib_name_code.          &lib_name_msg3.;
%put &lib_name_code.          &lib_name_msg4.;
%put &lib_name_code.          &lib_name_msg5.;
%put &lib_name_code.          &lib_name_msg6.;
%put &lib_name_code.          &lib_name_msg7.;
%put &lib_name_code. ;
%put &lib_name_code. Return Code: &lib_name_rc.;
%put &lib_name_code. ;
%put &lib_name_code. &dline.;
%put ;

abort &lib_name_rc. return;

%end;


/*==============================================================================*/
/*                                                                              */
/* step 050    Build the libpath macro variable.                                */
/*                                                                              */
/*==============================================================================*/

/*------------------------------------------------------------------------------*/
/*                                                                              */
/* step 041    Local Windows Macro Submission with Windows Library Type.        */
/*             *    &sysscp.  = WIN                                             */
/*             *    &libtype. = WIN                                             */
/*             *    &ostype.ype.  = WIN                                             */
/*                                                                              */
/*------------------------------------------------------------------------------*/

%if       &sysscp.            eq   WIN
and       %upcase(&libtype.)  eq   WIN  
and       %upcase(&server.)   eq   NULL      %then %do;

%let      path   = &home.\&dir1.\&dir2.\&type.;

%end;

%else %if &sysscp.            eq   WIN
and       %index(&home.,/)    ne   0
and       %upcase(&server.)   ne   NULL      %then %do;

%let      path   = &home./&dir1./&dir2./&type.;

%end;

%else %if &sysscpl.           eq   AIX       %then %do;

%let      path   = &home./&dir1./&dir2./&type.;

%end;


/*==============================================================================*/
/*                                                                              */
/* step 300    Assign the sas macro parmaeters to global variables.             */
/*                                                                              */
/*==============================================================================*/

%global   libref
          libpath
          libserver;

%let      libref         = &lib.;
%let      libpath        = &path.;
%let      libserver      = &server.;


/*==============================================================================*/
/*                                                                              */
/* step 302    Assign the Library Path to the libref macro variable name.       */
/*                                                                              */
/*==============================================================================*/

%global   &libref.;
          
%let      &libref.       = &libpath.;


/*==============================================================================*/
/*                                                                              */
/* step 303    If the macro was submitted under windows                         */
/*             Then send to the sas server.                                     */
/*                                                                              */
/*==============================================================================*/

%if       &sysscp. = WIN      %then %do;

%syslput  &libref.       = &libpath.;

%end;


/*==============================================================================*/
/*                                                                              */
/* step 400    Assigns Windows SAS Libraries                                    */
/*                                                                              */
/*==============================================================================*/

/*------------------------------------------------------------------------------*/
/*                                                                              */
/* step 401    Assigns a Locally submitted Windows SAS Library.                 */
/*                                                                              */
/*             local     No                                                     */
/*             submitted Server                                                 */
/*                                                                              */
/*             sysscp    libserver Description                                  */
/*             --------- --------- --------------------------------             */
/*             WIN       eq  NULL  Assign a local windows library               */
/*                                                                              */
/*------------------------------------------------------------------------------*/

%if       &sysscp.            eq   WIN       
and       %upcase(&server.)   eq   NULL      %then %do;

          systask   command   "mkdir -r &libpath.";

          libname   &libref.  "&libpath.";
     
          %global   &libref.;

          %let      &libref. = &libpath.;

          %let lib_name_rc   = 0;
          %let lib_name_code = NOTE:;
          %let lib_name_msg1 = The Windows Library has been successfully assigned!;
          %let lib_name_msg2 = ;
          %let lib_name_msg3 = ;

%end;



/*==============================================================================*/
/*                                                                              */
/* step 500    Assigns UNIX SAS Libraries                                       */
/*                                                                              */
/*==============================================================================*/

/*------------------------------------------------------------------------------*/
/* step 501    Assigns a Remote Submitted UNIX SAS Library Directory Path.      */
/*                                                                              */
/* Note:       1.   The lib_name sas macro was submitted to the local          */
/*                  windows sas system.                                         */
/*                  and                                                         */
/*             2.   The User specified a SAS Server option.                     */
/*                  and                                                         */
/*             3.   The User specified a UNIX Directory Path.                   */
/*                  and                                                         */
/*             4.   This resulted in Internal Remote Submit Statements          */
/*                  were generated.                                             */
/*                                                                              */
/*------------------------------------------------------------------------------*/

%if       &sysscp.                 eq   WIN
and       %upcase(&server.)        ne   NULL      %then %do;

          /*-------------------------------------------------------------------------*/
          /* 1.     Create Global Variables on sas server for the macro parms        */
          /*-------------------------------------------------------------------------*/

          %syslput  libref        = &libref.;
          %syslput  libpath       = &libpath.;
          %syslput  libserver     = &libserver.;

          %let      &libref.       = &libpath.;

          /*=========================================================================*/
          /*                                                                         */
          /* 2.     Generate Remote Submit Code.                                     */
          /*                                                                         */
          /*=========================================================================*/

          rsubmit;

          /*-------------------------------------------------------------------------*/
          /* 2.1    Create the SAS Library on the remote server.                     */
          /*-------------------------------------------------------------------------*/

          systask   command   "mkdir -p &libpath.";

          /*-------------------------------------------------------------------------*/
          /* 2.2    Assign the SAS Library to the SAS Libref.                        */
          /*-------------------------------------------------------------------------*/

          libname   &libref.  "&libpath.";

          /*-------------------------------------------------------------------------*/
          /* 2.3    Create the SAS Libref global variable to hold the library path.  */
          /*-------------------------------------------------------------------------*/

          %global   &libref.;

          %let      &libref. = &libpath.;

          /*-------------------------------------------------------------------------*/
          /* 2.4    Chmod the SAS Library Path.                                      */
          /*-------------------------------------------------------------------------*/

          /*=========================================================================*/
          /*                                                                         */
          /* 2.99   Generate the End of the Remote Submit Code.                      */
          /*                                                                         */
          /*=========================================================================*/

          endrsubmit;


          /*=========================================================================*/
          /* 3.     Issue the Local Libname connecting to the remote library.        */
          /*=========================================================================*/

          libname   &libref.  slibref=&libref.    server=&libserver.;

          /*=========================================================================*/
          /* 4.     Create the Library Allocation Return Code variables.             */
          /*=========================================================================*/

          %let lib_name_rc   = 0;
          %let lib_name_code = NOTE:;
          %let lib_name_msg1 = The Remote Unix Library has been successfully assigned!;
          %let lib_name_msg2 = ;
          %let lib_name_msg3 = ;


          /*=========================================================================*/
          /* 4.     Create the Library Allocation Return Code variables.             */
          /*=========================================================================*/

          /*-------------------------------------------------------------------------*/
          /* 4.1    Define Local Variables.                                          */
          /*-------------------------------------------------------------------------*/

          %local    dq   
                    lib_chmod_rc ;

          %let      dq             = %str(%");

          %let      lib_chmod_cmd  = &dq.chmod -R &chmod. &&libpath.&dq.; 

          %put      lib_chmod_cmd  = &lib_chmod_cmd.;

          /*-------------------------------------------------------------------------*/
          /* 4.2    Send the Library Chmod command to the sas server.                */
          /*-------------------------------------------------------------------------*/

          %syslput  lib_chmod_cmd  = &lib_chmod_cmd.;

          /*-------------------------------------------------------------------------*/
          /* 4.3    generate remote submit code.                                     */
          /*-------------------------------------------------------------------------*/

          rsubmit;

          /*-------------------------------------------------------------------------*/
          /* 4.4    Chmod the SAS Library Path.                                      */
          /*-------------------------------------------------------------------------*/

          systask   command   %unquote(&lib_chmod_cmd.)   
                    shell
                    wait 
                    taskname  = lib_chmod_task
                    status    = lib_chmod_rc ; 

          /*-------------------------------------------------------------------------*/
          /* 4.5    Generate the End of the remote submit code.                      */
          /*-------------------------------------------------------------------------*/

          endrsubmit;

%end;

/*------------------------------------------------------------------------------*/
/* step 502    Creates a LOCAL Submitted UNIX SAS Library Directory Path.       */
/*                                                                              */
/* Note:       1.   The lib_name SAS macro was submitted to the UNIX system    */
/*                  via a local submission or via remote submit.                */
/*                                                                              */
/*                  and                                                         */
/*                                                                              */
/*             2.   The User did NOT specify a SAS Server option.               */
/*                                                                              */
/*                  and                                                         */
/*                                                                              */
/*             3.   The User specified a UNIX Directory Path.                   */
/*                                                                              */
/*------------------------------------------------------------------------------*/

%if       &sysscpl.      eq   AIX            %then %do;

          /*-------------------------------------------------------------------------*/
          /* 1.     Issue Make Directory Command.                                    */
          /*-------------------------------------------------------------------------*/

          systask   command   "mkdir -p &libpath.";

          /*-------------------------------------------------------------------------*/
          /* 2.     Assign the libname to the libpath.                               */
          /*-------------------------------------------------------------------------*/

          libname   &libref.  "&libpath.";

          /*-------------------------------------------------------------------------*/
          /* 3.     Chmod the SAS Library Path.                                      */
          /*-------------------------------------------------------------------------*/

          %local    dq   
                    lib_chmod_rc ;

          %let      dq             = %str(%");

          %let      lib_chmod_cmd  = &dq.chmod -R &chmod. &libpath.&dq.; 
 
          systask   command   %unquote(&lib_chmod_cmd.)   
                    shell
                    wait 
                    taskname  = lib_chmod_task
                    status    = lib_chmod_rc ; 

          /*-------------------------------------------------------------------------*/
          /* 4.     Define the Libref Global variable to hold the Libpath.           */
          /*-------------------------------------------------------------------------*/

          %global   &libref.;

          %let      &libref. = &libpath.;

          /*-------------------------------------------------------------------------*/
          /* 5.     Define the Lib Alloc return code variables.                      */
          /*-------------------------------------------------------------------------*/

          %let lib_name_rc   = 0;
          %let lib_name_code = NOTE:;
          %let lib_name_msg1 = The Local Unix Library has been successfully assigned!;
          %let lib_name_msg2 = ;
          %let lib_name_msg3 = ;

%end;


/*==============================================================================*/
/*                                                                              */
/* step 800    Assigns the local libref to the remote sas library for viewing   */
/*             of the remote sas library on the local session.                  */
/*                                                                              */
/*==============================================================================*/

%put;
%put &lib_name_code. &dline.;
%put &lib_name_code. macro:        lib_name;
%put &lib_name_code. ;
%put &lib_name_code. Purpose:      Assigns a sas library directory path to the libref.;
%put &lib_name_code. ;
%put &lib_name_code. sysscp:       &sysscp.;
%put &lib_name_code. sysscpl:      &sysscpl.;
%put &lib_name_code. ;
%put &lib_name_code. Input Parameters:;
%put &lib_name_code. ;
%put &lib_name_code. lib:          &lib.;
%put &lib_name_code. home:         &home.;
%put &lib_name_code. app:          &app.;
%put &lib_name_code. project:      &project.;
%put &lib_name_code. type:         &type.;
%put &lib_name_code. ;
%put &lib_name_code. home:         &home.;
%put &lib_name_code. dir1:         &dir1.;
%put &lib_name_code. dir2:         &dir2.;
%put &lib_name_code. type:         &type.;
%put &lib_name_code. ;
%put &lib_name_code. ;
%put &lib_name_code. libref:       &libref.;
%put &lib_name_code. libpath:      &libpath.;
%put &lib_name_code. libserver:    &libserver.;
%put &lib_name_code. ;
%put &lib_name_code. Global Libref Macro Variable:;
%put &lib_name_code. ----------------------------;
%put &lib_name_code. ;
%put &lib_name_code. &libref. = &&&libref.;
%put &lib_name_code. ;
%put &lib_name_code. ;
%put &lib_name_code. lib_name_rc      = &lib_name_rc.;
%put &lib_name_code. ;
%put &lib_name_code. lib_name_msg1    = &lib_name_msg1.;
%put &lib_name_code. lib_name_msg2    = &lib_name_msg2.;
%put &lib_name_code. lib_name_msg3    = &lib_name_msg3.;
%put &lib_name_code. ;
%put &lib_name_code. ;
%put &lib_name_code. &dline.;
%put;


%mend;
%lib_name(
lib       = remxvic,
home      = default,
dir1      = mortgage,
dir2      = vic,
type      = output,
server    = default
); run;
