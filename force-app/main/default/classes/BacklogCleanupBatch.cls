public class BacklogCleanupBatch implements Database.Batchable <sObject>{
    public String queryString {set;get;}
    public BacklogCleanupBatch() {
       queryString = Label.DataClnupSQL;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext bc, List < sObject > lst) {
        if (lst != null && !lst.isEmpty()) {
            Database.delete(lst, false);
        }

    }
    public void finish(Database.BatchableContext bc) {
        if (Label.DataClnupBatchFlg == 'true' || Test.isRunningTest()) {
        List<sobject> lst = Database.query(String.escapeSingleQuotes(queryString));
        if (lst != null && !lst.isEmpty()) {
            BacklogCleanupBatch obj = new BacklogCleanupBatch();
            Database.executeBatch(obj);
        }
      }
    }
}