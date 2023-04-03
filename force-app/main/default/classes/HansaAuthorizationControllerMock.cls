/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────┐
* Mock Class for HansaAuthorizationController
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
public class HansaAuthorizationControllerMock implements HttpCalloutMock {
  
    public HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"02817260-0D91A138-B9AA887B-E06266AE-7D8861BC","token_type":"bearer","expires_in":3600,"refresh_token":"55CAEF70-35F03D90-A00DA804-F2FA789E-5F6B3A69"}');
        res.setStatusCode(200);
        
        return res;
    }
}