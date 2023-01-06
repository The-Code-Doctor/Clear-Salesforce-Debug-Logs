/* 
*   The Batch class to allow muliple log files (100 of them) at a time
*/
public class Tool_DeleteDebugLogsJob implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    //Variable Declaration
    private String formedQuery = 'Select Id from Apexlog ';
    private String querySuffix = ' order by LogLength desc';
    private List<String> userIds;
    private Boolean keepTodaysLogs = false;
    
    public Tool_DeleteDebugLogsJob() {
    }
    
    public Tool_DeleteDebugLogsJob(List<String> userIds) {
        this.userIds = userIds;
    }
    
    public Tool_DeleteDebugLogsJob(Boolean keepTodaysLogs) {
        this.keepTodaysLogs = keepTodaysLogs;
    }
    
    public Tool_DeleteDebugLogsJob(List<String> userIds, Boolean keepTodaysLogs) {
        this.userIds = userIds;
        this.keepTodaysLogs = keepTodaysLogs;
    }
    
    /*=================================================
    * @method name: start
    * @purpose: To initiate the batch process.
    * @param: Database Batchable Context
    * @return: Database.getQueryLocator
    *=================================================*/
    public Database.QueryLocator start(Database.BatchableContext objBatchContext){
        String whereClause = '';
        if(userIds != NULL && !userIds.isEmpty()) {
            whereClause += 'where LogUserId IN :userIds';
        } 
        if(keepTodaysLogs) {
            if(String.isBlank(whereClause)) {
                whereClause += 'where LastModifiedDate<TODAY';
            } else {
                whereClause += ' AND LastModifiedDate<TODAY';
            }
        }
        formedQuery += (String.isBlank(whereClause) ? '' : whereClause) + querySuffix;
        return Database.getQueryLocator(formedQuery);
    }
    
    
    /*=================================================
    * @method name: execute
    * @purpose: To perform the Rest API callout to delete log records
    * @param: Database Batchable Context, List of ApexLog (Debug Log) records to be deleted
    =================================================*/
    public void execute(Database.BatchableContext objBatchContext, List<sObject> lstRecords){
        String idList = '';
        for(sObject al: lstRecords){
            idList += al.Id+',';
        }
        if(idList.contains(',')){
            idList = idList.substring(0,idList.length()-1);
        }
        System.debug('Apex Log IDs being deleted in this batch : '+idList);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
                        + '/services/data/v44.0/composite/sobjects?ids='+idList);
        req.setMethod('DELETE');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        HttpResponse res = h.send(req);
    }
    
    
    /*=================================================
    * @method name: finish
    * @purpose: To perform further actions, once the batch run is completed.
    * @param: Database Batchable Context
    =================================================*/
    public void finish(Database.BatchableContext objBatchContext){
    }
}