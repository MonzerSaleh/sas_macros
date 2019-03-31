

DATA _null_ ;

	TIME_BASE_DATE  =    TODAY();

/* Current Month */
	LAG00M_SOP_DATE  	=    INTNX( 'MONTH', TIME_BASE_DATE, 0, 'B' );
	LAG00M_SOP_yymmdd   =    PUT( LAG00M_SOP_DATE, YYMMDD6. );
	LAG00M_SOP_ddmmyy   =    PUT( LAG00M_SOP_DATE, DDMMYY6. );
	LAG00M_SOP_ddmmyyyy =    PUT( LAG00M_SOP_DATE, DDMMYY8. );
	LAG00M_SOP_yymmddd  =    PUT( LAG00M_SOP_DATE, YYMMDDD10. );
	LAG00M_SOP_yymmdds  =    PUT( LAG00M_SOP_DATE, YYMMDDS10. );
	
	LAG00M_EOP_DATE  =    INTNX( 'MONTH', TIME_BASE_DATE, 0, 'E' );
/* Current Week  */
	LAG00W_SOP_DATE  =    INTNX( 'WEEK', TIME_BASE_DATE, 0, 'B' );
	LAG00W_EOP_DATE  =    INTNX( 'WEEK', TIME_BASE_DATE, 0, 'E' );
	
/* Previous Month */
	LAG01M_SOP_DATE  =    INTNX( 'MONTH', TIME_BASE_DATE, -1, 'B' );
	LAG01M_EOP_DATE  =    INTNX( 'MONTH', TIME_BASE_DATE, -1, 'E' );
/* Previous Week  */
	LAG01W_SOP_DATE  =    INTNX( 'WEEK', TIME_BASE_DATE, -1, 'B' );
	LAG01W_EOP_DATE  =    INTNX( 'WEEK', TIME_BASE_DATE, -1, 'E' );
	  


call symputx('LAG00M_SOP_DATE', put(LAG00M_SOP_DATE, date9.) , 'g');
call symputx('LAG00M_SOP_yymmdd', LAG00M_SOP_yymmdd , 'g');
call symputx('LAG00M_SOP_ddmmyy', LAG00M_SOP_ddmmyy , 'g');
call symputx('LAG00M_SOP_ddmmyyyy', LAG00M_SOP_ddmmyyyy , 'g');
call symputx('LAG00M_SOP_yymmddd', LAG00M_SOP_yymmddd , 'g');
call symputx('LAG00M_SOP_yymmdds', LAG00M_SOP_yymmdds , 'g');

call symputx('LAG00M_EOP_DATE', put(LAG00M_EOP_DATE, date9.) , 'g');

call symputx('LAG00W_SOP_DATE', put(LAG00W_SOP_DATE, date9.) , 'g');
call symputx('LAG00W_EOP_DATE', put(LAG00W_EOP_DATE, date9.) , 'g');

call symputx('LAG01M_SOP_DATE', put(LAG01M_SOP_DATE, date9.) , 'g');
call symputx('LAG01M_EOP_DATE', put(LAG01M_EOP_DATE, date9.) , 'g');

call symputx('LAG01W_SOP_DATE', put(LAG01W_SOP_DATE, date9.) , 'g');
call symputx('LAG01W_EOP_DATE', put(LAG01W_EOP_DATE, date9.) , 'g');


RUN;

%put SAS_Date = &LAG00M_SOP_DATE.	;	
%put yymmdd   = &LAG00M_SOP_yymmdd.	;
%put ddmmyy   = &LAG00M_SOP_ddmmyy.	;
%put ddmmyyyy = &LAG00M_SOP_ddmmyyyy.;
%put yymmddd  = &LAG00M_SOP_yymmddd.	;
%put yymmdds  = &LAG00M_SOP_yymmdds.	;

%put M_end = &LAG00M_EOP_DATE.		;

%put W_start = &LAG00W_SOP_DATE. 	W_end = &LAG00W_EOP_DATE.;

%put M_start = &LAG01M_SOP_DATE. 	M_end = &LAG01M_SOP_DATE.;
%put W_start = &LAG01W_SOP_DATE. 	W_end = &LAG01W_EOP_DATE.;










