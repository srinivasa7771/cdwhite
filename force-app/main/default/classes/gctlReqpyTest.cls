@isTest
private class gctlReqpyTest {
    static testMethod void doTest() {
        boolean blV;String sV;
           Test.startTest();

               testData.init();
            g_srvc_settings__c stg=testData.stgCrt(); /*MS*/
            stg.payq__c = 'Select xcnc__c, Id, Name, STA__c, AT__c, AP__c, AOP__c, dsc__c, dsc__r.prct__c, spCh__c, rmob__c, xaloc__c, xbrnd__c, xbn__c, nt__c, xfpc__c, srvc__c, srvc__r.name, srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, srvc__r.ckgsnc__c, srvc__r.stg__r.payq__c, srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.pstg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c, srvc__r.payMd__c, Acc__r.Name, Acc__r.lc__c, Acc__c, Acc__r.Type, Acc__r.bgrfi__c, Acc__r.adrfi__c, Acc__r.Prk__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bg__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Acc__r.vestd__c, Acc__r.vbtemp__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, Item_Count__c, srvc__r.kstp__c,  Acc__r.adb__c, Acc__r.bgb__c, Acc__r.bgnr__c, xtpa__c, srvc__r.uid__c, xltr__c, (Select Id, Name From reqMbrs__r where isDeleted=false), (Select Id, Name, mxAts__c, mnAts__c, ats__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id, Name, STA__c, dt__c, A__c, md__c, TP__c From Transactions__r where isDeleted=false), (select id, Name, RQ__c, nc__c, rv__c, m__c, m__r.Name, vSTA__c, AP__c, AD__c, AOP__c, nt__c, xprnt__c, xr__c, Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c, sta__r.Courier_Stage__c, xcawb__c, xcnopro__c , xcub__c , xcco__c, xcasc__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, AV__c, su__c, vsu__c, TAX_CODE__c, extc__c, TAXCODE_SC__c, extcsc__c, vsc__c, vesch__c, vst__c, vec__c, ngs__c, ngsXP__c, tvatp__c, tgop__c, tngop__c, tgovp__c, tvngp__c From Items__r where IsDeleted=false order by itm__r.ord__c), Zone__c, Full_Name__c, CreatedBy.Name , srvc__r.Category__c, xadh__c, xcmob__c , xceml__c From g_Req__c';
            update stg;
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();

            gStg__c paidParking = new gStg__c(name='AdditionalParking', Text_Value__c = '154');
            insert paidParking;

            //----------------------------------------
            gctlReqpy.itm itm = new gctlReqpy.itm(r.Items__r[0]);itm.I=itm.I;itm.s=itm.s;itm.r=itm.r;
            g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment');gctlReqpy.Trn trn = new gctlReqpy.Trn(T); trn.T=trn.T;
            s.stg__r=stg;r.srvc__r=s;
            ApexPages.currentPage().getParameters().put('rc', 'y');
            ApexPages.currentPage().getParameters().put('c', 'test');
            ApexPages.currentPage().getParameters().put('id', r.id);
            gctlReqpy obj=new gctlReqpy(new ApexPages.StandardController(r)); obj.pyMthd = 'pyMthd';

            obj.rq=obj.rq;obj.pt=obj.pt;obj.pDsc=obj.pDsc;obj.pgHide=obj.pgHide;obj.ispu=obj.ispu;sV=obj.lcl;
            obj.T=obj.T;obj.Is=obj.Is;obj.pyMthds=obj.pyMthds;obj.pyMthd=obj.pyMthd;obj.pdfConfirm=obj.pdfConfirm;obj.payDone=obj.payDone;blV=obj.nD;
            obj.pyMthd='Customer Deposit';obj.save();
            obj.pyMthd='Cash';obj.save();
            obj.pyMthd='Cheque';obj.save();
            Test.setMock(HttpCalloutMock.class, new MockTokenBatchGen());
            obj.pyMthd='Credit / Debit Card';obj.save();
            obj.pyMthd='';obj.save();
            obj.CnclPayment();
            //--------------------------------------------
            gctlReqpyChk objChk = new gctlReqpyChk();
            objChk.pgHide=objChk.pgHide;objChk.ispu=objChk.ispu;sV=objChk.lcl;objChk.T=objChk.T;
            gctlReqpyChk.PaymentRes pay= new gctlReqpyChk.PaymentRes();
            pay.accessToken=pay.accessToken;
            pay.MESSAGECODE=pay.MESSAGECODE;
            pay.messageStatus=pay.messageStatus;
            pay.MESSAGE=pay.MESSAGE;
            pay.AUTHCODE=pay.AUTHCODE;
            pay.updateTime=pay.updateTime;

            objChk.Chk();
            Apexpages.currentPage().getParameters().put('SPTRN', 'SPTRN');
            Apexpages.currentPage().getParameters().put('DEGTRN', 'DEGTRN');
            Apexpages.currentPage().getParameters().put('MESSAGECODE', '00');
            Apexpages.currentPage().getParameters().put('MESSAGE', 'MESSAGE');
            Apexpages.currentPage().getParameters().put('TRANSDATE', '2000-01-01');
            Apexpages.currentPage().getParameters().put('PYMTMETHOD', 'PYMTMETHOD');
            Apexpages.currentPage().getParameters().put('ENCRYPTEDRESMSG', 'ENCRYPTEDRESMSG');
             Apexpages.currentPage().getParameters().put('ref', 'testRef');

            objChk.Chk();
           Test.stopTest();
    }
    static testMethod void doTest1() {
        boolean blV;String sV;
        testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();

            gStg__c paidParking = new gStg__c(name='AdditionalParking', Text_Value__c = '154');
            insert paidParking;
            List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where     srvc__r.Name='Srvc' LIMIT 1];
          List<g_srvcitm_Status__c> stng1 = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' and Milestone__c='EP' LIMIT 1];
         g_reqitem__c rqitem = new g_reqitem__c(Name='test', RQ__c=r.Id, itm__c=srvitm[0].Id, sta__c=stng1[0].Id);
        insert rqitem;
        g_reqDoc__c rdoc= new g_reqDoc__c(Name='test', RQ__c=r.Id, ats__c=5);
        insert rdoc;
        system.debug('rdoc----'+rdoc);
        g_reqitemDoc__c rrdocitm = new g_reqitemDoc__c(name='test', reqItm__c=rqitem.Id, reqDoc__c=rdoc.Id, mnAts__c=1);
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = rdoc.Id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        insert attachment;
           Test.startTest();

            //----------------------------------------
            gctlReqpy.itm itm = new gctlReqpy.itm(r.Items__r[0]);itm.I=itm.I;itm.s=itm.s;itm.r=itm.r;
            g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment');gctlReqpy.Trn trn = new gctlReqpy.Trn(T); trn.T=trn.T;
            s.stg__r=stg;r.srvc__r=s;
            ApexPages.currentPage().getParameters().put('rc', 'y');
            ApexPages.currentPage().getParameters().put('c', 'test');
            ApexPages.currentPage().getParameters().put('id', r.id);
            gctlReqpy obj=new gctlReqpy(new ApexPages.StandardController(r)); obj.pyMthd = 'pyMthd';
        system.debug('r---'+r);
            obj.rq=obj.rq;obj.pt=obj.pt;obj.pDsc=obj.pDsc;obj.pgHide=obj.pgHide;obj.ispu=obj.ispu;sV=obj.lcl;
            obj.T=obj.T;obj.Is=obj.Is;obj.pyMthds=obj.pyMthds;obj.pyMthd=obj.pyMthd;obj.pdfConfirm=obj.pdfConfirm;obj.payDone=obj.payDone;blV=obj.nD;

            Test.setMock(HttpCalloutMock.class, new MockTokenBatchGen());
            obj.pyMthd='Credit / Debit Card';obj.save();
            obj.pyMthd='';obj.save();
            obj.CnclPayment();
            //--------------------------------------------
            gctlReqpyChk objChk = new gctlReqpyChk();
            objChk.pgHide=objChk.pgHide;objChk.ispu=objChk.ispu;sV=objChk.lcl;objChk.T=objChk.T;
            objChk.Chk();
            Apexpages.currentPage().getParameters().put('SPTRN', 'SPTRN');
            Apexpages.currentPage().getParameters().put('DEGTRN', 'DEGTRN');
            Apexpages.currentPage().getParameters().put('MESSAGECODE', 'MESSAGECODE');
            Apexpages.currentPage().getParameters().put('MESSAGE', 'MESSAGE');
            Apexpages.currentPage().getParameters().put('TRANSDATE', '2000-01-01');
            Apexpages.currentPage().getParameters().put('PYMTMETHOD', 'PYMTMETHOD');
            Apexpages.currentPage().getParameters().put('ENCRYPTEDRESMSG', 'ENCRYPTEDRESMSG');
            objChk.Chk();
           Test.stopTest();
    }
    static testMethod void doTest2() {
        boolean blV;String sV;
        testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();

            List<gStg__c> gstgLst = new List<gStg__c>();
            gStg__c paidParking = new gStg__c(name='AdditionalParking', Text_Value__c = '154');
            gStg__c surveyid = new gStg__c(name='AXS SurveyId', Text_Value__c = '154');
            gstgLst.add(paidParking);
            gstgLst.add(surveyid);
            insert gstgLst;
          g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment', gwrf__c='testRef');
         insert T;
           Test.startTest();

            gctlReqpyChk objChk = new gctlReqpyChk();
            objChk.pgHide=objChk.pgHide;objChk.ispu=objChk.ispu;sV=objChk.lcl;objChk.T=objChk.T;
            objChk.Chk();objChk.loadData(T.id);
            Apexpages.currentPage().getParameters().put('SPTRN', 'SPTRN');
            Apexpages.currentPage().getParameters().put('DEGTRN', 'DEGTRN');
            Apexpages.currentPage().getParameters().put('MESSAGECODE', 'MESSAGECODE');
            Apexpages.currentPage().getParameters().put('MESSAGE', 'MESSAGE');
            Apexpages.currentPage().getParameters().put('TRANSDATE', '2000-01-01');
            Apexpages.currentPage().getParameters().put('PYMTMETHOD', 'PYMTMETHOD');
            Apexpages.currentPage().getParameters().put('ENCRYPTEDRESMSG', 'ENCRYPTEDRESMSG');
            Apexpages.currentPage().getParameters().put('ref', 'testRef');
            objChk.Chk();
           Test.stopTest();
    }
    static testmethod void test1() {
        testdata.init();
        User u = testData.createportalUser('testuser');
        insert u;
        system.debug('u----'+u);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
         List<g_srvc_settings__c> srvcsettings = [select id, reqq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        g_Srvc__c gs = new g_Srvc__c(id=srvcLst[0].id, uid__c='tbg');
        update gs;
        gStg__c paidParking = new gStg__c(Name='grucall', Checkbox_Value__c=true, Text_Value__c='00e20000001mIim;00e20000001mIis', Number_Value__c=1, Currency_Value__c=1);
            insert paidParking;
         List<User> ulist = [select contactid, accountId from user where Email='portaluser@testorg.com' LIMIT 1];
          List<Contact> conlst = [select accountid from contact where id=:ulist[0].contactid];
        g_Req__c r=testData.reqCrt(ulist[0].accountId, gs.Id, ulist[0].contactid, 'Open', srvcsettings[0].reqq__c);
        g_req__c req = new g_req__c(id=r.Id, xtpa__c=2500);
        update req;

            g_Tran__c T = new g_Tran__c(Acc__c=conlst[0].accountid, RQ__c=r.Id, TP__c='Payment', gwrf__c='testRef');
         insert T;

        test.startTest();
           Test.setMock(HttpCalloutMock.class, new MockTokenBatchGen());
         system.runAs(ulist[0]) {
              //PageReference myVfPage = Page.grqatt;
             PageReference myVfPage = new PageReference('/apex/grqatt');
        myVfPage.getParameters().put('id', req.Id);
        myVfPage.getParameters().put('tid', T.id);
        Test.setCurrentPage(myVfPage);
        String rid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        String tid = Apexpages.currentPage().getParameters().get('tid');
        ApexPages.StandardController setCon = new ApexPages.StandardController(req);
        gctlReqpy grpy = new gctlReqpy(setCon);
             grpy.saveReq();
             grpy.Validate();
             grpy.hasAccess();
            // grpy.crtPayCard();
             grpy.createFeedItem('test');
             grpy.CnclPayment();
             grpy.authenticateUser();
             gctlReqpy.DEG_Checksum('test', 'test');
             grpy.getJsonResponse('jstring', 'AccessToken');
             grpy.CrtPay('Open', 'Credit / Debit Card', T.Name);
             grpy.CrtPay('Open', 'Customer Deposit', T.Name);
             grpy.save();
             grpy.saveReq();

             grpy.updateItemSTA(req.Id);
             test.stopTest();
         }
    }
    public class MockTokenBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
           String endpoint = req.getEndpoint();
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
           if (endpoint.contains('token'))
            res.setBody('{ "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIxMDhmNWQ4Yy03ZDU5LTQ3ZWUtYWJjNC03MzVlMjE0NjNhMGIiLCJleHAiOjE1NjEyOTQzNjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IkJlYXJlciIsImF6cCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjQ5YTU5YjdlLTY4MjctNDk5ZC05MWI4LTM3ZGUxY2VhNTllZSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIiwiY2xpZW50SWQiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJjbGllbnRIb3N0IjoiMTAxLjUzLjE2NC44IiwicmVhbG0iOiJuaSIsImdpdmVuX25hbWUiOiJFLUNvbSBBY2NvdW50IiwiY2xpZW50QWRkcmVzcyI6IjEwMS41My4xNjQuOCIsImhpZXJhcmNoeVJlZnMiOlsiMTE0NGRmZDktZjUyYS00NGQxLTkwN2QtY2NkM2Y4M2E2MjIyIl19.qA9epI6Nj4IqLBoWiq58SzE3FFmESTtA5ndsA-PuvvtaNcJPhZgLNKVJNnc2ejXuw8Tjb4t6gqAHfGgGFHjxVzqq1kyizFcj7dCxT2IDK2kHL6ziZ-TtmxuFs50N5qFpVcqgtv05QXzWnNbUf_NgHS_rM5F2nO8v9IeKSpmYhA_IQFOfhy1slraR2WJi7muk5Od3yW1FtLa9ldn3S92FscMWM-nS-MHBdq8y6vpTMz9f2Z4AwHCcAOp4jeydFS4S_PkhJDpEiKEdkKpU8FvYCEIQ9SoZsbG4eoBIYRz6NSSvQHjGkmYBA6wg5irZFVJpqubX1C1PPuHGV3NLJNNRQg", "expires_in": 300, "refresh_expires_in": 1800, "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIwZDRkMWQ5OC0xMjRiLTQ2NDUtODMzYi0wYzA1MjE1NjA5YjkiLCJleHAiOjE1NjEyOTU4NjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IlJlZnJlc2giLCJhenAiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI0OWE1OWI3ZS02ODI3LTQ5OWQtOTFiOC0zN2RlMWNlYTU5ZWUiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIn0.eIf5FjbWEE3OBwTJJA0cO96iI5Q1tflioCVhPMoA-xPPs90HGXQp9-CsBIG6PCXTYS6g3zD5hwP48CZ7kQXbyqHYRUzLfV3z3oJfJ95YhBCdcJh4DWBc11eAj2TmHmJ3Ih6zvHYkY4404rvWRAaiIKHFOtAf5sOt0R94nK_uu8MPSNbJJRqRSOnjgGzVI7AdC_nrn2joO4gN9DKu49eCcHH2lndXAW8e3fOeqxWSuNNlkHv1PXajy0v6veIFjjtlz2wRLdWoMU7VCM_kSZ7Qx-JQraqU0os6lefPgRAQUY225bQsR9ELGf8nTxpwRpkZDeE5wYmFwXPv-sS9xOU5aA", "token_type": "bearer", "not-before-policy": 0, "session_state": "49a59b7e-6827-499d-91b8-37de1cea59ee", "scope": ""}');
           else
             res.setBody('{"_id":"urn:order:db882ce9-69a5-47f8-a310-9652bb51ba3b", "_links":{"cnp:payment-link":{"href":"https://api-gateway-uat.ngenius-payments.com/transactions/outlets/d0e91b8f-476d-4a4b-aae7-075755b0159a/orders/db882ce9-69a5-47f8-a310-9652bb51ba3b/payment-link"}, "payment-authorization":{"href":"https://api-gateway-uat.ngenius-payments.com/transactions/paymentAuthorization"}, "self":{"href":"https://api-gateway-uat.ngenius-payments.com/transactions/outlets/d0e91b8f-476d-4a4b-aae7-075755b0159a/orders/db882ce9-69a5-47f8-a310-9652bb51ba3b"}, "tenant-brand":{"href":"http://config-service/config/outlets/d0e91b8f-476d-4a4b-aae7-075755b0159a/configs/tenant-brand"}, "payment":{"href":"https://paypage-uat.ngenius-payments.com/?code=1d1d9b666d1e4d29"}, "merchant-brand":{"href":"http://config-service/config/outlets/d0e91b8f-476d-4a4b-aae7-075755b0159a/configs/merchant-brand"}}, "type":"SINGLE", "merchantDefinedData":{}, "action":"SALE", "amount":{"currencyCode":"AED", "value":200000}, "language":"en", "merchantAttributes":{"skipConfirmationPage":"true", "redirectUrl":"https://pgso-axs.cs31.force.com/grqpyc"}, "emailAddress":"srinivasa.varanasi@gmail.com", "reference":"db882ce9-69a5-47f8-a310-9652bb51ba3b", "outletId":"d0e91b8f-476d-4a4b-aae7-075755b0159a", "createDateTime":"2019-11-21T10:33:09.032Z", "paymentMethods":{"card":["MASTERCARD", "VISA"]}, "referrer":"urn:Ecom:db882ce9-69a5-47f8-a310-9652bb51ba3b", "formattedAmount":"د.إ.‏ 2, 000", "formattedOrderSummary":{}, "_embedded":{"payment":[{"_id":"urn:payment:455ffa00-69de-4121-9331-35cf85d929ab", "_links":{"self":{"href":"https://api-gateway-uat.ngenius-payments.com/transactions/outlets/d0e91b8f-476d-4a4b-aae7-075755b0159a/orders/db882ce9-69a5-47f8-a310-9652bb51ba3b/payments/455ffa00-69de-4121-9331-35cf85d929ab"}, "payment:card":{"href":"https://api-gateway-uat.ngenius-payments.com/transactions/outlets/d0e91b8f-476d-4a4b-aae7-075755b0159a/orders/db882ce9-69a5-47f8-a310-9652bb51ba3b/payments/455ffa00-69de-4121-9331-35cf85d929ab/card"}, "curies":[{"name":"cnp", "href":"https://api-gateway-uat.ngenius-payments.com/docs/rels/{rel}", "templated":true}]}, "state":"STARTED", "amount":{"currencyCode":"AED", "value":200000}, "updateDateTime":"2019-11-21T10:33:09.032Z", "outletId":"d0e91b8f-476d-4a4b-aae7-075755b0159a", "orderReference":"db882ce9-69a5-47f8-a310-9652bb51ba3b"}]}}');
            res.setStatusCode(200);
            system.debug('res-->'+res);
            return res;
        }
    }

}