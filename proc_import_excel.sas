/*==============================================================================*/
/*                                                                              */
/* Macro:      proc_import_excel                                                */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/* Parms:      1.   path           specify the directory path where the input   */
/*                                 excel file is located.                       */
/* Parms:      2.   dsn            specify the file name of the input excel     */
/*                                 file.                                        */
/* Parms:      3.   file           specify the file name of the input excel     */
/*                                 file.                                        */
/*                                 obsolete                                     */
/* Parms:      3.   ext            specify the file extension of the input      */
/*                                 excel file.                                  */
/* Parms:      4.   sheet          specify the excel worksheet name to be       */
/*                                 imported.                                    */
/* Parms:      5.   outlib         specify the output sas library name where    */
/*                                 the sas dataset is to be created.            */
/* Parms:      6.   out            specify the output sas dataset name to       */
/*                                 be created.                                  */
/*==============================================================================*/
%MACRO PROC_IMPORT_EXCEL(
 path     = null,
 dsn      = null,
 file     = null,
 ext      = xlsx,
 sheet    = sheet1,
 outlib   = work,
 out      = null,
 version  = 2010,
 rectype  = yes
 );

/*==============================================================================*/
/* step 010    Define the Operating System Deliminators.                        */
/*==============================================================================*/

%let      aix_dlm   = %str(/);
%let      win_dlm   = %str(\);

/*==============================================================================*/
/* step 00020  convert rectype parm to uppercase.      ( YES = Y | NO = N )     */
/*==============================================================================*/

%let      rectype   =    %upcase(&rectype.);
%let      rectype   =    %substr(&rectype.,1,1);

/*==============================================================================*/
/* step 020    Define the file deliminator                                      */
/*==============================================================================*/

%let dlm                      =    %str(/);

/*==============================================================================*/
/* step 030    Build the datafile macro variable to hold the input file path.   */
/*==============================================================================*/

%IF       %upcase(&FILE.)               EQ   NULL
AND       %upcase(&DSN.)                NE   NULL
%THEN %DO;
          %let DSN                      =    &DSN.;
%end;

%IF       %upcase(&file.)               NE   NULL
AND       %upcase(&DSN.)                EQ   NULL
%THEN %DO;
          %let DSN                      =    &FILE.;
%END;

%IF       %upcase(&file.)               ne   NULL
and       %upcase(&dsn.)                ne   NULL
%THEN %DO;
          %LET DSN                      =    &DSN.;
%END;

/*==============================================================================*/
/* step 030    Build the datafile macro variable to hold the input file path.   */
/*==============================================================================*/

%let      datafile       =    &PATH.&DLM.&DSN..&EXT.;

/*==============================================================================*/
/* step 040    Display the macro parmaeters to the sas log.                     */
/*==============================================================================*/

%put ;
%put NOTE: &dline.;
%put NOTE: MACRO:   PROC_IMPORT_EXCEL;
%put NOTE: ;
%put NOTE: ;
%put NOTE: SYSSCP        = &SYSSCP.;
%put NOTE: dlm           = &dlm.;
%put NOTE: ;
%put NOTE: path          = &path.;
%put NOTE: datafile      = &datafile.;
%put NOTE: ext           = &ext.;
%put NOTE: sheet         = &sheet.;
%put NOTE: ;
%put NOTE: outlib        = &outlib.;
%put NOTE: out           = &out.;  
%put NOTE: ;
%put NOTE: RECTYPE       = &RECTYPE.;  
%put NOTE: ;
%put NOTE: ;
%put NOTE: &dline.;
%put ;



/*==============================================================================*/
/*==============================================================================*/
/*                                                                              */
/* step 10000  WIN SAS 9.3 32-BIT            EXCEL 2010                         */
/*                                                                              */
/*==============================================================================*/
/*==============================================================================*/


/*==============================================================================*/
/*                                                                              */
/* step 11032  WIN SAS 9.3 32-BIT            EXCEL 2010 xls                     */
/*                                                                              */
/*==============================================================================*/

%IF            &dlm.               =    &win_dlm.
AND            &sysver.            =    9.3
AND            &version.           =    2010
AND            &ext.               =    xls                 
%THEN %DO; 

PROC IMPORT    OUT                 =    &outlib..&out.
               DATAFILE            =    "&datafile."
               DBMS                =    EXCEL
               REPLACE;

               SHEET               =    "&SHEET.";

               getnames            =    yes;
RUN;

%END;

/*==============================================================================*/
/*                                                                              */
/* step 12032  WIN SAS 9.3 32-BIT            EXCEL 2010 xlsx                    */
/*                                                                              */
/*==============================================================================*/

%IF            &dlm.               =    &win_dlm.
AND            &sysver.            =    9.3
AND            &version.           =    2010
AND            &ext.               =    xlsx                
%THEN %DO; 

PROC IMPORT    OUT                 =    &outlib..&out.
               DATAFILE            =    "&datafile."
               DBMS                =    EXCEL
               REPLACE;

               SHEET               =    "&SHEET.";

               getnames            =    yes;
RUN;

%END;





/*==============================================================================*/
/*==============================================================================*/
/*                                                                              */
/* step 20000  SAS WINDOWS 9.4 64-BIT        EXCEL 2010 xls                     */
/*                                                                              */
/*==============================================================================*/
/*==============================================================================*/


/*==============================================================================*/
/*                                                                              */
/* step 21064  win sas 9.4 64-bit  AND  EXCEL 2010 xls                          */
/*                                                                              */
/*==============================================================================*/

%IF            &dlm.               =    &win_dlm.
AND            &sysver.            =    9.4   
AND            &version.           =    2010
AND            &ext.               =    xls  
%THEN %DO; 

PROC IMPORT    OUT                 =    &outlib..&out.
               DATAFILE            =    "&datafile."
               DBMS                =    EXCEL 
               REPLACE;

               SHEET               =    "&sheet.";

               getnames            =    yes;
RUN;

%END;


/*==============================================================================*/
/*                                                                              */
/* step 22064  win sas 9.4 64-bit  AND  EXCEL 2010 xlsx                         */
/*                                                                              */
/*==============================================================================*/

%IF            &dlm.               =    &win_dlm.
    AND            &sysver.            =    9.4   
    AND            &version.           =    2010
    AND            &ext.               =    xlsx 
%THEN %DO; 

    PROC IMPORT    OUT                 =    &outlib..&out.
                   DATAFILE            =    "&datafile."
                   DBMS                =    xlsx  
                   REPLACE;
                   SHEET               =    "&sheet.";
                   GETNAMES            =    yes;
    RUN;

%END;

%IF       &rectype. = Y                 %THEN %DO;

DATA &outlib..&out.;
     set  &outlib..&out.;
     IF   RECTYPE = 'A';
RUN;

%END;


%mend;
/*options nomacrogen symbolgen mlogic mprint source source2 notes;*/
/*%proc_import_excel(*/
/* path     = &appxtab.,*/
/* dsn      = edw_metadata,*/
/* sheet    = owssvr,*/
/* outlib   = APPXTAB,*/
/* out      = edw_metadata,*/
/* rectype  = no*/
/* ); run;*/
