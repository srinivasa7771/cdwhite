public with sharing class Case_Request_Status_CTL
{
    public g_Req__c req{get;set;}
    public Case cs {get;set;}

    public Case_Request_Status_CTL(ApexPages.StandardController controller) {
        cs=(Case)controller.getRecord();
        loadData();
    }

    public void loadData() {
        cs = [Select Id, Request__c from Case Where Id =: cs.Id];
        if (cs.Request__c != null) {
            req = [Select Id, Name , srvc__r.stg__r.reqq__c  From g_Req__c  where id=: cs.Request__c];
            req = (g_Req__c)Database.query(req.srvc__r.stg__r.reqq__c + ' where id=\'' + String.escapeSingleQuotes(String.valueOf(req.id)) + '\' and isDeleted = false');
        }
    }
}