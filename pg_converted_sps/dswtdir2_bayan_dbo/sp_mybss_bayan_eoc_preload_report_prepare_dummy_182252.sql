CREATE OR REPLACE PROCEDURE dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dummy(IN par_cyclecode character varying)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_norm_code    VARCHAR(10); -- CALL dswtdir2_bayan_dbo.sp_mybss_bayan_eoc_preload_report_prepare_dummy('EOC1')
    v_billcycle    VARCHAR(5);
    v_cycle_key    VARCHAR(10);
BEGIN
    -- 0. Parameter Normalization
    v_norm_code := UPPER(TRIM(par_cyclecode));
    IF v_norm_code ~ '^[0-9]+$' THEN
        v_norm_code := 'BC' || LPAD(v_norm_code, 2, '0');
    END IF;

    CREATE TABLE IF NOT EXISTS dswtdir2_bayan_dbo.billcycles (
        cyclecode VARCHAR(10), billcycle VARCHAR(5), description VARCHAR(50), 
        runday INT, keyword_ssrs VARCHAR(20), exportfilekey VARCHAR(100), exportfilename VARCHAR(100)
    );

    INSERT INTO dswtdir2_bayan_dbo.billcycles (cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    SELECT v.cyclecode, v.billcycle, v.description, v.runday, v.keyword_ssrs, v.exportfilekey, v.exportfilename
    FROM (VALUES 
        ('EOC1'::VARCHAR, 'BC01'::VARCHAR, 'Every 12th'::VARCHAR, 12::INT, '_BC1_C1'::VARCHAR, 'txBayan_Billed_Cycle1_LoadFileSel'::VARCHAR, 'txBayan_Billed_Cycle1_LoadFileSel.txt'::VARCHAR),
        ('EOC2', 'BC06', 'Every 14th', 14, '_BC6_C2', 'txBayan_Billed_Cycle2_LoadFileSel', 'txBayan_Billed_Cycle2_LoadFileSel.txt'),
        ('EOC3', 'BC08', 'Every 15th', 15, '_BC8_C3', 'txBayan_Billed_Cycle3_LoadFileSel', 'txBayan_Billed_Cycle3_LoadFileSel.txt'),
        ('EOC4', 'BC10', 'Every 16th', 16, '_BC10_C4', 'txBayan_Billed_Cycle4_LoadFileSel', 'txBayan_Billed_Cycle4_LoadFileSel.txt'),
        ('EOC5', 'BC11', 'Every 17th', 17, '_BC11_C5', 'txBayan_Billed_Cycle5_LoadFileSel', 'txBayan_Billed_Cycle5_LoadFileSel.txt'),
        ('EOC6', 'BC13', 'Every 19th', 19, '_BC13_C6', 'txBayan_Billed_Cycle6_LoadFileSel', 'txBayan_Billed_Cycle6_LoadFileSel.txt'),
        ('EOC7', 'BC16', 'Every 21st', 21, '_BC16_C7', 'txBayan_Billed_Cycle7_LoadFileSel', 'txBayan_Billed_Cycle7_LoadFileSel.txt'),
        ('EOC8', 'BC18', 'Every 24th', 24, '_BC18_C8', 'txBayan_Billed_Cycle8_LoadFileSel', 'txBayan_Billed_Cycle8_LoadFileSel.txt'),
        ('EOC9', 'BC21', 'Every 26th', 26, '_BC21_C9', 'txBayan_Billed_Cycle9_LoadFileSel', 'txBayan_Billed_Cycle9_LoadFileSel.txt'),
        ('EOC10', 'BC24', 'Every 30th', 30, '_BC24_C10', 'txBayan_Billed_Cycle10_LoadFileSel', 'txBayan_Billed_Cycle10_LoadFileSel.txt'),
        ('EOC11', 'BC27', 'Every 2nd', 2, '_BC27_C11', 'txBayan_Billed_Cycle11_LoadFileSel', 'txBayan_Billed_Cycle11_LoadFileSel.txt')
    ) AS v(cyclecode, billcycle, description, runday, keyword_ssrs, exportfilekey, exportfilename)
    WHERE NOT EXISTS (
        SELECT 1 FROM dswtdir2_bayan_dbo.billcycles b WHERE b.cyclecode = v.cyclecode
    );

    IF v_norm_code LIKE 'BC%' THEN
        v_billcycle := v_norm_code;
        SELECT cyclecode INTO v_cycle_key FROM dswtdir2_bayan_dbo.billcycles WHERE billcycle = v_billcycle LIMIT 1;
    ELSE
        v_cycle_key := v_norm_code;
        SELECT billcycle INTO v_billcycle FROM dswtdir2_bayan_dbo.billcycles WHERE cyclecode = v_cycle_key LIMIT 1;
    END IF;

    v_billcycle := COALESCE(v_billcycle, 'BC01');
    v_cycle_key := COALESCE(v_cycle_key, 'EOC1');

    -- 1. Charge Code Missing Cache
    CREATE TABLE IF NOT EXISTS dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache (
        missing_charge_code VARCHAR(100),
        billcycle           VARCHAR(5)
    );
    DELETE FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache 
    WHERE billcycle = v_billcycle;

    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_chargecodemissing_cache (
        missing_charge_code, billcycle
    )
    SELECT 'BAYAN_CHG_MISSING_' || g.i, v_billcycle 
    FROM generate_series(1, 5) AS g(i);

    -- 2. Subscriber Type Missing Cache (Enforce non-null billcycle)
    CREATE TABLE IF NOT EXISTS dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca (
        subscriber_type   VARCHAR(100),
        billcycle         VARCHAR(5)
    );
    DELETE FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca 
    WHERE billcycle = v_billcycle;

    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_subscriber_typemissing_ca (
        subscriber_type, billcycle
    )
    VALUES ('BBWL', v_billcycle);

    -- 3. Billed Preload Cache (Valid Records)
    CREATE TABLE IF NOT EXISTS dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache (
        column01          VARCHAR(10),
        column02          VARCHAR(255),
        column03          VARCHAR(255),
        column04          VARCHAR(255),
        column05          VARCHAR(255),
        column06          VARCHAR(255),
        column07          VARCHAR(255),
        column08          VARCHAR(255),
        column09          VARCHAR(255),
        column10          VARCHAR(255),
        column11          VARCHAR(255),
        column12          VARCHAR(255),
        column13          VARCHAR(255),
        column14          VARCHAR(255),
        column15          VARCHAR(255),
        column16          VARCHAR(255),
        column17          VARCHAR(255),
        column18          VARCHAR(255),
        column19          VARCHAR(255),
        zdsp_order        INT,
        zdsp_uniquekey    VARCHAR(100),
        billcycle         VARCHAR(5)
    );
    DELETE FROM dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache 
    WHERE billcycle = v_billcycle;

    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_preload_cache (
        column01, column02, column03, column04, column05, column06, column07,
        column08, column09, column10, column11, column12, column13, column14,
        column15, column16, column17, column18, column19, zdsp_order, zdsp_uniquekey,
        billcycle
    )
    SELECT 
        '01',
        'BAYN_ACC_' || LPAD(g.i::TEXT, 8, '0'),
        'SUB_' || g.i,
        'INV_' || v_billcycle || '_' || g.i,
        'POSTPAID',
        'CHG_CODE_' || (100 + g.i),
        'MONTHLY_SERVICE_FEE',
        'PHP',
        (1500.00 + (g.i * 25.50))::NUMERIC(18,2)::VARCHAR,
        '0.00',
        (1500.00 + (g.i * 25.50))::NUMERIC(18,2)::VARCHAR,
        '180.00',
        '0.00',
        '180.00',
        (1680.00 + (g.i * 25.50))::NUMERIC(18,2)::VARCHAR,
        TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD'),
        TO_CHAR(CURRENT_DATE + INTERVAL '30 days', 'YYYY-MM-DD'),
        'ACT',
        'BAYAN_TELECOM',
        g.i,
        'BAYN_KEY_' || v_billcycle || '_' || g.i,
        v_billcycle
    FROM generate_series(1, 25) AS g(i);

    -- 4. Reconciliation Summary PHP Cache (Populate billcycle column)
    CREATE TABLE IF NOT EXISTS dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryphp_cache (
        description       VARCHAR(200),
        cycle_code_01     VARCHAR(50),
        cycle_code_06     VARCHAR(50),
        cycle_code_08     VARCHAR(50),
        cycle_code_10     VARCHAR(50),
        cycle_code_11     VARCHAR(50),
        cycle_code_13     VARCHAR(50),
        cycle_code_16     VARCHAR(50),
        cycle_code_18     VARCHAR(50),
        cycle_code_21     VARCHAR(50),
        cycle_code_24     VARCHAR(50),
        cycle_code_27     VARCHAR(50),
        total             VARCHAR(50),
        billcycle         VARCHAR(5)
    );
    TRUNCATE TABLE dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryphp_cache;

    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryphp_cache (
        description, cycle_code_01, cycle_code_06, cycle_code_08, cycle_code_10,
        cycle_code_11, cycle_code_13, cycle_code_16, cycle_code_18, cycle_code_21,
        cycle_code_24, cycle_code_27, total, billcycle
    )
    VALUES
        ('Total Previous Balance', '1250000.00', '1340000.00', '1120000.00', '1450000.00', '1560000.00', '1670000.00', '1780000.00', '1890000.00', '1950000.00', '2100000.00', '2250000.00', '18360000.00', v_billcycle),
        ('Total Payments Billed', '-450000.00', '-520000.00', '-480000.00', '-560000.00', '-590000.00', '-610000.00', '-630000.00', '-670000.00', '-710000.00', '-740000.00', '-780000.00', '-6740000.00', v_billcycle),
        ('Total Fin Act', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', v_billcycle),
        ('Total Brought Forward Balance', '800000.00', '820000.00', '640000.00', '890000.00', '970000.00', '1060000.00', '1150000.00', '1220000.00', '1240000.00', '1360000.00', '1470000.00', '11620000.00', v_billcycle),
        ('Total Rental', '2500000.00', '2600000.00', '2450000.00', '2700000.00', '2800000.00', '2900000.00', '3000000.00', '3100000.00', '3200000.00', '3300000.00', '3400000.00', '31950000.00', v_billcycle),
        ('Total Handset Financing', '150000.00', '160000.00', '140000.00', '170000.00', '180000.00', '190000.00', '200000.00', '210000.00', '220000.00', '230000.00', '240000.00', '2090000.00', v_billcycle),
        ('Total Promotion/Discount', '-120000.00', '-130000.00', '-110000.00', '-140000.00', '-150000.00', '-160000.00', '-170000.00', '-180000.00', '-190000.00', '-200000.00', '-210000.00', '-1760000.00', v_billcycle),
        ('Total Traffic Processed', '890000.00', '920000.00', '870000.00', '950000.00', '980000.00', '1010000.00', '1040000.00', '1070000.00', '1100000.00', '1130000.00', '1160000.00', '11120000.00', v_billcycle),
        ('TOTAL INT''L ECONOCALL', '45000.00', '48000.00', '42000.00', '51000.00', '53000.00', '56000.00', '58000.00', '61000.00', '63000.00', '66000.00', '68000.00', '611000.00', v_billcycle),
        ('Total VAS Charge', '350000.00', '370000.00', '340000.00', '390000.00', '410000.00', '430000.00', '450000.00', '470000.00', '490000.00', '510000.00', '530000.00', '4740000.00', v_billcycle),
        ('Total Free Minutes', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', v_billcycle),
        ('Total Less Consumable MSF', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', v_billcycle),
        ('Total Adjustments', '-25000.00', '-28000.00', '-22000.00', '-31000.00', '-33000.00', '-35000.00', '-37000.00', '-40000.00', '-42000.00', '-45000.00', '-47000.00', '-385000.00', v_billcycle),
        ('Total Onetime Charges', '75000.00', '80000.00', '70000.00', '85000.00', '90000.00', '95000.00', '100000.00', '105000.00', '110000.00', '115000.00', '120000.00', '1045000.00', v_billcycle),
        ('Total Overseas Communication Tax', '12000.00', '13000.00', '11000.00', '14000.00', '15000.00', '16000.00', '17000.00', '18000.00', '19000.00', '20000.00', '21000.00', '176000.00', v_billcycle),
        ('Total Overseas Tax (ECONOCALL)', '3500.00', '3800.00', '3200.00', '4100.00', '4300.00', '4600.00', '4800.00', '5100.00', '5300.00', '5600.00', '5800.00', '50100.00', v_billcycle),
        ('Total Surcharge', '18000.00', '19000.00', '17000.00', '21000.00', '22000.00', '24000.00', '25000.00', '27000.00', '28000.00', '30000.00', '31000.00', '262000.00', v_billcycle),
        ('Total VAT', '410000.00', '430000.00', '395000.00', '450000.00', '470000.00', '490000.00', '510000.00', '530000.00', '550000.00', '570000.00', '590000.00', '5495000.00', v_billcycle),
        ('Total Adjustment VAT', '-3000.00', '-3360.00', '-2640.00', '-3720.00', '-3960.00', '-4200.00', '-4440.00', '-4800.00', '-5040.00', '-5400.00', '-5640.00', '-46200.00', v_billcycle),
        ('Total Number of Accounts', '4500', '4650', '4400', '4800', '4950', '5100', '5250', '5400', '5550', '5700', '5850', '56150', v_billcycle),
        ('Total Current Charges', '4363500.00', '4573800.00', '4253200.00', '4776100.00', '4964300.00', '5156600.00', '5348800.00', '5541100.00', '5733300.00', '5925600.00', '6117800.00', '56754500.00', v_billcycle),
        ('Total Amount Due', '5135500.00', '5362440.00', '4868560.00', '5631380.00', '5897340.00', '6177400.00', '6457360.00', '6716300.00', '6926260.00', '7235200.00', '7535160.00', '67948900.00', v_billcycle),
        ('Current Charges', '4363500.00', '4573800.00', '4253200.00', '4776100.00', '4964300.00', '5156600.00', '5348800.00', '5541100.00', '5733300.00', '5925600.00', '6117800.00', '56754500.00', v_billcycle),
        ('Current Adjustments', '-28000.00', '-31360.00', '-24640.00', '-34720.00', '-36960.00', '-39200.00', '-41440.00', '-44800.00', '-47040.00', '-50400.00', '-52640.00', '-431200.00', v_billcycle),
        ('Total Billed', '4335500.00', '4542440.00', '4228560.00', '4741380.00', '4927340.00', '5117400.00', '5307360.00', '5496300.00', '5686260.00', '5875200.00', '6065160.00', '56323300.00', v_billcycle),
        ('Billed charges report', '4363500.00', '4573800.00', '4253200.00', '4776100.00', '4964300.00', '5156600.00', '5348800.00', '5541100.00', '5733300.00', '5925600.00', '6117800.00', '56754500.00', v_billcycle),
        ('Billed Adj report', '-28000.00', '-31360.00', '-24640.00', '-34720.00', '-36960.00', '-39200.00', '-41440.00', '-44800.00', '-47040.00', '-50400.00', '-52640.00', '-431200.00', v_billcycle),
        ('sapglbilled', '4335500.00', '4542440.00', '4228560.00', '4741380.00', '4927340.00', '5117400.00', '5307360.00', '5496300.00', '5686260.00', '5875200.00', '6065160.00', '56323300.00', v_billcycle),
        ('Diff in billed charges', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '0.00', v_billcycle),
        ('Diff in billed adj', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '0.00', v_billcycle),
        ('Diff in sapglbilled', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '0.00', v_billcycle);

    -- 5. Reconciliation Summary USD Cache (Populate billcycle column)
    CREATE TABLE IF NOT EXISTS dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryusd_cache (
        description       VARCHAR(200),
        cycle_code_01     VARCHAR(50),
        cycle_code_06     VARCHAR(50),
        cycle_code_08     VARCHAR(50),
        cycle_code_10     VARCHAR(50),
        cycle_code_11     VARCHAR(50),
        cycle_code_13     VARCHAR(50),
        cycle_code_16     VARCHAR(50),
        cycle_code_18     VARCHAR(50),
        cycle_code_21     VARCHAR(50),
        cycle_code_24     VARCHAR(50),
        cycle_code_27     VARCHAR(50),
        total             VARCHAR(50),
        billcycle         VARCHAR(5)
    );
    TRUNCATE TABLE dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryusd_cache;

    INSERT INTO dswtdir2_bayan_dbo.rpt_preload_report_prepare_dp1_billed_reconsummaryusd_cache (
        description, cycle_code_01, cycle_code_06, cycle_code_08, cycle_code_10,
        cycle_code_11, cycle_code_13, cycle_code_16, cycle_code_18, cycle_code_21,
        cycle_code_24, cycle_code_27, total, billcycle
    )
    VALUES
        ('Total Previous Balance', '25000.00', '26800.00', '22400.00', '29000.00', '31200.00', '33400.00', '35600.00', '37800.00', '39000.00', '42000.00', '45000.00', '367200.00', v_billcycle),
        ('Total Payments Billed', '-9000.00', '-10400.00', '-9600.00', '-11200.00', '-11800.00', '-12200.00', '-12600.00', '-13400.00', '-14200.00', '-14800.00', '-15600.00', '-134800.00', v_billcycle),
        ('Total Fin Act', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', v_billcycle),
        ('Total Brought Forward Balance', '16000.00', '16400.00', '12800.00', '17800.00', '19400.00', '21200.00', '23000.00', '24400.00', '24800.00', '27200.00', '29400.00', '232400.00', v_billcycle),
        ('Total Rental', '50000.00', '52000.00', '49000.00', '54000.00', '56000.00', '58000.00', '60000.00', '62000.00', '64000.00', '66000.00', '68000.00', '639000.00', v_billcycle),
        ('Total Handset Financing', '3000.00', '3200.00', '2800.00', '3400.00', '3600.00', '3800.00', '4000.00', '4200.00', '4400.00', '4600.00', '4800.00', '41800.00', v_billcycle),
        ('Total Promotion/Discount', '-2400.00', '-2600.00', '-2200.00', '-2800.00', '-3000.00', '-3200.00', '-3400.00', '-3600.00', '-3800.00', '-4000.00', '-4200.00', '-35200.00', v_billcycle),
        ('Total Traffic Processed', '17800.00', '18400.00', '17400.00', '19000.00', '19600.00', '20200.00', '20800.00', '21400.00', '22000.00', '22600.00', '23200.00', '222400.00', v_billcycle),
        ('TOTAL INT''L ECONOCALL', '900.00', '960.00', '840.00', '1020.00', '1060.00', '1120.00', '1160.00', '1220.00', '1260.00', '1320.00', '1360.00', '12220.00', v_billcycle),
        ('Total VAS Charge', '7000.00', '7400.00', '6800.00', '7800.00', '8200.00', '8600.00', '9000.00', '9400.00', '9800.00', '10200.00', '10600.00', '94800.00', v_billcycle),
        ('Total Free Minutes', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', v_billcycle),
        ('Total Less Consumable MSF', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', '0.00', v_billcycle),
        ('Total Adjustments', '-500.00', '-560.00', '-440.00', '-620.00', '-660.00', '-700.00', '-740.00', '-800.00', '-840.00', '-900.00', '-940.00', '-7700.00', v_billcycle),
        ('Total Onetime Charges', '1500.00', '1600.00', '1400.00', '1700.00', '1800.00', '1900.00', '2000.00', '2100.00', '2200.00', '2300.00', '2400.00', '20900.00', v_billcycle),
        ('Total Overseas Communication Tax', '240.00', '260.00', '220.00', '280.00', '300.00', '320.00', '340.00', '360.00', '380.00', '400.00', '420.00', '3520.00', v_billcycle),
        ('Total Overseas Tax (ECONOCALL)', '70.00', '76.00', '64.00', '82.00', '86.00', '92.00', '96.00', '102.00', '106.00', '112.00', '116.00', '1002.00', v_billcycle),
        ('Total Surcharge', '360.00', '380.00', '340.00', '420.00', '440.00', '480.00', '500.00', '540.00', '560.00', '600.00', '620.00', '5240.00', v_billcycle),
        ('Total VAT', '8200.00', '8600.00', '7900.00', '9000.00', '9400.00', '9800.00', '10200.00', '10600.00', '11000.00', '11400.00', '11800.00', '109900.00', v_billcycle),
        ('Total Adjustment VAT', '-60.00', '-67.20', '-52.80', '-74.40', '-79.20', '-84.00', '-88.80', '-96.00', '-100.80', '-108.00', '-112.80', '-924.00', v_billcycle),
        ('Total Number of Accounts', '450', '465', '440', '480', '495', '510', '525', '540', '555', '570', '585', '5615', v_billcycle),
        ('Total Current Charges', '87270.00', '91476.00', '85064.00', '95522.00', '99286.00', '103132.00', '106976.00', '110822.00', '114666.00', '118512.00', '122356.00', '1135082.00', v_billcycle),
        ('Total Amount Due', '102710.00', '107248.80', '97371.20', '112627.60', '117946.80', '123548.00', '129147.20', '134326.00', '138525.20', '144704.00', '150703.20', '1358888.00', v_billcycle),
        ('Current Charges', '87270.00', '91476.00', '85064.00', '95522.00', '99286.00', '103132.00', '106976.00', '110822.00', '114666.00', '118512.00', '122356.00', '1135082.00', v_billcycle),
        ('Current Adjustments', '-560.00', '-627.20', '-492.80', '-694.40', '-739.20', '-784.00', '-828.80', '-896.00', '-940.80', '-1008.00', '-1052.80', '-8624.00', v_billcycle),
        ('Total Billed', '86710.00', '90848.80', '84571.20', '94827.60', '98546.80', '102348.00', '106147.20', '109926.00', '113725.20', '117504.00', '121303.20', '1126458.00', v_billcycle),
        ('Billed charges report', '87270.00', '91476.00', '85064.00', '95522.00', '99286.00', '103132.00', '106976.00', '110822.00', '114666.00', '118512.00', '122356.00', '1135082.00', v_billcycle),
        ('Billed Adj report', '-560.00', '-627.20', '-492.80', '-694.40', '-739.20', '-784.00', '-828.80', '-896.00', '-940.80', '-1008.00', '-1052.80', '-8624.00', v_billcycle),
        ('sapglbilled', '86710.00', '90848.80', '84571.20', '94827.60', '98546.80', '102348.00', '106147.20', '109926.00', '113725.20', '117504.00', '121303.20', '1126458.00', v_billcycle),
        ('Diff in billed charges', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '0.00', v_billcycle),
        ('Diff in billed adj', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '0.00', v_billcycle),
        ('Diff in sapglbilled', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '0.00', v_billcycle);

    RAISE NOTICE 'Bayan Preload Report Prepare (Dummy) populated all 5 physical cache tables for cycle % (%).', v_billcycle, v_cycle_key;
END;
$procedure$
