/*==============================================================================*/
/*                                                                              */
/* MACRO:           CLOSE EXPLORER                                              */
/*                                                                              */
/* PURPOSE:    1.   This SAS macro will close an OPEN SAS Explorer window to    */
/*                  allow the %lib_delete macro to successfully delete          */
/*                  SAS datasets from the SAS library.                          */
/*                                                                              */
/* PURPOSE:    2.   The SAS system will throw an ERROR: message for DMSEXP      */
/*                  window holding resources open.                              */
/*                                                                              */
/*============+=================================================================*/
/* YYYY-MM-DD | MAINTENANCE LOG                                                 */
/*============+=================================================================*/
/* 2018-05-11 | CREATED TO SOLVE CONTENTION ISSUE WITH %LIB_DELETE.   VIC NETO  */
/*============+=================================================================*/
%MACRO CLOSE_EXPLORER;

DM "DMSEXP; END";

%MEND;
/*%CLOSE_EXPLORER; RUN;*/
