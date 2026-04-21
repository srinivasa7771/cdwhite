@isTest
private class gctlRQTest {
    static testMethod void doTest() {
           Test.startTest();
               testData.init();/*MS*/

            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();
            //----------------------------------------
            gctlRQ obj = new gctlRQ();obj.nP();obj.vP();obj.eP();
          obj.empid=obj.empid; obj.encid=obj.encid; obj.pid=obj.pid;
         obj.iid=obj.iid; obj.isgu=obj.isgu; obj.Test=obj.Test;
        obj.cn=obj.cn; obj.sid=obj.sid;
         obj.getSrvc('001');
            obj=new gctlRQ(new ApexPages.StandardController(r));obj.vP();
        ApexPages.CurrentPage().getParameters().put('md', 'n');
            ApexPages.CurrentPage().getParameters().put('sid', s.Id);
        obj = new gctlRQ();obj.nP();
            ApexPages.CurrentPage().getParameters().put('c', s.uid__c);
        obj = new gctlRQ();obj.nP();

        Test.stopTest();
    }
}