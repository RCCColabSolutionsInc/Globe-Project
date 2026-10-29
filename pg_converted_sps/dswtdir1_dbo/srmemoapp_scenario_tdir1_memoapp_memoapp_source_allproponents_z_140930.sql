CREATE OR REPLACE PROCEDURE dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_z()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Uma Guduru 03/22/2021
Modified by: Uma Guduru 03/22/2021
Description: R2 Manual Rule to update SKB1 fields zMWSKZ_SKB1_ScnInitial, zXMWNO_SKB1_ScnInitial, zXLOEB_SKB1_ScnInitial, zXSPEB_SKB1_ScnInitial.
*/
BEGIN
    UPDATE dswtdir1_dbo.srmemoapp_scenario_tdir1_memoapp_memoapp_source_allproponents_zxloeb_skb1_scninitial_skb1_fields_updsel
    SET zmwskz_skb1_scninitial = zmwskz_skb1_scninitialnew, zxloeb_skb1_scninitial = zxloeb_skb1_scninitialnew, zxmwno_skb1_scninitial = zxmwno_skb1_scninitialnew, zxspeb_skb1_scninitial = zxspeb_skb1_scninitialnew;
END;
$procedure$
