CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_prevoiusmonth_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    CALL dswtdir3_aprm_dbo.traprm_content_previous_month_cntext_i_01_content_pmdel();
    /* Delete the Data From Previous Month */
    CALL dswtdir3_aprm_dbo.traprm_content_previous_month_cntext_i_01_content_pmins();
    /* Insert Current Month Data into Previous Month Table */
    CALL dswtdir3_aprm_dbo.traprm_content_previous_month_cntext_i_06_content_pmdel();
    /* Delete the Data From Previous Month */
    CALL dswtdir3_aprm_dbo.traprm_content_previous_month_cntext_i_06_content_pmins()
    /* Insert Current Month Data into Previous Month Table */
    ;
END;
$procedure$
