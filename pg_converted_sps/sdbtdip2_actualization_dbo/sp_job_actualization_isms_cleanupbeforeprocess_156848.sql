CREATE OR REPLACE PROCEDURE sdbtdip2_actualization_dbo.sp_job_actualization_isms_cleanupbeforeprocess()
 LANGUAGE plpgsql
AS $procedure$
/* ============================================= */
/* Author:		Windstoner */
/* Create date: Aug 8, 2023 */
/* Description:	<Description,,> */
/* ============================================= */
BEGIN
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    TRUNCATE TABLE sdbtdip2_actualization_dbo.apmi_raw;
    TRUNCATE TABLE sdbtdip2_actualization_dbo.summary_accrual_ob;
    TRUNCATE TABLE sdbtdip2_actualization_dbo.summary_of_invoice_inbound;
    TRUNCATE TABLE sdbtdip2_actualization_dbo.summary_of_invoice_outbound;
END;
$procedure$
