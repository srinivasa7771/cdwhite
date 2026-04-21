@isTest
private class gctlReq1Test {
      @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
    }
    static testmethod void loadDataIdNotNull() {
        g_Srvc__c srv =[SELECT id, (select id from Items__r limit 1) FROM g_Srvc__c LIMIT 1];
        system.debug('srv::::::'+srv);
        g_srvcitm__c srvItem =srv.Items__r;
        /*g_srvcitm_Doc__c srvItmdocs= new g_srvcitm_Doc__c(Name='test', lbl__c='test', Tp__c='Cancellation Document',
                                                          mnAts__c=0, mxAts__c=0, itm__c=srvItem.id);
        insert srvItmdocs;
        system.debug('srvItmdocs:::'+srvItmdocs.id);*/

        g_Req__c req=[SELECT id, STA__c, Acc__c  FROM g_Req__c limit 1 ];
        Account acc = [SELECT id FROM Account limit 1];
        req.Acc__c =acc.id;
        req.srvc__C=srv.id;
        update req;
        Test.startTest();
            //PageReference vfpage = Page.nrtacc;
            PageReference vfpage = new PageReference('/apex/nrtacc');
            vfpage.getParameters().put('id', req.Id);
            vfpage.getParameters().put('sid', 'xxx');
            vfpage.getParameters().put('pid', 'xxx');
            Test.setCurrentPage(vfpage);
            ApexPages.StandardController sc = new ApexPages.StandardController(req);
            gctlReq1 obj = new gctlReq1(sc);
            obj.saveDraft();
            srv.uid__c ='tad';
            update srv;
            obj.saveOpen();
            //obj.fetchPreTransaction();
            obj.save();
            obj.authenticateUser();
            obj.loadDpdtSec();
            gctlReq1.DEG_Checksum('11', '121');

        Test.stopTest();
    }
    static testmethod void loadDataIdNull() {
        g_Srvc__c srv =[SELECT id, (select id from Items__r limit 1) FROM g_Srvc__c LIMIT 1];
        system.debug('srv::::::'+srv);
        g_srvcitm__c srvItem =srv.Items__r;
        /*g_srvcitm_Doc__c srvItmdocs= new g_srvcitm_Doc__c(Name='test', lbl__c='test', Tp__c='Cancellation Document',
                                                          mnAts__c=0, mxAts__c=0, itm__c=srvItem.id);
        insert srvItmdocs;
        system.debug('srvItmdocs:::'+srvItmdocs.id);*/
        g_Req__c req=new g_Req__c();

        Test.startTest();
            //PageReference vfpage = Page.nrtacc;
            PageReference vfpage = new PageReference('/apex/nrtacc');
            vfpage.getParameters().put('id', '');
            vfpage.getParameters().put('sid', 'xxx');
            vfpage.getParameters().put('pid', 'xxx');
            vfpage.getParameters().put('rc', 'xxx');
            vfpage.getParameters().put('cn', 'xxx');
            Test.setCurrentPage(vfpage);
            ApexPages.StandardController sc = new ApexPages.StandardController(req);
            gctlReq1 obj = new gctlReq1(sc);
            gctlReq1 obj1 =  new gctlReq1();
            //obj.saveDraft();
            //obj.saveOpen();
            //obj.fetchPreTransaction();
            //obj.save();
            //obj.dsgu();
            //gctlReq1.DEG_Checksum('', '');
        Test.stopTest();
    }
}