global class khdaSanctionBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select id, Name, dsgu__c, STA__c, epexpdt__c, xdrv__c, Acc__c, Acc__r.snc__c, Acc__r.lcsnc__c, Acc__r.lc__c, Acc__r.lcsncnt__c from g_Req__c where Service_Code__c =\'208\' and epexpdt__c >= Today';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List <g_Req__c> scope) {
        List<g_Req__c> rqList = new List<g_Req__c>();
        map<String, g_Req__c> dccaReqSanc = new  map<String, g_Req__c>();
        map<String, g_Req__c> dccaRemoveReqSanc = new  map<String, g_Req__c>();
        List<Account> accList = new List<Account>();
        for (g_Req__c rq: scope) {
            if (rq.epexpdt__c == system.today()) {
                account ac = new account();
                ac.id = rq.Acc__r.id;
                String accSnc =rq.Acc__r.snc__c;
                if (String.IsBlank(accSnc) ) {
                    ac.snc__c = 'RnL- Required Docs;';
                }else{
                    if (!(accSnc.contains('RnL- Required Docs')))
                    ac.snc__c = rq.Acc__r.snc__c +';'+'RnL- Required Docs;';
                }
                dccaReqSanc.put(rq.Acc__r.lc__c, rq);
                accList.add(ac);
            }else if (  rq.epexpdt__c != null && rq.epexpdt__c > system.today() && rq.dsgu__c == true && (rq.STA__c== 'Under Review' || rq.STA__c== 'Open'  || rq.STA__c== 'In Process') ) {
                account ac = new account();
                ac.id = rq.Acc__r.id;
                String accSnc =rq.Acc__r.snc__c;
                if (accSnc != null && (accSnc.contains('RnL- Required Docs;') || accSnc.contains('RnL- Required Docs'))) {
                    ac.snc__c = accSnc.replace('RnL- Required Docs;', '');
                    ac.snc__c = accSnc.replace('RnL- Required Docs', '');
                }
                dccaRemoveReqSanc.put(rq.Acc__r.lc__c, rq);
                accList.add(ac);
            }
        }
        if (Schema.sObjectType.Account.isUpdateable()) {
            update accList;
        }
        if (dccaReqSanc != null) {
            grqDccaSanc.khdaSanction(dccaReqSanc, 'open');
        }
        if (dccaRemoveReqSanc != null) {
            grqDccaSanc.khdaSanction(dccaReqSanc, 'closed');
        }

    }
    global void finish(Database.BatchableContext BC) {}
}