CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srp_falcon_billed_volvo_072020_fordel()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  zboa0018 9/14/2020 3:17:47 PM
Description: Insert TDIR1_ICCBS into ttInnove_USD_Billed
*/
BEGIN
    DELETE FROM dswtdir1_dbo.srp_falcon_billed_volvo_072020_fordelsel;
END;
$procedure$
