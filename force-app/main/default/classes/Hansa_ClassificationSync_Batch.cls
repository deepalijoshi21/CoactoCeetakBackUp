/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* Batch class to sync retroactive Hansa account classification field
* Helper class  :   Hansa_ClassificationSync_BatchHelper
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 
*/

public class Hansa_ClassificationSync_Batch  implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public String userAccId;
    
    public Hansa_ClassificationSync_Batch(String accId){
        this.userAccId=accId;
    }
    
    public Hansa_ClassificationSync_Batch(){
        this.userAccId='';
    }
    
    //START BATCH
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query='';
        if(userAccId=='')
            query='select id,RecordTypeId,RecordType.Name from account where recordtype.name=\'Supplier\'';
        else
            query='select id,RecordTypeId,RecordType.Name from account where recordtype.name=\'Supplier\' AND id=:userAccId';
        return Database.getQueryLocator(query);
    }
    
    //EXECUTE METHOD
    public void execute(Database.BatchableContext BC, List<Account> accRec){
        System.debug('@@@@@@@@@@@@ accRec '+accRec);
        if(accRec.size()==1){
            Hansa_ClassificationSync_BatchHelper.postToHansaUpdate(accRec[0].id);
        } 
    }
    
    //FINISH METHOD
    public void finish(Database.BatchableContext BC){
        System.debug('@@@@@ batch finished');
    }
}