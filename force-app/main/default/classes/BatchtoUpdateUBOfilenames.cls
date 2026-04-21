global class BatchtoUpdateUBOfilenames implements database.batchable<Sobject>{
    global database.QueryLocator start(database.BatchableContext bc) {
        String reqquery = 'Select ID, Name, Acc__r.Name, STA__c, (select Name from Attachments )  from g_req__c where srvc__r.UID__c=\'209\'';
        return database.getQueryLocator(reqquery);
    }
    global void execute(database.BatchableContext bc , list<g_req__c> scope) {
        Map<String, String> rqMap = new Map<String, String>();
        for (g_req__c rq : scope) {
            for (Attachment a : rq.Attachments) {
                if (String.isNotBlank(a.Name)) {
                    if (rqMap.containsKey(rq.Id)) {
                        rqMap.put(rq.Id, rqMap.get(rq.Id)+';'+a.Name);
                    }
                    else{
                        rqMap.put(rq.Id, a.Name);
                    }
                }
            }
        }
        if (!rqMap.isEmpty()) {
            List<g_req__c> greqtoupdate = new List<g_req__c>();
            List<g_req__c> rqlst1 = [select id from g_req__c where id In:rqMap.keyset()];
            for (g_req__c rq1 : rqlst1) {
                rq1.UBO_File_Name__c= rqMap.get(rq1.Id);
                greqtoupdate.add(rq1);
            }
            system.debug('greqtoupdate--'+greqtoupdate);
            system.debug('greqtoupdate--size'+greqtoupdate.size());
            if (!greqtoupdate.isEmpty()) {
                if (Schema.sObjectType.g_req__c.isUpdateable()) {
                    update greqtoupdate;
                }
            }
        }
    }
    global void finish(database.BatchableContext bc) {}
}