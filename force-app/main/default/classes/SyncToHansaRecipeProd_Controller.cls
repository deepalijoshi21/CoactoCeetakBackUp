/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Description	:	Controller for syncToRecipeHansa Product aura component
* Test class	:	
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Salesforce Coacto
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class SyncToHansaRecipeProd_Controller {
    public SyncToHansaRecipeProd_Controller() {
        System.debug('######@@ sync to recipe AURA controller ');
    }
    
    // FIRST METHOD TO CALL WHEN syncToHansa BUTTON PRESSED
    @AuraEnabled
    public static String checkConditions(string prodId){
        system.debug('@@@@@@@ product Id => '+prodId);
        product2 prod = [select id,Ghost_Product_created_on_Hansa__c,Ghost_Available_as_Kit__c,Kit__c from product2 where id =:prodId];
        if(prod.Kit__c==null || prod.Kit__c=='No'){
            return 'NoCriteria'; 
        }
        else{
            if(prod.Ghost_Product_created_on_Hansa__c== False){
                return 'NoProduct';            
            }
            else{
                if(prod.Ghost_Available_as_Kit__c==False){
                    return 'ReadyToSync';
                }
                else{
                    return 'AlreadyToSync';
                }   
            }
        }
        
    }
    
    @AuraEnabled
    public static boolean syncToHansa(string prodId){
        Product2 pdt = [select id,Ghost_Product_created_on_Hansa__c,Ghost_Available_as_Kit__c from Product2 where id =:prodId];
        if(pdt.Ghost_Available_as_Kit__c==False && pdt.Ghost_Product_created_on_Hansa__c==True){
            System.debug('@@@@### POST RECIPE TO HANSA call');
            // CALL PUT
            System.debug('##########@ CALL METHOD TO POST RECIPE AND LINE');
            //Co_ProductTriggerHandler.postToHansaItem(new set<Id>{prodId});
            Set<Id> product_IdSet = new Set<Id>();
            product_IdSet.add(pdt.Id);
            //System.enqueueJob(new Co_KitProductTriggerHandler(product_IdSet));
            //Call Batch**
            Co_RecipeHelperBatch secBatchObj = new Co_RecipeHelperBatch(new List<String>{pdt.Id});
            Database.executeBatch(secBatchObj,1);
        }
        return true;
    }
}