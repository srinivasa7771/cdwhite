public class BatchCancelUnderCancellationSR implements Database.Batchable < sObject >, Schedulable {
    public String queryString;
    public List<String> rqSta;
    public BatchCancelUnderCancellationSR() {
        rqSta = new List<String>{'Completed', 'Cancelled', 'Rejected'};
        queryString = 'select id, name, acc__r.name, srvc__r.name, srvc__r.uid__c, createddate from g_req__c where sta__c not in:rqSta and srvc__r.uid__c  in (\'208\') and acc__r.lcsta__c in (\'License Under Cancellation\', \'License Cancelled\') and  AP__c=0 order by createddate desc';
        system.debug(queryString);
    }
    public BatchCancelUnderCancellationSR(String accId) {
        this();
        String aid = accId;
        queryString = 'select id, name, acc__r.name, srvc__r.name, srvc__r.uid__c, createddate from g_req__c where sta__c not in:rqSta and srvc__r.uid__c in (\'208\')  and acc__r.lcsta__c in (\'License Under Cancellation\', \'License Cancelled\') and  AP__c=0 and acc__c=\''+
            accId+'\' order by createddate ';

    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('queryString --- '+queryString);
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext bc, List < g_req__c  > scope) {
        system.debug('scope -- '+scope);
        List<g_req__c> srToCancel = new List<g_req__c>();
        for (g_req__c r: scope) {
            r.sta__c = 'Cancelled';
            srToCancel.add(r);
        }
        if (srToCancel != null && srToCancel.size()>0)
            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                update srToCancel;
            }
    }
    public void finish(Database.BatchableContext bc) {}

    public void execute(SchedulableContext sc) {
        BatchCancelUnderCancellationSR b = new BatchCancelUnderCancellationSR();
        database.executebatch(b, 1);
    }
}