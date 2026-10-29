CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zheader00_batch_num()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 07/30/2020
Modified by: Sindhuja Beram 09/19/2020
Description: Updates HeaderBatch Number as column5 from flat file sap_blcb_PHP
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_php_billed_tdir1_iccbs_sap_blcb_php_zheader00_batch_numberupdsel
    SET zheader00_batch_number = zheader00_batch_numbernew;
END;
$procedure$
