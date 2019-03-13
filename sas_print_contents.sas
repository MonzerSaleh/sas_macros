/*==============================================================================*/
/* Macro:      1.   sas_print_contents                                          */
/* Notes:      1.   This sas macro is designed to perform a PROC Contents       */
/*                  Variable listing and exports the listing to an excel        */
/*                  file.                                                       */
/* ---------------------------------------------------------------------------- */
/* Input Parms:                                                                 */
/*             1.   LIB       =    speccify the SAS library where the input     */
/*                                 SAS table is located.                        */
/*                  DEFAULT:  WORK                                              */
/*             2.   DATA      =    specify the Input SAS dataset that is being  */
/*                                 exported to a CSV file.                      */
/*                                                                              */
/*                  DEFAULT:  _LAST_                                            */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/* Output Contents Dataset Parms:                                               */
/*                                                                              */
/*             1.   OUTLIB    =    specify the SAS library where the SAS Export */
/*                                 Variable List dataset is located.            */
/*                                                                              */
/*                                 DEFAULT:  WORK                               */
/*                                                                              */
/*             2.   OUT       =    specify the SAS dataset containing the SAS   */
/*                                 export variable list.                        */
/*                                                                              */
/*                                 DEFAULT:  SAS_EXPORT_VAR_LIST                */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/* Output Contents Excel File Parms:                                            */
/*                                                                              */
/*             1.   outdir   =    specify the Output Directory Path where the  */
/*                                 CSV file is to be created.                   */
/*                                                                              */
/*                                 DEFAULT:  &appwout.                          */
/*                                                                              */
/*             2.   OUTDSN    =    specify the Output External Dataset Name     */
/*                                 that is to be created.                       */
/*                                                                              */
/*                                 DEFAULT:  sas_export_csv_file                */
/*                                                                              */
/*             3.   OUTEXT    =    specify the Output External Dataset Name     */
/*                                 Extension that is to be created.             */
/*                                                                              */
/*                                 DEFAULT:  csv                                */
/*                                                                              */
/*==============================================================================*/
%macro sas_print_contents(
lib       = work,
data      = _LAST_,
outlib    = work,
out       = sas_export_var_list,
outdir    = &appwout.,
outdsn    = sas_print_contents,
outext    = htm
); 


/*==============================================================================*/
/*                                                                              */
/* step 010    Convert the prefix to upper case.                                */
/*                                                                              */
/*==============================================================================*/

/*------------------------------------------------------------------------------*/
/* step 011    Convert Input Parameters to lower case.                          */
/*------------------------------------------------------------------------------*/

%let      lib       =    %lowcase(&lib.);
%let      data      =    %lowcase(&data.);

/*------------------------------------------------------------------------------*/
/* step 012    Convert Output parameters to lower case.                         */
/*------------------------------------------------------------------------------*/

%let      outlib    =    %lowcase(&outlib.);
%let      out       =    %lowcase(&out.);

/*------------------------------------------------------------------------------*/
/* step 013    Convert Output parameters to lower case.                         */
/*------------------------------------------------------------------------------*/

%let      outdir    =    %lowcase(&outdir.);
%let      outdsn    =    %lowcase(&outdsn.);
%let      outext    =    %lowcase(&outext.);

/*------------------------------------------------------------------------------*/
/* step 014    Check the outdir for the output delimiter                       */
/*------------------------------------------------------------------------------*/

%if       %index(&outdir.,&aixdlm.) ne 0 %then %do;
%let      outdlm    = &aixdlm.;
%end;
%else %if %index(&outdir.,&windlm.) ne 0 %then %do;
%let      outdlm    = &windlm.;
%end;

/*------------------------------------------------------------------------------*/
/* step 015    Build the output file parameter.                                 */
/*------------------------------------------------------------------------------*/

%let      outfile   =    &outdir.&outdlm.&outdsn..&outext.;

/*------------------------------------------------------------------------------*/
/* step 016    Display the SAS macro parameters.                                */
/*------------------------------------------------------------------------------*/

%put NOTE: &dline.;
%put NOTE: Macro:   sas_print_contents.sas;
%put NOTE: ;
%put NOTE: ;
%put NOTE: Input Parameters:;
%put NOTE: ;
%put NOTE: lib      = &lib.;
%put NOTE: data     = &data.;
%put NOTE: ;
%put NOTE: outlib   = &outlib.;
%put NOTE: out      = &out.;
%put NOTE: ;
%put NOTE: outdir   = &outdir.;
%put NOTE: outdlm   = &outdlm.;
%put NOTE: outdsn   = &outdsn.;
%put NOTE: outext   = &outext.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: &dline.;
 

/*==============================================================================*/
/*                                                                              */
/* step 020    Create a list of SAS Variables to be exported.                   */
/*                                                                              */
/* Note:       1.   This step creates a list of the sas variables that are      */
/*                  to be exported to the output csv file.                      */
/*                                                                              */
/* input:      1.   &lib..&data.                                                */
/*                  appxcur.gic_price_tool_history_2                            */
/*                                                                              */
/* output:     1.   &outlib..&out.                                              */
/*                  work.sas_export_var_list                                    */
/*                                                                              */
/*==============================================================================*/

proc contents data=&lib..&data.    
     memtype   =    data
     out       =    &outlib..&out.
     (keep     =    libname  memname
                    varnum name label length format formatl formatd type );
run;


/*==============================================================================*/
/*                                                                              */
/* step 030    Print the list of sas variables to an html report.               */
/*                                                                              */
/* output:     1.   &outlib..&out.                                              */
/*                  work.sas_export_var_list                                    */
/*                                                                              */
/*==============================================================================*/

ods html file = "&outdir.\&outdsn..&outext.";
proc print data = &outlib..&out.;
run;
ods html close;


%mend;
/*options nomacrogen nosymbolgen nomlogic mprint source source2;*/
/*%sas_print_contents(*/
/* lib    = appxcur,*/
/* data   = cmp_cust_accts_7,*/
/* outdir = &appwout.,*/
/* outdsn = cmp_cust_accts_7*/
/* ); run;*/
