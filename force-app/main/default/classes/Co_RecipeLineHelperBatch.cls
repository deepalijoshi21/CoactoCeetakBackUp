/****************************************************************************************************
* Description	: callout to hansa for each new kit record(recipe line)
* Previous batch: Co_RecipeHelperBatch
*****************************************************************************************************/
public class Co_RecipeLineHelperBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    List<Id> Product2SuccessKitList = new List<Id>();
    List<Id> successfulKitId_List = new List<Id>();
    //Constructor
    public Co_RecipeLineHelperBatch(List<Id> userProduct2List){
        System.debug('@@@@@@ recipeLine batch constructor');
        this.Product2SuccessKitList = userProduct2List;
    }
    
    //start method
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT id, Recipe_Row_Ref__c,Qty_per_Kit__c,Product_Name__r.Name,Kit_Part__c,Kit_Part__r.Name,Kit_Part__r.Ghost_Product_created_on_Hansa__c,Ghost_Parent_is_Active_Kit__c,Ghost_KP_created_on_Hansa__c from Kit_Part__c where Kit_Part__c!=null AND Product_Name__c IN:Product2SuccessKitList AND  Ghost_Parent_is_Active_Kit__c=True AND  Ghost_KP_created_on_Hansa__c=False AND Recipe_Row_Ref__c>=1 AND Kit_Part__r.Ghost_Product_created_on_Hansa__c=True Order by Product_Name__r.Name]);
    }
    
    // execute method
    public void execute(Database.BatchableContext BC, List<Kit_Part__c> scope){
        System.debug('####@ Batch 3 execute');
        //Set<String> KitId_Set = new Set<String>();
        if(!scope.isEmpty()){
            List<String> succesResult = new List<String>();
         	//KitId_Set.add(scope[0].Id);
        	/*succesResult =*/ postToHansaController.patchNewRecipeLineToHansa(scope[0].Id);  
            if(!succesResult.isEmpty())
            	successfulKitId_List.addAll(succesResult);
        }
    }
    
    // final method
    public void finish(Database.batchableContext BC){
        System.debug('@@@@@@ Batch 3 final ');
    }
}