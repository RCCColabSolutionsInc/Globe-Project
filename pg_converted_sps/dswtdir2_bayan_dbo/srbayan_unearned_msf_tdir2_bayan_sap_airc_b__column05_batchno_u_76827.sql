CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b__column05_batchno_u()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Debojit Roy 01/12/2021
Modified by: Debojit Roy 02/01/2021
Description: Updates Batch Number
*/
/*BEGIN
    UPDATE dswtdir2_bayan_dbo.srbayan_unearned_msf_tdir2_bayan_sap_airc_b__column05_batchno_updsel
    SET zcolumn05 = zcolumn05new;
END;*/
BEGIN
    UPDATE dswtdir2_bayan_dbo.stbayan_unearned_msf_tdir2_bayan_sap_airc_b a
    SET zcolumn05 = ((b.batch_no::integer + 1))::character varying(30)
    FROM dswtdir2_bayan_dbo.ztf0001s b
    WHERE lower(a.column2::text) = lower(b.from_system::text) 
      AND lower(a.column3::text) = lower(b.to_system::text) 
      AND lower(a.column4::text) = lower(b.event::text)
      AND lower(a.column1::text) = lower('00'::text) 
      AND lower(b.bukrs::text) = lower('BAYN'::text);
END;
$procedure$
