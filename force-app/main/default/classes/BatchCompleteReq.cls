global class BatchCompleteReq implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
    String query;

    public BatchCompleteReq() {}
    public BatchCompleteReq(Id rqItemId) {
        // query = 'Select Id, name, sta__c, (SELECT id, name, sta__r.cd__c, sta__r.rqSTA__c from items__r where sta__r.rqSTA__c in (\'Cancelled\', \'Completed\', \'rejected\'))  from g_req__c where sta__c  in (\'Open\', \'In Process\', \'Under Review\') and isp__c=false and id=\''+rqId+'\'';
         query = 'SELECT id, rq__c, rq__r.sta__c, sta__r.rqSTA__c from g_reqitem__c where sta__r.rqSTA__c in (\'Cancelled\', \'Completed\', \'Rejected\') and rq__r.sta__c in (\'Open\', \'Under Review\', \'In Process\') and id=\''+
             rqItemId+'\'';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        if (String.isBlank(query)) {
            query = 'SELECT id, rq__c, rq__r.sta__c, sta__r.rqSTA__c from g_reqitem__c where sta__r.rqSTA__c in (\'Cancelled\', \'Completed\', \'Rejected\') and rq__r.sta__c in (\'Open\', \'Under Review\', \'In Process\') limit 999';
        }
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<g_reqitem__c> scope) {
        Map<String, String> mapStatusByID = new Map<String, String>();
        List<g_req__c> reqToUpdate = new List<g_req__c>();

        for (g_reqitem__c ri : scope) {
            if (!mapStatusByID.containsKey(ri.rq__c)) {
                mapStatusByID.put(ri.rq__c, ri.sta__r.rqSTA__c);
            }
        }

        for (String rqId : mapStatusByID.keyset()) {
            g_req__c rq = new g_req__c(id=rqId, sta__c=mapStatusByID.get(rqId), isp__c=true);
            reqToUpdate.add(rq);
        }

        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update reqToUpdate;
        }
    }

    /*

    global Database.QueryLocator start(Database.BatchableContext BC) {
        if (String.isBlank(query)) {
            query = 'Select Id, name, sta__c, (SELECT id, name, sta__r.cd__c, sta__r.rqSTA__c from items__r where sta__r.rqSTA__c in (\'Cancelled\', \'Completed\', \'rejected\')) from g_req__c where sta__c  in (\'Open\', \'In Process\', \'Under Review\')  and isp__c=false limit 999';
        }
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<g_req__c> scope) {

        List<g_req__c> lstToUpdate = new List<g_req__c>();
        Set<String> statuses = new Set<String>{'completed', 'rejected', 'cancelled'}; //all lower case

        for (g_req__c rq : scope) {
            if (rq.items__r != null && rq.items__r.size()>0) {
                for (g_reqItem__c i : rq.items__r) {
                    if (String.isNotBlank(i.sta__r.rqSTA__c) && statuses.contains(i.sta__r.rqSTA__c.toLowerCase()) ) {
                        rq.sta__c = i.sta__r.rqSTA__c;  // if there are 5 items but controlling item's status is ok/r/c/xc then update req status accordingly
                        break;
                    }
                }
            }

            rq.isp__c = true;
            lstToUpdate.add(rq);
        }
        if (lstToUpdate.size()>0) {
            if (Schema.sObjectType.g_req__c.isUpdateable()) {
                update lstToUpdate;
            }
        }
    }
    */

    global void finish(Database.BatchableContext BC) {}

    global void execute(SchedulableContext sc) { database.executeBatch(new BatchCompleteReq(), 1);}

    /*global Database.QueryLocator start(Database.BatchableContext BC) {
        if (String.isBlank(query)) {
            query = 'Select Id, name, sta__c, xadh__c, (SELECT id, name, sta__r.cd__c, sta__r.name, sta__r.Tp__c, sta__r.rqSTA__c from items__r where sta__r.Tp__c in (\'Cancelled\', \'Completed\', \'rejected\'))  from g_req__c where sta__c  in (\'Open\', \'In Process\', \'Under Review\') and rist__c>0 and updSTA__c=true limit 999';
        }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<g_req__c> scope) {
        List<g_req__c> lstToUpdate = new List<g_req__c>();
        Set<String> statuses = new Set<String>{'completed', 'rejected', 'cancelled'};
        for (g_req__c rq : scope) {
            if (rq.items__r != null && rq.items__r.size()>0) {
                String rqStatus = '';//Integer n = 0;
                for (g_reqItem__c i : rq.items__r) {
                    //if (i.sta__r.cd__c.equalsIgnoreCase('ok') || i.sta__r.name.equalsIgnoreCase('Completed')) {n += 1;}
                    if (String.isNotBlank(i.sta__r.Tp__c) && String.isNotBlank(i.sta__r.rqSTA__c) && statuses.contains(i.sta__r.Tp__c.toLowerCase()) ) {rqStatus = i.sta__r.rqSTA__c;}
                }
                // update request status if all items are completed/cancelled/rejected*/ /*if (n>0 && rq.items__r.size()==n) {rq.sta__c = 'Completed';lstToUpdate.add(rq);}
                rq.sta__c = String.isNotBlank(rqStatus) ? rqStatus : 'Completed';lstToUpdate.add(rq);
            }
        }
        if (lstToUpdate.size()>0) {update lstToUpdate; }
    }*/

}