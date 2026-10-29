CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_usd_deferred_zerrorupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 09/02/2020
Modified by: Sindhuja Beram 09/02/2020
Description: Error
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_usd_deferred_zerrorupdsel
    SET zerror = zerrornew;*/
	UPDATE dswtdir1_dbo.ttinnove_usd_deferred target
    SET zerror = CASE
        WHEN r01.amount01 = r99.amount99::numeric THEN 0
        ELSE NULL
    END
    FROM dswtdir1_dbo.deferred_usd_record_01_sum r01
    JOIN dswtdir1_dbo.deferred_usd_record_99_sum r99 
      ON lower(r01.zsource::text) = lower(r99.zsource::text)
    WHERE lower(target.zsource::text) = lower(r01.zsource::text)
      AND target.zerror IS NULL;
END;
$procedure$
