CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dp1_billed_preload_pg(IN p_billcycle character varying)
 LANGUAGE plpgsql
AS $procedure$

/* ============================================= */
/* Modified By:	Arnel Martinez */
/* Create date: October 15, 2026 */
/* Description: Report */
/* ============================================= */
/* ex: BC01 */

DECLARE
BEGIN

    DELETE FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache WHERE "billcycle" = p_billCycle;

    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache
           ("column01"
           ,"column02"
           ,"column03"
           ,"column04"
           ,"column05"
           ,"column06"
           ,"column07"
           ,"column08"
           ,"column09"
           ,"column10"
           ,"column11"
           ,"column12"
           ,"column13"
           ,"column14"
           ,"column15"
           ,"column16"
           ,"column17"
           ,"column18"
           ,"column19"
           ,"zdsp_order"
           ,"zdsp_uniquekey"
           ,"billcycle")
 SELECT  "column01",
                          "column02",
                          "column03",
                          "column04",
                          "column05",
                          "column06",
                          "column07",
                          "column08",
                          "column09",
                          "column10",
                          "column11",
                          "column12",
                          "column13",
                          "column14",
                          "column15",
                          "column16",
                          "column17",
                          "column18",
                          "column19",
                          CASE
                            WHEN "column01" <> '01' THEN NULL
                            else	CAST(zdsp_order as INTEGER)
                          END AS "zdsp_order",
                          "zdsp_uniquekey",
                          zLegacyCycle_Code
      FROM   dswtdir2_bayan_dbo.ttbayan_billed
      WHERE  "zlegacycycle_code" = p_billCycle
      --ORDER  BY "column01";
	  ORDER BY "column01" ASC, "zdsp_order"::INTEGER ASC; 

END;
$procedure$
