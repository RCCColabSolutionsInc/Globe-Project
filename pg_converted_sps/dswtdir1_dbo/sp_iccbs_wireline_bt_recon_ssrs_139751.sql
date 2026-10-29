CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_iccbs_wireline_bt_recon_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        zdescription, zvalue_03, zvalue_05, zvalue_06, zvalue_08, zvalue_12, zvalue_15, zvalue_16, zvalue_21, zvalue_26, zvalue_eom, zvalue_cuml, zreconcomments_byuser1, zreconcomments_byuser2, zreconcomments_byuser3, zreconreq, zbillcycle_value_detail, zreconciliationflag, zcuml_value_detail, zbillmonth, "zBillDate_EOM ", zbillrun_year, zinputfileprocessed_date, zlineitemnumber, ztier_value, ztier_cumulative, ztier_sum_gt_bt, zlegacyzlineitemnumber, zsource, boastatus, addedon, changedon, changedby
        FROM dswtdir1_dbo.dcwireline_bt;
END;
$procedure$
