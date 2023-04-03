/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Description	:	Helper class for "Co_ProjectTrigger" Trigger
* Test class	: 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Coacto Salesforce   
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class Co_ProductTriggerHandler {
    
    // FOR NEW PRODUCT TO POST TO HANSA**
    // METHOD 1:
    @future (callout=true)
    public static void postToHansaItem(set<Id> productId_Set){ 
        try{
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
        }
        catch(Exception ex){
            system.debug('####### EXCEPTION ENCOUNTERED line: => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
        }        
    }  
    
    
    // GET CUSTOM SETTING FOR "Hansa SF product Mapping" MAPPING**
    // METHOD 2: 
    // <SFfield,<sfValue,hansaValue>> //Hansa_SF_product_Mapping
    public static map<string,map<string,string>> getProductCustomSettingRecords(String customSettingName){        
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklist = new map<string,map<string,string>>();
        if(customSettingName == 'Hansa_SF_product_Mapping__c'){
            for(Hansa_SF_product_Mapping__c a: Hansa_SF_product_Mapping__c.getall().values()){
                if(salesforceFieldVsSalesforceVsHansaPicklist.containsKey(string.valueOf(a.Salesforce_Field__c).toLowerCase())){
                    map<string,string> salesforcePicklistVsHansaPicklist = salesforceFieldVsSalesforceVsHansaPicklist.get(string.valueOf(a.Salesforce_Field__c).toLowerCase());
                    salesforcePicklistVsHansaPicklist.put(a.Salesforce_Picklist_Value__c,a.Hansa_Picklist_Value__c);
                    salesforceFieldVsSalesforceVsHansaPicklist.put(string.valueOf(a.Salesforce_Field__c).toLowerCase(),salesforcePicklistVsHansaPicklist);
                }else{
                    map<string,string> salesforcePicklistVsHansaPicklist = new map<string,string>();
                    salesforcePicklistVsHansaPicklist.put(a.Salesforce_Picklist_Value__c,a.Hansa_Picklist_Value__c);
                    salesforceFieldVsSalesforceVsHansaPicklist.put(string.valueOf(a.Salesforce_Field__c).toLowerCase(),salesforcePicklistVsHansaPicklist);
                }
            }    
            system.debug('@@@@@@@@ PRODUCT CUSTOMSETTING MAP ==> '+salesforceFieldVsSalesforceVsHansaPicklist);
            
            if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty()){
                return salesforceFieldVsSalesforceVsHansaPicklist;
            }else
                return new map<string,map<string,string>>();
        }
        return null;
    }
    
    // Method 3
    // Run on after update: Call heroku
    @future (callout=true)
    public static void postToHansaItemOnUpdate(Set<Id> productId_Set){
        try{
            boolean devStop = false;
            RunOnce.accountTrigger = false;
            string hansaAccessToken = '';
            list<Product2> productListToUpdate = new List<Product2>();
            map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklist = new map<string,map<string,string>>();
            map<string,string> countryNameVsCode = getCountriesCode();
            
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
                string productQuery = 'SELECT id, Inspection_Code__c, Product_Type__c, Product_Group__c,Product_Classification__c,Product_Description__c,Product_Status__c,Name, Ceetak_Drawing_No__c, Ceetak_Drawing_Rev__c, Ceetak_Material_Code__c, Material_Type__c, Unit__c, Weight_grams__c, Inspection_Name__c, Warnings__c, Country_of_Origin__c, EDI__c, EDI_Classification__c  FROM product2 where Id IN: productId_Set';
                system.debug('@@@@@ productQuery ==> '+productQuery);
                list<Product2> productRecords_list = database.query(productQuery);
                system.debug('@@@@@ product Records ==> '+productRecords_list);
                
                //salesforceFieldVsSalesforceVsHansaPicklist = getCustomSettingRecords('Account_Mapping_Customer__c');
                salesforceFieldVsSalesforceVsHansaPicklist = Co_ProductTriggerHandler.getProductCustomSettingRecords('Hansa_SF_product_Mapping__c');
                
                for(Product2 prod : productRecords_list){
                    try{
                        string endPointURL = '';
                        string fieldsValue = ''; 
                        string ceetakLocation = '';
                        string salesArea = '';
                        string customerCategory = ''; 
                        string herokuEndPoint = 'https://erp-sync.herokuapp.com/getItem';
                        
                        // FILL HANSA REQUIRED FIELDS**
                        if(prod.Product_Group__c != null && prod.Product_Description__c!=null && prod.Product_Status__c=='Approved'){
                            fieldsValue += 'set_field.SalesForceID=' + prod.id + '&';
                            list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Turn_of_Product_Sync__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
                            String tempEndPoint = customSettting[0].Product_End_Point_URL__c;
                            //String tempEndPoint = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/INVc';
                            endPointURL = tempEndPoint.substringBeforeLast('?') + '/' + prod.Name + '?';
                            //endPointURL = 'https://erp-sync.herokuapp.com/getItem';
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
                            // **
                            if(prod.Material_Type__c!=null){
                                fieldsValue +='&set_field.MaterialType='+prod.Material_Type__c;
                            }
                            else
                                fieldsValue +='&set_field.MaterialType='+''; 
                            // **

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
                            
                            System.debug('@@@@@@@@ CUSTOM SETTING @@@@@');
                            System.debug('@@@@ salesforceFieldVsSalesforceVsHansaPicklist.containsKey(product_status__c) : '+salesforceFieldVsSalesforceVsHansaPicklist.containsKey('product_status__c'));
                            System.debug('@@@@@@@ salesforceFieldVsSalesforceVsHansaPicklist : '+salesforceFieldVsSalesforceVsHansaPicklist);
                            
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
                            
                            if(res != null && res.getStatusCode() != null){
                                prod.Hansa_Status_Code__c = string.valueOf(res.getStatusCode());
                            }
                            if(res != null && res.getBody() != null){
                                System.debug('@@@@ BODY: '+res.getBody()); 
                                System.debug('@@@@ STATUS:'+res.getStatus());
                                System.debug('@@@@ STATUS_CODE:'+res.getStatusCode());
                                
                                map<string,Object> obj = (map<string,Object>)JSON.deserializeUntyped(res.getBody());
                                prod.Hansa_Status_Code__c = string.valueOf(obj.get('statusCode'));
                                prod.Hansa_JSON_Body__c = string.valueOf(obj.get('body'));
                                System.debug('###@ respns Body => '+prod.Hansa_JSON_Body__c);
                                prod.Hansa_Sync_Error__c = false;
                                //Dom.Document doc = new Dom.Document();
                                // doc.load(string.valueOf(obj.get('body'))); 
                                //prod.Hansa_JSON_Body__c = res.getBody();
                                prod.Hansa_Last_Sync_Date__c = system.today();
                            }
                            productListToUpdate.add(prod);
                        }
                        else{
                            System.debug('@######## empty endpoint ot field set for UPDATE');
                        }
                        
                    }
                    catch(exception ex){
                        system.debug('@@@@@@@ EXCEPTION ENCOUNTERED PRODUCT: => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
                        prod.Hansa_Sync_Error__c = true; 
                        prod.Hansa_JSON_Body__c = ex.getMessage()+' cause: '+ex.getCause()+' Line: '+ex.getLineNumber();
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
        }
        catch(Exception ex){
            system.debug('####### EXCEPTION ENCOUNTERED Product b : => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
        }        
        // 
    }
    
    // MTHOD 4:
    // DESCRIPTON: hansle bulk callout
    public static void handleBulkProductsForNew(Set<Id> productIdSet, boolean isNew){        
        System.debug('@@@@@@@@ check bulkify ');
        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Turn_of_Product_Sync__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
        if(!customSettting[0].Turn_of_Product_Sync__c){
            if(!productIdSet.isEmpty()){
                if(!System.isFuture() && !System.isBatch()){
                    //If future is allowed, batch up Product ids into batches of 25.
                    Integer i = 0;
                    Set<Id> prodIdsToProcessBatch = new Set<Id>();
                    for(String prodId : productIdSet){
                        prodIdsToProcessBatch.add(prodId);
                        i++;
                        if(i == 25){
                            System.debug('@@@@@@@@ 25 done');
                            if(!prodIdsToProcessBatch.isEmpty() && isNew){
                                System.debug('@@@@@@@@ call Put for 25 ');
                                // NEW
                                Co_ProductTriggerHandler.postToHansaItem(prodIdsToProcessBatch);
                            }
                            if(!prodIdsToProcessBatch.isEmpty() && !isNew){
                                System.debug('@@@@@@@@ call Patch for 25 ');
                                // UPDATE
                                Co_ProductTriggerHandler.postToHansaItemOnUpdate(prodIdsToProcessBatch);
                            }
                            prodIdsToProcessBatch = new Set<Id>();
                            i = 0;
                        }
                    }
                    
                    System.debug('@@@@@@@@ Not 25 bulk ');
                    if(!prodIdsToProcessBatch.isEmpty() && isNew){
                        System.debug('@@@@@@@@ call product put ');
                        Co_ProductTriggerHandler.postToHansaItem(prodIdsToProcessBatch);
                    }
                    if(!prodIdsToProcessBatch.isEmpty() && !isNew){
                        System.debug('@@@@@@@@ call product Patch ');
                        Co_ProductTriggerHandler.postToHansaItemOnUpdate(prodIdsToProcessBatch);
                    }
                }
            }    
        }
    }
    
    /**
* ─────────────────────────────────────────────────────────────────────────────────────────────┐
*  Get Countries Code based on standard Countries Values
* ─────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static map<string,string> getCountriesCode(){
        map<string,string> countryNameVsCode = new map<string,string>();
        Schema.DescribeFieldResult fieldResult = User.Countrycode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            countryNameVsCode.put(f.getLabel() , f.getValue()); 
        }
        return countryNameVsCode;
    }    
}