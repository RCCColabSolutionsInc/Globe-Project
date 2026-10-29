CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trbayan_php_unbilled_datazerrorupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/04/2020
Modified by: Sindhuja Beram 09/04/2020
Description: Update zError when Total Amount matches with sum of individual amounts
*/
BEGIN
    UPDATE dswtdir1_dbo.trbayan_php_unbilled_datazerrorupdsel
    SET zerror = zerrornew;
END;
$procedure$
