@isTest
public class AlternateShippingTriggerHandler_Test {
    @testSetup static  void insertAlternateShipping(){
        Test.setMock(HttpCalloutMock.class, new AlternateShippingTriggerHandler_Mock());
        Hansa_ERP__c erp = new Hansa_ERP__c();
        erp.name = 'Refresh Token';
        erp.Client_Identification__c = '18B30509-DD3026C9-C1FA6558-E230A9AD-F6A9B9DF';
        erp.Client_Secret__c = '9e570ca990099d39c9fa859b2c8ea8b3';
        erp.Authorization_URI__c = 'https://standard-id.hansaworld.com/oauth-authorize';
        erp.Access_Token_URI__c = 'https://standard-id.hansaworld.com/oauth-token';
        erp.Redirect_URI__c = 'https://test.salesforce.com/apex/HansaAuthoriza...';
        erp.Customer_Supplier_End_Point_URL__c = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/CUVc?';
        erp.Turn_of_Account_Sync__c = true;
        erp.Alternate_Address_End_Point__c = 'testAddress';
        insert erp; 
        
        Account supplierAccount = new Account();
        supplierAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
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
        supplierAccount.type = 'Certified';
        supplierAccount.EDI_Customer__c = 'No';
        supplierAccount.Logistics_Account__c = 'No';
        supplierAccount.Productivity_Account__c = 'No';
        supplierAccount.Target_Account__c = 'No';
        supplierAccount.Prefferred_Supplier_Status__c = 'No';
        supplierAccount.Hansa_Account_Number__c = '123';
        insert supplierAccount;
        
        
        
        Alternate_Shipping_Delivery_Address__c alternateShipping = new Alternate_Shipping_Delivery_Address__c();
        alternateShipping.Account__c = supplierAccount.id;
        alternateShipping.Name = 'test';
        insert alternateShipping;
        
        
        RunOnce.alternateAddressTrigger = true;
        alternateShipping.Name = 'test update';
        alternateShipping.Code__c = 'test code';
        alternateShipping.shipping_street_address_line_1__c = 'test';
        alternateShipping.shipping_street_address_line_2__c = 'test';
        alternateShipping.shipping_street_address_line_3__c = 'test';
        alternateShipping.shipping_city__c = 'test';
        alternateShipping.shipping_zip_post_code__c = 'test';
        alternateShipping.shipping_state_county__c = 'test';
        alternateShipping.Shipping_Country_Name__c = 'Albania';
        alternateShipping.Created_In_Hansa__c = true;
        alternateShipping.Code__c = '123';
        alternateShipping.Contact_name__c = 'Test Contact';
        alternateShipping.Contact_phone__c = '1212';
        alternateShipping.VAT_Zone__c= 'Domestic';

        update alternateShipping;
        
    }
    @isTest
    public static void updateAlternateShipping(){
        for(Alternate_Shipping_Delivery_Address__c alternateShipping : [select id from Alternate_Shipping_Delivery_Address__c where name ='test update']){
            alternateShipping.Created_In_Hansa__c = false; 
            alternateShipping.name = null;
            RunOnce.alternateAddressTrigger = true;
            update alternateShipping;
        }
    }
    
    @isTest
    public static void updateAlternateShippingTrue(){
        for(Alternate_Shipping_Delivery_Address__c alternateShipping : [select id from Alternate_Shipping_Delivery_Address__c where name ='test update']){
            alternateShipping.Created_In_Hansa__c = true; 
            alternateShipping.name = null;
            alternateShipping.shipping_street_address_line_1__c = null;
            alternateShipping.shipping_street_address_line_2__c = null;
            alternateShipping.shipping_street_address_line_3__c = null;
            alternateShipping.shipping_city__c = null;
            alternateShipping.shipping_zip_post_code__c = null;
            alternateShipping.shipping_state_county__c = null;
            alternateShipping.Shipping_Country_Name__c = null;
            RunOnce.alternateAddressTrigger = true;
            update alternateShipping;
        }
    }
}