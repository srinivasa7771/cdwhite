global class BatchCancelRequests implements Database.Batchable<sObject>{
    public String queryString;
    public static  BusinessHours bsHour;
    public BatchCancelRequests() {   try{
      //  bsHour = [SELECT Id FROM BusinessHours WHERE id= :gU.csStr('BH')];
        queryString = 'SELECT ID, AOP__c, AP__c, srvc__c, LastModifiedDate, Service_Code__c FROM g_Req__c where (STA__c=\'Draft\' or STA__c=\'Open\') and AOP__c=0 and AP__c=0 and isDeleted=false and Service_Code__c in (\'122\', \'126\', \'071\', \'035\', \'045\', \'048\', \'047\', \'032\', \'049\', \'034\', \'044\', \'055\', \'057\', \'067\', \'051\', \'033\', \'053\', \'052\', \'060\', \'066\', \'070\', \'036\', \'056\', \'072\', \'031\', \'100\', \'101\', \'115\', \'120\', \'119\', \'122\', \'116\', \'uae\', \'tbg\', \'tad\', \'058\', \'059\', \'054\', \'061\', \'062\', \'016\', \'ltc\', \'ltp\', \'082\', \'085\', \'098\', \'086\', \'087\', \'089\', \'088\', \'094\', \'096\', \'097\', \'095\', \'099\', \'104\', \'105\', \'106\', \'107\', \'073\', \'109\', \'110\', \'112\', \'113\', \'074\', \'lts\', \'ltn\')';
    }catch (Exception e) {}
    }
    public BatchCancelRequests(String reqId) {
        this();
        queryString += ' and id=\''+reqId+'\'';
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {return Database.getQueryLocator(queryString);}
    public void execute(Database.BatchableContext bc, list<g_Req__c> listofReq) {
        if (bsHour == null) {
            bsHour = [SELECT Id FROM BusinessHours WHERE id= :gU.csStr('BH')];
        }
        list<g_Req__c> listofReqToUpdate=new list<g_Req__c> ();
        for (g_Req__c r : listofReq) {
            Double hours=(Double)BusinessHours.diff(bsHour.id, r.LastModifiedDate, Date.Today())/(3600000);
            if ((hours/9)>=15) {
                listofReqToUpdate.add(r);
            }
        }
        List<g_reqitem__c> toUpdate = new List<g_reqitem__c>();
        for (g_Req__c ru : listofReqToUpdate) {
            ru.STA__c='Cancelled';
            map<String, Id> mapSTA = new map<String, Id>();
            for (g_srvcitm_Status__c s: [select id, cd__c, itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c=:ru.srvc__c and cd__c='xc']) {
                mapSTA.put(s.itm__r.cd__c, s.Id);
            }
            list<g_reqitem__c> items = [select Id, itm__r.cd__c, sta__c, sta__r.Tp__c from g_reqitem__c where RQ__c=: ru.Id and isDeleted = false and sta__r.Tp__c='Open'];
            for (g_reqitem__c i: items) {
                if (mapSTA.get(i.itm__r.cd__c)==null) {
                    System.debug(Label.msgNFSTAC);
                }
                i.sta__c = mapSTA.get(i.itm__r.cd__c);
                toUpdate.add(i);
            }
        }
        if (listofReqToUpdate.size()>0) {
            update(listofReqToUpdate);
        }
        if (toUpdate.size()>0) {
            update(toUpdate);
        }
    }
     public void finish(Database.BatchableContext bc) {}
}