/*==============================================================================*/
/* syntax:          %get_formatted_dates(                                       */
/*                  prefix    =    cur,                                         */
/*                  date      =    yyyymmdd | yyyy-mm-dd | yyyy/mm/dd           */
/*                  suffix    =    dt | date                                    */
/*                  ); run;                                                     */
/* Descr:      This sas macro will create a series of output global macro  */
/*                  variables where the values are date formatted using         */
/*                  different output formats:                                   */
/*                                                                              */
/*                  Name      =    Variable            =    output format       */
/*                  ========= =    ==================  =    =================== */
/*                  ymdn      =    &prefix._ymdn_date  =    YYYYMMDD            */
/*                  ymdd      =    &prefix._ymdd_date  =    YYYY-MM-DD          */
/*                  ymddq     =    &prefix._ymddq_date =    'YYYY-MM-DD'        */
/*                  sas       =    &prefix._sas_date   =    19516               */
%macro get_formatted_dates(
    prefix    = process_sta,
    suffix    = dt,
    date      = yyyy-mm-dd
);
/*==============================================================================*/
/* step 010    Remove any Date Seperators.                                      */
%local    input_date;
%let      input_date     =    %sysfunc( compress(&date., '-/') );

/*==============================================================================*/
/* step 020    Define the ymdn Date formatted as:      YYYYMMDD                 */
%global   &prefix._ymdn_&suffix.;
%let      &prefix._ymdn_&suffix.   =    &input_date.;

/*==============================================================================*/
/* step 030    Parse the Input Date YYYYMMDD into date components.              */
%local    yyyy mm dd;
%let      yyyy      =    %substr(&input_date. ,1 ,4);
%let      mm        =    %substr(&input_date. ,5 ,2);
%let      dd        =    %substr(&input_date. ,7 ,2);

/*==============================================================================*/
/* step 040    Define the default SAS un-formatted date.                        */
%global   &prefix._sas_&suffix.;
%let      &prefix._sas_&suffix.    =    %sysfunc( mdy(&mm.,&dd.,&yyyy.) );

/*==============================================================================*/
/* step 050    Define the YMDD formatted date with dashes.                      */
%global   &prefix._ymdd_&suffix.;
%let      &prefix._ymdd_&suffix.   =    &yyyy.-&mm.-&dd.;

/*==============================================================================*/
/* step 060    Define the YMDDQ formatted date with quotes and dashes.          */
%global   &prefix._ymddq_&suffix.;
%let      &prefix._ymddq_&suffix.  = &sq.&yyyy.-&mm.-&dd.&sq.;

/*==============================================================================*/
/* step 070    Display the global variables to the sas log.                     */

%put ;
%put NOTE: &dline.;
%put NOTE: macro:        create_formatted_dates;
%put NOTE: ;
%put NOTE: ;
%put NOTE: note:    1.   Creates a series of formatted global macro date variables;
%put NOTE:               from an input date.;
%put NOTE: ;
%put NOTE: note:    2.   The input date may be one of the following formats:;
%put NOTE: ;
%put NOTE:               *    YYYYMMDD;
%put NOTE:               *    YYYY/MM/DD;
%put NOTE:               *    YYYY-MM-DD;
%put NOTE: ;
%put NOTE: ;
%put NOTE: Input Parameters:;
%put NOTE: ================;
%put NOTE: ;
%put NOTE: prefix               = &prefix.;
%put NOTE: ;
%put NOTE: input_date           = &input_date.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: Output Global Variables:;
%put NOTE: =======================;
%put NOTE: ;
%put NOTE: &prefix._ymdn_&suffix.  = &&&&&prefix._ymdn_&suffix..;
%put NOTE: ;
%put NOTE: &prefix._ymdd_&suffix.  = &&&&&prefix._ymdd_&suffix..;
%put NOTE: ;
%put NOTE: &prefix._ymddq_&suffix. = &&&&&prefix._ymddq_&suffix..;
%put NOTE: ;
%put NOTE: &prefix._sas_&suffix.   = &&&&&prefix._sas_&suffix..;
%put NOTE: ;
%put NOTE: ;
%put NOTE: &dline.;
%put ;

%mend;
/*%get_formatted_dates( prefix=process_sta, date = 20120612 ); run;*/
