@isTest(SeeAllData=false)
public class dccaStatusUpdBatchTest {

  /*  @testSetup static void setup() {
        testData.init();

        g_srvc_settings__c stg=testData.stgCrt();
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

        List<ws_call__c> wsList = new List<ws_call__c>();

        ws_call__c ws = new ws_call__c();
        ws.intsts__c= 'Ready for Integration';
        ws.mtd_nm__c = 'dccaUpdStatus' ;
        ws.pmid__c ='' ;
        ws.rq_itm__c=rqItm[0].id;
        ws.rq_jsn__c='{"rec":[{"status":null, "refAxs":"43184420180520", "error":null}]}';
        ws.ws_typ__c='DCCA update status';
        wsList.add(ws);

        ws_call__c ws1 = new ws_call__c();
        ws1.intsts__c= 'Ready for Integration';
        ws1.mtd_nm__c = 'dccaApproval' ;
        ws1.pmid__c ='' ;
        ws1.rq_itm__c=rqItm[0].id;
        ws1.rq_jsn__c='{"rec":[{"status":null, "refAxs":"43184420180520", "error":null}]}';
        ws1.ws_typ__c='DCCA update status';
        wsList.add(ws1);

        Insert wsList;
    }*/

    static testMethod void testbatch() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockInsBatchGen());
          testData.init();

        g_srvc_settings__c stg=testData.stgCrt();
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

        List<ws_call__c> wsList = new List<ws_call__c>();

        ws_call__c ws = new ws_call__c();
        ws.intsts__c= 'Ready for Integration';
        ws.mtd_nm__c = 'dccaUpdStatus' ;
        ws.pmid__c ='' ;
        ws.rq_itm__c=rqItm[0].id;
        ws.rq_jsn__c='{"rec":[{"timeStamp":null, "status":null, "regOff":null, "regAdd":{"unitNoArb":null, "unitNo":null, "lsStart":null, "lsEnd":null, "floorArb":null, "floor":null, "businessUnitArb":null, "businessUnit":null, "buildingnameArb":null, "buildingname":null, "aggNo":"AG-145569"}, "refAxs":"86321420191008", "error":null, "dccaReqId":"a1C6F00000ToGz3UAF", "custConf":null, "awbNo":null}]}';
        ws.ws_typ__c='DCCA AddRemove Sanction1';
        wsList.add(ws);

        ws_call__c ws1 = new ws_call__c();
        ws1.intsts__c= 'Ready for Integration';
        ws1.mtd_nm__c = 'dccaUpdStatus' ;
        ws1.pmid__c ='' ;
        ws1.rq_itm__c=rqItm[0].id;
       ws1.rq_jsn__c='{"AttachmentList":[{"Name":"Approval from DM", "attachmentBody":"test"}]}';
        ws1.ws_typ__c='DCCA License Renewals1';
        wsList.add(ws1);

        Insert wsList;
        List<ws_call__c> wsListUpdate = [select id, intsts__c from ws_call__c WHERE ws_typ__c In('DCCA AddRemove Sanction1')];
         for (ws_call__c wsupdate : wsListUpdate) {
             wsupdate.intsts__c = 'Ready for Integration';
             wsupdate.ws_typ__c='DCCA update status';
         }
         update wsListUpdate;
        try{
        dccaStatusUpdBatch obj = new dccaStatusUpdBatch();
        DataBase.executeBatch(obj, 5);
        grqWsDcca gr = new grqWsDcca();
        }catch (Exception ex) {}
        Test.stopTest();
    }

  /*  static testMethod void testFailure() {
        Test.startTest();
        //Failure
        Test.setMock(HttpCalloutMock.class, new MockInsBatchGenError());
        dccaStatusUpdBatch obj = new dccaStatusUpdBatch();
        grqWsExtStatusUpd gr = new grqWsExtStatusUpd();

        DataBase.executeBatch(obj, 5);
        Test.stopTest();
    }

    static testMethod void testExc() {
        Test.startTest();
        //Callout Exception
        try{
            Test.setMock(HttpCalloutMock.class, new MockGenExc());
            dccaStatusUpdBatch obj = new dccaStatusUpdBatch();
            DataBase.executeBatch(obj, 5);
        }Catch(Exception e) {}
        Test.stopTest();
    }*/

    public class MockInsBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"rec":[{"status":"Closed", "refAxs":"43184420180520", "error":"Error"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockInsBatchGenError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"rec":[{"status":"Closed", "refAxs":"43184420180520", "error":null}]}');
            res.setStatusCode(200);
            return res;
        }
    }

  /*  static testMethod void testFailbatch() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockGenExc());
        dccaStatusUpdBatch obj = new dccaStatusUpdBatch();
        DataBase.executeBatch(obj, 5);
        grqWsDcca gr = new grqWsDcca();

        Test.stopTest();
    }*/

    public class MockGenFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"serviceRequest":[{"service":"a156F000006ui51QAA", "refAxs":"43084220180408", "locAdd":"R/C22-Outdoor Seating, Bldg 10, Ground 0, Dubai Media City", "licenseNo":"30849", "isSucces":false, "isPaid":true, "extAxs":"a0EN000000FBKmzMAH", "errorMessage":null, "attaFlag":null, "attach":null}]}');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockGenExc implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            throw new CalloutException();

        }
    }

}