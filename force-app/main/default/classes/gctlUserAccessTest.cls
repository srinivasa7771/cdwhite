@isTest
private class gctlUserAccessTest {
    static testMethod void doTest() {
       Test.startTest();
         testData.init();
        g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'User1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'User2', 'Egypt');

        //----------------------------------------
        gctlUserAccess obj = new gctlUserAccess();
        obj.getUsers();
        obj.save();
       Test.stopTest();
  }
}