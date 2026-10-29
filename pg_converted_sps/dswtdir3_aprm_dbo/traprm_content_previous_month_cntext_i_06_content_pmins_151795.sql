CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.traprm_content_previous_month_cntext_i_06_content_pmins()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/16/2021
Modified by: Elakki K 03/16/2021
Description: Insert Current Month Data into Previous Month Table
*/
BEGIN
    INSERT INTO dswtdir3_aprm_dbo.cntext_i_06_content_pm (column1, column10, column11, column12, column13, column14, column15, column16, column17, column2, column3, column4, column5, column6, column7, column8, column9)
    SELECT
        column1, column10, column11, column12, column13, column14, column15, column16, column17, column2, column3, column4, column5, column6, column7, column8, column9
        FROM dswtdir3_aprm_dbo.traprm_content_previous_month_cntext_i_06_content_pminssel;
END;
$procedure$
