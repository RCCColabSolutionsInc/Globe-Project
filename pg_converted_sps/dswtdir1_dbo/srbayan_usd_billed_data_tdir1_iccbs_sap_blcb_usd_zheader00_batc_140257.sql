CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zheader00_batc()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/03/2020
Modified by: Sindhuja Beram 09/19/2020
Description:
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_usd_billed_data_tdir1_iccbs_sap_blcb_usd_zheader00_batch_numberupdsel
    SET zheader00_batch_number = zheader00_batch_numbernew;
END;
$procedure$
