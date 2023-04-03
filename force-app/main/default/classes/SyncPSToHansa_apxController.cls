/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* Description	:	Apex controller for aura component "SyncPSToHansa". Manually sync Part Supplier to HANSA
* Test class	:	
* ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────
* @author         	Salesforce Coacto
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 
*/

public class SyncPSToHansa_apxController {
    
    public SyncPSToHansa_apxController() {
        System.debug('@@@@@@@ PS default constructor');
    }
    
    // FIRST METHOD 
    // CALL wben syncToHansa button is clicked
    @AuraEnabled
    public static boolean checkPSConditions(string psId){
        boolean psCreatedInHansa = false;
        System.debug('############@ ps => '+psId);
        Part_Suppliers__c psRec = [select id,Ghost_PS_created_on_Hansa__c,recordType.Name from Part_Suppliers__c where id =:psId];
        if(psRec.Ghost_PS_created_on_Hansa__c== False){
            return false;            
        }else{
            return true;
        }
    }
    
    @AuraEnabled
    public static boolean syncPSToHansa(string psId){
        boolean psCreatedInHansa = false;
        Part_Suppliers__c psObj = [select id,Ghost_PS_created_on_Hansa__c,recordType.Name from Part_Suppliers__c where id =:psId];
        if(psObj.Ghost_PS_created_on_Hansa__c==True){
            System.debug('#### calling PATCH => ');
            // CALL PATCH
            if(psObj.recordType.Name=='Part Supplier')
           		Coacto_PartSuplr_TriggerHelper.patchToHansaPSupplier(new set<Id>{psId}, true);
            if(psObj.recordType.Name=='Part Customer')
           		Coacto_PartSuplr_TriggerHelper.patchToHansaPSupplier(new set<Id>{psId}, false);
            
        }else if(psObj.Ghost_PS_created_on_Hansa__c==False){
            System.debug('#### calling PUT => ');
            // CALL PUT
            if(psObj.recordType.Name=='Part Supplier')
           		Coacto_PartSuplr_TriggerHelper.postToHansaPSupplier(new set<Id>{psId}, true);
            if(psObj.recordType.Name=='Part Customer')
                 Coacto_PartSuplr_TriggerHelper.postToHansaPSupplier(new set<Id>{psId}, false);
        }
        return true;
    }
}