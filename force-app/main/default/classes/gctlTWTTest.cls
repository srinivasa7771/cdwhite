@isTest
private class gctlTWTTest {
static testMethod void doTest() {
    Test.startTest();
     testData.init();
        g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Student', 'test1', 'India');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Student', 'test12', 'India');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
          List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where     srvc__r.Name='Srvc' LIMIT 1];
          List<g_srvcitm_Status__c> stng1 = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' and Milestone__c='EP' LIMIT 1];
         g_reqitem__c rqitem = new g_reqitem__c(Name='test', RQ__c=r.Id, itm__c=srvitm[0].Id, sta__c=stng1[0].Id);
        insert rqitem;
            g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment');
            insert T;
            gctlTWT obj=new gctlTWT(new ApexPages.StandardController(T));
           obj.nt= 'test';
            obj.crtTran();
    Test.stopTest();
}
}