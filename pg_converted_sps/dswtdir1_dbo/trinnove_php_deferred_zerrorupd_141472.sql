CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_php_deferred_zerrorupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 07/27/2020
Modified by: Sindhuja Beram 07/27/2020
Description: zError to indicate the sum of amount for 01 records equal to 99 record amount
*/
BEGIN
    /*(UPDATE dswtdir1_dbo.trinnove_php_deferred_zerrorupdsel
    SET zerror = zerrornew;*/
	UPDATE dswtdir1_dbo.ttinnove_php_deferred main
    SET zerror = CASE
        WHEN r01.amount01 = r99.amount99::numeric THEN 0
        ELSE NULL
    END
    FROM dswtdir1_dbo.deferred_record_01_sum r01
    JOIN dswtdir1_dbo.deferred_record_99_sum r99 
        ON lower(r01.zsource::text) = lower(r99.zsource::text)
    WHERE lower(main.zsource::text) = lower(r01.zsource::text)
      AND main.zerror IS NULL;
END;
$procedure$
