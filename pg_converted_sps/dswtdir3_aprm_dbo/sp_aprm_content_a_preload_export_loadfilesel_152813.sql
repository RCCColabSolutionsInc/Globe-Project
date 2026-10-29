CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_a_preload_export_loadfilesel()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  rowcount INT;
BEGIN
-- Chec the count of the detail('01'), if record count is 0 then return an empty table to prevent the genereation of export file.
	
	SELECT COUNT(1) INTO rowcount FROM dswtdir3_aprm_dbo.txaprm_content_1st_exportsel x WHERE x.Column1 = '01';
	
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
  FROM dswtdir3_aprm_dbo.txaprm_content_1st_exportsel;
END;
$procedure$
