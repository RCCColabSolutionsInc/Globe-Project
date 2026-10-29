CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_postload_transform_dummy()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- =========================================================================
    -- 0. SCHEMA REFRESH (SELF-HEALING)
    -- Safely attempts to drop the object whether it currently exists as a View or a Table.
    -- Catches and ignores 'wrong_object_type' (SQLSTATE 42809) errors.
    -- =========================================================================
    BEGIN
        DROP VIEW IF EXISTS dswtdir2_bayan_dbo.trbayan_billed_zloaded_updsel CASCADE;
    EXCEPTION WHEN wrong_object_type THEN
        -- Do nothing, it is not a view
    END;

    BEGIN
        DROP TABLE IF EXISTS dswtdir2_bayan_dbo.trbayan_billed_zloaded_updsel CASCADE;
    EXCEPTION WHEN wrong_object_type THEN
        -- Do nothing, it is not a table
    END;
    
    CREATE TABLE dswtdir2_bayan_dbo.trbayan_billed_zloaded_updsel (
        zloaded VARCHAR(10),
        zloadednew VARCHAR(10)
    );

    -- =========================================================================
    -- 1. STAGE DUMMY DATA
    -- Simulates the output of the legacy view where zloadedNew is hardcoded to '1'
    -- =========================================================================
    INSERT INTO dswtdir2_bayan_dbo.trbayan_billed_zloaded_updsel (zloaded, zloadednew)
    SELECT '0' AS zloaded, '1' AS zloadednew
    FROM generate_series(1, 55) AS g(i);

    -- =========================================================================
    -- 2. EXECUTE TRANSFORM LOGIC (Mirrors trBayan_Billed_zloaded_Upd)
    -- Updates the zloaded flag across the staged records
    -- =========================================================================
    UPDATE dswtdir2_bayan_dbo.trbayan_billed_zloaded_updsel
    SET zloaded = zloadednew;

    RAISE NOTICE 'Postload Transform dummy pipeline executed. View mocked as a physical table and updated securely.';
END;
$procedure$
