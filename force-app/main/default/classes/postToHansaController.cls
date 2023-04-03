/********************************************************************************************************************************
* Description	: helper call for Batch (Co_ProductTriggerHandlerBatch, Co_RecipeHelperBatch, Co_RecipeLineHelperBatch)
*********************************************************************************************************************************/
public class postToHansaController {

    // Method1 : sync product to item
    public static List<String> postToHansa_newItem(set<String> productId_Set){ 
        List<String> successResultList =new List<String>();
        try{
            System.debug('@@@@ batch** product request');
            boolean devStop = false;
            RunOnce.accountTrigger = false;
            string hansaAccessToken = '';
            list<Product2> productListToUpdate = new List<Product2>();
            map<string,string> countryNameVsCode = getCountriesCode();
            map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklist = new map<string,map<string,string>>();
            
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
                string productQuery = 'SELECT id, Inspection_Code__c, Product_Type__c, Product_Group__c,Product_Classification__c,Product_Description__c,Product_Status__c,Name, Ceetak_Drawing_No__c, Ceetak_Drawing_Rev__c, Ceetak_Material_Code__c, Material_Type__c, Unit__c, Weight_grams__c, Inspection_Name__c, Warnings__c, Country_of_Origin__c, EDI__c, EDI_Classification__c  FROM product2 where Id IN: productId_Set';
                system.debug('@@@@@ productQuery ==> '+productQuery);
                list<Product2> productRecords_list = database.query(productQuery);
                system.debug('@@@@@ product Records ==> '+productRecords_list);
                
                salesforceFieldVsSalesforceVsHansaPicklist = Co_ProductTriggerHandler.getProductCustomSettingRecords('Hansa_SF_product_Mapping__c');
                
                for(Product2 prod : productRecords_list){
                    	boolean responseCheck = false;
                    try{
                        string endPointURL = '';
                        string fieldsValue = ''; 
                        string ceetakLocation = '';
                        string salesArea = '';
                        string customerCategory = ''; 
                        // FILL HANSA REQUIRED FIELDS**
                        if(prod.Product_Group__c != null && prod.Product_Description__c!=null && prod.Product_Status__c=='Approved'){
                            
                            list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Turn_of_Product_Sync__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
                            endPointURL = customSettting[0].Product_End_Point_URL__c;
                            
                            //endPointURL = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/INVc';
                            fieldsValue += 'set_field.Group=' + prod.Product_Group__c + '&set_field.Name=' + prod.Product_Description__c + '&set_field.Code=' +prod.Name.toUpperCase();
                        }//FILL REST OF THE MAPPING**
                        
                        if(fieldsValue!='' && !devStop){
                            fieldsValue +='&set_field.SalesForceID='+prod.id;
                            
                            if(prod.Ceetak_Drawing_No__c!=null){
                                fieldsValue +='&set_field.DrawingNr='+prod.Ceetak_Drawing_No__c;
                            }
                            else
                                fieldsValue +='&set_field.DrawingNr='+'';
                            // **
                            if(prod.Ceetak_Drawing_Rev__c!=null){
                                fieldsValue +='&set_field.DrawingRev='+prod.Ceetak_Drawing_Rev__c;
                            }
                            else
                                fieldsValue +='&set_field.DrawingRev='+'';
                            // **
                            if(prod.Ceetak_Material_Code__c!=null){
                                fieldsValue +='&set_field.MaterialCode='+prod.Ceetak_Material_Code__c;
                            }
                            else
                                fieldsValue +='&set_field.MaterialCode='+'';
                            // **
                            if(prod.Material_Type__c!=null){
                                fieldsValue +='&set_field.MaterialType='+prod.Material_Type__c;
                            }
                            else
                                fieldsValue +='&set_field.MaterialType='+''; 
                            
                            if(prod.Unit__c!=null){
                                fieldsValue +='&set_field.Unittext='+prod.Unit__c;
                            }
                            else
                                fieldsValue +='&set_field.Unittext='+'';
                            // **
                            if(prod.Inspection_Name__c!=null){
                                fieldsValue +='&set_field.InspectionName='+prod.Inspection_Name__c;
                            }
                            else
                                fieldsValue +='&set_field.InspectionName='+'';
                            // **
                            if(prod.Warnings__c!=null){
                                fieldsValue +='&set_field.WarnText1='+prod.Warnings__c;
                            }
                            else
                                fieldsValue +='&set_field.WarnText1='+'';
                            // **
                            if(prod.Country_of_Origin__c!=null && countryNameVsCode.containsKey(prod.Country_of_Origin__c)){
                                //fieldsValue +='&set_field.CountryOfOrigin='+prod.Country_of_Origin__c;
                                fieldsValue +='&set_field.CountryOfOrigin='+countryNameVsCode.get(prod.Country_of_Origin__c);
                            }
                            else
                                fieldsValue +='&set_field.CountryOfOrigin='+'';
                            // **
                            if(prod.EDI__c=='Yes'){
                                String tempVal = prod.Product_Classification__c!=null?prod.Product_Classification__c:'';
                                tempVal+= prod.EDI_Classification__c!=null?','+prod.EDI_Classification__c:'';
                                fieldsValue +='&set_field.DispGroups='+tempVal;
                            }
                            else if(prod.EDI__c!='Yes' && prod.Product_Classification__c!=null){
                                fieldsValue +='&set_field.DispGroups='+prod.Product_Classification__c;
                            }
                            else
                                fieldsValue +='&set_field.DispGroups='+'';
                            
                            System.debug('salesforceFieldVsSalesforceVsHansaPicklist.containsKey(product_status__c) : '+salesforceFieldVsSalesforceVsHansaPicklist.containsKey('product_status__c'));
                            System.debug('salesforceFieldVsSalesforceVsHansaPicklist : '+salesforceFieldVsSalesforceVsHansaPicklist);
                            
                            
                            
                            // FROM CUSTOM SETTINGS
                            if(prod.Product_Status__c != null){
                                if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('product_status__c')){
                                    if(salesforceFieldVsSalesforceVsHansaPicklist.get('product_status__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('product_status__c').containsKey(prod.product_status__c)){
                                        // fieldsValue += '&set_field.ToolType=' + salesforceFieldVsSalesforceVsHansaPicklist.get('product_status__c').get(prod.product_status__c);
                                    }
                                }
                            } 
                            
                            if(prod.Product_Type__c != null){
                                if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('product_type__c')){
                                    if(salesforceFieldVsSalesforceVsHansaPicklist.get('product_type__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('product_type__c').containsKey(prod.product_type__c)){
                                        fieldsValue += '&set_field.ItemType=' + salesforceFieldVsSalesforceVsHansaPicklist.get('product_type__c').get(prod.product_type__c);
                                    }
                                }
                            } 
                            
                            if(prod.Inspection_Code__c != null){
                                if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('inspection_code__c')){
                                    if(salesforceFieldVsSalesforceVsHansaPicklist.get('inspection_code__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('inspection_code__c').containsKey(prod.inspection_code__c)){
                                        fieldsValue += '&set_field.InspectionCode=' + salesforceFieldVsSalesforceVsHansaPicklist.get('inspection_code__c').get(prod.inspection_code__c);
                                    }
                                }
                            }
                        }
                        system.debug('@@@@ FINAL endPointURL ==> '+endPointURL);
                        
                        if(endPointURL != '' && fieldsValue!=''){  
                            system.debug('@@@@@@#### fieldsValue===> '+fieldsValue);
                            HttpRequest req = new HttpRequest();
                            req.setMethod('POST');
                            req.setHeader('Authorization','Bearer '+hansaAccessToken);
                            req.setEndpoint(endPointURL);
                            req.setBody(fieldsValue);
                            req.setHeader('Content-Type','application/x-www-form-urlencoded');
                            req.setTimeout(120000);             
                            Http http = new Http();
                            HTTPResponse res;
                            // Send Request
                            System.debug('@@@@@@@@@ Req body befor calling => '+req);
                            System.debug('@@@@@@@@@ Req body => '+req.getBody());
                            res = http.send(req); 
                            System.debug('@@@@@@@@@ Res body After calling => '+res);
                            
                            if(res != null && res.getStatusCode() != null){
                                prod.Hansa_Status_Code__c = string.valueOf(res.getStatusCode());
                            }
                            if(res != null && res.getBody() != null){
                                System.debug('@@@@ BODY: '+res.getBody()); 
                                System.debug('@@@@ STATUS:'+res.getStatus());
                                System.debug('@@@@ STATUS_CODE:'+res.getStatusCode());
                                prod.Hansa_JSON_Body__c = res.getBody();
                                prod.Hansa_Last_Sync_Date__c = system.today();
                                responseCheck= true;
                                
                                if(res.getStatusCode() == 200){
                                    
                                    Dom.Document doc = new Dom.Document();
                                    doc.load(res.getBody());                        
                                    Dom.XMLNode dataRegister = doc.getRootElement();
                                    if(dataRegister.getChildElement('INVc', null) != null){
                                        for (Dom.XMLNode child: dataRegister.getChildElement('INVc', null).getChildElements()) {
                                            if(child.getName() == 'Code'){
                                                prod.Ghost_Product_created_on_Hansa__c = True;
                                                prod.Hansa_Sync_Error__c = false;  
                                                successResultList.add(prod.Id);
                                            }
                                        }  
                                    }
                                }
                                else{
                                    system.debug('@@@@@@@@@ status code not 200 ');
                                    prod.Hansa_Sync_Error__c = True;   
                                }
                            }
                            productListToUpdate.add(prod);
                        }
                        else{
                            System.debug('@@@@@@@ ==>>> ENDPOINT NOT DEFINE OR FIELD SET EMPTY ');
                        }
                        
                    }
                    catch(exception ex){
                        system.debug('@@@@@@@ EXCEPTION ENCOUNTERED line: => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
                        prod.Hansa_Sync_Error__c = true; 
                        prod.Hansa_JSON_Body__c = responseCheck==True?prod.Hansa_JSON_Body__c+' Exception: '+ex.getMessage():ex.getMessage();
                        productListToUpdate.add(prod);
                    }
                } 
                
            }// IF TOKEN NOT FOUND ***
            else if(hansaAccessToken == '' || hansaAccessToken == null  || hansaAccessToken == 'Error in Access Token Request'){
                System.debug('@@@@@@@ TOKEN NOT FOUND '); 
                for(Product2 prod : [select id,Hansa_JSON_Body__c,Hansa_Status_Code__c from Product2 where id in : productId_Set]){
                    prod.Hansa_JSON_Body__c = 'Error in hansa token request, Token = '+hansaAccessToken;
                    prod.Hansa_Sync_Error__c = true;
                    productListToUpdate.add(prod);
                }
            }
            
            system.debug('@@@@@@@ productListToUpdate=> '+productListToUpdate);
            if(!productListToUpdate.isEmpty()){
                update productListToUpdate;
            }
            return successResultList;
        }
        catch(Exception ex){
            system.debug('####### EXCEPTION ENCOUNTERED line: => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
            return successResultList;
        }        
    }  
    
    // Method 2 : get counter code form custom setting
    public static map<string,string> getCountriesCode(){
        map<string,string> countryNameVsCode = new map<string,string>();
        Schema.DescribeFieldResult fieldResult = User.Countrycode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            countryNameVsCode.put(f.getLabel() , f.getValue()); 
        }
        return countryNameVsCode;
    } 
    
    // METHOD 3 : sync recipe
    public static List<String> postNewKitToHansa(Set<String> productIdSet){
        List<String> successResultList =new List<String>();
        RunOnce.allowFurure_ProdKitLine = True;
        RunOnce.productTrigger = false; 
        System.debug('@@@@@@@@@ batch** post KIT to hansa');
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
                        endPointURL = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/RecVc';
                        //endPointURL = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/RecVc?set_field.Code='+prod.Name+'&set_field.Comment='+prod.Product_Description__c+'&set_row_field.0.Item='+prod.Name+'&set_row_field.0.OutQty=1';
                        fieldsValue = 'set_field.Code='+prod.Name+'&set_field.Comment='+prod.Product_Description__c+'&set_row_field.0.Item='+prod.Name+'&set_row_field.0.OutQty=1';
                        system.debug('@@@@ FINAL endPointURL ==> '+endPointURL);
                        
                        if(endPointURL != ''){  
                            system.debug('@@@@@@####  Recipe fieldsValue => '+fieldsValue);
                            HttpRequest req = new HttpRequest();
                            req.setMethod('POST');
                            req.setHeader('Authorization','Bearer '+hansaAccessToken);
                            req.setEndpoint(endPointURL);
                            req.setBody(fieldsValue);
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
                                                successResultList.add(prod.id);
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
            return successResultList;
        }
        catch(Exception ex){
            system.debug('####### Recipe EXCEPTION ENCOUNTERED line: => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
            return successResultList;
        }   
    }
    
    // METHOD 4: recipe line sync with related kit records
    public static void patchNewRecipeLineToHansa(Id kitId){
        RunOnce.kpTriggerCheck = false; // not run Kit Part Trigger**
        
        System.debug('@@@@@@@@@ Batch** Patch recipe line to hansa => '+kitId);
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