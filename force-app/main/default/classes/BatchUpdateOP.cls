global class BatchUpdateOP implements Database.Batchable < sObject > {
  public String queryString;
 global BatchUpdateOP(String dt) { // LAST_N_DAYS:180
      queryString = 'select id, itm__r.srvc__r.name, itm__r.srvc__r.uid__c, createddate from g_reqitem__c where itm__r.srvc__r.uid__c not in (\'208\', \'122\')  and itmCd__c in (\'pt\', \'pnt\', \'ptn\') and AP__C=0 and createddate < '+
          dt+'  order by createddate';
      system.debug(queryString);
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext bc, List < g_reqitem__c  > scope) {
        if (Schema.sObjectType.g_reqitem__c.isDeletable()) {
            delete scope;
        }
    }
    public void finish(Database.BatchableContext bc) {}
}