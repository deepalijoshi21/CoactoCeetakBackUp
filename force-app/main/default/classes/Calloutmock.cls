@isTest
global class Calloutmock implements HttpCalloutMock{
    global HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setHeader('Content-Type','application/x-www-form-urlencoded');
        
        
        string body='<?xml version=\'1.0\' encoding=\'UTF-8\' standalone=\'yes\'?>\r\n<data  register=\"INVc\" sequence=\"11920070\" url=\"/api/1/INVc/BS-NOV-T3\" systemversion=\"8.5.34.3235\">\r\n <INVc>\r\n  <UUID>CDAE84B0-FECC509D-69C7F8BC-974EEAC3-2DB29825</UUID>\r\n  <SyncFlags>1</SyncFlags>\r\n  <Code>BS-NOV-T3</Code>\r\n  <Name>BSDEVQA</Name>\r\n  <Unittext>EACH</Unittext>\r\n  <Group>GAS</Group>\r\n  <Weight>110.00</Weight>\r\n  <UpdateCost>2</UpdateCost>\r\n  <LastPriceChange>2021-11-11</LastPriceChange>\r\n  <LastBasePriceChange>2021-11-11</LastBasePriceChange>\r\n  <DispGroups>CONS</DispGroups>\r\n  <colnr>Grey</colnr>\r\n  <SRUpdateCost>2</SRUpdateCost>\r\n  <InspectionCode>NA</InspectionCode>\r\n  <InspectionName>None Required</InspectionName>\r\n  <CountryOfOrigin>Serbia</CountryOfOrigin>\r\n  <SalesForceID>01t26000009KhCnAAK</SalesForceID>\r\n  <rows></rows>\r\n </INVc>\r\n</data>';
        res.setBody(body);
        return res; 
    }
}