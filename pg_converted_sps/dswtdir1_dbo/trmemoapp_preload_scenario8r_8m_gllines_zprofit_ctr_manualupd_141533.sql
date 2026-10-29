CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_scenario8r_8m_gllines_zprofit_ctr_manualupd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 03/25/2021
Modified by: Uma Guduru 03/25/2021
Description: For 8R GL Lines only, For Input file value Company_Code is GLOB, then use MCG, for INOV use IC_WVL, for BAYN use BT_WVL. For any Other company codes use blank. Values valid only for Rev GLs.
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_scenario8r_8m_gllines_zprofit_ctr_manualupdsel
    SET zprofit_ctr = zprofit_ctrnew;
END;
$procedure$
