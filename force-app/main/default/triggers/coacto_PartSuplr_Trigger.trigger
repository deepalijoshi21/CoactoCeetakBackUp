/**
    * ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
    *  Description	:	Sync Salesfoce 'Part Supplier' with Hasna 'Purchase Item'
    *  Event		:	after insert, after update
    *  Helper 		:	Coacto_PartSuplr_TriggerHelper
    *  Test class	:	coacto_PartSuplr_Trigger_Test, triggerCalloutmock
    * ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    * @author    Salesforce(Coacto)      22-Oct-2021
    * ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

trigger coacto_PartSuplr_Trigger on Part_Suppliers__c (after insert, after update) {
	
    // ON/OFF CHECK
    if(System.Label.slx_PartSupplierSyncCheck=='Yes' && RunOnce.psTriggerCheck){
        RunOnce.psTriggerCheck= false;
        
        // INSERT**
        if(Trigger.isInsert && Trigger.isAfter){
            Coacto_PartSuplr_TriggerHelper.handleBulk_NewPS(Trigger.NewMap.KeySet(),True);
        }// UPDATE**
        else if(Trigger.isUpdate && Trigger.isAfter && !System.isFuture()){
            List<String> fieldsToBeChecked = new List<String>{'Name','Supplier_Name__c', 'Hansa_Supplier_Number__c', 'Supplier_Product_Name__c', 'Supplier_Part_Ref__c', 'Supplier_Drawing_No__c', 'Supplier_Drawing_Rev__c', 'Supplier_Material_Code__c', 'Country_of_Origin__c', 'Purch_Box_Qty__c', 'Purch_Bag_Qty__c', 'Purch_Box_Gross_Weight__c', 'Purch_Box_Dimensions__c', 'Purchase_Warning__c', 'Minimum_Order_Qty__c', 'Inactive__c', 'Default_Part_Supplier__c', 'Customer_Name__c', 'Hansa_Account_Number__c', 'Customer_Product_Name__c', 'Customer_Item_Ref__c', 'Customer_Description__c', 'Customer_Drawing_Ref__c', 'Special_Requirements__c', 'Customer_Approval_Received__c', 'Approval_Date__c', 'Sales_Box_Qty__c', 'Sales_Bag_Qty__c', 'EDI_Item_No__c', 'Tariff_Code__c', 'No_of_Years_Productivity__c'};
            Set<Id> pscList_ToInsert = new Set<Id>();
            Set<Id> pscList_ToUpdate = new Set<Id>();
            for(Part_Suppliers__c psc : Trigger.new){
                if(!psc.Ghost_PS_created_on_Hansa__c)
                    pscList_ToInsert.add(psc.Id);
                else{
                    for(String fieldName: fieldsToBeChecked){
                        system.debug('@@@@@ Update trigger => '+fieldName);
                        system.debug('oldMap => '+trigger.oldMap.get(psc.Id).get(fieldName));
                        system.debug('newMap => '+trigger.newMap.get(psc.Id).get(fieldName));                            
                        if(trigger.oldMap.get(psc.Id).get(fieldName)!= trigger.newMap.get(psc.Id).get(fieldName)){
                            system.debug('*** adding id in set');
                            pscList_ToUpdate.add(psc.Id);
                            break;
                        }                    
                    }
                 	//pscList_ToUpdate.add(psc.Id);   
                }
            }
            if(!pscList_ToUpdate.isEmpty())
            	Coacto_PartSuplr_TriggerHelper.handleBulk_NewPS(pscList_ToUpdate,False);
            if(!pscList_ToInsert.isEmpty())
                Coacto_PartSuplr_TriggerHelper.handleBulk_NewPS(pscList_ToInsert,True);
        }
    }
    else{
        System.debug('@@@@@ label is OFF for sync');
    }
}