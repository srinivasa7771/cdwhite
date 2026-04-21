@isTest
private class scheduledCancelRequestTest {
   static testMethod void doTest() {
        test.startTest();
          String CRON_EXP = '0 0 0 3 9 ? 2090';
            scheduledCancelRequest ctrl = new scheduledCancelRequest();
            system.schedule('test job', CRON_EXP, ctrl);
        test.stopTest();
    }
}