CREATE OR REPLACE PROCEDURE dswtdip2_iot_da_dbo.sp_iot_da_transform()
 LANGUAGE plpgsql
AS $procedure$
/* USE dswTDIP2_IOT_DA */
BEGIN
    CALL dswtdip2_iot_da_dbo.triot_da_monthly_sdr_ib_ob_del();
	
	/* Delete from Monthly SDR table */
	--CALL dswtdip2_iot_da_dbo.triot_da_monthly_sdr_ib_ob_ins();

    /* Insert Monthly SDR IB and OB */
    CALL dswtdip2_iot_da_dbo.triot_da_ib_ob_usd_sdr_upside_downside_del();

    /* Delete IB and OB Upside and Downside */
	--CALL dswtdip2_iot_da_dbo.triot_da_ib_ob_usd_sdr_upside_downside_ins();

    /* Insert IB and OB Upside_Downside */
    CALL dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_summary_header_del();

    /* Delete Summary Header IB and OB */
--  CALL dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_summary_header_ins();

    /* Insert Summary Header IB and OB */
    CALL dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_usd_del();

	/* Delete Summary IB and OB USD */
--    CALL dswtdip2_iot_da_dbo.triot_da_summary_ib_ob_usd_ins();

    /* Summary IB and OB USD */
    CALL dswtdip2_iot_da_dbo.triot_da_summary_outtap_cn_del();

--    /* Delete Summary Outtap CN */
--    CALL dswtdip2_iot_da_dbo.triot_da_summary_outtap_cn_ins();

	/* Insert Summary OutTap CN */
    CALL dswtdip2_iot_da_dbo.triot_da_summary_outtap_loadfile_table_del();
--    /* Delete data from Outtap Loadfile Table */
--    CALL dswtdip2_iot_da_dbo.triot_da_summary_outtap_loadfile_table_ins();
--    /* Insert Summary Outtap Load File data into Table */
--    CALL dswtdip2_iot_da_dbo.triot_da_sumouttap_copa_split_total_del();
--    /* Delete from COPA SPLIT Table */
--    CALL dswtdip2_iot_da_dbo.triot_da_sumouttap_copa_split_total_ins();
--    /* Insert COPA SPlit into Table */
--    CALL dswtdip2_iot_da_dbo.triot_da_sumintapcn_del();
--    /* Delete from Summary Intap Table */
--    CALL dswtdip2_iot_da_dbo.triot_da_sumintapcn_ins();
--    /* Insert Summary Intap CN into table */
--    CALL dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_sdr_del();
--    /* Delete from Load File Sub */
--    CALL dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_sdr_ins();
--    /* Insert into Sumintap Load File Sub */
--    CALL dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_del();
--    /* Delete from Summary Intap Loadfile Table */

--    CALL dswtdip2_iot_da_dbo.triot_da_sumintap_loadfile_ins();
    /* Insert Summary Intap Loadfile into table */
--    ;
END;
$procedure$
