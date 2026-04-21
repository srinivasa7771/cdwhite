@isTest
public class gwsHTest {
   @testsetup static void setup() {

         testData.init();
        g_srvc_settings__c stg=testData.stgCrt();/*MS*/
        g_Srvc__c s = new g_Srvc__c(Name='Srvc', lbl__c='Srvc', stg__c=stg.Id, uid__c='208',
            actv__c=true, ckgsnc__c=true, Prk__c='Dubai Internet City', AccTp__c='Customer - External',
            ConRol__c='Employee', ConSTA__c='Active', payMd__c='Customer Deposit; Cash; Credit / Debit Card',
            Category__c='Employees Services', Sub_Category__c='Renewal Visa', Milestone_Stage__c='Ep;Medical;Rp;',
            Milestone_SLA__c='10;2;6');
        insert s;

        list<g_srvcitm__c> itms = new list<g_srvcitm__c>();
        itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
            slaXP__c=2, ord__c=1, Tp__c='Service Item',
                cd__c='0np', dcr__c ='Approval from DM:Approval from DM;Catering Service Agreement:Catering Service Agreement;NOC from LandLord:NOC from LandLord;Service Provider License Copy:Service Provider License Copy;Signed Catering Permit Guidelines:Signed Catering Permit Guidelines;',
            Name='rp', lbl__c='rp', Req__c=true, aln__c=true, mxcnt__c=1,
            rv__c=true, prcEdt__c=false, DscApp__c=true, EXP__c=true, KF__c=0,
            scN__c=10, cN__c=5, smN__c=1, spChN__c=1, scXP__c=1, cXP__c=1,
            smXP__c=1, spChXP__c=1, xf__c='xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
        itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
            slaXP__c=2, ord__c=2, Tp__c='Service Item', cd__c='pnt', Name='pnt',
            lbl__c='pnt', Req__c=false, mxcnt__c=1, rv__c=false, prcEdt__c=true,
            DscApp__c=false, EXP__c=false, KF__c=0, scN__c=10, cN__c=5, smN__c=1,
            spChN__c=1, scXP__c=1, cXP__c=1, smXP__c=1, spChXP__c=1, xf__c=''));
        insert itms;

        list<g_srvcitm_Status__c> sta = new list<g_srvcitm_Status__c>();
        for (g_srvcitm__c i:itms) {
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='n', name='n', lbl__c='n', Tp__c='Open', rqSTA__c='',
                clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0, Shift_At__c='Payment',
                Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Completed', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ook', name='ook', lbl__c='ook', Tp__c='Completed',
                rqSTA__c='', clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0,
                Shift_At__c='Payment', Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c = 'Medical',
                slaa__c='Parallel', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='c', name='c', lbl__c='c', Tp__c='Cancelled',
                rqSTA__c='Cancelled', clm__c=true, clmA__c=1, rfnd__c=true, rfndA__c=1,
                Shift_At__c='Payment', Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='RP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ok', name='ok', lbl__c='ok', Tp__c='Completed',
                rqSTA__c='Completed', clm__c=false, clmA__c=0, rfnd__c=false,
                rfndA__c=0, Shift_At__c='Payment', Shift_Items__c='rp;md;', exsyst__c='dcca:Closed;'));
        }
        insert sta;

        Account a=testData.accCrt(false);
        a.ORACLE_PARTY_ID__c = '1234';  a.lc__c='999999';
        update a;

        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c rq=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        rq.rtacn__c = '1234';rq.xoln__c='055372654'; rq.rmob__c='0512341234';
        // rq.xceml__c='a@b.com'; rq.xintp__c = 'SILVER'; rq.xcp__c = 'P98989876';
        update rq;
        loc__c loc = new loc__c();
        loc.acc__c = a.id;
        loc.ls_end__c = date.today().addDays(10);
        loc.ls_std__c = date.today(); loc.isregof__c = true; loc.IsActive__c = true;
        insert loc;
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c limit 1];
        System.debug('<rqItm[0]> : ' + rqItm[0].RQ__r.Id);
        Blob b = Blob.valueOf('Test Data');
        Attachment att = new Attachment();
        att.ParentId = rqItm[0].RQ__r.id;
        att.Name = 'test 2';
        att.Body = b;
        insert att;

        g_reqDoc__c r1 = new g_reqDoc__c();
        r1.Name = 'Approval from DM';
        r1.RQ__c = rqItm[0].RQ__r.id;
        Insert r1;

        Attachment attach=new Attachment();
        attach.Name='Approval from DM.jpg';
        Blob bodyBlob=Blob.valueOf('Unit Test Approval from DM Body');
        attach.body=bodyBlob;
        attach.parentId=r1.id;
        insert attach;

    }
    static testMethod void testbatch() {
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockLicRenewalBatchGen());
        List<ws_call__c> wsList = new List<ws_call__c>();
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c limit 1];
        ws_call__c ws = new ws_call__c();
        ws.intsts__c= 'Ready for Integration';
        ws.mtd_nm__c = 'LicenseRenewalDoc1' ;
        ws.pmid__c ='' ;
        ws.rq_itm__c=rqItm[0].id;
        ws.rq_jsn__c='{"inv":[{"refNo":"85302920190918", "payMethod":"Cash", "invNo":"T2019101937911", "invAmount":"15020.00", "error":null, "dccaSrId":"a1C6F00000SkX8WUAV"}]}';
        ws.ws_typ__c='DccaExtraService';
        wsList.add(ws);
        Insert wsList;

        Test.stopTest();
    }
    static testMethod void testbatch1() {
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockLicRenewalBatchGen1());
        List<ws_call__c> wsList = new List<ws_call__c>();
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c limit 1];
        ws_call__c ws = new ws_call__c();
        ws.intsts__c= 'Ready for Integration';
        ws.mtd_nm__c = 'dccaUpdStatus' ;
        ws.pmid__c ='' ;
        ws.rq_itm__c=rqItm[0].id;
        ws.rq_jsn__c='{"rec":[{"timeStamp":null, "status":null, "regOff":null, "regAdd":{"unitNoArb":null, "unitNo":null, "lsStart":null, "lsEnd":null, "floorArb":null, "floor":null, "businessUnitArb":null, "businessUnit":null, "buildingnameArb":null, "buildingname":null, "aggNo":"AG-144984"}, "refAxs":"85302920190918", "error":null, "dccaReqId":"a1C6F00000SkX8WUAV", "custConf":null, "awbNo":null}]}';
        ws.ws_typ__c='DCCA update status';
        wsList.add(ws);
        Insert wsList;

        Test.stopTest();
    }
    static testMethod void testbatch2() {
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockLicRenewalBatchGen2());
        List<ws_call__c> wsList = new List<ws_call__c>();
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c limit 1];
        ws_call__c ws = new ws_call__c();
        ws.intsts__c= 'Ready for Integration';
        ws.mtd_nm__c = 'dccaUpdStatus' ;
        ws.pmid__c ='' ;
        ws.rq_itm__c=rqItm[0].id;
        ws.rq_jsn__c='{"rec":[{"timeStamp":null, "status":null, "regOff":null, "regAdd":{"unitNoArb":null, "unitNo":null, "lsStart":null, "lsEnd":null, "floorArb":null, "floor":null, "businessUnitArb":null, "businessUnit":null, "buildingnameArb":null, "buildingname":null, "aggNo":"AG-144984"}, "refAxs":"85302920190918", "error":null, "dccaReqId":"a1C6F00000SkX8WUAV", "custConf":null, "awbNo":null}]}';
        ws.ws_typ__c='DCCA License Renewals';
        wsList.add(ws);
        Insert wsList;

        Test.stopTest();
    }
    static testMethod void testbatch3() {
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockLicRenewalBatchGen3());
        List<ws_call__c> wsList = new List<ws_call__c>();
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c limit 1];
        ws_call__c ws = new ws_call__c();
        ws.intsts__c= 'Ready for Integration';
        ws.mtd_nm__c = 'dccaUpdStatus' ;
        ws.pmid__c ='' ;
        ws.rq_itm__c=rqItm[0].id;
        ws.rq_jsn__c='{"san":[{"Status":"open", "description":"RnL- Required Docs", "axsRefNo":"83630420190810"}], "licNo":"93826"}';
        ws.ws_typ__c='DCCA AddRemove Sanction';
        wsList.add(ws);
        Insert wsList;

        Test.stopTest();
    }
    static testMethod void testbatch4() {
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockLicRenewalBatchGen4());
        List<ws_call__c> wsList = new List<ws_call__c>();
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c limit 1];
        ws_call__c ws = new ws_call__c();
        ws.intsts__c= 'Ready for Integration';
        ws.mtd_nm__c = 'dccaApproval' ;
        ws.pmid__c ='' ;
        ws.rq_itm__c=rqItm[0].id;
        ws.rq_jsn__c='{"serviceRequest":[{"service":null, "refAXS":"61865620180414", "locAdd":"Shop No. 01, Floor: 5, Building 2, DSC.", "licenseNo":"93408", "isSucces":null, "isPaid":true, "extAXS":"a0E0I00000gdAqgUAE", "errorMessage":null, "attaFlag":null, "attach":null}]}';
        ws.ws_typ__c='DCCA Letters';
        wsList.add(ws);
        Insert wsList;

        Test.stopTest();
    }
    static testMethod void testbatch5() {
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockLicRenewalBatchGen4());
        List<ws_call__c> wsList = new List<ws_call__c>();
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c limit 1];
        ws_call__c ws = new ws_call__c();
        ws.intsts__c= 'Ready for Integration';
        ws.mtd_nm__c = 'Courier Booking' ;
        ws.pmid__c ='' ;
        ws.rq_itm__c=rqItm[0].id;
        ws.rq_jsn__c='';
        ws.ws_typ__c='Courier Booking';
        ws_call__c ws1 = new ws_call__c();
        ws1.intsts__c= 'Ready for Integration';
        ws1.mtd_nm__c = 'updateCourSta' ;
        ws1.pmid__c ='' ;
        ws1.rq_itm__c=rqItm[0].id;
        ws1.rq_jsn__c='';
        ws1.ws_typ__c='Courier Service';
        wsList.add(ws1);
        ws_call__c ws2 = new ws_call__c();
        ws2.intsts__c= 'Ready for Integration';
        ws2.mtd_nm__c = 'updateStatus' ;
        ws2.pmid__c ='' ;
        ws2.rq_itm__c=rqItm[0].id;
        ws2.rq_jsn__c='';
        ws2.ws_typ__c='Onboarding';
        wsList.add(ws2);
        ws_call__c ws3 = new ws_call__c();
        ws3.intsts__c= 'Ready for Integration';
        ws3.mtd_nm__c = 'fetchAccInfo' ;
        ws3.pmid__c ='' ;
        ws3.rq_itm__c=rqItm[0].id;
        ws3.rq_jsn__c='';
        ws3.ws_typ__c='Onboarding';
        wsList.add(ws3);
        ws_call__c ws4 = new ws_call__c();
        ws4.intsts__c= 'Ready for Integration';
        ws4.mtd_nm__c = 'uploadDoc' ;
        ws4.pmid__c ='' ;
        ws4.rq_itm__c=rqItm[0].id;
        ws4.rq_jsn__c='';
        ws4.ws_typ__c='Onboarding';
        wsList.add(ws4);
        ws_call__c ws5 = new ws_call__c();
        ws5.intsts__c= 'Ready for Integration';
        ws5.mtd_nm__c = 'DDANewInvoice' ;
        ws5.pmid__c ='' ;
        ws5.rq_itm__c=rqItm[0].id;
        ws5.rq_jsn__c='';
        ws5.ws_typ__c='Onboarding';
        wsList.add(ws5);
        ws_call__c ws6 = new ws_call__c();
        ws6.intsts__c= 'Ready for Integration';
        ws6.mtd_nm__c = 'YardiInvoice' ;
        ws6.pmid__c ='' ;
        ws6.rq_itm__c=rqItm[0].id;
        ws6.rq_jsn__c='';
        ws6.ws_typ__c='Onboarding';
        wsList.add(ws6);

              ws_call__c ws7 = new ws_call__c();
        ws7.intsts__c= 'Ready for Integration';
        ws7.mtd_nm__c = 'BankAccUpdate' ;
        ws7.pmid__c ='' ;
        ws7.rq_itm__c=rqItm[0].id;
        ws7.rq_jsn__c='';
        ws7.ws_typ__c='CreateBankFu';
        wsList.add(ws7);

         ws_call__c ws8 = new ws_call__c();
        ws8.intsts__c= 'Ready for Integration';
        ws8.mtd_nm__c = 'BankAccUpdate' ;
        ws8.pmid__c ='' ;
        ws8.rq_itm__c=rqItm[0].id;
        ws8.rq_jsn__c='';
        ws8.ws_typ__c='YardiCreateBankFu';
        wsList.add(ws8);

 ws_call__c ws18 = new ws_call__c();
        ws18.intsts__c= 'Ready for Integration';
        ws18.mtd_nm__c = 'BankAccUpdate' ;
        ws18.pmid__c ='' ;
        ws18.rq_itm__c=rqItm[0].id;
        ws18.rq_jsn__c='';
        ws18.ws_typ__c='YardiCreateBankFu';
        wsList.add(ws18);

 ws_call__c ws9 = new ws_call__c();
        ws9.intsts__c= 'Ready for Integration';
        ws9.mtd_nm__c = 'BankAccUpdate' ;
        ws9.pmid__c ='' ;
        ws9.rq_itm__c=rqItm[0].id;
        ws9.rq_jsn__c='';
        ws9.ws_typ__c='YardiCreateBankAttFu';
        wsList.add(ws9);

ws_call__c ws12 = new ws_call__c();
        ws12.intsts__c= 'Ready for Integration';
        ws12.mtd_nm__c = 'AppFeeInvoice' ;
        ws12.pmid__c ='' ;
        ws12.rq_itm__c=rqItm[0].id;
        ws12.rq_jsn__c='';
        ws9.ws_typ__c='Onboarding';
        wsList.add(ws12);

        ws_call__c ws10 = new ws_call__c();
        ws10.intsts__c= 'Ready for Integration';
        ws10.mtd_nm__c = 'CreateRequest' ;
        ws10.pmid__c ='' ;
        ws10.rq_itm__c=rqItm[0].id;
        ws10.rq_jsn__c='';
        ws10.ws_typ__c='Fitout';
        wsList.add(ws10);

ws_call__c ws11 = new ws_call__c();
        ws11.intsts__c= 'Ready for Integration';
        ws11.mtd_nm__c = 'UploadDocs' ;
        ws11.pmid__c ='' ;
        ws11.rq_itm__c=rqItm[0].id;
        ws11.rq_jsn__c='';
        ws11.ws_typ__c='Fitout';
        wsList.add(ws11);
        Insert wsList;

        Test.stopTest();
    }
    public class MockLicRenewalBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"inv":[{"refNo":"85302920190918", "payMethod":"Cash", "invNo":"T2019101937911", "invAmount":"15020.00", "error":null, "dccaSrId":"a1C6F00000SkX8WUAV"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockLicRenewalBatchGen1 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"rec":[{"timeStamp":null, "status":"License Under Review", "regOff":null, "regAdd":{"unitNoArb":"202", "unitNo":"202", "lsStart":"2019-11-03", "lsEnd":"2020-11-02", "floorArb":"02", "floor":"02", "businessUnitArb":"مدينة دبي للإستديوهات", "businessUnit":"Dubai Studio City", "buildingnameArb":"بوتيك استديو رقم 17", "buildingname":"Boutique Studio No. 17", "aggNo":"AG-144984"}, "refAxs":"85302920190918", "error":null, "dccaReqId":"a1C6F00000SkX8WUAV", "CustConf":null, "awbNo":null}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockLicRenewalBatchGen2 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"AttachmentList":[{"parentId":null, "Name":null, "messagecode":"0", "message":"Attcahment Successfully Created", "attachmentBody":null}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockLicRenewalBatchGen3 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"AttachmentList":[{"parentId":null, "Name":null, "messagecode":"0", "message":"Attcahment Successfully Created", "attachmentBody":null}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockLicRenewalBatchGen4 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"serviceRequest":[{"service":"a156F000006ui51QAA", "refAxs":"61865620180414", "locAdd":"Shop No. 01, Floor: 5, Building 2, DSC.", "licenseNo":"93408", "isSucces":true, "isPaid":true, "extAxs":"a0E0I00000gdAqgUAE", "errorMessage":null, "attaFlag":null, "attach":null}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}