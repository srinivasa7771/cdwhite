global class Batch_RI_MS_LNK implements Database.Batchable < sObject > {
    public String queryString;
    public String mm;
    public Batch_RI_MS_LNK() {
        queryString ='Select Name, RQ__c, srvItmsla__c, Milestone__c, mlstg__c, Id, (Select Name, Milestone__c From Status_History__r Where isdeleted=false and Milestone__c=null) From g_reqitem__c Where isdeleted=false ';
    }
    public Batch_RI_MS_LNK(String mm) {
        this();
        queryString += 'and CALENDAR_MONTH(CreatedDate)='+mm;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext bc, list < g_reqitem__c > listRIs) {
        System.debug('**Starting Execution');
        list < g_reqitem__c > toUpdateRI = new list < g_reqitem__c > ();
        list < g_itmHistorySTA__c > toUpdateSTAH = new list < g_itmHistorySTA__c > ();
        Set < ID > setOfRequestIds = new Set < ID > ();
        Set < ID > setOfServiceItemIds = new Set < ID > ();
        for (g_reqitem__c ri: listRIs) {
            setOfRequestIds.add(ri.RQ__c);
            System.debug('**ri.RQ__c'+ri.RQ__c);
        }
        List < g_Milestone__c > lstMls = new List < g_Milestone__c > ();
        Map < String, g_Milestone__c > mpMsFromCustomId = new Map < String, g_Milestone__c > ();
        System.debug('**Before Querying MS');
        for (g_Milestone__c mst: [SELECT Id, Name__c, Request__c, SLA__c FROM g_Milestone__c WHERE Request__c IN :setOfRequestIds]) {
            mpMsFromCustomId.put(mst.Request__c + mst.Name__c, mst);
            System.debug('**mpMsFromCustomId Key:'+ mst.Request__c + mst.Name__c);
        }
        System.debug('**After Querying MS');
        g_Milestone__c mst;
        for (g_reqitem__c ri: listRIs) {
            if (mpMsFromCustomId.containsKey(ri.RQ__c + ri.mlstg__c)) {
                System.debug('**Get Key:'+ ri.RQ__c + ri.mlstg__c);
                mst = mpMsFromCustomId.get(ri.RQ__c + ri.mlstg__c);
                ri.Milestone__c = mst.Id;
                if (ri.srvItmsla__c != null && ri.srvItmsla__c != 0 && ri.srvItmsla__c != mst.SLA__c) {
                    mst.SLA__c = ri.srvItmsla__c;
                    lstMls.add(mst);
                }
            }
            if (ri.Status_History__r != null) {
                if (ri.Status_History__r.size() > 0) {
                    for (g_itmHistorySTA__c sth: ri.Status_History__r) {
                        sth.Milestone__c = ri.Milestone__c;
                        toUpdateSTAH.add(sth);
                    }
                }
            }
            toUpdateRI.add(ri);
        }
        if (toUpdateSTAH.size() > 0) {
            Database.Update(toUpdateSTAH, false);
        }
    }
    public void finish(Database.BatchableContext bc) {
    }
}