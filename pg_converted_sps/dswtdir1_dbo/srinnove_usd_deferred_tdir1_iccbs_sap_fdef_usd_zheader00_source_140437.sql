CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zheader00_source()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 9/18/2020 12:57:37 PM
Specification: cMap:TDIR1_ICCBS:stInnove_USD_Deferred_TDIR1_ICCBS_sap_fdef_USD:sap_fdef_USD:zHeader00_Source_System
*/
BEGIN
    UPDATE dswtdir1_dbo.srinnove_usd_deferred_tdir1_iccbs_sap_fdef_usd_zheader00_source_systemupdsel
    SET zheader00_source_system = zheader00_source_systemnew;
END;
$procedure$
