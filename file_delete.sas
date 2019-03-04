/*------------------------------------------------------------------------------*/
/* MACRO:           FILE_DELETE                                                 */
/*                                                                              */
/* PURPOSE:    1.   Deletes an external file by the complete dataset path.      */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* SYNTAX:     1.   %FILE_DELETE( <path> );                                     */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* CODES:      1.   Return Code Macro Variable = file_delete_rc                 */
/*                                                                              */
/*                  RC   Description of return code.                            */
/*                  ==   ====================================================== */
/*                  0    specifies the dataset was deleted successfully.        */
/*                  1    specifies the dataset was not deleted.                 */
/*                  2    specifies the dataset could not be deleted.            */
/*                                                                              */
/*============+=================================================================*/

%MACRO FILE_DELETE(PATH);

/*=============+================================================================*/
/* STEP 001    RESET THE GLOBAL FILE DELETE RC TO ZERO.                         */
/*=============+================================================================*/

%GLOBAL   FILE_DELETE_RC ;

%LET      FILE_DELETE_RC = 0;


/*=============+================================================================*/
/* STEP 002    ASSIGN <MYFILE> FILE REFERENCE TO THE INPUT PATH.                */
/*=============+================================================================*/

%LOCAL    MYFILE 
          MYFILE_RC;

%LET      MYFILE         = MYFILE;
%LET      MYFILE_RC      = %SYSFUNC( FILENAME(MYFILE,&PATH.) );


/*=============+================================================================*/
/* STEP 003    CHECK THE EXISTANCE OF THE FILE REFERENCE:   MYFILE              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* RC:    1.   RC = 0 = THE MYFILE FILE REFERENCE DOES NOT EXIST.               */
/* RC:    2.   RC = 1 = THE MYFILE FILE REFERENCE EXISTS.                       */
/*                                                                              */
/*=============+================================================================*/

%let      MYFILE_EXIST_RC = %sysfunc( FEXIST(&MYFILE.) );

/*=============+================================================================*/
/* STEP 004    MYFILE - MY FILE REFERENCE DOES NOT EXIST ROUTINE.               */
/* ---------------------------------------------------------------------------- */
/* NOTE:  1.   WHEN THE MYFILE - MY FILE REFERENCE DOES NOT EXIST (0).          */
/*             THEN SET FILE DELETE RC TO 1.                                    */
/*=============+================================================================*/

%IF  &MYFILE_EXIST_RC.        = 0       %THEN %DO;    

     %LET FILE_DELETE_RC      = 1;

     %PUT;
     %PUT NOTE: &DLINE.;
     %PUT NOTE: MACRO:  FILE_DELETE;
     %PUT NOTE: ;
     %PUT NOTE: ;
     %PUT NOTE: FILE_DELETE_RC: &FILE_DELETE_RC.;
     %PUT NOTE: ;
     %PUT NOTE: ;
     %PUT NOTE: PATH: &PATH.;
     %PUT NOTE: ;
     %PUT NOTE: MESSGAGE:;
     %PUT NOTE: ;
     %PUT NOTE: 1. THE FILE COULD NOT BE FOUND;
     %PUT NOTE: ;
     %PUT NOTE: 2. THE DELETE ACTION HAS BEEN CANCELLED;
     %PUT NOTE: ;
     %PUT NOTE: &DLINE.;
     %PUT;

%END;


/*=============+================================================================*/
/*                                                                              */
/* step 005    MYFILE - FILE REFERENCE EXISTS ROUTINE.                          */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* NOTE:  1.   WHEN THE MYFILE - FILE REFERENCE EXISTS...                       */
/*                                                                              */
/*             THEN DELETE THE FILE.                                            */
/*                                                                              */
/*=============+================================================================*/

%IF  &MYFILE_EXIST_RC. = 1    %THEN %DO;

     /*-------------------------------------------------------------------------*/
     /* 1.     DELETE THE FILE.                                                 */
     /*-------------------------------------------------------------------------*/

     %LET      FILE_DELETE_RC = %SYSFUNC( fdelete(&myfile) );

     /*-------------------------------------------------------------------------*/
     /* 2.     THE FILE DELETE FAILED - ISSUE AN ERROR MESSAGE.                 */
     /*-------------------------------------------------------------------------*/

     %IF       &FILE_DELETE_RC. NE 0    %THEN %DO;

               %LET FILE_DELETE_RC = 2;

               %PUT;
               %PUT NOTE: &DLINE.;
               %PUT NOTE: MACRO:  FILE_DELETE;
               %PUT NOTE: ;
               %PUT NOTE: PATH: &PATH.;
               %PUT NOTE: ;
               %PUT NOTE: FILE_DELETE_RC: &FILE_DELETE_RC.;
               %PUT NOTE: ;
               %PUT NOTE: MESSAGE:;
               %PUT NOTE: ;
               %PUT NOTE: 1. THE FILE COULD NOT BE DELETED;
               %PUT NOTE: ;
               %PUT NOTE: 2. THE DELETE ACTION HAS BEEN CANCELLED;
               %PUT NOTE: ;
               %PUT NOTE: ;
               %PUT NOTE: &DLINE.;
               %PUT;

     %END;

     /*-------------------------------------------------------------------------*/
     /* 3.     THE FILE DETETE WAS SUCCESSFUL. - ISSUE A SUCCESS MESSAGE.       */
     /*-------------------------------------------------------------------------*/

     %IF       &FILE_DELETE_RC. EQ 0    %THEN %DO;

               %LET FILE_DELETE_RC = 0;

               %PUT;
               %PUT NOTE: &DLINE.;
               %PUT NOTE: MACRO:  FILE_DELETE;
               %PUT NOTE: ;
               %PUT NOTE: ;
               %PUT NOTE: PATH: &PATH.;
               %PUT NOTE: ;
               %PUT NOTE: ;
               %PUT NOTE: FILE_DELETE_RC: &FILE_DELETE_RC.;
               %PUT NOTE: ;
               %PUT NOTE: ;
               %PUT NOTE: MESSAGE:;
               %PUT NOTE: ;
               %PUT NOTE: 1. THE FILE WAS DELETED.;
               %PUT NOTE: ;
               %PUT NOTE: 2. THE DELETE ACTION WAS SUCCESSFUL.;
               %PUT NOTE: ;
               %PUT NOTE: ;
               %PUT NOTE: &DLINE.;
               %PUT;

     %END;

%END;

%MEND;
/*%FILE_DELETE(c:\data\text.txt); RUN;*/
/*%put ;*/
/*%put NOTE: ----------------------------------------------------------------;  */
/*%put NOTE: Note: this is the return code variable outside of the sas macro.;  */
/*%put NOTE: ;                                                                  */
/*%put NOTE: file_delete_rc = &file_delete_rc;                                  */
/*%put NOTE: ----------------------------------------------------------------;  */
/*%put ;*/
