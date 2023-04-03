@isTest
global class triggerCalloutmock implements HttpCalloutMock{
   
    private Integer statusCode;

    public triggerCalloutmock(Integer statusCode){
        this.statusCode = statusCode;
    }
    global HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(this.statusCode);
        res.setHeader('Content-Type','application/x-www-form-urlencoded');
        

        string body='<?xml version=\'1.0\' encoding=\'UTF-8\' standalone=\'yes\'?>\r\n<data  register=\"ABSCUINVc\" sequence=\"11920070\" url=\"/api/1/ABSCUINVc/BS-NOV-T3\" systemversion=\"8.5.34.3235\">\r\n <ABSCUINVc> <CUArtCode>72003x2</CUArtCode> <ArtCode>SBW-47486-ZA70CE69-2</ArtCode> <CustCode>53625</CustCode> <Addr0>Complex Cold Forming Ltd</Addr0> <Spec>test part customer record</Spec> <Spec1>DELIVERY NOTES TO BE CONTAINED INSIDE THE CARTON</Spec1> <CUSpec>27 X 1 BONDED WASHER ACM 70 + PHOSPHATED STEEL (EDR47486PROD)</CUSpec> <BagQty>500.00</BagQty> <BoxQty>50.00</BoxQty> <rows></rows> </ABSCUINVc>\r\n</data>';
        res.setBody(body);
        return res; 
    }
}