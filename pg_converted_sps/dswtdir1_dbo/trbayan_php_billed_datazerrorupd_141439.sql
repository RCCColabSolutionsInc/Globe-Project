CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trbayan_php_billed_datazerrorupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/04/2020
Modified by: Sindhuja Beram 09/04/2020
Description: Update zError when Total Amount matches with sum of individual amounts
*/
BEGIN
    UPDATE dswtdir1_dbo.trbayan_php_billed_datazerrorupdsel
    SET zerror = zerrornew;
END;
$procedure$
