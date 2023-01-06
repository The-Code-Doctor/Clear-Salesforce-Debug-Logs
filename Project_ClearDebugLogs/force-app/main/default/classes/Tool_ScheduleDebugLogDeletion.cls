/* 
*   The Schedulable class that you can use to schedule the Debug Log deletion automatically during the preferred time everyday
*/
public class Tool_ScheduleDebugLogDeletion implements Schedulable {
    
    public void execute(SchedulableContext objScheduleContext) {
        Tool_DeleteDebugLogsJob sObjectDeleteJob = new Tool_DeleteDebugLogsJob();
        Id jobId=database.executeBatch(sObjectDeleteJob, 100);
        System.debug('Job Started='+jobId);
    }
    
}