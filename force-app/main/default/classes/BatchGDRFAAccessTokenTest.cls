@isTest
Private class BatchGDRFAAccessTokenTest {
  @isTest static void testGDRFATOKEN() {
       Test.startTest();
        Database.executeBatch(new BatchGDRFAAccessToken());
        Test.stopTest();
    }

}