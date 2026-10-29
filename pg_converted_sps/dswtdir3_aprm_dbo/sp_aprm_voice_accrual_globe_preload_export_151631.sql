CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_accrual_globe_preload_export()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  cursor_file CURSOR FOR SELECT SqlQuery, "Path","FileName"
	   FROM vartable;
  path VARCHAR(500);
  sqlquery TEXT;
  path_current VARCHAR(200);
  filename VARCHAR(200);
BEGIN
path := 'F:\BOA\Transform\Export\TDIR3-APRM\APRM_VOICE\ttAPRM_Voice_Globe_New';
	DROP TABLE IF EXISTS vartable;
CREATE TEMP TABLE vartable (

		ID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
		CycleCode VARCHAR(5),
		SqlQuery TEXT,
		"Path" VARCHAR(500),
		"FileName" VARCHAR(200)
	
) ON COMMIT DROP; 

		-- Placeholder in the event that this data eventually comes from a maintenance table
	INSERT INTO vartable(SqlQuery,"Path","FileName")
	VALUES('EXEC [dswTDIR3_APRM].[dbo].[sp_APRM_Voice_Accrual_Globe_Preload_Export_LoadFileSel]',path,'ICEXT_Voice_Globe_Accrual.txt');

	
	
	

	-- Loop from the table
	
	OPEN cursor_file;
LOOP
  FETCH cursor_file INTO sqlquery, path_current, filename;
  EXIT WHEN NOT FOUND;
CALL etl_db_dbo.sp_exporttextfile(sqlquery, path, filename);  -- Execute export file
		END LOOP;
CLOSE cursor_file;
END;
$procedure$
