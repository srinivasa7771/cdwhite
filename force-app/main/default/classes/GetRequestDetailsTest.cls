@isTest
private class GetRequestDetailsTest {
    static testmethod void test1() {
        testData.init();
        testData.triggersetting('RequestDiscountTrigger', true);
        Account a=testData.accCrt(false);
         Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
         testData.bRulesReqCrt();testData.bRulesItemCrt();
         Request_Discounti__c rd=new Request_Discounti__c(Name='test', Status__c='Draft');
         insert rd;
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        List<g_reqitem__c> ritm = [select id, RQ__c, cXP__c, cN__c, scXP__c, scN__c, AV__c from g_reqitem__c where RQ__c=:r.Id LIMIT 1];
        system.debug('ritm'+ritm);
        Test.startTest();
        ApexPages.StandardController setCon = new ApexPages.StandardController(ritm[0]);
        GetRequestDetails grd = new GetRequestDetails(setCon);
        grd.notevalue='test';
        grd.bodyvalue=Blob.valueOf('test');
        g_reqitem__c git = new g_reqitem__c(id=ritm[0].id, scXP__c=20.0);
        update git;
        List<g_reqitem__c> requp=[select id, RQ__c, cXP__c, cN__c, scXP__c, scN__c, AV__c from g_reqitem__c where Id=:git.Id LIMIT 1];
        grd.searchDetails();
        grd.getSelected();
        GetRequestDetails.selectedRecDetails wrapObj1  = new GetRequestDetails.selectedRecDetails(String.Valueof(ritm[0].Id),
            '', '', '', '', '12345', system.today(), 0.0, 0.0, 0.0, 0.0, 200.0, 200.0, 200.0,
            200.0, 200.0);
        grd.navigateConfirmDetails();
        GetRequestDetails.noteWrapper wrapObj  = new GetRequestDetails.noteWrapper(String.Valueof(ritm[0].Id),
            '', '', '', '', '12345', system.today(), 0.0, 0.0, 0.0, 0.0, 200.0, 200.0, 200.0,
            200.0, 200.0, 'test', Blob.valueOf('test'));
        grd.noteWrapperlst.add(wrapObj);
        grd.navigatePrev();
        grd.submitforapproval();
        Test.stopTest();
    }
}