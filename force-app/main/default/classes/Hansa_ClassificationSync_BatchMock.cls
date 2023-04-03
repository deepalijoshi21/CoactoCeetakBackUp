@isTest
public class Hansa_ClassificationSync_BatchMock implements HttpCalloutMock { 
    public HTTPResponse respond(HTTPRequest req) {        
        HttpResponse res = new HttpResponse();
        
        System.assertEquals('POST', req.getMethod());
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(201);
        return res;
            
        
    }
}