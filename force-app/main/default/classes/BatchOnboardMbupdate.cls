global class BatchOnboardMbupdate implements Database.Batchable<sObject>{
   global String query;
    global BatchOnboardMbupdate() {}
    global BatchOnboardMbupdate(String qry) {
        query = qry;
    }
   global Database.QueryLocator start(Database.BatchableContext BC) {
       if (String.isBlank(query))
         query = 'Select Id, ldmob__c, xadtx1__c from g_req__c where srvc__r.uid__c=\'322\' and os__c=\'Lead generated\' and xcmob__c=\'\'';

        return Database.getQueryLocator(query);
    }
     global void execute(Database.BatchableContext BC, List<g_req__c> scope) {
        g_req__c rq = scope[0];
         if (String.isNotBlank(rq.xadtx1__c)) {
              ReqData rqData = (ReqData) JSON.deserialize(rq.xadtx1__c, ReqData.class);
             if (String.isNotBlank( rqData.phoneno)) {
                   String mb = rqData.phoneno;
                   rq.ldmob__c = mb.replaceAll('\\D', '');
                  if (Schema.sObjectType.g_req__c.isUpdateable()) {
                      update rq;
                  }
             }

         }
    }
    global void finish(Database.BatchableContext BC) {}
    global class ReqData {
        public string phoneno;
    }
}