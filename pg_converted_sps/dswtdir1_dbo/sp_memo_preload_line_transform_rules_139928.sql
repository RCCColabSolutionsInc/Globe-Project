CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_line_transform_rules()
 LANGUAGE plpgsql
AS $procedure$
/* #endregion */
/* preload line preload rules */
/* #region 01 sp_Memo_Preload_Line_Transform_Rules */
BEGIN
    /* Remove the Suffix "Space 1" - Length of date considered the Timestamp value also in Source Rule */
    CALL dswtdir1_dbo.trmemoapp_preload_zbline_date_trimsuffix_1upd();
    /* Absolute of Amount in Doc Curr */
    CALL dswtdir1_dbo.trmemoapp_preload_zamount_in_doc_curr_absupd();
    /* Remove the Suffix "Space 1" - Length of date considered the Timestamp value also in Source Rule */
    CALL dswtdir1_dbo.trmemoapp_preload_zdoc_date_trimsuffix_1upd();
    /* Absolute of Withholding Tax Base */
    CALL dswtdir1_dbo.trmemoapp_preload_zwithholding_tax_base_absupd();
    /* Default AddedOn as required for DCS if Source and Filed level Default does not set the required Date format. */
    CALL dswtdir1_dbo.trmemoapp_preload_addedonupd();
    /* Default AddedBy as required for DCS */
    CALL dswtdir1_dbo.trmemoapp_preload_addedbyupd();
    /* Default boaStatus to Error as required for DCS. Remediate BoaStatus to ProceduresCompleted if zError_Counter = 0 and zError_LineItem = 0 */
    CALL dswtdir1_dbo.trmemoapp_preload_boastatusupd();
    /* Set zProponent */
    CALL dswtdir1_dbo.trmemoapp_preload_zproponentupd();
    /* refer to trMEMOAPP_Preload_zInputFileProcessed_Date_Custom_UpdSel */
    CALL dswtdir1_dbo.trmemoapp_preload_zinputfileprocessed_dateupd();
    /* update using currrent date for all sources */
    CALL dswtdir1_dbo.trmemoapp_preload_zinputfileprocessed_date_custom_upd();
    /* Update with Pipe Separator for Date and Time in Getdate */
    CALL dswtdir1_dbo.trmemoapp_preload_zlegacyzdsp_uniquekey_pipeseparator_getdateupd();
    /* Update zDSP Unique Key From zLegacy DSP Unique Key */
    CALL dswtdir1_dbo.trmemoapp_preload_zdsp_uniquekey_zlegacyzdsp_uniquekeyupd();
    /* Update with Pipe Separator for Date and Time in Getdate */
    CALL dswtdir1_dbo.trmemoapp_preload_zdsp_uniquekey_pipeseparator_getdateupd();
    /* GLAccount Type for Revenue GL Account  --R2Reviewed */
    CALL dswtdir1_dbo.trmemoapp_preload_glaccount_type_ska1upd();
    /* Update RevenueType , Posting without tax allowed information and Tax Code: zFSTAG_SKB1,zXMWNO_SKB1,zMWSKZ_SKB1.  --R2Reviewed */
    CALL dswtdir1_dbo.trmemoapp_preload_mwskz_xmwno_updatefrom_skb1upd();
    /* R2: Blank out Revenue GL fields for Vendor and VAT Lines.  --R2Reviewed */
    CALL dswtdir1_dbo.trmemoapp_preload_revgl_fields_zbrand_zsub_product_a_zrevenue_type_upd();
    /* R2: For 8R GL Lines only, For Input file value Company_Code is GLOB, then use MCG, for INOV use IC_WVL, for BAYN use BT_WVL. For any Other company codes use blank. Values validonly for Rev GLs.   --R2Reviewed */
    CALL dswtdir1_dbo.trmemoapp_preload_scenario8r_8m_gllines_zprofit_ctr_manualupd();
    /* */
    CALL dswtdir1_dbo.trmemoapp_preload_zdsp_orderupd();
END;
$procedure$
