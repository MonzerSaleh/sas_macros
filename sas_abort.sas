%macro sas_abort(rc=);

data _null_;
     if &rc. ne 0 then abort &rc.;
run;

%mend;
/*%sas_abort(rc=8); run;*/
