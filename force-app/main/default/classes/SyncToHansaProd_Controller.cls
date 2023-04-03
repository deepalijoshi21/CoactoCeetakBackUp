/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Description	:	Controller for syncToHansa Product aura component
* Test class	:	Co_ProjectTrigger_Test
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Salesforce Coacto
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/

public class SyncToHansaProd_Controller {
    public SyncToHansaProd_Controller() {
        
    }
    
    // FIRST METHOD TO CALL WHEN syncToHansa BUTTON PRESSED
    @AuraEnabled
    public static boolean checkConditions(string prodId){
        boolean accountCreatedInHansa = false;
        product2 prod = [select id,Ghost_Product_created_on_Hansa__c from product2 where id =:prodId];
        if(prod.Ghost_Product_created_on_Hansa__c== False){
            return false;            
        }else{
            return true;
        }
    }
    
    @AuraEnabled
    public static boolean syncToHansa(string prodId){
        boolean accountCreatedInHansa = false;
        Product2 pdt = [select id,Ghost_Product_created_on_Hansa__c from Product2 where id =:prodId];
        if(pdt.Ghost_Product_created_on_Hansa__c==True){
            System.debug('@@@@### patch call');
            // CALL PATCH
            Co_ProductTriggerHandler.postToHansaItemOnUpdate(new set<Id>{prodId});
            
        }else if(pdt.Ghost_Product_created_on_Hansa__c==False){
            System.debug('@@@@### Put call');
            // CALL PUT
           // Co_ProductTriggerHandler.postToHansaItem(new set<Id>{prodId});
           //Call batch**
            System.debug('##### Product Id => '+prodId);
            Database.executeBatch(new Co_ProductTriggerHandlerBatch(new List<Id>{prodId}),1);
        }
        return true;
    }
}