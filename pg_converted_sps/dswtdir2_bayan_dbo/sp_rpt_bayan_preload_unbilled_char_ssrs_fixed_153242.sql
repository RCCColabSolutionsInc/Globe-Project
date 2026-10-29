CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_rpt_bayan_preload_unbilled_char_ssrs_fixed(INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
BEGIN OPEN p_refcur FOR SELECT column01,column02,column03,column04,column05,column06,column07,column08,column09,column10,column11,column12,column13,column14,column15,column16,column17,zdsp_order,zdsp_uniquekey FROM dswtdir2_bayan_dbo.rpt_preload_report_unbilled_char_cache ORDER BY column01 NULLS FIRST,CAST(zdsp_order AS integer) NULLS FIRST; END; $procedure$
