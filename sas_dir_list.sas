/*==============================================================================*/
/* Macro:           sas_dir_list                                                */
/* ---------------------------------------------------------------------------- */
/* note:       1.   This sas macro performs a sas directory list using the sas  */
/*                  dictionary table ( sashelp.vtable ).                        */
/* note:       2.   a sas dataset is returned with a list of sas datasets       */
/*                  in the sas library.                                         */
/*==============================================================================*/
%macro sas_dir_list(
 lib      = ,
 data     = ,
 nobs     = all,
 outlib   = work,
 out      = sas_dir_list,
 delete   = none  
 ); 

/*==============================================================================*/
/*                                                                              */
/* step 010    convert parms to upcase.                                         */
/*                                                                              */
/*==============================================================================*/

%let lib     = %upcase(&lib.);
%let data    = %upcase(&data.);

%let nobs    = %upcase(&nobs.);

%let outlib  = %upcase(&outlib.);
%let out     = %upcase(&out.);

%let delete  = %upcase(&delete.);


/*==============================================================================*/
/*                                                                              */
/* step 010    convert parms to upcase.                                         */
/*                                                                              */
/*==============================================================================*/

%let mylib     = &&&lib.;
%let mylibobs  = %index(&mylib.,%str(/));

%put mylib     = &mylib.;
%put mylibobs  = &mylibobs.;


%syslput lib        = &lib.;
%syslput data       = &data.;

%syslput nobs       = &nobs.;

%syslput outlib     = &outlib.;
%syslput out        = &out.;

%syslput delete     = &delete.;



/*==============================================================================*/
/*                                                                              */
/* step 020    create a sas directory dataset list.                             */
/*                                                                              */
/*==============================================================================*/

proc sql;

     create table &outlib..&out.   as 

     select    libname, 
               memname,
               nobs

     from      sashelp.vtable 

     where     libname   =         "&lib."
     and       memname   like      "&data.%"

     %if       &nobs.    =         0
     or        &nobs.    =         ZERO
     or        &nobs.    =         EMPTY     %then %do;
     and       nobs      =         &nobs.
     %end;
     ;
     quit;
run;

/*==============================================================================*/
/*                                                                              */
/* step 030    Delete any empty sas datasets.                                   */
/*                                                                              */
/*==============================================================================*/

%if &delete.   =    EMPTY     %then %do;

data &outlib..&out.;

     set  &outlib..&out.;

     statement = '%lib_delete('    ||
                 "lib="            ||
                 strip(libname)    ||
                 ","               ||
                 "data="           ||
                 strip(memname)    ||
                 ");run;";         

     if   _n_       >    0

     and  nobs      =    0    then do;

     call execute( statement );

     end;

run;

%end;


%mend;
/*%sas_dir_list(*/
/* lib      = appxdat,*/
/* data     = trn_week,*/
/* nobs     = all,*/
/* outlib   = appxdat,*/
/* out      = sas_dir_list*/
/* ); */
