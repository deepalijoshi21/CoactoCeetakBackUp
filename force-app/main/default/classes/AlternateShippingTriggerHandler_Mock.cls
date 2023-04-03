public class AlternateShippingTriggerHandler_Mock implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String jsonBody = '{"statusCode":200,"body":"<?xml version=\'1.0\' encoding=\'UTF-8\' standalone=\'yes\'?>\r\n<data register=\"DelAddrVc\">\r\n<DelAddrVc>\r\n<UUID>E9AEA6BE-C2757E52-EECBCB4D-80BFA87E-E836D2E6</UUID>\r\n<ServerSequence>0</ServerSequence>\r\n<SyncFlags>1</SyncFlags>\r\n<CustCode>55479</CustCode>\r\n<Name>test5678 account 8th oct</Name>\r\n<DelCode>1881</DelCode>\r\n<Comment>aaaaaa</Comment>\r\n<DelAddr0>bbbbbbb</DelAddr0>\r\n<DelAddr1>ddddd</DelAddr1>\r\n<DelAddr2>cccccccc</DelAddr2>\r\n<DelAddr3>ssssss</DelAddr3>\r\n<DelAddr4>66666</DelAddr4>\r\n<Region></Region>\r\n<Class></Class>\r\n<Closed>0</Closed>\r\n<Contact></Contact>\r\n<Phone></Phone>\r\n<Fax></Fax>\r\n<Email></Email>\r\n<PriceList></PriceList>\r\n<InvoiceBase>0</InvoiceBase>\r\n<IncludeOriginalItem>0</IncludeOriginalItem>\r\n<IncludePeriod>0</IncludePeriod>\r\n<AddEmptyLine>0</AddEmptyLine>\r\n<UseAsQty>0</UseAsQty>\r\n<GroupInvoice>0</GroupInvoice>\r\n<IncludeSite>0</IncludeSite>\r\n<InclCustOrdNr>0</InclCustOrdNr>\r\n<InclRentResNo>0</InclRentResNo>\r\n<OnePerReservation>0</OnePerReservation>\r\n<TaxTemplateCode></TaxTemplateCode>\r\n<Sorting></Sorting>\r\n<DelCountry>YE\u0000</DelCountry>\r\n<FreightCode></FreightCode>\r\n<VATCode></VATCode>\r\n<ExportFlag>0</ExportFlag>\r\n<RecipientGLN></RecipientGLN>\r\n<RecipientDepartment></RecipientDepartment>\r\n<DelCountryName>Yemen</DelCountryName>\r\n</DelAddrVc>\r\n</data>\r\n","headers":{"date":"Mon, 12 Oct 2020 13:08:06 GMT","set-cookie":["HSESSION=3C44F2F0-7F1E1F52-72BA391D-2532DEB4-7830E9E6;Comment=Session ID;Path=/;"],"cache-control":"no-cache, no-store, must-revalidate","content-type":"text/html; charset=UTF-8","content-length":"1277","last-modified":"Mon, 12 Oct 2020 13:08:06 GMT","connection":"close"},"request":{"uri":{"protocol":"https:","slashes":true,"auth":null,"host":"ceetaktest.itsiltd.co.uk:3002","port":"3002","hostname":"ceetaktest.itsiltd.co.uk","hash":null,"search":"?custcode=55479&delcode=1881","query":"custcode=55479&delcode=1881","pathname":"/WebSFDelAddrVc.hal","path":"/WebSFDelAddrVc.hal?custcode=55479&delcode=1881","href":"https://ceetaktest.itsiltd.co.uk:3002/WebSFDelAddrVc.hal?custcode=55479&delcode=1881"},"method":"PATCH","headers":{"Content-Type":"text/xml","Authorization":"Bearer 0B2F8700-551A02A0-786831B9-B5B7CF5C-2DF339BE","content-length":25}}}';
        String body ='<?xml version=\'1.0\' encoding=\'UTF-8\' standalone=\'yes\'?>'+
            '<data register="DelAddrVc">'+
            '<DelAddrVc>'+
            '<UUID>E9AEA6BE-C2757E52-EECBCB4D-80BFA87E-E836D2E6</UUID>'+
            '<ServerSequence>0</ServerSequence>'+
            '<SyncFlags>1</SyncFlags>'+
            '<CustCode>55479</CustCode>'+
            '<Name>test5678 account 8th oct</Name>'+
            '<DelCode>1881</DelCode>'+
            '<Comment>aaaaaa</Comment>'+
            '<DelAddr0>bbbbbbb</DelAddr0>'+
            '<DelAddr1></DelAddr1>'+
            '<DelAddr2>cccccccc</DelAddr2>'+
            '<DelAddr3>ssssss</DelAddr3>'+
            '<DelAddr4>66666</DelAddr4>'+
            '<Region></Region>'+
            '<Class></Class>'+
            '<Closed>0</Closed>'+
            '<Contact></Contact>'+
            '<Phone></Phone>'+
            '<Fax></Fax>'+
            '<Email></Email>'+
            '<PriceList></PriceList>'+
            '<InvoiceBase>0</InvoiceBase>'+
            '<IncludeOriginalItem>0</IncludeOriginalItem>'+
            '<IncludePeriod>0</IncludePeriod>'+
            '<AddEmptyLine>0</AddEmptyLine>'+
            '<UseAsQty>0</UseAsQty>'+
            '<GroupInvoice>0</GroupInvoice>'+
            '<IncludeSite>0</IncludeSite>'+
            '<InclCustOrdNr>0</InclCustOrdNr>'+
            '<InclRentResNo>0</InclRentResNo>'+
            '<OnePerReservation>0</OnePerReservation>'+
            '<TaxTemplateCode></TaxTemplateCode>'+
            '<Sorting></Sorting>'+
            '<DelCountry>YE</DelCountry>'+
            '<FreightCode></FreightCode>'+
            '<VATCode></VATCode>'+
            '<ExportFlag>0</ExportFlag>'+
            '<RecipientGLN></RecipientGLN>'+
            '<RecipientDepartment></RecipientDepartment>'+
            '<DelCountryName>Yemen</DelCountryName>'+
            '</DelAddrVc>'+
            '</data>';
        
        res.setHeader('Content-Type', 'text/xml');
        req.setHeader('Accept','text/xml');
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}