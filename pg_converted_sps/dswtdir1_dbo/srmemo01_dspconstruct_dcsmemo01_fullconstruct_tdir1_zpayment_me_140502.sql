CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemo01_dspconstruct_dcsmemo01_fullconstruct_tdir1_zpayment_me()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 ON: 7/5/2020 8:06:04 PM
Specification: cMap:DSPConstruct:stMEMO01_DSPConstruct_dcsMEMO01_FullConstruct_TDIR1:dcsMEMO01_FullConstruct_TDIR1:zPayment_Method
*/
BEGIN
    UPDATE dswtdir1_dbo.srMEMO01_DSPConstruct_dcsMEMO01_FullConstruct_TDIR1_zPayment_MethodUpdSel
    SET zPayment_Method = zPayment_MethodNew;
END;
$procedure$
