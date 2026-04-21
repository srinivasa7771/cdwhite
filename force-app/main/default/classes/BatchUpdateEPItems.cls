global class BatchUpdateEPItems implements Database.Batchable < sObject > , Database.AllowsCallouts, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select id , name, xai__c, (select id, name, itm__r.cd__c, sta__r.name, sta__r.xai__c, sta__r.cd__c from items__r) from g_req__c where sta__c in (\'Open\', \'Under Review\', \'In Process\') ';
        if (!test.isRunningTest()) {
            query += ' and Item_Count__c>0 and  srvc__r.uid__c in (\'001\', \'002\', \'004\', \'021\', \'078\', \'304\', \'001\', \'040\', \'003\', \'020\', \'303\', \'011\', \'006\', \'140\', \'005\', \'138\', \'013\', \'141\', \'312\', \'313\') and createddate<2021-01-17T00:00:00.000+0000 limit 5000';
        }
        //', '002', '004', '021', '078', '304', '001', '040', '003', '020', '303', '011', '006', '140', '005', '138', '013', '141', '312', '313'
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <g_req__c> scope) {
        List<g_req__c> rqToUpdate = new List<g_req__c> ();

        for (g_req__c rq : scope) {
            Map<String, String> allItems = new Map<String, String>();

            if (rq.items__r != null && rq.items__r.size()>0) {
                for (g_reqItem__c ri : rq.items__r) {
                    String str = '';
                    String iCd = ri.itm__r.cd__c.toLowerCase();
                    if (iCd=='ep' && (ri.sta__r.cd__c=='ok' || ri.sta__r.cd__c=='ii')) {str='ai:ARRIVAL INTIMATION;la:LOCAL AMENDMENT;';}

                    if (!allItems.containsKey(ri.itm__r.cd__c)) {
                        allItems.put(iCd, str);
                    }
                }
            }

            if (allItems.containsKey('ep') && String.isNotBlank(allItems.get('ep')) && !allItems.containsKey('la') && !allItems.containsKey('ai') ) {
                rq.xai__c = allItems.get('ep');
                rqToUpdate.add(rq);
            }
        }

        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update rqToUpdate;
        }

    }

    global void finish(Database.BatchableContext BC) {}

    global void execute(SchedulableContext sc) {
        database.executeBatch(new BatchUpdateEPItems(), 1);
    }

}