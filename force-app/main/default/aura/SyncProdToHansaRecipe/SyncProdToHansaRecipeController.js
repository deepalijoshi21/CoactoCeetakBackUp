({
	recordUpdate : function(component, event, helper) {
        console.log(component.get('v.currentUser'));      
        var userProfile = component.get("v.currentUser").Profile.Name;
        var startSync = false;
        component.set("v.message","Syncing In Progress...");
        startSync = true;
        
        if(startSync){
            component.set("v.showSpinner",true);
            var action = component.get("c.checkConditions");
            action.setParams({ prodId : component.get("v.recordId") });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('SUCCESS!!!');
                    var returnValue = response.getReturnValue();
                    console.log('@@@@@@@@@@ returnValue ==>'+returnValue);
                    if(returnValue != null && returnValue=='NoProduct'){
                        component.set('v.message','Product is not available as Hansa Item, Please first sync product');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "Error",
                            "title": "Error!",
                            "message": "Product is not available as Hansa Item, Please first sync product "
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                        
                    }else if(returnValue != null && returnValue=='ReadyToSync'){
                        component.set('v.message','Please click below Save button, to create this Product as Recipe in Hansa.');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",true);
                    } else if(returnValue != null && returnValue=='AlreadyToSync'){
                        component.set('v.message','Already sync as Recipe');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",false);
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "Success",
                            "title": "Success!",
                            "message": "Already sync as Recipe "
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                        
                    } else if(returnValue != null && returnValue=='NoCriteria'){
                        component.set('v.message','Product not marked as Kit, Please check');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",false);
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "Success",
                            "title": "Success!",
                            "message": "Product not marked as Kit, Please check "
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                        
                    } else{
                        component.set('v.message','Exception encountered: Please contact Administrator');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",false);
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":"Exception encountered: Please contact Administrator"
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                    }
                }
                else if (state === "ERROR") {
                    console.log('ERROR!!!');
                    component.set("v.showSpinner",false);
                    let errors = response.getError();
                    var customError = '';
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        customError =  errors[0].message  ;
                    }else{
                        customError = "Unknown Error. Please Contact System Admin!!";
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" : "error",
                        "title": "Error!",
                        "message": customError
                    });
                    toastEvent.fire();                   
                }else {
                    component.set("v.showSpinner",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" : "error",
                        "title": "Success!",
                        "message": "Unknown Error. Please Contact System Admin!!"
                    });
                    toastEvent.fire();
                }
            });  
            $A.enqueueAction(action);
        }
    },
      // START BUTTON ACTION
    startSync : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var action = component.get("c.syncToHansa");
        action.setParams({ prodId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                if(returnValue != null && returnValue ){
                    component.set("v.showSpinner",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" : "success",
                        "title": "Success!",
                        "message": "Syncing this Product to Hansa Recipe.\n For result please see \"Hansa Sync Details\" section on record "
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
            }
            else if (state === "ERROR") {
                component.set("v.showSpinner",false);
                let errors = response.getError();
                var customError = '';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    customError =  errors[0].message  ;
                }else{
                    customError = "Unknown Error. Please Contact System Admin!!";
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": customError
                });
                toastEvent.fire();                   
            }else {
                component.set("v.showSpinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type" : "error",
                    "title": "Success!",
                    "message": "Unknown Error. Please Contact System Admin!!"
                });
                toastEvent.fire();
            }
        });  
        $A.enqueueAction(action);
    }, 
})