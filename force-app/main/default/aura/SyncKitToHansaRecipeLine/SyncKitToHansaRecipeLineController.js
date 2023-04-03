({
    recordUpdate : function(component, event, helper) {
        console.log('@@@@@@@## first method call');
        console.log(component.get('v.currentUser'));
        //alert(component.get("v.currentUser").Profile.Name);
        
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
                    
                    if(returnValue != null && returnValue=='NotValidRecord'){
                        component.set('v.message','This is Invalid record to sync, Please check');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "Error",
                            "title": "Error",
                            "message": "This is Invalid record to sync, Please check! "
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                        
                        
                    }else if(returnValue != null && returnValue=='NoRecipe'){
                        component.set('v.message','Please check Product is not a active Recipe in Hansa');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "Error",
                            "title": "Error",
                            "message": "Product is not a active Recipe in Hansa, Please check! "
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                        
                        
                    }else if(returnValue != null && returnValue=='NoRowRef'){
                        component.set('v.message','Please check Kit has not row ref');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "Error",
                            "title": "Error",
                            "message": "Kit has not row ref, Please check! "
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                        
                        
                    }else if(returnValue != null && returnValue=='KitNotAvailable'){
                        component.set('v.message','Please check Kit is not a Hansa Item.');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "Error",
                            "title": "Error",
                            "message": "Kit is not a Hansa Item, Please check! "
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                        
                        
                    }else if(returnValue != null && returnValue=='updateHansa'){
                        component.set('v.message','Please click below Save button, to sync all fields to Hansa RecipeLine.<br/><b>Note  - This will override all values in Hansa.</b>');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",true);
                    }else if(returnValue != null && returnValue=='readyInsert'){
                        component.set('v.message','Please click below Save button, to create this Kit as RecipeLine in Hansa.');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",true);
                    }
                    
                    // END***
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
        action.setParams({ kitId : component.get("v.recordId") });
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
                        "message": "We are syncing this Product to Hansa Item.\n For result please see \"Hansa Sync Details\" section on record "
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