@isTest
private class gctlUsersTest {
    static testMethod void doTest() {
       Test.startTest();
         testData.init();
        g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a1=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a1.Id, 'Active', 'Employee', 'User1', 'Egypt');
            Contact emp=testData.conCrt(sp, a1.Id, 'Active', 'Employee', 'User2', 'Egypt');
        //----------------------------------------
        gctlUsers obj = new gctlUsers();obj.save();obj.enUser();obj.dsbUser();
       Test.stopTest();
  }
}