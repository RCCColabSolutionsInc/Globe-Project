CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_voice_delta_globe_preload_export_possitiveamount_loadfi()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  rowcount INT;
BEGIN
-- Chec the count of the detail('01'), if record count is 0 then return an empty table to prevent the genereation of export file.
	
	SELECT COUNT(1) INTO rowcount FROM dswtdir3_aprm_dbo.txaprm_voice_globe_delta_positiveamount_exportsel x WHERE x.Column1 = '01';
	
	IF rowcount < 1 THEN

		SELECT NULL AS "Dummy" LIMIT 0; -- return empty table
		RETURN;
	END IF;

	SELECT "Column1"
		  ,"Column2"
		  ,"Column3"
		  ,"Column4"
		  ,"Column5"
		  ,"Column6"
		  ,"Column7"
		  ,"Column8"
		  ,"Column9"
		  ,"Column10"
		  ,"Column11"
		  ,"Column12"
		  ,"Column13"
		  ,"Column14"
		  ,"Column15"
		  ,"Column16"
		  ,"Column17"
		  ,"Column18"
		  ,"Column19"
		  ,"Column20"
		  ,"Column21"
		  ,"Column22"
		  ,"Column23"
	  FROM dswtdir3_aprm_dbo.txaprm_voice_globe_delta_positiveamount_exportsel;
END;
$procedure$
