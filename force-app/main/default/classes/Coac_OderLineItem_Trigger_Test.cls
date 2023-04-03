/*******************************************************************************************************************
*	Created by		: 	Bhagwan Singh
*	Created date	: 	09-08-2022
*	Trigger			:	Coac_OrderLineItem_Trigger, Coac_OrderLineItem_Trigger
* 	Classes			:	Coac_OrderLineItem_TriggerHelper, Coac_OrderLineItem_TriggerHelper
*	Description		:	Test class for Order and OrderItems
********************************************************************************************************************/
@isTest(seeAllData=false)
public class Coac_OderLineItem_Trigger_Test {
    
    //Test Setup Method
    @testSetup static void testSetupMethod(){
        // Insert Account
    	Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        // Insert Product
        Product2 prdt = new Product2();
        prdt.Name = 'Test_Product';
        prdt.Description='Test Product Entry 1';
        prdt.productCode = 'ABC';
        prdt.isActive = true;
        insert prdt;
        
        //ID pricebookId = Test.getStandardPricebookId();
        string priceId = System.Label.Coac_PricebookId;
        //system.debug('>>'+pricebookId);
        //Enter Standard Price book
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = priceId;
        standardPrice.Product2Id = prdt.Id;
        standardPrice.UnitPrice = 5;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
    
        // Insert Order
        
        Order odr = new Order();
        odr.Name = 'Test Order ';
        odr.recordTypeId=Schema.SObjectType.Order.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        odr.EffectiveDate = system.today();
        odr.EndDate = system.today() + 4;
        odr.AccountId = acc.id;
        odr.Pricebook2Id =  priceId ;
        
        insert odr;
        
        // Insert Order Item
    
        OrderItem oli = new OrderItem();
        oli.OrderId = odr.id;
        oli.Quantity = 24;
        oli.UnitPrice = 240;
        oli.Product2id = prdt.id;
        oli.PricebookEntryId=standardPrice.id;
        oli.Quantity_Delivered__c=3;
        oli.Quantity=5;
        insert oli;
    
        
        OrderItem oli3 = new OrderItem();
        oli3.OrderId = odr.id;
        oli3.Quantity = 24;
        oli3.UnitPrice = 240;
        oli3.Product2id = prdt.id;
        oli3.PricebookEntryId=standardPrice.id;
        oli3.Order_Line_Status__c='Open';
        insert oli3;
        
    }
    
    public static testMethod void orderItemTest1(){
        Order odr=[Select id, name, status from Order Limit 1];
        odr.status='On Hold';
        update odr;
     } 

    public static testMethod void orderItemTest2(){
        OrderItem oli=[Select id, Order_Line_Status__c from OrderItem where Order_Line_Status__c='Open' Limit 1];
        delete oli;
        
    }    
    
    public static testMethod void orderItemTest3(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        // Insert Product
        Product2 prdt = new Product2();
        prdt.Name = 'Test_Product3';
        prdt.Description='Test Product Entry 1';
        prdt.productCode = 'ABC3';
        prdt.isActive = true;
        insert prdt;
        
        //ID pricebookId = Test.getStandardPricebookId();
        string priceId = System.Label.Coac_PricebookId;
        //system.debug('>>'+pricebookId);
        //Enter Standard Price book
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = priceId;
        standardPrice.Product2Id = prdt.Id;
        standardPrice.UnitPrice = 5;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
    
        // Insert Order
        
        Order odr = new Order();
        odr.Name = 'Test Order ';
        odr.recordTypeId=Schema.SObjectType.Order.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        odr.EffectiveDate = system.today();
        odr.EndDate = system.today() + 4;
        odr.AccountId = acc.id;
        odr.Pricebook2Id =  priceId ;
        
        insert odr;
        
        // Insert Order Item
    
        OrderItem oli = new OrderItem();
        oli.OrderId = odr.id;
        oli.Quantity = 24;
        oli.UnitPrice = 240;
        oli.Product2id = prdt.id;
        oli.PricebookEntryId=standardPrice.id;
        oli.Quantity_Delivered__c=24;
        insert oli;
    
    }    
    
    public static testMethod void orderItemTest4(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        // Insert Product
        Product2 prdt = new Product2();
        prdt.Name = 'Test_Product2';
        prdt.Description='Test Product Entry 1';
        prdt.productCode = 'ABC2';
        prdt.isActive = true;
        insert prdt;
        
        //ID pricebookId = Test.getStandardPricebookId();
        string priceId = System.Label.Coac_PricebookId;
        //system.debug('>>'+pricebookId);
        //Enter Standard Price book
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = priceId;
        standardPrice.Product2Id = prdt.Id;
        standardPrice.UnitPrice = 5;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
    
        // Insert Order
        
        Order odr = new Order();
        odr.Name = 'Test Order ';
        odr.recordTypeId=Schema.SObjectType.Order.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        odr.EffectiveDate = system.today();
        odr.EndDate = system.today() + 4;
        odr.AccountId = acc.id;
        odr.Pricebook2Id =  priceId ;
        
        insert odr;
        
        // Insert Order Item
    
        OrderItem oli = new OrderItem();
        oli.OrderId = odr.id;
        oli.Quantity = 24;
        oli.UnitPrice = 240;
        oli.Product2id = prdt.id;
        oli.PricebookEntryId=standardPrice.id;
        oli.Order_Line_Status__c='Cancelled';
        insert oli;

    }  
    
}