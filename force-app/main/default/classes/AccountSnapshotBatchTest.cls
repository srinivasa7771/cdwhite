@isTest
private class AccountSnapshotBatchTest {

    static testmethod void testAccountSnapshotBatch() {
      Test.startTest();
        testData.init();
        Account a=testData.accCrt(false);
        AccountSnapshotBatch obj = new AccountSnapshotBatch();
        String cronExp = '0 0 * * * ?';
        system.schedule('testAccountSnapshotBatch', cronExp, obj);

      Test.stopTest();
     }

}