
%macro set_date_vars(
	target_date  =    TODAY()
);

DATA J0000_set_date_vars;
     		J0000_BASE_DATE = &target_date.;
     FORMAT J0000_BASE_DATE    date9.;

	CALL SYMPUT( "J0000_BASE_DATE" , LEFT( J0000_BASE_DATE ) );
RUN;

%GLOBAL LAG000D_SOP_TODAY;
%LET LAG000D_SOP_TODAY = %sysfunc(putn( &J0000_BASE_DATE.,DATE9.));

/*
	%sysfunc(inputn(&input_date, yymmdd8.), date9.)
*/
%put ;
%put NOTE: ======================================================================;
%put NOTE: v0  = &target_date.;
%put NOTE: v1  = &LAG000D_SOP_TODAY.;
%put NOTE: ======================================================================;
%put ;


%mend;

%set_date_vars();
%put &LAG000D_SOP_TODAY.;

%set_date_vars(target_date='25JAN2012'd);
%put &LAG000D_SOP_TODAY.;










