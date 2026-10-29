CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemo_postload_memo01_ins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Swetha Neha 07/07/2020
Modified by: Swetha Neha 08/02/2020
Description: Inserting data from MEMO01 into MEMO_Postload
*/
BEGIN
    INSERT INTO dswtdir1_dbo.ttmemoapp_dcs_zzmemoapp_old (zcocd, zcounter, zcurrency, zdoc_date, zdocument_header_text, zexchange_rate, zgl_acct, zledger_group, zperiod, zpk, zposting_date, zreference, zsource, zspecial_gl, ztransl_date, ztype)
    SELECT
        zcocd, zcounter, zcurrency, zdoc_date, zdocument_header_text, zexchange_rate, zgl_acct, zledger_group, zperiod, zpk, zposting_date, zreference, zsource, zspecial_gl, ztransl_date, ztype
        FROM dswtdir1_dbo.trmemo_postload_memo01_inssel;
END;
$procedure$
