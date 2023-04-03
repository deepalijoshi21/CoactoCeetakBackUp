@istest
public class Hansa_ClassificationSync_BatchHelperTest {

    @isTest
    public static void TestMethod1(){
        
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
        //acc.RecordType.Name = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getDeveloperName();
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
        
         
        Account_Mapping_Customer__c c=new Account_Mapping_Customer__c();
        c.Name='Test1';
        c.Hansa_Picklist_Value__c='BED' ;
        c.Salesforce_Picklist_Value__c='BED';
        c.Salesforce_Field__c='ceetak_Location__c';
        insert c;
        
        Account_Mapping_Customer__c c1=new Account_Mapping_Customer__c();
        c1.Name='Test2';
        c1.Hansa_Picklist_Value__c='D';
        c1.Salesforce_Picklist_Value__c='D';
        c1.Salesforce_Field__c='Ceetak_Location__c';
        insert c1;
        
        Account_Mapping_Supplier__c s=new Account_Mapping_Supplier__c();
        s.Name='Test1';
        s.Hansa_Picklist_Value__c='BED' ;
        s.Salesforce_Picklist_Value__c='BED';
        s.Salesforce_Field__c='ceetak_Location__c';
        insert s;
            
        Account_Mapping_Supplier__c s1=new Account_Mapping_Supplier__c();
        s1.Name='Test2';
        s1.Hansa_Picklist_Value__c='D';
        s1.Salesforce_Picklist_Value__c='D';
        s1.Salesforce_Field__c='Ceetak_Location__c';
        insert s1;       
               
        Test.startTest();
        Hansa_ClassificationSync_Batch hcb = new Hansa_ClassificationSync_Batch();
        Id batchId = Database.executeBatch(hcb);
        Test.stopTest();        
}
    
       @isTest
    public static void TestMethod2(){
        
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
        //Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getDeveloperName();
        acc.Supplier_Account_Type__c = 'Potential';
        acc.name = 'test account1';
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
                    
        Test.startTest();
        Hansa_ClassificationSync_Batch hcb = new Hansa_ClassificationSync_Batch(acc.Id);
        Id batchId = Database.executeBatch(hcb);
        Test.stopTest();        
}
    @istest
    public static void postToHansaUpdateTest(){  
        
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
        //acc.RecordType.Name = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getDeveloperName();
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
        
         
        Account_Mapping_Customer__c c=new Account_Mapping_Customer__c();
        c.Name='Test1';
        c.Hansa_Picklist_Value__c='BED' ;
        c.Salesforce_Picklist_Value__c='BED';
        c.Salesforce_Field__c='ceetak_Location__c';
        insert c;
        
        Account_Mapping_Customer__c c1=new Account_Mapping_Customer__c();
        c1.Name='Test2';
        c1.Hansa_Picklist_Value__c='D';
        c1.Salesforce_Picklist_Value__c='D';
        c1.Salesforce_Field__c='Ceetak_Location__c';
        insert c1;
        
        Account_Mapping_Supplier__c s=new Account_Mapping_Supplier__c();
        s.Name='Test1';
        s.Hansa_Picklist_Value__c='BED' ;
        s.Salesforce_Picklist_Value__c='BED';
        s.Salesforce_Field__c='ceetak_Location__c';
        insert s;
            
        Account_Mapping_Supplier__c s1=new Account_Mapping_Supplier__c();
        s1.Name='Test2';
        s1.Hansa_Picklist_Value__c='D';
        s1.Salesforce_Picklist_Value__c='D';
        s1.Salesforce_Field__c='Ceetak_Location__c';
        insert s1;       
               
             
        Test.setMock(HttpCalloutMock.class, new Hansa_ClassificationSync_BatchMock());
         Hansa_ERP__c erp = new Hansa_ERP__c();
        erp.name = 'Refresh Token';
        erp.Client_Identification__c = '18B30509-DD3026C9-C1FA6558-E230A9AD-F6A9B9DF';
        erp.Client_Secret__c = '9e570ca990099d39c9fa859b2c8ea8b3';
        erp.Authorization_URI__c = 'https://standard-id.hansaworld.com/oauth-authorize';
        erp.Access_Token_URI__c = 'https://standard-id.hansaworld.com/oauth-token';
        erp.Redirect_URI__c = 'https://test.salesforce.com/apex/HansaAuthoriza...';
        erp.Customer_Supplier_End_Point_URL__c = 'https://erp-sync.herokuapp.com/getData';
        erp.Turn_of_Account_Sync__c = false;
        erp.Alternate_Address_End_Point__c = 'testAddress';
        insert erp;
            
           
        Account_Mapping_Customer__c accMappingCustomer = new Account_Mapping_Customer__c();
        accMappingCustomer.Hansa_Picklist_Value__c = '1';
        accMappingCustomer.Salesforce_Field__c = 'Account_Mapping_Customer__c';
        accMappingCustomer.Salesforce_Picklist_Value__c = 'ABE';
        accMappingCustomer.name = 'test3';
        insert accMappingCustomer;
        
        Account_Mapping_Customer__c accMappingCustomer1 = new Account_Mapping_Customer__c();
        accMappingCustomer1.Hansa_Picklist_Value__c = '2';
        accMappingCustomer1.Salesforce_Field__c = 'account_Mapping_Customer__c';
        accMappingCustomer1.Salesforce_Picklist_Value__c = 'CONFLOW LTD';
        accMappingCustomer1.name = 'test2';
        insert accMappingCustomer1;
        
        Account_Mapping_Customer__c accMappingCustomer2 = new Account_Mapping_Customer__c();
        accMappingCustomer2.Hansa_Picklist_Value__c = '3';
        accMappingCustomer2.Salesforce_Field__c = 'Account_Mapping_Customer__c';
        accMappingCustomer2.Salesforce_Picklist_Value__c = '2';
        accMappingCustomer2.name = 'test1';
        insert accMappingCustomer2;
        
        Account_Mapping_Customer__c accMappingCustomer3 = new Account_Mapping_Customer__c();
        accMappingCustomer3.Hansa_Picklist_Value__c = '3';
        accMappingCustomer3.Salesforce_Field__c = 'Account_Mapping_Customer__c';
        accMappingCustomer3.Salesforce_Picklist_Value__c = 'A';
        accMappingCustomer3.name = 'test4';
        insert accMappingCustomer3;
           
        Test.startTest();
        Hansa_ClassificationSync_Batch hcb = new Hansa_ClassificationSync_Batch();
        Id batchId = Database.executeBatch(hcb);
        Test.stopTest();   
   
    }

    
    
}