trigger AlternateShippingTrigger on Alternate_Shipping_Delivery_Address__c (after insert, after update) {
        if( trigger.isAfter && trigger.isInsert && RunOnce.alternateAddressTrigger){
            RunOnce.alternateAddressTrigger = false;
            AlternateShippingTriggerHandler.processAddressToHansa(trigger.newMap, trigger.oldMap);
        }else if(trigger.isUpdate && RunOnce.alternateAddressTrigger){
            RunOnce.alternateAddressTrigger = false;
            AlternateShippingTriggerHandler.processAddressToHansa(trigger.newMap, trigger.oldMap);
        }
}