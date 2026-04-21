global class Batch_Cour_up implements Database.Batchable < sObject > {
    public String queryString;
    public String mm;
    public Batch_Cour_up() {
        queryString = 'select Id, Name, sta__c, AWB__c, itm__r.RQ__c, itm__r.sta__c from g_cmb__c  where xcb__c='+
            '\'Delivery\''+ 'and adh__c=false and IsDeleted=false and itm__r.sta__r.Tp__c='+'\'Open\''+ 'and Not_in_same_STA__c=true and sta__c='+
            '\'Delivered\'';
    }
    public Batch_Cour_up(String mm) {
        this();
        queryString += 'and CALENDAR_MONTH(CreatedDate)=' + mm;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext bc, list < g_cmb__c > cb) {
        set<String> setSr = new set<String>();
        set<String> setStatus = new set<String>();
        set<Long> setAWBNo = new set<Long>();
        List<g_reqitem__c> upItms = new List<g_reqitem__c>();
        Map<String, Courier_Status__c> MapStatusTo = new Map<String, Courier_Status__c>();
        List<g_req__c> rq=new List<g_req__c>();
        try{
            for (g_cmb__c loopvar: cb) {
                setStatus.add(loopvar.itm__r.sta__c);
                setSr.add(loopvar.itm__r.RQ__c);
                setAWBNo.add(Long.valueOf(loopvar.AWB__c));
            }
            g_reqitem__c item;
            for (Courier_Status__c loopvar :[SELECT Id, Courier_Status__c, curSTA__c, itmSTA__c, itmSTA__r.rqSTA__c, srvitm__c FROM Courier_Status__c WHERE  curSTA__c IN :setStatus ]) {
                MapStatusTo.put(loopvar.Courier_Status__c+loopvar.curSTA__c+loopvar.srvitm__c, loopvar);
            }
            List<g_cmb__c> courRecList=[select id, Name, xawb__c, itmsta__c, sta__c, tmpstamp__c,
                xupr__c, itm__c, itm__r.itm__c, xnsct__c, itm__r.id, itm__r.RQ__c, itm__r.RQ__r.STA__c,
                itm__r.STA__r.Milestone__c, itm__r.Name, itm__r.xcawb__c, itm__r.xcco__c, itm__r.sta__c,
                itm__r.sta__r.Tp__c, itm__r.sta__r.rqSTA__c,
                    itm__r.xcusr__c from g_cmb__c  where  xawb__c in :setAWBNo and adh__c=false and IsDeleted=false and itm__r.sta__r.Tp__c='Open' and Not_in_same_STA__c=true and sta__c='Delivered'];
            if (courRecList.size() > 0) {
                for (g_cmb__c itm :courRecList) {
                    if (MapStatusTo.containsKey(itm.sta__c + itm.itmsta__c + itm.itm__r.itm__c) && MapStatusTo.get(itm.sta__c + itm.itmsta__c + itm.itm__r.itm__c) != null) {
                        Courier_Status__c cs = MapStatusTo.get(itm.sta__c  + itm.itmsta__c + itm.itm__r.itm__c);
                        if (itm.itm__r != null) {
                            item = itm.itm__r;
                            if (cs != null && cs.cursta__c == item.sta__c) {
                                item.sta__c = cs.itmSTA__c;
                                upItms.add(item);
                            }
                            if (itm.itm__r.RQ__r.STA__c != cs.itmSTA__r.rqSTA__c && (cs.itmSTA__r.rqSTA__c == 'Completed' || cs.itmSTA__r.rqSTA__c == 'Under Review')) {
                                rq.add(new g_Req__c(id = itm.itm__r.RQ__c, STA__c = cs.itmSTA__r.rqSTA__c));
                            }
                        }
                    }
                }
            }
            if (!upItms.isEmpty()) {
                if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                    update upItms;
                }
            }
            if (!rq.isEmpty()) {
                if (Schema.sObjectType.g_req__c.isUpdateable()) {
                    update rq;
                }
            }
        }
        catch (Exception e) {
            system.debug(e.getStackTraceString());
        }
    }
    public void finish(Database.BatchableContext bc) {
    }
}