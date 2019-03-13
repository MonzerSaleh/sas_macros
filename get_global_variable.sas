/*==============================================================================*/
/*                                                                              */
/* macro:      get_global_variable                                              */
/*                                                                              */
/* note:  1.   this sas macro displays the global variable on the operating     */
/*             system where the sas macro was submitted.                        */
/*                                                                              */
/*============+=================================================================*/
/* YYYY-MM-DD | Description                                                     */
/*============+=================================================================*/
/* 2013-12-07 | created by victor neto.                                         */
/* 2017-07-04 | 2017 PASSWORD AUTHENTICATION REVIEW BY VICTOR NETO.             */
/*============+=================================================================*/
%macro get_global_variable(var);


%syslput &var. = &&&var.;

%put NOTE: &dline.;
%put NOTE: ;
%put NOTE: &var. = &&&var.;
%put NOTE: ;
%put NOTE: &dline.;

%mend;
/*%get_global_variable(unix_server); run;*/
