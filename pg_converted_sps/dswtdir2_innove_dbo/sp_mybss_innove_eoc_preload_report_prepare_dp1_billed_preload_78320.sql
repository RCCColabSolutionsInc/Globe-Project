CREATE OR REPLACE PROCEDURE dswtdir2_innove_dbo.sp_mybss_innove_eoc_preload_report_prepare_dp1_billed_preload(IN par_billcycle character varying)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    DELETE FROM dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache
        WHERE LOWER(billcycle) = LOWER(par_BillCycle);
    INSERT INTO dswtdir2_innove_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache (column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey, billcycle)
    WITH qu
    AS (SELECT
        column01, column02, column03, column04, column05, column06, column07, column08, column09, column10, column11, column12, column13, column14, column15, column16, column17, column18, column19,
        CASE
            WHEN LOWER(column01) <> LOWER('01') THEN NULL
            else	CAST(zdsp_order as INTEGER)
        END AS zdsp_order, zdsp_uniquekey, par_BillCycle
        FROM dswtdir2_innove_dbo.ttinnove_billed
        WHERE LOWER(zlegacycycle_code) = LOWER(par_BillCycle))
		
    SELECT
        *
        FROM qu
		ORDER BY "column01" ASC, "zdsp_order"::INTEGER ASC
        LIMIT ((SELECT
            count(*)
            FROM qu) * (100) / 100);
	


END;
$procedure$
