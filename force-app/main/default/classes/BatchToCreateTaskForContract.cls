/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is used to create tasks and email alert to set of users for Contract object
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-03-27
* @modified       2020-03-31
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/

global class BatchToCreateTaskForContract implements Database.Batchable<sObject>{
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select id,ownerId,StartDate,account.ownerId,Contract_End_Date__c,Expiry_Date_Notification__c,accountid,account.recordTypeId,account.recordType.name,owner.email,account.owner.email,account.Primary_Internal_Sales__c,account.Primary_Internal_Sales__r.email from Contract where Contract_End_Date__c != null and Expiry_Date_Notification__c != null';     
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contract> ContractList){
        try{
            if(!ContractList.isEmpty()){
                list<EmailTemplate> expiryTemplate = new list<EmailTemplate>([select id from emailtemplate where name = 'Contract Expiring Template' order by createddate desc limit 1]);
                set<string> ccAddressToSendNotificationEmail = new set<string>();
                if(ContractList[0].accountId != null && ContractList[0].account.recordTypeId != null && ContractList[0].account.recordType.name == 'Customer' ){
                    if(ContractList[0].Expiry_Date_Notification__c.isNumeric() && ((ContractList[0].Contract_End_Date__c - Integer.valueOf(ContractList[0].Expiry_Date_Notification__c)) == system.today())){
                        Task taskObj = new Task();
                        taskObj.Subject = 'Contract Expiry';
                        taskObj.OwnerId = ContractList[0].account.ownerId;
                        taskObj.ActivityDate = ContractList[0].Contract_End_Date__c;
                        taskObj.WhatId = ContractList[0].id;
                        insert taskObj; 
                    }
                    if(ContractList[0].accountId != null){
                        ccAddressToSendNotificationEmail.add(ContractList[0].account.owner.email);
                        if(ContractList[0].account.Primary_Internal_Sales__c != null){
                            ccAddressToSendNotificationEmail.add(ContractList[0].account.Primary_Internal_Sales__r.email);
                        }
                    }
                }else if(ContractList[0].accountId != null && ContractList[0].account.recordTypeId != null && ContractList[0].account.recordType.name == 'Supplier' ){
                    if(ContractList[0].Expiry_Date_Notification__c.isNumeric() && ((ContractList[0].Contract_End_Date__c - Integer.valueOf(ContractList[0].Expiry_Date_Notification__c)) == system.today())){
                        Task taskObj = new Task();
                        taskObj.Subject = 'Contract Expiry';
                        taskObj.OwnerId = ContractList[0].account.ownerId;                    
                        taskObj.ActivityDate = ContractList[0].Contract_End_Date__c;
                        taskObj.WhatId = ContractList[0].id;
                        insert taskObj;                        
                    }
                    if(ContractList[0].accountId != null){
                        ccAddressToSendNotificationEmail.add(ContractList[0].account.owner.email);                        
                    }
                }
                if(!expiryTemplate.isEmpty() && ContractList[0].Expiry_Date_Notification__c.isNumeric() && ((ContractList[0].Contract_End_Date__c - Integer.valueOf(ContractList[0].Expiry_Date_Notification__c)) == system.today()) ){
                    Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(expiryTemplate[0].id, ContractList[0].ownerId, ContractList[0].Id); 
                    message.setTargetObjectId(ContractList[0].ownerId); 
                    message.setSaveAsActivity(false); 
                    if(!ccAddressToSendNotificationEmail.isEmpty()){
                        message.setCcAddresses(new list<string>(ccAddressToSendNotificationEmail));
                    }
                    Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message}; 
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                }
                
            } 
        }catch(Exception e){
            system.debug('Exception  Line Number---- ' + e.getLineNumber());
            system.debug('Exception  Message---- ' +e.getMessage());
            SendEmailErrorUtility.sendEmail(e.getLineNumber(),e.getMessage() + ' Contract Id-- '+ ContractList[0].Id,'BatchToCreateTaskForContract' );
        }        
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}