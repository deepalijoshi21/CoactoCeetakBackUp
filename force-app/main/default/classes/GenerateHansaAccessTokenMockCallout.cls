/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────┐
* Mock Class for GenerateHansaAccessToken
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
public class GenerateHansaAccessTokenMockCallout implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"DC400947-D6B35512-5B0822A2-A1094DF3-02BF11CE","token_type":"bearer","expires_in":3600}');
        res.setStatusCode(200);
        return res;
    }
}