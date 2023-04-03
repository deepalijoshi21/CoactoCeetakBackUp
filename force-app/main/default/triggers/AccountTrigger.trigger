trigger AccountTrigger on Account (before update, after update, after insert) {
        if(trigger.isBefore && trigger.isUpdate){
             AccountTriggerHandler.accValidation(trigger.newMap, trigger.oldMap);
        }
        if(RunOnce.accountTrigger && trigger.isAfter && trigger.isUpdate){
             RunOnce.accountTrigger = false;
             AccountTriggerHandler.getAccountRecords(trigger.newMap, trigger.oldMap);
        }

        
        if(RunOnce.accountTrigger && Trigger.isAfter && Trigger.isInsert){
          RunOnce.accountTrigger = false;
          AccountTriggerHandler.getAccountRecords(trigger.newMap, trigger.oldMap);
        }



}