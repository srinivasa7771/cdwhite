global class BatchUpdateNxtStatus implements Database.Batchable < sObject > , Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        /*String query = 'Select id, name, uid__c, copyCofig__c  from g_Srvc__c where AccTp__c includes(\'Customer - External;\') AND  copyCofig__c=false AND uid__c  NOT IN (\'149\', \'150\', \'152\', \'153\', \'154\', \'156\', \'157\', \'159\', \'213\', \'133\', \'116\', \'XXX\', \'122\', \'ltc\', \'ltp\', \'ltn\', \'lts\', \'050\', \'051\', \'052\')';
        */  String query = 'Select id, name, uid__c, copyCofig__c  from g_Srvc__c';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List < g_Srvc__c > scope) {
        g_Srvc__c srv= scope[0];
        copyStatuses.updateNextStatuses(srv.uid__c, null);
    }
    global void finish(Database.BatchableContext BC) {
    }
/*Select id, name, uid__c from g_Srvc__c where AccTp__c includes('Customer - External;') AND uid__c  NOT IN ('149', '150', '152', '153', '154', '156', '157', '159', '213', '133', '116', 'XXX', '122', 'ltc', 'ltp', 'ltn', 'lts', '050', '051', '052')*/  }