/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is used to handle logic for account trigger handler
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/

/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Account Field Validation.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    map<id, account>      newMap,oldMap
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
*/ 
public class AccountTriggerHandler {
    public static void accValidation(map<id, account> newMap , map<id , account> oldMap){
        String errorMessage = '';
        String sBreak = '<br/>'; 
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(oldMap != null && newMap != null){
            for(String  accID : newMap.keySet()){
                if(Schema.SObjectType.Account.getRecordTypeInfosById().get(newMap.get(accID).recordtypeid) != null && Schema.SObjectType.Account.getRecordTypeInfosById().get(newMap.get(accID).recordtypeid).getname() == 'Supplier' && newMap.get(accID).Supplier_Account_Type__c == 'Approved'){
                    
                    if(newMap.get(accID).VAT_Zone__c != oldMap.get(accID).VAT_Zone__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage  = 'You do not have permission to change VAT Zone of Approved Supplier.'+sBreak; 
                    }
                    if(newMap.get(accID).Payment_Terms__c != oldMap.get(accID).Payment_Terms__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change Payment Terms of Approved Supplier.'+sBreak;
                    }
                    if(newMap.get(accID).Bank_Account_No__c != oldMap.get(accID).Bank_Account_No__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change Bank Account No of Approved Supplier.'+sBreak;
                    }
                    if(newMap.get(accID).Bank_Sort_Code__c != oldMap.get(accID).Bank_Sort_Code__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change Bank Sort Code of Approved Supplier.'+sBreak;
                    }
                    if(newMap.get(accID).Early_Payment_Discount__c != oldMap.get(accID).Early_Payment_Discount__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change Early Payment Discount of Approved Supplier.'+sBreak;
                    }
                    if(newMap.get(accID).Company_Registration_No__c != oldMap.get(accID).Company_Registration_No__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change Company Registration No of Approved Supplier.'+sBreak;
                    }
                    if(newMap.get(accID).CurrencyIsoCode  != oldMap.get(accID).CurrencyIsoCode  && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change Account Currency of Approved Supplier.'+sBreak;
                    }   
                    if(newMap.get(accID).VAT_Code__c != oldMap.get(accID).VAT_Code__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change VAT Code of Approved Supplier.'+sBreak;
                    }
                    if(newMap.get(accID).LFY_Spend__c != oldMap.get(accID).LFY_Spend__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change LFY Spend of Approved Supplier.'+sBreak;
                    } 
                    if(newMap.get(accID).CFY_Spend__c != oldMap.get(accID).CFY_Spend__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change CFY Spend of Approved Supplier.'+sBreak;
                    }
                    if(newMap.get(accID).Last_Traded__c != oldMap.get(accID).Last_Traded__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change Last Traded of Approved Supplier.'+sBreak;
                    }
                    if(newMap.get(accID).Freight_Charges_Actual__c != oldMap.get(accID).Freight_Charges_Actual__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change Freight Charges (Actual) of Approved Supplier.'+sBreak;
                    }
                    if(newMap.get(accID).Duty_Charges_Actual__c != oldMap.get(accID).Duty_Charges_Actual__c && (profileName != 'Ceetak Admin' && profileName != 'Ceetak Accounts' && profileName != 'System Administrator')){
                        errorMessage += 'You do not have permission to change Duty Charges (Actual) of Approved Supplier.'+sBreak;
                    }
                    if(errorMessage != null && errorMessage != ''){
                        newMap.get(accID).addError(errorMessage,false);
                    }
                }
            }
        }
    }
    
/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Check conditions to post Customer and Supplier records to hansa
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    map<id, account>      newMap,oldMap
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static void getAccountRecords(map<id,Account> newMap,map<id,Account> oldMap){
        
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Account.fields.getMap();  // Get all fields of account using schema
        set<string> accountIdsToProcess = new set<string>();
        set<string> accountIdsToProcessForUpdate = new set<string>();
        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Turn_of_Account_Sync__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
        set<string> accountMappingFieldsForCustomer = new set<string>{'name','ceetak_location__c','website','language__c','sales_area__c','phone','email__c','customer_category__c','edi_customer__c','shipping_instructions__c','currencyisocode','vat_code__c','vat_zone__c','customer_vat_no__c','incoterms_shipping_terms__c','payment_terms__c','credit_limit__c','billingstreet','billingcity','billingstate','billingcountrycode','billingpostalcode','shippingstreet','shippingcity','shippingstate','shippingcountrycode','shippingpostalcode','warning_quotation_order__c','order_class__c'};
        set<string> fieldChangesForCustomer = new set<string>();
        set<string> accountMappingFieldsForSupplier = new set<string>{'name','ownerid','phone','email__c','website','currencyisocode','vat_code__c','vat_zone__c','incoterms_shipping_terms__c','payment_terms__c','bank_account_no__c','bank_sort_code__c','billingstreet','billingcity','billingstate','billingcountrycode','billingpostalcode','shippingstreet','shippingcity','shippingstate','shippingcountrycode','shippingpostalcode'};
        set<string> fieldChangesForSupplier = new set<string>();
        if((trigger.isUpdate || Trigger.isInsert)  && newMap != null && !customSettting.isEmpty() && !customSettting[0].Turn_of_Account_Sync__c){
            for(string accountId : newMap.keySet()){
                if(((trigger.isUpdate && oldMap != null && newMap.get(accountId).type != oldMap.get(accountId).type) || Trigger.isInsert) && newMap.get(accountId).recordTypeId == '0123z000000Vap0'  && newMap.get(accountId).type == 'Certified' /*&& oldMap.get(accountId).type == 'Prospect'*/ && newMap.get(accountId).Hansa_Account_Number__c == null){
                    accountIdsToProcess.add(accountId);
                }
                
                if(((trigger.isUpdate && oldMap != null && newMap.get(accountId).Supplier_Account_Type__c != oldMap.get(accountId).Supplier_Account_Type__c) || Trigger.isInsert) && newMap.get(accountId).recordTypeId == '0123z000000Vap5'  && newMap.get(accountId).Supplier_Account_Type__c == 'Approved' /*&& oldMap.get(accountId).Supplier_Account_Type__c == 'Potential'*/ && newMap.get(accountId).Hansa_Supplier_Number__c == null){
                    accountIdsToProcess.add(accountId);
                }

                if(trigger.isUpdate && oldMap != null ){
                    for (String fieldName: schemaFieldMap.keySet()) {
                         if(accountMappingFieldsForCustomer.contains(fieldName) && newMap.get(accountId).recordTypeId == '0123z000000Vap0' && newMap.get(accountId).Hansa_Account_Number__c != null && newMap.get(accountId).type == 'Certified' && newMap.get(accountId).get(fieldName) != oldMap.get(accountId).get(fieldName)){
                            accountIdsToProcessForUpdate.add(accountId);
                            fieldChangesForCustomer.add(fieldName);
                         }

                         if(accountMappingFieldsForSupplier.contains(fieldName) && newMap.get(accountId).recordTypeId == '0123z000000Vap5' && newMap.get(accountId).Hansa_Supplier_Number__c != null && newMap.get(accountId).Supplier_Account_Type__c == 'Approved' && newMap.get(accountId).get(fieldName) != oldMap.get(accountId).get(fieldName)){
                            accountIdsToProcessForUpdate.add(accountId);
                            fieldChangesForSupplier.add(fieldName);
                         }
                     }
                }
                
            }
        } 
        system.debug('accountIdsToProcess+++'+accountIdsToProcess);
        system.debug('accountIdsToProcessForUpdate+++'+accountIdsToProcessForUpdate); 
        system.debug('fieldChangesForCustomer+++'+fieldChangesForCustomer); 

        if(!accountIdsToProcess.isEmpty()){
            if(!System.isFuture() && !System.isBatch()){
               //If future is allowed, batch up account ids into batches of 25. We have to make one callout per account.  We're better off splitting into many @future methods in this case.
               Integer i = 0;
               Set<string> accountIdsToProcessBatch = new Set<string>();
               for(String accountId : accountIdsToProcess){
                    accountIdsToProcessBatch.add(accountId);
                    i++;
                    if(i == 25){
                        processAccountBatch(accountIdsToProcessBatch);
                        accountIdsToProcessBatch = new Set<string>();
                        i = 0;
                    }
                }
                if(!accountIdsToProcessBatch.isEmpty()){
                    processAccountBatch(accountIdsToProcessBatch);
                }
            }
        }

        if(!accountIdsToProcessForUpdate.isEmpty()){
            if(!System.isFuture() && !System.isBatch()){
               //If future is allowed, batch up account ids into batches of 25. We have to make one callout per account.  We're better off splitting into many @future methods in this case.
               Integer i = 0;
               Set<string> accountIdsToProcessBatchUpdate = new Set<string>();
               for(String accountId : accountIdsToProcessForUpdate){
                accountIdsToProcessBatchUpdate.add(accountId);
                    i++;
                    if(i == 25){
                        processAccountBatchUpdate(accountIdsToProcessBatchUpdate,fieldChangesForCustomer,fieldChangesForSupplier);
                        accountIdsToProcessBatchUpdate = new Set<string>();
                        i = 0;
                    }
                }
                if(!accountIdsToProcessBatchUpdate.isEmpty()){
                    processAccountBatchUpdate(accountIdsToProcessBatchUpdate,fieldChangesForCustomer,fieldChangesForSupplier);
                } 
            }
        }


    }

/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Future method to split bulk accounts into batches of 25.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    Set<string>      accountIds
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    @future(callout=true)
    public static void processAccountBatch(Set<string> accountIds){
        postToHansa(accountIds);
    }

/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Future method to split bulk accounts into batches of 25.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    Set<string>      accountIds
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    @future(callout=true)
    public static void processAccountBatchUpdate(Set<string> accountIds, Set<string> fieldChangesForCustomer, Set<string> fieldChangesForSupplier){
        postToHansaUpdate(accountIds,fieldChangesForCustomer,fieldChangesForSupplier,false);
    }
    
/**
    * ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
    *  Final callout to hansa to create or override all customer and supplier account in hansa whenever sync to hansa button is pressed
    * ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    Set<string>      accountIds
    * ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static void postToHansa(set<string> accountIds){ 
        RunOnce.accountTrigger = false;
        string hansaAccessToken = '';
        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Customer_Supplier_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklist = new map<string,map<string,string>>();
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklistSupplier = new map<string,map<string,string>>();

        // Generate Hansa Token(Start)
        if(!test.isRunningTest()){
            hansaAccessToken = GenerateHansaAccessToken.generateAccessToken();
        }else{
            hansaAccessToken = 'Test hansa token'; 
        }
        // Generate Hansa Token(End)
        system.debug('hansaAccessToken+++'+hansaAccessToken);

        list<account> accountListToUpdate = new list<account>();        
        if(hansaAccessToken != '' && hansaAccessToken != null  && hansaAccessToken != 'Error in Access Token Request'){            
            
            string accountQuery = 'select id,Account_Status__c,name,Language__c,Duty_Charges_Actual__c,Bank_Account_No__c,Bank_Sort_Code__c,Freight_Charges_Actual__c,BillingCountryCode,shippingcountrycode,Ceetak_Location__c,Website,Sales_Area__c,Phone,Email__c,Customer_Category__c,EDI_Customer__c,Shipping_Instructions__c,LFY_Actual_Sales__c,CurrencyIsoCode,VAT_Code__c,VAT_Zone__c,Customer_VAT_No__c,Incoterms_Shipping_Terms__c,Payment_Terms__c,Credit_Limit__c,Credit_Balance__c,billingstreet,billingcity,billingstate,billingpostalcode,billingcountry,shippingstreet,shippingcity,shippingstate,shippingpostalcode,shippingcountry,recordtype.name,Hansa_Account_Number__c,Hansa_Supplier_Number__c,recordTypeId,Hansa_JSON_Body__c,Hansa_Status_Code__c,owner.Hansa_Initials__c,Hansa_Sync_Error__c,Warning_Quotation_Order__c,order_class__c from account where id in : accountIds';
            system.debug('accountQuery'+accountQuery);
            list<account> accountRecords = database.query(accountQuery);
            system.debug('accountRecords++'+accountRecords);

            salesforceFieldVsSalesforceVsHansaPicklist = getCustomSettingRecords('Account_Mapping_Customer__c');
            salesforceFieldVsSalesforceVsHansaPicklistSupplier = getCustomSettingRecords('Account_Mapping_Supplier__c');

            for(Account acc : accountRecords){
                string endPointURL = '';
                string fieldsValue = ''; 
                string ceetakLocation = '';
                string salesArea = '';
                string customerCategory = ''; 

                if(acc.recordTypeId != null && acc.recordtype.name == 'Customer' && !customSettting.isEmpty()){
                    endPointURL = customSettting[0].Customer_Supplier_End_Point_URL__c + 'set_field.VEType=0&set_field.CUType=1';

                    fieldsValue += 'set_field.SalesForceID=' + acc.id + '&set_field.Name=' + acc.name + '&';
                    if(acc.Account_Status__c != null){
                        if(acc.Account_Status__c == 'Open'){
                            fieldsValue +=  'set_field.blockedFlag=0&set_field.OnHoldFlag=0&'; 
                        }else if(acc.Account_Status__c == 'On Hold'){
                            fieldsValue +=  'set_field.blockedFlag=0&set_field.OnHoldFlag=1&';
                        }else if(acc.Account_Status__c == 'Closed'){
                            fieldsValue +=  'set_field.blockedFlag=1&set_field.OnHoldFlag=0&';
                        }
                    }

                    // Getting the hansa picklist value from selected picklist value in salesforce
                    if(acc.Ceetak_Location__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('ceetak_location__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('ceetak_location__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('ceetak_location__c').containsKey(acc.Ceetak_Location__c)){
                                fieldsValue += 'set_field.OrderLocation=' + salesforceFieldVsSalesforceVsHansaPicklist.get('ceetak_location__c').get(acc.Ceetak_Location__c)+ '&';
                                ceetakLocation = salesforceFieldVsSalesforceVsHansaPicklist.get('ceetak_location__c').get(acc.Ceetak_Location__c);
                            }
                        }
                    }                    

                    if(acc.Language__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('language__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('language__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('language__c').containsKey(acc.language__c)){
                                fieldsValue += 'set_field.LangCode=' + salesforceFieldVsSalesforceVsHansaPicklist.get('language__c').get(acc.language__c) + '&';
                            }
                        }
                    }

                    if(acc.Sales_Area__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('sales_area__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('sales_area__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('sales_area__c').containsKey(acc.sales_area__c)){
                                fieldsValue += 'set_field.SalesMan=' + salesforceFieldVsSalesforceVsHansaPicklist.get('sales_area__c').get(acc.sales_area__c) + '&';
                                salesArea = salesforceFieldVsSalesforceVsHansaPicklist.get('sales_area__c').get(acc.sales_area__c);
                            }
                        }
                    }                                     

                    if(acc.Customer_Category__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('customer_category__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('customer_category__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('customer_category__c').containsKey(acc.customer_category__c)){
                                fieldsValue += 'set_field.CustCat=' + salesforceFieldVsSalesforceVsHansaPicklist.get('customer_category__c').get(acc.customer_category__c)+ '&';
                                customerCategory = salesforceFieldVsSalesforceVsHansaPicklist.get('customer_category__c').get(acc.customer_category__c) ;
                            }
                        }
                    }

                    if(acc.EDI_Customer__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('edi_customer__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('edi_customer__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('edi_customer__c').containsKey(acc.edi_customer__c)){
                                fieldsValue += 'set_field.EDIFlag=' + salesforceFieldVsSalesforceVsHansaPicklist.get('edi_customer__c').get(acc.edi_customer__c) + '&';
                            }
                        }
                    }
                    
                    if(acc.currencyisocode != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('currencyisocode')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode').containsKey(acc.currencyisocode)){
                                fieldsValue += 'set_field.CurncyCode=' + salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode').get(acc.currencyisocode) + '&';
                            }
                        }
                    }

                    if(acc.vat_code__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('vat_code__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c').containsKey(acc.vat_code__c)){
                                fieldsValue += 'set_field.VATCode=' + salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c').get(acc.vat_code__c) + '&';
                            }
                        }
                    }

                    if(acc.vat_zone__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('vat_zone__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').containsKey(acc.vat_zone__c)){
                                fieldsValue += 'set_field.ExportFlag=' + salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').get(acc.vat_zone__c) + '&';
                            }
                        }
                    }                    

                    if(acc.incoterms_shipping_terms__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('incoterms_shipping_terms__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c').containsKey(acc.incoterms_shipping_terms__c)){
                                fieldsValue += 'set_field.ShipDeal=' + salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c').get(acc.incoterms_shipping_terms__c) + '&';
                            }
                        }
                    }

                    if(acc.payment_terms__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('payment_terms__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c').containsKey(acc.payment_terms__c)){
                                fieldsValue += 'set_field.PayDeal=' + salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c').get(acc.payment_terms__c) + '&';
                            }
                        }
                    }

                    if(acc.order_class__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('order_class__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('order_class__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('order_class__c').containsKey(acc.order_class__c)){
                                fieldsValue += 'set_field.OrderClass=' + salesforceFieldVsSalesforceVsHansaPicklist.get('order_class__c').get(acc.order_class__c) + '&';
                            }
                        }
                    }

                    if(acc.Warning_Quotation_Order__c != null){
                        fieldsValue += 'set_field.WarnText1=' + acc.Warning_Quotation_Order__c + '&';
                    }

                    if(acc.Website != null){
                        fieldsValue += 'set_field.wwwAddr=' + acc.Website + '&';
                    }

                    if(acc.Phone != null){
                        fieldsValue += 'set_field.Phone=' + acc.Phone + '&';
                    }

                    if(acc.Email__c != null){
                        fieldsValue += 'set_field.eMail=' + acc.Email__c + '&';
                    } 

                    if(acc.Shipping_Instructions__c != null){
                        fieldsValue += 'set_field.PNoteComment=' + acc.Shipping_Instructions__c + '&';
                    }

                    if(acc.LFY_Actual_Sales__c != null){
                        fieldsValue += 'set_field.UserVal1=' + acc.LFY_Actual_Sales__c + '&';
                    }
                    if(acc.Customer_VAT_No__c != null){
                        fieldsValue += 'set_field.VATNr=' + acc.Customer_VAT_No__c + '&';
                    }

                    if(acc.Credit_Limit__c != null){
                        fieldsValue += 'set_field.CurrCreditLimit=' + acc.Credit_Limit__c + '&';
                    }

                    if(acc.billingcity != null){
                        fieldsValue += 'set_field.InvAddr2=' + acc.billingcity + '&';
                    }                    

                    if(acc.billingstate != null){
                        fieldsValue += 'set_field.InvAddr3=' + acc.billingstate + '&';
                    }

                    if(acc.billingpostalcode != null){
                        fieldsValue += 'set_field.InvAddr4=' + acc.billingpostalcode + '&';
                    }

                    if(acc.billingcountrycode  != null){
                        fieldsValue += 'set_field.CountryCode=' + acc.billingcountrycode + '&';
                        fieldsValue += 'set_field.InvCountryName=' + acc.billingcountry + '&';
                    }

                    if(acc.billingstreet  != null){
                        list<string> addressSplit = acc.billingstreet.split('\n',2);
                        if(addressSplit.size() > 1){
                            fieldsValue += 'set_field.InvAddr0=' + addressSplit[0] + '&';
                            string address1 = '';
                            for(string enterSplit : addressSplit[1].split('\n')){
                                if(enterSplit != null && enterSplit != '' && address1 != ''){
                                    address1 += ', ' + enterSplit.replace('\r','');
                                }else if(enterSplit != null && enterSplit != '' ){
                                    address1 += enterSplit.replace('\r','');
                                }
                            }
                            fieldsValue += 'set_field.InvAddr1=' + address1 + '&';
                        }else{
                            fieldsValue += 'set_field.InvAddr0=' + addressSplit[0] + '&';
                        }                        
                    }

                    if(acc.shippingcity != null){
                        fieldsValue += 'set_field.DelAddr2=' + acc.shippingcity + '&';
                    }                    

                    if(acc.shippingstate != null){
                        fieldsValue += 'set_field.DelAddr3=' + acc.shippingstate + '&';
                    }

                    if(acc.shippingpostalcode != null){
                        fieldsValue += 'set_field.DelAddr4=' + acc.shippingpostalcode + '&';
                    }

                    if(acc.shippingcountrycode  != null){
                        fieldsValue += 'set_field.DelCountry=' + acc.shippingcountrycode + '&';
                        fieldsValue += 'set_field.DelCountryName=' + acc.shippingcountry + '&';
                    }

                    if(acc.shippingstreet  != null){
                        list<string> addressSplit = acc.shippingstreet.split('\n',2);
                        if(addressSplit.size() > 1){
                            fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                            string address1 = '';
                            for(string enterSplit : addressSplit[1].split('\n')){
                                if(enterSplit != null && enterSplit != '' && address1 != ''){
                                    address1 += ', ' + enterSplit.replace('\r','');
                                }else if(enterSplit != null && enterSplit != '' ){
                                    address1 += enterSplit.replace('\r','');
                                }
                            }
                            fieldsValue += 'set_field.DelAddr1=' + address1 + '&';
                        }else{
                            fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                        }                        
                    }

                    if(ceetakLocation != '' && salesArea != '' && customerCategory != ''){
                       fieldsValue += 'set_field.Classification=' + ceetakLocation + ',' + salesArea + ',' + customerCategory + '&';
                    }                    
                    
                }
                else if(acc.recordTypeId != null && acc.recordtype.name == 'Supplier' && !customSettting.isEmpty()){
                    endPointURL = customSettting[0].Customer_Supplier_End_Point_URL__c + 'set_field.VEType=1&set_field.CUType=0&set_field.CustCat=S';
                    
                    fieldsValue += 'set_field.SalesForceID=' + acc.id + '&set_field.Name=' + acc.name + '&';
                    if(acc.Account_Status__c != null){
                        if(acc.Account_Status__c == 'Open'){
                            fieldsValue +=  'set_field.blockedFlag=0&'; 
                        }else if(acc.Account_Status__c == 'Closed'){
                            fieldsValue +=  'set_field.blockedFlag=1&';
                        }
                    }                    

                    if(acc.currencyisocode != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('currencyisocode')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode').containsKey(acc.currencyisocode)){
                                fieldsValue += 'set_field.VECurncyCode=' + salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode').get(acc.currencyisocode) + '&';
                            }
                        }
                    }

                    if(acc.vat_code__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('vat_code__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c').containsKey(acc.vat_code__c)){
                                fieldsValue += 'set_field.VEVATCode=' + salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c').get(acc.vat_code__c) + '&';
                            }
                        }
                    }

                    if(acc.vat_zone__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('vat_zone__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').containsKey(acc.vat_zone__c)){
                                fieldsValue += 'set_field.ExportFlag=' + salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').get(acc.vat_zone__c) + '&';
                            }
                        }
                    } 

                    if(acc.incoterms_shipping_terms__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('incoterms_shipping_terms__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c').containsKey(acc.incoterms_shipping_terms__c)){
                                fieldsValue += 'set_field.VEShipDeal=' + salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c').get(acc.incoterms_shipping_terms__c) + '&';
                            }
                        }
                    }

                    if(acc.payment_terms__c != null){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('payment_terms__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c').containsKey(acc.payment_terms__c)){
                                fieldsValue += 'set_field.VEPayDeal=' + salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c').get(acc.payment_terms__c) + '&';
                            }
                        }
                    }

                    if(acc.owner.Hansa_Initials__c != null){
                        fieldsValue +=  'set_field.AccountManager='+acc.owner.Hansa_Initials__c + '&';
                    }

                    if(acc.Website != null){
                        fieldsValue += 'set_field.wwwAddr=' + acc.Website + '&';
                    }

                    if(acc.Phone != null){
                        fieldsValue += 'set_field.Phone=' + acc.Phone + '&';
                    }

                    if(acc.Email__c != null){
                        fieldsValue += 'set_field.eMail=' + acc.Email__c + '&';
                    } 

                    if(acc.Freight_Charges_Actual__c != null){
                        fieldsValue += 'set_field.UserStr4=' + acc.Freight_Charges_Actual__c + '&';
                    }
                    
                    if(acc.Duty_Charges_Actual__c != null){
                        fieldsValue += 'set_field.UserStr5=' + acc.Duty_Charges_Actual__c + '&';
                    } 

                    if(acc.Bank_Account_No__c != null){
                        fieldsValue += 'set_field.BankAccount=' + acc.Bank_Account_No__c + '&';
                    }
                    
                    if(acc.Bank_Sort_Code__c != null){
                        fieldsValue += 'set_field.SortCode=' + acc.Bank_Sort_Code__c + '&';
                    } 

                    if(acc.billingcity != null){
                        fieldsValue += 'set_field.InvAddr2=' + acc.billingcity + '&';
                    }                    

                    if(acc.billingstate != null){
                        fieldsValue += 'set_field.InvAddr3=' + acc.billingstate + '&';
                    }

                    if(acc.billingpostalcode != null){
                        fieldsValue += 'set_field.InvAddr4=' + acc.billingpostalcode + '&';
                    }

                    if(acc.billingcountrycode  != null){
                        fieldsValue += 'set_field.CountryCode=' + acc.billingcountrycode + '&';
                        fieldsValue += 'set_field.InvCountryName=' + acc.billingcountry + '&';
                    }

                    if(acc.billingstreet  != null){
                        list<string> addressSplit = acc.billingstreet.split('\n',2);
                        if(addressSplit.size() > 1){
                            fieldsValue += 'set_field.InvAddr0=' + addressSplit[0] + '&';
                            string address1 = '';
                            for(string enterSplit : addressSplit[1].split('\n')){
                                if(enterSplit != null && enterSplit != '' && address1 != ''){
                                    address1 += ', ' + enterSplit.replace('\r','');
                                }else if(enterSplit != null && enterSplit != '' ){
                                    address1 += enterSplit.replace('\r','');
                                }
                            }
                            fieldsValue += 'set_field.InvAddr1=' + address1 + '&';
                        }else{
                            fieldsValue += 'set_field.InvAddr0=' + addressSplit[0] + '&';
                        }                        
                    }

                    if(acc.shippingcity != null){
                        fieldsValue += 'set_field.DelAddr2=' + acc.shippingcity + '&';
                    }                    

                    if(acc.shippingstate != null){
                        fieldsValue += 'set_field.DelAddr3=' + acc.shippingstate + '&';
                    }

                    if(acc.shippingpostalcode != null){
                        fieldsValue += 'set_field.DelAddr4=' + acc.shippingpostalcode + '&';
                    }

                    if(acc.shippingcountrycode  != null){
                        fieldsValue += 'set_field.DelCountry=' + acc.shippingcountrycode + '&';
            fieldsValue += 'set_field.DelCountryName=' + acc.shippingcountry + '&';
                    }

                    if(acc.shippingstreet  != null){
                        list<string> addressSplit = acc.shippingstreet.split('\n',2);
                        if(addressSplit.size() > 1){
                            fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                            string address1 = '';
                            for(string enterSplit : addressSplit[1].split('\n')){
                                if(enterSplit != null && enterSplit != '' && address1 != ''){
                                    address1 += ', ' + enterSplit.replace('\r','');
                                }else if(enterSplit != null && enterSplit != '' ){
                                    address1 += enterSplit.replace('\r','');
                                }
                            }
                            fieldsValue += 'set_field.DelAddr1=' + address1 + '&';
                        }else{
                            fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                        }                        
                    }
                    
                    System.debug('##### filling HANSA Classification');
                    if(acc.owner.Hansa_Initials__c!=null){
                        System.debug('#@@@@ 1 Hansa Initial added '+acc.owner.Hansa_Initials__c);
                        fieldsValue += 'set_field.Classification=' +acc.owner.Hansa_Initials__c +'&';
                    }

                }
                system.debug('endPointURL+++'+endPointURL);
                if(endPointURL != '' && !customSettting.isEmpty() && customSettting[0].Customer_Supplier_End_Point_URL__c != null){  
                    system.debug('@@@@@@#### fieldsValue++'+fieldsValue.substringBeforeLast('&'));
                    HttpRequest req = new HttpRequest();
                    req.setMethod('POST');
                    
                    req.setHeader('Authorization','Bearer '+hansaAccessToken);
                    //req.setHeader('Content-Type','text/xml'); 
                    
                    req.setEndpoint(endPointURL);
                    req.setBody(fieldsValue);
                    req.setHeader('Content-Type','application/x-www-form-urlencoded');
                    req.setTimeout(120000);             
                    Http http = new Http();
                    HTTPResponse res;
                    try{ 
                      res = http.send(req); 
                    }catch(Exception e){
                        system.debug('Exception Line Number '+e.getLineNumber());
                        system.debug('Exception Message '+e.getMessage());
                        acc.Hansa_Sync_Error__c = true; 
                        acc.Hansa_JSON_Body__c = e.getMessage();
                    }                    
                    if(res != null && res.getStatusCode() != null){
                        acc.Hansa_Status_Code__c = string.valueOf(res.getStatusCode());
                    }
                    if(res != null && res.getBody() != null){
                        System.debug('BODY: '+res.getBody()); 
                        System.debug('STATUS:'+res.getStatus());
                        System.debug('STATUS_CODE:'+res.getStatusCode());
                        acc.Hansa_JSON_Body__c = res.getBody();
                        acc.Hansa_Last_Sync_Date__c = system.today();
                        if(res.getStatusCode() == 200){
                            try{
                                Dom.Document doc = new Dom.Document();
                                doc.load(res.getBody());                        
                                Dom.XMLNode dataRegister = doc.getRootElement();
                                if(dataRegister.getChildElement('CUVc', null) != null){
                                    for (Dom.XMLNode child: dataRegister.getChildElement('CUVc', null).getChildElements()) {
                                        if(child.getName() == 'Code'){
                                            if(acc.recordTypeId != null && acc.recordtype.name == 'Customer'){
                                                acc.Hansa_Account_Number__c = string.valueOf(child.getText().trim());
                                                acc.Hansa_Sync_Error__c = false;  
                                            }else if(acc.recordTypeId != null && acc.recordtype.name == 'Supplier'){
                                                acc.Hansa_Supplier_Number__c = string.valueOf(child.getText().trim());
                                                acc.Hansa_Sync_Error__c = false;  
                                            }                                            
                                        }
                                        // system.debug('++'+child.getName());
                                        // system.debug('++'+child.getText().trim());
                                    }  
                                }
                            }catch(Exception e){
                                system.debug('Exception Line Number '+e.getLineNumber());
                                system.debug('Exception Message '+e.getMessage());
                                acc.Hansa_Sync_Error__c = true;
                            }
                        }
                    }
                    accountListToUpdate.add(acc);
                }
            }            
        }else if(hansaAccessToken == '' || hansaAccessToken == null  || hansaAccessToken == 'Error in Access Token Request'){
            for(Account acc : [select id,Hansa_JSON_Body__c,Hansa_Status_Code__c from account where id in : accountIds]){
                acc.Hansa_JSON_Body__c = 'Error in hansa token request, Token = '+hansaAccessToken;
                acc.Hansa_Sync_Error__c = true;
                accountListToUpdate.add(acc);
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

/**
    * ───────────────────────────────────────────────────────────────────────────────────────────────────┐
    *  Final callout to hansa to update customer and supplier accounts in hansa called form Account trigger
    * ────────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    Set<string>      accountIds
    * ───────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static void postToHansaUpdate(set<string> accountIds,Set<string> fieldChangesForCustomer, set<string> fieldChangesForSupplier, boolean syncButton ){
        RunOnce.accountTrigger = false;
        string hansaAccessToken = '';
        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Customer_Supplier_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklist = new map<string,map<string,string>>();
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklistSupplier = new map<string,map<string,string>>();

        // Generate Hansa Token(Start)
        if(!test.isRunningTest()){
            hansaAccessToken = GenerateHansaAccessToken.generateAccessToken();
        }else{
            hansaAccessToken = 'Test hansa token'; 
        }
        // Generate Hansa Token(End)
        system.debug('hansaAccessToken+++'+hansaAccessToken);

        list<account> accountListToUpdate = new list<account>();        
        if(hansaAccessToken != '' && hansaAccessToken != null  && hansaAccessToken != 'Error in Access Token Request'){            
            
            string accountQuery = 'select id,Account_Status__c,name,Language__c,Duty_Charges_Actual__c,Bank_Account_No__c,Bank_Sort_Code__c,Freight_Charges_Actual__c,BillingCountryCode,Same_as_Billing_Address__c,shippingcountrycode,Ceetak_Location__c,Website,Sales_Area__c,Phone,Email__c,Customer_Category__c,EDI_Customer__c,Shipping_Instructions__c,LFY_Actual_Sales__c,CurrencyIsoCode,VAT_Code__c,VAT_Zone__c,Customer_VAT_No__c,Incoterms_Shipping_Terms__c,Payment_Terms__c,Credit_Limit__c,Credit_Balance__c,billingstreet,billingcity,billingstate,billingpostalcode,billingcountry,shippingstreet,shippingcity,shippingstate,shippingpostalcode,shippingcountry,recordtype.name,Hansa_Account_Number__c,Hansa_Supplier_Number__c,recordTypeId,Hansa_JSON_Body__c,Hansa_Status_Code__c,owner.Hansa_Initials__c,Hansa_Sync_Error__c,Warning_Quotation_Order__c,order_class__c from account where id in : accountIds';
            system.debug('accountQuery'+accountQuery);
            list<account> accountRecords = database.query(accountQuery);
            system.debug('accountRecords++'+accountRecords);

            salesforceFieldVsSalesforceVsHansaPicklist = getCustomSettingRecords('Account_Mapping_Customer__c');
            salesforceFieldVsSalesforceVsHansaPicklistSupplier = getCustomSettingRecords('Account_Mapping_Supplier__c');

            for(Account acc : accountRecords){
                string endPointURL = '';
                string fieldsValue = '';
                boolean setClassification = false;
                fieldsValue += 'set_field.SalesForceID=' + acc.id + '&'; 
                if(acc.recordTypeId != null && acc.recordtype.name == 'Customer' && !customSettting.isEmpty() && (!fieldChangesForCustomer.isEmpty() || syncButton)){
                    endPointURL = customSettting[0].Customer_Supplier_End_Point_URL__c.substringBeforeLast('?') + '/' + acc.Hansa_Account_Number__c + '?';

                    if(acc.name != null && (fieldChangesForCustomer.contains('name') || syncButton) ){
                        fieldsValue += '&set_field.Name=' + acc.name + '&';
                    }

                    
                    // Getting the hansa picklist value from selected picklist value in salesforce
                    if(acc.Ceetak_Location__c != null  && (fieldChangesForCustomer.contains('ceetak_location__c') || syncButton)){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('ceetak_location__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('ceetak_location__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('ceetak_location__c').containsKey(acc.Ceetak_Location__c)){
                                fieldsValue += 'set_field.OrderLocation=' + salesforceFieldVsSalesforceVsHansaPicklist.get('ceetak_location__c').get(acc.Ceetak_Location__c)+ '&';
                                setClassification = true;
                            }
                        }
                    }else if(fieldChangesForCustomer.contains('ceetak_location__c') || syncButton){
                        fieldsValue += 'set_field.OrderLocation=' + '' + '&';
                        setClassification = true;
                    }                    

                    if(acc.Language__c != null  && (fieldChangesForCustomer.contains('language__c') || syncButton)){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('language__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('language__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('language__c').containsKey(acc.language__c)){
                                fieldsValue += 'set_field.LangCode=' + salesforceFieldVsSalesforceVsHansaPicklist.get('language__c').get(acc.language__c) + '&';
                            }
                        }
                    }else if(fieldChangesForCustomer.contains('language__c') || syncButton){
                        fieldsValue += 'set_field.LangCode=' + '' + '&';
                    }

                    if(acc.Sales_Area__c != null  && (fieldChangesForCustomer.contains('sales_area__c') || syncButton)){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('sales_area__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('sales_area__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('sales_area__c').containsKey(acc.sales_area__c)){
                                fieldsValue += 'set_field.SalesMan=' + salesforceFieldVsSalesforceVsHansaPicklist.get('sales_area__c').get(acc.sales_area__c) + '&';
                                setClassification = true;
                            }
                        }
                    }else if(fieldChangesForCustomer.contains('sales_area__c') || syncButton){
                        fieldsValue += 'set_field.SalesMan=' + '' + '&';
                        setClassification = true;
                    }                                     

                    if(acc.Customer_Category__c != null  && (fieldChangesForCustomer.contains('customer_category__c') || syncButton)){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('customer_category__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('customer_category__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('customer_category__c').containsKey(acc.customer_category__c)){
                                fieldsValue += 'set_field.CustCat=' + salesforceFieldVsSalesforceVsHansaPicklist.get('customer_category__c').get(acc.customer_category__c)+ '&';
                                setClassification = true;
                            }
                        }
                    }else if(fieldChangesForCustomer.contains('customer_category__c') || syncButton){
                        fieldsValue += 'set_field.CustCat=' + '' + '&';
                        setClassification = true;
                    } 

                    if(acc.EDI_Customer__c != null  && (fieldChangesForCustomer.contains('edi_customer__c') || syncButton)){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('edi_customer__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('edi_customer__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('edi_customer__c').containsKey(acc.edi_customer__c)){
                                fieldsValue += 'set_field.EDIFlag=' + salesforceFieldVsSalesforceVsHansaPicklist.get('edi_customer__c').get(acc.edi_customer__c) + '&';
                            }
                        }
                    }else if(fieldChangesForCustomer.contains('edi_customer__c') || syncButton){
                        fieldsValue += 'set_field.EDIFlag=' + '' + '&';
                    } 
                    
                    if(acc.currencyisocode != null  && (fieldChangesForCustomer.contains('currencyisocode') || syncButton)){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('currencyisocode')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode').containsKey(acc.currencyisocode)){
                                fieldsValue += 'set_field.CurncyCode=' + salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode').get(acc.currencyisocode) + '&';
                            }
                        }
                    }

                    if(acc.vat_code__c != null  && (fieldChangesForCustomer.contains('vat_code__c') || syncButton)){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('vat_code__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c').containsKey(acc.vat_code__c)){
                                fieldsValue += 'set_field.VATCode=' + salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c').get(acc.vat_code__c) + '&';
                            }
                        }
                    }else if(fieldChangesForCustomer.contains('vat_code__c') || syncButton){
                        fieldsValue += 'set_field.VATCode=' + '' + '&';
                    }

                    if(acc.vat_zone__c != null  && (fieldChangesForCustomer.contains('vat_zone__c') || syncButton)){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('vat_zone__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').containsKey(acc.vat_zone__c)){
                                fieldsValue += 'set_field.ExportFlag=' + salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').get(acc.vat_zone__c) + '&';
                            }
                        }
                    }else if(fieldChangesForCustomer.contains('vat_zone__c') || syncButton){
                        fieldsValue += 'set_field.ExportFlag=' + '' + '&';
                    }                    

                    if(acc.incoterms_shipping_terms__c != null  && (fieldChangesForCustomer.contains('incoterms_shipping_terms__c') || syncButton)){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('incoterms_shipping_terms__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c').containsKey(acc.incoterms_shipping_terms__c)){
                                fieldsValue += 'set_field.ShipDeal=' + salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c').get(acc.incoterms_shipping_terms__c) + '&';
                            }
                        }
                    }else if(fieldChangesForCustomer.contains('incoterms_shipping_terms__c') || syncButton){
                        fieldsValue += 'set_field.ShipDeal=' + '' + '&';
                    }

                    if(acc.payment_terms__c != null  && (fieldChangesForCustomer.contains('payment_terms__c')  || syncButton)){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('payment_terms__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c').containsKey(acc.payment_terms__c)){
                                fieldsValue += 'set_field.PayDeal=' + salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c').get(acc.payment_terms__c) + '&';
                            }
                        }
                    }else if(fieldChangesForCustomer.contains('payment_terms__c') || syncButton){
                        fieldsValue += 'set_field.PayDeal=' + '' + '&';
                    }

                    if(acc.order_class__c != null  && (fieldChangesForCustomer.contains('order_class__c')  || syncButton)){
                        if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('order_class__c')){
                            if(salesforceFieldVsSalesforceVsHansaPicklist.get('order_class__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('order_class__c').containsKey(acc.order_class__c)){
                                fieldsValue += 'set_field.OrderClass=' + salesforceFieldVsSalesforceVsHansaPicklist.get('order_class__c').get(acc.order_class__c) + '&';
                            }
                        }
                    }else if(fieldChangesForCustomer.contains('order_class__c') || syncButton){
                        fieldsValue += 'set_field.OrderClass=' + '' + '&';
                    }


                    if(acc.Warning_Quotation_Order__c != null  && (fieldChangesForCustomer.contains('warning_quotation_order__c') || syncButton)){
                        fieldsValue += 'set_field.WarnText1=' + acc.Warning_Quotation_Order__c + '&';
                    }else if(fieldChangesForCustomer.contains('warning_quotation_order__c') || syncButton){
                        fieldsValue += 'set_field.WarnText1=' + '' + '&';
                    }

                    if(acc.Website != null  && (fieldChangesForCustomer.contains('website') || syncButton)){
                        fieldsValue += 'set_field.wwwAddr=' + acc.Website + '&';
                    }else if(fieldChangesForCustomer.contains('website') || syncButton){
                        fieldsValue += 'set_field.wwwAddr=' + '' + '&';
                    }

                    if(acc.Phone != null  && (fieldChangesForCustomer.contains('phone') || syncButton)){
                        fieldsValue += 'set_field.Phone=' + acc.Phone + '&';
                    }else if(fieldChangesForCustomer.contains('phone') || syncButton){
                        fieldsValue += 'set_field.Phone=' + '' + '&';
                    }

                    if(acc.Email__c != null  && (fieldChangesForCustomer.contains('email__c') || syncButton)){
                        fieldsValue += 'set_field.eMail=' + acc.Email__c + '&';
                    }else if(fieldChangesForCustomer.contains('email__c') || syncButton){
                        fieldsValue += 'set_field.eMail=' + '' + '&';
                    } 

                    if(acc.Shipping_Instructions__c != null && (fieldChangesForCustomer.contains('shipping_instructions__c') || syncButton)){
                        fieldsValue += 'set_field.PNoteComment=' + acc.Shipping_Instructions__c + '&';
                    }else if(fieldChangesForCustomer.contains('shipping_instructions__c') || syncButton){
                        fieldsValue += 'set_field.PNoteComment=' + '' + '&';
                    } 

                    
                    if(acc.Customer_VAT_No__c != null && (fieldChangesForCustomer.contains('customer_vat_no__c') || syncButton)){
                        fieldsValue += 'set_field.VATNr=' + acc.Customer_VAT_No__c + '&';
                    }else if(fieldChangesForCustomer.contains('customer_vat_no__c') || syncButton){
                        fieldsValue += 'set_field.VATNr=' + '' + '&';
                    } 

                    if(acc.Credit_Limit__c != null && (fieldChangesForCustomer.contains('credit_limit__c') || syncButton)){
                        fieldsValue += 'set_field.CurrCreditLimit=' + acc.Credit_Limit__c + '&';
                    }else if(fieldChangesForCustomer.contains('credit_limit__c') || syncButton){
                        fieldsValue += 'set_field.CurrCreditLimit=' + '' + '&';
                    } 

                    if(acc.billingcity != null && (fieldChangesForCustomer.contains('billingcity') || syncButton)){
                        fieldsValue += 'set_field.InvAddr2=' + acc.billingcity + '&';
                    }else if(fieldChangesForCustomer.contains('billingcity') || syncButton){
                        fieldsValue += 'set_field.InvAddr2=' + '' + '&';
                    }                     

                    if(acc.billingstate != null && (fieldChangesForCustomer.contains('billingstate') || syncButton)){
                        fieldsValue += 'set_field.InvAddr3=' + acc.billingstate + '&';
                    }else if(fieldChangesForCustomer.contains('billingstate') || syncButton){
                        fieldsValue += 'set_field.InvAddr3=' + '' + '&';
                    } 

                    if(acc.billingpostalcode != null && (fieldChangesForCustomer.contains('billingpostalcode') || syncButton)){
                        fieldsValue += 'set_field.InvAddr4=' + acc.billingpostalcode + '&';
                    }else if(fieldChangesForCustomer.contains('billingpostalcode') || syncButton){
                        fieldsValue += 'set_field.InvAddr4=' + '' + '&';
                    } 

                    if(acc.billingcountrycode  != null && (fieldChangesForCustomer.contains('billingcountrycode') || syncButton)){
                        fieldsValue += 'set_field.CountryCode=' + acc.billingcountrycode + '&';
                        fieldsValue += 'set_field.InvCountryName=' + acc.billingcountry + '&';
                    }else if(fieldChangesForCustomer.contains('billingcountrycode') || syncButton){
                        fieldsValue += 'set_field.CountryCode=' + '' + '&';
                        fieldsValue += 'set_field.InvCountryName=' + '' + '&';
                    } 

                    if(acc.billingstreet  != null && (fieldChangesForCustomer.contains('billingstreet') || syncButton)){
                        list<string> addressSplit = acc.billingstreet.split('\n',2);
                        if(addressSplit.size() > 1){
                            fieldsValue += 'set_field.InvAddr0=' + addressSplit[0] + '&';                            
                            string address1 = '';
                            for(string enterSplit : addressSplit[1].split('\n')){
                                if(enterSplit != null && enterSplit != '' && address1 != ''){
                                    address1 += ', ' + enterSplit.replace('\r','');
                                }else if(enterSplit != null && enterSplit != '' ){
                                    address1 += enterSplit.replace('\r','');
                                }
                            }
                            fieldsValue += 'set_field.InvAddr1=' + address1 + '&';
                        }else{
                            fieldsValue += 'set_field.InvAddr0=' + addressSplit[0] + '&';
                            fieldsValue += 'set_field.InvAddr1=' + '' + '&';
                        }                        
                    }else if(fieldChangesForCustomer.contains('billingstreet') || syncButton){
                        fieldsValue += 'set_field.InvAddr0=' + '' + '&';
                        fieldsValue += 'set_field.InvAddr1=' + '' + '&';
                    }

                    
                    if(acc.Same_as_Billing_Address__c){
                        if(acc.billingcity != null && (fieldChangesForCustomer.contains('billingcity') || syncButton)){
                            fieldsValue += 'set_field.DelAddr2=' + acc.billingcity + '&';
                        }else if(fieldChangesForCustomer.contains('billingcity') || syncButton){
                            fieldsValue += 'set_field.DelAddr2=' + '' + '&';
                        }                     
    
                        if(acc.billingstate != null && (fieldChangesForCustomer.contains('billingstate') || syncButton)){
                            fieldsValue += 'set_field.DelAddr3=' + acc.billingstate + '&';
                        }else if(fieldChangesForCustomer.contains('billingstate') || syncButton){
                            fieldsValue += 'set_field.DelAddr3=' + '' + '&';
                        } 
    
                        if(acc.billingpostalcode != null && (fieldChangesForCustomer.contains('billingpostalcode') || syncButton)){
                            fieldsValue += 'set_field.DelAddr4=' + acc.billingpostalcode + '&';
                        }else if(fieldChangesForCustomer.contains('billingpostalcode') || syncButton){
                            fieldsValue += 'set_field.DelAddr4=' + '' + '&';
                        } 
    
                        if(acc.billingcountrycode  != null && (fieldChangesForCustomer.contains('billingcountrycode') || syncButton)){
                            fieldsValue += 'set_field.DelCountry=' + acc.billingcountrycode + '&';
                fieldsValue += 'set_field.DelCountryName=' + acc.billingcountry + '&';
                        }else if(fieldChangesForCustomer.contains('billingcountrycode') || syncButton){
                            fieldsValue += 'set_field.DelCountry=' + '' + '&';
                fieldsValue += 'set_field.DelCountryName=' + '' + '&';
                        } 
    
                        if(acc.billingstreet  != null && (fieldChangesForCustomer.contains('billingstreet') || syncButton)){
                            list<string> addressSplit = acc.billingstreet.split('\n',2);
                            if(addressSplit.size() > 1){
                                fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                                string address1 = '';
                                for(string enterSplit : addressSplit[1].split('\n')){
                                    if(enterSplit != null && enterSplit != '' && address1 != ''){
                                        address1 += ', ' + enterSplit.replace('\r','');
                                    }else if(enterSplit != null && enterSplit != '' ){
                                        address1 += enterSplit.replace('\r','');
                                    }
                                }
                                fieldsValue += 'set_field.DelAddr1=' + address1 + '&';
                            }else{
                                fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                                fieldsValue += 'set_field.DelAddr1=' + '' + '&';
                            }                        
                        }else if(fieldChangesForCustomer.contains('billingstreet') || syncButton){
                            fieldsValue += 'set_field.DelAddr0=' + '' + '&';
                            fieldsValue += 'set_field.DelAddr1=' + '' + '&';
                        } 
                    }else{
                        if(acc.shippingcity != null  && (fieldChangesForCustomer.contains('shippingcity') || syncButton)){
                            fieldsValue += 'set_field.DelAddr2=' + acc.shippingcity + '&';
                        }else if(fieldChangesForCustomer.contains('shippingcity') || syncButton){
                            fieldsValue += 'set_field.DelAddr2=' + '' + '&';
                        }                    
    
                        if(acc.shippingstate != null && (fieldChangesForCustomer.contains('shippingstate') || syncButton)){
                            fieldsValue += 'set_field.DelAddr3=' + acc.shippingstate + '&';
                        }else if(fieldChangesForCustomer.contains('shippingstate') || syncButton){
                            fieldsValue += 'set_field.DelAddr3=' + '' + '&';
                        }
    
                        if(acc.shippingpostalcode != null && (fieldChangesForCustomer.contains('shippingpostalcode') || syncButton)){
                            fieldsValue += 'set_field.DelAddr4=' + acc.shippingpostalcode + '&';
                        }else if(fieldChangesForCustomer.contains('shippingpostalcode') || syncButton){
                            fieldsValue += 'set_field.DelAddr4=' + '' + '&';
                        }
    
                        if(acc.shippingcountrycode  != null && (fieldChangesForCustomer.contains('shippingcountrycode') || syncButton)){
                            fieldsValue += 'set_field.DelCountry=' + acc.shippingcountrycode + '&';
                fieldsValue += 'set_field.DelCountryName=' + acc.shippingcountry + '&';
                        }else if(fieldChangesForCustomer.contains('shippingcountrycode') || syncButton){
                            fieldsValue += 'set_field.DelCountry=' + '' + '&';
                fieldsValue += 'set_field.DelCountryName=' + '' + '&';
                        }
    
                        if(acc.shippingstreet  != null && (fieldChangesForCustomer.contains('shippingstreet') || syncButton)){
                            list<string> addressSplit = acc.shippingstreet.split('\n',2);
                            if(addressSplit.size() > 1){
                                fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                                string address1 = '';
                                for(string enterSplit : addressSplit[1].split('\n')){
                                    if(enterSplit != null && enterSplit != '' && address1 != ''){
                                        address1 += ', ' + enterSplit.replace('\r','');
                                    }else if(enterSplit != null && enterSplit != '' ){
                                        address1 += enterSplit.replace('\r','');
                                    }
                                }
                                fieldsValue += 'set_field.DelAddr1=' + address1 + '&';
                            }else{
                                fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                                fieldsValue += 'set_field.DelAddr1=' + '' + '&';
                            }                        
                        }else if(fieldChangesForCustomer.contains('shippingstreet') || syncButton){
                            fieldsValue += 'set_field.DelAddr0=' + '' + '&';
                            fieldsValue += 'set_field.DelAddr1=' + '' + '&';
                        }
                    }
                    
                    if(setClassification){
                        fieldsValue += 'set_field.Classification=' ;
                        if(acc.Ceetak_Location__c != null){
                            if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('ceetak_location__c')){
                                if(salesforceFieldVsSalesforceVsHansaPicklist.get('ceetak_location__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('ceetak_location__c').containsKey(acc.Ceetak_Location__c)){
                                    fieldsValue +=  salesforceFieldVsSalesforceVsHansaPicklist.get('ceetak_location__c').get(acc.Ceetak_Location__c)+ ',';
                                }
                            }
                        }                    
    
                        if(acc.Sales_Area__c != null){
                            if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('sales_area__c')){
                                if(salesforceFieldVsSalesforceVsHansaPicklist.get('sales_area__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('sales_area__c').containsKey(acc.sales_area__c)){
                                    fieldsValue += salesforceFieldVsSalesforceVsHansaPicklist.get('sales_area__c').get(acc.sales_area__c) + ',';
                                }
                            } 
                        }                                     
    
                        if(acc.Customer_Category__c != null){
                            if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('customer_category__c')){
                                if(salesforceFieldVsSalesforceVsHansaPicklist.get('customer_category__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('customer_category__c').containsKey(acc.customer_category__c)){
                                    fieldsValue += salesforceFieldVsSalesforceVsHansaPicklist.get('customer_category__c').get(acc.customer_category__c);
                                }
                            }
                        }
                    } 
                    
                }
                else if(acc.recordTypeId != null && acc.recordtype.name == 'Supplier' && !customSettting.isEmpty() && (!fieldChangesForSupplier.isEmpty() || syncButton)){
                   // Supplier Mapping
                   endPointURL = customSettting[0].Customer_Supplier_End_Point_URL__c.substringBeforeLast('?') + '/' + acc.Hansa_Supplier_Number__c + '?'; 
                                       
                   if(acc.name != null && (fieldChangesForSupplier.contains('name') || syncButton)){
                       fieldsValue += '&set_field.Name=' + acc.name + '&';
                   }                

                   if(acc.currencyisocode != null && (fieldChangesForSupplier.contains('currencyisocode') || syncButton)){
                       if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('currencyisocode')){
                           if(salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode').containsKey(acc.currencyisocode)){
                               fieldsValue += 'set_field.VECurncyCode=' + salesforceFieldVsSalesforceVsHansaPicklist.get('currencyisocode').get(acc.currencyisocode) + '&';
                           }
                       }
                   }

                   if(acc.vat_code__c != null  && (fieldChangesForSupplier.contains('vat_code__c') || syncButton)){
                       if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('vat_code__c')){
                           if(salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c').containsKey(acc.vat_code__c)){
                               fieldsValue += 'set_field.VEVATCode=' + salesforceFieldVsSalesforceVsHansaPicklist.get('vat_code__c').get(acc.vat_code__c) + '&';
                           }
                       }
                   }else if(fieldChangesForSupplier.contains('vat_code__c') || syncButton){
                       fieldsValue += 'set_field.VEVATCode=' + '' + '&';
                   } 

                   if(acc.vat_zone__c != null && (fieldChangesForSupplier.contains('vat_zone__c') || syncButton)){
                       if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('vat_zone__c')){
                           if(salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').containsKey(acc.vat_zone__c)){
                               fieldsValue += 'set_field.ExportFlag=' + salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').get(acc.vat_zone__c) + '&';
                           }
                       }
                   }else if(fieldChangesForSupplier.contains('vat_zone__c') || syncButton){
                       fieldsValue += 'set_field.ExportFlag=' + '' + '&';
                   } 

                   if(acc.incoterms_shipping_terms__c != null && (fieldChangesForSupplier.contains('incoterms_shipping_terms__c') || syncButton)){
                       if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('incoterms_shipping_terms__c')){
                           if(salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c').containsKey(acc.incoterms_shipping_terms__c)){
                               fieldsValue += 'set_field.VEShipDeal=' + salesforceFieldVsSalesforceVsHansaPicklist.get('incoterms_shipping_terms__c').get(acc.incoterms_shipping_terms__c) + '&';
                           }
                       }
                   }else if(fieldChangesForSupplier.contains('incoterms_shipping_terms__c') || syncButton){
                       fieldsValue += 'set_field.VEShipDeal=' + '' + '&';
                   } 

                   if(acc.payment_terms__c != null && (fieldChangesForSupplier.contains('payment_terms__c') || syncButton)){
                       if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('payment_terms__c')){
                           if(salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c').containsKey(acc.payment_terms__c)){
                               fieldsValue += 'set_field.VEPayDeal=' + salesforceFieldVsSalesforceVsHansaPicklist.get('payment_terms__c').get(acc.payment_terms__c) + '&';
                           }
                       }
                   }else if(fieldChangesForSupplier.contains('payment_terms__c') || syncButton){
                       fieldsValue += 'set_field.VEPayDeal=' + '' + '&';
                   } 

                   if(acc.owner.Hansa_Initials__c != null && (fieldChangesForSupplier.contains('ownerid') || syncButton)){
                       fieldsValue +=  'set_field.AccountManager='+acc.owner.Hansa_Initials__c + '&';
                   }else{
                       if(fieldChangesForSupplier.contains('ownerid') || syncButton){
                           fieldsValue += 'set_field.AccountManager=' + '' + '&';
                       }   
                   } 

                   if(acc.Website != null && (fieldChangesForSupplier.contains('website') || syncButton)){
                       fieldsValue += 'set_field.wwwAddr=' + acc.Website + '&';
                   }else if(fieldChangesForSupplier.contains('website') || syncButton){
                       fieldsValue += 'set_field.wwwAddr=' + '' + '&';
                   } 

                   if(acc.Phone != null && (fieldChangesForSupplier.contains('phone') || syncButton)){
                       fieldsValue += 'set_field.Phone=' + acc.Phone + '&';
                   }else if(fieldChangesForSupplier.contains('phone') || syncButton){
                       fieldsValue += 'set_field.Phone=' + '' + '&';
                   } 

                   if(acc.Email__c != null && (fieldChangesForSupplier.contains('email__c') || syncButton)){
                       fieldsValue += 'set_field.eMail=' + acc.Email__c + '&';
                   }else if(fieldChangesForSupplier.contains('email__c') || syncButton){
                       fieldsValue += 'set_field.eMail=' + '' + '&';
                   } 

                   if(acc.Bank_Account_No__c != null && (fieldChangesForSupplier.contains('bank_account_no__c') || syncButton)){
                       fieldsValue += 'set_field.BankAccount=' + acc.Bank_Account_No__c + '&';
                   }else if(fieldChangesForSupplier.contains('bank_account_no__c') || syncButton){
                       fieldsValue += 'set_field.BankAccount=' + '' + '&';
                   } 
                   
                   if(acc.Bank_Sort_Code__c != null && (fieldChangesForSupplier.contains('bank_sort_code__c') || syncButton)){
                       fieldsValue += 'set_field.SortCode=' + acc.Bank_Sort_Code__c + '&';
                   }else if(fieldChangesForSupplier.contains('bank_sort_code__c') || syncButton){
                       fieldsValue += 'set_field.SortCode=' + '' + '&';
                   } 

                   if(acc.billingcity != null && (fieldChangesForSupplier.contains('billingcity') || syncButton)){
                       fieldsValue += 'set_field.InvAddr2=' + acc.billingcity + '&';
                   }else if(fieldChangesForSupplier.contains('billingcity') || syncButton){
                       fieldsValue += 'set_field.InvAddr2=' + '' + '&';
                   }                     

                   if(acc.billingstate != null && (fieldChangesForSupplier.contains('billingstate') || syncButton)){
                       fieldsValue += 'set_field.InvAddr3=' + acc.billingstate + '&';
                   }else if(fieldChangesForSupplier.contains('billingstate') || syncButton){
                       fieldsValue += 'set_field.InvAddr3=' + '' + '&';
                   } 

                   if(acc.billingpostalcode != null && (fieldChangesForSupplier.contains('billingpostalcode') || syncButton)){
                       fieldsValue += 'set_field.InvAddr4=' + acc.billingpostalcode + '&';
                   }else if(fieldChangesForSupplier.contains('billingpostalcode') || syncButton){
                       fieldsValue += 'set_field.InvAddr4=' + '' + '&';
                   } 

                   if(acc.billingcountrycode  != null && (fieldChangesForSupplier.contains('billingcountrycode') || syncButton)){
                       fieldsValue += 'set_field.CountryCode=' + acc.billingcountrycode + '&';
                       fieldsValue += 'set_field.InvCountryName=' + acc.billingcountry + '&';
                   }else if(fieldChangesForSupplier.contains('billingcountrycode') || syncButton){
                       fieldsValue += 'set_field.CountryCode=' + '' + '&';
                       fieldsValue += 'set_field.InvCountryName=' + '' + '&';
                   } 

                   if(acc.billingstreet  != null && (fieldChangesForSupplier.contains('billingstreet') || syncButton)){
                       list<string> addressSplit = acc.billingstreet.split('\n',2);
                       if(addressSplit.size() > 1){
                           fieldsValue += 'set_field.InvAddr0=' + addressSplit[0] + '&';
                           string address1 = '';
                           for(string enterSplit : addressSplit[1].split('\n')){
                                if(enterSplit != null && enterSplit != '' && address1 != ''){
                                    address1 += ', ' + enterSplit.replace('\r','');
                                }else if(enterSplit != null && enterSplit != '' ){
                                    address1 += enterSplit.replace('\r','');
                                }
                            }
                            fieldsValue += 'set_field.InvAddr1=' + address1 + '&';
                       }else{
                           fieldsValue += 'set_field.InvAddr0=' + addressSplit[0] + '&';
                           fieldsValue += 'set_field.InvAddr1=' + '' + '&';
                       }                        
                   }else if(fieldChangesForSupplier.contains('billingstreet') || syncButton){
                       fieldsValue += 'set_field.InvAddr0=' + '' + '&';
                       fieldsValue += 'set_field.InvAddr1=' + '' + '&';
                   }

                   
                   if(acc.Same_as_Billing_Address__c){
                       if(acc.billingcity != null && (fieldChangesForSupplier.contains('billingcity') || syncButton)){
                           fieldsValue += 'set_field.DelAddr2=' + acc.billingcity + '&';
                       }else if(fieldChangesForSupplier.contains('billingcity') || syncButton){
                           fieldsValue += 'set_field.DelAddr2=' + '' + '&';
                       }                     
   
                       if(acc.billingstate != null && (fieldChangesForSupplier.contains('billingstate') || syncButton)){
                           fieldsValue += 'set_field.DelAddr3=' + acc.billingstate + '&';
                       }else if(fieldChangesForSupplier.contains('billingstate') || syncButton){
                           fieldsValue += 'set_field.DelAddr3=' + '' + '&';
                       } 
   
                       if(acc.billingpostalcode != null && (fieldChangesForSupplier.contains('billingpostalcode') || syncButton)){
                           fieldsValue += 'set_field.DelAddr4=' + acc.billingpostalcode + '&';
                       }else if(fieldChangesForSupplier.contains('billingpostalcode') || syncButton){
                           fieldsValue += 'set_field.DelAddr4=' + '' + '&';
                       } 
   
                       if(acc.billingcountrycode  != null && (fieldChangesForSupplier.contains('billingcountrycode') || syncButton)){
                           fieldsValue += 'set_field.DelCountry=' + acc.billingcountrycode + '&';
               fieldsValue += 'set_field.DelCountryName=' + acc.billingcountry + '&';
                       }else if(fieldChangesForSupplier.contains('billingcountrycode') || syncButton){
                           fieldsValue += 'set_field.DelCountry=' + '' + '&';
               fieldsValue += 'set_field.DelCountryName=' + '' + '&';
                       } 
   
                       if(acc.billingstreet  != null && (fieldChangesForSupplier.contains('billingstreet') || syncButton)){
                           list<string> addressSplit = acc.billingstreet.split('\n',2);
                           if(addressSplit.size() > 1){
                               fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                               string address1 = '';
                                for(string enterSplit : addressSplit[1].split('\n')){
                                    if(enterSplit != null && enterSplit != '' && address1 != ''){
                                        address1 += ', ' + enterSplit.replace('\r','');
                                    }else if(enterSplit != null && enterSplit != '' ){
                                        address1 += enterSplit.replace('\r','');
                                    }
                                }
                                fieldsValue += 'set_field.DelAddr1=' + address1 + '&';
                           }else{
                               fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                               fieldsValue += 'set_field.DelAddr1=' + '' + '&'; 
                           }                        
                       }else if(fieldChangesForSupplier.contains('billingstreet') || syncButton){
                           fieldsValue += 'set_field.DelAddr0=' + '' + '&';
                           fieldsValue += 'set_field.DelAddr1=' + '' + '&';
                       } 
                   }else{
                       if(acc.shippingcity != null  && (fieldChangesForSupplier.contains('shippingcity') || syncButton)){
                           fieldsValue += 'set_field.DelAddr2=' + acc.shippingcity + '&';
                       }else if(fieldChangesForSupplier.contains('shippingcity') || syncButton){
                           fieldsValue += 'set_field.DelAddr2=' + '' + '&';
                       }                    
   
                       if(acc.shippingstate != null && (fieldChangesForSupplier.contains('shippingstate') || syncButton)){
                           fieldsValue += 'set_field.DelAddr3=' + acc.shippingstate + '&';
                       }else if(fieldChangesForSupplier.contains('shippingstate') || syncButton){
                           fieldsValue += 'set_field.DelAddr3=' + '' + '&';
                       }
   
                       if(acc.shippingpostalcode != null && (fieldChangesForSupplier.contains('shippingpostalcode') || syncButton)){
                           fieldsValue += 'set_field.DelAddr4=' + acc.shippingpostalcode + '&';
                       }else if(fieldChangesForSupplier.contains('shippingpostalcode') || syncButton){
                           fieldsValue += 'set_field.DelAddr4=' + '' + '&';
                       }
   
                       if(acc.shippingcountrycode  != null && (fieldChangesForSupplier.contains('shippingcountrycode') || syncButton)){
                           fieldsValue += 'set_field.DelCountry=' + acc.shippingcountrycode + '&';
               fieldsValue += 'set_field.DelCountryName=' + acc.shippingcountry + '&';
                       }else if(fieldChangesForSupplier.contains('shippingcountrycode') || syncButton){
                           fieldsValue += 'set_field.DelCountry=' + '' + '&';
               fieldsValue += 'set_field.DelCountryName=' + '' + '&';
                       }
   
                       if(acc.shippingstreet  != null && (fieldChangesForSupplier.contains('shippingstreet') || syncButton)){
                           list<string> addressSplit = acc.shippingstreet.split('\n',2);
                           if(addressSplit.size() > 1){
                               fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                               string address1 = '';
                                for(string enterSplit : addressSplit[1].split('\n')){
                                    if(enterSplit != null && enterSplit != '' && address1 != ''){
                                        address1 += ', ' + enterSplit.replace('\r','');
                                    }else if(enterSplit != null && enterSplit != '' ){
                                        address1 += enterSplit.replace('\r','');
                                    }
                                }
                                fieldsValue += 'set_field.DelAddr1=' + address1 + '&';
                           }else{
                               fieldsValue += 'set_field.DelAddr0=' + addressSplit[0] + '&';
                               fieldsValue += 'set_field.DelAddr1=' + '' + '&'; 
                           }                        
                       }else if(fieldChangesForSupplier.contains('shippingstreet') || syncButton){
                           fieldsValue += 'set_field.DelAddr0=' + '' + '&';
                           fieldsValue += 'set_field.DelAddr1=' + '' + '&';
                       }                       
                   }
                    System.debug('##### filling Update Supplier HANSA Classification');
                    if(acc.owner.Hansa_Initials__c!=null){
                        System.debug('#@@@@  Hansa Initial added '+acc.owner.Hansa_Initials__c);
                        fieldsValue += 'set_field.Classification='+ acc.owner.Hansa_Initials__c +'&';
                    }
                }
                system.debug('endPointURL+++'+endPointURL);
                if(endPointURL != '' && !customSettting.isEmpty() && customSettting[0].Customer_Supplier_End_Point_URL__c != null && fieldsValue != null && fieldsValue != ''){  
                    system.debug('@@@@@@ fieldsValue++'+fieldsValue.substringBeforeLast('&'));
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
        }else if(hansaAccessToken == '' || hansaAccessToken == null  || hansaAccessToken == 'Error in Access Token Request'){
            for(Account acc : [select id,Hansa_JSON_Body__c,Hansa_Status_Code__c from account where id in : accountIds]){
                acc.Hansa_JSON_Body__c = 'Error in hansa token request, Token = '+hansaAccessToken;
                acc.Hansa_Sync_Error__c = true;
                accountListToUpdate.add(acc);
            }
        }
        system.debug('accountListToUpdate+++++'+accountListToUpdate);
        if(!accountListToUpdate.isEmpty()){
            try{
                update accountListToUpdate;
            }catch(Exception e){
                system.debug('@@@@@@@@@@@  Exception Line Number '+e.getLineNumber());
                system.debug('@@@@@@@@@@@  Exception Message '+e.getMessage()); 
            }
        }
    }
/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    *  Fetching Picklist field mapping for supplier accounts
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    String      customSettingName
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
*/
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
}