/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Description	:	Helper class for "coacto_PartSuplr_Trigger" Trigger
* Helper class	:	GenerateHansaAccessToken
* Test class	: 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Coacto Salesforce   
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class Coacto_PartSuplr_TriggerHelper {
    
    // MTHOD 1:
    // DESCRIPTON: handle bulk callout for new Part Supplier
    public static void handleBulk_NewPS(Set<Id> psIdSet, boolean isNew){        
        System.debug('@@@@@@@@ check bulkify ');
        Map<Id,Part_Suppliers__c> partSupplierRType_List = new Map<Id,Part_Suppliers__c>([SELECT id,RecordType.Name from Part_Suppliers__c where  RecordType.Name!=null AND Id IN: psIdSet]);
        
        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Turn_of_Product_Sync__c,Turn_of_Part_Supplier_Customer_Sync__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
        // CUSTOM SETTING TO PAUSE SYNC**
        if(!customSettting[0].Turn_of_Part_Supplier_Customer_Sync__c){
            if(!partSupplierRType_List.isEmpty()){
                if(!System.isFuture() && !System.isBatch()){
                    //If future is allowed, batch up Product ids into batches of 25.
                    Integer i = 0;
                    Integer j = 0;
                    Set<Id> psIdsToProcessBatch = new Set<Id>();
                    Set<Id> pCIdsToProcessBatch = new Set<Id>();
                    for(String psId : partSupplierRType_List.keySet()){
                        if(partSupplierRType_List.get(psId).RecordType.Name=='Part Supplier'){
                            i++;
                            psIdsToProcessBatch.add(psId);
                        }
                        else if(partSupplierRType_List.get(psId).RecordType.Name=='Part Customer'){
                            pCIdsToProcessBatch.add(psId);
                            j++;
                        }
                            
                        
                        if(i == 25){
                            System.debug('@@@@@@@@ 25 done');
                            if(!psIdsToProcessBatch.isEmpty() && isNew){
                                System.debug('@@@@@@@@ => call Put for 25 ');
                                // NEW
                                Coacto_PartSuplr_TriggerHelper.postToHansaPSupplier(psIdsToProcessBatch,true);
                            }
                            if(!psIdsToProcessBatch.isEmpty() && !isNew){
                                System.debug('@@@@@@@@ => call Patch for 25 ');
                                // UPDATE
                                Coacto_PartSuplr_TriggerHelper.patchToHansaPSupplier(psIdsToProcessBatch, true);
                            }
                            psIdsToProcessBatch = new Set<Id>();
                            i = 0;
                        }
                        
                        // PART CUSTOMER**
						//if(i == 25){  ------- using of wrong variable
                          if(j == 25){
                            System.debug('@@@@@@@@# 25 done');
                            if(!pCIdsToProcessBatch.isEmpty() && isNew){
                                System.debug('@@@@@@@@# => Part Customer call Put for 25 ');
                                // NEW
                                Coacto_PartSuplr_TriggerHelper.postToHansaPSupplier(pCIdsToProcessBatch,false);
                            }
                            if(!pCIdsToProcessBatch.isEmpty() && !isNew){
                                System.debug('@@@@@@@@# => Part Customer call Patch for 25 ');
                                // UPDATE
                                Coacto_PartSuplr_TriggerHelper.patchToHansaPSupplier(pCIdsToProcessBatch, false);
                            }
                            pCIdsToProcessBatch = new Set<Id>();
                            j = 0;
                        }
                        
                    }
                    
                    System.debug('psIdsToProcessBatch>>>>>>'+psIdsToProcessBatch);
                    System.debug('pCIdsToProcessBatch>>>>>>'+pCIdsToProcessBatch);
                    // CALL PART SUPPLIER**
                    System.debug('@@@@@@@@ Not 25 bulk ');
                    System.debug('@@@@@@@@ call put Part Supplier '+psIdsToProcessBatch);
                    if(!psIdsToProcessBatch.isEmpty() && isNew){
                        System.debug('@@@@@@@@ call put Part Supplier '+psIdsToProcessBatch);
                        Coacto_PartSuplr_TriggerHelper.postToHansaPSupplier(psIdsToProcessBatch, true);
                    }
                    if(!psIdsToProcessBatch.isEmpty() && !isNew){
                        System.debug('@@@@@@@@ call Patch  Part Supplier post=> '+psIdsToProcessBatch);
                        Coacto_PartSuplr_TriggerHelper.patchToHansaPSupplier(psIdsToProcessBatch,true);
                    }
                    
                    // CALL PART CUSTOMER**
                     System.debug('@@@@@@@@ Part customer Not 25 bulk ');
                    if(!pCIdsToProcessBatch.isEmpty() && isNew){
                        System.debug('@@@@@@@@ call put Part Customer '+pCIdsToProcessBatch);
                        Coacto_PartSuplr_TriggerHelper.postToHansaPSupplier(pCIdsToProcessBatch, false);
                    }
                    if(!pCIdsToProcessBatch.isEmpty() && !isNew){
                        System.debug('@@@@@@@@ call Patch  Part Customer post=> '+pCIdsToProcessBatch);
                        Coacto_PartSuplr_TriggerHelper.patchToHansaPSupplier(pCIdsToProcessBatch,false);
                    }
                    
                    
                }
            }    
        }
    }
    
    
    // METHOD 2: 
    // FOR NEW 'Part Supplier' TO POST TO HANSA**
    @future (callout=true)
    public static void postToHansaPSupplier(set<Id> psIdSet, boolean isPS){ 
        System.debug('@@@@@### call sync method ');
        
         System.debug('psIdSet '+ psIdSet);
        //try{
            boolean devStop = false;
            RunOnce.accountTrigger = false;
            string hansaAccessToken = '';
            list<Part_Suppliers__c> psListToUpdate = new List<Part_Suppliers__c>();
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
                string psQuery = 'SELECT Customer_Name__c,Customer_Product_Name__r.Product_Description__c, Customer_Name__r.Name, Hansa_Account_Number__c, Customer_Product_Name__c, Customer_Product_Name__r.Name, Customer_Item_Ref__c, Customer_Description__c, Customer_Drawing_Ref__c, Special_Requirements__c, Customer_Approval_Received__c, Approval_Date__c, Sales_Box_Qty__c, Sales_Bag_Qty__c, EDI_Item_No__c, Tariff_Code__c, No_of_Years_Productivity__c, id, Name,Supplier_Product_Name__c,Supplier_Product_Name__r.Name,Supplier_Name__c,Supplier_Name__r.Name, Ghost_PS_created_on_Hansa__c, Hansa_Sync_Error__c, Hansa_JSON_Body__c, Hansa_Last_Sync_Date__c, Hansa_Status_Code__c,Hansa_Supplier_Number__c,  Supplier_Part_Ref__c, Supplier_Drawing_No__c, Supplier_Drawing_Rev__c, Supplier_Material_Code__c, Country_of_Origin__c, Purch_Box_Qty__c, Purch_Bag_Qty__c, Purch_Box_Gross_Weight__c, Purch_Box_Dimensions__c, Purchase_Warning__c, Minimum_Order_Qty__c, Inactive__c, Default_Part_Supplier__c  FROM Part_Suppliers__c where Id IN: psIdSet';
                system.debug('@@@@@ ps pc Query ==> '+psQuery);
                list<Part_Suppliers__c> psRecords_list = database.query(psQuery);
                system.debug('@@@@@ Part Supplier Records ==> '+psRecords_list);
				 system.debug('@@ Check Records ==> '+psRecords_list[0].Hansa_Account_Number__c);
                for(Part_Suppliers__c partObj : psRecords_list){
                   // try{
                        string endPointURL = '';
                        string fieldsValue = ''; 
                        string ceetakLocation = '';
                        string salesArea = '';
                        string customerCategory = ''; 

                    // FILL HANSA REQUIRED FIELDS**
                    if(!partObj.Ghost_PS_created_on_Hansa__c){
                        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,Part_Supplier_End_Point_URL__c, Part_Customer_End_Point_URL__c, name,Turn_of_Product_Sync__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
                        if(isPS){
                            System.debug('@===> PS ');
                            //endPointURL = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/PIVc';
                            endPointURL = customSettting[0].Part_Supplier_End_Point_URL__c;
                            if(partObj.Supplier_Product_Name__c != null && partObj.Supplier_Name__c!=null && partObj.Hansa_Supplier_Number__c!=''){                            
                                fieldsValue += 'set_field.VEName=' + partObj.Supplier_Name__r.Name + '&set_field.ItemCode=' + partObj.Supplier_Product_Name__r.Name+ '&set_field.SalesForceID=' +partObj.Id;
                            }
                        }
                        else{
                            System.debug('@===> PC ');
                            //endPointURL = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/ABSCUINVc';
                            endPointURL = customSettting[0].Part_Customer_End_Point_URL__c;
                            System.debug('@===> PC '+ partObj.Hansa_Account_Number__c +'$$$'+ partObj.Customer_Product_Name__c);
                            if(partObj.Hansa_Account_Number__c!=null && partObj.Customer_Product_Name__c!=null){
                                fieldsValue +='set_field.CustCode='+partObj.Hansa_Account_Number__c+'&set_field.ArtCode='+partObj.Customer_Product_Name__r.Name+ '&set_field.SalesForceID=' +partObj.Id;
                                
                                if(partObj.Customer_Name__c!=null){
                                    fieldsValue += '&set_field.Addr0=' + partObj.Customer_Name__r.Name;
                                }
                                else
                                    fieldsValue += '&set_field.Addr0=' +'';
                            }
                        }
                    }
                    
                    //FILL REST OF THE MAPPING**
                    if(fieldsValue!='' && !devStop){
                        // if Part Supplier**
                        if(isPS){
                            if(partObj.Hansa_Supplier_Number__c!=null){
                                fieldsValue +='&set_field.VECode='+partObj.Hansa_Supplier_Number__c;
                            }
                            else
                                fieldsValue +='&set_field.VECode='+'';
                            // **
                            if(partObj.Supplier_Part_Ref__c!=null){
                                fieldsValue +='&set_field.VEItemCode='+partObj.Supplier_Part_Ref__c;
                            }
                            else
                                fieldsValue +='&set_field.VEItemCode='+'';
                            // **
                            if(partObj.Supplier_Drawing_No__c!=null){
                                fieldsValue +='&set_field.DrawingNr='+partObj.Supplier_Drawing_No__c;
                            }
                            else
                                fieldsValue +='&set_field.DrawingNr='+'';
                            // **
                            if(partObj.Supplier_Drawing_Rev__c!=null){
                                fieldsValue +='&set_field.DrawingRev='+partObj.Supplier_Drawing_Rev__c;
                            }
                            else
                                fieldsValue +='&set_field.DrawingRev='+''; 
                            // **
                            if(partObj.Supplier_Material_Code__c!=null){
                                fieldsValue +='&set_field.MaterialCode='+partObj.Supplier_Material_Code__c;
                            }
                            else
                                fieldsValue +='&set_field.MaterialCode='+'';
                            // **
                            if(partObj.Country_of_Origin__c!=null){
                                fieldsValue +='&set_field.OrgCountry='+partObj.Country_of_Origin__c;
                            }
                            else
                                fieldsValue +='&set_field.OrgCountry='+'';
                            // **
                            if(partObj.Purch_Box_Qty__c!=null){
                                fieldsValue +='&set_field.BoxQty='+partObj.Purch_Box_Qty__c;
                            }
                            else
                                fieldsValue +='&set_field.BoxQty='+'';
                            // **
                            if(partObj.Purch_Bag_Qty__c!=null){
                                fieldsValue +='&set_field.BagQty='+partObj.Purch_Bag_Qty__c;
                            }
                            else
                                fieldsValue +='&set_field.BagQty='+'';
                            // **
                            if(partObj.Purch_Box_Gross_Weight__c!=null){
                                fieldsValue +='&set_field.BoxWeight='+partObj.Purch_Box_Gross_Weight__c;
                            }
                            else
                                fieldsValue +='&set_field.BoxWeight='+'';
                            // **
                            
                            if(partObj.Purch_Box_Dimensions__c!=null){
                                fieldsValue +='&set_field.BoxDimensions='+partObj.Purch_Box_Dimensions__c;
                            }
                            else
                                fieldsValue +='&set_field.BoxDimensions='+'';
                            // **
                            if(partObj.Purchase_Warning__c!=null){
                                fieldsValue +='&set_field.WarningText='+partObj.Purchase_Warning__c;
                            }
                            else
                                fieldsValue +='&set_field.WarningText='+'';
                            // **
                            if(partObj.Minimum_Order_Qty__c!=null){
                                fieldsValue +='&set_field.MinPOQty='+partObj.Minimum_Order_Qty__c;
                            }
                            else
                                fieldsValue +='&set_field.MinPOQty='+'';
                            // **
                            Integer tempState = partObj.Inactive__c==True?1:0;
                            fieldsValue +='&set_field.ClosedFlag='+tempState;
                            // **
                            Integer tempdef = partObj.Default_Part_Supplier__c==True?1:0;
                            fieldsValue +='&set_field.DefaultChoice='+tempdef;
                            // **  
                        }
                        else{// if Part Customer**
                            
                            //**
                            if(partObj.Customer_Item_Ref__c!=null){
                                fieldsValue +='&set_field.CUArtCode='+partObj.Customer_Item_Ref__c;
                            }
                            else
                                fieldsValue +='&set_field.CUArtCode='+'';
                            
                            //**
                            if(partObj.Customer_Product_Name__r.Product_Description__c!=null){
                                fieldsValue +='&set_field.Spec='+partObj.Customer_Product_Name__r.Product_Description__c;
                            }
                            else
                                fieldsValue +='&set_field.Spec='+'';
                            
                            //**
                            if(partObj.Customer_Description__c!=null){
                                fieldsValue +='&set_field.CUSpec='+partObj.Customer_Description__c;
                            }
                            else
                                fieldsValue +='&set_field.CUSpec='+'';
                            
                            
                            //**
                            if(partObj.Customer_Drawing_Ref__c!=null){
                                fieldsValue +='&set_field.DrawingNr='+partObj.Customer_Drawing_Ref__c;
                            }
                            else
                                fieldsValue +='&set_field.DrawingNr='+'';
                            
                            
                            //**
                            if(partObj.Special_Requirements__c!=null){
                                fieldsValue +='&set_field.WarningText='+partObj.Special_Requirements__c;
                            }
                            else
                                fieldsValue +='&set_field.WarningText='+'';
                            
                            
                            //**
                            if(partObj.Customer_Approval_Received__c!=null){
                                System.debug('@@#@@1 Customer_Approval_Received__c '+partObj.Customer_Approval_Received__c);
                                if(partObj.Customer_Approval_Received__c!='0'){
                                    System.debug('@@#@@2 Customer_Approval_Received__c '+partObj.Customer_Approval_Received__c);
                                    Integer pickVal = partObj.Customer_Approval_Received__c=='1'?1:2;
                                    fieldsValue +='&set_field.ApprovalFlag='+pickVal;    
                                }
                                else{
                                    System.debug('@@#@@3 Customer_Approval_Received__c '+partObj.Customer_Approval_Received__c);
                                    Integer pickVal = 0;
                                    fieldsValue +='&set_field.ApprovalFlag='+pickVal;   
                                }
                            }
                            else
                                fieldsValue +='&set_field.ApprovalFlag='+'0';
                            
                            
                            //**
                            if(partObj.Approval_Date__c!=null){
                                fieldsValue +='&set_field.ApprovalDate='+partObj.Approval_Date__c;
                            }
                            else
                                fieldsValue +='&set_field.ApprovalDate='+'';
                            
                            
                            //**
                            if(partObj.Sales_Box_Qty__c!=null){
                                fieldsValue +='&set_field.BoxQty='+partObj.Sales_Box_Qty__c;
                            }
                            else
                                fieldsValue +='&set_field.BoxQty='+'';
                            
                            
                            //**
                            if(partObj.Sales_Bag_Qty__c!=null){
                                fieldsValue +='&set_field.BagQty='+partObj.Sales_Bag_Qty__c;
                            }
                            else
                                fieldsValue +='&set_field.BagQty='+'';
                            
                            
                            //**
                            if(partObj.EDI_Item_No__c!=null){
                                fieldsValue +='&set_field.EDIArtCode='+partObj.EDI_Item_No__c;
                            }
                            else
                                fieldsValue +='&set_field.EDIArtCode='+'';
                            
                            
                            //**
                            if(partObj.Tariff_Code__c!=null){
                                fieldsValue +='&set_field.TariffCode='+partObj.Tariff_Code__c;
                            }
                            else
                                fieldsValue +='&set_field.TariffCode='+'';
                            
                            
                            //**
                            if(partObj.No_of_Years_Productivity__c!=null){
                                fieldsValue +='&set_field.ProductivityYears='+partObj.No_of_Years_Productivity__c;
                            }
                            else
                                fieldsValue +='&set_field.ProductivityYears='+'';
                            
                        }
                        
                    }
                    system.debug('@@@@ PS PC FINAL endPointURL ==> '+endPointURL);
                        
                    if(endPointURL != '' && fieldsValue!=''){  
                        system.debug('@@@@@@#### PSPC fieldsValue===> '+fieldsValue);
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
                        res = http.send(req); 
                        System.debug('@@@@@@@@@ Res body After calling => '+res);
                        
                        if(res != null && res.getStatusCode() != null){
                            partObj.Hansa_Status_Code__c = string.valueOf(res.getStatusCode());
                        }
                        if(res != null && res.getBody() != null){
                            System.debug('@@@@ BODY: '+res.getBody()); 
                            System.debug('@@@@ STATUS:'+res.getStatus());
                            System.debug('@@@@ STATUS_CODE:'+res.getStatusCode());
                            partObj.Hansa_JSON_Body__c = res.getBody(); 
                            partObj.Hansa_Last_Sync_Date__c = system.today();
                            
                            if(res.getStatusCode() == 200){
                                try{
                                   // partObj.Hansa_Sync_Error__c = false;   
                                    if(endPointURL.endsWith('PIVc')){
                                        System.debug('@@@@@@ PS Body');
                                        Dom.Document doc = new Dom.Document();
                                        doc.load(res.getBody());                        
                                        Dom.XMLNode dataRegister = doc.getRootElement();
                                        System.debug('@@@@@@@@ ## dataRegister: '+dataRegister);
                                        if(dataRegister.getChildElement('PIVc', null) != null){
                                            for (Dom.XMLNode child: dataRegister.getChildElement('PIVc', null).getChildElements()) {
                                                if(child.getName() == 'ItemCode'){
                                                    partObj.Ghost_PS_created_on_Hansa__c = True;
                                                    partObj.Hansa_Sync_Error__c = false;                                             
                                                }
                                            }  
                                        }
                                        psListToUpdate.add(partObj);
                                    }
                                    if(endPointURL.endsWith('ABSCUINVc')){
                                        System.debug('@@@@@@ PC Body');
                                        Dom.Document doc2 = new Dom.Document();
                                        doc2.load(res.getBody());                        
                                        Dom.XMLNode dataRegister2 = doc2.getRootElement();
                                        System.debug('@@@@@@@@ ## dataRegister2: '+dataRegister2);
                                        if(dataRegister2.getChildElement('ABSCUINVc', null) != null){
                                            for (Dom.XMLNode child: dataRegister2.getChildElement('ABSCUINVc', null).getChildElements()) {
                                                if(child.getName() == 'ArtCode'){
                                                    partObj.Ghost_PS_created_on_Hansa__c = True;
                                                    partObj.Hansa_Sync_Error__c = false;                                             
                                                }
                                            }  
                                        }
                                        psListToUpdate.add(partObj);
                                    }
                                   
                                }
                                catch(Exception e){
                                    system.debug('### PSc Exception Line Number '+e.getLineNumber());
                                    system.debug('### PSc Exception Message '+e.getMessage());
                                    partObj.Hansa_Sync_Error__c = true;
                                    partObj.Hansa_JSON_Body__c = e.getMessage()+'\n'+res.getBody();
                                    psListToUpdate.add(partObj);
                                }
                                
                            }
                            else{
                                system.debug('@@@@@@@@@ status code not 200 ');
                                partObj.Hansa_Sync_Error__c = True;    
                                psListToUpdate.add(partObj);
                            }
                        }
                        // psListToUpdate.add(partObj);
                    }
                    else{
                        System.debug('@@@@@@@ ==>>> ENDPOINT NOT DEFINE OR FIELD SET EMPTY ');
                    }
                } 
                
            }  // IF TOKEN NOT FOUND ***
            else if(hansaAccessToken == '' || hansaAccessToken == null  || hansaAccessToken == 'Error in Access Token Request'){
                System.debug('@@@@@@@ TOKEN NOT FOUND '); 
                for(Part_Suppliers__c partObj2 : [select id,Hansa_JSON_Body__c,Hansa_Status_Code__c from Part_Suppliers__c where id in : psIdSet]){
                    partObj2.Hansa_JSON_Body__c = 'Error in hansa token request, Token = '+hansaAccessToken;
                    partObj2.Hansa_Sync_Error__c = true;
                    psListToUpdate.add(partObj2);
                }
            }
            
            system.debug('@@@@@@@ psListToUpdate=> '+psListToUpdate);
            if(!psListToUpdate.isEmpty()){
                database.update (psListToUpdate,false);
            }
        //}
       // catch(Exception ex){
       //     system.debug('@@@@@ PS EXCEPTION ENCOUNTERED line: => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
       // }        
    }  
    
    // Method 3
    // Run on after update: Call heroku (PATCH)
    @future (callout=true)
    public static void patchToHansaPSupplier(Set<Id> psIdSet, boolean isPS){
        //try{
            System.debug('@@@@@#### called PATCH method');
            boolean devStop = false;
            RunOnce.accountTrigger = false;
            string hansaAccessToken = '';
            list<Part_Suppliers__c> psListToUpdate = new List<Part_Suppliers__c>();
           //map<string,map<string,string>> salesforceFieldVsSalesforceVsHansaPicklist = new map<string,map<string,string>>();
            
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
                string psQuery = 'SELECT Customer_Name__c,Customer_Product_Name__r.Product_Description__c, Customer_Name__r.Name, Hansa_Account_Number__c, Customer_Product_Name__c, Customer_Product_Name__r.Name, Customer_Item_Ref__c, Customer_Description__c, Customer_Drawing_Ref__c, Special_Requirements__c, Customer_Approval_Received__c, Approval_Date__c, Sales_Box_Qty__c, Sales_Bag_Qty__c, EDI_Item_No__c, Tariff_Code__c, No_of_Years_Productivity__c, id, Name,Supplier_Product_Name__c,Supplier_Product_Name__r.Name,Supplier_Name__c,Supplier_Name__r.Name, Ghost_PS_created_on_Hansa__c, Hansa_Sync_Error__c, Hansa_JSON_Body__c, Hansa_Last_Sync_Date__c, Hansa_Status_Code__c,Hansa_Supplier_Number__c,  Supplier_Part_Ref__c, Supplier_Drawing_No__c, Supplier_Drawing_Rev__c, Supplier_Material_Code__c, Country_of_Origin__c, Purch_Box_Qty__c, Purch_Bag_Qty__c, Purch_Box_Gross_Weight__c, Purch_Box_Dimensions__c, Purchase_Warning__c, Minimum_Order_Qty__c, Inactive__c, Default_Part_Supplier__c  FROM Part_Suppliers__c where Id IN: psIdSet';
                system.debug('@@@@@ productQuery ==> '+psQuery);
                list<Part_Suppliers__c> psRecords_list = database.query(psQuery);
                system.debug('@@@@@ product Records ==> '+psRecords_list);
                                
                for(Part_Suppliers__c partObj : psRecords_list){
                   // try{
                        string endPointURL = '';
                        string fieldsValue = ''; 
                        string ceetakLocation = '';
                        string salesArea = '';
                        string customerCategory = ''; 
                        string herokuEndPoint = 'https://erp-sync.herokuapp.com/getPartSuplr';
                    
                    // FILL HANSA REQUIRED FIELDS**
                    if(partObj.Ghost_PS_created_on_Hansa__c){
                        list<Hansa_ERP__c> customSettting = new list<Hansa_ERP__c>([select id,name,Part_Customer_patch_URL__c, Part_Supplier_patch_URL__c, Turn_of_Product_Sync__c,Product_End_Point_URL__c from Hansa_ERP__c where name = 'Refresh Token' limit 1]);
                        //endPointURL = customSettting[0].PartSupplr_End_Point_URL__c;
                        // endPointURL = 'https://ceetaktest.itsiltd.co.uk:3002/api/1/PIVc';
                        
                        if(isPS){
                            if(partObj.Supplier_Product_Name__c != null && partObj.Supplier_Name__c!=null && partObj.Hansa_Supplier_Number__c!='' && partObj.Hansa_Supplier_Number__c!=null){
                                System.debug('@===> PS update ');
                                String endpoint1 = customSettting[0].Part_Supplier_patch_URL__c;
                                endPointURL = endpoint1+'vecode='+partObj.Hansa_Supplier_Number__c+'&itemcode='+ partObj.Supplier_Product_Name__r.Name;
                                //https://ceetaktest.itsiltd.co.uk:3002/WebSFPIVc.hal?vecode=90273&itemcode=BS-NOV-T1
                                fieldsValue='Process';
                            }
                            else{
                                fieldsValue='';
                                endPointURL='';
                            }
                        }
                        else{
                            System.debug('@===> PC update ');
                            endPointURL = customSettting[0].Part_Customer_patch_URL__c;
                            if(partObj.Hansa_Account_Number__c!=null && partObj.Customer_Product_Name__c!=null){
                                endPointURL +=partObj.Hansa_Account_Number__c+'/'+partObj.Customer_Product_Name__r.Name;
                                fieldsValue='READY TO CHECK';
                            }
                        }
                    }
                    
                    //FILL REST OF THE MAPPING**    
                    if(fieldsValue!='' && !devStop){
                        if(isPS){
                            fieldsValue='';
                            if(partObj.Supplier_Name__c!=null){
                                fieldsValue +='set_field.VEName='+partObj.Supplier_Name__r.Name+'\n';
                            }
                            else
                                fieldsValue +='set_field.VEName='+''+'\n'; 
                            // **
                            if(partObj.Supplier_Part_Ref__c!=null){
                                fieldsValue +='set_field.VEItemCode='+partObj.Supplier_Part_Ref__c+'\n';
                            }
                            else
                                fieldsValue +='set_field.VEItemCode='+''+'\n';
                            // **
                            if(partObj.Supplier_Drawing_No__c!=null){
                                fieldsValue +='set_field.DrawingNr='+partObj.Supplier_Drawing_No__c+'\n';
                            }
                            else
                                fieldsValue +='set_field.DrawingNr='+''+'\n';
                            // **
                            if(partObj.Supplier_Drawing_Rev__c!=null){
                                fieldsValue +='set_field.DrawingRev='+partObj.Supplier_Drawing_Rev__c+'\n';
                            }
                            else
                                fieldsValue +='set_field.DrawingRev='+''+'\n'; 
                            // **
                            if(partObj.Supplier_Material_Code__c!=null){
                                fieldsValue +='set_field.MaterialCode='+partObj.Supplier_Material_Code__c+'\n';
                            }
                            else
                                fieldsValue +='set_field.MaterialCode='+''+'\n';
                            // **
                            if(partObj.Country_of_Origin__c!=null){
                                fieldsValue +='set_field.OrgCountry='+partObj.Country_of_Origin__c+'\n';
                            }
                            else
                                fieldsValue +='set_field.OrgCountry='+''+'\n';
                            // **
                            if(partObj.Purch_Box_Qty__c!=null){
                                fieldsValue +='set_field.BoxQty='+partObj.Purch_Box_Qty__c+'\n';
                            }
                            else
                                fieldsValue +='set_field.BoxQty='+''+'\n';
                            // **
                            if(partObj.Purch_Bag_Qty__c!=null){
                                fieldsValue +='set_field.BagQty='+partObj.Purch_Bag_Qty__c+'\n';
                            }
                            else
                                fieldsValue +='set_field.BagQty='+''+'\n';
                            // **
                            if(partObj.Purch_Box_Gross_Weight__c!=null){
                                fieldsValue +='set_field.BoxWeight='+partObj.Purch_Box_Gross_Weight__c+'\n';
                            }
                            else
                                fieldsValue +='set_field.BoxWeight='+''+'\n';
                            // **
                            
                            if(partObj.Purch_Box_Dimensions__c!=null){
                                fieldsValue +='set_field.BoxDimensions='+partObj.Purch_Box_Dimensions__c+'\n';
                            }
                            else
                                fieldsValue +='set_field.BoxDimensions='+''+'\n';
                            // **
                            if(partObj.Purchase_Warning__c!=null){
                                fieldsValue +='set_field.WarningText='+partObj.Purchase_Warning__c+'\n';
                            }
                            else
                                fieldsValue +='set_field.WarningText='+''+'\n';
                            // **
                            if(partObj.Minimum_Order_Qty__c!=null){
                                fieldsValue +='set_field.MinPOQty='+partObj.Minimum_Order_Qty__c+'\n';
                            }
                            else
                                fieldsValue +='set_field.MinPOQty='+''+'\n';
                            // **
                            Integer tempState = partObj.Inactive__c==True?1:0;
                            fieldsValue +='set_field.ClosedFlag='+tempState+'\n';
                            // **
                            Integer tempdef = partObj.Default_Part_Supplier__c==True?1:0;
                            fieldsValue +='set_field.DefaultChoice='+tempdef+'\n';
                            // **  
                        }
                        else{
                            fieldsValue='';
                            // if Part Customer**
                            if(partObj.Customer_Name__c!=null){
                                fieldsValue += '&set_field.Addr0=' + partObj.Customer_Name__r.Name;
                            }
                            else
                                fieldsValue += '&set_field.Addr0=' +'';
                            
                            //**
                            if(partObj.Customer_Item_Ref__c!=null){
                                fieldsValue +='&set_field.CUArtCode='+partObj.Customer_Item_Ref__c;
                            }
                            else
                                fieldsValue +='&set_field.CUArtCode='+'';
                            
                            
                            //**
                            if(partObj.Customer_Description__c!=null){
                                fieldsValue +='&set_field.CUSpec='+partObj.Customer_Description__c;
                            }
                            else
                                fieldsValue +='&set_field.CUSpec='+'';
                            
                            
                            //**
                            if(partObj.Customer_Product_Name__r.Product_Description__c!=null){
                                fieldsValue +='&set_field.Spec='+partObj.Customer_Product_Name__r.Product_Description__c;
                            }
                            else
                                fieldsValue +='&set_field.Spec='+'';
                            
                            
                            //**
                            if(partObj.Customer_Drawing_Ref__c!=null){
                                fieldsValue +='&set_field.DrawingNr='+partObj.Customer_Drawing_Ref__c;
                            }
                            else
                                fieldsValue +='&set_field.DrawingNr='+'';
                            
                            
                            //**
                            if(partObj.Special_Requirements__c!=null){
                                fieldsValue +='&set_field.WarningText='+partObj.Special_Requirements__c;
                            }
                            else
                                fieldsValue +='&set_field.WarningText='+'';
                            
                            
                            //**
                            if(partObj.Customer_Approval_Received__c!=null){
                                if(partObj.Customer_Approval_Received__c!='0'){
                                    Integer pickVal = partObj.Customer_Approval_Received__c=='1'?1:2;
                                    fieldsValue +='&set_field.ApprovalFlag='+pickVal;    
                                }
                                else{
                                    Integer pickVal = 0;
                                    fieldsValue +='&set_field.ApprovalFlag='+pickVal;   
                                }
                            }
                            else
                                fieldsValue +='&set_field.ApprovalFlag='+'0';
                            
                            
                            //**
                            if(partObj.Approval_Date__c!=null){
                                fieldsValue +='&set_field.ApprovalDate='+partObj.Approval_Date__c;
                            }
                            else
                                fieldsValue +='&set_field.ApprovalDate='+'';
                            
                            
                            //**
                            if(partObj.Sales_Box_Qty__c!=null){
                                fieldsValue +='&set_field.BoxQty='+partObj.Sales_Box_Qty__c;
                            }
                            else
                                fieldsValue +='&set_field.BoxQty='+'';
                            
                            
                            //**
                            if(partObj.Sales_Bag_Qty__c!=null){
                                fieldsValue +='&set_field.BagQty='+partObj.Sales_Bag_Qty__c;
                            }
                            else
                                fieldsValue +='&set_field.BagQty='+'';
                            
                            
                            //**
                            if(partObj.EDI_Item_No__c!=null){
                                fieldsValue +='&set_field.EDIArtCode='+partObj.EDI_Item_No__c;
                            }
                            else
                                fieldsValue +='&set_field.EDIArtCode='+'';
                            
                            
                            //**
                            if(partObj.Tariff_Code__c!=null){
                                fieldsValue +='&set_field.TariffCode='+partObj.Tariff_Code__c;
                            }
                            else
                                fieldsValue +='&set_field.TariffCode='+'';
                            
                            
                            //**
                            if(partObj.No_of_Years_Productivity__c!=null){
                                fieldsValue +='&set_field.ProductivityYears='+partObj.No_of_Years_Productivity__c;
                            }
                            else
                                fieldsValue +='&set_field.ProductivityYears='+'';
                            
                        }                            
                        
                    }
                    system.debug('@@@@ PS update FINAL endPointURL ==> '+endPointURL);
                    
                    if(endPointURL != '' && fieldsValue!=''){  
                        system.debug('@@@@@@#### PSPC update fieldsValue===> '+fieldsValue);
                        string domainUrl = endPointURL;
                        string body = 'authorizationToken='+EncodingUtil.urlEncode(hansaAccessToken,'UTF-8') + '&endPointURL='+EncodingUtil.urlEncode(domainUrl,'UTF-8')  + '&jsonBody='+EncodingUtil.urlEncode(fieldsValue,'UTF-8');            
                        Http http = new Http();
                        
                        HttpRequest req = new HttpRequest();
                        req.setMethod('POST');
                        req.setEndpoint(herokuEndPoint); 
                        req.setTimeout(120000);  
                        req.setHeader('Content-Type','application/x-www-form-urlencoded');
                        req.setBody(body);
                        HTTPResponse res;
                        try{
                            res = http.send(req); 
                        }catch(Exception e){
                            system.debug('@@@ ps 1 update Exception Line Number '+e.getLineNumber());
                            system.debug('@@@ ps 1 Exception Message '+e.getMessage());
                            partObj.Hansa_Sync_Error__c = true; 
                            partObj.Hansa_JSON_Body__c = e.getMessage();
                        } 
                        
                        // Send Request
                        System.debug('@@@@@@@@@ Req body befor calling => '+req);
                        res = http.send(req); 
                        System.debug('@@@@@@@@@ Res body After calling => '+res);
                        
                        if(res != null && res.getStatusCode() != null){
                            partObj.Hansa_Status_Code__c = string.valueOf(res.getStatusCode());
                        }
                        if(res != null && res.getBody() != null){
                            System.debug('@@@@ BODY: '+res.getBody()); 
                            System.debug('@@@@ STATUS:'+res.getStatus());
                            System.debug('@@@@ STATUS_CODE:'+res.getStatusCode());
                            //partObj.Hansa_JSON_Body__c = res.getBody();
                            partObj.Hansa_Last_Sync_Date__c = system.today();
                            
                            //if(res.getStatusCode() == 200){
                            try{
                                map<string,Object> obj = (map<string,Object>)JSON.deserializeUntyped(res.getBody());
                                if(string.valueOf(obj.get('statusCode'))=='200')
                                    partObj.Hansa_Sync_Error__c = false;
                                else
                                    partObj.Hansa_Sync_Error__c = true;
                                
                                partObj.Hansa_Status_Code__c = string.valueOf(obj.get('statusCode'));
                                partObj.Hansa_JSON_Body__c = string.valueOf(obj.get('body'));
                                System.debug('$$$$$$$$$@ body => '+string.valueOf(obj.get('body')));
                                // Dom.Document doc = new Dom.Document();
                                // doc.load(string.valueOf(obj.get('body')));  
                                psListToUpdate.add(partObj);
                            }
                            catch(Exception e){
                                system.debug('### PS update Exception Line Number '+e.getLineNumber());
                                system.debug('### PS update Exception Message '+e.getMessage());
                                partObj.Hansa_Sync_Error__c = true;
                                partObj.Hansa_JSON_Body__c = e.getMessage()+'\n'+res.getBody();
                                psListToUpdate.add(partObj);
                            }
                            //}
                        }
                        //psListToUpdate.add(partObj);
                    }
                    else{
                        System.debug('@@@@@@@ ==>>> ENDPOINT NOT DEFINE OR FIELD SET EMPTY ');
                    }
                        
                    //}
                    /*catch(exception ex){
                        system.debug('@@@@@@@ ps EXCEPTION ENCOUNTERED line: => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
                        partObj.Hansa_Sync_Error__c = true; 
                        partObj.Hansa_JSON_Body__c = ex.getMessage();
                        psListToUpdate.add(partObj);
                    } */
                } 
                
            }// IF TOKEN NOT FOUND ***
            else if(hansaAccessToken == '' || hansaAccessToken == null  || hansaAccessToken == 'Error in Access Token Request'){
                System.debug('@@@@@@@ TOKEN NOT FOUND '); 
                for(Part_Suppliers__c partObj2 : [select id,Hansa_JSON_Body__c,Hansa_Status_Code__c from Part_Suppliers__c where id in : psIdSet]){
                    partObj2.Hansa_JSON_Body__c = 'Error in hansa token request, Token = '+hansaAccessToken;
                    partObj2.Hansa_Sync_Error__c = true;
                    psListToUpdate.add(partObj2);
                }
            }
            
            system.debug('@@@@@@@ update psListToUpdate=> '+psListToUpdate);
            if(!psListToUpdate.isEmpty()){
                database.update(psListToUpdate,false);
            }
        //}
        /*catch(Exception ex){
            system.debug('####### update EXCEPTION ENCOUNTERED line: => '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
        } */       
        // 
    }
}