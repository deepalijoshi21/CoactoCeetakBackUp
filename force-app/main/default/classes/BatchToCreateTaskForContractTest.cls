/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test class for BatchToCreateTaskForContract and BatchToCreateTaskForContractSchedule
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-03-31
* @modified       2020-03-31
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
public class BatchToCreateTaskForContractTest {
	@isTest
    public static void testTask(){
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        acc.name = 'test account';
        acc.Primary_Internal_Sales__c = UserInfo.getUserId();
        insert acc;
        
        Contract contract = new Contract();
        contract.AccountId = acc.id;
        contract.Status = 'Draft';
        contract.Type__c = 'NDA';
        contract.Contract_End_Date__c = date.today().addDays(14);
        contract.Expiry_Date_Notification__c = '14';
        insert contract;
        Database.executeBatch(new BatchToCreateTaskForContract(),1);
    }
    
    @isTest
    public static void testSupplier(){
        Account acc1 = new Account();
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        acc1.name = 'test account';
        acc1.Primary_Internal_Sales__c = UserInfo.getUserId();
        insert acc1;
        
        Contract contract1 = new Contract();
        contract1.AccountId = acc1.id;
        contract1.Status = 'Draft';
        contract1.Type__c = 'NDA';
        contract1.Contract_End_Date__c = date.today().addDays(14);
        contract1.Expiry_Date_Notification__c = '14';
        insert contract1;
        Database.executeBatch(new BatchToCreateTaskForContract(),1);
        test.startTest();
        BatchToCreateTaskForContractSchedule createtask = new BatchToCreateTaskForContractSchedule();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Contract Notification', sch, createtask);
        Test.stopTest();
    }
}