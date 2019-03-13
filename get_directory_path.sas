/*==============================================================================*/
/* Macro:      get_directory_path                                               */
/* Purpose:    This sas macro routine will remove the first right justified     */
/*             word based on the back-slash deliminator that seperates the      */
/*             words in the string.                                             */
/*                                                                              */
/* Example:    1.   If the Input Path contains the following:                   */
/*                                                                              */
/*                  t:\dssprod\netoware\macros\netoware.sas                     */
/*                                                                              */
/*             2.   The right-justified word (netoware.sas) is removed from     */
/*                  the string.                                                 */
/*                                                                              */
/*                  t:\dssprod\netoware\macros                                  */
/*                                                                              */
/*============+=================================================================*/

%macro get_directory_path( 
path      = ,
delim     = \,
level     = 1,
var       = get_directory_path
);

%local    newpath
          location;
%let      newpath = &path.;

%do i = 1 %to &level.;

     %let newpath   = %sysfunc( reverse( &newpath. ) );
     %let location  = %sysfunc( index( &newpath. , &delim. ) );
     %let location  = %eval( &location. + 1 );
     %let newpath   = %sysfunc( substr( &newpath. , &location. ) );
     %let newpath   = %sysfunc( reverse( &newpath. ) );

%end;

%global   &var.;
%let      &var.          = &newpath.;

%put;
%put NOTE: &dline.;
%put NOTE: Macro:        get_directory_path;
%put NOTE: ;
%put NOTE: ;
%put NOTE: Purpose:      This sas macro will remove the last word in a string;
%put NOTE:               using the back-slash (\) as the deliminator.;
%put NOTE: ;
%put NOTE: path     = &path.;
%put NOTE: ;
%put NOTE: delim    = &delim.;
%put NOTE: ;
%put NOTE: level    = &level.;
%put NOTE: ;
%put NOTE: newpath  = &newpath.;
%put NOTE: ;
%put NOTE: &var. = &&&var.;
%put NOTE: ;
%put NOTE: ;
%put NOTE: &dline.;
%put ;


%mend;
/*%get_directory_path(*/
/*path      = t:\dssprod\netoware\macros\netoware.sas,*/
/*delim     = \,*/
/*level     = 2,*/
/*var       = get_directory_path*/
/*); run;*/
