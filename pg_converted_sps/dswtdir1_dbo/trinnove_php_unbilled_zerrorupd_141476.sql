CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trinnove_php_unbilled_zerrorupd()
 LANGUAGE plpgsql
AS $procedure$

/*
Created by:  Sindhuja Beram 07/27/2020
Modified by: Sindhuja Beram 07/27/2020
Description: Rule to check sum of 01 Amount matches 99 record sum
*/
BEGIN
    /*UPDATE dswtdir1_dbo.trinnove_php_unbilled_zerrorupdsel
    SET zerror = zerrornew;*/
	UPDATE dswtdir1_dbo.ttinnove_php_unbilled main
    SET zerror = CASE
        WHEN r01.amount01 = r99.amount99::numeric THEN 0
        ELSE NULL
    END
    FROM dswtdir1_dbo.unbilled_record_01_sum r01
    JOIN dswtdir1_dbo.unbilled_record_99_sum r99 
      ON LOWER(r01.zsource::text) = LOWER(r99.zsource::text)
    WHERE LOWER(main.zsource::text) = LOWER(r01.zsource::text)
      AND main.zerror IS NULL;
END;
$procedure$
