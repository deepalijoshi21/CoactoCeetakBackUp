/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is used to create tasks and email alert to set of users for Document custom object
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-03-31
* @modified       2020-03-31
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
global with sharing class BatchToCreateTaskForDocument implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select id,Account__c,ownerid,Account__r.ownerid,Account__r.owner.email,End_Date__c,Expiry_Date_Notification__c from Document__c where End_Date__c != null and Expiry_Date_Notification__c != null';     
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Document__c> DocumentList){
        try{
            list<EmailTemplate> expiryTemplate = new list<EmailTemplate>([select id from emailtemplate where name = 'Document Expiring Template' order by createddate desc limit 1]);
            set<string> ccAddressToSendNotificationEmail = new set<string>();
                    
            if(!DocumentList.isEmpty() && DocumentList[0].Expiry_Date_Notification__c.isNumeric() && ((DocumentList[0].End_Date__c - Integer.valueOf(DocumentList[0].Expiry_Date_Notification__c)) == system.today())){
                Task taskObj = new Task();
                taskObj.Subject = 'Document Expiry';
                taskObj.OwnerId = DocumentList[0].ownerId;
                taskObj.ActivityDate = DocumentList[0].End_Date__c;
                taskObj.WhatId = DocumentList[0].id;
                insert taskObj; 
                
                if(DocumentList[0].Account__c != null){
                    ccAddressToSendNotificationEmail.add(DocumentList[0].Account__r.owner.email);
                }

                if(!expiryTemplate.isEmpty() ){
                    Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(expiryTemplate[0].id, DocumentList[0].ownerId, DocumentList[0].Id); 
                    message.setTargetObjectId(DocumentList[0].ownerId); 
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
            SendEmailErrorUtility.sendEmail(e.getLineNumber(),e.getMessage() + ' Document Id-- '+ DocumentList[0].Id,'BatchToCreateTaskForDocument' );
        } 
    }

    global void finish(Database.BatchableContext BC){
        
    }
}