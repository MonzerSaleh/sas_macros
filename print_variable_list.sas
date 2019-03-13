/*==============================================================================*/
/*                                                                              */
/* macro:      print_variable_list                                              */
/*                                                                              */
/* Purpose:    1.   create a variable list from a sas dataset.                  */
/*                                                                              */
/* Parms:      1.   lib       =    specify the input sas library                */
/*                                                                              */
/*             2.   data      =    specify the input sas dataset                */
/*                                                                              */
/*             3.   outlib    =    specify the output sas library               */
/*                                                                              */
/*             4.   out       =    specify the output dataset.                  */
/*                                                                              */
/*             5.   remote    =    This is obsolete.                            */
/*                                                                              */
/*==============================================================================*/
%macro print_variable_list(
lib       = appxcur,
data      = camp_cust_acct_data_1,

outlib    = NULL,
out       = NULL,
remote    = OBSOLETE
); 


/*==============================================================================*/
/*                                                                              */
/* step 010    Generate the Remote Submit statement.                            */
/*                                                                              */
/*==============================================================================*/

%if       &sysscp.  = WIN          %then %do;

%syslput  lib       = &lib.;
%syslput  data      = &data.;

%syslput  outlib    = &outlib.;
%syslput  out       = &out.;

rsubmit;

%end;


/*==============================================================================*/
/*                                                                              */
/* step 030    Print the sas dataset contents.                                  */
/*                                                                              */
/*==============================================================================*/

proc contents data = &lib..&data.       details varnum 

     %if  &outlib.  ne NULL 
     and  &out.     ne NULL   %then %do;

          out = &outlib..&out.

     %end;

     ;

run;


/*==============================================================================*/
/*                                                                              */
/* step 040    Generate the endrsubmit statement.                               */
/*                                                                              */
/*==============================================================================*/

%if  &sysscp. = WIN %then %do;

endrsubmit;

%end;


%mend;
/*%print_variable_list(*/
/*lib       = sashelp,*/
/*data      = class,*/
/*outlib    = appxcur, */
/*out       = class*/
/*); run;*/
