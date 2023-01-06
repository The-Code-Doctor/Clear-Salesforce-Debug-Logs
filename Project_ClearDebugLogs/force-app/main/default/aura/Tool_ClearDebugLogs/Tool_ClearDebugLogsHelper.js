({
	deleteDebugLogs : function(component, event, helper) {
        component.set('v.status', 1);
		var action = component.get("c.clearDebugLogs");
        action.setParams({
            userIds: component.get('v.userIds'),
            keepTodaysLogs: component.get('v.keepTodaysLogs')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if ("SUCCESS" === state) {
                console.log('deletion in progress');
                component.set('v.initiated', true);
                helper.showToast('Started!!', 'Job started successfully to clear debug logs..', 'success');
                var interval = setInterval($A.getCallback(function () {
                    component.set('v.interval', interval);
                    var jobStatus = component.get("c.getBatchJobStatus");
                    if(jobStatus){
                        jobStatus.setParams({ jobID : response.getReturnValue()});
                        jobStatus.setCallback(this, function(jobStatusResponse){
                            var state = jobStatusResponse.getState();
                            if (state === "SUCCESS"){
                                var job = jobStatusResponse.getReturnValue();
                                var processedPercent = 0;
                                if(job.JobItemsProcessed != 0){
                                    processedPercent = (job.JobItemsProcessed / job.TotalJobItems) * 100;
                                }
                                if(job.TotalJobItems == 0){
                                    processedPercent = 100;
                                }
                                component.set('v.status', processedPercent);
                                if(processedPercent === 100) {
                                    clearInterval(interval);
                                    component.set('v.initiated', false);
                                    helper.showToast('Finished!!', 'Clear debug logs finished!', 'success');
                                }
                            }
                        });
                        $A.enqueueAction(jobStatus);
                    }
                }), 100);
            } else {
                console.error('log deletion failed: '+JSON.stringify(response.getError()));
                helper.showToast('Error Occurred!!', 'Failed to start the Job to clear the logs!', 'error');
            }
        });
        $A.enqueueAction(action);
    },
    
    abortJob : function(component, event, helper){
        let interval = component.get('v.interval');
        if(interval) {
            clearInterval(interval);
            component.set('v.interval', '');
            component.set('v.initiated', false);
            component.set('v.status', 0);
            helper.showToast('Aborted!!', 'The Job is Aborted!', 'success');
        }                 
    },
    
    showToast : function(title,message,type){
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title ,
            message : message,
            type  : type
        });
        toastEvent.fire();                  
    }
})