@isTest
private class BatchCourBookingTest {
    static testmethod void test1() {
         testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
          g_Req__c r=testData.reqCrt(a.Id, s.Id, sp.Id, 'Open', stg.reqq__c);
        List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where     srvc__r.Name='Srvc' LIMIT 1];
        system.debug('srvitm=='+srvitm);
        List<g_srvcitm_Status__c> stng = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' LIMIT 1];
        system.debug('stng1=='+stng);
         g_reqitem__c rqitem = new g_reqitem__c(Name='test', RQ__c=r.Id, itm__c=srvitm[0].Id, sta__c=stng[0].Id);
        insert rqitem;
        List<ws_call__c> wsList = new List<ws_call__c>();
for (Integer i=0;i<1;i++) {
ws_call__c m = new ws_call__c(rq_itm__c=rqitem.Id, rq_jsn__c='test', ws_typ__c ='Courier Booking', mtd_nm__c='Courier Booking', intsts__c ='Ready for Integration');
wsList.add(m);
}
insert wsList;
       Test.startTest();
BatchCourBooking c = new BatchCourBooking();
Database.executeBatch(c);
Test.stopTest();

    }
}