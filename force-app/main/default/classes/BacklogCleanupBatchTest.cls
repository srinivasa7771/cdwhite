@isTest
private class BacklogCleanupBatchTest {
   static testmethod void test() {
       User adminU = [Select Id, Name from User where Name = 'System Admin'
                                                           LIMIT 1
                                                          ];
                                          List<Account> accLst = new LIst<Account>();
                                            Account a = new Account(name = 'Acc',
                                                                    Type = 'Customer - External',
                                                                    Prk__c = 'Dubai Internet City',  Owner = adminU);
                                           Account a1 = new Account(name = 'Acc1',
                                                                    Type = 'Customer - External',
                                                                    Prk__c = 'Dubai Internet City',  Owner = adminU);
       accLst.add(a); accLst.add(a1);
       insert accLst;

        Test.startTest();
         BacklogCleanupBatch obj = new BacklogCleanupBatch();
         obj.queryString = 'select id from Account limit 1';
          database.executeBatch(obj, 1);
        Test.stopTest();
    }
}