@isTest
private class gctlTopTest {
    @testSetup
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        stg.payq__c = 'Select xcnc__c, Id, Name, STA__c, AT__c, AP__c, AOP__c, dsc__c, dsc__r.prct__c, spCh__c, rmob__c, xaloc__c, xbrnd__c, xbn__c, nt__c, xfpc__c, srvc__c, srvc__r.name, srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, srvc__r.ckgsnc__c, srvc__r.stg__r.payq__c, srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.pstg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c, srvc__r.payMd__c, Acc__r.Name, Acc__r.lc__c, Acc__c, Acc__r.Type, Acc__r.bgrfi__c, Acc__r.adrfi__c, Acc__r.Prk__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bg__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Acc__r.vestd__c, Acc__r.vbtemp__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, Item_Count__c, srvc__r.kstp__c,  Acc__r.adb__c, Acc__r.bgb__c, Acc__r.bgnr__c, xtpa__c, srvc__r.uid__c, xltr__c, (Select Id, Name From reqMbrs__r where isDeleted=false), (Select Id, Name, mxAts__c, mnAts__c, ats__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id, Name, STA__c, dt__c, A__c, md__c, TP__c From Transactions__r where isDeleted=false), (select id, Name, RQ__c, nc__c, rv__c, m__c, m__r.Name, vSTA__c, AP__c, AD__c, AOP__c, nt__c, xprnt__c, xr__c, Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c, sta__r.Courier_Stage__c, xcawb__c, xcnopro__c , xcub__c , xcco__c, xcasc__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, AV__c, su__c, vsu__c, TAX_CODE__c, extc__c, TAXCODE_SC__c, extcsc__c, vsc__c, vesch__c, vst__c, vec__c, ngs__c, ngsXP__c, tvatp__c, tgop__c, tngop__c, tgovp__c, tvngp__c From Items__r where IsDeleted=false order by itm__r.ord__c), Zone__c, Full_Name__c, CreatedBy.Name , srvc__r.Category__c, xadh__c, xcmob__c , xceml__c From g_Req__c';
        update stg;
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
    }
    static testMethod void doTest() {
        g_Req__c req =[SELECT ID, xtpa__c FROM g_Req__c LIMIT 1];
        req.xtpa__c = 2500;
        update req;
        Account acc= [SELECT id From Account limit 1];
        g_Tran__c tran = new g_Tran__c();
        tran.Acc__c= acc.id;
        tran.md__c = 'Cash';
        tran.RQ__c = req.id;
        insert tran;
        Test.startTest();
        //PageReference vfpage = Page.nrtacc;
        PageReference vfpage = new PageReference('/apex/nrtacc');
        vfpage.getParameters().put('id', req.Id);
        vfpage.getParameters().put('sid', 'xxx');
        vfpage.getParameters().put('ref', 'xxx');
        Test.setCurrentPage(vfpage);
        apexpages.currentpage().getparameters().put('id', req.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(req);

        gctlTop obj = new  gctlTop(sc);
        obj.Chk();
        obj.fetchRQ(req.id);
        obj.editModeRq();

        boolean flg1 = obj.nd;
        obj.rqid = req.id;
        obj.save();
        obj.saveReq();
        obj.CnclPayment();
        obj.authenticateUser();
        obj.getCurrentUrl();
        obj.crtPayCard();
        obj.fetchPreTransaction();
        obj.selectedPT();

        gctlTop.PaymentRes res = new gctlTop.PaymentRes();
        gctlTop.msg msgobj = new gctlTop.msg('', '', '');
        //obj.getPaymentResponse();
        //obj.getJsonResponse2();

        //obj.T=tran;
        Test.stopTest();
    }
    static testMethod void doTestRefIdNull() {
        g_Req__c req =[SELECT ID FROM g_Req__c LIMIT 1];
        Account acc= [SELECT id From Account limit 1];
        Test.startTest();
        //PageReference vfpage = Page.nrtacc;
        PageReference vfpage = new PageReference('/apex/nrtacc');
        vfpage.getParameters().put('id', req.Id);
        vfpage.getParameters().put('sid', 'xxx');
        vfpage.getParameters().put('m', 'e');
        Test.setCurrentPage(vfpage);
        ApexPages.StandardController sc = new ApexPages.StandardController(req);
        gctlTop obj = new  gctlTop(sc);
        obj.Chk();
        //obj.T=tran;
        Test.stopTest();
    }

}