/****************************************************************************************************
* Description	: callout to hansa for each new product from salefoce
* Chained Batch	: Co_RecipeHelperBatch(Post Hansa for recipe and 0th indes recipe line)
*****************************************************************************************************/

public class Co_ProductTriggerHandlerBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    List<String> Product2List = new List<String>();
    Set<String> successfulProductId_Set = new Set<String>();
    
    //Constructor
    public Co_ProductTriggerHandlerBatch(List<Id> userProduct2List){
        System.debug('@@@@@@ Product batch constructor');
        this.Product2List = userProduct2List;
    }
    
    // Start method
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT id, Inspection_Code__c, Product_Type__c, Product_Group__c,Product_Classification__c,Product_Description__c,Product_Status__c,Name, Ceetak_Drawing_No__c, Ceetak_Drawing_Rev__c, Ceetak_Material_Code__c, Material_Type__c, Unit__c, Weight_grams__c, Inspection_Name__c, Warnings__c, Country_of_Origin__c, EDI__c, EDI_Classification__c  FROM product2 where Id IN: Product2List]);
        //return null;
    }
    
    // Execute method
    public void execute(Database.BatchableContext BC, List<product2> scope){
        Set<String> productId_Set = new Set<String>();
        if(!scope.isEmpty()){
            List<String> succesResult = new List<String>();
         	productId_Set.add(scope[0].Id);
        	succesResult = postToHansaController.postToHansa_newItem(productId_Set);  
            if(!succesResult.isEmpty())
            	successfulProductId_Set.addAll(succesResult);
        }
    }
    
    // Final method
    public void finish(Database.batchableContext BC){
        System.debug('@@@@@@@@@@@ FINISH ITEM batch');
        List<String> userKitProduct2List = new List<String>();
        for(Product2 prod : [SELECT id,Ghost_Product_created_on_Hansa__c, Kit__c from product2 where Ghost_Product_created_on_Hansa__c=True AND Kit__c='Yes' AND Id IN:successfulProductId_Set]){
            userKitProduct2List.add(prod.Id);
        }
        System.debug('@@@@@ userKitProduct2List => '+userKitProduct2List);
        if(!userKitProduct2List.isEmpty()){
            System.debug('@@@@ call batch2 ');
            Co_RecipeHelperBatch secBatchObj = new Co_RecipeHelperBatch(userKitProduct2List);
            Database.executeBatch(secBatchObj,1);
        }
    }
}