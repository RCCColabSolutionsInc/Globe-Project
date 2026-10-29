CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.srglobe_dp2_unearned_tdir2_globe_saplairc_zbrandupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Pradeep Gupta 11/23/2020
Modified by: Pradeep Gupta 11/23/2020
Description: Brand
Refactored to update base table directly instead of joining view.
*/
BEGIN
    UPDATE dswtdir2_globe_dbo.stglobe_dp2_unearned_tdir2_globe_saplairc target
    SET zbrand = CASE
            WHEN lower(COALESCE(map.source_val, ''::character varying)::text) = lower(''::text) THEN target.column3
            ELSE map.target_val
        END
    FROM dswtdir2_globe_dbo.zfco_udt_map map
    WHERE lower(COALESCE(target.column3, ''::character varying)::text) = lower(map.source_val::text)
      AND lower(map.from_system::text) = lower('AINV'::text) 
      AND lower(map.event::text) = lower('AIRC'::text) 
      AND lower(map.to_system::text) = lower('SAPFIGL'::text) 
      AND lower(map.bukrs::text) = lower('GLOB'::text) 
      AND lower(map.dimension::text) = lower('BRAND'::text);
END;
$procedure$
