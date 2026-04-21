@isTest
private class gctlReqStatusTest {
    @testSetup
    static void setup() {/*MS*/
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

        g_Req__c req=[SELECT id, STA__c, Acc__c, srvc__r.sdg__c FROM g_Req__c limit 1 ];
        req.xai__c='eci;la:Local Amendment;eci;';
        req.xsi__c='ic;';
        req.STA__c='In Process';
        update req;
        g_reqitem__c ritm = [select id from g_reqitem__c limit 1];
        g_Srvc__c srv = [select id, Milestone_Stage__c from g_Srvc__c limit 1];
        srv.Milestone_Stage__c = 'GEN:General;';
        update srv;
        g_Milestone__c objMilestone = new g_Milestone__c();
        objMilestone.Request__c = req.id;
        insert objMilestone;
        Test.startTest();
            //PageReference vfpage = Page.grqstatus;
            PageReference vfpage = new PageReference('/apex/grqstatus');
            vfpage.getParameters().put('id', req.Id);
               vfpage.getParameters().put('itmCd', 'ai');
            Test.setCurrentPage(vfpage);
            ApexPages.StandardController sc = new ApexPages.StandardController(req);
            gctlReqStatus obj = new gctlReqStatus(sc);
            obj.CancelR();
            Apexpages.currentPage().getParameters().put('itmId', ritm.id);
            obj.editItem();

            /*obj.removeExpItm();
            obj.updateAdhocItems();
            obj.removeAdhocItems();*/
            obj.nextPg();
            boolean flg = obj.nD;
            boolean flg1 = obj.nDGrP;
            boolean flg2 = obj.nP;
        obj.CancelR();
        obj.submitCorrection();
        obj.updateItemSTA();
        obj.cancelPayment();

        obj.upsertR('Open');
        obj.cancelItms();
        obj.updateAdhocItems();
        obj.removeAdhocItems();

        obj.invokeCourier();
        obj.addExpItm();
        obj.removeExpItm();

        obj.strDate('12/06/2019');
        obj.licCopy=obj.licCopy;

        Test.stopTest();
    }
}