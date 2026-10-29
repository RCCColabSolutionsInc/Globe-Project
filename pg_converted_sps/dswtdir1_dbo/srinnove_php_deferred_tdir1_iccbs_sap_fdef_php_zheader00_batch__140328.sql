CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zheader00_batch_()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  zboa0018 ON: 9/15/2020 7:21:55 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_Deferred_TDIR1_ICCBS_sap_fdef_PHP:sap_fdef_PHP:zHeader00_Batch_Number
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zheader00_batch_numberupdsel
    SET zheader00_batch_number = zheader00_batch_numbernew;*/
	UPDATE dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php t1
    SET zheader00_batch_number = ((t2.batch_no::numeric + 1::numeric))::character varying(30)
    FROM dswtdir1_dbo.ztf0001 t2
    WHERE lower(t1.zheader00_event::text) = lower(t2.event::text) 
      AND lower(t1.zheader00_target_system::text) = lower(t2.to_system::text) 
      AND lower(t1.zheader00_source_system::text) = lower(t2.from_system::text)
      AND lower(t1.column1::text) = lower('00'::text);
END;
$procedure$
