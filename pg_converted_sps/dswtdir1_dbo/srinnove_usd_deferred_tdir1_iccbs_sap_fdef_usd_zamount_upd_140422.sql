CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zamount_upd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  zboa0018 ON: 9/18/2020 12:57:37 PM
Specification: cMap:TDIR1_ICCBS:stInnove_USD_Deferred_TDIR1_ICCBS_sap_fdef_USD:sap_fdef_USD:zAmount
*/
BEGIN
    /*PDATE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zamount_updsel
    SET "zAmount " = "zAmount New";*/
	UPDATE dswtdir1_dbo.stinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd
    SET "zAmount " = CASE 
        WHEN lower(zrecord::text) = lower('01'::text) THEN column11::numeric
        ELSE NULL
    END
    WHERE "zAmount " IS NULL;
END;
$procedure$
