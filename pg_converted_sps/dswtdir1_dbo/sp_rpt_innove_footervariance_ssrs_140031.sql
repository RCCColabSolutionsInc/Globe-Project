CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_rpt_innove_footervariance_ssrs(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    OPEN p_refcur FOR
    SELECT
        processname, sourceamountfooter, targetamountfooter, variance
        FROM dswtdir1_dbo.tvinnove_footervariance_rptsel;
END;
$procedure$
