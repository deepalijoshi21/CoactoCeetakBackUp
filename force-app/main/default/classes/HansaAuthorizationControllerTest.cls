/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test Class for HansaAuthorizationController
* ───────────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-04-09
* @modified       2020-04-13
* ─────────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
public class HansaAuthorizationControllerTest {
    @isTest
    public static void testTask(){
        Test.setMock(HttpCalloutMock.class, new HansaAuthorizationControllerMock());
        HansaAuthorizationController controller = new HansaAuthorizationController();
        controller.authenticate();
        controller.errorClose();
        controller.homePage();
        ApexPages.currentPage().getParameters().put('code','Test Code');
        ApexPages.currentPage().getParameters().put('error','Test Code');
        Hansa_ERP__c erp = new Hansa_ERP__c();
        erp.name = 'Refresh Token';
        erp.Client_Identification__c = 'test';
        erp.Client_Secret__c = 'test';
        erp.Authorization_URI__c = 'https://standard-id.hansaworld.com/oauth-authorize';
        erp.Access_Token_URI__c = 'https://standard-id.hansaworld.com/oauth-token ';
        erp.Redirect_URI__c = 'https://test.salesforce.com/apex/HansaAuthorization';
        erp.Customer_Supplier_End_Point_URL__c = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/CUVc?';
        insert erp;
        test.startTest();
        controller.OnLoadController();
        test.stopTest();
    }
}