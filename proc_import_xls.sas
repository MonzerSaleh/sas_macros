/*==============================================================================*/
/* Macro:      proc_import_xls                                                  */
/*==============================================================================*/
%macro proc_import_xls(
    path          = null,          
    dsn           = null,
    sheet         = sheet1,
    lib           = appxcur,
    data          = null,
    outlib        = comxhis,
    out           = null
);

/*------------------------------------------------------------------------------*/
/* step 010    Define the Operating System Deliminators.                        */
/*------------------------------------------------------------------------------*/

%let      unix_dlm  = %str(/);
%let      win_dlm   = %str(\);

/*------------------------------------------------------------------------------*/
/* step 020    Determine if the path contains a unix or windows deliminator.    */
/*------------------------------------------------------------------------------*/

%if       %index(&path.,&unix_dlm.)     ne   0         %then %do;
          %let dlm                      =    %str(/);
%end;
%else %if %index(&path.,&win_dlm.)      ne   0         %then %do;
          %let dlm                      =    %str(\);
%end;

/*------------------------------------------------------------------------------*/
/* step 030    Build the datafile macro variable to hold the input file path.   */
/*------------------------------------------------------------------------------*/

%let      datafile            =    &path.&dlm.&dsn..xls;

/*------------------------------------------------------------------------------*/
/* step 040    Display the macro parmaeters to the sas log.                     */
/*------------------------------------------------------------------------------*/

%put ;
%put NOTE: &dline.;
%put NOTE: ;
%put NOTE: path          = &path.;
%put NOTE: dlm           = &dlm.;
%put NOTE: dsn           = &dsn.;
%put NOTE: sheet         = &sheet.;
%put NOTE: datafile      = &datafile.;
%put NOTE: ;
%put NOTE: lib           = &lib.;
%put NOTE: data          = &data.;
%put NOTE: ;
%put NOTE: outlib        = &outlib.;
%put NOTE: out           = &out.;  
%put NOTE: ;
%put NOTE: &dline.;
%put ;


/*------------------------------------------------------------------------------*/
/*                                                                              */
/* step 101    generate the remote submit statements when submitted in          */
/*             a windows session.                                               */
/*                                                                              */
/*------------------------------------------------------------------------------*/

%if  &sysscp.  =    WIN      
and  &dlm.     =    %str(/)   %then %do;

     %syslput path       = &path.;
     %syslput dsn        = &dsn.;
     %syslput sheet      = &sheet.;
     %syslput datafile   = &datafile.;

     %syslput lib        = &lib.;
     %syslput data       = &data.;

     %syslput outlib     = &outlib.;
     %syslput out        = &out.;

     rsubmit;

%end;

proc import out               =    &lib..&data.
          datafile            =    "&datafile."

          %if  &dlm.          =    &win_dlm.      %then %do;
          dbms                =    EXCEL
          %end;

          %if  &dlm.          =    &unix_dlm.     %then %do;
          dbms                =    XLS  
          %end;

          replace;

          %if       &dlm.     =    &win_dlm.      %then %do;
          sheet               =    "&sheet.$";
          getnames            =    yes;
          mixed               =    yes;
          scantext            =    yes;
          usedate             =    yes;
          scantime            =    yes;
          %end;

          %if       &dlm.     =    &unix_dlm.     %then %do;
          sheet               =    "&sheet.";
          %end;

run;

%mend;
/*%put syswctl = &syswctl.;*/
/*%proc_import_xls(*/
/*path      = &syswctl.,*/
/*dsn       = netoware_system_control_v3,*/
/*sheet     = netoware_system_libraries,*/
/*lib       = sasuser,*/
/*data      = netoware_system_libraries,*/
/*outlib    = sasuser,*/
/*out       = netoware_system_libraries */
/*); run;*/
