/*******************************************************************************************************************
*	Created by		: 	Bhagwan Singh
*	Created date	: 	04-08-2022
*	Trigger			:	Coac_OrderLineItem_Trigger
*	Description		:	Created to automate operations on OrderItem.
********************************************************************************************************************/
public class Coac_OrderLineItem_TriggerHelper {
    
    // Update for OrderItem
    public static void beforeUpdate(List<OrderItem> OrderItemList, Map<id, OrderItem> TriggeroldMap, Map<id, OrderItem> TriggernewMap){
        System.debug('#### before Update');
        try{
            
            // checking Conditions for OrderItem
            for(OrderItem oli:OrderItemList){
                
                if(oli.Quantity_Delivered__c > 0 && oli.Quantity_Delivered__c < oli.Quantity && oli.Order_Line_Status__c!='Partially Delivered'){
                    oli.Order_Line_Status__c='Partially Delivered';
                }
                else if(oli.Quantity_Delivered__c == 0 && oli.Quantity == 0  && oli.Order_Line_Status__c!='Cancelled'){
                    oli.Order_Line_Status__c='Cancelled';
                }
                else if(oli.Quantity_Delivered__c > 0 && oli.Quantity_Delivered__c == oli.Quantity && oli.Order_Line_Status__c!='Complete'){
                    oli.Order_Line_Status__c='Complete';
                }
            }
        }Catch(Exception e){
            System.debug('@@@@ Exception on line '+e.getLineNumber()+' Exception Message '+e.getMessage());
        }
    }
    
    // event: after update
    
    public static void afterUpdate(List<OrderItem> OrderItemList){//, Map<id, OrderItem> TriggeroldMap, Map<id, OrderItem> TriggernewMap){
        try{
            System.debug('#### After Update');
            Set<id> OrderIds=new Set<id>();
            // get unique order id set
            for(OrderItem oli:OrderItemList){
                OrderIds.add(oli.OrderId);
                System.debug('#### Adding Order Id');
            }
            
            List<Order> upOrderList=new List<Order>();
            Map<id, String> orderStatusMap=new Map<id, String>();
            
            // Querring order with order line items
            for(Order ordr : [Select id, Status, RecordTypeId, Coac_Ghost_ErrorField__c, Total_Ordered__c, (Select id, Order_Line_Status__c, Quantity from OrderItems Limit 200) from Order where id IN: OrderIds Limit 49999]){
                
                Decimal Quantity_Sum=0;
                Set<String> oliStatus=new Set<String>();
                
                // child lines of order record
                if(!ordr.OrderItems.isEmpty()){
                    for(OrderItem o:ordr.OrderItems){
                        Quantity_Sum+=o.Quantity;
                        oliStatus.add(o.Order_Line_Status__c);
                        System.debug('#### Setting Order Line Status');
                    }
                    
                    // Checking conditions for Order Status
                    if(!oliStatus.isEmpty()){
                        if((oliStatus.contains('Complete') && (oliStatus.contains('Accepted') || oliStatus.contains('Open'))) || (oliStatus.contains('Partially Delivered'))){
                            orderStatusMap.put(ordr.id, 'Partially Delivered');
                            System.debug('#### Partially Delivered');
                        }
                        else if((oliStatus.contains('Complete') && (Schema.SObjectType.Order.getRecordTypeInfosById().get(ordr.recordtypeid).getname() == 'Standard') && !oliStatus.contains('Cancelled') && !oliStatus.contains('Partially Delivered') && !oliStatus.contains('Accepted') && !oliStatus.contains('Open')) || 
                                ((Schema.SObjectType.Order.getRecordTypeInfosById().get(ordr.recordtypeid).getname() == 'Call off') && (Quantity_Sum == ordr.Total_Ordered__c))){
                                    orderStatusMap.put(ordr.id, 'Complete');
                                    System.debug('#### Standard Completed');
                                }
                        else if(oliStatus.contains('Cancelled') && !oliStatus.contains('Complete') && !oliStatus.contains('Partially Delivered') && !oliStatus.contains('Accepted') && !oliStatus.contains('Open')){
                            orderStatusMap.put(ordr.id, 'Cancelled'); 
                            System.debug('#### Cancelled');
                        }
                        
                    }
                    else{
                        System.debug('#### Order Line Status '+oliStatus);
                    }
                    
                }
                else{
                    System.debug('#### Order.Order Item is Empty'+ordr.OrderItems);
                }
            }
            
            
            // fill order status
            List<Order> orderList_toupdate = new List<Order>();
            for(String  odr: orderStatusMap.keySet()){
                Order odr_rec = new Order();
                odr_rec.Id = odr;
                odr_rec.status=orderStatusMap.get(odr); 
                odr_rec.Coac_Ghost_ErrorField__c=orderStatusMap.get(odr); 
                orderList_toupdate.add(odr_rec);
                System.debug('#### Order Status to update'+orderStatusMap.get(odr));
            }
            // update Order 
            if(!orderList_toupdate.isEmpty()){
                //database.update(orderList_toupdate, true);
                update orderList_toupdate;
                System.debug('#### Order Status updated');
            }
        }Catch(Exception e){
            System.debug('@@@@ Exception on line '+e.getLineNumber()+' Exception Message '+e.getMessage());
        }   
    }
    
    public static void beforeDelete(List<OrderItem> OrderItems){
        System.debug('#### before Delete');
        for(OrderItem oli:OrderItems){
            if(oli.Order_Line_Status__c!='Open'){
                oli.addError('Can not Delete this Order Line Item as it is not Open');
            }
        }
    }    
}