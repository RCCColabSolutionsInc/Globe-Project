CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo."dswtdir2_bayan_dbo.sp_rpt_tvbayan_dp1_billed_postload_valid_ssr"()
 LANGUAGE plpgsql
AS $procedure$

DECLARE 
var_BCCode VARCHAR(5) := 'BC01';

	BEGIN

		SELECT
		billcycle
		INTO var_BCCode
		FROM dswtdir2_bayan_dbo.billcycles
		WHERE LOWER(cyclecode) = LOWER(par_CycleCode);
	END;
$procedure$
