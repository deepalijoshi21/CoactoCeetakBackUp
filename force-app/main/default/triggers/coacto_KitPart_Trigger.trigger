/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Description   :   Sync Salesforce Kit Part with Hansa Item( Module: Sales Order )
* Trigegr events:   before insert, after insert, after update
* Helper class  :   Co_KitPartTriggerHandler
* Test class    :
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Coacto Salesforce   
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
trigger coacto_KitPart_Trigger on Kit_Part__c (before insert,after insert, after update) {
    
    // AUTO SERIAL NO. **
    if(System.Label.Co_AutoSerialNo!='No'){
        if(Trigger.isInsert && Trigger.isBefore){
            System.debug('@@@@@ before logic ');
            Co_KitPartTriggerHandler.setSerialNo(Trigger.New);
        }
    }
    
    // HANSA SYNC CODE**
    if(System.Label.Co_KitPartSync_check!='No' ){
        //AFTER INSERT & UPDATE EVENT
        if(RunOnce.kpTriggerCheck && Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) && !System.isFuture()){
            RunOnce.kpTriggerCheck = false;    
            System.debug('@@@@@@@@# update kit part');
            //for update**
            List<String> fieldsToBeChecked = new List<String>{'Kit_Part__c','Qty_per_Kit__c'};
                Set<id> kit_ToInsertSet = new Set<Id>();
            for(Kit_Part__c ktO: trigger.new){
                System.debug('@@@@@@# Ghost_Parent_is_Active_Kit__c '+ktO.Ghost_Parent_is_Active_Kit__c);
                if(ktO.Ghost_Parent_is_Active_Kit__c /*&& !ktO.Ghost_KP_created_on_Hansa__c*/ && ktO.Hansa_Recipe_Sync_OK__c){
                    if(Trigger.isInsert && ktO.Recipe_Row_Ref__c>0){
                        system.debug('@@@@ INSERT trigger');
                        kit_ToInsertSet.add(ktO.id);   
                    }
                    else{
                        for(String fieldName: fieldsToBeChecked){
                            system.debug('@@@@@ Update trigger => '+fieldName);
                            system.debug('oldMap => '+trigger.oldMap.get(ktO.Id).get(fieldName));
                            system.debug('newMap => '+trigger.newMap.get(ktO.Id).get(fieldName));                            
                            if(trigger.oldMap.get(ktO.Id).get(fieldName)!= trigger.newMap.get(ktO.Id).get(fieldName)){
                                system.debug('*** adding id in set');
                                kit_ToInsertSet.add(ktO.Id);
                                break;
                            }                    
                        }
                    }
                }
                else{
                    System.debug('@@@@@@@ CRITERIA NOT MET');
                }
            }
            if(!kit_ToInsertSet.isEmpty()){
                // CALL HELPER
                System.debug('@@@@@@@ kit_ToInsertSet =>'+kit_ToInsertSet);
                Co_KitPartTriggerHandler.handleBulForNewKit(kit_ToInsertSet);
            }
        }
    }
}