CREATE OR REPLACE PROCEDURE dswtdir1_dbo.sp_memo_preload_line_transform()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /* Datasources Load */
    /* Scenario 1 */
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn01_01_vendorlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn01_02_gllines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn01_03_vatlines();
    /* Scenario 2 */
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn02_01_vendorlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn02_02_gllines();
    /* Scenario 3 */
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn03_01_vendorlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn03_02_gllines();
    /* Scenario 4 */
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn04_01_vendorlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn04_02_gllines();
    /* Scenario 5 */
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn05_01_vendorlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn05_02_gllines();
    /* Scenario 8R */
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn08r_01_vendorlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn08r_02_vatlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn08r_03_gllines();
    /* Scenario 8M */
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn08m_01_vendorlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn08m_02_gllines();
    /* Scenario 9 */
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn09_01_vendorlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn09_02_vatlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn09_03_gllines();
    /* Scenario 10 */
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn10_01_vendorlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn10_02_vatlines();
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_scn10_03_gllines();
    /* Rules */
    CALL dswtdir1_dbo.sp_memo_preload_line_transform_rules();
END;
$procedure$
