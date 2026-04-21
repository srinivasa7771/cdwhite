@isTest
private class gctlAdPDFTest {
    static testMethod void doTest() {
        boolean blV;String sV;decimal dV;
           Test.startTest();
               testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();
            //----------------------------------------
            gctlAdPDF.Trn t = new gctlAdPDF.Trn(new g_Tran__c());
            t.T=t.T;
            t.isCrdt=t.isCrdt;
            dV=t.cd;
            dV=t.db;
            gctlAdPDF obj=new gctlAdPDF(new ApexPages.StandardController(a));obj.gAD();obj.gBG();obj.gCC();
            ApexPages.CurrentPage().getParameters().put('p', 'THIS_MONTH');
            ApexPages.CurrentPage().getParameters().put('n', '2');
            obj=new gctlAdPDF(new ApexPages.StandardController(a));obj.gAD();
            ApexPages.CurrentPage().getParameters().put('p', 'LAST_MONTH');
            ApexPages.CurrentPage().getParameters().put('n', '2');
            obj=new gctlAdPDF(new ApexPages.StandardController(a));obj.gAD();
            ApexPages.CurrentPage().getParameters().put('p', 'THIS_QUARTER');
            ApexPages.CurrentPage().getParameters().put('n', '2');
            obj=new gctlAdPDF(new ApexPages.StandardController(a));obj.gAD();
            ApexPages.CurrentPage().getParameters().put('p', 'LAST_N_QUARTERS');
            ApexPages.CurrentPage().getParameters().put('n', '2');
            obj=new gctlAdPDF(new ApexPages.StandardController(a));obj.gAD();
            ApexPages.CurrentPage().getParameters().put('p', 'THIS_YEAR');
            ApexPages.CurrentPage().getParameters().put('n', '2');
            obj=new gctlAdPDF(new ApexPages.StandardController(a));obj.gAD();
            ApexPages.CurrentPage().getParameters().put('p', 'LAST_N_YEARS');
            ApexPages.CurrentPage().getParameters().put('n', '2');
            obj=new gctlAdPDF(new ApexPages.StandardController(a));obj.gAD();
           Test.stopTest();
    }
}