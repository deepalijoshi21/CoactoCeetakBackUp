/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test Class for SyncToHansaController
* ───────────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-04-09
* @modified       2020-04-13
* ─────────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
public class SyncToHansaControllerTest {
    
    @isTest
    public static void customerAccount(){
        SyncToHansaController syncToHansa = new SyncToHansaController();
        Account acc = new Account();
        acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        acc.type = 'Prospect';
        acc.name = 'test account';
        acc.Phone = '1920';
        acc.Secondary_Internal_Sales__c = userinfo.getuserid();
        acc.AccountSource = 'Area Sales Manager';
        acc.LFY_Actual_Sales__c = 10;
        acc.BillingCity = 'Small Town';
        acc.BillingCountry = 'United States';
        acc.BillingPostalCode = 'HG11 6YT';
        acc.BillingState = 'Connecticut';
        acc.BillingStreet = '5 Never Ending Road';
        acc.Primary_Internal_Sales__c = userinfo.getuserid();
        acc.Ceetak_Location__c = 'BED';
        acc.Customer_Type__c = 'OEM';
        acc.Key_Engineer__c = userinfo.getuserid();
        acc.Minimum_Line_Value__c = 12;
        acc.Minimum_Order_Value__c = 12;
        acc.Primary_Industry_Sector__c = 'Automotive';
        acc.Sales_Area__c = '1';
        acc.Account_Status__c = 'Open';
        acc.Actual_YTD__c = 10;
        acc.Industry_Sector_s__c = 'Automotive';
        acc.Credit_Balance__c = 10;
        acc.Credit_Limit__c = 10;
        acc.Customer_Category__c = 'A+';
        //acc.Forecast__c = 10;
        acc.FY_Forecast__c = 10;
        acc.Open_Order_Value__c = 10;
        acc.VAT_Code__c = 'Exempt';
        acc.Payment_Terms__c = '7 Days EOM';
        acc.Supplier_Type__c = 'Seals';
        acc.Key_Products__c = 'Gaskets';
        acc.VAT_Zone__c = 'Domestic';
        acc.Sales_Area__c = '1';
        acc.Language__c = 'KAWASAKI';
        acc.Customer_VAT_No__c = 'test';
        acc.Customer_Category__c = 'A+';
        acc.Shipping_Instructions__c = 'test';
        acc.Email__c = 'test@gmail.com';
        acc.Website = 'www.test.com';
        acc.Incoterms_Shipping_Terms__c = 'Ex Works (EXW)';
        acc.EDI_Customer__c = 'Yes';
        acc.Hansa_Account_Number__c = '123';
        insert acc;
       SyncToHansaController.checkConditions(acc.id); 
        SyncToHansaController.syncToHansa(acc.id);
    }
    
    @isTest
    public static void supplierAccount(){
        Account acc = new Account();
        acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        acc.type = 'Prospect';
        acc.name = 'test account';
        acc.Phone = '1920';
        acc.Secondary_Internal_Sales__c = userinfo.getuserid();
        acc.AccountSource = 'Area Sales Manager';
        acc.LFY_Actual_Sales__c = 10;
        acc.BillingCity = 'Small Town';
        acc.BillingCountry = 'United States';
        acc.BillingPostalCode = 'HG11 6YT';
        acc.BillingState = 'Connecticut';
        acc.BillingStreet = '5 Never Ending Road';
        acc.Primary_Internal_Sales__c = userinfo.getuserid();
        acc.Ceetak_Location__c = 'BED';
        acc.Customer_Type__c = 'OEM';
        acc.Key_Engineer__c = userinfo.getuserid();
        acc.Minimum_Line_Value__c = 12;
        acc.Minimum_Order_Value__c = 12;
        acc.Primary_Industry_Sector__c = 'Automotive';
        acc.Sales_Area__c = '1';
        acc.Account_Status__c = 'Open';
        acc.Actual_YTD__c = 10;
        acc.Industry_Sector_s__c = 'Automotive';
        acc.Credit_Balance__c = 10;
        acc.Credit_Limit__c = 10;
        acc.Customer_Category__c = 'A+';
        //acc.Forecast__c = 10;
        acc.FY_Forecast__c = 10;
        acc.Open_Order_Value__c = 10;
        acc.VAT_Code__c = 'Exempt';
        acc.Payment_Terms__c = '7 Days EOM';
        acc.Supplier_Type__c = 'Seals';
        acc.Key_Products__c = 'Gaskets';
        acc.VAT_Zone__c = 'Domestic';
        acc.Sales_Area__c = '1';
        acc.Language__c = 'KAWASAKI';
        acc.Customer_VAT_No__c = 'test';
        acc.Customer_Category__c = 'A+';
        acc.Shipping_Instructions__c = 'test';
        acc.Email__c = 'test@gmail.com';
        acc.Website = 'www.test.com';
        acc.Incoterms_Shipping_Terms__c = 'Ex Works (EXW)';
        acc.EDI_Customer__c = 'Yes';
        acc.Logistics_Account__c = 'Yes';
        acc.Productivity_Account__c = 'Yes';
        acc.Target_Account__c = 'Yes';
        acc.Hansa_Account_Number__c = '123';
        acc.Hansa_Supplier_Number__c = '12';
        insert acc;
       SyncToHansaController.checkConditions(acc.id); 
        SyncToHansaController.syncToHansa(acc.id);
    }
}