/*===================================================================================*/
/* Purpose:    1.   Creates a TABLE CONTENTS LISTING FOR AN INPUT TABLE.             */
/* ----------------------------------------------------------------------------------*/
/* PARMS:      1.   LIB       =    specify the input sas library name.               */
/*             2.   DATA      =    specify the input sas dataset name.               */
/*             3.   OUTLIB    =    specify the output sas library name.              */
/*             4.   OUT       =    specify the output sas dataset name.              */
/*             5.   KEEP      =    STANDARD                                          */
/*             6.   RENAME    =    NO                                                */
/*===================================================================================*/
%MACRO PROC_TABLE_CONTENTS(
 DATABASE  = NULL,
 lib       = WORK,
 data      = _LAST_,
 outlib    = NULL,
 out       = NULL,
 keep      = STANDARD,
 rename    = NO
 );


/*===================================================================================*/
/*                                                                                   */
/* step 001    convert to upper case.                                                */
/*                                                                                   */
/*===================================================================================*/

%let lib       =    &lib.;
%let data      =    %upcase(&data.);
%let outlib    =    %upcase(&outlib.);
%let out       =    %upcase(&out.);
%let keep      =    %upcase(&keep.);
%let rename    =    %upcase(&rename.);


/*===================================================================================*/
/* step 010    Generate the Remote Submit statement.                                 */
/*===================================================================================*/

%syslput  DATABASE  = &DATABASE.;
%syslput  lib       = &lib.;
%syslput  data      = &data.;

%syslput  outlib    = &outlib.;
%syslput  out       = &out.;

%syslput  keep      = &keep.;
%syslput  rename    = &rename.;



/*===================================================================================*/
/*                                                                                   */
/* step 030    Print the sas dataset contents.                                       */
/*                                                                                   */
/*===================================================================================*/

proc contents data = &lib..&data.       VARNUM 

     %if  &outlib.  ne NULL 
     and  &out.     ne NULL   %then %do;

          out = &outlib..&out.

     %end;

     ;

run;



/*===================================================================================*/
/*                                                                                   */
/* step 040    Keep Standard Variables                                               */
/*                                                                                   */
/*===================================================================================*/

%if  &keep. = STANDARD   %then %do;

data &outlib..&out.;

     /*==============================================================================*/
     /* 1.     read the contents dataset.                                            */
     /*==============================================================================*/

     set       &outlib..&out.;

     /*==============================================================================*/
     /* 2.     rename the contents variables.                                        */
     /*==============================================================================*/

     %if  &rename. = YES %then %do;

          /*-------------------------------------------------------------------------*/
          /* 1.     rename   the libname to src_lib                                  */
          /*-------------------------------------------------------------------------*/

          rename    libname   =    src_lib;
          label     libname   =    'src_lib';

          /*-------------------------------------------------------------------------*/
          /* 2.     rename   memname to src_table                                    */
          /*-------------------------------------------------------------------------*/

          rename    memname   =    src_table;
          label     memname   =    'src_table';

          /*-------------------------------------------------------------------------*/
          /* 3.     rename   name    to src_var                                      */
          /*-------------------------------------------------------------------------*/

          rename    name      =    src_var;
          label     name      =    'src_var';

          /*-------------------------------------------------------------------------*/
          /* 4.     rename   data type to src_type                                   */
          /*-------------------------------------------------------------------------*/

          if        type      =    1
          then      src_type  =    'N';
          else      src_type  =    'C';

          /*-------------------------------------------------------------------------*/
          /* 5.     rename   format variables.                                       */
          /*-------------------------------------------------------------------------*/

          rename    format    =    src_fmt;
          label     format    =    'src_fmt';

          rename    formatl   =    src_fmtl;
          label     formatl   =    'src_fmtl';

          rename    formatd   =    src_fmtd;
          label     formatd   =    'src_fmtd';

          /*-------------------------------------------------------------------------*/
          /* 6.     rename informat variables.                                       */
          /*-------------------------------------------------------------------------*/

          rename    informat  =    src_infmt;
          label     informat  =    'src_infmt';

          rename    informl   =    src_infmtl;
          label     informl   =    'src_infmtl';

          rename    informd   =    src_infmtd;
          label     informd   =    'src_infmtd';

     %end;

     /*==============================================================================*/
     /* 3.     Keep Contents Variables                                               */
     /*==============================================================================*/

     keep 
               VARNUM
               LIBNAME
               MEMNAME
               NAME
               TYPE
               FORMAT
               FORMATL
               FORMATD
               INFORMAT
               INFORML
               INFORMD;
run;

%end;

%mend;
/*%PROC_TABLE_CONTENTS(*/
/* DATABASE = OWSTAR,*/
/* lib      = CIA,*/
/* data     = cvp_branch_trans_volume,*/
/* outlib   = work, */
/* out      = CUST_BASE_LIST,*/
/* keep     = standard,*/
/* RENAME   = NO*/
/* ); run;*/
