CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zproduct_gro()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Sindhuja Beram 09/04/2020
Modified by: Sindhuja Beram 09/04/2020
Description: Updates zProduct_Group , zService_Type based on ZFFI_PROD_SERV
*/
BEGIN
    UPDATE dswtdir1_dbo.srbayan_usd_deferred_data_tdir1_iccbs_sap_bdef_usd_zproduct_group_zservice_typeupdsel
    SET zproduct_group = zproduct_groupnew, zservice_type = zservice_typenew;
END;
$procedure$
