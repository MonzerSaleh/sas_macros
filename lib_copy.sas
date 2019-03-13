/*==============================================================================*/
/* Note:       1.   Copies sas datasets from the input sas library to the       */
/*                  output sas library.                                         */
/*============+=================================================================*/
%macro lib_copy (
 lib      = null,
 outlib   = null,
 select   = null
 );

/*------------------------------------------------------------------------------*/
/* Step 101    Validate the Lib parameter is not null.                          */
/*------------------------------------------------------------------------------*/

%if            %lowcase(&lib.)     eq   null      %then %do;

               %putmlog(
               name      = lib_copy ,
               var       = lib_copy_rc ,
               rc        = 8,
               msg1      = The Lib parameter cannot have a null value. 
               ); run ;

%end;

/*------------------------------------------------------------------------------*/
/* Step 102    Validate outlib parameter is not null.                           */
/*------------------------------------------------------------------------------*/

%if            %lowcase(&outlib.)  eq   null      %then %do;

               %putmlog(
                name     = lib_copy ,
                var      = lib_copy_rc ,
                rc       = 8,
                msg1     = The OutLib parameter cannot have a null value.
                ); run;

%end;
 
/*------------------------------------------------------------------------------*/
/* Step 103    Copy members from an input library to an output library.         */
/*------------------------------------------------------------------------------*/

proc copy in = &lib. out = &outlib. ;

     %if  &select. ne null    %then %do;

          select &select.;

     %end;


     quit;
run ;


%mend;      
/*%lib_alloc(lib=in,path=c:\ftp\input); run;*/
/*%lib_alloc(lib=out,path=c:\ftp\output); run;*/
/*data in.vic; x=1; run;*/
/*data in.mary; x=1; run;*/
/*%lib_copy(lib=in,outlib=out,select=vic); run;*/
