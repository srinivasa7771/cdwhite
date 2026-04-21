global class Batch_Free_up implements Database.Batchable < sObject > {

    public String queryString;public String mm;
    public Batch_Free_up() {
        queryString = 'SELECT A__c,RQ__r.Name,RQ__r.srvc__c,RQ__c FROM g_Tran__c where Acc__r.Legal_Framework__c='+'\'Freelancer\''+'and A__c=7520.00 and Acc__r.Name!='+'\'test identity 1\''+' and RQ__r.Sta__c='+'\'Under Review\''+' and TP__c='+'\'Payment\''+' and STA__c='+'\'Completed\''+' and Srv_Code__c='+'\'208\''+' and createddate=last_n_days:360';
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext bc, list < g_Tran__c > cb) { try{ map < String, Id > mSTA = new map < String, Id > (); for (g_srvcitm_Status__c s: [select id, cd__c, itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c ='a0L0I00000GKKulUAH' and cd__c ='ok']) { mSTA.put(s.itm__r.cd__c, s.Id); } list < g_reqitem__c > items = [select Id, itm__r.cd__c, sta__c from g_reqitem__c where RQ__c =: cb[0].RQ__c and isDeleted = false and sta__r.Tp__c = 'Open']; list < g_reqitem__c > tU = new list < g_reqitem__c > (); for (g_reqitem__c i: items) { if (mSTA.get(i.itm__r.cd__c) == null) {  i.sta__c = mSTA.get(i.itm__r.cd__c); tU.add(i); } if (tU.size() > 0) { update tU; } g_req__c r= new g_req__c(id=cb[0].RQ__c,STA__c='Completed'); update r; } }catch (Exception e) { system.debug(e.getStackTraceString()); } }
    public void finish(Database.BatchableContext bc) {}
}