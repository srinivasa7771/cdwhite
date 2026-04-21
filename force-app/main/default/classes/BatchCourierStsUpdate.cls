public class BatchCourierStsUpdate implements Database.Batchable < sObject >, Database.AllowsCallouts {
   public String queryString;
   public  List<String> rlst;
    public BatchCourierStsUpdate() {
       queryString='select id, sta__c, itm__c, rq__c from g_reqitem__c where Temp_Current_Status_Code__c in (\'ii\', \'dc\') and rq__r.sta__c in (\'Open\', \'Under Review\', \'In Process\') and name not in (\'Local Amendment\', \'Arrival Intimation\')';
    }
    public BatchCourierStsUpdate(String rname) {
        rlst = rname.split(', ');
       queryString='select id, sta__c, itm__c, rq__c from g_reqitem__c where rq__r.name=:rlst and Temp_Current_Status_Code__c in (\'ii\', \'dc\') and rq__r.sta__c in (\'Open\', \'Under Review\', \'In Process\') and name not in (\'Local Amendment\', \'Arrival Intimation\')';

    }
    public Database.QueryLocator start(Database.BatchableContext bc) {return Database.getQueryLocator(queryString);}
    public void execute(Database.BatchableContext bc, list < g_reqitem__c > ritmLst) {
       g_reqitem__c ri = ritmLst[0];

       List<g_srvcitm_Status__c> stsLst =  [select id, rqSTA__c from g_srvcitm_Status__c where itm__c=:ri.itm__c and cd__c = 'ok'];
        if (stsLst != null && !stsLst.isEmpty()) {
            ri.sta__c = stsLst[0].id;
            update ri;
            if (String.isNotBlank(stsLst[0].rqSTA__c) && stsLst[0].rqSTA__c == 'Completed') {
                g_req__c R = new g_req__c(id=ri.rq__c, STA__c=stsLst[0].rqSTA__c);
                if (Schema.sObjectType.g_req__c.isUpdateable()) {
                    update R;
                }
            }
        }

    }
    public void finish(Database.BatchableContext bc) {}
}