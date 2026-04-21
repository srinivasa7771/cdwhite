@istest private class gUtest{
    static TestMethod void doTest() {
        Test.startTest();
        boolean blV;String sV;
        gU.pgMode md=new gU.pgMode();blV=md.IsNew;blV=md.isEdit;blV=md.isView;md.setNew();md.setEdit();md.setView();md.getPgParam();
        try{Integer x=0;x=x/x;}catch (Exception ex){gU.AddErrorMsg(ex);}gU.AddErrorMsg('test');gU.AddInfoMsg('test');gU.AddSuccessMsg('test');gU.AddWarningMsg('test');
        blV=gU.IdsEqual(null,null);blV=gU.IdsEqual('123456781234567',null);blV=gU.IdsEqual('123456781234567','123456781234567');blV=gU.IdsEqual('123456781234567','876543217654321');
        gU.ValueIsNull(null);gU.ValueIsNull('Some Value');

        gStg__c stg1 = new gStg__c();
        stg1.name = 'PSPID';
        stg1.Checkbox_Value__c = true;
        stg1.Currency_Value__c = 12;
        stg1.Number_Value__c = 43;
        stg1.Text_Value__c = 'tecomnew';
        insert stg1;

        gStg__c stg2 = new gStg__c();
        stg2.name = 'SHAPASS';
        stg2.Checkbox_Value__c = true;
        stg2.Currency_Value__c = 12;
        stg2.Number_Value__c = 43;
        stg2.Text_Value__c = 'P@ssw0rd12345678';
        insert stg2;

        list<gStg__c> stgs=new list<gStg__c>();
        stgs.add(new gStg__c(Name='test',Checkbox_Value__c=true,Text_Value__c='test',Number_Value__c=1,Currency_Value__c=1));
        stgs.add(new gStg__c(Name='gpPrfls',Checkbox_Value__c=true,Text_Value__c='00e20000001mIim;00e20000001mIis',Number_Value__c=1,Currency_Value__c=1));
        stgs.add(new gStg__c(Name='grucall',Checkbox_Value__c=true,Text_Value__c='00e20000001mIim;00e20000001mIis',Number_Value__c=1,Currency_Value__c=1));
        stgs.add(new gStg__c(Name='gpSU',Checkbox_Value__c=true,Text_Value__c=UserInfo.getProfileId(),Number_Value__c=1,Currency_Value__c=1));
        stgs.add(new gStg__c(Name='gwChnl',Checkbox_Value__c=true,Text_Value__c='gwChnl',Number_Value__c=1,Currency_Value__c=1));
        stgs.add(new gStg__c(Name='gwsc',Checkbox_Value__c=true,Text_Value__c='gwsc',Number_Value__c=1,Currency_Value__c=1));
        stgs.add(new gStg__c(Name='gwspc',Checkbox_Value__c=true,Text_Value__c='gwspc',Number_Value__c=1,Currency_Value__c=1));
        stgs.add(new gStg__c(Name='gwvc',Checkbox_Value__c=true,Text_Value__c='gwvc',Number_Value__c=1,Currency_Value__c=1));
        stgs.add(new gStg__c(Name='gwURL',Checkbox_Value__c=true,Text_Value__c='gwURL',Number_Value__c=1,Currency_Value__c=1));
        stgs.add(new gStg__c(Name='gwKy',Checkbox_Value__c=true,Text_Value__c='gwKy',Number_Value__c=1,Currency_Value__c=1));
        stgs.add(new gStg__c(Name='isFmUser',Checkbox_Value__c=true,Text_Value__c='00e0I000001l2IE;',Number_Value__c=1,Currency_Value__c=1));
        SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.CREATABLE, stgs);
        insert secDec.getRecords();
        g_srvc_settings__c sStg=new g_srvc_settings__c(name='test',pg__c='gpPrfls');insert sStg;list<g_Srvc__c> srvcs=new list<g_Srvc__c>();srvcs.add(new g_Srvc__c(actv__c=true,AccTp__c='Tp1',uid__c='id1',stg__c=sStg.Id));srvcs.add(new g_Srvc__c(actv__c=false,AccTp__c='Tp2',uid__c='id2',stg__c=sStg.Id));insert srvcs;
        list<g_srvcAL__c> acl=new list<g_srvcAL__c>();acl.add(new g_srvcAL__c(DE__c=true,AP__c=true,srvc__c=srvcs[0].Id,usr__c=UserInfo.getUserId()));insert acl;
        gU.csBool('test');gU.csStr('test');gU.csNum('test');gU.csCurr('test');
        gU.isPortalUser('00e20000001mIim');gU.isPortalUser('00e20000001mIit');gU.isPortalSuperUser('00e20000001mIim');
        gU.canAccess2(srvcs[0].Id,false,null);gU.checkParkingUser(UserInfo.getUserId());
        gU.canReqSrvc(srvcs[0].Id,false,'gpPrfls');gU.canReqSrvc(srvcs[0].Id,true,'gpPrfls');gU.canReqSrvc(srvcs[1].Id,false,'gpPrfls');gU.canReqSrvc(srvcs[1].Id,true,'gpPrfls');
        set<string> npS=new Set<String>{'a','b','c'}; set<Date> mpD=new Set<Date>{Date.today(),Date.today().addDays(1)};
            gU.Sort(npS);gU.Sort(mpD);
        gU.AmountInWords(-1);gU.AmountInWords(0);gU.AmountInWords(99);gU.AmountInWords(199);gU.AmountInWords(1999);gU.AmountInWords(199999);gU.AmountInWords(1999999);gU.AmountInWords(999999999);gU.AmountInWords(1000000000);gU.AmountInWords(2000000000);gU.AmountInWords(1999999999);
        gU.periodInWords(null,null);gU.periodInWords(Date.today(),Date.today());gU.periodInWords(Date.today(),Date.today().addDays(15));gU.periodInWords(Date.today(),Date.today().addDays(90));gU.periodInWords(Date.today(),Date.today().addDays(365));gU.periodInWords(Date.today(),Date.today().addDays(730));
        PageReference pageRef=(new ApexPages.StandardController(srvcs[0])).view();
        Test.setCurrentPage(pageRef);
        gU.DEG_Encrypt('MD5');gU.DEG_PrepareCall(1,'refNo');gU.DEG_Checksum('msg','hashMsg');
        sV=gU.pageURL;
        gU.checkNav();
        // gU.strDateTime('8/8/2015 10:10:10 PM');
        Cookie grqv = new Cookie('grqv','grqv',null,-1,true);
        ApexPages.currentPage().setCookies(new Cookie[]{grqv});
        gU.checkNav();
        gU.strDateTime('11/11/2020 11:11:00 PM');
        String myString = 'StringToBlob';
        Blob myBlob = Blob.valueof(myString);
        gU.converBolobToBytes(myBlob);


        Test.stopTest();
    }


    static TestMethod void doTestNew() {
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        s.uid__c ='216';
        update s;
        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test',ptype__c='Normal:10 Days;Express:3 Days;',cv__c='NewVisa',sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        Contact c = new Contact(Id=conLst[0].Id,mbs__c=5000,eidid__c='784198774283257',eidedt__c=system.today().addyears(3)); update c;
        List<g_srvc_settings__c> srvcsettings = [select id,reqq__c,docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];

        Contact emp=testData.conCrt(conLst[0],accLst[0].Id,'Active','Employee','Pass2','Egypt');
        g_Req__c r=testData.reqCrt(accLst[0].Id,srvcLst[0].Id,emp.Id,'Open',srvcsettings[0].reqq__c);
        String selectedActs = '[{"name":"Environment","segId":"a08D000000Zb70DIAR","allowed":"5","price":"15000.00","SegActivities":[{"name":"Research &amp; Development","actId":"a12D0000001YygKIAS","price":"15000.00","docs":[]}]},{"name":"Specialty Supplies","segId":"a08D000000Zb6zZIAR","allowed":"5","price":"15000.00","SegActivities":[{"name":"Research &amp; Development","actId":"a12D0000001Yyd1IAC","price":"15000.00","docs":[]}]}]';
        r.xadtx2__c = selectedActs;r.xdei__c='a1c12345678'; r.xdccaRq__c='RQ-112233'; update r;

        List<g_srvcitm__c> srvitm = [select id,cd__c from g_srvcitm__c where srvc__r.Name='Srvc' LIMIT 1];

        srvitm[0].cd__c='nl';
        update srvitm[0];
        List<g_srvcitm_Status__c> stng = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc'];
        stng[0].cd__c='v';
        stng[0].isfn__c=true;
        update stng[0];
        List<g_reqitem__c> items = [select id from g_reqitem__c];

        Courier_Status__c cStat = new Courier_Status__c(srvitm__c=srvitm[0].Id, curSTA__c=stng[0].Id, itmSTA__c=stng[0].Id, Courier_Status__c='Courier Initiated');
        insert cStat;

        g_reqDoc__c rdoc= new g_reqDoc__c(Name='Valid Passport Copy',RQ__c=r.Id,ats__c=1);
        insert rdoc;
        Attachment att = new Attachment(name='Valid Passport Copy',parentId=rdoc.Id, body= Blob.valueOf('TEST'));
        insert att;
        rdoc.dda_att__c=att.id;
        update rdoc;
        g_Tran__c T = new g_Tran__c(Acc__c=accLst[0].Id,RQ__c=r.Id,dt__c=system.today(),TP__c='Payment',STA__c='Completed',md__c='Credit / Debit Card');
        insert T;
        List<g_TranItem__c> TIs = new List<g_TranItem__c>();
        ws_call__c wc1 = new ws_call__c(pmid__c=att.id, adhoc_text1__c='Passport', ws_typ__c='DCCA Letters', mtd_nm__c='InvoiceCreation', intsts__c='Ready for Integration', rq_itm__c=items[0].Id,rq_jsn__c='{"AttachmentList":[{"parentId":"a1CFV0000011siS2AQ","Name":"Valid Passport Copy","messagecode":null,"message":null,"attachmentBody":null}]}');
        insert wc1;

        gU.initiateDocumentUploadOIC(r,'ddaupload','Child');
        gU.updateItemSTA(r.Id);
        gU.sendEmailOTP('UBO','test@gmail.com',r);
        UBOSubmissionCtl_2.IndvInfo infor = new UBOSubmissionCtl_2.IndvInfo();
        r.ivramsgs__c='1234';
        update r;
        gU.validateOtp('UBO',r,infor,'1234',true,r.Id);
        gU.validateOtp('UBO',r,infor,'1234',false,r.Id);

    }

}