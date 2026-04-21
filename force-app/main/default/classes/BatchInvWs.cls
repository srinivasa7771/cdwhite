global class BatchInvWs implements Database.Batchable < sObject > , Database.AllowsCallouts {
    public string dt;
    public BatchInvWs() {}
    public BatchInvWs(String paymentDt) {
        dt = paymentDt;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {

        String query = 'select id, Name, A__c, md__c, RQ__c, RQ__r.xdei__c, RQ__r.name from g_Tran__c where Srv_Code__c=\'208\' and STA__c=\'Completed\' and DAY_ONLY(createddate) > ' + dt;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List < g_Tran__c > scope) {
      g_Tran__c t = scope[0];
      List < ws_call__c > wsLst = [select id from ws_call__c where rq_itm__r.rq__r.Service_Code__c = '208' and ws_typ__c = 'DccaExtraService' and mtd_nm__c = 'InvoiceCreation' and xrno__c =: t.RQ__r.name ];
      if (wsLst == null || wsLst.isEmpty()) {
          System.enqueueJob(new QueueClass(t.id));
      }
    }
    global void finish(Database.BatchableContext BC) {}

    public class QueueClass implements Queueable {
        Id recordid;
        public QueueClass(id recordid) {
            this.recordid = recordid;
        }
        public void execute(QueueableContext context) {
            g_Tran__c t = [select id, Name, A__c, md__c, RQ__c, RQ__r.xdei__c, RQ__r.name from g_Tran__c where id =:recordid][0];
            List < g_reqitem__c > riLst = [select id from g_reqitem__c where RQ__c =: t.RQ__c and itm__r.cd__c = 'dr'];
            if (riLst != null && !riLst.isEmpty()) grqWsDccaInvoiceService.invWsCreation(T, T.RQ__r.xdei__c, riLst[0].id);
        }
    }
}