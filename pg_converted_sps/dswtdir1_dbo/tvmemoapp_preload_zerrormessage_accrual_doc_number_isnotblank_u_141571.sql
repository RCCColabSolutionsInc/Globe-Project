CREATE OR REPLACE PROCEDURE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_accrual_doc_number_isnotblank_u()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 03/25/2021
Modified by: Pradeep Gupta 03/25/2021
Description: Accrual Doc Number Blank #R2
*/
BEGIN
    UPDATE dswtdir1_dbo.tvmemoapp_preload_zerrormessage_accrual_doc_number_isnotblank_updsel
    SET zerror_lineitem = zerror_lineitemnew, zerrormessage = zerrormessagenew;
END;
$procedure$
