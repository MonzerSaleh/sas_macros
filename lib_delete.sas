/*==============================================================================*/
/* Purpose:         Deletes a sas dataset.                                      */
/*============+=================================================================*/

%macro lib_delete(

 step     = NULL,        /* step:       specify the step number.                */
 title    = NULL,        /* title:      specify the step title.                 */

 lib      = work,        /* library reference where datasets are to be deleted  */
 data     = ,            /* Dataset Name to be deleted.                         */

                         /* Options:                                            */
 memtype  = all,         /* memtype     =    type of members to be deleted.     */
                         /* memtype     =    all                                */
 details  = nodetails,   /* Print Dataset Details                               */
                         /* details     =    nodetails                          */
 force    = force,       /* force       =    force                              */
 list     = nolist       /* list        =    nolist.                            */
);

/*==============================================================================*/
/* step 01000       Close the SAS Explorer WIndow If Open.                      */
/*==============================================================================*/

%IF  &SYSSCP. = WIN %THEN %DO;

     DM 'DMSEXP; CANCEL';

%END;


/*==============================================================================*/
/*                                                                              */
/* step 02000       GENERATE PROC DATASETS IN ONE OF THREE MODES:               */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* MODE:       1.   delete one sas dataset.                                     */
/*             2.   delete sas datasets with a specifc prefix.                  */
/*             3.   delete all sas datasets in a sas library ( data=kill )      */
/*                                                                              */
/*==============================================================================*/

PROC DATASETS 

     /*=========================================================================*/
     /*                                                                         */
     /* 01. LIB     Specify the sas libname where the datasets are located      */
     /*             that will be deleted.                                       */
     /*                                                                         */
     /*=========================================================================*/

     LIB       = &LIB.


     /*=========================================================================*/
     /*                                                                         */
     /* 02.    MEMTYPE        Specify the sas memeber type.                     */
     /*                                                                         */
     /* ----------------------------------------------------------------------- */
     /*                                                                         */
     /*        DEFAULT:       memtype = all                                     */
     /*                                                                         */
     /*                       This deletes all member types.                    */
     /*                                                                         */
     /*=========================================================================*/

     MEMTYPE   = &MEMTYPE. 


     /*=========================================================================*/
     /*                                                                         */
     /* 3.     DATA=KILL      delete all sas datasets in the sas library.       */
     /*                                                                         */
     /*=========================================================================*/
     
     %IF       %UPCASE(&DATA.)     EQ   KILL      %THEN %DO;
     KILL   
     %END;


     /*=========================================================================*/
     /*                                                                         */
     /* 4.     FORCE=FORCE    force the deletion of the sas datasets.           */
     /*                                                                         */
     /*=========================================================================*/

     &FORCE.


     /*=========================================================================*/
     /*                                                                         */
     /* 5.     LIST           controls the printing of the sas directory info.  */
     /*                                                                         */
     /* ----------------------------------------------------------------------- */
     /*                                                                         */
     /*        DEFAULT:       NOLIST    supress printing of directory.          */
     /*                                                                         */
     /*                       BLANK     prints the sas directory.               */
     /*                                                                         */
     /*=========================================================================*/

     &LIST.


     /*=========================================================================*/
     /* 6.     DETAILS        controls the printing of the dataset details.     */
     /* ----------------------------------------------------------------------- */
     /*        DEFAULT:       NODETAILS supress printing of details             */
     /*                       blank     prints the sas dataset details.         */
     /*=========================================================================*/

     &details. 
     ;

     /*-------------------------------------------------------------------------*/
     /* 7.     DATA           Limit the deletion of sas datasets.               */
     /* ----------------------------------------------------------------------- */
     /*                                                                         */
     /* 7.1    A              Delete a sas dataset from a sas library.          */
     /*                                                                         */
     /* 7.2    A:             Delete all sas datasets                           */
     /*                       that begin with the letter A.                     */
     /*                       from a sas library.                               */
     /*                                                                         */
     /* 7.3    KILL           Delete all sas datasets from a sas library.       */
     /*                                                                         */
     /*-------------------------------------------------------------------------*/

     %IF       %UPCASE(&DATA.)     NE   KILL      %THEN %DO;

     DELETE    &data. ;

     %END;


     /*-------------------------------------------------------------------------*/
     /* 2.     Quit the Proce Datasets procedure.                               */
     /*-------------------------------------------------------------------------*/

     QUIT;
RUN;

  
%MEND LIB_DELETE;
/*%lib_delete(lib=appwcur,data=vic1); run;*/
