CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zheader00_batch_upd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by: zboa0018 ON: 9/15/2020 7:21:28 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_TDIR1_ICCBS_sap_flcb_PHP:sap_flcb_PHP:zHeader00_Batch_Number
*/
BEGIN
	/*UPDATE dswtdir1_dbo.srinnove_php_tdir1_iccbs_sap_flcb_php_zheader00_batch_numberupdsel*/
    UPDATE dswtdir1_dbo.stinnove_php_tdir1_iccbs_sap_flcb_php AS target_table
    SET zheader00_batch_number = (
        SELECT ((ztf0001.batch_no::numeric + 1))::character varying(30)
        FROM "dgs4hana_tdir1_dbo"."ztf0001"
        WHERE LOWER(target_table.zheader00_event::text) = LOWER(ztf0001.event::text)
          AND LOWER(target_table.zheader00_target_system::text) = LOWER(ztf0001.to_system::text)
          AND LOWER(target_table.zheader00_source_system::text) = LOWER(ztf0001.from_system::text)
        LIMIT 1
    )
    WHERE LOWER(target_table.column1::text) = '00';
END;
$procedure$
