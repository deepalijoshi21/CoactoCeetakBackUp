/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is used to handle logic for Alternate Shipping/Delivery Addresses trigger handler
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class AlternateShippingTriggerHandler {
    public static void processAddressToHansa(map<id,Alternate_Shipping_Delivery_Address__c> newMap, map<id,Alternate_Shipping_Delivery_Address__c> oldMap){
        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Turn_of_Address_Sync__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Alternate_Shipping_Delivery_Address__c.fields.getMap();  // Get all fields of account using schema
        set<string> processAddressToHansaRecordIds = new set<string>();
        set<string> updateAddressChangesToHansa = new set<string>();
        set<string> addressMappingFieldsForHansa = new set<string>{'account__c','name','shipping_street_address_line_1__c','shipping_street_address_line_2__c','shipping_street_address_line_3__c',
                                                   'shipping_city__c','shipping_state_county__c','shipping_zip_post_code__c','shipping_country_name__c','contact_name__c','contact_phone__c','vat_zone__c'};
        set<string> fieldChangesForAddress = new set<string>(); 

        if(newMap != null){
            for(String alternateAddressRecordId : newMap.keySet()){
                if(trigger.isInsert){
                    processAddressToHansaRecordIds.add(alternateAddressRecordId);
                }else if(trigger.isUpdate && oldMap != null ){
                    for (String fieldName: schemaFieldMap.keySet()) {
                         if(addressMappingFieldsForHansa.contains(fieldName)  && newMap.get(alternateAddressRecordId).Created_In_Hansa__c && newMap.get(alternateAddressRecordId).get(fieldName) != oldMap.get(alternateAddressRecordId).get(fieldName)){
                            updateAddressChangesToHansa.add(alternateAddressRecordId);
                            fieldChangesForAddress.add(fieldName);
                         }                     
                    }
                    if(!newMap.get(alternateAddressRecordId).Created_In_Hansa__c){
                        processAddressToHansaRecordIds.add(alternateAddressRecordId);
                    }
                }
            }
            
            
        }

        if(!processAddressToHansaRecordIds.isEmpty() && !customSettting.isEmpty() && !customSettting[0].Turn_of_Address_Sync__c){
            if(!System.isFuture() && !System.isBatch()){
                //If future is allowed, batch up account ids into batches of 25. We have to make one callout per account.  We're better off splitting into many @future methods in this case.
                Integer i = 0;
                Set<string> addressIdsToProcessBatch = new Set<string>();
                for(String addressId : processAddressToHansaRecordIds){
                    addressIdsToProcessBatch.add(addressId);
                     i++;
                     if(i == 25){
                         processAlternateAddressBatch(addressIdsToProcessBatch,true,new set<string>());
                         addressIdsToProcessBatch = new Set<string>(); 
                         i = 0;
                     }
                 }
                 if(!addressIdsToProcessBatch.isEmpty()){
                    processAlternateAddressBatch(addressIdsToProcessBatch,true,new set<string>());
                 }
             }
        }

        if(!updateAddressChangesToHansa.isEmpty() && !customSettting.isEmpty() && !customSettting[0].Turn_of_Address_Sync__c){
            if(!System.isFuture() && !System.isBatch()){
                //If future is allowed, batch up account ids into batches of 25. We have to make one callout per account.  We're better off splitting into many @future methods in this case.
                Integer i = 0;
                Set<string> addressIdsToProcessBatch = new Set<string>();
                for(String addressId : updateAddressChangesToHansa){
                    addressIdsToProcessBatch.add(addressId);
                     i++;
                     if(i == 25){
                         processAlternateAddressBatch(addressIdsToProcessBatch,false,fieldChangesForAddress);
                         addressIdsToProcessBatch = new Set<string>(); 
                         i = 0;
                     }
                 }
                 if(!addressIdsToProcessBatch.isEmpty()){
                    processAlternateAddressBatch(addressIdsToProcessBatch,false,fieldChangesForAddress);
                 }
             }
        }
    } 

    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    * Future method to split bulk Alternate Shipping Addresses into batches of 25.
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    Set<string>      AlternateAddressIds
    * @param    boolean          isNew
    * @param    Set<string>      fieldChangesForAddress
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
   */
    @future(callout=true)
    public static void processAlternateAddressBatch(Set<string> AlternateAddressIds, boolean isNew, set<string> fieldChangesForAddress){
        if(isNew){
            postToHansa(AlternateAddressIds);
        }else{
            postToHansaAddressUpdate(AlternateAddressIds,fieldChangesForAddress,false);
        }
    }
    
    
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    *  Final callout to hansa to create alternate address in hansa
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    Set<string>      AlternateAddressIds
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void postToHansa(set<string> AlternateAddressIds){
        string hansaAccessToken = '';
        list<Alternate_Shipping_Delivery_Address__c> alternateAddressToUpdate = new list<Alternate_Shipping_Delivery_Address__c>();
        list<Hansa_ERP__c> alternateAddressEndPoint = new list<Hansa_ERP__c>([select id,name,Alternate_Address_End_Point__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
        string fieldValues = '';
        map<string,string> countryNameVsCode = getCountriesCode();
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklist = new map<string,map<string,string>>();

        // Generate Hansa Token(Start)
        if(!test.isRunningTest()){
            hansaAccessToken = GenerateHansaAccessToken.generateAccessToken();
        }else{
            hansaAccessToken = 'Test hansa token'; 
        }

        

        system.debug('hansaAccessToken+++'+hansaAccessToken);
        if(hansaAccessToken != '' && hansaAccessToken != null  && hansaAccessToken != 'Error in Access Token Request' && !alternateAddressEndPoint.isEmpty() && alternateAddressEndPoint[0].Alternate_Address_End_Point__c != null){            
            salesforceFieldVsSalesforceVsHansaPicklist = getCustomSettingRecords('Alternate_Address__c');  
            for(Alternate_Shipping_Delivery_Address__c alternateAddress : [select id,name,Account__c,Account__r.name,Code__c,
                                                                           Created_In_Hansa__c,Hansa_Account_Number__c,In_Active__c,
                                                                           Shipping_City__c,Shipping_Country_Name__c,Shipping_State_County__c,
                                                                           Shipping_Street_Address_Line_1__c,Shipping_Street_Address_Line_2__c,
                                                                           Shipping_Street_Address_Line_3__c,Shipping_Zip_Post_Code__c,
                                                                           Contact_Name__c, Contact_Phone__c, VAT_Zone__c
                                                                           from Alternate_Shipping_Delivery_Address__c where id in : AlternateAddressIds]){
                   
                   if(alternateAddress.Hansa_Account_Number__c != null && alternateAddress.Code__c != null){
                        fieldValues = '';

                        if(alternateAddress.Account__c != null ){
                            fieldValues += 'set_field.CustCode=' + alternateAddress.Hansa_Account_Number__c +'\n';
                        }

                        if(alternateAddress.Account__c != null ){
                            fieldValues += 'set_field.DelCode=' + alternateAddress.Code__c +'\n';
                        }

                        if(alternateAddress.Account__c != null ){
                            fieldValues += 'set_field.Name=' + alternateAddress.Account__r.name +'\n';
                        }

                        if(alternateAddress.Name != null ){
                            fieldValues += 'set_field.Comment=' + alternateAddress.Name +'\n';
                        }

                        if(alternateAddress.Contact_Name__c != null ){
                            fieldValues += 'set_field.Contact=' + alternateAddress.Contact_Name__c +'\n';
                        }

                        if(alternateAddress.Contact_Phone__c != null ){
                            fieldValues += 'set_field.Phone=' + alternateAddress.Contact_Phone__c +'\n';
                        }

                        if(alternateAddress.VAT_Zone__c != null  ){
                            if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('vat_zone__c')){
                                if(salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').containsKey(alternateAddress.vat_zone__c.trim())){
                                    fieldValues += 'set_field.ExportFlag=' + salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').get(alternateAddress.vat_zone__c.trim()) +'\n';
                                }
                            }
                        }                        

                        if(alternateAddress.Shipping_Street_Address_Line_1__c != null ){
                            fieldValues += 'set_field.DelAddr0=' + alternateAddress.Shipping_Street_Address_Line_1__c +'\n';
                        }

                        if(alternateAddress.Shipping_Street_Address_Line_2__c != null || alternateAddress.Shipping_Street_Address_Line_3__c != null ){
                            //fieldValues += 'set_field.DelAddr1=' + alternateAddress.Shipping_Street_Address_Line_2__c +'\n';
                            if(alternateAddress.Shipping_Street_Address_Line_2__c != null){
                                fieldValues += 'set_field.DelAddr1=' + alternateAddress.Shipping_Street_Address_Line_2__c ;
                            } 

                            if(alternateAddress.Shipping_Street_Address_Line_3__c != null){
                                if(alternateAddress.Shipping_Street_Address_Line_2__c != null && alternateAddress.Shipping_Street_Address_Line_2__c != ''){
                                    fieldValues += ', ' + alternateAddress.Shipping_Street_Address_Line_3__c +'\n' ;
                                }else{
                                    fieldValues += 'set_field.DelAddr1=' + alternateAddress.Shipping_Street_Address_Line_3__c +'\n' ;
                                }
                            }else{
                                fieldValues += '\n';
                            }                            
                        }

                        if(alternateAddress.Shipping_City__c != null ){
                            fieldValues += 'set_field.DelAddr2=' + alternateAddress.Shipping_City__c +'\n';
                        }

                        if(alternateAddress.Shipping_State_County__c != null ){
                            fieldValues += 'set_field.DelAddr3=' + alternateAddress.Shipping_State_County__c +'\n';
                        }

                        if(alternateAddress.Shipping_Zip_Post_Code__c != null ){
                            fieldValues += 'set_field.DelAddr4=' + alternateAddress.Shipping_Zip_Post_Code__c +'\n';
                        }

                        if(alternateAddress.Shipping_Country_Name__c != null ){
                            fieldValues += 'set_field.DelCountryName=' + alternateAddress.Shipping_Country_Name__c +'\n';
                            if(countryNameVsCode.containsKey(alternateAddress.Shipping_Country_Name__c)){
                                fieldValues += 'set_field.DelCountry=' + countryNameVsCode.get(alternateAddress.Shipping_Country_Name__c) ;
                            }
                        }

                        system.debug('fieldsValue++'+fieldValues);
                        HttpRequest req = new HttpRequest();
                        req.setMethod('PUT');                    
                        req.setHeader('Authorization','Bearer '+hansaAccessToken);
                        //req.setHeader('Content-Type','text/xml');                     
                        req.setEndpoint(alternateAddressEndPoint[0].Alternate_Address_End_Point__c);
                        req.setBody(fieldValues);
                        req.setHeader('Content-Type','application/x-www-form-urlencoded');
                        req.setTimeout(120000);            
                        Http http = new Http();
                        HTTPResponse res;
                        try{
                            res = http.send(req);
                            if(res != null){
                                System.debug('BODY: '+res.getBody()); 
                                System.debug('STATUS:'+res.getStatus());
                                System.debug('STATUS_CODE:'+res.getStatusCode());
                                if(res.getStatusCode() != null){
                                    alternateAddress.Hansa_Status_Code__c = string.valueOf(res.getStatusCode());
                                }
                                alternateAddress.Hansa_JSON_Body__c = res.getBody();
                                alternateAddress.Hansa_Sync_Error__c = false;
                                alternateAddress.Hansa_Last_Sync_Date__c = system.now();
                            
                                Dom.Document doc = new Dom.Document();
                                doc.load(res.getBody());                            
                                Dom.XMLNode dataRegister = doc.getRootElement();
                                if(dataRegister.getChildElement('error', null) != null){
                                    alternateAddress.Hansa_Sync_Error__c = true;
                                    alternateAddress.Created_In_Hansa__c = false;
                                }
                                
                                if(dataRegister.getChildElement('DelAddrVc', null) != null){
                                    for (Dom.XMLNode child: dataRegister.getChildElement('DelAddrVc', null).getChildElements()) {                                        
                                        if(child.getName() == 'SyncFlags'){
                                            if(child.getText().trim() == '1'){
                                                alternateAddress.Created_In_Hansa__c = true;
                                            }else{
                                                alternateAddress.Created_In_Hansa__c = false;
                                            }                                            
                                        }else if(child.getName() == 'error'){
                                            alternateAddress.Hansa_Sync_Error__c = true;
                                        }                                        
                                    }  
                                }
                            }
                        }catch(Exception e){
                            system.debug('Exception Line Number '+e.getLineNumber());
                            system.debug('Exception Message '+e.getMessage());
                            alternateAddress.Hansa_Sync_Error__c = true; 
                            alternateAddress.Hansa_JSON_Body__c = e.getMessage();
                            alternateAddress.Hansa_Last_Sync_Date__c = system.now();                           
                        }
                        alternateAddressToUpdate.add(alternateAddress);
                    }
               }
        }else if(hansaAccessToken == '' || hansaAccessToken == null  || hansaAccessToken == 'Error in Access Token Request'){
                for(Alternate_Shipping_Delivery_Address__c alternateAddress : [select id,Hansa_JSON_Body__c,Hansa_Status_Code__c from Alternate_Shipping_Delivery_Address__c where id in : AlternateAddressIds]){
                    alternateAddress.Hansa_JSON_Body__c = 'Error in hansa token request, Token = '+hansaAccessToken;
                    alternateAddress.Hansa_Sync_Error__c = true;
                    alternateAddress.Hansa_Last_Sync_Date__c = system.now();
                    alternateAddressToUpdate.add(alternateAddress);
                }  
        }
        system.debug('alternateAddressToUpdate+++++'+alternateAddressToUpdate);
        if(!alternateAddressToUpdate.isEmpty()){
            Database.SaveResult[] srList = database.update(alternateAddressToUpdate,false); 
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Fields that affected this error: ' + err.getFields());
                    }
                }
            }           
        }
    }

    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    *  Final callout to hansa to update alternate address in hansa
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    Set<string>      AlternateAddressIds
    * @param    Set<string>      fieldChangesForAddress
    * @param    boolean          customSync
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public static void postToHansaAddressUpdate(set<string> AlternateAddressIds,Set<string> fieldChangesForAddress, boolean customSync){
        
        list<Alternate_Shipping_Delivery_Address__c> alternateAddressToUpdate = new list<Alternate_Shipping_Delivery_Address__c>();
        list<Hansa_ERP__c> alternateAddressEndPoint = new list<Hansa_ERP__c>([select id,name,Alternate_Address_End_Point__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
        map<string,string> countryNameVsCode = getCountriesCode();
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklist = new map<string,map<string,string>>();
        string hansaAccessToken = '';
        string herokuEndPoint = 'https://erp-sync.herokuapp.com/getData';
        string endPointURL = '';
        string fieldValues = '';
        string body = '';
        // Generate Hansa Token(Start)
        if(!test.isRunningTest()){
            hansaAccessToken = GenerateHansaAccessToken.generateAccessToken();
        }else{
            hansaAccessToken = 'Test hansa token'; 
        }

        

        system.debug('hansaAccessToken+++'+hansaAccessToken);
        if(hansaAccessToken != '' && hansaAccessToken != null  && hansaAccessToken != 'Error in Access Token Request' && !alternateAddressEndPoint.isEmpty() && alternateAddressEndPoint[0].Alternate_Address_End_Point__c != null){            
            salesforceFieldVsSalesforceVsHansaPicklist = getCustomSettingRecords('Alternate_Address__c');
            for(Alternate_Shipping_Delivery_Address__c alternateAddress : [select id,name,Account__c,Account__r.name,Code__c,
                                                                           Created_In_Hansa__c,Hansa_Account_Number__c,In_Active__c,
                                                                           Shipping_City__c,Shipping_Country_Name__c,Shipping_State_County__c,
                                                                           Shipping_Street_Address_Line_1__c,Shipping_Street_Address_Line_2__c,
                                                                           Shipping_Street_Address_Line_3__c,Shipping_Zip_Post_Code__c,
                                                                           contact_name__c,  contact_phone__c, vat_zone__c
                                                                           from Alternate_Shipping_Delivery_Address__c where id in : AlternateAddressIds]){
                   fieldValues = '';
                   endPointURL = '';
                   body = '';
                   if(alternateAddress.Hansa_Account_Number__c != null && alternateAddress.Code__c != null){ 

                        if(alternateAddress.Account__c != null && (fieldChangesForAddress.contains('account__c') || customSync) ){
                            fieldValues += 'set_field.Name=' + alternateAddress.Account__r.name +'\n';
                        }else if(fieldChangesForAddress.contains('account__c') || customSync){
                            fieldValues += 'set_field.Name=' + '' +'\n';
                        }

                        if(alternateAddress.Name != null && (fieldChangesForAddress.contains('name') || customSync) ){
                            fieldValues += 'set_field.Comment=' + alternateAddress.Name +'\n';
                        }else if(fieldChangesForAddress.contains('name') || customSync){
                            fieldValues += 'set_field.Comment=' + '' +'\n';
                        }

                        if(alternateAddress.Contact_Name__c != null && (fieldChangesForAddress.contains('contact_name__c') || customSync) ){
                            fieldValues += 'set_field.Contact=' + alternateAddress.Contact_Name__c +'\n';
                        }else if(fieldChangesForAddress.contains('contact_name__c') || customSync){
                            fieldValues += 'set_field.Contact=' + '' +'\n';
                        }

                        if(alternateAddress.Contact_Phone__c != null && (fieldChangesForAddress.contains('contact_phone__c') || customSync) ){
                            fieldValues += 'set_field.Phone=' + alternateAddress.Contact_Phone__c +'\n';
                        }else if(fieldChangesForAddress.contains('contact_phone__c') || customSync){
                            fieldValues += 'set_field.Phone=' + '' +'\n';
                        }

                        if(alternateAddress.VAT_Zone__c != null  && (fieldChangesForAddress.contains('vat_zone__c') || customSync) ){
                            if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty() && salesforceFieldVsSalesforceVsHansaPicklist.containsKey('vat_zone__c')){
                                if(salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c') != null && salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').containsKey(alternateAddress.vat_zone__c.trim())){
                                    fieldValues += 'set_field.ExportFlag=' + salesforceFieldVsSalesforceVsHansaPicklist.get('vat_zone__c').get(alternateAddress.vat_zone__c.trim()) +'\n';
                                }
                            }
                        }else if(fieldChangesForAddress.contains('vat_zone__c') || customSync){
                            fieldValues += 'set_field.ExportFlag=' + '' +'\n';
                        }

                        if(alternateAddress.Shipping_Street_Address_Line_1__c != null && (fieldChangesForAddress.contains('shipping_street_address_line_1__c') || customSync) ){
                            fieldValues += 'set_field.DelAddr0=' + alternateAddress.Shipping_Street_Address_Line_1__c +'\n';
                        }else if(fieldChangesForAddress.contains('shipping_street_address_line_1__c') || customSync){
                            fieldValues += 'set_field.DelAddr0=' + '' +'\n';
                        }

                        if((alternateAddress.Shipping_Street_Address_Line_2__c != null || alternateAddress.Shipping_Street_Address_Line_3__c != null) && ((fieldChangesForAddress.contains('shipping_street_address_line_2__c') || fieldChangesForAddress.contains('shipping_street_address_line_3__c')) || customSync) ){
                            //fieldValues += 'set_field.DelAddr1=' + alternateAddress.Shipping_Street_Address_Line_2__c +'\n';
                            if(alternateAddress.Shipping_Street_Address_Line_2__c != null){
                                fieldValues += 'set_field.DelAddr1=' + alternateAddress.Shipping_Street_Address_Line_2__c ; 
                            }

                            if(alternateAddress.Shipping_Street_Address_Line_3__c != null){
                                if(alternateAddress.Shipping_Street_Address_Line_2__c != null && alternateAddress.Shipping_Street_Address_Line_2__c != ''){
                                    fieldValues += ', ' + alternateAddress.Shipping_Street_Address_Line_3__c +'\n' ;
                                }else{
                                    fieldValues += 'set_field.DelAddr1=' + alternateAddress.Shipping_Street_Address_Line_3__c +'\n' ;
                                }
                            }else{
                                fieldValues += '\n';
                            }
                        }else if((fieldChangesForAddress.contains('shipping_street_address_line_2__c') || fieldChangesForAddress.contains('shipping_street_address_line_3__c'))  || customSync){
                            fieldValues += 'set_field.DelAddr1=' + '' +'\n';
                        }

                        if(alternateAddress.Shipping_City__c != null && (fieldChangesForAddress.contains('shipping_city__c') || customSync) ){
                            fieldValues += 'set_field.DelAddr2=' + alternateAddress.Shipping_City__c +'\n';
                        }else if(fieldChangesForAddress.contains('shipping_city__c') || customSync){
                            fieldValues += 'set_field.DelAddr2=' + '' +'\n';
                        }

                        if(alternateAddress.Shipping_State_County__c != null && (fieldChangesForAddress.contains('shipping_state_county__c')|| customSync) ){
                            fieldValues += 'set_field.DelAddr3=' + alternateAddress.Shipping_State_County__c +'\n';
                        }else if(fieldChangesForAddress.contains('shipping_state_county__c') || customSync){
                            fieldValues += 'set_field.DelAddr3=' + '' +'\n';
                        }

                        if(alternateAddress.Shipping_Zip_Post_Code__c != null && (fieldChangesForAddress.contains('shipping_zip_post_code__c') || customSync) ){
                            fieldValues += 'set_field.DelAddr4=' + alternateAddress.Shipping_Zip_Post_Code__c +'\n';
                        }else if(fieldChangesForAddress.contains('shipping_zip_post_code__c') || customSync){
                            fieldValues += 'set_field.DelAddr4=' + '' +'\n';
                        }

                        if(alternateAddress.Shipping_Country_Name__c != null && (fieldChangesForAddress.contains('shipping_country_name__c') || customSync) ){
                            fieldValues += 'set_field.DelCountryName=' + alternateAddress.Shipping_Country_Name__c +'\n';
                            if(countryNameVsCode.containsKey(alternateAddress.Shipping_Country_Name__c)){
                                fieldValues += 'set_field.DelCountry=' + countryNameVsCode.get(alternateAddress.Shipping_Country_Name__c) ;
                            }
                        }else if(fieldChangesForAddress.contains('shipping_country_name__c') || customSync){
                            fieldValues += 'set_field.DelCountryName=' + '' +'\n';
                            fieldValues += 'set_field.DelCountry=' + '' ; 
                        }

                        system.debug('fieldsValue++'+fieldValues);
                        if(fieldValues != null && fieldValues != ''){  
                            endPointURL = alternateAddressEndPoint[0].Alternate_Address_End_Point__c+'?custcode='+alternateAddress.Hansa_Account_Number__c+'&delcode='+alternateAddress.Code__c;
                            system.debug('endPointURL++'+endPointURL);
                            body = 'authorizationToken='+EncodingUtil.urlEncode(hansaAccessToken,'UTF-8') + '&endPointURL='+EncodingUtil.urlEncode(endPointURL,'UTF-8')  + '&jsonBody='+EncodingUtil.urlEncode(fieldValues,'UTF-8');
                            Http addressReq = new Http();
                            HttpRequest addressData = new HttpRequest();
                            addressData.setMethod('POST');
                            addressData.setEndpoint(herokuEndPoint); 
                            addressData.setTimeout(120000);  
                            addressData.setHeader('Content-Type','application/x-www-form-urlencoded');
                            addressData.setBody(body);
                            HTTPResponse res;
                            try{
                                res = addressReq.send(addressData);
                                if(res != null){
                                    System.debug('BODY: '+res.getBody()); 
                                    System.debug('STATUS:'+res.getStatus());
                                    System.debug('STATUS_CODE:'+res.getStatusCode());
                                    if(res.getStatusCode() != null){
                                        alternateAddress.Hansa_Status_Code__c = string.valueOf(res.getStatusCode());
                                    }
                                    alternateAddress.Hansa_JSON_Body__c = res.getBody();
                                    alternateAddress.Hansa_Sync_Error__c = false;
                                    alternateAddress.Hansa_Last_Sync_Date__c = system.now();
                                    Map<String,Object> rawObj = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
                                    alternateAddress.Hansa_JSON_Body__c = string.valueOf(rawObj.get('body'));
                                    Dom.Document doc = new Dom.Document();
                                    string s = string.valueOf(rawObj.get('body')).replace('&','&amp;');
                                    doc.load(s);                             
                                    Dom.XMLNode dataRegister = doc.getRootElement();
                                    
                                    if(dataRegister.getChildElement('error', null) != null){
                                        alternateAddress.Hansa_Sync_Error__c = true;
                                    }                                    
                                    if(dataRegister.getChildElement('DelAddrVc', null) != null){
                                        for (Dom.XMLNode child: dataRegister.getChildElement('DelAddrVc', null).getChildElements()) {                                        
                                            if(child.getName() == 'error'){
                                                alternateAddress.Hansa_Sync_Error__c = true;
                                            }                                        
                                        }  
                                    }
                                }
                            }catch(Exception e){
                                system.debug('Exception Line Number '+e.getLineNumber());
                                system.debug('Exception Message '+e.getMessage());
                                alternateAddress.Hansa_Sync_Error__c = true;   
                                alternateAddress.Hansa_JSON_Body__c = e.getMessage();                         
                            }
                            alternateAddressToUpdate.add(alternateAddress);
                        }                        
                    }
               }
        }else if(hansaAccessToken == '' || hansaAccessToken == null  || hansaAccessToken == 'Error in Access Token Request'){
                for(Alternate_Shipping_Delivery_Address__c alternateAddress : [select id,Hansa_JSON_Body__c,Hansa_Status_Code__c from Alternate_Shipping_Delivery_Address__c where id in : AlternateAddressIds]){
                    alternateAddress.Hansa_JSON_Body__c = 'Error in hansa token request, Token = '+hansaAccessToken;
                    alternateAddress.Hansa_Sync_Error__c = true;
                    alternateAddress.Hansa_Last_Sync_Date__c = system.now();
                    alternateAddressToUpdate.add(alternateAddress);
                    alternateAddress.Hansa_Last_Sync_Date__c = system.now();
                }  
        }
        system.debug('alternateAddressToUpdate+++++'+alternateAddressToUpdate);
        if(!alternateAddressToUpdate.isEmpty()){
            Database.SaveResult[] srList = database.update(alternateAddressToUpdate,false); 
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Fields that affected this error: ' + err.getFields());
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

    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────┐
    *  Fetching Picklist field mapping for supplier accounts
    * ──────────────────────────────────────────────────────────────────────────────────────────────
    * @param    String      customSettingName
    * ─────────────────────────────────────────────────────────────────────────────────────────────┘
*/
    public static map<string,map<string,string>> getCustomSettingRecords(String customSettingName){        
            
        map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklist = new map<string,map<string,string>>();

        if(customSettingName == 'Alternate_Address__c'){
            for(Alternate_Address__c a: Alternate_Address__c.getall().values()){
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
            if(!salesforceFieldVsSalesforceVsHansaPicklist.isEmpty()){
                return salesforceFieldVsSalesforceVsHansaPicklist;
            }else{
                return new map<string,map<string,string>>();
            }            
        }
        return null;

    }

}