/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is Helper for Hansa_ClassificationSync_Batch. Handle logic to sync retroactive Hansa account classification field
* class referred    :   GenerateHansaAccessToken
* ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class Hansa_ClassificationSync_BatchHelper {
    
    // Fetching Picklist field mapping for supplier accounts
    public static map<string,map<string,string>> getCustomSettingRecords(String customSettingName){        
        
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklist = new map<string,map<string,string>>();
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklistSupplier = new map<string,map<string,string>>();
        
        if(customSettingName == 'Account_Mapping_Customer__c'){
            for(Account_Mapping_Customer__c a: Account_Mapping_Customer__c.getall().values()){
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
            system.debug('salesforceFieldVsSalesforceVsHansaPicklist++');
            system.debug(salesforceFieldVsSalesforceVsHansaPicklist);
            if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty()){
                return salesforceFieldVsSalesforceVsHansaPicklist;
            }else{
                return new map<string,map<string,string>>();
            }
            
        }else if(customSettingName == 'Account_Mapping_Supplier__c'){
            for(Account_Mapping_Supplier__c a: Account_Mapping_Supplier__c.getall().values()){
                if(salesforceFieldVsSalesforceVsHansaPicklistSupplier.containsKey(string.valueOf(a.Salesforce_Field__c).toLowerCase())){
                    map<string,string> salesforcePicklistVsHansaPicklistSupplier = salesforceFieldVsSalesforceVsHansaPicklistSupplier.get(string.valueOf(a.Salesforce_Field__c).toLowerCase());
                    salesforcePicklistVsHansaPicklistSupplier.put(a.Salesforce_Picklist_Value__c,a.Hansa_Picklist_Value__c);
                    salesforceFieldVsSalesforceVsHansaPicklistSupplier.put(string.valueOf(a.Salesforce_Field__c).toLowerCase(),salesforcePicklistVsHansaPicklistSupplier);
                }else{
                    map<string,string> salesforcePicklistVsHansaPicklistSupplier = new map<string,string>();
                    salesforcePicklistVsHansaPicklistSupplier.put(a.Salesforce_Picklist_Value__c,a.Hansa_Picklist_Value__c);
                    salesforceFieldVsSalesforceVsHansaPicklistSupplier.put(string.valueOf(a.Salesforce_Field__c).toLowerCase(),salesforcePicklistVsHansaPicklistSupplier);
                }
                system.debug('a++++'+a);
                
            }
            system.debug('salesforceFieldVsSalesforceVsHansaPicklistSupplier++');
            system.debug(salesforceFieldVsSalesforceVsHansaPicklistSupplier);
            if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty()){
                return salesforceFieldVsSalesforceVsHansaPicklistSupplier;
            }else{
                return new map<string,map<string,string>>();
            }
        }
        return null;
        
    }
    
    
    // SYNC METHOD CALLED FROM BATCH***
    public static void postToHansaUpdate(String userAccId){
        RunOnce.accountTrigger = false;
        string hansaAccessToken = '';
        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Customer_Supplier_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklist = new map<string,map<string,string>>();
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklistSupplier = new map<string,map<string,string>>();
        list<account> accountListToUpdate = new list<account>(); 
        
        // *** GENERATE HANDA TOKEN(Start)
        if(!test.isRunningTest()){
            // ** CALL METHOD TO GET HANSA ACCESS TOKEN
            hansaAccessToken = GenerateHansaAccessToken.generateAccessToken();
        }else{
            hansaAccessToken = 'Test hansa token'; 
        }
        // Generate Hansa Token(End)
        system.debug('@@@@@@@ hansaAccessToken+++ '+hansaAccessToken);
        
        Account acc = [select id,Account_Status__c,name,Language__c,Duty_Charges_Actual__c,Bank_Account_No__c,Bank_Sort_Code__c,Freight_Charges_Actual__c,BillingCountryCode,Same_as_Billing_Address__c,shippingcountrycode,Ceetak_Location__c,Website,Sales_Area__c,Phone,Email__c,Customer_Category__c,EDI_Customer__c,Shipping_Instructions__c,LFY_Actual_Sales__c,CurrencyIsoCode,VAT_Code__c,VAT_Zone__c,Customer_VAT_No__c,Incoterms_Shipping_Terms__c,Payment_Terms__c,Credit_Limit__c,Credit_Balance__c,billingstreet,billingcity,billingstate,billingpostalcode,billingcountry,shippingstreet,shippingcity,shippingstate,shippingpostalcode,shippingcountry,recordtype.name,Hansa_Account_Number__c,Hansa_Supplier_Number__c,recordTypeId,Hansa_JSON_Body__c,Hansa_Status_Code__c,owner.Hansa_Initials__c,Hansa_Sync_Error__c,Warning_Quotation_Order__c,order_class__c from account where id=:userAccId limit 1];
        
        if(hansaAccessToken != '' && hansaAccessToken != null  && hansaAccessToken != 'Error in Access Token Request' && acc!=null){            
            System.debug('@@@@@@ START SYNC');
            salesforceFieldVsSalesforceVsHansaPicklist = getCustomSettingRecords('Account_Mapping_Customer__c');
            salesforceFieldVsSalesforceVsHansaPicklistSupplier = getCustomSettingRecords('Account_Mapping_Supplier__c');
            string endPointURL = '';
            string fieldsValue = '';
            boolean setClassification = false;
            fieldsValue += 'set_field.SalesForceID=' + acc.id + '&'; 
            if(acc.recordTypeId != null && acc.recordtype.name == 'Supplier' && !customSettting.isEmpty()){
                // Supplier Mapping
                endPointURL = customSettting[0].Customer_Supplier_End_Point_URL__c.substringBeforeLast('?') + '/' + acc.Hansa_Supplier_Number__c + '?'; 
                
                if(acc.name != null){
                    fieldsValue += '&set_field.Name=' + acc.name + '&';
                }                
                System.debug('##### filling Update Supplier HANSA Classification');
                if(acc.owner.Hansa_Initials__c!=null){
                    System.debug('#@@@@  Hansa Initial added '+acc.owner.Hansa_Initials__c);
                    fieldsValue += 'set_field.Classification='+ acc.owner.Hansa_Initials__c +'&';
                }
                
            }
            
            system.debug('endPointURL+++'+endPointURL);
            if(endPointURL != '' && !customSettting.isEmpty() && customSettting[0].Customer_Supplier_End_Point_URL__c != null && fieldsValue != null && fieldsValue != ''){  
                system.debug('###### fieldsValue++'+fieldsValue.substringBeforeLast('&'));
                string herokuEndPoint = 'https://erp-sync.herokuapp.com/getData';
                string domainUrl = endPointURL;
                string body = 'authorizationToken='+EncodingUtil.urlEncode(hansaAccessToken,'UTF-8') + '&endPointURL='+EncodingUtil.urlEncode(domainUrl,'UTF-8')  + '&jsonBody='+EncodingUtil.urlEncode(fieldsValue,'UTF-8');
                Http customerReq = new Http();
                HttpRequest customerData = new HttpRequest();
                customerData.setMethod('POST');
                customerData.setEndpoint(herokuEndPoint); 
                customerData.setTimeout(120000);  
                customerData.setHeader('Content-Type','application/x-www-form-urlencoded');
                customerData.setBody(body);                    
                // Callout to Heroku for Patch request
                HTTPResponse res;
                try{
                    res = customerReq.send(customerData); 
                }catch(Exception e){
                    system.debug('Exception Line Number '+e.getLineNumber());
                    system.debug('Exception Message '+e.getMessage());
                    acc.Hansa_Sync_Error__c = true; 
                    acc.Hansa_JSON_Body__c = e.getMessage();
                }                    
                acc.Hansa_Last_Sync_Date__c = system.today();                    
                if(res != null && res.getBody() != null){
                    System.debug('BODY: '+res.getBody()); 
                    System.debug('STATUS:'+res.getStatus());
                    System.debug('STATUS_CODE:'+res.getStatusCode());
                    try{
                        map<string,Object> obj = (map<string,Object>)JSON.deserializeUntyped(res.getBody());
                        acc.Hansa_Status_Code__c = string.valueOf(obj.get('statusCode'));
                        acc.Hansa_JSON_Body__c = string.valueOf(obj.get('body'));
                        acc.Hansa_Sync_Error__c = false;
                        Dom.Document doc = new Dom.Document();
                        doc.load(string.valueOf(obj.get('body')));                                                   
                    }catch(Exception e){
                        system.debug('Exception Line Number '+e.getLineNumber());
                        system.debug('Exception Message '+e.getMessage());
                        acc.Hansa_Sync_Error__c = true; 
                    }                       
                }
                accountListToUpdate.add(acc);
            }
            
        }
        else if(hansaAccessToken == '' || hansaAccessToken == null  || hansaAccessToken == 'Error in Access Token Request'){
            System.debug('@@@@@@ NOT SYNC');
            if(acc!=null){
                Account accNw = new Account();
                accNw.id= acc.id;
                accNw.Hansa_JSON_Body__c = 'Error in hansa token request, Token = '+hansaAccessToken;
                accNw.Hansa_Sync_Error__c = true;
                accountListToUpdate.add(accNw);
            }
        }
        system.debug('accountListToUpdate+++++'+accountListToUpdate);
        if(!accountListToUpdate.isEmpty()){
            try{
                update accountListToUpdate;
            }catch(Exception e){
                system.debug('Exception Line Number '+e.getLineNumber());
                system.debug('Exception Message '+e.getMessage()); 
            }
        }
    }
    
}