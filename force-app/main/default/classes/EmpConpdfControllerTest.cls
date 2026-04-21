@isTest
private class EmpConpdfControllerTest {
  static testMethod void doTest() {
       testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        req.cldt__c = date.today();
        update req;
        test.startTest();
         apexpages.currentpage().getparameters().put('id', req.id);
          EmpConpdfController obj = new EmpConpdfController();
          system.assert(obj.doj != null);
        test.stopTest();
    }
    static testMethod void doTest1() {
       testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        emp.jd__c = Date.today();
        update emp;
        test.startTest();
         apexpages.currentpage().getparameters().put('id', req.id);
          EmpConpdfController obj = new EmpConpdfController();
           system.assert(obj.doj != null);
        test.stopTest();
    }
    static testMethod void doTest2() {
       testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);

        test.startTest();
         apexpages.currentpage().getparameters().put('id', req.id);
         g_srvcitm__c si = [select id, cd__c from g_srvcitm__c where cd__c ='ci'];
         si.cd__c = 'ai';
         update si;
          EmpConpdfController obj = new EmpConpdfController();
           system.assert(obj.othAllowances != null);
        test.stopTest();
    }
}