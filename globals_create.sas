/*------------------------------------------------------------------------------*/
/* MAcro:       globals_create                                                  */
/*                                                                              */        
/* Purpose:     This creates an empty sas table containing the following fields */
/*                                                                              */
/*              * Key         - specifies the name of the global macro variable */
/*                                                                              */
/*              * Value       - specifies the value of the macro variable       */
/*                                                                              */
/*              * comments    - specifies any comments to describe the variable.*/
/*                                                                              */        
/* Details:     lib      - specify the lirary where to create the member.       */
/*                                                                              */
/*              data     - specify the data set name of the control card member */
/*                                                                              */ 
/*------------+-----------------------------------------------------------------*/
/* YYYY-MM-DD | Maintenance Log                                                 */
/*============+=================================================================*/
/* 2005-02-18 | Created by Victor Neto, Bradimar Corporation                    */
/* 2017-07-04 | 2017 PASSWORD AUTHENTICATION REVIEW BY VICTOR NETO.             */
/*------------+-----------------------------------------------------------------*/
%macro globals_create  
 ( 
 lib   = work ,
 data  = globals_create
 );
                                                                                
/*------------------------------------------------------------------------------*/
/* Mac 001     Create a globals table                                           */
/*------------------------------------------------------------------------------*/

data &lib..&data ;
     length key $33. value $100. comments $100.;
     key = ' '; value = ' '; comments = ' '; output;
run;

%mend;
/*
%globals_create ( 
 lib  = sysxtab,
 data = sys_var_names 
 );
*/

