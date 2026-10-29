CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_preload_export_pg(IN p_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    rec_file RECORD;
    v_path VARCHAR(500);
    v_sqlquery TEXT;
    v_path_current VARCHAR(200);
    v_filename VARCHAR(200);
BEGIN
v_path := 'F:\BOA\Transform\Export\TDIR2-MyBSS\Globe\ttGlobe_DP1_Billed_New';
	DROP TABLE IF EXISTS tmp_vartable;
	CREATE TEMP TABLE tmp_vartable (
		ID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		CycleCode VARCHAR(5),
		SqlQuery TEXT,
		Path VARCHAR(500),
		FileName VARCHAR(200)
	); 

		-- Placeholder in the event that this data eventually comes from a maintenance table
	INSERT INTO tmp_vartable(CycleCode,SqlQuery,Path,FileName)
	VALUES('EOC1','EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC01"',v_path,'txGlobe_DP1_Billed_Cycle1LoadFileSel.txt'),
		  ('EOC2','EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC06"',v_path,'txGlobe_DP1_Billed_Cycle2LoadFileSel.txt'),
		  ('EOC3','EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC08"',v_path,'txGlobe_DP1_Billed_Cycle3LoadFileSel.txt'),
		  ('EOC4','EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC10"',v_path,'txGlobe_DP1_Billed_Cycle4LoadFileSel.txt'),
		  ('EOC5','EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC11"',v_path,'txGlobe_DP1_Billed_Cycle5LoadFileSel.txt'),
		  ('EOC6','EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC13"',v_path,'txGlobe_DP1_Billed_Cycle6LoadFileSel.txt'),
		  ('EOC7','EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC16"',v_path,'txGlobe_DP1_Billed_Cycle7LoadFileSel.txt'),
		  ('EOC8','EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC18"',v_path,'txGlobe_DP1_Billed_Cycle8LoadFileSel.txt'),
		  ('EOC9','EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC21"',v_path,'txGlobe_DP1_Billed_Cycle9LoadFileSel.txt'),
		  ('EOC10','EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC24"',v_path,'txGlobe_DP1_Billed_Cyc10LoadFileSel.txt'),
		  ('EOC11','EXEC [dswTDIR2_Globe].[dbo].sp_MyBSS_Globe_EOC_Preload_Export_DP1_Billed_LoadFileSel "BC27"',v_path,'txGlobe_DP1_Billed_Cyc11LoadFileSel.txt');


	

	-- Loop from the table
	FOR rec_file IN (
SELECT SqlQuery AS sqlquery, Path AS path_current, FileName AS filename FROM tmp_vartable
	   WHERE CycleCode = p_cyclecode
) LOOP

		CALL etl_db.sp_ExportTextFile(rec_file.sqlquery,v_path,rec_file.filename);-- Execute export file
		
END LOOP;
END;
$procedure$
