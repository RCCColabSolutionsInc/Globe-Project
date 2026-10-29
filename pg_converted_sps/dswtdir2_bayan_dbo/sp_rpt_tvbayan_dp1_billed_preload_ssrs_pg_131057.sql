CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_rpt_tvbayan_dp1_billed_preload_ssrs_pg(IN par_cyclecode character varying, INOUT p_refcur refcursor)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    var_BCCode VARCHAR(5) DEFAULT 'BC01';
BEGIN
    -- Retrieve the matching billcycle code safely
    SELECT billcycle
    INTO var_BCCode
    FROM dswtdir2_bayan_dbo.billcycles
    WHERE LOWER(cyclecode) = LOWER(par_cyclecode);

    -- If no cyclecode match is found, keep the default or handle it gracefully
    IF var_BCCode IS NULL THEN
        var_BCCode := par_cyclecode;
    END IF;

    -- Open the refcursor to return the result set to the caller
    OPEN p_refcur FOR 
    SELECT
         column01
        ,column02
        ,column03
        ,column04
        ,column05
        ,column06
        ,column07
        -- Safe casting for numeric replacement of TRY_PARSE
        ,ROUND(NULLIF(column08, '')::NUMERIC, 2) AS column08
        ,ROUND(NULLIF(column09, '')::NUMERIC, 2) AS column09
        ,column10
        ,column11
        ,column12
        ,column13
        ,column14
        ,column15
        ,column16
        ,column17
        ,column18
        ,column19
        ,zdsp_order
        ,zdsp_uniquekey
        ,billcycle
    FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache
    WHERE billcycle = var_BCCode 
    ORDER BY column01, NULLIF(zdsp_order, '')::INTEGER;

END;
$procedure$
