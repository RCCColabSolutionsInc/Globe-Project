CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_dspconstruct_dcsmemo01_fullconstruct_tdir1_ztr_prtupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 7/5/2020 8:06:04 PM
Specification: cMap:DSPConstruct:stMEMO01_DSPConstruct_dcsMEMO01_FullConstruct_TDIR1:dcsMEMO01_FullConstruct_TDIR1:zTr_prt
*/
BEGIN
    UPDATE dswtdir1_dbo.srMEMO01_DSPConstruct_dcsMEMO01_FullConstruct_TDIR1_zTr_prtUpdSel
    SET zTr_prt = zTr_prtNew;
END;
$procedure$
