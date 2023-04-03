/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Description	:	Helper class for "coacto_KitPart_Trigger" Trigger sync to Hansa
* Test class	: 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Coacto Salesforce   
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class Co_KitPartTriggerHandler {
    
    // MTHOD 1: BULKIFY
    // DESCRIPTON: Prepare set for hansle bulk callout
    public static void handleBulForNewKit(Set<Id> kitPartSet){        
        System.debug('@@@@@@@@ check bulkify ');
        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,Turn_of_Kit_Part_Sync__c,name,Turn_of_Product_Sync__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
        
        //UPDATE CUSTOM SETTING TO with kitParts check
        if(!customSettting[0].Turn_of_Kit_Part_Sync__c){
            if(!kitPartSet.isEmpty()){
                if(!System.isFuture() && !System.isBatch()){
                    //If future is allowed, batch up Product ids into batches of 25.
                    Integer i = 0;
                    Set<Id> kitIdsToProcessBatch = new Set<Id>();
                    for(String kitId : kitPartSet){
                        kitIdsToProcessBatch.add(kitId);
                        i++;
                        if(i == 25){
                            System.debug('@@@@@@@@ 25 done');
                            if(!kitIdsToProcessBatch.isEmpty()){
                                System.debug('@@@@@@@@ call Put for 25 ');
                                // NEW
                                Co_KitPartTriggerHandler.postToHansaKit(kitIdsToProcessBatch);
                            }
                            kitIdsToProcessBatch = new Set<Id>();
                            i = 0;
                        }
                    }
                    
                    System.debug('@@@@@@@@ Not 25 bulk ');
                    if(!kitIdsToProcessBatch.isEmpty()){
                        System.debug('@@@@@@@@ call put ');
                        Co_KitPartTriggerHandler.postToHansaKit(kitIdsToProcessBatch);
                    }
                }
            }    
        }
    }
    
    //METHOD 2: 
    // Patch Recipe to HANSA for new and update of RecipeLine
    @future (callout=true)
    public static void postToHansaKit(set<Id> kitIdSet){ 
        System.debug('@@@@@### call Kit post sync method ');
        boolean devStop = false;
        string hansaAccessToken = '';
        list<Kit_Part__c> kitList_ToUpdate = new List<Kit_Part__c>();
        
        // Generate Hansa Token(Start)
        if(!test.isRunningTest()){
            System.debug('@@@@@@@@@ GET TOKEN');
            hansaAccessToken = GenerateHansaAccessToken.generateAccessToken();
        }else{
            hansaAccessToken = 'Test hansa token'; 
        }
        system.debug('@@@@@@@@ hansaAccessToken=> '+hansaAccessToken);
        
        // IF TOKEN FOUND SUCCESSFULLY ***
        if(hansaAccessToken != '' && hansaAccessToken != null  && hansaAccessToken != 'Error in Access Token Request'){            
            string psQuery = 'SELECT Id, Name, Kit_Part__c,Ghost_KP_created_on_Hansa__c,Kit_Part__r.Name,Recipe_Row_Ref__c, Product_Family__c, Product_Name__c, Qty_per_Kit__c, Product_Name__r.Name, Hansa_Status_Code__c, Hansa_JSON_Body__c, Hansa_Last_Sync_Date__c, Hansa_Sync_Error__c from Kit_Part__c where Id IN: kitIdSet';
            system.debug('@@@@@ Kit Query ==> '+psQuery);
            list<Kit_Part__c> kitRecords_list = database.query(psQuery);
            system.debug('@@@@@ Kit  Records List ==> '+kitRecords_list);
            
            for(Kit_Part__c kitOb : kitRecords_list){
                // try{
                string endPointURL = '';
                string fieldsValue = ''; 
                string ceetakLocation = '';
                string salesArea = '';
                string customerCategory = ''; 
                string herokuEndPoint  = '';
                
                // FILL HANSA REQUIRED FIELDS**
                if(!kitOb.Ghost_KP_created_on_Hansa__c){
                    Integer tempSNo = Integer.valueOf(kitOb.Recipe_Row_Ref__c);
                    list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Turn_of_Product_Sync__c,Kit_Part_Patch_URL__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
                    String endPointURL1 = customSettting[0].Kit_Part_Patch_URL__c;
                    //endPointURL = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/RecVc';
                    endPointURL = endPointURL1+kitOb.Product_Name__r.Name+'?set_row_field.'+tempSNo+'.Item='+kitOb.Kit_Part__r.Name+'&set_row_field.'+tempSNo+'.InQty='+kitOb.Qty_per_Kit__c;
                    
                    herokuEndPoint = 'https://erp-sync.herokuapp.com/getItem';
                    if(kitOb.Id != null){                            
                        fieldsValue += 'set_field.SalesForceID=' +kitOb.Id;
                    }
                }
                
                //FILL REST OF THE MAPPING**
                system.debug('@@@@ Kit FINAL endPointURL ==> '+endPointURL);
                
                if(endPointURL != '' && fieldsValue!=''){  
                    system.debug('@@@@@@#### Kit fieldsValue===> '+fieldsValue);                    
                    string domainUrl = endPointURL;
                    string body = 'authorizationToken='+EncodingUtil.urlEncode(hansaAccessToken,'UTF-8') + '&endPointURL='+EncodingUtil.urlEncode(domainUrl,'UTF-8')  + '&jsonBody='+EncodingUtil.urlEncode(fieldsValue,'UTF-8');
                    system.debug('@@@@@@####@ body ===> '+body);
                    system.debug('@@@@@@#### fieldsValue===> '+fieldsValue);
                    system.debug('@@@@@@#### herokuEndPoint ===> '+herokuEndPoint);
                    
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
                    System.debug('@@@@@@@@@ Req body befor calling => '+customerData);
                    res = customerReq.send(customerData);
                    System.debug('@@@@@@@@@ Res body After calling => '+res);
                    
                    if(res != null ){
                        if(res.getStatusCode() != null){
                            kitOb.Hansa_Status_Code__c = string.valueOf(res.getStatusCode());
                        }
                        if(res.getBody() != null){
                            System.debug('@@@@ BODY: '+res.getBody()); 
                            System.debug('@@@@ STATUS:'+res.getStatus());
                            System.debug('@@@@ STATUS_CODE:'+res.getStatusCode());
                            if(res.getStatusCode() != 200){
                                kitOb.Hansa_Sync_Error__c = True;
                            }
                            else
								kitOb.Hansa_Sync_Error__c = False;   
                            map<string,Object> obj = (map<string,Object>)JSON.deserializeUntyped(res.getBody());
                            kitOb.Hansa_Status_Code__c = string.valueOf(obj.get('statusCode'));
                            kitOb.Hansa_JSON_Body__c = string.valueOf(obj.get('body'));
                            kitOb.Hansa_Last_Sync_Date__c = system.today();
                        }
                        else{
                            System.debug('@######## empty RESPONSE ');
                        }
                        kitList_ToUpdate.add(kitOb);
                    }
                }
                else{
                    System.debug('@@@@@@@ ==>>> ENDPOINT NOT DEFINE OR FIELD SET EMPTY ');
                }
            } 
            
        }// IF TOKEN NOT FOUND ***
        else if(hansaAccessToken == '' || hansaAccessToken == null  || hansaAccessToken == 'Error in Access Token Request'){
            System.debug('@@@@@@@ TOKEN NOT FOUND '); 
            for(Kit_Part__c kitOb2 : [select id,Hansa_JSON_Body__c,Hansa_Status_Code__c from Kit_Part__c where id in : kitIdSet]){
                kitOb2.Hansa_JSON_Body__c = 'Error in hansa token request, Token = '+hansaAccessToken;
                kitOb2.Hansa_Sync_Error__c = true;
                kitList_ToUpdate.add(kitOb2);
            }
        }
        
        system.debug('@@@@@@@ kitList_ToUpdate=> '+kitList_ToUpdate);
        if(!kitList_ToUpdate.isEmpty()){
            database.update (kitList_ToUpdate,false);
        }      
    } 
    
    //METHOD 3:
    public static void setSerialNo(List<Kit_Part__c> newList){
        Map<String, Integer> productVsSrNo_Map = new Map<String, Integer>();
        System.debug('@@@@@ Serial No. logic => '+ newList);
        for(Kit_Part__c kp: newList){
            if(kp.Product_Name__c!=null){
                productVsSrNo_Map.put(kp.Product_Name__c,0);
            }
        }
        // get products current serial no.
        for(Product2 prd : [SELECT id, Name,(SELECT id,Recipe_Row_Ref__c from Kit_Parts__r where Recipe_Row_Ref__c!=null Order by Recipe_Row_Ref__c DESC limit 1) from Product2 where id IN: productVsSrNo_Map.keySet()]){
            if(prd.Kit_Parts__r.size()!=0){
                if(prd.Kit_Parts__r[0].Recipe_Row_Ref__c==0)
                    productVsSrNo_Map.put(prd.Id,0);
                else
                    productVsSrNo_Map.put(prd.Id,Integer.valueOf(prd.Kit_Parts__r[0].Recipe_Row_Ref__c));    
            }
            
        }
        
        System.debug('@@@@@@@ MAP '+productVsSrNo_Map);
        for(Kit_Part__c kp: newList){
            if(kp.Product_Name__c!=null){
                kp.Recipe_Row_Ref__c = Integer.valueOf(productVsSrNo_Map.get(kp.Product_Name__c))+1;
                productVsSrNo_Map.put(kp.Product_Name__c,Integer.valueOf(kp.Recipe_Row_Ref__c));
            }
            else
                kp.Recipe_Row_Ref__c = 0;
        }
        System.debug('@@@@@ Final KP LIST => '+newList);
    }
}