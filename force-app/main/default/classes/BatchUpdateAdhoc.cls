global class BatchUpdateAdhoc implements Database.Batchable < sObject > , Database.AllowsCallouts, Schedulable  {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, name, xadh__c, (SELECT id, name, itm__r.cd__c from items__r) from g_req__c where xadh__c=\'\' and createddate > LAST_N_MONTHS:3 and sta__c in (\'Draft\', \'Open\', \'In Process\', \'Under Review\') limit 999';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <g_req__c> scope) {
        for (g_req__c rq : scope) {

            if (String.isBlank(rq.xadh__c)) {rq.xadh__c='';}else{rq.xadh__c = ';';}

            if (rq.items__r != null && rq.items__r.size()>0) {
                for (g_reqItem__c i :  rq.items__r) {
                    if (!rq.xadh__c.contains(i.itm__r.cd__c+';')) {
                        rq.xadh__c += i.itm__r.cd__c+';';
                    }
                }
            }

        }
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update scope;
        }

    }

    global void finish(Database.BatchableContext BC) {}
    global void execute(SchedulableContext sc) { database.executeBatch(new BatchUpdateAdhoc(), 1);}

}