/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────┐
* Controller of VF page(HansaAuthorization). This class is used to generate refresh token for Hansa ERP
* ───────────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-04-03
* @modified       2020-04-06
* ─────────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class HansaAuthorizationController {
    public boolean errorFlag{get;set;}
    public string errorMessage{get;set;}
    public boolean mainPanel{get;set;}
    public boolean successPanel{get;set;}
    public HansaAuthorizationController(){
        errorFlag = false;
        errorMessage = '';
        mainPanel = true;
        successPanel = false;
    }
    public pagereference authenticate(){
        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Access_Token_URI__c,Authorization_URI__c,Client_Identification__c,Client_Secret__c,Redirect_URI__c,Refresh_Token__c from Hansa_ERP__c where name = 'Refresh Token']);
        if(!customSettting.isEmpty()){
            pagereference p = new pagereference('https://standard-id.hansaworld.com/oauth-authorize?response_type=code&client_id='+customSettting[0].Client_Identification__c+'&redirect_uri='+customSettting[0].Redirect_URI__c);
            return p;
        }else{
            errorFlag = true;
            errorMessage = 'Custom Setting not found. Please contact system administrator!!';  
            return null;
        }         
    }
    public void errorClose(){
        errorFlag = false;
        errorMessage = ''; 
    }
    
    public void OnLoadController(){
        string code = '';
        string error = '';
        if(apexpages.currentpage().getparameters().containsKey('code')){
            code = apexpages.currentpage().getparameters().get('code');
        }
        if(apexpages.currentpage().getparameters().containsKey('error')){
            error = apexpages.currentpage().getparameters().get('error');
        }        
        system.debug('code+++'+code);
        system.debug('error+++'+error);
        if(code != null && code != ''){
            mainPanel = false;
            
            list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Access_Token_URI__c,Authorization_URI__c,Client_Identification__c,Client_Secret__c,Redirect_URI__c,Refresh_Token__c from Hansa_ERP__c where name = 'Refresh Token']);
            if(!customSettting.isEmpty()){
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint(customSettting[0].Access_Token_URI__c);                           
                req.setBody('grant_type=authorization_code' + 
                            '&client_secret=' + customSettting[0].Client_Secret__c + 
                            '&client_id='+ customSettting[0].Client_Identification__c +             
                            '&redirect_uri=' + customSettting[0].Redirect_URI__c + 
                            '&code=' + code);
                
                Http http = new Http();
                HTTPResponse res;
                res = http.send(req);
                System.debug('BODY: '+res.getBody()); 
                System.debug('STATUS:'+res.getStatus());
                System.debug('STATUS_CODE:'+res.getStatusCode());
                if(res.getStatusCode() == 200 && res.getBody() !=null){
                    Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    if(responseBody.containsKey('refresh_token')){
                        customSettting[0].Refresh_Token__c = string.valueOf(responseBody.get('refresh_token'));
                        try{
                            update customSettting[0];
                        }catch(Exception e){
                            system.debug('Exception Line Number '+e.getLineNumber());
                            system.debug('Exception Message '+e.getMessage());
                            errorFlag = true;
                            errorMessage = e.getMessage() + ' - ' +e.getLineNumber();                        
                        }
                        successPanel = true;
                    }
                    if(responseBody.containsKey('error')){
                        errorFlag = true;
                        errorMessage = 'Error in hansa authorization. Error Body-' + responseBody.get('error')+'. Please review your custom setting or contact your system administrator!!';
                    }
                }else{
                    errorFlag = true;
                    errorMessage = 'Error in hansa authorization. Error Body-' + res.getBody() + ' Error Code-' + res.getStatusCode();    
                }                    
                
            }else{
                errorFlag = true;
                errorMessage = 'Custom Setting not found. Please contact system administrator!!';  
            } 
            
        }
        if(error != null && error != ''){
            errorFlag = true;
            errorMessage = error + '. Please contact system administrator!!'; 
        }
    }
    
    public pagereference homePage(){
        pagereference p = new pagereference('/home/home.jsp');
        return p;        
    }
}