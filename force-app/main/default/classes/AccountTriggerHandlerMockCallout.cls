/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────┐
* Mock Class for AccountTriggerHandler
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
public class AccountTriggerHandlerMockCallout implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String body = '<?xml version=\'1.0\' encoding=\'UTF-8\' standalone=\'yes\'?>'+
            '<data  register="CUVc" sequence="5588483" url="/api/1/CUVc/55598" systemversion="8.5.33.317">'+
            '<CUVc>'+
            '<UUID>BCFF4A7C-4B87A8E7-0F030087-C9230504-A1590E60</UUID>'+
            '<SyncFlags>1</SyncFlags>'+
            '<Code>55598</Code>'+
            '<Name>Test Coacto Developer 1</Name>'+
            '<CustCat>D</CustCat>'+
            '<PayDeal>30</PayDeal>'+
            '<InterestFlag>1</InterestFlag>'+
            '<RemndrFlag>1</RemndrFlag>'+
            '<CurncyCode>GBP</CurncyCode>'+
            '<OnAccount>1</OnAccount>'+
            '<SalesMan>9</SalesMan>'+
            '<CreditLimit>0.00</CreditLimit>'+
            '<Classification>BED,9,A</Classification>'+
            '<DateChanged>2020-04-13</DateChanged>'+
            '<Password>0</Password>'+
            '<DateCreated>2020-04-13</DateCreated>'+
            '<CUType>1</CUType>'+
            '<TaxCondition>2</TaxCondition>'+
            '<Sign>COACTO</Sign>'+
            '<eInvPostage>2</eInvPostage>'+
            '<OrderLocation>BED</OrderLocation>'+
            '<SalesForceID>0013H000002WNB2QAO</SalesForceID>'+
            '</CUVc>'+
            '</data>';
        res.setHeader('Content-Type', 'text/xml');
        req.setHeader('Accept','text/xml');
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}