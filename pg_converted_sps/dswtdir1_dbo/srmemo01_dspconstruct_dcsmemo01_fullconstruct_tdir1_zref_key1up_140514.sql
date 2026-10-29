CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_dspconstruct_dcsmemo01_fullconstruct_tdir1_zref_key1up()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 7/5/2020 8:06:04 PM
Specification: cMap:DSPConstruct:stMEMO01_DSPConstruct_dcsMEMO01_FullConstruct_TDIR1:dcsMEMO01_FullConstruct_TDIR1:zRef_Key1
*/
BEGIN
    UPDATE dswtdir1_dbo.srMEMO01_DSPConstruct_dcsMEMO01_FullConstruct_TDIR1_zRef_Key1UpdSel
    SET zRef_Key1 = zRef_Key1New;
END;
$procedure$
