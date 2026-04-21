@isTest
private class gctlRQ1Test {
    @testSetup
    static void setup() {
        gStg__c setting = new gStg__c();
        setting.Name = 'enableOCR';
        setting.Text_Value__c = 'Passport First Page;New Passport Copy - First Page;Passport - first page;';
        insert setting;
        gStg__c setting1 = new gStg__c();
        setting1.Name = 'OptionsDocs';
        setting1.Text_Value__c = 'Passport First Page;New Passport Copy - First Page;Passport - first page;';
        insert setting1;

        testData.init();
        User usr = testData.createportalUser('test');
        insert usr;

        List<user> ulist = [select contactid from user where id=:usr.id LIMIT 1];
        List<Contact> conList = [select accountid from contact where id=:ulist[0].contactid LIMIT 1];
        conList[0].xped__c =Date.newInstance(2023, 12, 9);
        conList[0].rp__c ='1123123123';
        conList[0].rol__c ='Employee';
        update conList;
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Contact emp=testData.conCrt(null, conList[0].accountId, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(conList[0].accountId, s.Id, conList[0].Id, 'Open', stg.reqq__c);
    }

    static testmethod void test() {

        List<user> ulist = [select id from user where Email='portaluser@testorg.com' LIMIT 1];
        Test.startTest();
        g_srvc_definition__c srvDef = new g_srvc_definition__c();
        srvdef.ptype__c= 'normal:10 Days;express:3 Days;';
        srvDef.docslbl__c='Passport First Page:Passport - first page;Passport Last Page:Passport - last page;Personal Photo:Recent passport size photo;Tenancy Contract (Ejari attested):Tenancy Contract (Ejari attested);Attested Marriage Certificate:Attested Marriage Certificate;Sponsor Passport First Page:Sponsor Passport First Page;Sponsor Passport Last Page:Sponsor Passport Last Page;Sponsor Visa Copy:Sponsor Visa Copy;Electricity and water bill:Electricity and water bill;';
        srvDef.srvtdocs__c='Passport First Page:Passport First Page;Passport Last Page:Passport Last Page;Personal Photo:Personal Photo;Tenancy Contract (Ejari attested):Tenancy Contract (Ejari attested);Electricity and water bill:Electricity and water bill;Attested Birth Certificate:Attested Birth Certificate;Mother Passport First Page:Mother Passport First Page;Mother Passport Last Page:Mother Passport Last Page;Mother Visa Copy:Mother Visa Copy;Sponsor Passport First Page:Sponsor Passport First Page;Sponsor Passport Last Page:Sponsor Passport Last Page;Sponsor Visa Copy:Sponsor Visa Copy;';
        srvDef.srvdocs__c ='Passport First Page:Passport - first page;Passport Last Page:Passport - last page;Personal Photo:Recent passport size photo;Tenancy Contract (Ejari attested):Tenancy Contract (Ejari attested);Attested Marriage Certificate:Attested Marriage Certificate;Sponsor Passport First Page:Sponsor Passport First Page;Sponsor Passport Last Page:Sponsor Passport Last Page;Sponsor Visa Copy:Sponsor Visa Copy;Electricity and water bill:Electricity and water bill;';
        //srvDef.pyChk__c=true;
        insert srvDef;
        g_Srvc__c srv =[SELECT name from g_Srvc__c LIMIT 1];
        srv.sdg__c = srvDef.id;
        srv.uid__c='058';
        srv.Sub_Category__c ='Renewals';
        update  srv;

        g_Req__c req =[Select id from g_Req__c  limit 1];
        req.xaed__c =Date.newInstance(2023, 12, 9);
        req.xceidedt__c =Date.newInstance(2023, 12, 9);
        req.e__c='1123123123';
        req.xadh__c='ins;';
        update req;

        List<g_reqitem__c> rqItemList = [SELECT id FROM g_reqitem__c where RQ__c =:req.id];

        g_reqDoc__c rqDoc = new g_reqDoc__c();
        rqDoc.Name='test';
        rqDoc.ats__c =5;
        rqDoc.RQ__c = req.id;
        //rqDoc.nmReq__c =2;
        //rqdoc.anmReqAts__c =2;
        rqdoc.ats__c =4;
        //rqdoc.mnAts__c=4;
        //rqdoc.Req__c= true;
        //rqdoc.reqAts__c= true;
        //rqdoc.upOk__c= true;
        insert rqDoc;

        g_reqitemDoc__c rqItemDoc  = new g_reqitemDoc__c();
        rqItemDoc.Name ='test';
        rqItemDoc.lbl__c ='test';
        rqItemDoc.mxAts__c =0;
        rqItemDoc.mnAts__c =0;
        rqItemDoc.reqItm__c =rqItemList[0].id;
        rqItemDoc.reqDoc__c =rqDoc.id;
        insert rqItemDoc;

        system.runAs(ulist[0]) {
            //PageReference vfpage = Page.grqstatus;
            /*PageReference vfpage = new PageReference('/apex/grqstatus');
            vfpage.getParameters().put('sid', srvDef.id);
            vfpage.getParameters().put('vt', 'b');
            vfpage.getParameters().put('insurancereq', 'true');
            vfpage.getParameters().put('attId', rqItemDoc.id);
            Test.setCurrentPage(vfpage);*/
            ApexPages.CurrentPage().getParameters().put('sid', srvDef.id);
            gctlRQ1  obj = new gctlRQ1();
            obj.redirectService();
            obj.loadData(req.id);
            obj.saveRequestInfo();
            obj.saveApplicantInfo();
            obj.validateVisa();
            obj.saveDraft();
            obj.saveDraft1();
            obj.deleteAttach();
            Test.stopTest();
        }

    }
    static testmethod void testvtBlank() {
        List<Contact> conList = [select accountid from contact LIMIT 1];
        conList[0].rol__c='Spouse';
        update conList;

        List<user> ulist = [select id from user where Email='portaluser@testorg.com' LIMIT 1];
        Test.startTest();
        g_srvc_definition__c srvDef = new g_srvc_definition__c();
        srvdef.ptype__c= 'normal:10 Days;express:3 Days;';
        srvDef.docslbl__c='Passport First Page:Passport - first page;Passport Last Page:Passport - last page;Personal Photo:Recent passport size photo;Tenancy Contract (Ejari attested):Tenancy Contract (Ejari attested);Attested Marriage Certificate:Attested Marriage Certificate;Sponsor Passport First Page:Sponsor Passport First Page;Sponsor Passport Last Page:Sponsor Passport Last Page;Sponsor Visa Copy:Sponsor Visa Copy;Electricity and water bill:Electricity and water bill;';
        srvDef.srvtdocs__c='Passport First Page:Passport First Page;Passport Last Page:Passport Last Page;Personal Photo:Personal Photo;Tenancy Contract (Ejari attested):Tenancy Contract (Ejari attested);Electricity and water bill:Electricity and water bill;Attested Birth Certificate:Attested Birth Certificate;Mother Passport First Page:Mother Passport First Page;Mother Passport Last Page:Mother Passport Last Page;Mother Visa Copy:Mother Visa Copy;Sponsor Passport First Page:Sponsor Passport First Page;Sponsor Passport Last Page:Sponsor Passport Last Page;Sponsor Visa Copy:Sponsor Visa Copy;';
        srvDef.srvdocs__c ='Passport First Page:Passport - first page;Passport Last Page:Passport - last page;Personal Photo:Recent passport size photo;Tenancy Contract (Ejari attested):Tenancy Contract (Ejari attested);Attested Marriage Certificate:Attested Marriage Certificate;Sponsor Passport First Page:Sponsor Passport First Page;Sponsor Passport Last Page:Sponsor Passport Last Page;Sponsor Visa Copy:Sponsor Visa Copy;Electricity and water bill:Electricity and water bill;';
        srvDef.pyChk__c=true;
        insert srvDef;
        g_Srvc__c srv =[SELECT name from g_Srvc__c LIMIT 1];
        srv.sdg__c = srvDef.id;
        srv.uid__c='058';
        srv.Sub_Category__c ='Renewals';
        update  srv;

        g_Req__c req =[Select id from g_Req__c  limit 1];
        req.xaed__c =Date.newInstance(2023, 12, 9);
        req.xceidedt__c =Date.newInstance(2023, 12, 9);
        req.e__c='1123123123';
        req.xadh__c='ins;';
        req.xcspb__c='Parent Company';
        update req;

        List<g_reqitem__c> rqItemList = [SELECT id FROM g_reqitem__c where RQ__c =:req.id];

        g_reqDoc__c rqDoc = new g_reqDoc__c();
        rqDoc.Name='test';
        rqDoc.ats__c =5;
        rqDoc.RQ__c = req.id;
        //rqDoc.nmReq__c =2;
        //rqdoc.anmReqAts__c =2;
        rqdoc.ats__c =4;
        //rqdoc.mnAts__c=4;
        //rqdoc.Req__c= true;
        //rqdoc.reqAts__c= true;
        //rqdoc.upOk__c= true;
        insert rqDoc;

        g_reqitemDoc__c rqItemDoc  = new g_reqitemDoc__c();
        rqItemDoc.Name ='test';
        rqItemDoc.lbl__c ='test';
        rqItemDoc.mxAts__c =0;
        rqItemDoc.mnAts__c =0;
        rqItemDoc.reqItm__c =rqItemList[0].id;
        rqItemDoc.reqDoc__c =rqDoc.id;
        insert rqItemDoc;

        system.runAs(ulist[0]) {
            //PageReference vfpage = Page.grqstatus;
            /*PageReference vfpage = new PageReference('/apex/grqstatus');
            vfpage.getParameters().put('sid', srvDef.id);
            vfpage.getParameters().put('vt', '');
            vfpage.getParameters().put('insurancereq', 'false');
            vfpage.getParameters().put('attId', rqItemDoc.id);
            Test.setCurrentPage(vfpage);*/
            ApexPages.CurrentPage().getParameters().put('sid', srvDef.id);
            gctlRQ1  obj = new gctlRQ1();
            obj.A=obj.A;
obj.infoDocLst=obj.infoDocLst;
obj.imageBase64=obj.imageBase64;
obj.docName=obj.docName;
obj.imageBase64=obj.imageBase64;
obj.ispu=obj.ispu;
obj.isNew=obj.isNew;
obj.err=obj.err;
            obj.docName='test';
            obj.redirectService();
            obj.loadData(req.id);
            obj.saveRequestInfo();
            obj.saveApplicantInfo();
            obj.validateVisa();
            obj.saveDraft();
            obj.saveDraft1();
            obj.deleteAttach();
            obj.nextPage();
            obj.fetchDependentInfo();
            obj.updateAdhocItems();
            obj.saveAttachment();
            Test.stopTest();
        }
    }
}