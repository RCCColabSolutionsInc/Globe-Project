CREATE OR REPLACE PROCEDURE sdbtdir1_memoapp_dbo.sp_clean_paymentrequests_33cols()
 LANGUAGE plpgsql
AS $procedure$
/*
Winds: additional data cleansing.
This procedure is executed from the SSIS package
*/
BEGIN
    UPDATE x AS x
    SET Invoice_Number = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Invoice_Number)), MemoApp_Ref_No_or_Proponents_Name = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(MemoApp_Ref_No_or_Proponents_Name)), Vendor_Code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Vendor_Code)), Vendor_Name = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Vendor_Name)), Currency = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Currency)), VAT_Code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(VAT_Code)), Accrual_Doc_Number = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Accrual_Doc_Number)), Company_Code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Company_Code)), Accrual_Doc_Fiscal_Year = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Accrual_Doc_Fiscal_Year)), GL_Natural_Code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(GL_Natural_Code)), Cost_Center_Code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Cost_Center_Code)), IO_Code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(IO_Code)), WBS_Code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(WBS_Code)), Link_Reference = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Link_Reference)), Link_Ref_Period = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Link_Ref_Period)), Product_Line = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Product_Line)), Payment_Method = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Payment_Method)), Payment_Terms = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Payment_Terms)), Description = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Description)), Assignment = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Assignment)), WHT_Type = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(WHT_Type)), Brand = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Brand)), Sub_Prod_A = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Sub_Prod_A)), Revenue_Type = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Revenue_Type)), Site_PLA_ID = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Site_PLA_ID)),
    /* new field 2025 */
    RFP_Approval_Date = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(RFP_Approval_Date)),
    /* new field 2025 */
    Payment_Block_Code = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Payment_Block_Code)),
    /* new field 2025 */
    Profit_Center = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Profit_Center)),
    /* new field 2025 */
    Sub_Prod_B = etl_db_dbo.fn_returnnullifempty(etl_db_dbo.fn_trimspaces2(Sub_Prod_B))
        /* new field 2025 */
    ;
END;
$procedure$
