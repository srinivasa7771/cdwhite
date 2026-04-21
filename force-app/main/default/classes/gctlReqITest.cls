@isTest
private class gctlReqITest {
    static testMethod void doTest() {
        boolean blV;String sV;
        Test.startTest();
        testData.init();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('id', '2730');
        System.currentPageReference().getParameters().put('enc', '27301111');
        gStg__c stg1 = new gStg__c();
        stg1.name = 'guprfl';
        stg1.Checkbox_Value__c = true;
        stg1.Currency_Value__c = 12;
        stg1.Number_Value__c = 43;
        stg1.Text_Value__c = '00e20000001Ak2YAAS';
        insert stg1;
        Contact c = new Contact();
        c.idtxt__c = '2730';
        c.rp__c = 'qwdqwed';
        c.lastName = 'khan';
        insert c;

        Contact c1 = new Contact();
        c1.rp__c = 'qwdqwed';
        c1.lastName = 'khan';
        c1.Spon__c = c.id;
        c1.rol__c = 'Spouse';
        insert c1;
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_reqMbr__c objM = new g_reqMbr__c();
        //-----------------------------------------------
        gctlReqI.xF xf = new gctlReqI.xf('f', true);xf.f=xf.f;xf.e=xf.e;
        s.stg__r=stg;r.srvc__r=s;
        gctlReqI obj=new gctlReqI(new ApexPages.StandardController(r));
        obj.rq=obj.rq;
        obj.pt=obj.pt;obj.pDsc=obj.pDsc;
        obj.pgHide=obj.pgHide;obj.ispu=obj.ispu;
        sV=obj.lcl;
        obj.Is=obj.Is;
        obj.optSTA=obj.optSTA;
        obj.STAs=obj.STAs;
        list<gctlReqI.xF> xFs=obj.xFs;
        sV=obj.rqJS;sV=obj.itmsJS;sV=obj.staJS;
        blV=obj.allV;blV=obj.nC;blV=obj.nD;blV=obj.nP;
        obj.save();
        obj.saveClose();
        obj.saveContinue();
        obj.nextPage();
        obj.authenticateUser();
        obj.ItemId = '';obj.AWBnumber = '';obj.msg = '';obj.stage = '';obj.itmcd = '';obj.cstatus = '';obj.ctmstp = '';
        gctlReqI.DEG_Checksum('test', 'test');
        obj.addPortalUserMessage('test, test');
        g_srvcitm__c si=[Select Id, cd__c, Name, lbl__c, Tp__c, xf__c, Req__c, rv__c, aln__c,
            mxcnt__c, dSTA__c, prcEdt__c, DscApp__c, EXP__c, KF__c, cN__c, scN__c, smN__c, spChN__c,
            cXP__c, scXP__c, smXP__c, spChXP__c, slaN__c, slaXP__c, ngs__c, ngsXP__c, vsc__c,
            vesch__c, vspc__c, vspexc__c, vst__c, vec__c, su__c, vsu__c, TAX_CODE__c, TAX_TYPE__c,
            extc__c, TAXCODE_SC__c, extcsc__c From  g_srvcitm__c where actv__c=true and IsDeleted=false and srvc__c=:s.Id order by ord__c limit 1];
        gctlReqI.itm itm = new gctlReqI.itm(obj.rq, si, null, false, 0);

        Test.stopTest();
    }
}