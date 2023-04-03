/*******************************************************************************************************************
*	Created by		: 	Bhagwan Singh
*	Created date	: 	04-08-2022
*	Helper class	:	Coac_Order_TriggerHelper
*	Description		:	Created to automate operations on Order.
********************************************************************************************************************/
trigger Coac_Order_Trigger on Order (before insert, before update, before delete, after Update ) {
    
    // Runs Before Insert
    if(Trigger.isInsert && Trigger.isBefore){
        if(RunOnce.odrBeforeInsert){
            RunOnce.odrBeforeInsert=false;
             Coac_Order_TriggerHelper.beforeInsert(Trigger.new);
        }
    }
    
    //runs before Update
    if(Trigger.isUpdate && Trigger.isBefore){
        if(RunOnce.odrBeforeUpdate){
            RunOnce.odrBeforeUpdate=false;
            Coac_Order_TriggerHelper.beforeUpdate(Trigger.new);
        }
    }

}