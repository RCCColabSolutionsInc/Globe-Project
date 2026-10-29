CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trbayan_php_billed_zerrorupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Saketh Venkata Nadurumati 07/27/2020
Modified by: Saketh Venkata Nadurumati 07/27/2020
Description: 	 Update zError when Total Amount matches with sum of individual amounts
*/
BEGIN
    UPDATE dswtdir1_dbo.trbayan_php_billed_zerrorupdsel
    SET zerror = zerrornew;
END;
$procedure$
