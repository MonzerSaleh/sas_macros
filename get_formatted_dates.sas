/*==============================================================================*/
/* syntax:          %get_formatted_dates(                                       */
/*                  prefix    =    cur,                                         */
/*                  date      =    yyyymmdd | yyyy-mm-dd | yyyy/mm/dd           */
/*                  suffix    =    dt | date                                    */
/*                  ); run;                                                     */
/* Descr:      This sas macro will create a series of output global macro  */
/*                  variables where the values are date formatted using         */
/*                  different output formats:                                   */
/*==============================================================================*/

%macro get_formatted_dates(
    prefix    = thisproc_,
    suffix    = dt,
    date      = yyyy-mm-dd
);
/*==============================================================================*/
/* step 000    Remove any Date Seperators.                                      */
%local    input_date;
%let      input_date     =    %sysfunc( compress(&date., '-/') );

/*==============================================================================*/
/* step 001    Define the ymdn Date formatted as:      YYYYMMDD                 */
%global   &prefix._ymdn_&suffix.;
%let      &prefix._ymdn_&suffix.   =    &input_date.;

/*==============================================================================*/
/* step 002    Parse the Input Date YYYYMMDD into date components.              */
%local    yyyy mm dd;
%let      yyyy      =    %substr(&input_date. ,1 ,4);
%let      mm        =    %substr(&input_date. ,5 ,2);
%let      dd        =    %substr(&input_date. ,7 ,2);

/*==============================================================================*/
/* step 003    Define the default SAS un-formatted date.                        */
%global   &prefix._sas_ndate;
%let      &prefix._sas_ndate    =    %sysfunc( mdy(&mm.,&dd.,&yyyy.) );


/*==============================================================================*/
/* step 004    Define the YMDD formatted date with dashes.                      */
%global   &prefix._ymd_&suffix.;
%let      &prefix._ymd_&suffix.   =    &yyyy.-&mm.-&dd.;

/*==============================================================================*/
/* step 005    Display the global variables to the sas log.                     */

%put ;
%put NOTE: ======================================================================;
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
%put NOTE: input_date           = &input_date.;
%put NOTE: ;
%put NOTE: Output Global Variables:;
%put NOTE: =======================;
%put NOTE: ;
%put NOTE: &prefix._ymdn_&suffix.  = &&&&&prefix._ymdn_&suffix..;
%put NOTE: ;
%put NOTE: &prefix._ymdd_&suffix.  = &&&&&prefix._ymdd_&suffix..;
%put NOTE: ;
%put NOTE: &prefix._sas_ndate      = &&&&&prefix._sas_ndate.;
%put NOTE: ;
%put NOTE: ======================================================================;
%put ;

%mend;
/*%get_formatted_dates( prefix=process_sta, date = 20120612 ); run;*/
