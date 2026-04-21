global class BatchGDRFAAccessToken implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select id,MasterLabel,DeveloperName,tokenvalue__c from GDRFAAPITOKEN__mdt';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <GDRFAAPITOKEN__mdt> scope) {
       // SECURITY: Removed sensitive debug log
    }

    global void finish(Database.BatchableContext BC) {}

    global void execute(SchedulableContext SC) {database.executebatch(new BatchGDRFAAccessToken());}
}