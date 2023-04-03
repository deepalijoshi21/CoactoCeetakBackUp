@isTest
private class coacto_PartSuplr_Trigger_Test {
    
    @TestSetup
    private static void testDataSetup(){
        
        Test.setMock(HttpCalloutMock.class, new triggerCalloutmock(200));
        
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
        customsetting.Part_Supplier_End_Point_URL__c='PIVc';
        customsetting.Redirect_URI__c='www.google.com';
        customsetting.Refresh_Token__c='mcafee';
        customsetting.Turn_of_Account_Sync__c=True;
        customsetting.Turn_of_Address_Sync__c=true;
        customsetting.Part_Customer_End_Point_URL__c='abc';
        
        customlist.add(customsetting);
        INSERT customlist;
        
        //----- for Supplier
        Account acc = new Account();
        acc.Name = 'testAcc';
        acc.Type ='New';
        acc.Hansa_Account_Number__c	='10000';
        acc.Hansa_Supplier_Number__c = '11111';	
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        insert acc;
        System.debug('<<<<<Account Inserted>>>>  ::' + acc.Hansa_Account_Number__c);
        
        Product2 rec = new Product2();
        rec.Name ='test_record';
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
        insert rec;
        
        List<Part_Suppliers__c> psList = new List<Part_Suppliers__c>();
        for(integer i =1;i<=99;i++){
            Part_Suppliers__c ps = new Part_Suppliers__c();
            ps.Supplier_Product_Name__c = rec.Id;
            ps.Supplier_Name__c = acc.Id;
            ps.Supplier_Part_Ref__c = 'testRef';
            ps.Supplier_Drawing_No__c = 'testDrawNo';
            ps.Supplier_Drawing_Rev__c = 'testDrawRev';
            ps.Supplier_Material_Code__c = 'testMaterial';
            ps.Country_of_Origin__c = 'India';
            ps.Purch_Box_Qty__c = 150;
            ps.Purch_Bag_Qty__c = 60;
            ps.Purch_Box_Gross_Weight__c = '400';
            ps.Purch_Box_Dimensions__c = 'testBoxDim';
            ps.Purchase_Warning__c = 'testPurchase';
            ps.Minimum_Order_Qty__c = 'testOrder';
            ps.Ghost_PS_created_on_Hansa__c = False;
            ps.RecordTypeId = Schema.SObjectType.Part_Suppliers__c.getRecordTypeInfosByName().get('Part Supplier').getRecordTypeId();
            psList.add(ps);   
        }
        insert psList;   
        
         //----- for Customer
        Account acc2 = new Account();
        acc2.Name = 'testAcc2';
        acc2.Type ='New';
        acc2.Hansa_Account_Number__c = '20000';
        acc2.Hansa_Supplier_Number__c = '22222';	
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        insert acc2;
        System.debug('<<<<<Account2 Inserted>>>>'+ acc2.Hansa_Account_Number__c);
        
        Product2 rec2 = new Product2();
        rec2.Name ='test_record2';
        rec2.ProductCode = 'testProd2';
        rec2.Product_Description__c = 'testProd2';
        rec2.Product_Classification__c = 'Assembly';
        rec2.Product_Type__c = 'Structured Item';
        rec2.Product_Status__c = 'Quote Only';
        rec2.EDI__c = 'Yes';
        rec2.EDI_Classification__c='SCHED';
        //rec2.Default_Product_Supplier__c	 =acc2.Id;
        rec2.Product_Group__c = 'Adver';
        rec2.Product_Status__c ='Approved';
        rec2.Ceetak_Drawing_No__c='accurate';
        rec2.Ceetak_Drawing_Rev__c='newldadd';
        rec2.Ceetak_Material_Code__c='amazed';
        rec2.Material_Type__c='rekon';
        rec2.Weight_grams__c=40;
        rec2.Prevent_Save__c=False;
        insert rec2;
        
        List<Part_Suppliers__c> pcList = new List<Part_Suppliers__c>();
        
        for(integer i =1;i<=99;i++){
            Part_Suppliers__c psCustomer = new Part_Suppliers__c();
            psCustomer.Customer_Product_Name__c = rec2.Id;
            psCustomer.Customer_Name__c	 = acc2.Id;
            psCustomer.Customer_Item_Ref__c = 'testItemRef'; 
            psCustomer.Customer_Description__c = 'testDesc';
            psCustomer.Customer_Drawing_Ref__c = 'testDrawRef';
            psCustomer.Special_Requirements__c = 'testSpecReq';
            psCustomer.Customer_Approval_Received__c = '1';
            psCustomer.Approval_Date__c = Date.today();
            psCustomer.Sales_Box_Qty__c = 50;
            psCustomer.Sales_Bag_Qty__c =100;
            psCustomer.EDI_Item_No__c = 'testEDI';
            psCustomer.Tariff_Code__c='testTariff';
            psCustomer.No_of_Years_Productivity__c=10;
            psCustomer.Ghost_PS_created_on_Hansa__c = False;
            psCustomer.RecordTypeId = Schema.SObjectType.Part_Suppliers__c.getRecordTypeInfosByName().get('Part Customer').getRecordTypeId();
            pcList.add(psCustomer);
        }
        insert pcList;
    }
    
   @isTest
    private static void testMethod1(){
        
        Test.setMock(HttpCalloutMock.class, new triggerCalloutmock(200));
        Test.startTest();
        
        List<Part_Suppliers__c> updateList = [select Supplier_Part_Ref__c,Purch_Bag_Qty__c, Ghost_PS_created_on_Hansa__c,
                                              Supplier_Drawing_No__c,Supplier_Drawing_Rev__c,Supplier_Material_Code__c,
                                              Country_of_Origin__c,Purch_Box_Qty__c,Purch_Box_Gross_Weight__c,
                                              Purch_Box_Dimensions__c, Purchase_Warning__c, Minimum_Order_Qty__c from Part_Suppliers__c ];
        for(Part_Suppliers__c ps:updateList){
            ps.Purch_Bag_Qty__c = Null;
            ps.Ghost_PS_created_on_Hansa__c = True;
            ps.Supplier_Part_Ref__c = Null;
            ps.Supplier_Drawing_No__c = Null;
            ps.Supplier_Drawing_Rev__c = Null;
            ps.Supplier_Material_Code__c = Null;
            ps.Country_of_Origin__c = Null;
            ps.Purch_Box_Qty__c = Null;
            ps.Purch_Bag_Qty__c = Null;
            ps.Purch_Box_Gross_Weight__c = Null;
            ps.Purch_Box_Dimensions__c = Null;
            ps.Purchase_Warning__c = Null;
            ps.Minimum_Order_Qty__c = Null;
        }
        update updateList;
        Test.stopTest();
    }
    
    @isTest
    private static void testMethod2(){
        
        Test.setMock(HttpCalloutMock.class, new triggerCalloutmock(200));
        Test.startTest();
        List<Part_Suppliers__c> updateList = [select Purch_Bag_Qty__c, Ghost_PS_created_on_Hansa__c from Part_Suppliers__c ];
        for(Part_Suppliers__c ps:updateList){
          ps.Purch_Bag_Qty__c = 60;
          ps.Ghost_PS_created_on_Hansa__c = False;
        }
        update updateList;
        
        List<Hansa_ERP__c> customlist =New list<Hansa_ERP__c>();
       
        Hansa_ERP__c customsetting=[select id,name,Part_Supplier_End_Point_URL__c from Hansa_ERP__c where name='Refresh Token'];
        customsetting.Refresh_Token__c='avast';
        customsetting.Part_Supplier_End_Point_URL__c='ABSCUINVc'; 
        customlist.add(customsetting);
        
        UPDATE customlist;
        Test.stopTest();
    }  
    
    @isTest
    private static void testMethod3(){
	      Test.setMock(HttpCalloutMock.class, new triggerCalloutmock(201));
        Test.startTest();
        
        List<Part_Suppliers__c> updateList = [select Purch_Bag_Qty__c, Ghost_PS_created_on_Hansa__c from Part_Suppliers__c ];
        for(Part_Suppliers__c ps:updateList){
          ps.Purch_Bag_Qty__c = 60;
          ps.Ghost_PS_created_on_Hansa__c = False;
        }
        update updateList;
        
        List<Hansa_ERP__c> customlist =New list<Hansa_ERP__c>();
       
        Hansa_ERP__c customsetting=[select id,name,Part_Supplier_End_Point_URL__c from Hansa_ERP__c where name='Refresh Token'];
        customsetting.Refresh_Token__c='avast';
        customsetting.Part_Supplier_End_Point_URL__c='PIVc'; 
        customlist.add(customsetting);
        
        UPDATE customlist;
        
      
        Test.stopTest();
    }

    @isTest
    private static void testMethod4(){
        Test.setMock(HttpCalloutMock.class, new triggerCalloutmock(200));
        
        List<Hansa_ERP__c> customlist =New list<Hansa_ERP__c>();
        
        Hansa_ERP__c customsetting =[SELECT id,Part_Customer_End_Point_URL__c,Turn_of_Address_Sync__c,Turn_of_Account_Sync__c,Refresh_Token__c,Redirect_URI__c,Part_Supplier_End_Point_URL__c,Customer_Supplier_End_Point_URL__c,Client_Secret__c,Client_Identification__c,Authorization_URI__c,Alternate_Address_End_Point__c,Name,Turn_of_Product_Sync__c,Product_End_Point_URL__c,Access_Token_URI__c from Hansa_ERP__c where Name='Refresh Token'];
        
        //----- for Supplier
        Account acc = new Account();
        acc.Name = 'testAccAA';
        acc.Type ='New';
        acc.Hansa_Account_Number__c	='10000';
        acc.Hansa_Supplier_Number__c = '11111';	
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        insert acc;
        System.debug('<<<<<Account Inserted>>>>  ::' + acc.Hansa_Account_Number__c);
        
        Product2 rec = new Product2();
        rec.Name ='test_recordAA';
        rec.ProductCode = 'testProdAA';
        rec.Product_Description__c = 'testProdAA';
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
        insert rec;
        
        List<Part_Suppliers__c> psList = new List<Part_Suppliers__c>();
        for(integer i =1;i<=99;i++){
            Part_Suppliers__c ps = new Part_Suppliers__c();
            ps.Supplier_Product_Name__c = rec.Id;
            ps.Supplier_Name__c = acc.Id;
            ps.RecordTypeId = Schema.SObjectType.Part_Suppliers__c.getRecordTypeInfosByName().get('Part Supplier').getRecordTypeId();
            psList.add(ps);   
        }
        insert psList;   
    }
    
     @isTest
    private static void testMethodA(){
		Test.setMock(HttpCalloutMock.class, new triggerCalloutmock(200));
		Part_Suppliers__c updatePSC = [select Purch_Bag_Qty__c, Ghost_PS_created_on_Hansa__c from Part_Suppliers__c where Ghost_PS_created_on_Hansa__c = False Limit 1 ];
		SyncPSToHansa_apxController.checkPSConditions(updatePSC.id);
        SyncPSToHansa_apxController.syncPSToHansa(updatePSC.id);
        
        updatePSC.Ghost_PS_created_on_Hansa__c = True;
        update updatePSC;
        SyncPSToHansa_apxController.syncPSToHansa(updatePSC.id);
    }
}