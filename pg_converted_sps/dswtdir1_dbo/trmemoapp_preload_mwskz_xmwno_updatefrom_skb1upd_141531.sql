CREATE OR REPLACE PROCEDURE dswtdir1_dbo.trmemoapp_preload_mwskz_xmwno_updatefrom_skb1upd()
 LANGUAGE plpgsql
AS $procedure$
/*
Created by:  Elakki K 03/25/2021
Modified by: Uma Guduru 03/27/2021
Description: Update Posting without tax allowed information and Tax Code #R2
*/
BEGIN
    UPDATE dswtdir1_dbo.trmemoapp_preload_mwskz_xmwno_updatefrom_skb1updsel
    SET zfstag_skb1 = zfstag_skb1new, zmwskz_skb1 = zmwskz_skb1new, zxmwno_skb1 = zxmwno_skb1new;
END;
$procedure$
