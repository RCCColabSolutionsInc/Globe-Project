CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zheader00_batch_n()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 08/31/2020
Modified by: Sindhuja Beram 09/19/2020
Description: Updates HeaderBatch Number as column5 from flat file sap_blcu_PHP
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_unbilled_tdir1_iccbs_sap_blcu_php_zheader00_batch_numberupdsel
    SET zheader00_batch_number = zheader00_batch_numbernew;
END;
$procedure$
