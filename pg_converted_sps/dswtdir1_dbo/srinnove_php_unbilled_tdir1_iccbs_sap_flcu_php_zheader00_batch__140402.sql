CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zheader00_batch_()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 07/30/2020
Modified by: Sindhuja Beram 09/18/2020
Description: Updates HeaderBatch Number as column5 from flat file sap_flcu_PHP
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_unbilled_tdir1_iccbs_sap_flcu_php_zheader00_batch_numberupdsel*/
    /*SET zheader00_batch_number = zheader00_batch_numbernew;*/
	UPDATE dswtdir1_dbo.stinnove_php_unbilled_tdir1_iccbs_sap_flcu_php st
    SET zheader00_batch_number = ((zt.batch_no::numeric + 1::numeric))::character varying(30)
    FROM dswtdir1_dbo.ztf0001 zt
    WHERE LOWER(st.zheader00_event::text) = LOWER(zt.event::text)
      AND LOWER(st.zheader00_target_system::text) = LOWER(zt.to_system::text)
      AND LOWER(st.zheader00_source_system::text) = LOWER(zt.from_system::text)
      AND LOWER(st.column1::text) = LOWER('00'::text);
END;
$procedure$
