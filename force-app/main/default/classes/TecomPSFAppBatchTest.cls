@isTest(SeeAllData=false)
public class TecomPSFAppBatchTest {
  @testSetup static void setup() {
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
        rq.xadtx3__c = '{"ResponseData":{"AgNo":"AG-141074", "Source":"TBP", "Success":true, "Error":"", "ResponseCode":"0"}}';
        // rq.xceml__c='a@b.com'; rq.xintp__c = 'SILVER'; rq.xcp__c = 'P98989876';
        update rq;
         list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c limit 1];
       g_reqDoc__c r1 = new g_reqDoc__c();
        r1.Name = 'Approval from DM';
        r1.RQ__c = rq.id;
        Insert r1;
        List<Attachment> attList = new List<Attachment>();
        Attachment attach=new Attachment();
        attach.Name='Approval from DM.jpg';
        Blob bodyBlob=Blob.valueOf('Unit Test Approval from DM Body');
        attach.body=bodyBlob;
        attach.parentId=r1.id;
        attList.add(attach);
      Attachment attach1=new Attachment();
        attach1.Name='Approval from DM1.jpg';
        bodyBlob=Blob.valueOf('Unit Test Approval from DM Body1');
        attach1.body=bodyBlob;
        attach1.parentId=r1.id;
        attList.add(attach1);
        insert attList;

    }

    static testMethod void testbatchCreationInvoice() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockLicRenewalBatchGen());
        Map<id, g_Req__c> rqMp = new Map<id, g_Req__c>();
        g_Req__c rq = [select id, name, xadtx3__c from g_Req__c limit 1];
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id from g_reqitem__c limit 1];
        rqMp.put(rqItm[0].id, rq);
        list<g_Tran__c> tItm =[Select id, name, RQ__r.name from g_Tran__c limit 1];
        grqWsPSFApproval.createPSFAppCall(rqItm, rqMp, 'TECOMCALL', 'PSFApp');
          TecomPSFAppBatch obj = new TecomPSFAppBatch();
        DataBase.executeBatch(obj, 5);
        Test.stopTest();
    }

    static testMethod void tesFailuretbatch() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockFailureBatchGen());
         List<ws_call__c> wsList = new List<ws_call__c>();
        ws_call__c ws = new ws_call__c();
        ws.intsts__c= 'Ready for Integration';
        ws.rq_jsn__c='{"AXSInvNo":"T2019031705780", "AgNo":"AG-141074"}';
        ws.ws_typ__c='TECOMCALL';
        wsList.add(ws);
        insert wsList;
        TecomPSFAppBatch obj = new TecomPSFAppBatch();
        DataBase.executeBatch(obj, 5);

        Test.stopTest();
    }

    public class MockLicRenewalBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"ReqNo":"", "AgNumber":"", "Attachment1Link":"", "Attachment2Link":"", "errormsg":"", "errorcode":"0"}');
            res.setStatusCode(200);
            return res;
        }
    }
    public class MockFailureBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"ReqNo":"", "AgNumber":"", "Attachment1Link":"", "Attachment2Link":"", "errormsg":"", "errorcode":"1"}');
            res.setStatusCode(400);
            return res;
        }
    }
}