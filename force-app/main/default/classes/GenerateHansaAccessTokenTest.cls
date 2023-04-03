/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test Class for GenerateHansaAccessToken
* ───────────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-04-13
* @modified       2020-04-13
* ─────────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
public class GenerateHansaAccessTokenTest {
    @isTest
    public static void accessTokenTest(){
        Test.setMock(HttpCalloutMock.class, new GenerateHansaAccessTokenMockCallout());
        Hansa_ERP__c erp = new Hansa_ERP__c();
        erp.name = 'Refresh Token';
        erp.Client_Identification__c = '18B30509-DD3026C9-C1FA6558-E230A9AD-F6A9B9DF';
        erp.Client_Secret__c = '9e570ca990099d39c9fa859b2c8ea8b3';
        erp.Authorization_URI__c = 'https://standard-id.hansaworld.com/oauth-authorize';
        erp.Access_Token_URI__c = 'https://standard-id.hansaworld.com/oauth-token';
        erp.Redirect_URI__c = 'https://test.salesforce.com/apex/HansaAuthoriza...';
        erp.Customer_Supplier_End_Point_URL__c = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/CUVc?';
        insert erp;
        test.startTest();
        GenerateHansaAccessToken.generateAccessToken();
        test.stopTest();
    }
}