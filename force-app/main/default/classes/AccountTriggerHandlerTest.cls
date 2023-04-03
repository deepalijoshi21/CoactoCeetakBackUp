/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test class for AccountTriggerHandler
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-05-01
* @modified       2020-05-04
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
public class AccountTriggerHandlerTest {
    @isTest
    public static void addErrorTest(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1]; 
        
        User usr = new User(LastName = 'Test',
                            FirstName='User',
                            Alias = 'TUser',
                            Email = 'test.user@test111111.com',
                            Username = 'test.user@test111111.com',
                            ProfileId = profileId.id, 
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           ); 
        insert usr;
        Account acc = new Account();
        acc.name = 'test account';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId(); 
        acc.Supplier_Account_Type__c = 'Potential';
        acc.name = 'test account';
        acc.Phone = '1920';
        acc.Key_Products__c = 'Kit';
        acc.Sales_Calculation_for_F_D__c = 12;
        acc.Secondary_Internal_Sales__c = userinfo.getuserid();
        acc.AccountSource = 'Area Sales Manager';
        acc.LFY_Actual_Sales__c = 10;
        acc.BillingCity = 'Small Town';
        acc.Duty_Charges_Actual__c = 12;
        acc.Supplier_Type__c = 'Seals';
        acc.Freight_Charges_Actual__c  = 80;
        acc.Industry_Sector_s__c = 'Automotive';
        acc.BillingCountry = 'United States';
        acc.BillingPostalCode = 'HG11 6YT';
        acc.BillingState = 'Connecticut';
        acc.BillingStreet = '5 Never Ending Road 6 \n Never Ending 7 \nNever Ending';
        acc.Payment_Terms__c = '7 Days EOM';
        acc.Primary_Internal_Sales__c = userinfo.getuserid();
        acc.Ceetak_Location__c = 'BED';
        acc.Customer_Type__c = 'OEM';
        acc.Key_Engineer__c = userinfo.getuserid();
        acc.Minimum_Line_Value__c = 12;
        acc.Minimum_Order_Value__c = 12;
        acc.Primary_Industry_Sector__c = 'Automotive';
        acc.Sales_Area__c = '1';
        acc.Account_Status__c = 'Open';
        acc.Incoterms_Shipping_Terms__c = 'Ex Works (EXW)';
        acc.Actual_YTD__c = 10;
        acc.Credit_Balance__c = 10;
        acc.Credit_Limit__c = 10;
        acc.Customer_Category__c = 'AA';
        //acc.Forecast__c = 10;
        acc.Incoterms_Shipping_Terms__c = 'Ex Works (EXW)';
        acc.FY_Forecast__c = 10;
        acc.Open_Order_Value__c = 10;
        acc.VAT_Code__c = 'Exempt';
        acc.VAT_Zone__c = 'Domestic';
        acc.Warning_Quotation_Order__c = 'Test';
        acc.order_class__c = 'PROJ' ;
        insert acc;
        
        acc.Supplier_Account_Type__c = 'Approved';
        update acc;
        
        system.runAs(usr){
            try{                
                acc.Payment_Terms__c = '30 Days EOM'; 
                acc.VAT_Zone__c = 'Outside EU';    
                acc.Bank_Account_No__c = '30';
                acc.Bank_Sort_Code__c = '30';
                acc.Early_Payment_Discount__c = 50;
                acc.Company_Registration_No__c = 'Test123Abc';
                acc.CurrencyIsoCode = 'USD';
                acc.VAT_Code__c = 'Exempt';
                acc.LFY_Spend__c = 80;
                acc.Last_Traded__c = system.today().addDays(3);
                acc.Freight_Charges_Actual__c  = 80;
                acc.Duty_Charges_Actual__c  = 80; 
                acc.CFY_Spend__c  = 11233;
                acc.Warning_Quotation_Order__c = 'Test';
                acc.order_class__c = 'PROJ' ;
                update acc;       
            }catch(Exception e){
                System.debug(e);
            }  
        }
    }
    @testSetup static void customerAndSupplierAccountRecords() {

        Account_Mapping_Customer__c accMappingCustomerOrderClass = new Account_Mapping_Customer__c();
        accMappingCustomerOrderClass.Hansa_Picklist_Value__c = 'SCALL';
        accMappingCustomerOrderClass.Salesforce_Field__c = 'order_class__c';
        accMappingCustomerOrderClass.Salesforce_Picklist_Value__c = 'SCALL';
        accMappingCustomerOrderClass.name = 'test121';
        insert accMappingCustomerOrderClass;

        Account_Mapping_Customer__c accMappingCustomerOrderClass1 = new Account_Mapping_Customer__c();
        accMappingCustomerOrderClass1.Hansa_Picklist_Value__c = 'PROJ';
        accMappingCustomerOrderClass1.Salesforce_Field__c = 'order_class__c';
        accMappingCustomerOrderClass1.Salesforce_Picklist_Value__c = 'PROJ';
        accMappingCustomerOrderClass1.name = 'test212';
        insert accMappingCustomerOrderClass1;

        Account customerAccount = new Account();
        customerAccount.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        customerAccount.type = 'Prospect';
        customerAccount.name = 'Test Customer Account';
        customerAccount.Phone = '1920';
        customerAccount.Secondary_Internal_Sales__c = userinfo.getuserid();
        customerAccount.AccountSource = 'Area Sales Manager';
        customerAccount.LFY_Actual_Sales__c = 10;
        customerAccount.BillingCity = 'Small Town';
        customerAccount.BillingCountry = 'United States';
        customerAccount.BillingPostalCode = 'HG11 6YT';
        customerAccount.BillingState = 'Connecticut';
        customerAccount.BillingStreet = '5 Never Ending Road 6 \n Never Ending 7 \nNever Ending';
        customerAccount.shippingCity = 'Small Town';
        customerAccount.shippingCountry = 'United States';
        customerAccount.shippingPostalCode = 'HG11 6YT';
        customerAccount.shippingState = 'Connecticut';
        customerAccount.shippingStreet = '5 Never Ending Road 6 \n Never Ending 7 \nNever Ending';
        customerAccount.Primary_Internal_Sales__c = userinfo.getuserid();
        customerAccount.Ceetak_Location__c = 'BED';
        customerAccount.Customer_Type__c = 'OEM';
        customerAccount.Key_Engineer__c = userinfo.getuserid();
        customerAccount.Minimum_Line_Value__c = 12;
        customerAccount.Minimum_Order_Value__c = 12;
        customerAccount.Primary_Industry_Sector__c = 'Automotive';
        customerAccount.Sales_Area__c = '1';
        customerAccount.Account_Status__c = 'Open';
        customerAccount.Actual_YTD__c = 10;
        customerAccount.Industry_Sector_s__c = 'Automotive';
        customerAccount.Credit_Balance__c = 10;
        customerAccount.Credit_Limit__c = 10;
        customerAccount.Customer_Category__c = 'AA';
        customerAccount.FY_Forecast__c = 10;
        customerAccount.Open_Order_Value__c = 10;
        customerAccount.VAT_Code__c = 'Exempt';
        customerAccount.Payment_Terms__c = '7 Days EOM';
        customerAccount.Supplier_Type__c = 'Seals';
        customerAccount.Key_Products__c = 'Kit';
        customerAccount.VAT_Zone__c = 'Domestic';
        customerAccount.Account_Status__c = 'Open';
        customerAccount.Sales_Area__c = '1';
        customerAccount.Language__c = 'KAWASAKI';
        customerAccount.Customer_VAT_No__c = 'test';
        customerAccount.Customer_Category__c = 'AA';
        customerAccount.Shipping_Instructions__c = 'test';
        customerAccount.Email__c = 'test@gmail.com';
        customerAccount.Website = 'www.test.com';
        customerAccount.Incoterms_Shipping_Terms__c = 'Ex Works (EXW)';
        customerAccount.EDI_Customer__c = 'Yes';
        customerAccount.CurrencyIsoCode = 'EUR';
        customerAccount.Warning_Quotation_Order__c = 'Test';
        customerAccount.order_class__c = 'PROJ' ;
        insert customerAccount;
        
        Account supplierAccount = new Account();
        supplierAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        supplierAccount.name = 'Test Supplier Account';
        supplierAccount.Phone = '19201';
        supplierAccount.Supplier_Account_Type__c = 'Potential';
        supplierAccount.Secondary_Internal_Sales__c = userinfo.getuserid();
        supplierAccount.AccountSource = 'Area Sales Manager';
        supplierAccount.LFY_Actual_Sales__c = 10;
        supplierAccount.BillingCity = 'Small Town';
        supplierAccount.BillingCountry = 'United States';
        supplierAccount.BillingPostalCode = 'HG11 6YT';
        supplierAccount.BillingState = 'Connecticut';
        supplierAccount.BillingStreet = '5 Never Ending Road 6 \n Never Ending 7 \nNever Ending';
        supplierAccount.shippingCity = 'Small Town';
        supplierAccount.shippingCountry = 'United States';
        supplierAccount.shippingPostalCode = 'HG11 6YT';
        supplierAccount.shippingState = 'Connecticut';
        supplierAccount.shippingStreet = '5 Never Ending Road 6 \n Never Ending 7 \nNever Ending';
        supplierAccount.Primary_Internal_Sales__c = userinfo.getuserid();
        supplierAccount.Ceetak_Location__c = 'BED';
        supplierAccount.Customer_Type__c = 'OEM';
        supplierAccount.Key_Engineer__c = userinfo.getuserid();
        supplierAccount.Minimum_Line_Value__c = 12;
        supplierAccount.Minimum_Order_Value__c = 12;
        supplierAccount.Primary_Industry_Sector__c = 'Automotive';
        supplierAccount.Sales_Area__c = '1';
        supplierAccount.Account_Status__c = 'Open';
        supplierAccount.Actual_YTD__c = 10;
        supplierAccount.Credit_Balance__c = 10;
        supplierAccount.Credit_Limit__c = 10;
        supplierAccount.Customer_Category__c = 'AA';
        supplierAccount.FY_Forecast__c = 10;
        supplierAccount.Open_Order_Value__c = 10;
        supplierAccount.VAT_Code__c = 'Exempt';
        supplierAccount.Freight_Charges_Actual__c  = 80;
        supplierAccount.Key_Products__c = 'Kit';
        supplierAccount.Industry_Sector_s__c = 'Automotive';
        supplierAccount.VAT_Zone__c = 'Domestic';
        supplierAccount.Supplier_Type__c = 'Seals';
        supplierAccount.Duty_Charges_Actual__c = 12;
        supplierAccount.Website = 'www.google.com';
        supplierAccount.Payment_Terms__c = '7 Days EOM';
        supplierAccount.Email__c = 'test@gmail.com';
        supplierAccount.Bank_Account_No__c = '12';
        supplierAccount.Bank_Sort_Code__c = '12';
        supplierAccount.Same_as_Billing_Address__c = true;
        supplierAccount.Incoterms_Shipping_Terms__c = 'Ex Works (EXW)';
        supplierAccount.Sales_Calculation_for_F_D__c = 12;
        supplierAccount.CurrencyIsoCode = 'EUR';
        insert supplierAccount;
        
        Account_Mapping_Supplier__c accMappingSupplier = new Account_Mapping_Supplier__c();
        accMappingSupplier.Hansa_Picklist_Value__c  = '1';
        accMappingSupplier.Salesforce_Field__c = 'VAT_Zone__c';
        accMappingSupplier.Salesforce_Picklist_Value__c = 'Domestic';
        accMappingSupplier.Name = 'Test Account Mapping Supplier';
        insert accMappingSupplier;
        
    }
    @isTest
    public static void updateCustomerAccount(){
        Test.setMock(HttpCalloutMock.class, new AccountTriggerHandlerMockCallout());
        Hansa_ERP__c erp = new Hansa_ERP__c();
        erp.name = 'Refresh Token';
        erp.Client_Identification__c = '18B30509-DD3026C9-C1FA6558-E230A9AD-F6A9B9DF';
        erp.Client_Secret__c = '9e570ca990099d39c9fa859b2c8ea8b3';
        erp.Authorization_URI__c = 'https://standard-id.hansaworld.com/oauth-authorize';
        erp.Access_Token_URI__c = 'https://standard-id.hansaworld.com/oauth-token';
        erp.Redirect_URI__c = 'https://test.salesforce.com/apex/HansaAuthoriza...';
        erp.Customer_Supplier_End_Point_URL__c = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/CUVc?';
        erp.Turn_of_Account_Sync__c = false;
        erp.Alternate_Address_End_Point__c = 'testAddress';
        insert erp; 
        
        Account_Mapping_Customer__c accMappingCustomer = new Account_Mapping_Customer__c();
        accMappingCustomer.Hansa_Picklist_Value__c = '1';
        accMappingCustomer.Salesforce_Field__c = 'ceetak_location__c';
        accMappingCustomer.Salesforce_Picklist_Value__c = 'ABE';
        accMappingCustomer.name = 'test3';
        insert accMappingCustomer;
        
        Account_Mapping_Customer__c accMappingCustomer1 = new Account_Mapping_Customer__c();
        accMappingCustomer1.Hansa_Picklist_Value__c = '2';
        accMappingCustomer1.Salesforce_Field__c = 'Language__c';
        accMappingCustomer1.Salesforce_Picklist_Value__c = 'CONFLOW LTD';
        accMappingCustomer1.name = 'test2';
        insert accMappingCustomer1;
        
        Account_Mapping_Customer__c accMappingCustomer2 = new Account_Mapping_Customer__c();
        accMappingCustomer2.Hansa_Picklist_Value__c = '3';
        accMappingCustomer2.Salesforce_Field__c = 'Sales_Area__c';
        accMappingCustomer2.Salesforce_Picklist_Value__c = '2';
        accMappingCustomer2.name = 'test1';
        insert accMappingCustomer2;
        
        Account_Mapping_Customer__c accMappingCustomer3 = new Account_Mapping_Customer__c();
        accMappingCustomer3.Hansa_Picklist_Value__c = '3';
        accMappingCustomer3.Salesforce_Field__c = 'Customer_Category__c';
        accMappingCustomer3.Salesforce_Picklist_Value__c = 'A';
        accMappingCustomer3.name = 'test4';
        insert accMappingCustomer3;
        
        Account_Mapping_Customer__c accMappingCustomer4 = new Account_Mapping_Customer__c();
        accMappingCustomer4.Hansa_Picklist_Value__c = '3';
        accMappingCustomer4.Salesforce_Field__c = 'EDI_Customer__c';
        accMappingCustomer4.Salesforce_Picklist_Value__c = 'No';
        accMappingCustomer4.name = 'test5';
        insert accMappingCustomer4;
        
        Account_Mapping_Customer__c accMappingCustomer5 = new Account_Mapping_Customer__c();
        accMappingCustomer5.Hansa_Picklist_Value__c = '3';
        accMappingCustomer5.Salesforce_Field__c = 'currencyisocode';
        accMappingCustomer5.Salesforce_Picklist_Value__c = 'GBP';
        accMappingCustomer5.name = 'test6';
        insert accMappingCustomer5;
        
        Account_Mapping_Customer__c accMappingCustomer6 = new Account_Mapping_Customer__c();
        accMappingCustomer6.Hansa_Picklist_Value__c = '3';
        accMappingCustomer6.Salesforce_Field__c = 'vat_code__c';
        accMappingCustomer6.Salesforce_Picklist_Value__c = '5% Rate';
        accMappingCustomer6.name = 'test7';
        insert accMappingCustomer6;
        
        Account_Mapping_Customer__c accMappingCustomer7 = new Account_Mapping_Customer__c();
        accMappingCustomer7.Hansa_Picklist_Value__c = '3';
        accMappingCustomer7.Salesforce_Field__c = 'vat_zone__c';
        accMappingCustomer7.Salesforce_Picklist_Value__c = 'Inside EU';
        accMappingCustomer7.name = 'test8';
        insert accMappingCustomer7;
        
        Account_Mapping_Customer__c accMappingCustomer8 = new Account_Mapping_Customer__c();
        accMappingCustomer8.Hansa_Picklist_Value__c = '3';
        accMappingCustomer8.Salesforce_Field__c = 'incoterms_shipping_terms__c';
        accMappingCustomer8.Salesforce_Picklist_Value__c = 'Ex Works (EXW)';
        accMappingCustomer8.name = 'test9';
        insert accMappingCustomer8;
        
        Account_Mapping_Customer__c accMappingCustomer9 = new Account_Mapping_Customer__c();
        accMappingCustomer9.Hansa_Picklist_Value__c = '3';
        accMappingCustomer9.Salesforce_Field__c = 'payment_terms__c';
        accMappingCustomer9.Salesforce_Picklist_Value__c = '15 Days EOM';
        accMappingCustomer9.name = 'test10';
        insert accMappingCustomer9;

        Account_Mapping_Customer__c accMappingCustomerOrderClass = new Account_Mapping_Customer__c();
        accMappingCustomerOrderClass.Hansa_Picklist_Value__c = 'SCALL';
        accMappingCustomerOrderClass.Salesforce_Field__c = 'order_class__c';
        accMappingCustomerOrderClass.Salesforce_Picklist_Value__c = 'SCALL';
        accMappingCustomerOrderClass.name = 'test11';
        insert accMappingCustomerOrderClass;

        Account_Mapping_Customer__c accMappingCustomerOrderClass1 = new Account_Mapping_Customer__c();
        accMappingCustomerOrderClass1.Hansa_Picklist_Value__c = 'PROJ';
        accMappingCustomerOrderClass1.Salesforce_Field__c = 'order_class__c';
        accMappingCustomerOrderClass1.Salesforce_Picklist_Value__c = 'PROJ';
        accMappingCustomerOrderClass1.name = 'test12';
        insert accMappingCustomerOrderClass1;
        
        List<Account> accList = new List<Account>();
        for(Account acc : [select id from account where name = 'Test Customer Account']){
            acc.type = 'Certified';
            acc.name = 'Update Customer Account';
            acc.Account_Status__c = 'Closed';
            acc.Ceetak_Location__c = 'ABE';
            acc.Language__c = 'CONFLOW LTD';
            acc.Sales_Area__c = '2';
            acc.Customer_Category__c = 'A';
            acc.EDI_Customer__c = 'No';
            acc.VAT_Zone__c = 'Inside EU';
            acc.VAT_Code__c = '5% Rate';
            acc.Incoterms_Shipping_Terms__c = 'Free Carrier (FCA)';
            acc.Payment_Terms__c = '15 Days EOM';
            acc.Website = 'www.test.com';
            acc.phone = '12344';
            acc.Email__c = 'test1@gmail.com';
            acc.Shipping_Instructions__c = 'test123';
            acc.Customer_VAT_No__c = '11';
            acc.Credit_Limit__c = 12;
            acc.Hansa_Account_Number__c = '12';
            acc.BillingCountry = 'United Kingdom';
            acc.BillingCity = 'small town';
            acc.BillingState = 'Bristol';
            acc.BillingStreet = '8 Never Ending Road 9 \n Never Ending 10 \nNever Ending';
            acc.BillingPostalCode = '1234';
            acc.shippingCity = 'Small Town';
            acc.shippingCountry = 'United Kingdom';
            acc.shippingPostalCode = 'HG11 6YTR';
            acc.shippingState = 'Bristol';
            acc.CurrencyIsoCode = 'GBP';
            acc.shippingStreet = '55 Never Ending Road 66 \n Never Ending 77 \nNever Ending';
            acc.Same_as_Billing_Address__c = true;
            acc.Warning_Quotation_Order__c = 'Test';
            acc.order_class__c = 'SCALL' ;
            accList.add(acc);
        }
        RunOnce.accountTrigger = true;
        update accList;
        
    }
    @isTest
    public static void updateSupplierAccount(){
        
        Test.setMock(HttpCalloutMock.class, new AccountTriggerHandlerMockCallout());
        Hansa_ERP__c erp = new Hansa_ERP__c();
        erp.name = 'Refresh Token';
        erp.Client_Identification__c = '18B30509-DD3026C9-C1FA6558-E230A9AD-F6A9B9DF';
        erp.Client_Secret__c = '9e570ca990099d39c9fa859b2c8ea8b3';
        erp.Authorization_URI__c = 'https://standard-id.hansaworld.com/oauth-authorize';
        erp.Access_Token_URI__c = 'https://standard-id.hansaworld.com/oauth-token';
        erp.Redirect_URI__c = 'https://test.salesforce.com/apex/HansaAuthoriza...';
        erp.Customer_Supplier_End_Point_URL__c = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/CUVc?';
        erp.Turn_of_Account_Sync__c = false;
        erp.Alternate_Address_End_Point__c = 'testAddress';
        insert erp;
        
        Account_Mapping_Customer__c accMappingCustomer5 = new Account_Mapping_Customer__c();
        accMappingCustomer5.Hansa_Picklist_Value__c = '3';
        accMappingCustomer5.Salesforce_Field__c = 'currencyisocode';
        accMappingCustomer5.Salesforce_Picklist_Value__c = 'GBP';
        accMappingCustomer5.name = 'test6';
        insert accMappingCustomer5;
        
        Account_Mapping_Customer__c accMappingCustomer6 = new Account_Mapping_Customer__c();
        accMappingCustomer6.Hansa_Picklist_Value__c = '3';
        accMappingCustomer6.Salesforce_Field__c = 'vat_code__c';
        accMappingCustomer6.Salesforce_Picklist_Value__c = 'Exempt';
        accMappingCustomer6.name = 'test7';
        insert accMappingCustomer6;
        
        Account_Mapping_Customer__c accMappingCustomer7 = new Account_Mapping_Customer__c();
        accMappingCustomer7.Hansa_Picklist_Value__c = '3';
        accMappingCustomer7.Salesforce_Field__c = 'vat_zone__c';
        accMappingCustomer7.Salesforce_Picklist_Value__c = 'Domestic';
        accMappingCustomer7.name = 'test8';
        insert accMappingCustomer7;
        
        Account_Mapping_Customer__c accMappingCustomer8 = new Account_Mapping_Customer__c();
        accMappingCustomer8.Hansa_Picklist_Value__c = '3';
        accMappingCustomer8.Salesforce_Field__c = 'incoterms_shipping_terms__c';
        accMappingCustomer8.Salesforce_Picklist_Value__c = 'Ex Works (EXW)';
        accMappingCustomer8.name = 'test9';
        insert accMappingCustomer8;
        
        Account_Mapping_Customer__c accMappingCustomer9 = new Account_Mapping_Customer__c();
        accMappingCustomer9.Hansa_Picklist_Value__c = '3';
        accMappingCustomer9.Salesforce_Field__c = 'payment_terms__c';
        accMappingCustomer9.Salesforce_Picklist_Value__c = '7 Days EOM';
        accMappingCustomer9.name = 'test10';
        insert accMappingCustomer9;

        Account_Mapping_Customer__c accMappingCustomerOrderClass = new Account_Mapping_Customer__c();
        accMappingCustomerOrderClass.Hansa_Picklist_Value__c = 'SCALL';
        accMappingCustomerOrderClass.Salesforce_Field__c = 'order_class__c';
        accMappingCustomerOrderClass.Salesforce_Picklist_Value__c = 'SCALL';
        accMappingCustomerOrderClass.name = 'test11';
        insert accMappingCustomerOrderClass;

        Account_Mapping_Customer__c accMappingCustomerOrderClass1 = new Account_Mapping_Customer__c();
        accMappingCustomerOrderClass1.Hansa_Picklist_Value__c = 'PROJ';
        accMappingCustomerOrderClass1.Salesforce_Field__c = 'order_class__c';
        accMappingCustomerOrderClass1.Salesforce_Picklist_Value__c = 'PROJ';
        accMappingCustomerOrderClass1.name = 'test12';
        insert accMappingCustomerOrderClass1;
        
        List<Account> accList = new List<Account>();
        for(Account acc : [select id from account where name = 'Test Supplier Account']){
            acc.Supplier_Account_Type__c = 'Approved';
            acc.name = 'udpate Sup';
            acc.VAT_Zone__c = 'Inside EU';
            acc.VAT_Code__c = '5% Rate';
            acc.Incoterms_Shipping_Terms__c = 'Free Carrier (FCA)';
            acc.Payment_Terms__c = '15 Days EOM';
            acc.Website = 'www.test.com';
            acc.phone = '12344';
            acc.Email__c = 'test1@gmail.com';
            acc.Bank_Account_No__c = '123456';
            acc.Bank_Sort_Code__c = '12311';
            acc.BillingCountry = 'United Kingdom';
            acc.BillingCity = 'small town';
            acc.BillingState = 'Bristol';
            acc.BillingStreet = '54 Never Ending Road 46 \n Never Ending 74 \nNever Ending';
            acc.BillingPostalCode = '1234';
            acc.shippingCity = 'Small Town';
            acc.shippingCountry = 'United Kingdom';
            acc.shippingPostalCode = 'HG11 6YTR';
            acc.shippingState = 'Bristol';
            acc.shippingStreet = '55 Never Ending Road 66 \n Never Ending 77 \nNever Ending';           
            acc.Same_as_Billing_Address__c = true;
            acc.Hansa_Supplier_Number__c = '12';
            acc.CurrencyIsoCode = 'GBP';
            accList.add(acc);
        }
        RunOnce.accountTrigger = true;
        update accList;
    }
    
    
    @isTest
    public static void customerAccountSameasBillingAddress(){
        Test.setMock(HttpCalloutMock.class, new AccountTriggerHandlerMockCallout());
        
        Hansa_ERP__c erp = new Hansa_ERP__c();
        erp.name = 'Refresh Token';
        erp.Client_Identification__c = '18B30509-DD3026C9-C1FA6558-E230A9AD-F6A9B9DF';
        erp.Client_Secret__c = '9e570ca990099d39c9fa859b2c8ea8b3';
        erp.Authorization_URI__c = 'https://standard-id.hansaworld.com/oauth-authorize';
        erp.Access_Token_URI__c = 'https://standard-id.hansaworld.com/oauth-token';
        erp.Redirect_URI__c = 'https://test.salesforce.com/apex/HansaAuthoriza...';
        erp.Customer_Supplier_End_Point_URL__c = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/CUVc?';
        erp.Turn_of_Account_Sync__c = false;
        erp.Alternate_Address_End_Point__c = 'testAddress';
        insert erp;
        
        Account_Mapping_Customer__c accMappingCustomer = new Account_Mapping_Customer__c();
        accMappingCustomer.Hansa_Picklist_Value__c = '1';
        accMappingCustomer.Salesforce_Field__c = 'ceetak_location__c';
        accMappingCustomer.Salesforce_Picklist_Value__c = 'ABE';
        accMappingCustomer.name = 'test3';
        insert accMappingCustomer;
        
        Account_Mapping_Customer__c accMappingCustomer1 = new Account_Mapping_Customer__c();
        accMappingCustomer1.Hansa_Picklist_Value__c = '2';
        accMappingCustomer1.Salesforce_Field__c = 'Language__c';
        accMappingCustomer1.Salesforce_Picklist_Value__c = 'CONFLOW LTD';
        accMappingCustomer1.name = 'test2';
        insert accMappingCustomer1;
        
        Account_Mapping_Customer__c accMappingCustomer2 = new Account_Mapping_Customer__c();
        accMappingCustomer2.Hansa_Picklist_Value__c = '3';
        accMappingCustomer2.Salesforce_Field__c = 'Sales_Area__c';
        accMappingCustomer2.Salesforce_Picklist_Value__c = '2';
        accMappingCustomer2.name = 'test1';
        insert accMappingCustomer2;
        
        Account_Mapping_Customer__c accMappingCustomer3 = new Account_Mapping_Customer__c();
        accMappingCustomer3.Hansa_Picklist_Value__c = '3';
        accMappingCustomer3.Salesforce_Field__c = 'Customer_Category__c';
        accMappingCustomer3.Salesforce_Picklist_Value__c = 'A';
        accMappingCustomer3.name = 'test4';
        insert accMappingCustomer3;
        
        Account_Mapping_Customer__c accMappingCustomer4 = new Account_Mapping_Customer__c();
        accMappingCustomer4.Hansa_Picklist_Value__c = '3';
        accMappingCustomer4.Salesforce_Field__c = 'EDI_Customer__c';
        accMappingCustomer4.Salesforce_Picklist_Value__c = 'No';
        accMappingCustomer4.name = 'test5';
        insert accMappingCustomer4;
        
        Account_Mapping_Customer__c accMappingCustomer5 = new Account_Mapping_Customer__c();
        accMappingCustomer5.Hansa_Picklist_Value__c = '3';
        accMappingCustomer5.Salesforce_Field__c = 'currencyisocode';
        accMappingCustomer5.Salesforce_Picklist_Value__c = 'GBP';
        accMappingCustomer5.name = 'test6';
        insert accMappingCustomer5;
        
        Account_Mapping_Customer__c accMappingCustomer6 = new Account_Mapping_Customer__c();
        accMappingCustomer6.Hansa_Picklist_Value__c = '3';
        accMappingCustomer6.Salesforce_Field__c = 'vat_code__c';
        accMappingCustomer6.Salesforce_Picklist_Value__c = '5% Rate';
        accMappingCustomer6.name = 'test7';
        insert accMappingCustomer6;
        
        Account_Mapping_Customer__c accMappingCustomer7 = new Account_Mapping_Customer__c();
        accMappingCustomer7.Hansa_Picklist_Value__c = '3';
        accMappingCustomer7.Salesforce_Field__c = 'vat_zone__c';
        accMappingCustomer7.Salesforce_Picklist_Value__c = 'Inside EU';
        accMappingCustomer7.name = 'test8';
        insert accMappingCustomer7;
        
        Account_Mapping_Customer__c accMappingCustomer8 = new Account_Mapping_Customer__c();
        accMappingCustomer8.Hansa_Picklist_Value__c = '3';
        accMappingCustomer8.Salesforce_Field__c = 'incoterms_shipping_terms__c';
        accMappingCustomer8.Salesforce_Picklist_Value__c = 'Ex Works (EXW)';
        accMappingCustomer8.name = 'test9';
        insert accMappingCustomer8;
        
        Account_Mapping_Customer__c accMappingCustomer9 = new Account_Mapping_Customer__c();
        accMappingCustomer9.Hansa_Picklist_Value__c = '3';
        accMappingCustomer9.Salesforce_Field__c = 'payment_terms__c';
        accMappingCustomer9.Salesforce_Picklist_Value__c = '15 Days EOM';
        accMappingCustomer9.name = 'test10';
        insert accMappingCustomer9;
        
        List<Account> accList = new List<Account>();
        for(Account acc : [select id from account where name = 'Test Customer Account']){
            acc.type = 'Certified';
            acc.name = 'test acc update';
            acc.Ceetak_Location__c = 'ABE';
            acc.Language__c = 'CONFLOW LTD';
            acc.Account_Status__c = 'Closed';
            acc.Sales_Area__c = '2';
            acc.Customer_Category__c = 'A';
            acc.EDI_Customer__c = 'No';
            acc.VAT_Zone__c = 'Inside EU';
            acc.VAT_Code__c = '5% Rate';
            acc.Incoterms_Shipping_Terms__c = 'Free Carrier (FCA)';
            acc.Payment_Terms__c = '15 Days EOM';
            acc.Website = 'www.test.com';
            acc.phone = '12344';
            acc.Email__c = 'test1@gmail.com';
            acc.Shipping_Instructions__c = 'test123';
            acc.Customer_VAT_No__c = '11';
            acc.Credit_Limit__c = 12;
            acc.BillingCity = 'Small Town';
            acc.BillingCountry = 'United States';
            acc.BillingPostalCode = 'HG11 6YT';
            acc.BillingState = 'Connecticut';
            acc.BillingStreet = '52 Never Ending Road 62 \n Never Ending 72 \nNever Ending';
            acc.shippingCity = 'Small Town';
            acc.shippingCountry = 'United Kingdom';
            acc.shippingPostalCode = 'HG11 6YTR';
            acc.shippingState = 'Bristol';
            acc.CurrencyIsoCode = 'GBP';
            acc.shippingStreet = '50 Never Ending Road 60 \n Never Ending 70 \nNever Ending';
            acc.Same_as_Billing_Address__c = false;
            acc.Hansa_Account_Number__c = '12';
            accList.add(acc);
        }
        RunOnce.accountTrigger = true;
        update accList;
        
    }
    
    @isTest
    public static void supplierAccountSameasBillingAddress(){
        
        Test.setMock(HttpCalloutMock.class, new AccountTriggerHandlerMockCallout());
        // Test.setMock(HttpCalloutMock.class, new GenerateHansaAccessTokenMockCallout());
        Hansa_ERP__c erp = new Hansa_ERP__c();
        erp.name = 'Refresh Token';
        erp.Client_Identification__c = '18B30509-DD3026C9-C1FA6558-E230A9AD-F6A9B9DF';
        erp.Client_Secret__c = '9e570ca990099d39c9fa859b2c8ea8b3';
        erp.Authorization_URI__c = 'https://standard-id.hansaworld.com/oauth-authorize';
        erp.Access_Token_URI__c = 'https://standard-id.hansaworld.com/oauth-token';
        erp.Redirect_URI__c = 'https://test.salesforce.com/apex/HansaAuthoriza...';
        erp.Customer_Supplier_End_Point_URL__c = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/CUVc?';
        erp.Turn_of_Account_Sync__c = false;
        erp.Alternate_Address_End_Point__c = 'testAddress';
        insert erp;
        
        Account_Mapping_Customer__c accMappingCustomer5 = new Account_Mapping_Customer__c();
        accMappingCustomer5.Hansa_Picklist_Value__c = '3';
        accMappingCustomer5.Salesforce_Field__c = 'currencyisocode';
        accMappingCustomer5.Salesforce_Picklist_Value__c = 'GBP';
        accMappingCustomer5.name = 'test6';
        insert accMappingCustomer5;
        
        Account_Mapping_Customer__c accMappingCustomer6 = new Account_Mapping_Customer__c();
        accMappingCustomer6.Hansa_Picklist_Value__c = '3';
        accMappingCustomer6.Salesforce_Field__c = 'vat_code__c';
        accMappingCustomer6.Salesforce_Picklist_Value__c = '5% Rate';
        accMappingCustomer6.name = 'test7';
        insert accMappingCustomer6;
        
        Account_Mapping_Customer__c accMappingCustomer7 = new Account_Mapping_Customer__c();
        accMappingCustomer7.Hansa_Picklist_Value__c = '3';
        accMappingCustomer7.Salesforce_Field__c = 'vat_zone__c';
        accMappingCustomer7.Salesforce_Picklist_Value__c = 'Inside EU';
        accMappingCustomer7.name = 'test8';
        insert accMappingCustomer7;
        
        Account_Mapping_Customer__c accMappingCustomer8 = new Account_Mapping_Customer__c();
        accMappingCustomer8.Hansa_Picklist_Value__c = '3';
        accMappingCustomer8.Salesforce_Field__c = 'incoterms_shipping_terms__c';
        accMappingCustomer8.Salesforce_Picklist_Value__c = 'Free Carrier (FCA)';
        accMappingCustomer8.name = 'test9';
        insert accMappingCustomer8;
        
        Account_Mapping_Customer__c accMappingCustomer9 = new Account_Mapping_Customer__c();
        accMappingCustomer9.Hansa_Picklist_Value__c = '3';
        accMappingCustomer9.Salesforce_Field__c = 'payment_terms__c';
        accMappingCustomer9.Salesforce_Picklist_Value__c = '15 Days EOM';
        accMappingCustomer9.name = 'test10';
        insert accMappingCustomer9;
        
        List<Account> accList = new List<Account>();
        for(Account acc : [select id from account where name = 'Test Supplier Account']){
            acc.Supplier_Account_Type__c = 'Approved';
            acc.name = 'udpate acc name';
            acc.VAT_Zone__c = 'Inside EU';
            acc.VAT_Code__c = '5% Rate';
            acc.Incoterms_Shipping_Terms__c = 'Free Carrier (FCA)';
            acc.Payment_Terms__c = '15 Days EOM';
            acc.Website = 'www.test.com';
            acc.phone = '12344';
            acc.Email__c = 'test1@gmail.com';
            acc.CurrencyIsoCode = 'GBP';
            acc.Bank_Account_No__c = '123456';
            acc.Bank_Sort_Code__c = '12311';
            acc.BillingCountry = 'United Kingdom';
            acc.BillingCity = 'small town';
            acc.BillingState = 'Bristol';
            acc.BillingStreet = '54 Never Ending Road 46 \n Never Ending 74 \nNever Ending';
            acc.BillingPostalCode = '1234';
            acc.shippingCity = 'Small Town';
            acc.shippingCountry = 'United Kingdom';
            acc.shippingPostalCode = 'HG11 6YTR';
            acc.shippingState = 'Bristol';
            acc.shippingStreet = '55 Never Ending Road 66 \n Never Ending 77 \nNever Ending';
            acc.Same_as_Billing_Address__c = false;
            acc.Hansa_Supplier_Number__c = '23';
            accList.add(acc);
        }
        RunOnce.accountTrigger = true;
        update accList;
    }
    
    @isTest
    public static void customerAccountWithoutHansaAccountNumber(){
        Test.setMock(HttpCalloutMock.class, new AccountTriggerHandlerMockCallout());
        
        Hansa_ERP__c erp = new Hansa_ERP__c();
        erp.name = 'Refresh Token';
        erp.Client_Identification__c = '18B30509-DD3026C9-C1FA6558-E230A9AD-F6A9B9DF';
        erp.Client_Secret__c = '9e570ca990099d39c9fa859b2c8ea8b3';
        erp.Authorization_URI__c = 'https://standard-id.hansaworld.com/oauth-authorize';
        erp.Access_Token_URI__c = 'https://standard-id.hansaworld.com/oauth-token';
        erp.Redirect_URI__c = 'https://test.salesforce.com/apex/HansaAuthoriza...';
        erp.Customer_Supplier_End_Point_URL__c = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/CUVc?';
        erp.Turn_of_Account_Sync__c = false;
        erp.Alternate_Address_End_Point__c = 'testAddress';
        insert erp;
        
        Account_Mapping_Customer__c accMappingCustomer = new Account_Mapping_Customer__c();
        accMappingCustomer.Hansa_Picklist_Value__c = '1';
        accMappingCustomer.Salesforce_Field__c = 'ceetak_location__c';
        accMappingCustomer.Salesforce_Picklist_Value__c = 'ABE';
        accMappingCustomer.name = 'test3';
        insert accMappingCustomer;
        
        Account_Mapping_Customer__c accMappingCustomer1 = new Account_Mapping_Customer__c();
        accMappingCustomer1.Hansa_Picklist_Value__c = '2';
        accMappingCustomer1.Salesforce_Field__c = 'Language__c';
        accMappingCustomer1.Salesforce_Picklist_Value__c = 'CONFLOW LTD';
        accMappingCustomer1.name = 'test2';
        insert accMappingCustomer1;
        
        Account_Mapping_Customer__c accMappingCustomer2 = new Account_Mapping_Customer__c();
        accMappingCustomer2.Hansa_Picklist_Value__c = '3';
        accMappingCustomer2.Salesforce_Field__c = 'Sales_Area__c';
        accMappingCustomer2.Salesforce_Picklist_Value__c = '2';
        accMappingCustomer2.name = 'test1';
        insert accMappingCustomer2;
        
        Account_Mapping_Customer__c accMappingCustomer3 = new Account_Mapping_Customer__c();
        accMappingCustomer3.Hansa_Picklist_Value__c = '3';
        accMappingCustomer3.Salesforce_Field__c = 'Customer_Category__c';
        accMappingCustomer3.Salesforce_Picklist_Value__c = 'A';
        accMappingCustomer3.name = 'test4';
        insert accMappingCustomer3;
        
        Account_Mapping_Customer__c accMappingCustomer4 = new Account_Mapping_Customer__c();
        accMappingCustomer4.Hansa_Picklist_Value__c = '3';
        accMappingCustomer4.Salesforce_Field__c = 'EDI_Customer__c';
        accMappingCustomer4.Salesforce_Picklist_Value__c = 'No';
        accMappingCustomer4.name = 'test5';
        insert accMappingCustomer4;
        
        Account_Mapping_Customer__c accMappingCustomer5 = new Account_Mapping_Customer__c();
        accMappingCustomer5.Hansa_Picklist_Value__c = '3';
        accMappingCustomer5.Salesforce_Field__c = 'currencyisocode';
        accMappingCustomer5.Salesforce_Picklist_Value__c = 'GBP';
        accMappingCustomer5.name = 'test6';
        insert accMappingCustomer5;
        
        Account_Mapping_Customer__c accMappingCustomer6 = new Account_Mapping_Customer__c();
        accMappingCustomer6.Hansa_Picklist_Value__c = '3';
        accMappingCustomer6.Salesforce_Field__c = 'vat_code__c';
        accMappingCustomer6.Salesforce_Picklist_Value__c = '5% Rate';
        accMappingCustomer6.name = 'test7';
        insert accMappingCustomer6;
        
        Account_Mapping_Customer__c accMappingCustomer7 = new Account_Mapping_Customer__c();
        accMappingCustomer7.Hansa_Picklist_Value__c = '3';
        accMappingCustomer7.Salesforce_Field__c = 'vat_zone__c';
        accMappingCustomer7.Salesforce_Picklist_Value__c = 'Inside EU';
        accMappingCustomer7.name = 'test8';
        insert accMappingCustomer7;
        
        Account_Mapping_Customer__c accMappingCustomer8 = new Account_Mapping_Customer__c();
        accMappingCustomer8.Hansa_Picklist_Value__c = '3';
        accMappingCustomer8.Salesforce_Field__c = 'incoterms_shipping_terms__c';
        accMappingCustomer8.Salesforce_Picklist_Value__c = 'Ex Works (EXW)';
        accMappingCustomer8.name = 'test9';
        insert accMappingCustomer8;
        
        Account_Mapping_Customer__c accMappingCustomer9 = new Account_Mapping_Customer__c();
        accMappingCustomer9.Hansa_Picklist_Value__c = '3';
        accMappingCustomer9.Salesforce_Field__c = 'payment_terms__c';
        accMappingCustomer9.Salesforce_Picklist_Value__c = '15 Days EOM';
        accMappingCustomer9.name = 'test10';
        insert accMappingCustomer9;

        Account_Mapping_Customer__c accMappingCustomerOrderClass = new Account_Mapping_Customer__c();
        accMappingCustomerOrderClass.Hansa_Picklist_Value__c = 'SCALL';
        accMappingCustomerOrderClass.Salesforce_Field__c = 'order_class__c';
        accMappingCustomerOrderClass.Salesforce_Picklist_Value__c = 'SCALL';
        accMappingCustomerOrderClass.name = 'test11';
        insert accMappingCustomerOrderClass;

        Account_Mapping_Customer__c accMappingCustomerOrderClass1 = new Account_Mapping_Customer__c();
        accMappingCustomerOrderClass1.Hansa_Picklist_Value__c = 'PROJ';
        accMappingCustomerOrderClass1.Salesforce_Field__c = 'order_class__c';
        accMappingCustomerOrderClass1.Salesforce_Picklist_Value__c = 'PROJ';
        accMappingCustomerOrderClass1.name = 'test12';
        insert accMappingCustomerOrderClass1;
        
        List<Account> accList = new List<Account>();
        for(Account acc : [select id from account where name = 'Test Customer Account']){
            acc.type = 'Certified';
            acc.name = 'test acc update';
            acc.Ceetak_Location__c = 'ABE';
            acc.Language__c = 'CONFLOW LTD';
            acc.Account_Status__c = 'Closed';
            acc.Sales_Area__c = '2';
            acc.Customer_Category__c = 'A';
            acc.EDI_Customer__c = 'No';
            acc.VAT_Zone__c = 'Inside EU';
            acc.VAT_Code__c = '5% Rate';
            acc.Incoterms_Shipping_Terms__c = 'Free Carrier (FCA)';
            acc.Payment_Terms__c = '15 Days EOM';
            acc.Website = 'www.test.com';
            acc.phone = '12344';
            acc.Email__c = 'test1@gmail.com';
            acc.Shipping_Instructions__c = 'test123';
            acc.Customer_VAT_No__c = '11';
            acc.Credit_Limit__c = 12;
            acc.CurrencyIsoCode = 'GBP';
            acc.BillingCity = 'Small Town';
            acc.BillingCountry = 'United States';
            acc.BillingPostalCode = 'HG11 6YT';
            acc.BillingState = 'Connecticut';
            acc.BillingStreet = '52 Never Ending Road 62 \n Never Ending 72 \nNever Ending';
            acc.shippingCity = 'Small Town';
            acc.shippingCountry = 'United Kingdom';
            acc.shippingPostalCode = 'HG11 6YTR';
            acc.shippingState = 'Bristol';
            acc.shippingStreet = '50 Never Ending Road 60 \n Never Ending 70 \nNever Ending';
            acc.Same_as_Billing_Address__c = false;
            acc.Warning_Quotation_Order__c = 'Test';
            acc.order_class__c = 'SCALL' ;
            accList.add(acc);
        }
        RunOnce.accountTrigger = true;
        update accList;
        
    }
    
    @isTest
    public static void supplierAccountWithOutHansaSupplierNumber(){
        
        Test.setMock(HttpCalloutMock.class, new AccountTriggerHandlerMockCallout());
        // Test.setMock(HttpCalloutMock.class, new GenerateHansaAccessTokenMockCallout());
        Hansa_ERP__c erp = new Hansa_ERP__c();
        erp.name = 'Refresh Token';
        erp.Client_Identification__c = '18B30509-DD3026C9-C1FA6558-E230A9AD-F6A9B9DF';
        erp.Client_Secret__c = '9e570ca990099d39c9fa859b2c8ea8b3';
        erp.Authorization_URI__c = 'https://standard-id.hansaworld.com/oauth-authorize';
        erp.Access_Token_URI__c = 'https://standard-id.hansaworld.com/oauth-token';
        erp.Redirect_URI__c = 'https://test.salesforce.com/apex/HansaAuthoriza...';
        erp.Customer_Supplier_End_Point_URL__c = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/CUVc?';
        erp.Turn_of_Account_Sync__c = false;
        erp.Alternate_Address_End_Point__c = 'testAddress';
        insert erp;
        
        Account_Mapping_Customer__c accMappingCustomer5 = new Account_Mapping_Customer__c();
        accMappingCustomer5.Hansa_Picklist_Value__c = '3';
        accMappingCustomer5.Salesforce_Field__c = 'currencyisocode';
        accMappingCustomer5.Salesforce_Picklist_Value__c = 'GBP';
        accMappingCustomer5.name = 'test6';
        insert accMappingCustomer5;
        
        Account_Mapping_Customer__c accMappingCustomer6 = new Account_Mapping_Customer__c();
        accMappingCustomer6.Hansa_Picklist_Value__c = '3';
        accMappingCustomer6.Salesforce_Field__c = 'vat_code__c';
        accMappingCustomer6.Salesforce_Picklist_Value__c = '5% Rate';
        accMappingCustomer6.name = 'test7';
        insert accMappingCustomer6;
        
        Account_Mapping_Customer__c accMappingCustomer7 = new Account_Mapping_Customer__c();
        accMappingCustomer7.Hansa_Picklist_Value__c = '3';
        accMappingCustomer7.Salesforce_Field__c = 'vat_zone__c';
        accMappingCustomer7.Salesforce_Picklist_Value__c = 'Inside EU';
        accMappingCustomer7.name = 'test8';
        insert accMappingCustomer7;
        
        Account_Mapping_Customer__c accMappingCustomer8 = new Account_Mapping_Customer__c();
        accMappingCustomer8.Hansa_Picklist_Value__c = '3';
        accMappingCustomer8.Salesforce_Field__c = 'incoterms_shipping_terms__c';
        accMappingCustomer8.Salesforce_Picklist_Value__c = 'Free Carrier (FCA)';
        accMappingCustomer8.name = 'test9';
        insert accMappingCustomer8;
        
        Account_Mapping_Customer__c accMappingCustomer9 = new Account_Mapping_Customer__c();
        accMappingCustomer9.Hansa_Picklist_Value__c = '3';
        accMappingCustomer9.Salesforce_Field__c = 'payment_terms__c';
        accMappingCustomer9.Salesforce_Picklist_Value__c = '15 Days EOM';
        accMappingCustomer9.name = 'test10';
        insert accMappingCustomer9;
        
        List<Account> accList = new List<Account>();
        for(Account acc : [select id from account where name = 'Test Supplier Account']){
            acc.Supplier_Account_Type__c = 'Approved';
            acc.name = 'udpate acc name';
            acc.VAT_Zone__c = 'Inside EU';
            acc.VAT_Code__c = '5% Rate';
            acc.Incoterms_Shipping_Terms__c = 'Free Carrier (FCA)';
            acc.Payment_Terms__c = '15 Days EOM';
            acc.Website = 'www.test.com';
            acc.phone = '12344';
            acc.Email__c = 'test1@gmail.com';
            acc.Bank_Account_No__c = '123456';
            acc.Bank_Sort_Code__c = '12311';
            acc.BillingCountry = 'United Kingdom';
            acc.BillingCity = 'small town';
            acc.BillingState = 'Bristol';
            acc.BillingStreet = '54 Never Ending Road 46 \n Never Ending 74 \nNever Ending';
            acc.BillingPostalCode = '1234';
            acc.shippingCity = 'Small Town';
            acc.shippingCountry = 'United Kingdom';
            acc.shippingPostalCode = 'HG11 6YTR';
            acc.shippingState = 'Bristol';
            acc.CurrencyIsoCode = 'GBP';
            acc.shippingStreet = '55 Never Ending Road 66 \n Never Ending 77 \nNever Ending';
            acc.Same_as_Billing_Address__c = false;
            accList.add(acc);
        }
        RunOnce.accountTrigger = true;
        update accList;
    }
}