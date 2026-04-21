@isTest
private class gctlTTest {
static testMethod void doTest() {
Test.startTest();
  testData.init();
        g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Student', 'test1', 'India');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Student', 'test12', 'India');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment');
            //----------------------------------------
            gctlT obj=new gctlT(new ApexPages.StandardController(T));
            obj.save();obj.cancel();obj.rq=r;
            obj.createFeedItem('test');
Test.stopTest();
}
}