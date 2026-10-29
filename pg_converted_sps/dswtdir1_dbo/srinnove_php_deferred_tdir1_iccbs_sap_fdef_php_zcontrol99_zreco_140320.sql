CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zcontrol99_zreco()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  zboa0018 ON: 9/18/2020 12:57:17 PM
Specification: cMap:TDIR1_ICCBS:stInnove_PHP_Deferred_TDIR1_ICCBS_sap_fdef_PHP:sap_fdef_PHP:zControl99_zRecord
*/
BEGIN
    /*UPDATE dswtdir1_dbo.srinnove_php_deferred_tdir1_iccbs_sap_fdef_php_zcontrol99_zrecordupdsel
    SET zcontrol99_zrecord = zcontrol99_zrecordnew;*/
	UPDATE dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php
    SET zcontrol99_zrecordcount = (
        SELECT count(*)
        FROM dswtdir1_dbo.stinnove_php_deferred_tdir1_iccbs_sap_fdef_php st1
        WHERE lower(st1.column1::text) = lower('01'::text)
    )
    WHERE zcontrol99_zamount IS NULL 
      AND lower(column1::text) = lower('99'::text);
END;
$procedure$
