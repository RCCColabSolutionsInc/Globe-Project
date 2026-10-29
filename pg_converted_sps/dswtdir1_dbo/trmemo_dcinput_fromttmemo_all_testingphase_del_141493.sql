CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemo_dcinput_fromttmemo_all_testingphase_del()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 07/23/2020
Modified by: Saketh Venkata Nadurumati 07/23/2020
Description: Delete Data From DCS Page
*/
BEGIN
    DELETE FROM dswtdir1_dbo.trmemo_dcinput_fromttmemo_all_testingphase_delsel;
END;
$procedure$
