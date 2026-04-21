@isTest
private class gctlqrlstrTest {

    static testmethod void testGctlqrlstr() {
      Test.startTest();
            testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);

           gctlqrlstr ctrl = new gctlqrlstr();
           ctrl.rq = r;
           ctrl.getRqtrans();
           ctrl.getStahis();
           ctrl.getCstahis();

      Test.stopTest();
    }

}