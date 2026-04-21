global class BatchStatushistCd implements Database.Batchable < sObject>, Database.AllowsCallouts {
    global String query;
    global BatchStatushistCd() {
        query = 'select id, acts__c, actE__c, fcd__c, tcd__c, f__r.cd__c, t__r.cd__c from g_itmHistorySTA__c  where createddate >= 2020-11-01T00:00:00Z and tcd__c=\'\'';
    }
    global BatchStatushistCd(String sdt, String edt) {
        query = 'select id, acts__c, actE__c, fcd__c, tcd__c, f__r.cd__c, t__r.cd__c from g_itmHistorySTA__c  where tcd__c=\'\' and createddate >=' + sdt + ' and createddate <=' + edt;
    }
    global BatchStatushistCd(String sdt, String edt, boolean flg) {
        query = 'select id, fcd__c, acts__c, actE__c, tcd__c, f__r.cd__c, t__r.cd__c from g_itmHistorySTA__c  where cd__c<0  and  createddate >= 2021-11-01T00:00:00Z';
    }
    global BatchStatushistCd(String hi) {
        query = 'select id, fcd__c, acts__c, actE__c, tcd__c, f__r.cd__c, t__r.cd__c from g_itmHistorySTA__c  where cd__c<0 and id=\'' + hi + '\'';
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('query::' + query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List < g_itmHistorySTA__c > lst) {
        try {
            BusinessHours mBH = [SELECT Id FROM BusinessHours WHERE id =: gU.csStr('BH')];
            Integer toHour = 3600000;
            for (g_itmHistorySTA__c sta: lst) {
                sta.fcd__c = sta.f__r.cd__c;
                sta.tcd__c = sta.t__r.cd__c;
                if (sta.acts__c >sta.actE__c) {
                    sta.actE__c=(sta.acts__c).addMinutes(15);
                    sta.cd__c=calDuration(mBH.id, sta.acts__c, (sta.acts__c).addMinutes(15));
                    sta.Duration__c=calDuration(mBH.id, sta.acts__c, (sta.acts__c).addMinutes(15));
                }
            }
            if (Schema.sObjectType.g_itmHistorySTA__c.isUpdateable()) {
                update lst;
            }
        }
        catch (Exception ex) {
            system.debug('ex::' + ex.getMessage());
        }
    }
    public decimal calDuration(String bhid, datetime st, datetime et) {
        Integer toHour = 3600000;
        Decimal d = 0;
        d = ((Double) BusinessHours.diff(bhid, st, et)) / toHour;
        return d;
    }
    global void finish(Database.BatchableContext BC) {
    }
}