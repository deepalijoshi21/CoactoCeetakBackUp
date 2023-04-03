/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is used to generate access token using refresh token for Hansa ERP
* ───────────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-04-07
* @modified       2020-04-07
* ─────────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class GenerateHansaAccessToken {
    public static string generateAccessToken(){
        try{
            list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Access_Token_URI__c,Authorization_URI__c,Client_Identification__c,Client_Secret__c,Redirect_URI__c,Refresh_Token__c from Hansa_ERP__c where name = 'Refresh Token']);
            if(!customSettting.isEmpty()){
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint(customSettting[0].Access_Token_URI__c);     
                req.setBody('grant_type=refresh_token'+ 
                            '&client_secret='+customSettting[0].Client_Secret__c +
                            '&client_id='+customSettting[0].Client_Identification__c +       
                            '&refresh_token='+customSettting[0].Refresh_Token__c); 
                
                req.setTimeout(120000);            
                Http http = new Http();
                HTTPResponse res;
                res = http.send(req);
                System.debug('BODY: '+res.getBody()); 
                System.debug('STATUS:'+res.getStatus());
                System.debug('STATUS_CODE:'+res.getStatusCode());
                if(res.getStatusCode() == 200 && res.getBody() !=null){
                    Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    if(responseBody.containsKey('access_token')){
                        return string.valueOf(responseBody.get('access_token'));                
                    }
                    if(responseBody.containsKey('error')){
                        return 'Error in Access Token Request'; 
                    }
                }            
            }
            return null;
        }
        catch(Exception ex){
            System.debug('@@@@@ ACCESS TOKEN EXCEPTION ENCOUNTERED ');
            String err='';
            err='Error in Access Token Request : '+ex.getCause()+' \nLine: '+ex.getLineNumber()+' \n message: '+ex.getMessage();
            return err;
        }        
    }
}