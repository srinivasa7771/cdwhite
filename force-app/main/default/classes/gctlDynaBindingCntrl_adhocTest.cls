@isTest
private class gctlDynaBindingCntrl_adhocTest {

    @testSetup
    static void setup() {
        testData.init();

        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
    }
    static testmethod void test() {
         Test.startTest();
        g_Req__c req=[SELECT id, STA__c, Acc__c, srvc__r.sdg__c FROM g_Req__c limit 1 ];
        req.xai__c='eci;la:Local Amendment;eci;';
        req.xsi__c='ic;';
        req.STA__c='In Process';
        update req;

                ApexPages.CurrentPage().getParameters().put('id', req.id);
        gctlDynaBindingCntrl_adhoc d=new gctlDynaBindingCntrl_adhoc();

          Test.stopTest();
    }
}