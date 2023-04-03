/**
* ────────────────────────────────────────────────────────────────────────────────────────────────────────┐
* Description   :   Sync Salesforce product with Hansa Item
* Trigegr events:   after insert, after update
* Helper class  :   Co_ProductTriggerHandler, Co_KitProductTriggerHandler, Co_KitLineProductTriggerHandler
* Test class    :  Co_ProjectTrigger_Test
* ─────────────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Coacto Salesforce   
* ───────────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
trigger Co_ProjectTrigger on Product2 (after insert,after update) {
    
    if(System.Label.Co_ProductHansaSync_check!='No'){
        // INSERT EVENT**
        if(RunOnce.productTrigger && Trigger.isAfter && Trigger.isInsert){
            RunOnce.productTrigger = false;            
            //Co_ProductTriggerHandler.handleBulkProductsForNew(trigger.newMap.keySet(),true);
            
            // Batch process***
            List<Id> productIdList = new List<Id>();
            productIdList.addAll(Trigger.newMap.keySet());
            System.debug('##### call batch => Co_ProductTriggerHandlerBatch');
            System.debug('##### List => '+productIdList);
            Database.executeBatch(new Co_ProductTriggerHandlerBatch(productIdList),1);
        }
        
        // UPDATE EVENT 1**
        // update item in hansa if product updated via UI
        if(RunOnce.productTrigger && trigger.isAfter && trigger.isUpdate && !System.isFuture() && !System.isBatch()){
            RunOnce.productTrigger = false;
            system.debug('@@@@ Inside trigger');
            List<String> fieldsToBeChecked = new List<String>{'Name','Product_Status__c','product_type__c',
                'Product_Group__c','Product_Description__c','Product_Classification__c',
                'Ceetak_Drawing_No__c','Ceetak_Drawing_Rev__c','Ceetak_Material_Code__c',
                'Material_Type__c','Weight_grams__c','Unit__c','Inspection_Name__c','inspection_code__c',
                'Warnings__c','Country_of_Origin__c','EDI_Classification__c'
                };
                    system.debug('@@@@@@@ List>>> '+fieldsToBeChecked);
            Set<Id> productIdSet = new Set<Id>();
            Set<Id> productIdToInsertSet = new Set<Id>();
            
            for(Product2 rec: trigger.new){
                system.debug('Inside trigger 2');
                if(rec.Ghost_Product_created_on_Hansa__c==True){
                    System.debug('@@@@@@@ PATCH');
                    for(String fieldName: fieldsToBeChecked){
                        system.debug('Inside trigger 3=> '+fieldName);
                        system.debug('oldMap => '+trigger.oldMap.get(rec.Id).get(fieldName));
                        system.debug('newMap => '+trigger.newMap.get(rec.Id).get(fieldName));
                        System.debug('@@@@@@@ PATCH');
                        if(trigger.oldMap.get(rec.Id).get(fieldName)!= trigger.newMap.get(rec.Id).get(fieldName)){
                            system.debug('*** adding id in set');
                            productIdSet.add(rec.Id);
                            break;
                        }                    
                    }
                }
                else{
                    System.debug('@@@@@@@ PUT');
                    if(Trigger.newMap.get(rec.Id).Ghost_Product_created_on_Hansa__c==Trigger.oldMap.get(rec.Id).Ghost_Product_created_on_Hansa__c)
                        productIdToInsertSet.add(rec.id);
                }
            }
            
            // UPDATE IN HANSA
            if(productIdSet!=null && !productIdSet.isEmpty()){
                system.debug('@@@@@@ sending productIdSet for PATCH>> '+productIdSet);
                Co_ProductTriggerHandler.handleBulkProductsForNew(trigger.newMap.keySet(),false);
            }
            // INSERT IN HANSA
            if(productIdToInsertSet!=null && !productIdToInsertSet.isEmpty()){
                system.debug('@@@@@@ sending productIdToInsertSet for PUSH>> '+productIdToInsertSet);
                Co_ProductTriggerHandler.handleBulkProductsForNew(trigger.newMap.keySet(),true);
            }
            
        }
        
        // UPDATE EVENT 2**
        // Call Post Product as Recipe to Hansa(if from future i.e after callout)
        if(trigger.isAfter && trigger.isUpdate  /*&& !RunOnce.allowFurure_ProdKitLine*/  && !System.isBatch() && !System.isFuture()){
            System.debug('@@@@@@===> call Recipe sync');
            //Set<Id> product_IdSet = new Set<Id>();
            Set<String> product_IdSet = new Set<String>();
            for(String pdtId : trigger.newMap.Keyset()){
               /* if(System.isFuture()){
                    System.debug('@@@@ concurrent recipe post');
                    if(Trigger.newMap.get(pdtId).Ghost_Product_created_on_Hansa__c && Trigger.newMap.get(pdtId).Kit__c!=null && Trigger.newMap.get(pdtId).Kit__c=='Yes' && ((Trigger.newMap.get(pdtId).Ghost_Product_created_on_Hansa__c!=Trigger.oldMap.get(pdtId).Ghost_Product_created_on_Hansa__c) )){
                        product_IdSet.add(pdtId); 
                    }
                }
                else{ */
                    System.debug('@@@@ user UI update Kit');
                    if(Trigger.newMap.get(pdtId).Ghost_Product_created_on_Hansa__c && Trigger.newMap.get(pdtId).Kit__c!=null && Trigger.newMap.get(pdtId).Kit__c=='Yes' && ((Trigger.newMap.get(pdtId).Kit__c!=Trigger.oldMap.get(pdtId).Kit__c))){
                        product_IdSet.add(pdtId); 
                    }
               // }
            }
            // check if product available for kit
            if(!product_IdSet.isEmpty()){
                System.debug('#####@@ call helper for RECIPE '+product_IdSet);
                //System.enqueueJob(new Co_KitProductTriggerHandler(product_IdSet));
                // call batch**
                List<String> userKitProduct2List = new List<String>();
                userKitProduct2List.addAll(product_IdSet);
                System.debug('@@@@@@##@ userKitProduct2List => '+userKitProduct2List);
                Co_RecipeHelperBatch secBatchObj = new Co_RecipeHelperBatch(userKitProduct2List);
                Database.executeBatch(secBatchObj,1);
            }
        }
        
        // UPDATE EVENT 3**
        // Patch related Kit as Recipe line to Hansa
      	/* if(trigger.isAfter && trigger.isUpdate && ( !System.isFuture()) && RunOnce.allowFurure_ProdKitLine  && !System.isBatch()){
            RunOnce.allowFurure_ProdKitLine = False;
            Set<Id> productId_Set = new Set<Id>();
            System.debug('@@@@@@===> call Recipe line sync');
            for(String pdtId : trigger.newMap.Keyset()){
                system.debug('con1>'+Trigger.newMap.get(pdtId).Ghost_Product_created_on_Hansa__c);
                system.debug('con2>'+Trigger.newMap.get(pdtId).Kit__c);
                system.debug('con4>'+Trigger.newMap.get(pdtId).Ghost_Available_as_Kit__c);
               system.debug('con5>'+Trigger.newMap.get(pdtId).Ghost_Available_as_Kit__c);
               system.debug('con6>'+Trigger.oldMap.get(pdtId).Ghost_Available_as_Kit__c);
                
                if(Trigger.newMap.get(pdtId).Ghost_Product_created_on_Hansa__c && Trigger.newMap.get(pdtId).Kit__c!=null && Trigger.newMap.get(pdtId).Kit__c=='Yes' && Trigger.newMap.get(pdtId).Ghost_Available_as_Kit__c && (Trigger.newMap.get(pdtId).Ghost_Available_as_Kit__c!=Trigger.oldMap.get(pdtId).Ghost_Available_as_Kit__c)){
                    productId_Set.add(pdtId); 
                }
            }
            // check if product available for kit
            if(!productId_Set.isEmpty()){
                System.debug('#####@@ call helper for RECIPE line ');
                System.enqueueJob(new Co_KitLineProductTriggerHandler(productId_Set));
                //Co_KitProductTriggerHandler.patchRecipeLineToHansa(productId_Set);
            } 
        } */
    }
}