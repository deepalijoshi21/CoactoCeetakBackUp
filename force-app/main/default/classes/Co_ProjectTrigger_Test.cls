@isTest
public class Co_ProjectTrigger_Test {
    
    @TestSetup
    public static void testSetup(){
        
        Test.setMock(HttpCalloutMock.class, new Calloutmock()); 
        
        List<Hansa_ERP__c> customlist =New list<Hansa_ERP__c>();
        
        Hansa_ERP__c customsetting =New Hansa_ERP__c();
        customsetting.Name='Refresh Token';
        customsetting.Turn_of_Product_Sync__c=False;
        customsetting.Product_End_Point_URL__c='www.abc.com';
        customsetting.Access_Token_URI__c='www.jockey.com';
        customsetting.Alternate_Address_End_Point__c='www.sudan.com';
        customsetting.Authorization_URI__c='www.ringkey.com';
        customsetting.Client_Identification__c='mighty';
        customsetting.Client_Secret__c='fabplesi';
        customsetting.Customer_Supplier_End_Point_URL__c='david';
        customsetting.Redirect_URI__c='www.google.com';
        customsetting.Refresh_Token__c='mcafee';
        customsetting.Turn_of_Account_Sync__c=True;
      
        customlist.add(customsetting);
        INSERT customlist;
        
        
        Account acc = new Account();
        acc.Name = 'test Acc';
        acc.Type ='New';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        
        
        insert acc;
        System.debug('<<<<<Account Inserted>>>>');
        
        Product2 rec = new Product2();
        rec.Name ='test record';
        rec.ProductCode = 'testProd';
        rec.Product_Description__c = 'testProd';
        rec.Product_Classification__c = 'Assembly';
        rec.Product_Type__c = 'Structured Item';
        rec.Product_Status__c = 'Quote Only';
        rec.EDI__c = 'Yes';
        rec.EDI_Classification__c='SCHED';
        rec.Default_Product_Supplier__c	 =acc.Id;
        rec.Product_Group__c = 'Adver';
        rec.Product_Status__c ='Approved';
        rec.Ceetak_Drawing_No__c='accurate';
        rec.Ceetak_Drawing_Rev__c='newldadd';
        rec.Ceetak_Material_Code__c='amazed';
        rec.Material_Type__c='rekon';
        rec.Weight_grams__c=40;
        rec.Prevent_Save__c=False;
        rec.Kit__c = 'No';
        insert rec;
        
        System.debug('<<<<<Product Inserted>>>>');
        
        Hansa_SF_product_Mapping__c csRec = new Hansa_SF_product_Mapping__c();
        csRec.Salesforce_Field__c ='Product_Status__c';
        csRec.Name = 'test';
        insert csRec;
        
        test.startTest();
        RunOnce.productTrigger = true;
        rec.Product_Type__c = 'Approved';
        rec.Weight_grams__c=null;
        
        Co_ProductTriggerHandler.getProductCustomSettingRecords('Hansa_SF_product_Mapping__c');
        test.stopTest();
    }
    
    @isTest
    public static void test(){
        set<id> PrdIdSet = new set<id>();
        Product2 res =[select id,name ,Product_Group__c from Product2 where name='test record'];
        res.Product_Group__c='AERUB';
        res.Ghost_Product_created_on_Hansa__c=True;
        res.Inspection_Code__c='VI';
        res.Kit__c = 'Yes';
        UPDATE res;
        PrdIdSet.add(res.Id);
        
        List<Hansa_ERP__c> customlist =New list<Hansa_ERP__c>();
        
        Hansa_ERP__c customsetting=[select id,name from Hansa_ERP__c where name='Refresh Token'];
        customsetting.Refresh_Token__c='avast';
        customlist.add(customsetting);
        
        UPDATE customlist;
        
        RunOnce.productTrigger = false;
        RunOnce.accountTrigger = false;
        RunOnce.allowFurure_ProdKitLine = True;
        Set<ID> prodset =New set<ID>();
        Co_ProductTriggerHandler.getProductCustomSettingRecords('Hansa_SF_product_Mapping__c');
        Co_ProductTriggerHandler.postToHansaItemOnUpdate(prodset);
        
        Co_KitProductTriggerHandler coKit = new Co_KitProductTriggerHandler(PrdIdSet);
        Co_KitProductTriggerHandler.bulkifyKitPost(PrdIdSet);
        Test.startTest();
        System.enqueueJob(coKit);
        Test.stopTest();
        

        Test.setMock(HttpCalloutMock.class, new Calloutmock());
        System.debug('Test Method Called');
    }
    
    @isTest
    public static void test1(){
        
        List<Hansa_ERP__c> customlist =New list<Hansa_ERP__c>();
        
        Hansa_ERP__c customsetting =New Hansa_ERP__c();
        customsetting.Name='Refresh Token1';
        customsetting.Turn_of_Product_Sync__c=False;
        customsetting.Product_End_Point_URL__c='www.abc.com';
        customsetting.Access_Token_URI__c='www.jockey.com';
        customsetting.Alternate_Address_End_Point__c='www.sudan.com';
        customsetting.Authorization_URI__c='www.ringkey.com';
        customsetting.Client_Identification__c='mighty';
        customsetting.Client_Secret__c='fabplesi';
        customsetting.Customer_Supplier_End_Point_URL__c='david';
        customsetting.Redirect_URI__c='www.google.com';
        customsetting.Refresh_Token__c='mcafee';
        customsetting.Turn_of_Account_Sync__c=True;
        customsetting.Turn_of_Address_Sync__c=true;
        customlist.add(customsetting);
        INSERT customlist;
        
        Account acc = new Account();
        acc.Name = 'test Acc';
        acc.Type ='New';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();        
        insert acc;
        System.debug('<<<<<Account Inserted>>>>');
        
        Product2 rec = new Product2();
        rec.Name ='test record1';
        rec.ProductCode = 'testProd';
        rec.Product_Description__c = 'testProd';
        rec.Product_Classification__c = 'Assembly';
        rec.Product_Type__c = 'Structured Item';
        rec.Product_Status__c = 'Quote Only';
        rec.EDI__c = 'Yes';
        rec.EDI_Classification__c='SCHED';
        rec.Default_Product_Supplier__c	 =acc.Id;
        rec.Product_Group__c = 'Adver';
        rec.Product_Status__c ='Approved';
        rec.Ceetak_Drawing_No__c=Null;
        rec.Ceetak_Drawing_Rev__c=Null;
        rec.Ceetak_Material_Code__c=Null;
        rec.Material_Type__c=Null;
        rec.Weight_grams__c=Null;
        rec.Prevent_Save__c=False;
        rec.Unit__c=Null;
        rec.Warnings__c='abc';
        
        insert rec;
    }
    
    @isTest
    public static void test2(){
        Product2 res =[select id,name ,Product_Group__c from Product2 where name='test record'];
        
        res.Product_Group__c='AERUB';
        res.Ghost_Product_created_on_Hansa__c=True;
        res.Inspection_Code__c='VI';
        res.Ceetak_Drawing_No__c=Null;
        res.Ceetak_Drawing_Rev__c=Null;
        res.Ceetak_Material_Code__c=Null;
        res.Material_Type__c=Null;
        res.Weight_grams__c=Null;
        res.Prevent_Save__c=False;
        res.Unit__c=Null;
        
        UPDATE res;

       
        List<Hansa_ERP__c> customlist =New list<Hansa_ERP__c>();
        
        Hansa_ERP__c customsetting=[select id,name from Hansa_ERP__c where name='Refresh Token'];
        customsetting.Refresh_Token__c='avast';
        customlist.add(customsetting);
        
        UPDATE customlist;
        
        RunOnce.productTrigger = false;
        RunOnce.accountTrigger = false;
        Set<ID> prodset =New set<ID>();
        Co_ProductTriggerHandler.getProductCustomSettingRecords('Hansa_SF_product_Mapping__c');
        Co_ProductTriggerHandler.postToHansaItemOnUpdate(prodset);
        
          Test.setMock(HttpCalloutMock.class, new Calloutmock());
        
    }
    
    @isTest
    public static void testTom1(){
        Product2 res =[select id,name ,Product_Group__c from Product2 where name='test record'];
        SyncToHansaProd_Controller.checkConditions(res.id);
        SyncToHansaProd_Controller.syncToHansa(res.id);
        
        res.Product_Group__c='AERUB';
        res.Ghost_Product_created_on_Hansa__c=False;
        res.Inspection_Code__c='VI';
        res.Ceetak_Drawing_No__c=Null;
        res.Ceetak_Drawing_Rev__c=Null;
        res.Ceetak_Material_Code__c=Null;
        res.Material_Type__c=Null;
        res.Weight_grams__c=Null;
        res.Prevent_Save__c=False;
        res.Unit__c=Null;
        
        UPDATE res;
        
        List<Hansa_ERP__c> customlist =New list<Hansa_ERP__c>();
        
        Hansa_ERP__c customsetting=[select id,name from Hansa_ERP__c where name='Refresh Token'];
        customsetting.Refresh_Token__c='avast';
        customlist.add(customsetting);
        
        UPDATE customlist;
        
        RunOnce.productTrigger = false;
        RunOnce.accountTrigger = false;
        Set<ID> prodset =New set<ID>();
        SyncToHansaProd_Controller.checkConditions(res.id);
        SyncToHansaProd_Controller.syncToHansa(res.id);
        Test.setMock(HttpCalloutMock.class, new Calloutmock());
        
    }
    @isTest
    public static void Co_KitProductMethod(){
       RunOnce.kpTriggerCheck = false;  
      
          set<id> PrdIdSet = new set<id>();
        Product2 res =[select id,name ,Product_Group__c from Product2 where name='test record'];
        
        
        res.Product_Group__c='AERUB';
        res.Kit__c = 'Yes';
        res.Ghost_Available_as_Kit__c = True;
        UPDATE res;
        PrdIdSet.add(res.Id);
       
        Kit_Part__c ktp = new Kit_Part__c();
        ktp.Product_Name__c = res.Id;
        ktp.Kit_Part__c = res.Id;
        ktp.Ghost_KP_created_on_Hansa__c =False;
        ktp.Recipe_Row_Ref__c = 4;
        insert ktp;
        
        Kit_Part__c ktp1 = new Kit_Part__c();
        ktp1.Product_Name__c = res.Id;
        ktp1.Kit_Part__c = res.Id;
        ktp1.Ghost_KP_created_on_Hansa__c =False;
        ktp1.Recipe_Row_Ref__c = 5;
        insert ktp1;
        
        system.debug('ktp>'+ktp.Recipe_Row_Ref__c);
        List<Hansa_ERP__c> customlist =New list<Hansa_ERP__c>();
        
        Hansa_ERP__c customsetting=[select id,name from Hansa_ERP__c where name='Refresh Token'];
        customsetting.Refresh_Token__c='avast';
        customlist.add(customsetting);
        
  //      UPDATE customlist;
        
        RunOnce.productTrigger = false;
        RunOnce.accountTrigger = false;
        RunOnce.allowFurure_ProdKitLine = True;
       
        
        Test.setMock(HttpCalloutMock.class, new Calloutmock());
        
       Co_KitLineProductTriggerHandler coKitLine = new Co_KitLineProductTriggerHandler(PrdIdSet);
        Co_KitLineProductTriggerHandler.bulkifyKitPost(PrdIdSet);
        Co_KitLineProductTriggerHandler.patchRecipeLineToHansa(ktp1.Id);
        Test.startTest();
        System.enqueueJob(coKitLine);
        Test.stopTest();
        
        
           
    }
}