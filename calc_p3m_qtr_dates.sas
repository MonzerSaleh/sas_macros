/*==============================================================================*/ 
/*                                                                              */
/* Macro:           calc_p3m_qtr_dates                                          */
/*                                                                              */
/* Purpose:    1.   generates a series of past 3 months quarterly date ranges.  */
/*                                                                              */
/* Example:                                                                     */
/*                                                                              */
/*                                                                              */
/*==============================================================================*/ 
%macro calc_p3m_qtr_dates(
 outlib   = work,
 out      = p3m_qtr_dates,
 periods  = 18,
 gen      = -1
 );


/*==============================================================================*/ 
/*                                                                              */
/* step 01000       generate past 3 months quarterly dates.                     */
/*                                                                              */
/* ---------------------------------------------------------------------------- */
/*                                                                              */
/* Note:       1.   generates a series of past 3 months quarterly date ranges.  */
/*                                                                              */
/*                                                                              */
/*==============================================================================*/ 
data &outlib..&out.;

     /*-------------------------------------------------------------------------*/ 
     /*   1.        Define the base current date ( todays date )                */
     /*-------------------------------------------------------------------------*/ 

     cur_dte        =    today();
     format 
     cur_dte             date9.;

     /*-------------------------------------------------------------------------*/ 
     /*   2.        Define the base current month.                              */
     /*-------------------------------------------------------------------------*/ 

     base_mth_dte   =    intnx( 'month' , cur_dte,  &gen. , 'e' );

     format 
     base_mth_dte        date9.;

     /*-------------------------------------------------------------------------*/ 
     /*   3.        Define the base current date.                               */
     /*-------------------------------------------------------------------------*/ 

     i              =    1;
     p3m_soq_dte    =    intnx( 'month' , base_mth_dte, -2, 'b' );
     p3m_eoq_dte    =    intnx( 'month' , base_mth_dte,  0, 'e' );

     format 
     p3m_soq_dte         date9.
     p3m_eoq_dte         date9.;

     output;

     /*-------------------------------------------------------------------------*/ 
     /*   4.        Define the base current date.                               */
     /*-------------------------------------------------------------------------*/ 

     do i = 2 to &periods.;

     p3m_soq_dte    =   intnx( 'month' , p3m_soq_dte, -1, 'b' );
     p3m_eoq_dte    =   intnx( 'month' , p3m_eoq_dte, -1, 'e' );
     output;

     end;

     /*-------------------------------------------------------------------------*/ 
     /*   5.        Define the base current date.                               */
     /*-------------------------------------------------------------------------*/ 

     *keep p3m_soq_dte p3m_eoq_dte i;
RUN;

%MEND;
/*%CALC_P3M_QTR_DATES(gen=-1,periods=18); RUN;*/
