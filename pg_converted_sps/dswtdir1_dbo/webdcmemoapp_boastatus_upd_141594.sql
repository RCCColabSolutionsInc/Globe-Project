CREATE OR REPLACE PROCEDURE dswtdir1_dbo.webdcmemoapp_boastatus_upd(IN par_zcounter character varying)
 LANGUAGE plpgsql
AS $procedure$
/* @zCounterLineItem NVARCHAR(50), */
/* @zDSP_UniqueKey NVARCHAR(50), */
/* @zSource NVARCHAR(50)) */
BEGIN
    UPDATE dswtdir1_dbo.dcmemoapp
    SET boastatus = '4'
        WHERE ((SELECT
            value_bit
            FROM zParam_MemoApp
            WHERE key1 = 'MemoCollectErrorAllS4') = 0 AND zloaded <> 1 AND zcleansingperiodclosed <> 1 AND zdisabled_lineitem <> 1 OR zdisabled_counter <> 1) AND aws_sqlserver_ext.conv_string_to_datetime('SMALLDATETIME', zinputfileprocessed_date) < clock_timestamp() - (90::NUMERIC || ' days')::INTERVAL AND zerror_lineitem = '0';
END;
$procedure$
