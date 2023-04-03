/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Description	:	Controller for syncKitToHansaRecipeLine aura component
* Test class	:	
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Salesforce Coacto
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class SyncToHansaRecipeLine_Controller {
    public SyncToHansaRecipeLine_Controller() {
        
    }
    
    // FIRST METHOD TO CALL WHEN syncToHansa BUTTON PRESSED
    @AuraEnabled
    public static String checkConditions(string prodId){
        System.debug('######@@@ kit line sync btn critarea check');
        Kit_Part__c kito = [select id,Ghost_KP_created_on_Hansa__c,Kit_Part__r.Ghost_Product_created_on_Hansa__c,Ghost_Parent_is_Active_Kit__c,Product_Name__r.Kit__c,Recipe_Row_Ref__c from Kit_Part__c where id =:prodId AND Kit_Part__c!=null AND Product_Name__c!=null];
        if(kito==null){
            return 'NotValidRecord';
        }
        else{
            if(kito.Ghost_Parent_is_Active_Kit__c==False){
                return 'NoRecipe';            
            }else if(!kito.Kit_Part__r.Ghost_Product_created_on_Hansa__c){
                return 'KitNotAvailable';
            }
            else if(kito.Recipe_Row_Ref__c==null || kito.Recipe_Row_Ref__c<=0 ){
                return 'NoRowRef';
            }
            else if(kito.Ghost_KP_created_on_Hansa__c){
                return 'updateHansa';
            }
            else{
                return 'readyInsert';
            }
        }
        
    }
    
    @AuraEnabled
    public static boolean syncToHansa(string kitId){
        //Product2 pdt = [select id,Ghost_Product_created_on_Hansa__c from Product2 where id =:kitId];
            System.debug('@@@@### patch call');
            // CALL PATCH
             Id kitId_nw = (id)kitId;
            Co_KitPartTriggerHandler.handleBulForNewKit(new set<Id>{kitId_nw});
        
        return true;
    }
}