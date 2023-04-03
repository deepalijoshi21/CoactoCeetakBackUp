/*******************************************************************************************************************
*	Created by		: 	Bhagwan Singh
*	Created date	: 	04-08-2022
*	Trigger     	:	Coac_Order_Trigger
*	Description		:	Created to automate operations on Order.
********************************************************************************************************************/
public with sharing class Coac_Order_TriggerHelper {
    
    public static void beforeInsert(List<Order> orders){
        System.debug('#### Test Order before Insert');
        for(Order ordr:orders){
            ordr.Coac_Ghost_ErrorField__c=null;
            ordr.Status='Open';
        }
    }
    
    public static void beforeUpdate(List<Order> orders){//, Map<id, Order> TriggeroldMap, Map<id, Order> TriggernewMap){
        System.debug('#### Test Order before Update Order Id '+Orders);
        
        for(Order ordr:orders){
            if(ordr.Status=='On Hold' && ordr.Order_Class__c!='SOIP'){
                ordr.Order_Class__c='SOIP';
            }
            
        }
       
        
    }
}