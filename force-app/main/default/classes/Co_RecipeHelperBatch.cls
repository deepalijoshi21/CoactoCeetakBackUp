/****************************************************************************************************
* Description	: callout to hansa for each new product kit = true
* Previous batch: Co_ProductTriggerHandlerBatch
* Chained Batch	: Co_RecipeLineHelperBatch
*****************************************************************************************************/
public class Co_RecipeHelperBatch implements Database.Batchable<SObject>, Database.Stateful,Database.AllowsCallouts {

    List<String> kitProduct2List = new List<Id>();
    Set<String> successfulKitId_List = new Set<String>();
    
    //Constructor
    public Co_RecipeHelperBatch(List<String> userKitProduct2List){
        System.debug('@@@@@@ Recipe batch constructor');
        this.kitProduct2List = userKitProduct2List;
    }
    
    public Co_RecipeHelperBatch(){
        System.debug('@@@@@@ Recipe default constructor');
        
    }
    
    //start method
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT id,Name, Product_Description__c,Ghost_Available_as_Kit__c,Ghost_Recipe_Sync_Response__c,Ghost_Recipe_Sync_Error__c  FROM product2 where Id IN: kitProduct2List]);
    }
    
    // execute method
    public void execute(Database.BatchableContext BC, List<product2> scope){
        Set<String> productId_Set = new Set<String>();
        if(!scope.isEmpty()){
            List<String> succesResult = new List<String>();
         	productId_Set.add(scope[0].Id);
        	succesResult = postToHansaController.postNewKitToHansa(productId_Set);  
            if(!succesResult.isEmpty())
            	successfulKitId_List.addAll(succesResult);
        }
    }
    
    // final method
    public void finish(Database.batchableContext BC){
        List<String> userKitSuccessProduct2List = new List<String>();
        System.debug('@@@@@@## finsh second bacth @@@ => '+successfulKitId_List);
        for(product2 prd : [SELECT id,Name, Product_Description__c, Ghost_Available_as_Kit__c, Ghost_Recipe_Sync_Response__c, Ghost_Recipe_Sync_Error__c  FROM product2 where Ghost_Available_as_Kit__c=True AND Kit__c='Yes' AND Id IN: successfulKitId_List]){
            userKitSuccessProduct2List.add(prd.Id);
        }
        System.debug('@@@@@ userKitSuccessProduct2List => '+userKitSuccessProduct2List);
        if(!userKitSuccessProduct2List.isEmpty()){
            System.debug('@@@@ call batch3 ');
            Co_RecipeLineHelperBatch thrdBatchObj = new Co_RecipeLineHelperBatch(userKitSuccessProduct2List);
            Database.executeBatch(thrdBatchObj,1);
        }
    }
}