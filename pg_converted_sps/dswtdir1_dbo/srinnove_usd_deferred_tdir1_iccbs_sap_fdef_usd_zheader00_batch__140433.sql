CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zheader00_batch_()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 07/30/2020
Modified by: Sindhuja Beram 09/18/2020
Description: Updates HeaderBatch Number as column5 from flat file sap_fdef_USD
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zheader00_batch_numberupdsel
    SET zheader00_batch_number = zheader00_batch_numbernew;*/
	UPDATE dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd target
    SET zheader00_batch_number = (zt.batch_no::numeric + 1)::character varying(30)
    FROM dswtdir1_dbo.ztf0001 zt
    WHERE lower(target.zheader00_event::text) = lower(zt.event::text)
      AND lower(target.zheader00_target_system::text) = lower(zt.to_system::text)
      AND lower(target.zheader00_source_system::text) = lower(zt.from_system::text)
      AND lower(target.column1::text) = lower('00'::text);
END;
$procedure$
