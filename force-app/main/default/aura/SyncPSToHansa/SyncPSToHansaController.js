({
    recordUpdate : function(component, event, helper) {
        console.log(component.get('v.currentUser'));
        //alert(component.get("v.currentUser").Profile.Name);
        
        var userProfile = component.get("v.currentUser").Profile.Name;
        var startSync = false;
        /*if(userProfile != 'Ceetak Admin' && userProfile != 'Ceetak Accounts' && userProfile != 'System Administrator'){
            component.set("v.message","You don't have permission to sync Product record to Hansa. Please contact system administrator");
        }else{*/
            component.set("v.message","Syncing In Progress...");
            startSync = true;
       // }
        
        if(startSync){
            component.set("v.showSpinner",true);
            var action = component.get("c.checkPSConditions");
            action.setParams({ psId : component.get("v.recordId") });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('SUCCESS!!!');
                    var returnValue = response.getReturnValue();
                    console.log('@@@@@@@@@@ returnValue ==>'+returnValue);
                    if(returnValue != null && returnValue ){
                        component.set('v.message','Please click below Save button, to sync all fields to Hansa record.<br/><b>Note  - This will override all values in Hansa.</b>');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",true);
                    }else{
                        component.set('v.message','Please click below Save button, to create this record in Hansa.');
                        component.set("v.showSpinner",false);
                        component.set("v.showSave",true);
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
        var action = component.get("c.syncPSToHansa");
        action.setParams({ psId : component.get("v.recordId") });
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
                        "message": "We are syncing this record to Hansa.\n For result please see \"Hansa Sync Details\" section on record "
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