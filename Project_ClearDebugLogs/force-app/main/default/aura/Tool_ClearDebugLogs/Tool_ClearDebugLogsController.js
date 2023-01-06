({
	deleteAllDebugLogs : function(component, event, helper) {
      component.set('v.userIds', []);
		  helper.deleteDebugLogs(component, event, helper);
	},
  
  deleteMyDebugLogs : function(component, event, helper) {
      let userIds = [];
      userIds.push($A.get("$SObjectType.CurrentUser.Id"));
      component.set('v.userIds', userIds);
      helper.deleteDebugLogs(component, event, helper);
  },

  abortJob : function(component, event, helper) {
    helper.abortJob(component, event, helper);
}
})