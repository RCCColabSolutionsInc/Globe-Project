CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.traprm_content_previous_month_cntext_i_01_content_pmdel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Debojit Roy 03/18/2021
Modified by: Debojit Roy 03/18/2021
Description: Delete the Data From Previous Month
*/
BEGIN
    DELETE FROM dswtdir3_aprm_dbo.traprm_content_previous_month_cntext_i_01_content_pmdelsel;
END;
$procedure$
