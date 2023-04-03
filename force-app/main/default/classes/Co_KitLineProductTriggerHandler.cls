/**
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* Description	:	Helper class for "Co_ProjectTrigger" Trigger. sync RecipeLine after Recipe is created
* Test class	: 
* ───────────────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Coacto Salesforce   
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class Co_KitLineProductTriggerHandler  implements Queueable  {
    
    Public Set<Id> product_IdSet = new Set<Id>();
    Public Map<Id,Product2> oldMap = new Map<Id,Product2>();
    
    // CONSTRUCTOR
    public Co_KitLineProductTriggerHandler(Set<Id> pdIdSet){
        this.product_IdSet = pdIdSet;
    }
    
    // call QUABLE
    public void execute(QueueableContext context) {
        System.debug('@@@@@## quable 2');
        oldMap = new Map<Id,Product2>([SELECT id,Name, Product_Description__c,Ghost_Available_as_Kit__c,Ghost_Recipe_Sync_Response__c,Ghost_Recipe_Sync_Error__c  FROM product2 where Id IN: product_IdSet]);
        Co_KitLineProductTriggerHandler.bulkifyKitPost(product_IdSet);
    }
    
    // METHOD 1
    //bulkify callout
    public static void bulkifyKitPost(Set<Id> productIdSet){
        try{
            System.debug('@@@@@@@@@ Bulkify KITLine to hansa');
            RunOnce.productTrigger = false; 
            
            list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Turn_of_Product_Sync__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
            if(!customSettting[0].Turn_of_Product_Sync__c){
                system.debug('productIdSet>>'+!productIdSet.isEmpty());
                system.debug('isBatch>>'+!System.isBatch());
                if(!productIdSet.isEmpty()){
                    if(!System.isBatch()){
                        //Check related Kit records and call method to sync to HANSA
                        for(Kit_Part__c kitPt : [SELECT id, Recipe_Row_Ref__c,Qty_per_Kit__c,Product_Name__r.Name,Kit_Part__c,Kit_Part__r.Name,Kit_Part__r.Ghost_Product_created_on_Hansa__c,Ghost_Parent_is_Active_Kit__c,Ghost_KP_created_on_Hansa__c from Kit_Part__c where Kit_Part__c!=null AND Product_Name__c IN:productIdSet AND  Ghost_Parent_is_Active_Kit__c=True AND  Ghost_KP_created_on_Hansa__c=False AND Recipe_Row_Ref__c>=1 AND Kit_Part__r.Ghost_Product_created_on_Hansa__c=True Order by Product_Name__r.Name Limit 49999]){
                            System.debug('@@@@@@@ kitPart record: '+kitPt);
                            Co_KitLineProductTriggerHandler.patchRecipeLineToHansa(kitPt.id);
                        }
                    }
                }    
            }
        }
        catch(Exception ex){
            System.debug('@@@@@@ EXCEPTION rline=> '+ex.getLineNumber()+' '+ex.getCause()+' '+ex.getMessage());
        }
    }
    
    
    // METHOD 3
    // PATCH RECIPE LINES for first time
    @future (callout=true)
    public static void patchRecipeLineToHansa(Id kitId){
        RunOnce.kpTriggerCheck = false; // not run Kit Part Trigger**
        
        System.debug('@@@@@@@@@ Patch recipe line to hansa => '+kitId);
        System.debug('####@@@ Start Recipe Line sync');
        RunOnce.accountTrigger = false;
        string hansaAccessToken = '';
        list<Kit_Part__c> KitListToUpdate_res = new List<Kit_Part__c>();
        
        // Generate Hansa Token(Start)
        if(!test.isRunningTest()){
            System.debug('@@@@@@@@@ => RL GET TOKEN');
            hansaAccessToken = GenerateHansaAccessToken.generateAccessToken();
        }else{
            hansaAccessToken = 'Test hansa token'; 
        }
        system.debug('@@@@@@@@ hansaAccessToken => '+hansaAccessToken);
        
        // IF TOKEN FOUND SUCCESSFULLY ***
        if(hansaAccessToken != '' && hansaAccessToken != null  && hansaAccessToken != 'Error in Access Token Request'){            
            Kit_Part__c kitPt = [SELECT id, Recipe_Row_Ref__c,Qty_per_Kit__c,Product_Name__r.Name,Kit_Part__c,Kit_Part__r.Name,Kit_Part__r.Ghost_Product_created_on_Hansa__c,Ghost_Parent_is_Active_Kit__c,Ghost_KP_created_on_Hansa__c from Kit_Part__c where Id=:kitId Limit 1];
            system.debug('@@@@@ RL Kit Records ==> '+kitPt);
            
            try{
                string endPointURL = '';
                string fieldsValue = ''; 
                string ceetakLocation = '';
                string salesArea = '';
                string customerCategory = ''; 
                string herokuEndPoint = 'https://erp-sync.herokuapp.com/getItem';
                
                fieldsValue += 'set_field.SalesForceID=' + kitPt.id;
                // FILL HANSA REQUIRED FIELDS**
                
                list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Turn_of_Product_Sync__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
                //String tempEndPoint = customSettting[0].Product_End_Point_URL__c;
                String tempEndPoint = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/RecVc/'+kitPt.Product_Name__r.Name+'?set_row_field.'+kitPt.Recipe_Row_Ref__c+'.Item='+kitPt.Kit_Part__r.Name+'&set_row_field.'+kitPt.Recipe_Row_Ref__c+'.InQty='+kitPt.Qty_per_Kit__c;
                endPointURL = tempEndPoint;             
                
                system.debug('@@@@ RL FINAL endPointURL ==> '+endPointURL);
                
                if(endPointURL != '' && fieldsValue!=''){  
                    string domainUrl = endPointURL;
                    string body = 'authorizationToken='+EncodingUtil.urlEncode(hansaAccessToken,'UTF-8') + '&endPointURL='+EncodingUtil.urlEncode(domainUrl,'UTF-8')  + '&jsonBody='+EncodingUtil.urlEncode(fieldsValue,'UTF-8');
                    system.debug('@@@@@@####@ RL body ===> '+body);
                    system.debug('@@@@@@#### RL fieldsValue===> '+fieldsValue);
                    system.debug('@@@@@@#### RL herokuEndPoint ===> '+herokuEndPoint);
                    
                    Http customerReq = new Http();
                    HttpRequest customerData = new HttpRequest();
                    customerData.setMethod('POST');
                    customerData.setEndpoint(herokuEndPoint); 
                    customerData.setTimeout(120000);  
                    customerData.setHeader('Content-Type','application/x-www-form-urlencoded');
                    customerData.setBody(body);                    
                    // Callout to Heroku for Patch request
                    HTTPResponse res;
                    // Send Request
                    System.debug('@@@@@@@@@ RL Req body befor calling => '+customerData);
                    res = customerReq.send(customerData);
                    System.debug('@@@@@@@@@ RL Res body After calling => '+res);
                    
                    if(res != null && res.getStatusCode() != null){
                        kitPt.Hansa_Status_Code__c = string.valueOf(res.getStatusCode());
                    }
                    if(res != null && res.getBody() != null){
                        System.debug('@@@@ RL BODY: '+res.getBody()); 
                        System.debug('@@@@ RL STATUS:'+res.getStatus());
                        System.debug('@@@@ RL STATUS_CODE:'+res.getStatusCode());
                        
                        map<string,Object> obj = (map<string,Object>)JSON.deserializeUntyped(res.getBody());
                        kitPt.Hansa_Status_Code__c = string.valueOf(obj.get('statusCode'));
                        kitPt.Hansa_JSON_Body__c = string.valueOf(obj.get('body'));
                        kitPt.Hansa_Sync_Error__c = false;
                        kitPt.Hansa_Last_Sync_Date__c = system.today();
                    }
                    KitListToUpdate_res.add(kitPt);
                }
                else{
                    System.debug('@######## RL empty endpoint ot field set for UPDATE');
                }
                
                if(!KitListToUpdate_res.isEmpty()){
                    System.debug('@@@@### update kit response => '+KitListToUpdate_res);
                    database.update(KitListToUpdate_res,false);
                }
            }
            catch(Exception ex){
                system.debug('####### RL EXCEPTION ENCOUNTERED line: => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
            }   
        }
    }
}