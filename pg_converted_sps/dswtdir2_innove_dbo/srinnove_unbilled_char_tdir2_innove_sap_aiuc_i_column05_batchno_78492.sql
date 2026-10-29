CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_column05_batchno()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Debojit Roy 12/14/2020
Modified by: Debojit Roy 12/14/2020
Description:
*/
/*BEGIN
    UPDATE dswtdir2_innove_dbo.srinnove_unbilled_char_tdir2_innove_sap_aiuc_i_column05_batchno_updsel
    SET zcolumn05 = zcolumn05new;
END;*/
BEGIN
    UPDATE dswtdir2_innove_dbo.stinnove_unbilled_char_tdir2_innove_sap_aiuc_i a
    SET zcolumn05 = ((b.batch_no::integer + 1))::character varying(30)
    FROM dswtdir2_innove_dbo.ztf0001s b
    WHERE lower(a.column2::text) = lower(b.from_system::text) 
      AND lower(a.column3::text) = lower(b.to_system::text) 
      AND lower(a.column4::text) = lower(b.event::text)
      AND lower(a.column1::text) = lower('00'::text) 
      AND lower(b.bukrs::text) = lower('INOV'::text);
END;
$procedure$
