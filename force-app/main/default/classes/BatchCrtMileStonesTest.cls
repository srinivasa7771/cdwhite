@isTest
private class BatchCrtMileStonesTest {
     static testMethod void doTest() {
        test.startTest();
        BatchCrtMileStones ctrl =  new BatchCrtMileStones('15');
         ctrl.queryString = 'select id from account where  IsDeleted=false  ';
          Database.executeBatch(ctrl);
        test.stopTest();
    }

}