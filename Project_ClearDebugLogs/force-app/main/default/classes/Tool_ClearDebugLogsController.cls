/*
 * Please ensure you provide Apex Access to this class on all the required profiles after deployment 
 * if any users other than System Administrators need to use it. 
 * Because for System Administrators it would be automatically added during deployment.
 * Please reach out at contact.thecodedoctor@gmail.com in case of any issues.
*/
public without sharing class Tool_ClearDebugLogsController {
    
    /* ================================================
    *@description : The method starts the Batch Job to clear the debug logs meeting the selected criteria
	 @param : userIds - List of users whose debug logs need to be removed. All logs will be cleared if this is NULL.
     @param : keepTodaysLogs - If true, it will not clear the current day's logs.
    *@return : String - jobId : The ID of the Batch Job that is started
     ================================================*/
    @AuraEnabled    
    public static String clearDebugLogs(List<String> userIds, Boolean keepTodaysLogs){
        Tool_DeleteDebugLogsJob sObjectDeleteJob = new Tool_DeleteDebugLogsJob(userIds, keepTodaysLogs);
        Id jobId=database.executeBatch(sObjectDeleteJob, 100);
        System.debug('Job Started='+jobId);
        return jobId; 
    }
    
    /* ================================================
      *@description : The method returns the current status of the Batch Job
	   @param : jobId - Id of the batchJb for which the status need to be checked
      *@return : AsyncApexJob - Current Detail Record of the Batch Jb
     ================================================*/
     @AuraEnabled
    public static AsyncApexJob getBatchJobStatus(Id jobID){
        return [SELECT Status,JobItemsProcessed,TotalJobItems FROM AsyncApexJob WHERE Id = :jobID];
    }
}