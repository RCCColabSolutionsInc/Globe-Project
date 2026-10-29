CREATE OR REPLACE PROCEDURE dswtdir3_aprm_dbo.sp_aprm_content_i_postload_report_send_bak()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
  cursor_data CURSOR FOR SELECT x.SubscriptionID,x.ReportName FROM etl_db_dbo.vw_reportsubcriptions x
	   WHERE
	   x.ReportName IN(SELECT d.reportname FROM ds d WHERE d.recordcount > 0);
  subscriptionid UUID;
  reportname VARCHAR(300);
BEGIN
DROP TABLE IF EXISTS ds;
CREATE TEMP TABLE ds (
reportname VARCHAR(500),recordcount INT
) ON COMMIT DROP;  

	INSERT INTO ds(reportname,recordcount)
	SELECT 'Content_I_Postload', COUNT(1) FROM dswtdir3_aprm_dbo.rpt_content_i_postload_report_cache;

	/*PRELOAD REPORTS*/
	-- Loop from the table and process based on conditions
	
	

	
	OPEN cursor_data;
LOOP
  FETCH cursor_data INTO subscriptionid,reportname;
  EXIT WHEN NOT FOUND;
-- TODO(migration): SSRS ReportServer call; no Postgres equivalent.
-- EXEC "ReportServer$DACPRD".dbo.AddEvent eventtype='TimedSubscription', eventdata=subscriptionid

		END LOOP;
CLOSE cursor_data;
END;
$procedure$
