CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_php_zerrorupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 07/27/2020
Modified by: Sindhuja Beram 07/27/2020
Description: Updates zError when Total amount for 01 records matches 99 record amount
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_php_zerrorupdsel*/
    /*SET zerror = REGEXP_REPLACE(zerrornew, '[^0-9.-]', '', 'g')::numeric;*/
	UPDATE dswtdir1_dbo.ttinnove_php AS target_table
    SET zerror = REGEXP_REPLACE(
        CASE
            WHEN r01.amount01 = r99.amount99::numeric THEN '0'
            ELSE NULL
        END, 
        '[^0-9.-]', '', 'g'
    )::numeric
    FROM dswtdir1_dbo.record_01_sum r01
    JOIN dswtdir1_dbo.record_99_sum r99 
      ON LOWER(r01.zsource::text) = LOWER(r99.zsource::text)
    WHERE LOWER(target_table.zsource::text) = LOWER(r01.zsource::text)
      AND target_table.zerror IS NULL;
END;
$procedure$
