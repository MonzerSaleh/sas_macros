/*------------------------------------------------------------------------------*/
/* Macro:      dir_create                                                       */
/* Purpose:    1.   Create an external physical directory path.                 */
/* Syntax:     1.   %dir_create ( <path> ); run;                                */
/* ---------------------------------------------------------------------------- */
/* Windows:                                                                     */
/* Notes:      1.   path      is the complete directory path.                   */
/*             eg.  path      =    t:\vic\mydir                                 */
/* ---------------------------------------------------------------------------- */
/* Codes:      1.   Return Code Macro Variable = dir_create_rc                  */
/*                                                                              */
/*                  RC   Description of return code.                            */
/*                  ==   ====================================================== */
/*                                                                              */
/*                  0    specifies the directory was created successfully.      */
/*                                                                              */
/*                  1    specifies the directory was creation failed.           */
/*============+=================================================================*/

%macro dir_create(path);

/*==============================================================================*/
/* step 010    Reset the Directory Create Return Code to zero.                  */
/*==============================================================================*/

%global   dir_create_rc ;

%let      dir_create_rc  = X;


/*==============================================================================*/
/* step 020    Issue the Directory Create Command by Operating System.          */
/*==============================================================================*/

systask     command 
            "mkdir &path."
            wait 
            status    =    dir_create_rc;

/*==============================================================================*/
/* step 030    Display the status box to the sas log.                           */
/* Options:    Return Code    Description                                       */
/* -------     -----------    ------------------------------------------------- */
/*             0              The directory was successfully created.           */
/*             1              The directory already exists.                     */
/*==============================================================================*/

%if       &dir_create_rc.     = 0       %then %do;    

          %putmlog (
          name = dir_create,
          var  = dir_delete_rc ,
          rc   = 0 ,   
          msg1 = The following directory path was successfully created:,
          msg2 = Directory Path: &path.
          );
 
%end;

%else %if &dir_create_rc.     = 1       %then %do;    

          %putmlog (
          name = dir_create,
          var  = dir_delete_rc ,
          rc   = 1 ,   
          msg1 = The following directory path already exists,
          msg2 = Directory Path: &path.
          );
 
%end;


%mend;
/*%dir_create(S:\test\vic3); run;*/

