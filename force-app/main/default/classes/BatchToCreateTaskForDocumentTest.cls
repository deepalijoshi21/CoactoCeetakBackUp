/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test class for BatchToCreateTaskForDocument and BatchToCreateTaskForDocumentSchedule
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
public class BatchToCreateTaskForDocumentTest {
	@isTest
    public static void testDocument(){
        Account acc = new Account();
        acc.name = 'test account';
        acc.RecordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        insert acc;
        
        
        Document__c document = new Document__c();
        document.Account__c = acc.id;
        document.Type__c = 'Terms & Conditions';
        document.Status__c = 'Draft';
        document.Department__c = 'Quality';
        document.Expiry_Date_Notification__c = '14';
        document.End_Date__c = date.today().addDays(14);
        insert document;
        
        Database.executeBatch(new BatchToCreateTaskForDocument(),1);
        Test.startTest();
        BatchToCreateTaskForDocumentSchedule task = new BatchToCreateTaskForDocumentSchedule();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Document Notification', sch, task); 
        Test.stopTest(); 
    }
}