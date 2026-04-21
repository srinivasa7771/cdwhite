@isTest
private class scheduledDSGRecTest {
   static testMethod void doTest() {
        test.startTest();
          String CRON_EXP = '0 0 0 3 9 ? 2090';
            scheduledDSGRec ctrl = new scheduledDSGRec();
            system.schedule('test job', CRON_EXP, ctrl);
        test.stopTest();
    }
}