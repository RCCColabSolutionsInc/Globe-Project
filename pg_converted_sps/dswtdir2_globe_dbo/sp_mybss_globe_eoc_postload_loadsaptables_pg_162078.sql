CREATE OR REPLACE PROCEDURE dswtdir2_globe_dbo.sp_mybss_globe_eoc_postload_loadsaptables_pg()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
-- *** MANUAL REVIEW NEEDED: linked server to SAP HANA - needs postgres_fdw / hana connectivity, not a same-instance schema ***
		CALL dgs4hana_tdir1.sp_ZTF0002S();

		-- *** MANUAL REVIEW NEEDED: linked server to SAP HANA - needs postgres_fdw / hana connectivity, not a same-instance schema ***
		CALL dgs4hana_tdir1.sp_ZTF0001S();

		-- *** MANUAL REVIEW NEEDED: linked server to SAP HANA - needs postgres_fdw / hana connectivity, not a same-instance schema ***
		CALL dgs4hana_tdir1.sp_ZFFI_REPORT_ODBC_Delta();
END;
$procedure$
