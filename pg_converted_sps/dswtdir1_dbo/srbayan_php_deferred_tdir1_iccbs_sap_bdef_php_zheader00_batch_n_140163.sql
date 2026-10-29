CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zheader00_batch_n()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/01/2020
Modified by: Sindhuja Beram 09/19/2020
Description:
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_deferred_tdir1_iccbs_sap_bdef_php_zheader00_batch_numberupdsel
    SET zheader00_batch_number = zheader00_batch_numbernew;
END;
$procedure$
