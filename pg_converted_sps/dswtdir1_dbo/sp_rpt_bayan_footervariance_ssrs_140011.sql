CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_rpt_bayan_footervariance_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        processname, sourceamountfooter, targetamountfooter, variance
        FROM dswtdir1_dbo.tvbayan_footervariance_rptsel;
END;
$procedure$
