/*******************************************************************************************************************
*	Created by		: 	Bhagwan Singh
*	Created date	: 	04-08-2022
*	Helper class	:	Coac_OrderLineItem_TriggerHelper
*	Description		:	Created to automate operations on OrderItem.
********************************************************************************************************************/

trigger Coac_OrderLineItem_Trigger on OrderItem (after insert, before update, before delete, after update) {
    
    // runs after insert and after update
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)){
        if(RunOnce.oliafterUpdate){
            RunOnce.oliafterUpdate=false;
            Coac_OrderLineItem_TriggerHelper.afterUpdate(Trigger.new);
        }
    }
    
    // runs before Update
    if(Trigger.isBefore && Trigger.isUpdate){
        if(RunOnce.olibeforeUpdate){
            RunOnce.olibeforeUpdate=false;
            Coac_OrderLineItem_TriggerHelper.beforeUpdate(Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
    }

    
    // runs before Delete
    if(Trigger.isBefore && Trigger.isDelete){
        if(RunOnce.olibeforeDelete){
            RunOnce.olibeforeDelete=false;
            Coac_OrderLineItem_TriggerHelper.beforeDelete(Trigger.old);
        }
    }
    
    
}