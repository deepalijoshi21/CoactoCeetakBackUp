/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Description	:	Helper class for "Co_ProjectTrigger" Trigger
* Test class	: 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Coacto Salesforce   
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class Co_KitProductTriggerHandler implements Queueable  {
    
    Public Set<Id> product_IdSet = new Set<Id>();
    Public Map<Id,Product2> oldMap = new Map<Id,Product2>();
    
    // CONSTRUCTOR
    public Co_KitProductTriggerHandler(Set<Id> pdIdSet){
        this.product_IdSet = pdIdSet;
    }
    
    // call QUABLE
    public void execute(QueueableContext context) {
        System.debug('@@@@@## quable 1');
        oldMap = new Map<Id,Product2>([SELECT id,Name, Product_Description__c,Ghost_Available_as_Kit__c,Ghost_Recipe_Sync_Response__c,Ghost_Recipe_Sync_Error__c  FROM product2 where Id IN: product_IdSet]);
        Co_KitProductTriggerHandler.bulkifyKitPost(product_IdSet);
    }
    
    // METHOD 1
    //bulkify callout
    public static void bulkifyKitPost(Set<Id> productIdSet){
        System.debug('@@@@@@@@@ Bulkify Recipe to hansa');
        RunOnce.productTrigger = false; 
        
        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Turn_of_Product_Sync__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
        if(!customSettting[0].Turn_of_Product_Sync__c){
            if(!productIdSet.isEmpty()){
                if(!System.isBatch()){
                    //If future is allowed, batch up Product ids into batches of 25.
                    Integer i = 0;
                    Set<Id> prodIdsToProcessBatch = new Set<Id>();
                    for(String prodId : productIdSet){
                        prodIdsToProcessBatch.add(prodId);
                        i++;
                        if(i == 25){
                            System.debug('@@@@@@@@ 25 done');
                            if(!prodIdsToProcessBatch.isEmpty()){
                                System.debug('@@@@@@@@ call Put for 25 ');
                                // NEW
                                Co_KitProductTriggerHandler.postKitToHansa(prodIdsToProcessBatch);
                            }
                            prodIdsToProcessBatch = new Set<Id>();
                            i = 0;
                        }
                    }
                    
                    System.debug('@@@@@@@@ Not 25 bulk ');
                    if(!prodIdsToProcessBatch.isEmpty()){
                        System.debug('@@@@@@@@ call put ');
                        Co_KitProductTriggerHandler.postKitToHansa(prodIdsToProcessBatch);
                    }
                }
            }    
        }
    }
    
    // METHOD 2
    // post to Hansa
    @future (callout=true)
    public static void postKitToHansa(Set<Id> productIdSet){
        RunOnce.allowFurure_ProdKitLine = True;
        RunOnce.productTrigger = false; 
        System.debug('@@@@@@@@@ post KIT to hansa');
        try{
            RunOnce.accountTrigger = false;
            string hansaAccessToken = '';
            list<Product2> productListToUpdate = new List<Product2>();
            
            // Generate Hansa Token(Start)
            if(!test.isRunningTest()){
                System.debug('@@@@@@@@@ => GET TOKEN');
                hansaAccessToken = GenerateHansaAccessToken.generateAccessToken();
            }else{
                hansaAccessToken = 'Test hansa token'; 
            }
            system.debug('@@@@@@@@ hansaAccessToken => '+hansaAccessToken);
            
            // IF TOKEN FOUND SUCCESSFULLY ***
            if(hansaAccessToken != '' && hansaAccessToken != null  && hansaAccessToken != 'Error in Access Token Request'){            
                string productQuery = 'SELECT id, Name, Product_Description__c,Ghost_Available_as_Kit__c,Ghost_Recipe_Sync_Response__c,Ghost_Recipe_Sync_Error__c  FROM product2 where Id IN: productIdSet';
                system.debug('@@@@@ Kit productQuery ==> '+productQuery);
                list<Product2> productRecords_list = database.query(productQuery);
                system.debug('@@@@@ Kit product Records ==> '+productRecords_list);
                
                for(Product2 prod : productRecords_list){
                    try{
                        string endPointURL = '';
                        string fieldsValue = ''; 
                        string ceetakLocation = '';
                        string salesArea = '';
                        string customerCategory = ''; 
                        // FILL HANSA REQUIRED FIELDS**                            
                        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Turn_of_Product_Sync__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
                        //endPointURL = customSettting[0].Product_End_Point_URL__c;
                        endPointURL = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/RecVc?set_field.Code='+prod.Name+'&set_field.Comment='+prod.Product_Description__c+'&set_row_field.0.Item='+prod.Name+'&set_row_field.0.OutQty=1';
                        
                        system.debug('@@@@ FINAL endPointURL ==> '+endPointURL);
                        
                        if(endPointURL != ''){  
                            system.debug('@@@@@@####  Recipe fieldsValue ');
                            HttpRequest req = new HttpRequest();
                            req.setMethod('POST');
                            req.setHeader('Authorization','Bearer '+hansaAccessToken);
                            req.setEndpoint(endPointURL);
                            //req.setBody(fieldsValue);
                            req.setHeader('Content-Type','application/x-www-form-urlencoded');
                            req.setTimeout(120000);             
                            Http http = new Http();
                            HTTPResponse res;
                            // Send Request
                            System.debug('@@@@@@@@@  Recipe Req body befor calling => '+req);
                            res = http.send(req); 
                            System.debug('@@@@@@@@@  Recipe Res body After calling => '+res);

                            if(res != null && res.getBody() != null){
                                System.debug('@@@@ r BODY: '+res.getBody()); 
                                System.debug('@@@@ r STATUS:'+res.getStatus());
                                System.debug('@@@@ r STATUS_CODE:'+res.getStatusCode());
                                prod.Ghost_Recipe_Sync_Response__c = res.getBody();
                                //prod.Hansa_Last_Sync_Date__c = system.today();
                                
                                if(res.getStatusCode() == 200){
                                    Dom.Document doc = new Dom.Document();
                                    doc.load(res.getBody());                        
                                    Dom.XMLNode dataRegister = doc.getRootElement();
                                    if(dataRegister.getChildElement('RecVc', null) != null){
                                        for (Dom.XMLNode child: dataRegister.getChildElement('RecVc', null).getChildElements()) {
                                            if(child.getName() == 'Code'){
                                                prod.Ghost_Available_as_Kit__c = True;
                                                prod.Ghost_Recipe_Sync_Error__c = false;    
                                                prod.Kit_Number_Hansa__c = '1';
                                            }
                                        }  
                                    }
                                }
                                else{
                                    system.debug('@@@@@@@@@  Recipe status code not 200 ');
                                    prod.Ghost_Recipe_Sync_Error__c = True;    
                                }
                            }
                            productListToUpdate.add(prod);
                        }
                        else{
                            System.debug('@@@@@@@ ==>>> Recipe  ENDPOINT NOT DEFINE OR FIELD SET EMPTY ');
                        }
                        
                    }
                    catch(exception ex){
                        system.debug('@@@@@@@ EXCEPTION  Recipe ENCOUNTERED line: => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
                        prod.Ghost_Recipe_Sync_Error__c = true; 
                        prod.Ghost_Recipe_Sync_Response__c = 'Line: '+ex.getLineNumber()+'  msg: '+ex.getMessage()+' cause: '+ex.getCause();
                        productListToUpdate.add(prod);
                    }
                } 
                
            }// IF TOKEN NOT FOUND ***
            else if(hansaAccessToken == '' || hansaAccessToken == null  || hansaAccessToken == 'Error in Access Token Request'){
                System.debug('@@@@@@@  Recipe  TOKEN NOT FOUND '); 
                for(Product2 prod : [select id,Hansa_JSON_Body__c,Hansa_Status_Code__c from Product2 where id in : productIdSet]){
                    prod.Ghost_Recipe_Sync_Response__c = 'Error in hansa token request, Token = '+hansaAccessToken;
                    prod.Ghost_Recipe_Sync_Error__c = true;
                    productListToUpdate.add(prod);
                }
            }
            
            system.debug('@@@@@@@ product Recipe ListToUpdate=> '+productListToUpdate);
            if(!productListToUpdate.isEmpty()){
                Database.update(productListToUpdate, False);
            }
        }
        catch(Exception ex){
            system.debug('####### Recipe EXCEPTION ENCOUNTERED line: => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
        }   
    }
}