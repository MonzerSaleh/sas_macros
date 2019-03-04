/*==============================================================================*/
/*                                                                              */
/* MACRO:           DISPLAY_ACTIVE_DATES                                        */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* NOTE:       1.   DISPLAY THE ACTIVE DATES GLOBAL VARIABLES THAT WERE         */
/*                  CREATED BY THE GET_ACTIVE_DATES SAS MACRO.                  */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* PARMS:      1.   PERIODS        SPECIFY THE PERIODS.                         */
/*                                                                              */
/*                                 DEFAULT:  16                                 */
/*                                                                              */
/* PARMS:      2.   TYPE           SPECIFY THE TYPE OF DATES.                   */
/*                                                                              */
/*                                 DEFAULT:  EDW  =    '01JAN2017'D             */
/*                                 OPTIONS:  EDW  =    '2017-01-01'             */
/*                                                                              */
/*                                                                              */
/*==============================================================================*/
%MACRO DISPLAY_ACTIVE_DATES(
 PERIODS  = 16,
 TYPE     = EDW
 );



/*==============================================================================*/
/*                                                                              */
/* MAIN 01000       CONVERT TYPE TO UPPER CASE.                                 */
/*                                                                              */
/*==============================================================================*/

%let type = %upcase(&type.);



/*==============================================================================*/
/*                                                                              */
/* MAIN 02000       DISPLAY ORA FORMATTED DATES.                                */
/*                                                                              */
/*==============================================================================*/

%IF %UPCASE(&TYPE.) = ORA %THEN %DO;


%DO  I = 1 %TO &PERIODS.;

     %IF       &I.  LE   9 
     %THEN     %LET PFX  =    M0&I.;
     %ELSE     %LET PFX  =    M&I.;

     %PUT NOTE: ;
     %PUT NOTE: &PFX._A001M_SOP_ORA_DATE:  &&&PFX._A001M_SOP_ORA_DATE.;
     %PUT NOTE: &PFX._A001M_EOP_ORA_DATE:  &&&PFX._A001M_EOP_ORA_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: &PFX._A003M_SOP_ORA_DATE:  &&&PFX._A003M_SOP_ORA_DATE.;
     %PUT NOTE: &PFX._A003M_EOP_ORA_DATE:  &&&PFX._A003M_EOP_ORA_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: &PFX._A006M_SOP_ORA_DATE:  &&&PFX._A006M_SOP_ORA_DATE.;
     %PUT NOTE: &PFX._A006M_EOP_ORA_DATE:  &&&PFX._A006M_EOP_ORA_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: ;
     %PUT NOTE: &PFX._A030D_SOP_ORA_DATE:  &&&PFX._A030D_SOP_ORA_DATE.;
     %PUT NOTE: &PFX._A030D_EOP_ORA_DATE:  &&&PFX._A030D_EOP_ORA_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: &PFX._A090D_SOP_ORA_DATE:  &&&PFX._A090D_SOP_ORA_DATE.;
     %PUT NOTE: &PFX._A090D_EOP_ORA_DATE:  &&&PFX._A090D_EOP_ORA_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: &PFX._A180D_SOP_ORA_DATE:  &&&PFX._A180D_SOP_ORA_DATE.;
     %PUT NOTE: &PFX._A180D_EOP_ORA_DATE:  &&&PFX._A180D_EOP_ORA_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: &DLINE.;

%END;

%END;



/*==============================================================================*/
/*                                                                              */
/* MAIN 03000       DISPLAY EDW FORMATTED DATES.                                */
/*                                                                              */
/*==============================================================================*/

%IF  %UPCASE(&TYPE.) = EDW     %THEN %DO;

%DO  I = 1 %TO &PERIODS.;

     %IF       &I.  LE   9 
     %THEN     %LET PFX  =    M0&I.;
     %ELSE     %LET PFX  =    M&I.;

     %PUT NOTE: ;
     %PUT NOTE: &PFX._A001M_SOP_EDW_DATE:  &&&PFX._A001M_SOP_EDW_DATE.;
     %PUT NOTE: &PFX._A001M_EOP_EDW_DATE:  &&&PFX._A001M_EOP_EDW_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: &PFX._A003M_SOP_EDW_DATE:  &&&PFX._A003M_SOP_EDW_DATE.;
     %PUT NOTE: &PFX._A003M_EOP_EDW_DATE:  &&&PFX._A003M_EOP_EDW_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: &PFX._A006M_SOP_EDW_DATE:  &&&PFX._A006M_SOP_EDW_DATE.;
     %PUT NOTE: &PFX._A006M_EOP_EDW_DATE:  &&&PFX._A006M_EOP_EDW_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: ;
     %PUT NOTE: &PFX._A030D_SOP_EDW_DATE:  &&&PFX._A030D_SOP_EDW_DATE.;
     %PUT NOTE: &PFX._A030D_EOP_EDW_DATE:  &&&PFX._A030D_EOP_EDW_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: &PFX._A090D_SOP_EDW_DATE:  &&&PFX._A090D_SOP_EDW_DATE.;
     %PUT NOTE: &PFX._A090D_EOP_EDW_DATE:  &&&PFX._A090D_EOP_EDW_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: &PFX._A180D_SOP_EDW_DATE:  &&&PFX._A180D_SOP_EDW_DATE.;
     %PUT NOTE: &PFX._A180D_EOP_EDW_DATE:  &&&PFX._A180D_EOP_EDW_DATE.;
     %PUT NOTE: ;
     %PUT NOTE: &DLINE.;

%END;
%END;


%MEND;
/*%DISPLAY_ACTIVE_DATES(*/
/* PERIODS  = 16,*/
/* TYPE     = ORA*/
/* ); RUN;*/
