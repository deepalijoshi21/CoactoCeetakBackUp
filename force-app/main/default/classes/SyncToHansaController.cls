public class SyncToHansaController {
    public SyncToHansaController() {

    }

    // FIRST METHOD TO CALL WHEN syncToHansa BUTTON PRESSED
    @AuraEnabled
    public static boolean checkConditions(string accountId){
        boolean accountCreatedInHansa = false;
        Account acc = [select id,recordTypeId,recordtype.name,Hansa_Account_Number__c,Hansa_Supplier_Number__c from account where id =:accountId];
        if(acc.recordTypeId != null && acc.recordtype.name == 'Customer' && acc.Hansa_Account_Number__c != null){
            return true;            
        }else if(acc.recordTypeId != null && acc.recordtype.name == 'Supplier' && acc.Hansa_Supplier_Number__c != null){
            return true;            
        }else{
            return false;
        }
    }

    @AuraEnabled
    public static boolean syncToHansa(string accountId){
        boolean accountCreatedInHansa = false;
        Account acc = [select id,recordTypeId,recordtype.name,Hansa_Account_Number__c,Hansa_Supplier_Number__c from account where id =:accountId];
        if(acc.recordTypeId != null && acc.recordtype.name == 'Customer' && acc.Hansa_Account_Number__c != null){
            AccountTriggerHandler.postToHansaUpdate(new set<string>{accountId}, new set<string>(), new set<string>(),true);
            
        }else if(acc.recordTypeId != null && acc.recordtype.name == 'Supplier' && acc.Hansa_Supplier_Number__c != null){
            AccountTriggerHandler.postToHansaUpdate(new set<string>{accountId}, new set<string>(), new set<string>(),true);
            
        }else{
            AccountTriggerHandler.postToHansa(new set<string>{accountId});
        }
        return true;
    }
}